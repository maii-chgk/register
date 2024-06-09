class Person < ApplicationRecord
  after_update :maybe_change_discourse_group_membership
  after_destroy :remove_from_suspended_discourse_group
  after_destroy :remove_from_active_discourse_group

  has_paper_trail

  MISSED_ASSEMBLIES_LIMIT = 3

  rails_admin do
    include_fields :name, :cyrillic_name, :email, :discourse_username, :accepted, :suspended, :newsletter,
      :start_date, :end_date
    exclude_fields :created_at, :updated_at, :id

    label "Человек"
    label_plural "Люди"

    configure :name do
      label "Имя"
    end

    configure :cyrillic_name do
      label "Имя кириллицей"
    end

    configure :start_date do
      label "Дата вступления"
    end

    configure :end_date do
      label "Дата выхода"
    end

    configure :accepted do
      label "Принят(а)"
    end

    configure :newsletter do
      label "Рассылка"
    end

    configure :discourse_username do
      label "Юзернейм на форуме"
    end

    configure :suspended do
      label "Приостановлен(а)"
    end
  end

  def self.members_count
    Person
      .where(accepted: true)
      .where("end_date is null or end_date > current_date")
      .where(suspended: [false, nil])
      .count
  end

  def self.suspended_count
    Person
      .where(accepted: true)
      .where("end_date is null or end_date > current_date")
      .where(suspended: true)
      .count
  end

  def self.count_toward_quorum
    count_toward_quorum_on(Date.today)
  end

  def self.count_toward_quorum_on(date)
    Person.all
      .count { |person| person.counts_toward_quorum_on?(date) }
  end

  def counts_toward_quorum?
    counts_toward_quorum_on?(Date.today) && !suspended
  end

  def counts_toward_quorum_on?(date)
    return false unless active_on?(date)
    return false if suspended && date == Date.today

    assemblies_that_could_attend = Assembly
      .where("start_date >= ?", start_date)
      .where("end_date < ?", date)
      .order(:end_date)
      .pluck(:end_date)
    return true if assemblies_that_could_attend.size < MISSED_ASSEMBLIES_LIMIT

    participations = fetch_participations(date)
    return true if participations.present? && streak_of_misses_start_date(participations).nil?

    had_electronic_vote_between?(assemblies_that_could_attend[-MISSED_ASSEMBLIES_LIMIT], date)
  end

  def fetch_participations(date)
    query = <<~SQL
      select distinct a.start_date as date, v.assembly_id
      from assemblies a 
      left join votes v
        on a.id = v.assembly_id 
      where a.start_date <= $1 and v.person_id = $2 and v.assembly_id is not null
      order by a.start_date
    SQL

    ActiveRecord::Base.connection.exec_query(query, "", [date, id]).to_a
  end

  def active?
    active_on?(Date.today) && !suspended
  end

  def active_on?(date)
    started_after?(date) && not_ended_before?(date)
  end

  def started_after?(date)
    start_date.present? && (start_date == date || start_date.before?(date))
  end

  def not_ended_before?(date)
    end_date.blank? || end_date.after?(date)
  end

  def streak_of_misses_start_date(participations)
    misses_count = 0
    participations.each do |participation|
      date, participation_id = participation[:date], participation[:id]
      if participation_id
        misses_count = 0
      else
        misses_count += 1
      end
      return date if misses_count == MISSED_ASSEMBLIES_LIMIT
    end
    nil
  end

  def had_electronic_vote_between?(first_date, second_date)
    Vote.where(["date between ? and ?", first_date, second_date])
      .where(person_id: id)
      .where("voting_session_id is not null or assembly_id is not null")
      .size > 0
  end

  def maybe_change_discourse_group_membership
    if saved_change_to_accepted?
      if active?
        add_to_active_discourse_group
      else
        remove_from_active_discourse_group
      end
    end

    if saved_change_to_suspended?
      if suspended
        add_to_suspended_discourse_group
        remove_from_active_discourse_group
      else
        remove_from_suspended_discourse_group
        add_to_active_discourse_group
      end
    end
  end

  def add_to_active_discourse_group
    discourse_client.add_to_group(Discourse::Client::MAIN_GROUP_ID, self)
  end

  def remove_from_active_discourse_group
    discourse_client.remove_from_group(Discourse::Client::MAIN_GROUP_ID, self)
  end

  def add_to_suspended_discourse_group
    discourse_client.add_to_group(Discourse::Client::SUSPENDED_GROUP_ID, self)
  end

  def remove_from_suspended_discourse_group
    discourse_client.remove_from_group(Discourse::Client::SUSPENDED_GROUP_ID, self)
  end

  def discourse_client
    Discourse::Client.new
  end
end

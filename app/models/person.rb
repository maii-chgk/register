class Person < ApplicationRecord
  has_many :assemblies

  after_update :maybe_change_membership
  after_destroy :unset_discourse_role

  has_paper_trail

  MISSED_ASSEMBLIES_LIMIT = 3

  rails_admin do
    include_fields :name, :cyrillic_name, :email, :accepted, :newsletter, :start_date, :end_date
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
  end

  def self.members_count
    Person
      .where(accepted: true)
      .where("end_date is null or end_date > current_date")
      .count
  end

  def self.count_toward_quorum
    count_toward_quorum_on(Date.today)
  end

  def self.count_toward_quorum_on(date)
    Person.all
      .filter { |person| person.counts_toward_quorum_on?(date) }
      .size
  end

  def counts_toward_quorum?
    counts_toward_quorum_on?(Date.today)
  end

  def counts_toward_quorum_on?(date)
    return false unless active_on?(date)

    assemblies_that_could_attend = Vote.assemblies_between(start_date, date)
    return true if assemblies_that_could_attend.size < MISSED_ASSEMBLIES_LIMIT

    attended_assemblies = attended_assemblies_before(date)
    attendance = assemblies_that_could_attend.map do |assembly_date|
      [assembly_date, attended_assemblies.include?(assembly_date)]
    end.sort

    return true if miss_streak_start_date(attendance).nil?

    had_electronic_vote_between?(miss_streak_start_date(attendance), date)
  end

  def active?
    active_on?(Date.today)
  end

  def active_on?(date)
    (end_date.blank? || end_date.after?(date)) && !(start_date.blank? || date.before?(start_date))
  end

  private

  def miss_streak_start_date(list)
    misses_count = 0
    list.each do |key, value|
      if value
        misses_count = 0
      else
        misses_count += 1
      end
      return key if misses_count == MISSED_ASSEMBLIES_LIMIT
    end
    nil
  end

  def had_electronic_vote_between?(first_date, second_date)
    Vote.where(["date between ? and ?", first_date, second_date])
      .where(person_id: id)
      .electronic
      .size > 0
  end

  def maybe_change_membership
    return unless saved_change_to_accepted?

    if active?
      set_discourse_role
    else
      unset_discourse_role
    end
  end

  def attended_assemblies_before(date)
    Vote.assembly
      .where(["date between ? and ?", start_date, date])
      .where(person_id: id)
      .select(:date)
      .distinct
      .pluck(:date)
  end

  def set_discourse_role
    Discourse::Client.add_to_group(email, Discourse::Client::MAIN_GROUP)
  end

  def unset_discourse_role
    Discourse::Client.remove_from_group(email, Discourse::Client::MAIN_GROUP)
  end
end

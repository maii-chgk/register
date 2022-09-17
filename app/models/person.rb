class Person < ApplicationRecord
  has_many :assemblies

  after_update :maybe_change_membership
  after_destroy :unset_discourse_role

  has_paper_trail

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
    Person.all.filter(&:counts_toward_quorum?).size
  end

  def counts_toward_quorum?
    active? && !missed_three_assemblies
  end

  def active?
    active_on?(Date.today)
  end

  def active_on?(date)
    (end_date.blank? || end_date.after?(date)) && !(start_date.blank? || date.before?(start_date))
  end

  private

  def maybe_change_membership
    return unless saved_change_to_accepted?

    if active?
      set_discourse_role
      AcceptanceConfirmationMailer::send_confirmation(email)
    else
      unset_discourse_role
    end
  end

  def missed_three_assemblies
    could_attend = Assembly
                     .where(["date >= ?", start_date])
                     .select(:date).distinct
    return false if could_attend.size < 3

    attended = Assembly
                 .three_most_recent
                 .where(["date >= ?", start_date])
                 .where(person_id: id)
    attended.size.zero?
  end

  def set_discourse_role
    Discourse::Client.add_to_group(email, Discourse::Client::MAIN_GROUP)
  end

  def unset_discourse_role
    Discourse::Client.remove_from_group(email, Discourse::Client::MAIN_GROUP)
  end
end

class Person < ApplicationRecord
  has_and_belongs_to_many :assemblies, Proc.new { distinct }

  after_update :maybe_change_membership
  after_destroy :unset_discourse_role

  has_paper_trail

  rails_admin do
    include_fields :name, :cyrillic_name, :email, :verified, :newsletter, :start_date, :end_date
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

    configure :verified do
      label "Верификация"
    end

    configure :newsletter do
      label "Рассылка"
    end
  end

  private

  def maybe_change_membership
    return unless saved_change_to_verified?

    if active?
      set_discourse_role
      AcceptanceConfirmationMailer::send_confirmation(email)
    else
      unset_discourse_role
    end
  end

  def active?
    verified && (end_date.blank? || end_date.after?(Date.today))
  end

  def set_discourse_role
    Discourse::Client.add_to_group(email, Discourse::Client::MAIN_GROUP)
  end

  def unset_discourse_role
    Discourse::Client.remove_from_group(email, Discourse::Client::MAIN_GROUP)
  end
end

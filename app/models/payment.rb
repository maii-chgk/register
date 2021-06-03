class Payment < ApplicationRecord
  belongs_to :person

  rails_admin do
    exclude_fields :created_at, :updated_at, :id

    label "Платёж"
    label_plural "Платежи"
  end
end

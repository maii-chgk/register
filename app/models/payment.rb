class Payment < ApplicationRecord
  has_paper_trail

  enum method: {
    cash: 0,
    website: 1
  }

  rails_admin do
    exclude_fields :created_at, :updated_at, :id

    label "Платёж"
    label_plural "Платежи"

    configure :date do
      label "Дата"
    end

    configure :name do
      label "Имя"
    end

    configure :currency do
      label "Валюта"
    end

    configure :amount do
      label "Сумма"
    end

    configure :method do
      label "Способ"
    end
  end
end

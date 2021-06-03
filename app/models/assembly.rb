class Assembly < ApplicationRecord
  has_and_belongs_to_many :people

  has_paper_trail
end

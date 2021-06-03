class Person < ApplicationRecord
  has_and_belongs_to_many :assemblies

  has_paper_trail
end

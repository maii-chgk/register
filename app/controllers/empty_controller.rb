class EmptyController < ApplicationController
  def index
    count = Person.where(accepted: true, end_date: nil).count
    render inline: "В МАИИ #{count} членов."
  end
end


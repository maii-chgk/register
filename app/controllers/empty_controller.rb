class EmptyController < ApplicationController
  def index
    count = Person.where(accepted: true).count
    render inline: "В МАИИ #{count} членов."
  end
end


class EmptyController < ApplicationController
  def index
    count = Person.members_count
    render inline: "В МАИИ #{count} членов."
  end
end


class EmptyController < ApplicationController
  def index
    count = Person.members_count
    quorum_count = Person.count_toward_quorum
    render inline: "В МАИИ #{count} членов. Для кворума ОС учитываются #{quorum_count}. Кворум — #{quorum_count / 4}. Кворум для изменения устава — #{quorum_count / 2}."
  end
end


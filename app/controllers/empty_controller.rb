class EmptyController < ApplicationController
  def index
    count = Person.members_count
    quorum_count = Person.count_toward_quorum
    quorum = (Float(quorum_count) / 4).ceil
    statute_quorum = (Float(quorum_count) / 2).ceil
    render inline: "В МАИИ #{count} членов. Для кворума ОС учитываются #{quorum_count}. Кворум — #{quorum}. Кворум для изменения устава — #{statute_quorum}."
  end
end

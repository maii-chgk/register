class PeopleController < ApplicationController
  skip_forgery_protection

  def formspark_webhook
    permitted = params.permit(:email, :name, "name-lat", :join, :newsletter)

    Person.new(
      email: permitted[:email],
      name: permitted["name-lat"],
      cyrillic_name: permitted[:name],
      accepted: false,
      newsletter: subscribe_to_newsletter?
    ).save
  end

  private

  def subscribe_to_newsletter?
    params[:subscribe] == "Да"
  end
end

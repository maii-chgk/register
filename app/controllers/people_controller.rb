class PeopleController < ApplicationController
  skip_forgery_protection

  def formspark_webhook
    permitted = params.permit(:email, :name, "name-lat", :join, :newsletter)

    Person.new(
      email: permitted[:email],
      name: permitted["name-lat"],
      cyrillic_name: permitted[:name],
      verified: false,
      newsletter: subscribe_to_newsletter?
    ).save
  end

  private

  def subscribe_to_newsletter?
    if params[:newsletter].present?
      return true if params[:newsletter] == "Да"
    end

    return true if params[:join] == %w[Да Да]

    false
  end
end

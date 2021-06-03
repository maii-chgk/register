class EmptyController < ApplicationController
  def index
    render inline: "Hello"
  end
end


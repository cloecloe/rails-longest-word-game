require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # Display a new random grid and a form.
    @letters = ('A'..'Z').to_a.sample(10)
    # The form will be submitted (with POST) to the score action.
  end

  def score
    @word = params['search'].downcase
    @letters = params["letters"].downcase

    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    html_serialized = open(url).read
    api_lewagon = JSON.parse(html_serialized)

    @display = ''

    in_grid = @word.chars.all? do |char|
      @word.count(char) <= @letters.count(char)
    end

    if in_grid == false
      @display = "Sorry but '#{@word}'' can not be built out of '#{@letters.upcase}'"
    elsif api_lewagon["found"] == false
      @display = "Sorry but '#{@word}' does not seem to be a valid English word..."
    else
      @display = "CONGRATULATIONS '#{@word}' is a valid English word!"
    end
  end
end

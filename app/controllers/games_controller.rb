class GamesController < ApplicationController
require 'open-uri'
require 'json'

  def new
    @letters = generate_grid(9)
    @start_time = Time.now
  end

  def score
    end_time = Time.now
    time_total = end_time - Time.parse(params[:start])
    @answer = params[:answer]
    grid = params[:liste].split('')

    return @score = "Sorry but #{@answer} is not an english word" if english_word?(@answer) == false
    return @score = "Your attempt is not in the grid" if in_grid?(@answer, grid) == false
    result = scoring(@answer, time_total)
    @score = "well done, your score is #{result}" #, score: scoring(@answer, time_p), time: time_p }
  end

  def generate_grid(grid_size)
  # TODO: generate random grid of letters
    Array.new(grid_size) { ('a'..'z').to_a.sample }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = URI(url).read
    JSON.parse(user_serialized)['found']
  end

  def in_grid?(word, grid)
    word.upcase.split('').all? { |element| word.count(element) <= grid.count(element) }
  end

  def scoring(word, time)
    ((word.size / time).to_f * 100).round(2)
  end

end

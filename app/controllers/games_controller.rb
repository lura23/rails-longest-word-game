require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a[rand(0..25)] }
  end

  def score
    @word = params[:answer]
    @test_letters = params[:letters]
    if @word.nil?
      @result = 'Please enter a word.'
    else
      @score = 0
      results
    end
  end

  private

  def belongs_to_grid?
    split_letters = @test_letters.split(//)
    split_answer = @word.upcase.split(//)
    split_answer.all? { |letter| split_letters.include?(letter) }
  end

  def english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    info = JSON.parse(open(url).read)
    true if info['found'] == true
  end

  def results
    if belongs_to_grid? != true
      @result = 'Your word contains invalid letters.'
    elsif english_word? != true
      @result = 'Your word is not a valid English word.'
    else
      @result = 'Congratulations, your word is valid.'
      points = @word.length
      @score += points
    end
  end
end

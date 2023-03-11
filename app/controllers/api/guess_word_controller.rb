class Api::GuessWordController < ApplicationController
	before_action :authenticate_user, only: [:create, :progress]

	def index 
		limit = filter_params[:Limit].to_i
		offset = filter_params[:Offset].to_i
		items = GuessWord.where.not(Status: 'Playing').order(Score: :desc).offset(offset).limit(limit)
		count = GuessWord.where.not(Status: 'Playing').count
		render json: { Items: items, Count: count, Offset: offset, Limit: limit }, include: [:user,:word], status: :ok
	end

	def progress
		guess_words = []
		if @current_user
			guess_words = GuessWord.where(Status: 'Playing', user_id: @current_user.id)
		end
		render json: guess_words, include: [:word,:guesses], status: :ok
	end

	def show 
		guess_word = GuessWord.find(params[:id])
		render json: guess_word, include: [:user, :word, :guesses => {:include => [:ratings]}], status: :ok
	end

	def create 
		guess_word = GuessWord.new({
			word_id: params[:WordId],
			user_id: @current_user ? @current_user.id : nil
		})
		if guess_word.save
			render json: guess_word, status: :ok
		else
			render json: { errors: guess_word.errors.full_messages }, status: 503
		end
	end

	def guess 
		Rails.logger.info guess_params
		guess_word_guess = GuessWordGuess.new({
			guess_word_id: guess_params[:guess_word_id],
			Guess: guess_params[:Guess]
		})
		if guess_word_guess.save
			green = []
			brown = []
			gray = []
			word = guess_params[:Word].split('')
			guess = guess_params[:Guess].split('')
			guess.each_with_index do | letter, idx |
				if letter == word[idx]
					green.push(idx)
					word[idx] = ''
				end
			end
			guess.each_with_index do | letter, idx |
				next if green.include?(idx)
				if word.include?(letter)
					brown.push(idx)
				else
					gray.push(idx)
				end
			end
			guess.each_index do | idx |
				rating = 'Gray'
				if green.include?(idx)
					rating = 'Green'
				elsif brown.include?(idx)
					rating = 'Brown'
				end
				GuessWordGuessRating.create({
					guess_word_guess_id: guess_word_guess.id,
					Rating: rating
				})
			end
			status = guess_word_status(guess_params[:guess_word_id], green.length, word.length)
			if status != 'Playing'
				score = guess_word_score(guess_params[:guess_word_id], word.length)
				GuessWord.update(guess_params[:guess_word_id], Score: score, Status: status)
			end
			render json: guess_word_guess, include: [:ratings], status: :ok
		else
			render json: { errors: guess_word_guess.errors.full_messages }, status: 503
		end

	end

	def hint 
		green = hint_params[:Green]
		gray = hint_params[:Gray]
		# strong params does not play nice
		brown = params[:Brown]
		hints = []
		words = Word.where(Length: hint_params[:Length])
		words.each do | record |
			word = record.Word
			next if !match_green(word,green)
			next if match_gray(word,gray,green)
			next if match_brown(word,brown)
			next if !include_brown(word,brown)
			hints.push(word)
		end
		render json: hints, status: :ok
	end

	private

	def match_green(word, green)
		return true if no_green(green)
		letters = word.dup.split('')
		green.each_with_index do | letter, idx |
			return false if letter != '' && letter != letters[idx]
		end
		return true
	end

	def match_gray(word, gray, green)
		flat_green = green.dup.flatten
		allgray = gray.dup - flat_green
		letters = word.dup.split('')
		allgray.each do | letter |
			return true if letters.include?(letter)
		end
		return false
	end

	def match_brown(word,brown)
		return false if no_brown(brown)
		letters = word.dup.split('')
		letters.each_with_index do | letter, idx |
			return true if brown[idx].length && brown[idx].include?(letter)
		end
		return false
	end

	def include_brown(word,brown)
		letters = word.dup.split('')
		flat_brown = brown.dup.flatten
		flat_brown.each do | letter |
			return false if !letters.include?(letter)
		end
		return true
	end

	def no_green(green)
		green.each do | letter |
			return false if letter != ''
		end
		true
	end

	def no_brown(brown)
		brown.each_index do | idx |
			return false if brown[idx].length
		end
		return true
	end

	def guess_word_status(id, greenLength, wordLength)
		status = 'Playing'
		count = GuessWordGuess.where(guess_word_id: id).count
		if greenLength == wordLength
			status = 'Won'
		elsif count >= ((wordLength.to_f * 3) / 2).ceil()
			status = 'Lost'
		end
		status
	end

	def guess_word_score(id, wordLength)
		perGreen = 10
		perBrown = 5
		maxGuesses = ((wordLength.to_f * 3) / 2).ceil()
		perGuess = wordLength * perGreen
		score = perGuess * maxGuesses
		guesses = GuessWordGuess.includes(:ratings).where(guess_word_id: id)
		guesses.each do | guess |
			score -= perGuess
			guess.ratings.each do | rating |
				if rating.Rating == 'Green'
					score += perGreen
				elsif rating.Rating == 'Brown'
					score += perBrown
				end
			end
		end
		score
	end

	def guess_params
		params.permit(:Word, :Guess, :guess_word_id, :guess_word => {})
	end

	def hint_params 
		params.permit(:Length, :Green => [], :Gray => [], :Brown => [[]], :guess_word => {})
	end

	def filter_params
		params.permit(:Offset,:Limit)
	end
end

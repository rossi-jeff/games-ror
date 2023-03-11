class Api::CodeBreakerController < ApplicationController
	before_action :authenticate_user, only: [:create, :progress]

	def index
		limit = filter_params[:Limit].to_i
		offset = filter_params[:Offset].to_i
		items = CodeBreaker.where.not(Status: 'Playing').includes(:user).order(Score: :desc).offset(offset).limit(limit)
		count = CodeBreaker.where.not(Status: 'Playing').count
		render json: { Items: items, Count: count, Offset: offset, Limit: limit }, include: [:user], status: :ok
	end

	def progress
		code_breakers = []
		if @current_user
			code_breakers = CodeBreaker.where(Status: 'Playing', user_id: @current_user.id)
		end
		render json: code_breakers, status: :ok
	end

	def show
		code_breaker = CodeBreaker.find(params[:id])
		render json: code_breaker, include: [:guesses => {:include => [:colors, :keys]}, :codes => [], :user => {}], status: :ok
	end

	def create
		colors = code_breaker_params[:Colors]
		code_breaker = CodeBreaker.new({
			Columns: code_breaker_params[:Columns],
			Colors: colors.size,
			user_id: @current_user ? @current_user.id : nil
		})
		if code_breaker.save
			code_breaker.Columns.times do
				CodeBreakerCode.create({
					code_breaker_id: code_breaker.id,
					Color: colors.sample
				})
			end
			render json: code_breaker, include: [:codes], status: :ok
		else
			render json: { errors: code_breaker.errors.full_messages }, status: 503
		end
	end

	def guess
		code_breaker_guess = CodeBreakerGuess.new({
			code_breaker_id: guess_params[:code_breaker_id]
		})
		if code_breaker_guess.save
			guess_params[:Colors].each do |color|
				CodeBreakerGuessColor.create({
					code_breaker_guess_id: code_breaker_guess.id,
					Color: color
				})
			end
			codes = get_codes(guess_params[:code_breaker_id])
			keys = calculate_keys(codes,guess_params[:Colors])
			keys.each do | key |
				CodeBreakerGuessKey.create({
					code_breaker_guess_id: code_breaker_guess.id,
					Key: key
				})
			end
			update_code_breaker_status(guess_params[:code_breaker_id],keys)
			render json: code_breaker_guess, include: [:colors,:keys], status: :ok
		else
			render json: { errors: code_breaker.errors.full_messages }, status: 503
		end
	end

	private

	def update_code_breaker_status(id,keys)
		code_breaker = CodeBreaker.find(id)
		guess_count = CodeBreakerGuess.where(code_breaker_id: id).count
		allBlack = true
		keys.each do | key |
			if key == 'White'
				allBlack = false
			end
		end
		score = calculate_code_breaker_score(id)
		if keys.size == code_breaker.Columns && allBlack
			CodeBreaker.update(id, :Status => 'Won', :Score => score)
		elsif guess_count >= 2 * code_breaker.Columns
			CodeBreaker.update(id, :Status => 'Lost', :Score => score)
		end
	end

	def calculate_code_breaker_score(id)
		code_breaker = CodeBreaker.includes(guesses: [:keys]).find(id)
		return 0 if code_breaker == nil
		perColumn = 10
		perColor = 10
		perBlack = 10
		perWhite = 5
		colorBonus = perColor * code_breaker.Colors
		perGuess = perColumn * code_breaker.Columns;
		maxGuesses = code_breaker.Columns * 2;
		score = (maxGuesses * perGuess) + colorBonus;
		code_breaker.guesses.each do | guess |
			score -= perGuess
			guess.keys.each do | key |
				score += key.Key == 'Black' ? perBlack : perWhite
			end
		end
		score
	end

	def get_codes(id)
		results = CodeBreakerCode.where(code_breaker_id: id).select(:Color)
		codes = results.map {|x| x.Color }
	end

	def calculate_keys(codes,colors)
		keys = []
		black = []
		codes.each_with_index do | color, idx |
			if colors[idx] == color
				black.push(idx)
				keys.push('Black')
			end
		end
		black.reverse.each do |idx|
			codes.delete_at(idx)
			colors.delete_at(idx)
		end
		colors.each do | color |
			idx = codes.index(color)
			if idx != nil
				codes.delete_at(idx)
				keys.push('White')
			end
		end
		keys
	end

	def filter_params
		params.permit(:Offset,:Limit)
	end

	def code_breaker_params
		params.require(:code_breaker).permit([:Colors => []], :Columns)
	end

	def guess_params
		params.permit(:code_breaker_id, [:Colors => []], :code_breaker => [:Colors => []])
	end
end

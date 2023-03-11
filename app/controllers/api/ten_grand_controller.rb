class Api::TenGrandController < ApplicationController
	before_action :authenticate_user, only: [:create, :progress]

	def index
		limit = filter_params[:Limit].to_i
		offset = filter_params[:Offset].to_i
		items = TenGrand.where.not(Status: 'Playing').includes(:user).order(Score: :desc).offset(offset).limit(limit)
		count = TenGrand.where.not(Status: 'Playing').count
		render json: { Items: items, Count: count, Offset: offset, Limit: limit }, include: [:user], status: :ok
	end

	def progress
		ten_grands = []
		if @current_user
			ten_grands = TenGrand.where(Status: 'Playing', user_id: @current_user.id)
		end
		render json: ten_grands, status: :ok
	end

	def show
		ten_grand = TenGrand.find(params[:id])
		render json: ten_grand, include: [:user, :turns => {:include => [:scores]}], status: :ok
	end

	def create 
		ten_grand = TenGrand.new({
			user_id: @current_user ? @current_user.id : nil
		})
		if ten_grand.save
				render json: ten_grand, status: :ok
		else
				render json: { errors: ten_grand.errors.full_messages }, status: 503
		end
	end

	def options 
		options = get_ten_grand_options(options_params[:Dice])
		render json: { Dice: options_params[:Dice], Options: options }, status: :ok
	end

	def roll 
		dice = []
		while dice.length < roll_params[:Quantity]
			dice.push(roll_die())
		end
		render json: dice, status: :ok
	end

	def score 
		Rails.logger.info score_params
		if score_params[:TurnId] > 0
			turn = TenGrandTurn.find(score_params[:TurnId])
		else
			turn = TenGrandTurn.create({
				ten_grand_id: score_params[:ten_grand_id]
			})
		end
		if turn
			dice = score_params[:Dice]
			options = score_params[:Options]
			options.sort! { |a,b| TenGrandScore::DICE_REQUIRED[b[:Category]] <=> TenGrandScore::DICE_REQUIRED[a[:Category]] }
			options.each do | option |
				Rails.logger.info option[:Category]
				score, used = get_score_and_used(option[:Category],dice)
				used.each do | face |
					idx = dice.index(face)
					if idx != nil
						dice.delete_at(idx)
					end 
				end
				TenGrandScore.create({
					ten_grand_turn_id: turn.id,
					Category: option[:Category],
					Score: score,
					Dice: used.join(',')
				})
			end
			update_ten_grand_turn_score(turn.id)
			update_ten_grand_score(score_params[:ten_grand_id])
			render json: turn, include: [:scores], status: :ok
		else
			render json: { errors: "Unable to Find or Create Turn" }, status: 500
		end
	end

	private

	def update_ten_grand_turn_score(id)
		score = 0
		ten_grand_scores = TenGrandScore.where(ten_grand_turn_id: id)
		crap_out = false
		ten_grand_scores.each do | tgs |
			score += tgs.Score
			crap_out = true if tgs.Category == 'CrapOut'
		end
		score = 0 if crap_out
		TenGrandTurn.update(id, Score: score)
	end

	def update_ten_grand_score(id)
		score = 0
		turns = TenGrandTurn.where(ten_grand_id: id)
		turns.each do | turn |
			score += turn.Score
		end
		status = score >= 10000 ? 'Won' : 'Playing'
		TenGrand.update(id, Score: score, Status: status)
	end

	def roll_die
		face = rand(1..6)
	end

	def count_faces(dice)
			faces = {}
			dice.each do | face |
					faces[face] = 0 if !faces[face] 
					faces[face] += 1
			end
			faces
	end

	def dice_ones(dice)
		used = []
		dice.each do | face |
			used.push(face) if face == 1
		end
		used
	end

	def dice_fives(dice)
		used = []
		dice.each do | face |
			used.push(face) if face == 5
		end
		used
	end

	def dice_full_house(dice)
		used = []
		faces = count_faces(dice)
		values = faces.values
		if values.include?(3) && values.include?(2)
			faces.keys.each do | key |
				if faces[key] == 3 || faces[key] == 2
					faces[key].times do
						used.push(key.to_i)
					end
				end
			end
		end
		used
	end

	def dice_straight(dice)
		used = []
		sorted = dice.sort
		if sorted.join(',') == '1,2,3,4,5,6'
			used = dice.dup
		end
		used
	end

	def dice_three_pair(dice)
		used = []
		faces = count_faces(dice)
		values = faces.values
		if values.join(',') == '2,2,2'
			used = dice.dup
		end
		used
	end

	def dice_three_kind(dice)
		used = []
		faces = count_faces(dice)
		faces.keys.each do | key |
			if faces[key] == 3
				3.times do
					used.push(key.to_i) 
				end
			end
		end
		used
	end

	def dice_four_kind(dice)
		used = []
		faces = count_faces(dice)
		faces.keys.each do | key |
			if faces[key] == 4
				4.times do
					used.push(key.to_i) 
				end
			end
		end
		used
	end

	def dice_five_kind(dice)
		used = []
		faces = count_faces(dice)
		faces.keys.each do | key |
			if faces[key] == 5
				5.times do
					used.push(key.to_i) 
				end
			end
		end
		used
	end

	def dice_six_kind(dice)
		used = []
		faces = count_faces(dice)
		faces.keys.each do | key |
			if faces[key] == 6
				6.times do
					used.push(key.to_i) 
				end
			end
		end
		used
	end

	def dice_double_three_kind(dice)
		used = []
		faces = count_faces(dice)
		values = faces.values
		if values.join(',') == '3,3'
			used = dice.dup
		end
		used
	end

	def score_ones(dice)
		score = 0
		dice.each do | face |
			score += 100 if face == 1
		end
		score
	end

	def score_fives(dice)
		score = 0
		dice.each do | face |
			score += 50 if face == 5
		end
		score
	end

	def score_full_house(dice)
			faces = count_faces(dice)
			values = faces.values
			score = values.include?(3) && values.include?(2) ? 1500 : 0
	end

	def score_straight(dice)
			sorted = dice.sort
			score = sorted.join(',') == '1,2,3,4,5,6' ? 2000 : 0
	end

	def score_three_pair(dice)
		faces = count_faces(dice)
		values = faces.values
		score = values.join(',') == '2,2,2' ? 1500 : 0
	end

	def score_three_kind(dice)
		score = 0
		faces = count_faces(dice)
		faces.keys.each do | key |
			if faces[key] == 3
				if key == 1
					score += 1000
				else
					score += key.to_i * 100
				end
			end
		end
		score
	end

	def score_four_kind(dice)
		score = 0
		faces = count_faces(dice)
		faces.keys.each do | key |
			if faces[key] == 4
				if key == 1
					score += 2000
				else
					score += key.to_i * 200
				end
			end
		end
		score
	end

	def score_five_kind(dice)
		score = 0
		faces = count_faces(dice)
		faces.keys.each do | key |
			if faces[key] == 5
				if key == 1
					score += 4000
				else
					score += key.to_i * 400
				end
			end
		end
		score
	end

	def score_six_kind(dice)
		score = 0
		faces = count_faces(dice)
		faces.keys.each do | key |
			if faces[key] == 6
				if key == 1
					score += 8000
				else
					score += key.to_i * 800
				end
			end
		end
		score
	end

	def score_double_three_kind(dice)
		score = 0
		faces = count_faces(dice)
		values = faces.values
		if values.join(',') == '3,3'
			faces.keys.each do | key |
				score += score_three_kind([key.to_i, key.to_i, key.to_i])
			end
			score = score * 2
		end
		score
	end

	def score_category(category,dice)
		score = 0
		case category
		when 'Ones'
			score = score_ones(dice)
		when 'Fives'
			score = score_fives(dice)
		when 'ThreePairs'
			score = score_three_pair(dice)
		when 'Straight'
			score = score_straight(dice)
		when 'FullHouse'
			score = score_full_house(dice)
		when 'DoubleThreeKind'
			score = score_double_three_kind(dice)
		when 'ThreeKind'
			score = score_three_kind(dice)
		when 'FourKind'
			score = score_four_kind(dice)
		when 'FiveKind'
			score = score_five_kind(dice)
		when 'SixKind'
			score = score_six_kind(dice)
		end
		score
	end

	def get_score_and_used(category,dice)
		score = 0
		used = []
		case category
		when 'Ones'
			score = score_ones(dice)
			used = dice_ones(dice)
		when 'Fives'
			score = score_fives(dice)
			used = dice_fives(dice)
		when 'ThreePairs'
			score = score_three_pair(dice)
			used = dice_three_pair(dice)
		when 'Straight'
			score = score_straight(dice)
			used = dice_straight(dice)
		when 'FullHouse'
			score = score_full_house(dice)
			used = dice_full_house(dice)
		when 'DoubleThreeKind'
			score = score_double_three_kind(dice)
			used = dice_double_three_kind(dice)
		when 'ThreeKind'
			score = score_three_kind(dice)
			used = dice_three_kind(dice)
		when 'FourKind'
			score = score_four_kind(dice)
			used = dice_four_kind(dice)
		when 'FiveKind'
			score = score_five_kind(dice)
			used = dice_five_kind(dice)
		when 'SixKind'
			score = score_six_kind(dice)
			used = dice_six_kind(dice)
		when 'CrapOut'
			used = dice.dup
		end
		return score, used
	end

	def get_ten_grand_options(dice)
		options = []
		TenGrandScore.Categories.each do | category |
			score = score_category(category[0],dice)
			if score > 0 || category[0] == 'CrapOut'
				options.push({ Category: category[0], Score: score })
			end
		end
		options.sort { |a,b| b[:Score] <=> a[:Score] }
	end

	def roll_params
		params.permit(:ten_grand_id, :Quantity, :ten_grand => {})
	end

	def options_params
		params.permit([:Dice => []], :ten_grand => {})
	end

	def score_params 
		params.permit([:Dice => []], [:Options => [:Category,:Score]], :ten_grand_id, :TurnId, :ten_grand => {})
	end

	def filter_params
		params.permit(:Offset,:Limit)
	end
end

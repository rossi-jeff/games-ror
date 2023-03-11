class Api::YachtController < ApplicationController
	before_action :authenticate_user, only: [:create, :progress]

    def index
        limit = filter_params[:Limit].to_i
				offset = filter_params[:Offset].to_i
				items = Yacht.includes(:user).where(NumTurns: 12).order(Total: :desc).offset(offset).limit(limit)
				count = Yacht.where(NumTurns: 12).count
				render json: { Items: items, Count: count, Offset: offset, Limit: limit }, include: [:user], status: :ok
    end

		def progress
			yachts = []
			if @current_user
				yachts = Yacht.where('NumTurns < 12 and user_id = ?', @current_user.id)
			end
			render json: yachts, status: :ok
		end

    def show
        Rails.logger.info params
        yacht = Yacht.find(params[:id])
        render json: yacht, include: [:user, :turns], status: :ok
    end

    def create
        yacht = Yacht.new({
					user_id: @current_user ? @current_user.id : nil
				})
        if yacht.save
            render json: yacht, status: :ok
        else
            render json: { errors: yacht.errors.full_messages }, status: 503
        end
    end

    def roll
        Rails.logger.info roll_params
        dice = []
        roll_params[:Keep].each do | face |
            dice.push(face)
        end
        while dice.length < 5
            dice.push(roll_die())
        end
        lastTurn = YachtTurn.where(yacht_id: roll_params[:yacht_id].to_i, Category: nil).order(id: :desc).limit(1)[0]
        if lastTurn && lastTurn.RollThree == ''
            if lastTurn.RollTwo != ''
                turn = YachtTurn.update(lastTurn.id, :RollThree => dice.join(','))
            else
                turn = YachtTurn.update(lastTurn.id, :RollTwo => dice.join(','))
            end
        else
            turn = YachtTurn.create({
                yacht_id: roll_params[:yacht_id].to_i,
                RollOne: dice.join(',')
            })
        end
        options = scoring_options(roll_params[:yacht_id].to_i,dice)
        render json: { Turn: turn, Options: options }, status: :ok
    end

    def score
        turn = YachtTurn.find(score_params[:TurnId])
        dice = []
        if turn && turn.RollThree != ''
            dice = turn.RollThree.split(',').map {|x| x.to_i }
        elsif turn && turn.RollTwo != ''
            dice = turn.RollTwo.split(',').map {|x| x.to_i }
        elsif turn && turn.RollOne != ''
            dice = turn.RollOne.split(',').map {|x| x.to_i }
        end
        score = category_score(score_params[:Category],dice)
        turn = YachtTurn.update(turn.id, :Score => score, :Category => score_params[:Category])
        update_yacht_total(score_params[:yacht_id].to_i)
        render json: turn, status: :ok
    end

    private

    def roll_die
       face = rand(1..6)
    end

    def skip_categories(id)
        results = YachtTurn.where(yacht_id: id).where.not(Category: nil).select(:Category)
        skip = results.map {|x| x.Category }
    end

    def score_number(dice,num)
        score = 0
        dice.each do | face |
            score += face if face == num
        end
        score
    end

    def score_choice(dice)
        score = 0
        dice.each do | face |
            score += face
        end
        score
    end

    def count_faces(dice)
        faces = {}
        dice.each do | face |
            faces[face] = 0 if !faces[face] 
            faces[face] += 1
        end
        faces
    end

    def score_little_straight(dice)
        sorted = dice.sort
        score = sorted.join(',') == '1,2,3,4,5' ? 30 : 0
    end

    def score_big_straight(dice)
        sorted = dice.sort
        score = sorted.join(',') == '2,3,4,5,6' ? 30 : 0
    end

    def score_four_kind(dice)
        faces = count_faces(dice)
        score = 0
        faces.keys.each do | key |
            if faces[key] == 4
                score = 4 * key
            end
        end
        score
    end

    def score_full_house(dice)
        faces = count_faces(dice)
        values = faces.values
        score = values.include?(3) && values.include?(2) ? 25 : 0
    end

    def score_yacht(dice)
        faces = count_faces(dice)
        values = faces.values
        score = values.include?(5) ? 25 : 0
    end

    def scoring_options(id,dice)
        skip = skip_categories(id)
        options = []
        YachtTurn.Categories.each do |category|
            next if skip.include?(category[0])
            option = {
                Category: category[0],
                Score: category_score(category[0],dice)
            }
            options.push(option)
        end
        options.sort { |a,b| b[:Score] <=> a[:Score] }
    end

    def category_score(category,dice)
        score = 0
        case category
        when 'Ones'
            score = score_number(dice,1)
        when 'Twos'
            score = score_number(dice,2)
        when 'Threes'
            score = score_number(dice,3)
        when 'Fours'
            score = score_number(dice,4)
        when 'Fives'
            score = score_number(dice,5)
        when 'Sixes'
            score = score_number(dice,6)
        when 'Choice'
            score = score_choice(dice)
        when 'BigStraight'
            score = score_big_straight(dice)
        when 'LittleStraight'
            score = score_little_straight(dice)
        when 'FourOfKind'
            score = score_four_kind(dice)
        when 'FullHouse'
            score = score_full_house(dice)
        when 'Yacht'
            score = score_yacht(dice)
        else
            score = 0
        end
        score
    end

    def update_yacht_total(id)
        turns = YachtTurn.where(yacht_id: id)
        score = 0
				count = 0
        turns.each do | turn |
            score += turn.Score
						count += 1
        end
        Yacht.update(id, :Total => score, NumTurns: count)
    end

    def roll_params
        params.permit(:yacht_id, [:Keep => []], :yacht => {})
    end

    def score_params
        params.permit(:TurnId, :Category, :yacht_id, :yacht => {})
    end

		def filter_params
			params.permit(:Offset,:Limit)
		end
end

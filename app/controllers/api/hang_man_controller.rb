class Api::HangManController < ApplicationController
	before_action :authenticate_user, only: [:create, :progress]

    def index 
        limit = filter_params[:Limit].to_i
        offset = filter_params[:Offset].to_i
        items = HangMan.where.not(Status: 'Playing').order(Score: :desc).offset(offset).limit(limit)
        count = HangMan.where.not(Status: 'Playing').count
        render json: { Items: items, Count: count, Offset: offset, Limit: limit }, include: [:user,:word], status: :ok
    end

    def progress
        hang_men = []
        if @current_user
            hang_men = HangMan.where(Status: 'Playing', user_id: @current_user.id)
        end
        render json: hang_men, include: [:word], status: :ok
    end

    def show
        hang_man = HangMan.find(params[:id])
        render json: hang_man, include: [:word,:user], status: :ok
    end

    def create
			hang_man = HangMan.new({
					word_id: params[:WordId],
					user_id: @current_user ? @current_user.id : nil
			})
			if hang_man.save
				render json: hang_man, status: :ok
			else
				render json: { errors: hang_man.errors.full_messages }, status: 503
			end
    end

    def guess
        hang_man = HangMan.find(guess_params[:hang_man_id])
        if hang_man
            correct = hang_man.Correct.split(',')
            wrong = hang_man.Wrong.split(',')
            found = false 
            word = guess_params[:Word]
            letter = guess_params[:Letter]
            if word.include?(letter)
                correct.push(letter)
                found = true
            else
                wrong.push(letter)
            end
            status = hang_man_status(word, correct, wrong)
            score = hang_man_score(word, correct, wrong)
            HangMan.update(
                guess_params[:hang_man_id], 
                Correct: correct.join(','), 
                Wrong: wrong.join(','),
                Status: status,
                Score: score
            )
            render json: { Letter: letter, Found: found }, status: :ok
        else
            render json: { errors: hang_man.errors.full_messages }, status: 503
        end
    end

    private

    def hang_man_status(word, correct, wrong)
        letters = word.split('').uniq
        missed = letters.filter { |l| !correct.include?(l) }
        return 'Won' if missed.length == 0
        return 'Lost' if wrong.length >= 6
        'Playing'
    end

    def hang_man_score(word, correct, wrong)
        status = hang_man_status(word, correct, wrong)
        letters = word.split('').uniq
        perLetter = 10
        perCorrect = 5
        score = status == 'Won' ? letters.length * perLetter : 0
        score += correct.length * perCorrect
        score -= wrong.length * perLetter
        score
    end

    def guess_params
        params.permit(:Word, :Letter, :hang_man_id, :hang_man => {})
    end

    def filter_params
			params.permit(:Offset,:Limit)
		end
end

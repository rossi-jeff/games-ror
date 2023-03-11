class Api::ConcentrationController < ApplicationController
	before_action :authenticate_user, only: [:create]

    def index
      limit = filter_params[:Limit].to_i
			offset = filter_params[:Offset].to_i
			items = Concentration.where.not(Status: 'Playing').includes(:user).order(Moves: :desc).offset(offset).limit(limit)
			count = Concentration.where.not(Status: 'Playing').count
			render json: { Items: items, Count: count, Offset: offset, Limit: limit }, status: :ok
    end

    def show
        concentration = Concentration.find(params[:id])
        render json: concentration, status: :ok
    end

    def create 
        concentration = Concentration.new({
					user_id: @current_user ? @current_user.id : nil
				})
        if concentration.save
            render json: concentration, status: :ok
        else
            render json: { errors: concentration.errors.full_messages }, status: 503
        end
    end

    def update
        concentration = Concentration.update(
            update_params[:id],
            Moves: update_params[:Moves],
            Elapsed: update_params[:Elapsed],
            Matched: update_params[:Matched],
            Status: update_params[:Status]
        )
        render json: concentration, status: :ok
    end

    private

    def update_params
        params.permit(:id, :Status, :Moves, :Matched, :Elapsed, :concentration => {})
    end

    def filter_params
			params.permit(:Offset,:Limit)
		end
end

class Api::FreeCellController < ApplicationController
	before_action :authenticate_user, only: [:create]

    def index
      limit = filter_params[:Limit].to_i
			offset = filter_params[:Offset].to_i
			items = FreeCell.where.not(Status: 'Playing').includes(:user).order(Moves: :desc).offset(offset).limit(limit)
			count = FreeCell.where.not(Status: 'Playing').count
			render json: { Items: items, Count: count, Offset: offset, Limit: limit }, include: [:user], status: :ok
    end

    def show
        free_cell = FreeCell.find(params[:id])
        render json: free_cell, status: :ok
    end

    def create
        free_cell = FreeCell.new({
					user_id: @current_user ? @current_user.id : nil
				})
        if free_cell.save
            render json: free_cell, status: :ok
        else
            render json: { errors: free_cell.errors.full_messages }, status: 503
        end
    end

    def update
        free_cell = FreeCell.update(
            update_params[:id],
            Moves: update_params[:Moves],
            Elapsed: update_params[:Elapsed],
            Status: update_params[:Status]
        )
        render json: free_cell, status: :ok
    end

    private

    def update_params
        params.permit(:id, :Status, :Moves, :Elapsed, :free_cell => {})
    end

    def filter_params
			params.permit(:Offset,:Limit)
		end
end

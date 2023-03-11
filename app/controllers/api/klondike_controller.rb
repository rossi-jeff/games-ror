class Api::KlondikeController < ApplicationController
	before_action :authenticate_user, only: [:create]

    def index
      limit = filter_params[:Limit].to_i
			offset = filter_params[:Offset].to_i
			items = Klondike.where.not(Status: 'Playing').includes(:user).order(Moves: :desc).offset(offset).limit(limit)
			count = Klondike.where.not(Status: 'Playing').count
			render json: { Items: items, Count: count, Offset: offset, Limit: limit }, include: [:user], status: :ok
    end

    def show
        klondike = Klondike.find(params[:id])
        render json: klondike, status: :ok
    end

    def create
        klondike = Klondike.new({
					user_id: @current_user ? @current_user.id : nil
				})
        if klondike.save
            render json: klondike, status: :ok
        else
            render json: { errors: klondike.errors.full_messages }, status: 503
        end
    end

    def update
        klondike = Klondike.update(
            update_params[:id],
            Moves: update_params[:Moves],
            Elapsed: update_params[:Elapsed],
            Status: update_params[:Status]
        )
        render json: klondike, status: :ok
    end

    private

    def update_params
        params.permit(:id, :Status, :Moves, :Elapsed, :klondike => {})
    end

    def filter_params
			params.permit(:Offset,:Limit)
		end
end

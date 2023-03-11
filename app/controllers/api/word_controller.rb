class Api::WordController < ApplicationController
	
	def show
		word = Word.find(params[:id])
		render json: word, status: :ok
	end

	def random
		if random_params[:Length] 
			conds = ['Length = ?', random_params[:Length]]
		elsif random_params[:Min] && random_params[:Max]
			conds = ['Length >= ? and Length <= ?',random_params[:Min],random_params[:Max]]
		elsif random_params[:Max]
			conds = ['Length <= ?',random_params[:Max]]
		elsif random_params[:Min]
			conds = ['Length >= ?',random_params[:Min]]
		else
			conds = []
		end
		word = Word.where(conds).order('RAND()').limit(1).first
		render json: word, status: :ok
	end

	private 

	def random_params
		params.permit(:Length, :Min, :Max, :word => {})
	end
end

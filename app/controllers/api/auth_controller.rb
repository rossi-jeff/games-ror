class Api::AuthController < ApplicationController
	include JwtToken

	def register
		@user = User.new(auth_params)
		if @user.save
			render json: @user, status: 201
		else
			render json: { errors: @user.errors.full_messages }, status: 503
		end
	end

	def login
		@user = User.find_by_UserName(auth_params[:UserName])
		if @user&.authenticate(auth_params[:password])
			token = JwtToken.jwt_encode({ user_id: @user.id })
			render json: { Token: token, UserName: @user.UserName }, status: :ok
		else
			render json: { error: 'unauthorized' }, status: :unauthorized
		end
	end

	private

	def auth_params
		params.require(:auth).permit(:UserName,:password)
	end
end

class ApplicationController < ActionController::API
	include JwtToken

	private

	def auth_header
		request.headers['Authorization']
	end

	def authenticate_user
		@current_user = nil
		return unless auth_header
		token = auth_header.split(' ').last
		decoded = JwtToken.jwt_decode(token)
		@current_user = User.find(decoded[:user_id])
	end
end

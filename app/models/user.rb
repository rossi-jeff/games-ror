class User < ApplicationRecord
	has_secure_password
    
	validates :UserName, presence: true, uniqueness: true
	validates :password, presence: true

	def as_json(options={}) 
		{
			:id => self.id,
			:UserName => self.UserName,
			:created_at => self.created_at,
			:updated_at => self.updated_at
		}
	end
end

class User < ActiveRecord::Base
	has_many :tracelog, dependent: :destroy
	validates :account, presence: true, length: {minimum: 3}
end

class User < ActiveRecord::Base
	has_many :tracelog, dependent: :destroy
	validates :account, presence: true, length: {minimum: 3}
	validates :password, presence: true
	validates :coin, numericality: {only_integer:true, greater_than: 0}
	validates :level, presence: true, numericality: { only_integer: true }
end

class User < ActiveRecord::Base
	validates :account, presence: true, length: {minimum: 3}, uniqueness: true
	validates :password, presence: true
	validates :coin, numericality: {only_integer:true, greater_than: 0}
	validates :level, presence: true, numericality: { only_integer: true }, on: :create
end

class User < ActiveRecord::Base
	apply_simple_captcha
	
	validates :account, presence: true, length: {minimum: 3}, uniqueness: true
	validates :password, presence: true
	validates :coin, numericality: {only_integer:true, greater_than: 0}
	validates :level, presence: true, numericality: { only_integer: true }, on: :create
	validates :upperlimit, presence: true, numericality: { only_integer: true }, on: :create
	validates :lowerlimit, presence: true, numericality: { only_integer: true }, on: :create
end

class Post < ActiveRecord::Base
	acts_as_taggable

	belongs_to :user
	default_scope -> { order('created_at DESC') }
	validates :user_id, presence: true
	validates :title, presence: true, length: {maximum: 70}
	validates :content, presence: true

end
class Micropost < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user
  
  validates_presence_of :content, :user_id
  validates_length_of :content, :maximum => 140
  
  default_scope :order => 'created_at DESC'
end

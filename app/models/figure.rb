class Figure <ActiveRecord::Base
  has_many :landmarks
  has_many :title_figures
  has_many :titles, through: :title_figures
end

class Title <ActiveRecord::Base
  has_many :title_figures
  has_many :figures, through: :title_figures
end

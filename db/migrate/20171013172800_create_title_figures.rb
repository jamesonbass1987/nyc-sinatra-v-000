class CreateTitleFigures < ActiveRecord::Migration
  def change
    create_table :title_figures do |t|
      t.integer :title_id
      t.integer :figure_id
    end
  end
end

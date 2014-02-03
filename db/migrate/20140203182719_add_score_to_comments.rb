class AddScoreToComments < ActiveRecord::Migration
  def change
    add_column :comments, :score, :float
  end
end

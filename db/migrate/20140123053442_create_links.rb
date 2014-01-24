class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.text :link_url
      t.text :title

      t.timestamps
    end
  end
end

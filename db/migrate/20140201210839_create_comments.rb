class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :text
      t.references :user, index: true
      t.references :link, index: true

      t.timestamps
    end
  end
end

class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :idea, index: true
      t.string :text
      t.integer :upvotes
      t.integer :downvotes
      t.timestamps
    end
  end
end

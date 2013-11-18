class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :idea, index: true
      t.string :text
      t.integer :upvotes, :null => false, :default => 0
      t.integer :downvotes, :null => false, :default => 0
      t.timestamps
    end
  end
end

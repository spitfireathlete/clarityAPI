class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.references :user, index: true
      t.references :project, index: true
      t.string :text
      t.integer :upvotes, :null => false, :default => 0
      t.integer :downvotes, :null => false, :default => 0
      t.timestamps
    end
  end
end

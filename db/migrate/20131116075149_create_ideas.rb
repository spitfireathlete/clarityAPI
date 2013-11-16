class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.references :user, index: true
      t.references :project, index: true
      t.string :text
      t.integer :upvotes
      t.integer :downvotes
      t.timestamps
    end
  end
end

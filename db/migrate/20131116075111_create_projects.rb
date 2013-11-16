class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :topic
      t.string :details
      t.references :user, index: true
      t.references :priority, index: true
      t.timestamps
    end
  end
end

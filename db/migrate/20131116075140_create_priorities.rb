class CreatePriorities < ActiveRecord::Migration
  def change
    create_table :priorities do |t|
      t.string :salesforce_id,      :null => false, :default => ""
      t.string :name
      t.timestamps
    end
    
    add_index :priorities, :salesforce_id, :unique => true
  end
end

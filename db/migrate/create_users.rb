class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :retweets, :force => true do |t|
      t.integer :id
      t.string  :name
      t.timestamps
    end
  end
  
  def self.down
    drop_table :retweets
    
  end
end
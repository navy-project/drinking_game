class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :user
      t.string :user_id
      t.string :user_image
      t.string :text
      t.string :tweet_id

      t.timestamps
    end
  end
end

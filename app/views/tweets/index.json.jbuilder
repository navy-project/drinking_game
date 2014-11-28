json.array!(@tweets) do |tweet|
  json.extract! tweet, :id, :user, :user_id, :user_image, :text
  json.url tweet_url(tweet, format: :json)
end

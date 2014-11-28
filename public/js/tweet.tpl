<div className="tweet row">
  <div className="user col-md-2">
    <a href="https://twitter.com/{{user_id}}"><img src="{{user_image}}"/></a>
  </div>
  <div className="col-md-10">
    <div className="text">
      <h2><a href="https://twitter.com/{{user_id}}">{{user}}</a></h2>
      <p>{{text}}</p>
    </div>
    <div className="time">
      <a href="https://twitter.com/{{user_id}}/status/{{tweet_id}}">{{created_at}}</a>
    </div>
  </div>
</div>

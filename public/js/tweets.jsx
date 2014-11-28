var ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

var Tweet = React.createClass({
  render: function() {
    return (
<div className="tweet row">
  <div className="user col-md-2">
    <a href={"https://twitter.com/" + this.props.user_id}><img src={this.props.user_image}/></a>
  </div>
  <div className="col-md-10">
    <div className="text">
      <h2><a href={"https://twitter.com/" + this.props.user_id}>{this.props.user}</a></h2>
      <p>{this.props.text}</p>
    </div>
    <div className="time">
      <a href={"https://twitter.com/" + this.props.user_id + "/status/" + this.props.id}>{this.props.created_at}</a>
    </div>
  </div>
</div>
      );
  }
});

var TweetList = React.createClass({
  getInitialState: function() {
    return {tweets: []};
  },
  componentDidMount: function() {
    var faye = new Faye.Client('http://test-game-dev.lvh.me:9292/faye');
    var _this = this;
    faye.subscribe('/tweets/new', function (data) {
      _this.add(data);
    });

  },
  add: function(tweet) {
    var newTweets = this.state.tweets;
    newTweets.unshift(tweet)
    this.setState({tweets: newTweets})
  },
  render: function() {
    var tweets = this.state.tweets.map(function(tweet, i) {
      return React.createElement(Tweet, tweet)
    });

    return (
      <ReactCSSTransitionGroup transitionName="example">
        {tweets}
      </ReactCSSTransitionGroup>
    );
  }
});

React.render(
    <TweetList />,
    $(".incoming").get(0)
    );

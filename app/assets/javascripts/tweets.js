//Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.
$(function() {
  var source   = $("#tweet_tpl").html();
  var template = Handlebars.compile(source);
  var faye_server = $("meta[name='faye-server']").attr("content");
  console.log("Connecting To Faye: ", faye_server);
  var targets = ["cloud", "paas", "saas", "devops", "microservice"];

  var faye = new Faye.Client(faye_server + '/faye/');

  var matchData = function(data) {
    var newMessage = data.text + ""
    for (var t=0; t < targets.length; t++) {
      var target = targets[t];
      var regEx = new RegExp(target, "ig");
      var replace = "<span class='match'>" + target + "</span>"
      newMessage = newMessage.replace(regEx, replace);
    }

    if (newMessage != data.text) {
      console.log("Matched Something", newMessage);
      data.text = newMessage;
      return {"data":data, "didMatch":true};
    } else {
      return {"data":data, "didMatch":false};
    }
  }

  faye.subscribe('/tweets/new', function (data) {
    var match = matchData(data)
    var tweet = $(template(match.data));
    tweet.hide()
    $(".tweets").prepend(tweet);
    tweet.slideDown();
    if (match.didMatch) {
      var arrow = $("<div class='arrow'></div>");
      arrow.hide();
      $(".tweets").prepend(arrow);
      arrow.slideDown();
    }
  });

});

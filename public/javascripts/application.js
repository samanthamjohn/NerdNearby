$(function() {
  $("#map_canvas").hide();
    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-23507228-1']);
    _gaq.push(['_trackPageview']);
    FB.init({
      appId  : '203906409650922',
      status : true, // check login status
      cookie : true, // enable cookies to allow the server to access the session
      xfbml  : true  // parse XFBML
    });

    (function() {
      var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();

  var mapCanvas = $("#map_canvas");
  var getFeedResults = function(position, google) {
    var lat = position.coords.latitude;
    var lng = position.coords.longitude;

    var latlng = new google.maps.LatLng(lat,lng);
    var myOptions = {
      zoom: 14,
      center: latlng,
      disableDefaultUI: true,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    $.get('feed_items', { lat: lat, lng: lng }, function(response) {
        $(".feed-items").html(response);

        $("#map_canvas").show();
        var map = new google.maps.Map($("#map_canvas").get(0), myOptions);

        var marker = new google.maps.Marker({
          position: latlng,
          map: map,
          title: "You are here"
        });
      });
  };

  var position = {
    coords : {
      latitude : mapCanvas.data("lat"),
      longitude : mapCanvas.data("lng")
    }
  };
  if(position.coords.latitude && position.coords.longitude) {
    getFeedResults(position, google);
  }
  else {
    navigator.geolocation.getCurrentPosition(function(position){
      getFeedResults(position, google);
    });
  }
      
})

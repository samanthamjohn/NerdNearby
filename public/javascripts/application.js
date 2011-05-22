$(function() {
  $("#map_canvas").width("500px");
  $("#map_canvas").height("500px");

  navigator.geolocation.getCurrentPosition(function(position) {

    var lat = position.coords.latitude;
    var lng = position.coords.longitude;

    var latlng = new google.maps.LatLng(lat,lng);
    var myOptions = {
      zoom: 11,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    var map = new google.maps.Map($("#map_canvas").get(0), myOptions);

    $.get('instagrams', {
      lat: lat,
      lng: lng},
      function(response) {
        $(".feed").html(response)
      });

    $.get('tweets', {
      lat: lat,
      lng: lng},
      function(response) {
        $(".feed").append(response)
      });
  });
});

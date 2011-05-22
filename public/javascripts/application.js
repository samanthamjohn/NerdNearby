$(function() {

  navigator.geolocation.getCurrentPosition(function(position) {

    var lat = position.coords.latitude;
    var lng = position.coords.longitude;

    var latlng = new google.maps.LatLng(lat,lng);
    var myOptions = {
      zoom: 14,
      center: latlng,
      disableDefaultUI: true,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    var map = new google.maps.Map($("#map_canvas").get(0), myOptions);

    var marker = new google.maps.Marker({
      position: latlng,
      map: map,
      title: "You are here"
    });

    $.get('feed_items', {
      lat: lat,
      lng: lng},
      function(response) {
        $(".feed-items").html(response)
      });
  });
});

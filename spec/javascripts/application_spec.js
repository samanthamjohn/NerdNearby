describe("application.js", function() {

  it("should set all the times for feed items", function() {
    var fixture = "<div class='timestamp'" +
                  "data-hour='04'" +
                  "data-minute='03'" +
                  "data-weekday='Monday'" +
                  "></div>";
    $(fixture).appendTo("body")
    findFeedItems();
    var timestamp = $("body").find(".timestamp");
    expect(timestamp.html()).toEqual("Monday 8:03 AM")
  });

  describe("UTCToLocalTime", function() {

    describe("when the new time is in the same day", function() {
      it("should convert a UTC time to local time", function() {

        var dayOfWeek = "Friday";
        var hour = 21;
        var minute = 5;
        var offset = -1;

        var localTime = UTCToLocalTime(dayOfWeek, hour, minute, offset);

        expect(localTime).toBe("Friday 8:05 PM");
      });

      it("it should set time 0 to 12", function() {
        var dayOfWeek = "Friday";
        var hour = 0;
        var minute = 5;
        var offset = 0;

        var localTime = UTCToLocalTime(dayOfWeek, hour, minute, offset);

        expect(localTime).toBe("Friday 12:05 AM");
      });
    });

    describe("when the new time is in the next day", function() {
      it("should get the time and set the correct day", function() {

        var dayOfWeek = "Friday";
        var hour = 23;
        var minute = 5;
        var offset = 1;

        var localTime = UTCToLocalTime(dayOfWeek, hour, minute, offset);

        expect(localTime).toBe("Saturday 12:05 AM");
      });
    });
    describe("when the new time is in the previous day", function() {
      it("should get the time and set the correct day", function() {

        var dayOfWeek = "Friday";
        var hour = 0;
        var minute = 5;
        var offset = -2;

        var localTime = UTCToLocalTime(dayOfWeek, hour, minute, offset);

        expect(localTime).toBe("Thursday 10:05 PM");
      });
    });
  });
});

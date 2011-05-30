require 'spec_helper'

describe ApplicationHelper do

  describe "#pretty_time" do
    subject { helper.pretty_time(time) }

    context "when a date is passed in" do
      let(:time) { Time.parse("may 22, 2011, 2:30 pm") }
      it { should == "<div class=\"timestamp\" data-hour=\"14\" data-minute=\"30\" data-weekday=\"Sunday\"></div>" }
    end

    context "when a null value is passed in" do
      let(:time) { nil }
      it { should == "" }
    end
  end


  describe "#tweet_maker" do
    subject { Nokogiri::HTML(helper.tweet_maker(feed_item)) }

    context "with a flickr feed item" do
      let(:checkin_text) { nil }
      let(:feed_item) { {
        url: "foo",
        checkin_text: checkin_text
      } }
      context "when the checkin text is blank" do
        let(:checkin_text) { "" }
        it "should return a twitter share block with 'awesome picture'" do
          subject.attr("class").should == "twitter-share-button"
          # feed_item.merge(checkin_text: "")
        end
      end
    end

    context "when there is checkin text" do

      context "when the checkin text is longer than 83 characters" do

      end
    end

  end
end



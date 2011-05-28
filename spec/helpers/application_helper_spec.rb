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

end



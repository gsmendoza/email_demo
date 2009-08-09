require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
  test "creating a feedback should email the administrator" do
    ActionMailer::Base.deliveries.clear

    @feedback = Feedback.create(:from => 'gsmendoza@mailinator.com', :subject => 'Hi', :message => 'Hello')

    ActionMailer::Base.deliveries.size.should == 1
    email = ActionMailer::Base.deliveries[0]
    email.should_not be_nil

    email.from.should == [@feedback.from]
    email.to.should == ['administrator@somerailsapp.com']
    email.subject.should =~ /#{t(:user_created_a_feedback)}/
    email.body.should =~ /#{@feedback.message}/
  end
end

class Feedback < ActiveRecord::Base
  after_create :deliver_emails

protected
  def deliver_emails
    GenericMailer.deliver_email self, :user_created_a_feedback,
      :from => from,
      :to => 'administrator@somerailsapp.com'
  end

end

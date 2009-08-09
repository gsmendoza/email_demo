Simplify sending emails in Rails
================================

Problem
-------

Sending emails can be painful in Rails.

Why?
----

* No REST-like conventions. Should I divide my mailers by model or just put them all in one big Notifier class (as implied in the API)? How should I name my email methods?
* Lack of visibility. When writing views, you can check out the view in your browser as you are writing it. With emails, you can only view the email when its sent to your inbox. If the email depends on an event in your app, you have to redo that event anytime you need to view the email.

How we lessened the pain
========================

Write a generic mailer
----------------------

With the help of [this](http://snippets.dzone.com/posts/show/1338) blog post, we wrote our own generic mailer:

    class GenericMailer < ActionMailer::Base
      def email(object, template_name, options = {})
        @from = options[:from] || 'default@email.com'
        @from = @from.respond_to?(:email) ? @from.email : @from

        @recipients = options[:recipients] || options[:to]
        @recipients = @recipients.collect{|item| item.respond_to?(:email) ? item.email : item}.sort if @recipients.is_a? Array

        @subject = "[App Name] " + (options[:subject] || I18n.t(template_name.to_s))

        @body = options[:body] || {object.class.to_s.underscore.to_sym => object}

        @template = "generic_mailer/#{object.class.table_name}/#{template_name}"
      end
    end

Now, we can send emails like so:

    class Feedback < ActiveRecord::Base
      after_create :deliver_emails

    protected
      def deliver_emails
        GenericMailer.deliver_email self, :user_created_a_feedback,
          :from => from,
          :to => 'administrator@somerailsapp.com'
      end
    end

That's one less email method definition to worry about!

Note that `template_name` is used to determine the subject (take from the localization file) and the name of the template. Templates are saved in `generic_mailer/<objects>/<template_name>`. In the above example, the `user_created_a_feedback.html.erb` file should be under `generic_mailer/feedbacks`.

Test if you're sending the right email to the right people
----------------------------------------------------------

    require 'test_helper'

    class FeedbackTest < ActiveSupport::TestCase
      test "creating a feedback should email the administrator" do
        ActionMailer::Base.deliveries.size.should == 0

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

For `t(:key)` to get the localization, we added the following test helper:

    def t(key, options = {})
      result = I18n.t(key.to_s, options)
      result.should_not =~ /translation.*missing/
      result
    end

Preview the email on your browser
--------------------------------------

Since Rails is the golden hammer to all problems, it is what I used to preview the emails on my browser (instead, of say, using an IDE that can do this sort of thing).

There are two parts. The route:

    map.connect '/generic_mailer/:table_name/:action/:id', :controller => 'generic_mailer'

and the controller:

    class GenericMailerController < ApplicationController
      before_filter :render_email

    protected
      def render_email
        self.instance_variable_set('@' + params[:table_name].singularize, params[:table_name].classify.constantize.find(params[:id]))
        render :template => "generic_mailer/#{params[:table_name]}/#{params[:action]}"
      end
    end

That's about it! Now I can preview the email above in the following url:

<http://localhost:3000/generic_mailer/feedbacks/user_created_a_feedback/1>

Since you can view sensitive data from this controller, it's important to secure this controller before you release to production.

Testing your emails manually
----------------------------

We use <http://www.mailinator.com> to test our emails, i.e. in our staging environment, all our user emails end with "@mailinator.com".

Another service that looks interesting is <http://litmusapp.com>.

Code
----

<http://github.com/gsmendoza/email_demo/tree/master>

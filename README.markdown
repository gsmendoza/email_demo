### Problem ###

Sending emails can be painful in Rails.

### Why? ###

* No REST-like conventions. Should I divide my mailers by model or just put them all in one big Notifier class (as implied in the API)? How should I name my email methods?
* Lack of visibility. When writing views, you can check out the view in your browser as you are writing it. With emails, you can only view the email when its sent to your inbox. If the email depends on an event in your app, you have to redo that event anytime you need to view the email.

### How we lessened the pain ###

#### Write a generic mailer ####

With the help of [this](http://snippets.dzone.com/posts/show/1338) blog post, we wrote our own generic mailer:

<script src='http://pastie.org/577110.js'></script>

Now, we can send emails like so:

<script src='http://pastie.org/577118.js'></script>

That's one less email method definition to worry about!

Note that `template_name` is used to determine the subject (take from the localization file) and the name of the template. Templates are saved in `generic_mailer/<objects>/<template_name>`. In the above example, the `user_created_a_feedback.html.erb` file should be under `generic_mailer/feedbacks`.

#### Test if you're sending the right email to the right people ####

<script src='http://pastie.org/577122.js'></script>

For `t(:key)` to get the localization, we added the following test helper:

<script src='http://pastie.org/577123.js'></script>

#### Preview the email on your browser ####

Since Rails is the golden hammer to all problems, it is what I used to preview the emails on my browser (instead, of say, using an IDE that can do this sort of thing).

There are two parts. The route:

<script src='http://pastie.org/577124.js'></script>

and the controller:

<script src='http://pastie.org/577125.js'></script>

That's about it! Now I can preview the email above in the following url:

<http://localhost:3000/generic_mailer/feedbacks/user_created_a_feedback/1>

Since you can view sensitive data from this controller, it's important to secure this controller before you release to production.

#### Testing your emails manually ####

We use <http://www.mailinator.com> to test our emails, i.e. in our staging environment, all our user emails end with "@mailinator.com".

Another service that looks interesting is <http://litmusapp.com>.

### Code ###

<http://github.com/gsmendoza/email_demo/tree/master>

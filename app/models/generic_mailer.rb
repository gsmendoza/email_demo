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

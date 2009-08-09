class GenericMailerController < ApplicationController
  before_filter :render_email

protected
  def render_email
    self.instance_variable_set('@' + params[:table_name].singularize, params[:table_name].classify.constantize.find(params[:id]))
    render :template => "generic_mailer/#{params[:table_name]}/#{params[:action]}"
  end
end

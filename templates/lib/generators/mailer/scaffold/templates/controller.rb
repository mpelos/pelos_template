# encoding: UTF-8
class <%= controller_class_name %>Controller < ApplicationController
  def create
    if params[:<%= singular_table_name %>].map{|v| v[1].blank?}.any?
      @error_message = t('<%= singular_table_name %>.error_message')
    else
      @successful_message = t('<%= singular_table_name %>.successful_message')
      ApplicationMailer.send_<%= singular_table_name %>_mail(params[:<%= singular_table_name %>]).deliver
    end

    respond_to do |format|
      format.js
    end
  end
end


  def send_<%= singular_table_name %>_mail(<%= singular_table_name %>)
    @<%= singular_table_name %> = <%= singular_table_name %>
    mail(:to => "to@example.com", :subject => "#Mensagem de #{<%= singular_table_name %>['name']}")
  end


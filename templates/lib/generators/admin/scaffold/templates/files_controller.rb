class Admin::<%= @controller_file_class_name %> < Admin::AdminController
  def destroy
    @attachment = <%= @file_class_name %>.find(params[:id])
    @attachment.destroy

    redirect_to(edit_admin_<%= singular_table_name %>_path(params[:<%= singular_table_name %>_id]))
  end
end


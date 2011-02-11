# encoding: UTF-8
class Admin::<%= controller_class_name %>Controller < Admin::AdminController
  inherit_resources

  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
<% for attribute in attributes -%>
<% if attribute.type.to_s.include? 'has_one' -%>
    @<%= singular_table_name %>.build_<%= attribute.name %>
<% elsif attribute.type.to_s.include? 'has_many' -%>
    @<%= singular_table_name %>.<%= attribute.name %>.build
<% end -%>
<% end -%>
  end

  def edit
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
<% for attribute in attributes -%>
<% if attribute.type.to_s.include? 'has_one' -%>
    @<%= singular_table_name %>.build_<%= attribute.name %> if @<%= singular_table_name %>.<%= attribute.name %>.nil?
<% elsif attribute.type.to_s.include? 'has_many' -%>
    @<%= singular_table_name %>.<%= attribute.name %>.build if @<%= singular_table_name %>.<%= attribute.name %>.empty?
<% end -%>
<% end -%>
  end

  def create
    create!(:notice => "#{t('activerecord.models.<%= singular_table_name %>')} cadastrad#{t('activerecord.attributes.<%= singular_table_name %>.gender')} com sucessso.") do |sucess, failure|
      sucess.html { redirect_to admin_<%= plural_table_name %>_url }

      failure.html do
<% for attribute in attributes -%>
<% if attribute.type.to_s.include? 'has_one' -%>
        @<%= singular_table_name %>.build_<%= attribute.name %>
<% elsif attribute.type.to_s.include? 'has_many' -%>
        @<%= singular_table_name %>.<%= attribute.name %>.build
<% end -%>
<% end -%>
        render :action => :new
      end
    end
  end

  def update
    create!(:notice => "#{t('activerecord.models.<%= singular_table_name %>')} atualizad#{t('activerecord.attributes.<%= singular_table_name %>.gender')} com sucessso.") do |sucess, failure|
      sucess.html { redirect_to admin_<%= plural_table_name %>_url }

      failure.html do
<% for attribute in attributes -%>
<% if attribute.type.to_s.include? 'has_one' -%>
        @<%= singular_table_name %>.build_<%= attribute.name %> if @<%= singular_table_name %>.<%= attribute.name %>.nil?
<% elsif attribute.type.to_s.include? 'has_many' -%>
        @<%= singular_table_name %>.<%= attribute.name %>.build if @<%= singular_table_name %>.<%= attribute.name %>.empty?
<% end -%>
<% end -%>
        render :action => :edit
      end
    end
  end

  def destroy
    destroy!(:notice => "#{t('activerecord.models.<%= singular_table_name %>')} excluíd#{t('activerecord.attributes.<%= singular_table_name %>.gender')} com sucessso.") { admin_<%= plural_table_name %>_url }
  end
end


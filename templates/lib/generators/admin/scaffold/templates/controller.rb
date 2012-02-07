# encoding: UTF-8
class Admin::<%= controller_class_name %>Controller < Admin::AdminController
  inherit_resources
  before_filter :set_page_title

  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %><%= "(:order => :position)" if options.ordination? %>.paginate(:page => params[:page], :per_page => 20)
  end

<% if options.show? -%>
  def show
    resource
    render :layout => 'admin/show'
  end
<% end -%>

  def new
    @<%= file_name %> = <%= orm_class.build(class_name) %>
<% for attribute in attributes -%>
<% if attribute.type.to_s.include? 'has_one' -%>
    @<%= file_name %>.build_<%= attribute.name %>
<% elsif attribute.type.to_s.include? 'has_many' -%>
    @<%= file_name %>.<%= attribute.name %>.build
<% end -%>
<% end -%>
  end

  def edit
    @<%= file_name %> = <%= orm_class.find(class_name, "params[:id]") %>
<% for attribute in attributes -%>
<% if attribute.type.to_s.include? 'has_one' -%>
    @<%= file_name %>.build_<%= attribute.name %> if @<%= file_name %>.<%= attribute.name %>.nil?
<% elsif attribute.type.to_s.include? 'has_many' -%>
    @<%= file_name %>.<%= attribute.name %>.build if @<%= file_name %>.<%= attribute.name %>.empty?
<% end -%>
<% end -%>
  end

  def create
    create!(:notice => "#{t('activerecord.models.<%= file_name %>')} cadastrad#{t('activerecord.attributes.<%= file_name %>.gender')} com sucessso.") do |sucess, failure|
      sucess.html { redirect_to admin_<%= plural_table_name %>_url }

      failure.html do
<% for attribute in attributes -%>
<% if attribute.type.to_s.include? 'has_one' -%>
        @<%= file_name %>.build_<%= attribute.name %>
<% elsif attribute.type.to_s.include? 'has_many' -%>
        @<%= file_name %>.<%= attribute.name %>.build
<% end -%>
<% end -%>
        render :action => :new
      end
    end
  end

  def update
    update!(:notice => "#{t('activerecord.models.<%= file_name %>')} atualizad#{t('activerecord.attributes.<%= file_name %>.gender')} com sucessso.") do |sucess, failure|
      sucess.html { redirect_to admin_<%= plural_table_name %>_url }

      failure.html do
<% for attribute in attributes -%>
<% if attribute.type.to_s.include? 'has_one' -%>
        @<%= file_name %>.build_<%= attribute.name %> if @<%= file_name %>.<%= attribute.name %>.nil?
<% elsif attribute.type.to_s.include? 'has_many' -%>
        @<%= file_name %>.<%= attribute.name %>.build if @<%= file_name %>.<%= attribute.name %>.empty?
<% end -%>
<% end -%>
        render :action => :edit
      end
    end
  end

  def destroy
    destroy!(:notice => "#{t('activerecord.models.<%= file_name %>')} excluíd#{t('activerecord.attributes.<%= file_name %>.gender')} com sucessso.") { admin_<%= plural_table_name %>_url }
  end

<% if options.ordination? -%>
  def reorder
    if resource.insert_at(params[:position])
      head :ok
    else
      head :error
    end
  end  
<% end -%>

  protected
    def set_page_title
      @page_title = t('activerecord.attributes.<%= file_name %>.plural')
    end
end


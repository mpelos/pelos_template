class <%= class_name %> < <%= parent_class_name.classify %>
<% attributes.each do |attribute| -%>
<% if attribute.type == :has_many -%>
  has_many :<%= attribute.name %>, :class_name => '<%= class_name + attribute.name.to_s.classify %>', :dependent => :destroy
<% elsif attribute.type.to_s.include? 'has_' -%>
  has_<%= attribute.type.to_s.split('_')[1] %> :<%= attribute.name %>, :as => :assetable, :class_name => '<%= class_name + attribute.name.to_s.classify %>', :dependent => :destroy
<% end -%>
<% end -%>

<% attributes.each do |attribute| -%>
<% if attribute.type == :has_many -%>
  accepts_nested_attributes_for :<%= attribute.name %>, :allow_destroy => true
<% elsif attribute.type.to_s.include? 'has_' -%>
  accepts_nested_attributes_for :<%= attribute.name %>, :reject_if => lambda { |a| a[:attachment].blank? }, :allow_destroy => true
<% end -%>
<% end -%>
end


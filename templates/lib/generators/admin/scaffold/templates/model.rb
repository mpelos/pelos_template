# encoding: UTF-8
class <%= class_name %> < <%= parent_class_name.classify %>
<% if options.ordination? -%>
  after_create :set_position
  acts_as_list
<% end -%>
<% if options.friendly_id? -%>
  has_friendly_id :<%= attributes.first.name %>, :use_slug => true, :approximate_ascii => true
<% end -%>
<% attributes.each do |attribute| -%>
<% if attribute.type == :has_many -%>
  has_many :<%= attribute.name %>, :class_name => '<%= class_name + attribute.name.to_s.classify %>', :dependent => :destroy
<% elsif attribute.type.to_s.include? 'has_' -%>
  has_<%= attribute.type.to_s.split('_')[1] %> :<%= attribute.name %>, :as => :assetable, :class_name => '<%= class_name + attribute.name.to_s.classify %>', :dependent => :destroy
<% end -%>
<% end -%>
<% attributes.each do |attribute| -%>
<% if attribute.type == :has_many -%>
  accepts_nested_attributes_for :<%= attribute.name %>, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
<% elsif attribute.type.to_s.include? 'has_' -%>
  accepts_nested_attributes_for :<%= attribute.name %>, :reject_if => lambda { |a| a[:attachment].blank? <%= "and a[:attachment_subtitle].blank?" if options.image_subtitle? %> }, :allow_destroy => true
<% end -%>
<% end -%>

  validates_presence_of :<%= attributes.first.name %>
<% if options.ordination? -%>

  protected
    def set_position
      self.move_to_bottom
    end
<% end -%>
end


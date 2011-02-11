class <%= migration_class_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
<% attributes.each do |attribute| -%>
<% unless attribute.type.to_s.include? 'has_'  -%>
      t.<%= attribute.type %> :<%= attribute.name %>
<%- end -%>
<%- end -%>
      t.timestamps
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end


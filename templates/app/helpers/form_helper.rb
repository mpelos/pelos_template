module FormHelper
  def nested_form_for(object, *args, &block)
    concat form_for(object, *(args << { :builder => NestedFormBuilder, :html => { :multipart => true } }), &block)
    execute_after_nested_form_callbacks
  end

  def execute_after_nested_form_callbacks
    @after_nested_form_callbacks ||= []
    @after_nested_form_callbacks.inject(String.new.html_safe) do |output, callback|
      output << callback.call
    end
  end

  def after_nested_form(association, &block)
    @associations ||= []
    @after_nested_form_callbacks ||= []

    unless @associations.include? association
      @associations << association
      @after_nested_form_callbacks << block
    end
  end

  class NestedFormBuilder < ActionView::Helpers::FormBuilder
    def fields_for(record_or_name_or_array, *args, &block)
      options = args.extract_options!
      options[:builder] = NestedFormBuilder

      super(record_or_name_or_array, *(args << options), &block)
    end

    alias :nested_fields_for :fields_for

    def link_to_add(association, name = nil)
      name ||= I18n.t 'helpers.nesting.add', :model => association.to_s.classify.constantize.model_name.human

      @fields ||= {}

      @template.after_nested_form(association) do
        model_object = object.class.reflect_on_association(association).klass.new

        @template.content_tag :div, :id => "#{association}_fields_blueprint", :style => 'display: none' do
          fields_for(association, model_object, :child_index => "new_#{association}", :builder => NestedFormBuilder, &@fields[association])
        end
      end

      @template.link_to(name, 'javascript:void(0)', :class => 'add_nested_fields link', :'data-association' => association)
    end

    def link_to_remove(name = nil)
      name ||= I18n.t('helpers.nesting.remove', :model => object.class.model_name.human)

      hidden_field(:_destroy) + @template.link_to(name, 'javascript:void(0)', :class => 'remove_nested_fields')
    end

    def fields_for_with_nested_attributes(association, args, block)
      @fields ||= {}
      @fields[association] = block

      super
    end

    def fields_for_nested_model(name, association, args, block)
      @template.content_tag :div, :class => 'fields' do
        super
      end
    end
  end
end


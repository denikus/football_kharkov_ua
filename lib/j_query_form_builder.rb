class JQueryFormBuilder < ActionView::Helpers::FormBuilder
  #helpers = field_helpers +
  #  %w(date_select datetime_select time_select) +
  #  %w(collection_select select country_select time_zone_select) -
  #  %w(hidden_field label fields_for)
  #helpers.each do |name|
  #  define_method(name) do |field, *args|
  #    options = args.extract_options!
  #    @template.content_tag(:tr, :style => (options.key?(:visible) and not options[:visible]) ? "display: none;" : '' ) do
  #      @template.content_tag(:td, @template.content_tag(:strong, label(field)), :class => 'first', :width => 172) +
  #      @template.content_tag(:td, super(field, *args.push(options)), :class => 'last')
  #    end
  #  end
  #end
  #
  #def header name, options={}
  #  @template.content_tag(:tr, options) do
  #    @template.content_tag(:th, name, :class => 'full', :colspan => 2)
  #  end
  #end
  
  [:text_field, :text_area, :select, :date_select].each do |method|
    define_method method do |field, lbl, *args|
      options = args.extract_options!
      @template.content_tag :tr do
        @template.content_tag(:td, lbl || label(field)) +
        @template.content_tag(:td, super(field, *args.push(options)))
      end
    end
  end
  
  def checkbox method, lbl, *args
    @template.content_tag :tr do
      @template.content_tag(:td, :colspan => 2) do
        check_box(*args.unshift(method)) +
        @template.content_tag(:label, lbl, :for => "#{@object_name}_#{method}")
      end
    end
  end
  
  def train_select method, choices, options={}, html_options={}
    html_options[:train] = true
    @template.content_tag(:tr) do
      @template.content_tag(:td, '&nbsp;') +
      @template.content_tag(:td, @template.select("#{@object_name}[#{method}]", '', choices, options, html_options))
    end
  end
  
  def delimeter name
    @template.content_tag(:tr) do
      @template.content_tag(:td, :colspan => 2) do
        @template.content_tag(:span, name, :class => "ui-widget-header ui-corner-all")
      end
    end
  end
  
  def canvas id
    @template.content_tag(:tr) do
      @template.content_tag(:td, '', :colspan => 2, :id => id)
    end
  end
  
  def append_button html
    (@buttons ||= []) << html
  end
  
  def draw legend, &block
    body = @template.capture(&block)
    form_id = @template.dom_id(@object)
    form_id = 'edit_' + form_id unless @object.new_record?
    @template.concat(@template.render(:partial => 'admin/shared/form.html.haml', :object => body, :locals => {:legend => legend, :id => form_id, :buttons => @buttons}), block.binding)
  end
end
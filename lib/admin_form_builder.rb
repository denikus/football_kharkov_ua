class AdminFormBuilder < ActionView::Helpers::FormBuilder
  helpers = field_helpers +
    %w(date_select datetime_select time_select) +
    %w(collection_select select country_select time_zone_select) -
    %w(hidden_field label fields_for)
  helpers.each do |name|
    define_method(name) do |field, *args|
      options = args.extract_options!
      @template.content_tag(:tr, :style => (options.key?(:visible) and not options[:visible]) ? "display: none;" : '' ) do
        @template.content_tag(:td, @template.content_tag(:strong, label(field)), :class => 'first', :width => 172) +
        @template.content_tag(:td, super(field, *args.push(options)), :class => 'last')
      end
    end
  end
  
  def header name, options={}
    @template.content_tag(:tr, options) do
      @template.content_tag(:th, name, :class => 'full', :colspan => 2)
    end
  end
  
  def train_select method, choices, options={}, html_options={}
    html_options[:onchange] ||= @template.update_page do |page|
      page << %Q{
        if($(this).val() == '') {
          while($(this).parents('tr').next().length > 0){ $(this).parents('tr').next().remove(); }
        } else {
          if($(this).parents('tr').next().length == 0){ $(this).parents('table').append($(this).parents('tr').clone(true)); }
        }
      }.split($/).join.gsub(/\s(\s+)/, '')
    end
    @template.content_tag(:tr) do
      @template.content_tag(:td, '&nbsp;', :class => 'first', :width => 172) +
      @template.content_tag(:td, @template.select("#{@object_name}[#{method}]", '', choices, options, html_options), :class => 'last')
    end
  end
  
  def draw header, &block
    body = @template.capture(&block)
    @template.concat(@template.render(:partial => 'admin/shared/form', :object => body, :locals => {:header => header, :footer => @footer}), block.binding)
  end
  
  def footer &block
    @template.capture(@footer = FooterProxy.new(self), &block)
  end
  
  class FooterProxy < ::ActiveSupport::BasicObject
    def initialize builder
      @builder = builder
    end
    
    def elements
      @elements ||= []
    end
    
    def method_missing m, *args, &block
      elements << (@builder.respond_to?(m) ? @builder : @builder.instance_variable_get(:@template)).send(m, *args, &block)
    end
  end
end
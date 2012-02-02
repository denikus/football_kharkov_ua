# -*- encoding : utf-8 -*-
module Kernel
  def show_log
    unless @log_buffer_size
      @log_file = Rails.logger.instance_variable_get("@log")
      @log_level = Rails.logger.level
      @log_buffer_size = Rails.logger.auto_flushing
    end
    Rails.logger.flush
    Rails.logger.instance_variable_set("@log", STDOUT)
    Rails.logger.level = Logger::DEBUG
    Rails.logger.auto_flushing = 1
    nil
  end

  def hide_log
    if @log_buffer_size
      Rails.logger.instance_variable_set("@log", @log_file)
      Rails.logger.level = @log_level
      Rails.logger.auto_flushing = @log_buffer_size
    end
    nil
  end
end

  class Array

    # return Ext compatible JSON form of an Array, i.e.:
    # {"results": n,
    # "posts": [ {"id": 1, "title": "First Post",
    # "body": "This is my first post.",
    # "published": true, ... },
    # ...
    # ]
    # }
    def to_ext_json(options = {})
      if given_class = options.delete(:class)
        element_class = (given_class.is_a?(Class) ? given_class : given_class.to_s.classify.constantize)
      else
        element_class = first.class
      end
      element_count = options.delete(:count) || self.length

      { :results => element_count, element_class.to_s.tableize.tr('/','_') => self }.to_json(options).html_safe
    end

  end

  class ActiveRecord::Base
      def to_ext_json(options = {})
        success = options.delete(:success)
        methods = Array(options.delete(:methods))
        underscored_class_name = self.class.to_s.demodulize.underscore

        if success || (success.nil? && valid?)
          # return success/data hash to form loader, i.e.:
          # {"data": { "post[id]": 1, "post[title]": "First Post",
          # "post[body]": "This is my first post.",
          # "post[published]": true, ...},
          # "success": true}
          data = attributes.map{|name,value| ["#{underscored_class_name}[#{name}]", value] }
          methods.each do |method|
            data << ["#{underscored_class_name}[#{method}]", self.send(method)] if self.respond_to? method
          end
          { :success => true, :data => Hash[*data.flatten] }.to_json(options)
        else
          # return no-success/errors hash to form submitter, i.e.:
          # {"errors": { "post[title]": "Title can't be blank", ... },
          # "success": false }
          error_hash = errors.inject({}) do |result, error| # error is [attribute, message]
            field_key = "#{underscored_class_name}[#{error.first}]"
            result[field_key] ||= 'Field ' + Array(errors[error.first]).join(' and ')
            result
          end
          { :success => false, :errors => error_hash }.to_json(options).html_safe
        end
      end
end
#  d method to ActiveRecord::base

class Hash
  def lookup(path, delimeter='>')
    keys = path.split(delimeter)
    keys.collect!{ |k| k[0] == ?: ? k[1..-1].to_sym : k }
    keys.inject(self){ |res, key| if res[key].nil? then return nil else res[key] end }
  end
end

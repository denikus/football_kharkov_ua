module Extensions
  module ActionController
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def admin_section section
        @admin_section = section

        define_method(:render) do |*args, &block|
          options = args.extract_options!
          @admin_section = options.delete(:section) if options.key? :section
          options = nil if options.empty?
          super(*args.push(options).compact, &block)
        end
      end
    end
  end
end

require 'active_support/concern'

module Enumerize
  module Hooks
    module FormtasticFormBuilderExtension
      extend ActiveSupport::Concern

      included do
        alias_method_chain :input, :enumerize
      end

      def input_with_enumerize(method, options={})
        is_ransack = defined? ::Ransack and object.is_a? ::Ransack::Search
        klass =  is_ransack ? object.klass : object.class

        if klass.respond_to?(:enumerized_attributes) && (attr = klass.enumerized_attributes[method])
          options[:as] = :select
          options[:collection] ||= is_ransack ? attr.options({ values: true }) : attr.options

          if attr.kind_of?(Enumerize::Multiple) && options[:as] != :check_boxes
            options[:input_html] = options.fetch(:input_html, {}).merge(:multiple => true)
          end
        end

        input_without_enumerize(method, options)
      end
    end
  end
end

::Formtastic::FormBuilder.send :include, Enumerize::Hooks::FormtasticFormBuilderExtension

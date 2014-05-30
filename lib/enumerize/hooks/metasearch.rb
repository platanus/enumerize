require 'active_support/concern'

module Enumerize
  module Hooks
    module MetaSearchExtension
      extend ActiveSupport::Concern

      included do
        alias_method_chain :input, :metasearch
      end

      def input_with_metasearch(method, options={})
        klass = object.is_a?(::MetaSearch::Builder) ? object.base : object.class

        if klass.respond_to?(:enumerized_attributes) && (attr = klass.enumerized_attributes[method])
          options[:collection] ||= attr.options
          options[:as] = :select
        end

        input_without_metasearch(method, options)
      end
    end
  end
end

::Formtastic::FormBuilder.send :include, Enumerize::Hooks::MetaSearchExtension if defined?(::Formtastic)
#::SimpleForm::FormBuilder.send :include, Enumerize::Hooks::MetaSearchExtension if defined?(::SimpleForm)

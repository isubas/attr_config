# frozen_string_literal: true

require 'ostruct'

module AttrConfig
  # Configurable
  module Configurable
    def self.included(base)
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module ClassMethods
      # Usage
      # attr_config :attribute,
      #             default: 'test',
      #             readable: { instance: false, class: false }
      #             writable: { instance: false, class: false }
      def attr_config(attribute, options = {})
        set_attr_config(attribute, options)
        define_getter_methods(attribute)
        define_setter_methods(attribute)
      end

      def config
        @config ||= OpenStruct.new(
          attr_configs.map { |key, options| [key, options[:default]] }.to_h
        )
      end

      def configure
        yield config
      end

      def attr_configs
        @attr_configs ||= {}
      end

      protected

      def inherited(subclass)
        subclass.instance_variable_set(:@attr_configs, attr_configs.dup)
        super
      end

      private

      def set_attr_config(attribute, options)
        attr_configs[attribute] = attr_configs.fetch(attribute, {}).merge(options)
      end

      def define_getter_methods(attribute)
        opt = attr_configs[attribute].fetch(:readable, {})

        define_method(attribute) { config[attribute] } if opt.fetch(:instance, true)
        define_singleton_method(attribute) { config[attribute] } if opt.fetch(:class, true)
      end

      def define_setter_methods(attribute)
        opt = attr_configs[attribute].fetch(:writable, {})

        define_method("#{attribute}=") { |value| config[attribute] = value } if opt.fetch(:instance, true)
        define_singleton_method("#{attribute}=") { |value| config[attribute] = value } if opt.fetch(:class, true)
      end
    end

    module InstanceMethods
      def config
        @config ||= reset_config
      end

      def reset_config
        @config = self.class.config.dup
      end
    end
  end
end

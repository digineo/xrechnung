module Xrechnung
  module MemberContainer
    def self.included(base)
      base.instance_variable_set :@members, {}
      base.extend ClassMethods
    end

    def initialize(**_kwargs)
      _kwargs.each do |k, v|
        send(members[k].fetch(:setter_name), v)
      end

      self.class.after_initialize.each do |block|
        instance_eval(&block)
      end
    end

    def members
      self.class.instance_variable_get :@members
    end

    module ClassMethods
      def member(member_name, type: nil, default: nil, optional: false)

        attr_reader member_name
        setter_name = :"#{member_name}="
        @members[member_name] = { optional: optional, setter_name: setter_name }

        if default
          after_initialize do
            send(setter_name, default)
          end
        end

        define_method setter_name do |in_value|
          if type && !in_value.is_a?(type)
            raise ArgumentError, "expected #{type} for :#{member_name}, got: #{in_value.class}"
          end

          instance_variable_set :"@#{member_name}", in_value
        end
      end

      def after_initialize(&block)
        @after_initialize_blocks ||= []
        if block
          @after_initialize_blocks << block
        else
          @after_initialize_blocks
        end
      end
    end
  end
end

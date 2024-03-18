module Xrechnung
  module MemberContainer
    def self.included(base)
      base.instance_variable_set :@members, {}
      base.extend ClassMethods
    end

    def initialize(**kwargs)
      # initialize default values
      self.class.members.each do |name, member|
        self[name] = member.default.dup unless member.default.nil?
      end

      kwargs.each do |k, v|
        self[k] = v
      end
    end

    def [](key)
      send(key)
    end

    def []=(key, value)
      send("#{key}=", value)
    end

    Member = Struct.new(:type, :default, :optional, :transform_value, keyword_init: true)

    module ClassMethods
      def members
        @members
      end

      # @param [String] member_name
      # @param [Array<Class>, Class] type
      # @param [Object] default
      # @param [TrueClass, FalseClass] optional When true, omits tag rather than rendering an empty tag on nil
      # @param [Proc] transform_value A Proc which is called with the input value to perform type conversion.
      def member(member_name, **kwargs)
        attr_reader member_name
        kwargs[:default].freeze

        setter_name           = :"#{member_name}="
        member                = Member.new(**kwargs)
        @members[member_name] = member

        define_method setter_name do |in_value|
          in_value = member.transform_value.call(in_value) if member.transform_value

          if member.type && !in_value.nil? && Array(member.type).none? { |t| in_value.is_a?(t) }
            raise ArgumentError, "expected #{member.type} for :#{member_name}, got: #{in_value.class}"
          end

          instance_variable_set :"@#{member_name}", in_value
        end
      end
    end
  end
end

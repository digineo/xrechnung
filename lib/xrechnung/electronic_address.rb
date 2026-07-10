module Xrechnung
  class ElectronicAddress
    include MemberContainer

    # @!attribute content
    #   @return [String]
    member :content, type: String

    # @!attribute scheme_id
    #   @return [String]
    member :scheme_id, type: String

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cbc :EndpointID, content, schemeID: scheme_id
    end
  end
end

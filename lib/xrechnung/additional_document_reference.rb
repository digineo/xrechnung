require "xrechnung/attachment"

module Xrechnung
  class AdditionalDocumentReference
    include MemberContainer

    # @!attribute id
    #   @return [String]
    member :id, type: String

    # @!attribute document_type
    #   @return [String]
    member :document_type, type: String, optional: true

    # @!attribute document_description
    #   @return [String]
    member :document_description, type: String, optional: true

    # @!attribute attachment
    #   @return [Xrechnung::Attachment]
    member :attachment, type: Xrechnung::Attachment, optional: true

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :AdditionalDocumentReference do
        xml.cbc :ID, id
        xml.cbc :DocumentType, document_type
        xml.cbc :DocumentDescription, document_description

        attachment&.to_xml(xml)
      end
    end
  end
end

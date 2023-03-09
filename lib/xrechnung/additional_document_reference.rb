module Xrechnung
  class AdditionalDocumentReference
    include MemberContainer

    # @!attribute id
    #   @return [String]
    member :id, type: String

    # @!attribute issue_date
    #   @return [document_type]
    member :document_type, type: String

    # @!attribute issue_date
    #   @return [base64_blob]
    member :base64_blob, type: Object

    def to_xml(xml)
      xml.cac :AdditionalDocumentReference do
        xml.cbc :ID, id
        xml.cac :Attachment do
          xml.cbc :EmbeddedDocumentBinaryObject, base64_blob, mimeCode: "application/pdf", filename: id
        end
      end
    end
  end
end

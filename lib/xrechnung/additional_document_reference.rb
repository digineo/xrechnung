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
    member :base64_blob, type: String

    def to_xml(xml)
      xml.cac :AdditionalDocumentReference do
        xml.cbc :ID, id
        xml.cbc :DocumentType, document_type
        xml.cac :Attachment do
          xml.cac :EmbeddedDocumentBinaryObject, mimeCode: "application/pdf", filename: id do
            base64_blob
          end
        end
      end
    end
  end
end

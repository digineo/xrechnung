module Xrechnung
  class AdditionalDocumentReference
    include MemberContainer

    # @!attribute id
    #   @return [String]
    member :id, type: String

    # @!attribute issue_date
    #   @return [Date]
    member :document_type, type: String

    def to_xml(xml)
      xml.cac :AdditionalDocumentReference do
        xml.cbc :ID, id
        xml.cbc :DocumentType, document_type
        xml.cac :Attachment do
          xml.cac :EmbeddedDocumentBinaryObject, mimeCode: "application/pdf", filename: @invoice.saved_pdfs.last.document_file_name do
            Base64.encode64(Paperclip.io_adapters.for(@invoice.saved_pdfs.last.document).read)
          end
        end
      end
    end
  end
end

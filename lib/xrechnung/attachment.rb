require "base64"

module Xrechnung
  class Attachment
    include MemberContainer

    # @!attribute mime_code
    #   @return [String]
    member :mime_code, type: String

    # @!attribute filename
    #   @return [String]
    member :filename, type: String

    member :payload

    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :Attachment do
        xml.cbc :EmbeddedDocumentBinaryObject,
          Base64.strict_encode64(payload),
          mimeCode: mime_code,
          filename: filename
      end
    end
  end
end

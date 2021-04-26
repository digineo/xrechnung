module Xrechnung
  class InvoiceDocumentReference
    include MemberContainer

    # @!attribute id
    #   @return [String]
    member :id, type: String

    # @!attribute issue_date
    #   @return [Date]
    member :issue_date, type: Date

    def to_xml(xml)
      xml.cac :InvoiceDocumentReference do
        xml.cbc :ID, id
        xml.cbc :IssueDate, issue_date
      end
    end
  end
end

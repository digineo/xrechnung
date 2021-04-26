module Xrechnung
  class InvoiceDocumentReference
    attr_accessor :id, :issue_date

    def to_xml(xml)
      xml.cac :InvoiceDocumentReference do
        xml.cbc :ID, id
        xml.cbc :IssueDate, issue_date
      end
    end
  end
end

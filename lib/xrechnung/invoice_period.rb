module Xrechnung
  class InvoicePeriod
    include MemberContainer

    # @!attribute start_date
    #   @return [Date]
    member :start_date, type: Date

    # @!attribute end_date
    #   @return [Date]
    member :end_date, type: Date

    def to_xml(xml)
      xml.cac :InvoicePeriod do
        xml.cbc :StartDate, start_date
        xml.cbc :EndDate, end_date
      end
    end
  end
end

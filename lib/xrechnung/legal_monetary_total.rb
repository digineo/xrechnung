module Xrechnung
  LegalMonetaryTotal = Struct.new(:line_extension_amount, :tax_exclusive_amount,
                                  :tax_inclusive_amount, :allowance_total_amount,
                                  :charge_total_amount, :prepaid_amount,
                                  :payable_rounding_amount, :payable_amount, keyword_init: true) do

    def initialize(**kwargs)
      super **kwargs.transform_values{|v| Currency::EUR(v) }
    end


    # noinspection RubyResolve
    def to_xml(xml)
      members.each do |member|
        next if self[member].nil?

        xml.cbc :"#{member.to_s.split("_").map(&:capitalize).join}", *self[member].xml_args
      end
      xml.target!
    end
  end
end

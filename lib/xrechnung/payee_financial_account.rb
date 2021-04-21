module Xrechnung
  #   <cac:PayeeFinancialAccount>
  #     <cbc:ID>DE12500105170648489890</cbc:ID>
  #     <cbc:Name>Harry Hirsch</cbc:Name>
  #     <cac:FinancialInstitutionBranch>
  #       <cbc:ID>XUFUXHB</cbc:ID>
  #     </cac:FinancialInstitutionBranch>
  #   </cac:PayeeFinancialAccount>
  PayeeFinancialAccount = Struct.new(:id, :name, :financial_institution_branch_id, keyword_init: true) do
    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :PayeeFinancialAccount do
        xml.cbc :ID, id
        xml.cbc :Name, name
        xml.cac :FinancialInstitutionBranch do
          xml.cbc :ID, financial_institution_branch_id
        end
      end
    end
  end
end

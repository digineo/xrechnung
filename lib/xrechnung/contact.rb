module Xrechnung
  class Contact
    attr_accessor :name,
                  :telephone,
                  :electronic_mail

    def to_xml(xml)
      xml.cac :Contact do
        xml.cbc :Name, name
        xml.cbc :Telephone, telephone
        xml.cbc :ElectronicMail, electronic_mail
      end
    end
  end
end

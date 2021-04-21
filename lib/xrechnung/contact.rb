module Xrechnung
  Contact = Struct.new(:name, :telephone, :electronic_mail, keyword_init: true) do
    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :Contact do
        xml.cbc :Name, name
        xml.cbc :Telephone, telephone
        xml.cbc :ElectronicMail, electronic_mail
      end
    end
  end
end

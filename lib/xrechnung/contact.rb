module Xrechnung
  class Contact
    include MemberContainer

    # @!attribute name
    #   @return [String]
    member :name, type: String

    # @!attribute telephone
    #   @return [String]
    member :telephone, type: String

    # @!attribute electronic_mail
    #   @return [String]
    member :electronic_mail, type: String

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

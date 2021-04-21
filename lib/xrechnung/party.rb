module Xrechnung
  Party = Struct.new(:name, :postal_address, :party_tax_scheme, :party_legal_entity, :contact, :nested, keyword_init: true) do
    def initialize(*args)
      super
      self.nested = true if self.nested.nil?
    end

    # noinspection RubyResolve
    def to_xml(xml)
      if nested
        xml.cac :Party do
          party_body(xml)
        end
      else
        party_body(xml)
      end
    end

    private

    def party_body(xml)
      unless name.nil? # if blank? -> empty name tag
        xml.cac :PartyName do
          if name == ""
            xml.cbc :Name
          else
            xml.cbc :Name, name
          end
        end
      end
      postal_address&.to_xml(xml)
      party_tax_scheme&.to_xml(xml)
      party_legal_entity&.to_xml(xml)
      contact&.to_xml(xml)
    end
  end
end

def build_contact
  contact                 = Xrechnung::Contact.new
  contact.name            = "Harry Hirsch"
  contact.telephone       = "+49 12345 78 657 - 8"
  contact.electronic_mail = "harry.hirsch@hhhtb.de"
  contact
end

def build_contact
  Xrechnung::Contact.new(
    name:            "Harry Hirsch",
    telephone:       "+49 12345 78 657 - 8",
    electronic_mail: "harry.hirsch@hhhtb.de",
  )
end

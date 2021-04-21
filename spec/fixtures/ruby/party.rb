load("spec/fixtures/ruby/postal_address.rb")
load("spec/fixtures/ruby/party_tax_scheme.rb")
load("spec/fixtures/ruby/party_legal_entity.rb")
load("spec/fixtures/ruby/contact.rb")

def build_party
  party = Xrechnung::Party.new
  party.postal_address = build_postal_address
  party.party_tax_scheme = build_party_tax_scheme
  party.party_legal_entity = build_party_legal_entity
  party.contact = build_contact
  party
end

require 'open-uri'

def name
  "import_shodan_xml"
end

def pretty_name
  "Import SHODAN XML"
end

## Returns a string which describes what this task does
def description
  "This is a task to import SHODAN xml."
end

## Returns an array of types that are allowed to call this task
def allowed_types
  [ Entities::ParsableFile,
    Entities::ParsableText ]
end

## Returns an array of valid options and their description/type for this task
def allowed_options
 []
end

def setup(entity, options={})
  super(entity, options)
end

## Default method, subclasses must override this
def run
  super

  if @entity.kind_of? Entities::ParsableText
    text = @entity.text
  else #ParsableFile
    text = open(@entity.uri).read
  end
  
  # Create our parser
  hosts = []
  shodan_xml = Import::ShodanXml.new(hosts)
  parser = Nokogiri::XML::SAX::Parser.new(shodan_xml)
  parser.parse(text)
  
  hosts.each do |host|
    #
    # Create the host / loc / domain entity for each host we know about
    #
    d = create_entity(Entities::DnsRecord, {:name => host.hostnames }) if host.hostnames.kind_of? String
    
    h = create_entity(Entities::Host, {:name => host.ip_address })
    # TODO - associate the child here
    #d.associate_child(h)
    
    p = create_entity(Entities::PhysicalLocation, {:city => host.city, :country => host.country})
    # TODO - associate the child here
    #h.associate_child(p)

    #host.services.each do |shodan_service|
    #  #
    #  # Create the service and associate it with our host above
    #  #
    #  create_entity(Entities::NetSvc, {
    #    :port_num => shodan_service.port,
    #    :type => "tcp",
    #    :fingerprint => shodan_service.data })
    #
    #end # End services processing

  end # End host processing
  
end

def cleanup
  super
end

require 'rexml/document'   
require 'rubydora'


def find_model(repo, modelname)
  model = repo.search('title~'+modelname+'')
  model[0]
end

def create_data(repo, modelname)
  pid = repo.ingest()
  obj = repo.find(pid)
  model = find_model(repo, modelname)
  obj.models << model
  obj
end

def add_dc_field(obj, field, value)
  ds = obj.datastreams['DC']
  doc = REXML::Document.new(ds.content.strip)
  ele=REXML::XPath.first(doc,'//oai_dc:dc]').add_element('dc:' + field)
  ele.text=value
  s=''
  doc.write(s)
  ds.content=s
  ds.save
end

repo = Rubydora.connect :url => 'http://localhost:8080/fedora', :user => 'fedoraAdmin', :password => 'fedora'

# Authority
objAuthority = create_data(repo, 'Authority')
add_dc_field(objAuthority,'title','Test Authority')

# Archive
objArchive = create_data(repo, 'Archive')
add_dc_field(objArchive,'title','Test Archive')
rels = objArchive.relationship("info:fedora/fedora-system:def/relations-external#isDependentOf")
rels << objAuthority

# Disk
objDisk = create_data(repo, 'Disk')
add_dc_field(objDisk,'title','Test Disk')
rels = objDisk.relationship("info:fedora/fedora-system:def/relations-external#isPartOf")
rels << objArchive

# DiskImage
objDiskImage = create_data(repo, 'DiskImage')
add_dc_field(objDiskImage,'title','Test DiskImage')
rels = objDiskImage.relationship("info:fedora/fedora-system:def/relations-external#isSubsetOf")
rels << objDisk

# DigitalDocument
objDigitalDocument = create_data(repo, 'DigitalDocument')
add_dc_field(objDigitalDocument,'title','Test DigitalDocument')
rels = objDigitalDocument.relationship("info:fedora/fedora-system:def/relations-external#isPartOf")
rels << objDisk

# ContentFile
objContentFile = create_data(repo, 'ContentFile')
add_dc_field(objContentFile,'title','Test ContentFile')
rels = objContentFile.relationship("info:fedora/fedora-system:def/relations-external#isPartOf")
rels << objDigitalDocument


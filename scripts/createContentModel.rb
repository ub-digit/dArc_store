require 'rexml/document'   
require 'rubydora'


def create_model(repo)
  pid = repo.ingest()
  obj = repo.find(pid)
  obj.models << 'info:fedora/fedora-system:ContentModel-3.0'
  obj
end

def add_model_ds(obj, xml)
  ds = obj.datastreams['DS-COMPOSITE-MODEL']
  ds.mimeType='text/xml'
  ds.controlGroup='X'
  ds.dsLabel='Datastream Composite Model'
  ds.content=xml
  ds.save()
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

repo.search('pid~darc:*').each{|d| d.delete}

# Authority
objAuthority = create_model(repo)
add_model_ds(objAuthority, '<?xml version="1.0" encoding="utf-8"?><dsCompositeModel xmlns="info:fedora/fedora-system:def/dsCompositeModel#"><dsTypeModel ID="EAC"/></dsCompositeModel>')
add_dc_field(objAuthority,'title','Content Model Object for Authority')

# Archive
objArchive = create_model(repo)
add_model_ds(objArchive, '<?xml version="1.0" encoding="utf-8"?><dsCompositeModel xmlns="info:fedora/fedora-system:def/dsCompositeModel#"><dsTypeModel ID="EAD"/></dsCompositeModel>')
add_dc_field(objArchive,'title','Content Model Object for Archive')

# Disk
objDisk = create_model(repo)
add_dc_field(objDisk,'title','Content Model Object for Disk')

# DiskImage
objDiskImage = create_model(repo)
add_model_ds(objDiskImage, '<?xml version="1.0" encoding="utf-8"?><dsCompositeModel xmlns="info:fedora/fedora-system:def/dsCompositeModel#"><dsTypeModel ID="DATA-D"/><dsTypeModel ID="DFXML"/><dsTypeModel ID="PREMIS"/></dsCompositeModel>')
add_dc_field(objDiskImage,'title','Content Model Object for DiskImage')

# DigitalDocument
objDigitalDocument = create_model(repo)
add_dc_field(objDigitalDocument,'title','Content Model Object for DigitalDocument')

# ContentFile
objContentFile = create_model(repo)
add_model_ds(objContentFile, '<?xml version="1.0" encoding="utf-8"?><dsCompositeModel xmlns="info:fedora/fedora-system:def/dsCompositeModel#"><dsTypeModel ID="DATA-F"/></dsCompositeModel>')
add_dc_field(objContentFile,'title','Content Model Object for ContentFile')


 





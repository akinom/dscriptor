#!/usr/bin/env jruby  -I lib -I utils
require "highline/import"

year = 2016
schema, element, qualifier = ['pu', 'date', 'classyear']
handle = '88435/dsp019c67wm88m'

fromString = "COMMUNITY.145"

require 'dspace'
DSpace.load

com = DSpace.fromString(fromString)
colls = com.getCollections

require 'xmlsimple'

colls.each do |col|
  puts "#{col.toString} #{col.getName}"
  File.open(col.toString + ".xml", 'w') do |out|
    items = col.items
    ihash = []
    while (i = items.next)
      h = {}
      h[:title] = i.getMetadataByMetadataString("dc.title").collect { |v| v.value }
      h[:author] = i.getMetadataByMetadataString("dc.contributor.author").collect { |v| v.value }
      h[:advisor] = i.getMetadataByMetadataString("dc.contributor.advisor").collect { |v| v.value }
      h[:classyear] = i.getMetadataByMetadataString("pu.date.classyear").collect { |v| v.value }
      h[:department] = i.getMetadataByMetadataString("pu.department").collect { |v| v.value }
      h[:url] = i.getMetadataByMetadataString("dc.identifier.uri").collect { |v| v.value }
      ihash << h
    end
    colurl = "http://arks.princeton.edu/ark:/#{col.getHandle()}"
    out.puts XmlSimple.xml_out({ :name => col.getName, :url => colurl, :items => ihash}, :root_name => 'collection')
  end
end


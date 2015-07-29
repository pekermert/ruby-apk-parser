require 'apktools/apkxml'
require 'pry'
if ARGV.length != 1
	puts "usage: get_app_version <APKFile>"
	exit(1)
end

apk_file = ARGV[0]

parser = ApkXml.new(apk_file)
parser.parse_xml("AndroidManifest.xml", false, true)

elements = parser.xml_elements

attribute1 = nil
attribute2 = nil
attribute3 = nil
attribute4 = nil

elements.each do |element|
	if element.name == 'manifest'
		attribute1 = element.attributes.map do |attribute|
			{attribute.name => attribute.value}
		end
	elsif element.name == 'activity'
		attribute2 = element.attributes.map do |attribute|
			{attribute.name => attribute.value}
		end
	elsif element.name == 'application'
		attribute3 = element.attributes.map do |attribute|
			{attribute.name => attribute.value}
		end
	elsif element.name == 'uses-sdk'
		attribute4 = element.attributes.map do |attribute|
			{attribute.name => attribute.value}
		end
	end

end

puts attribute1
puts attribute2
puts attribute3
puts attribute4
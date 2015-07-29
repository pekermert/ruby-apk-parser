require 'apktools/apkxml'
require 'pry'
require 'ipa_reader'

class Parser
	class << self
		def apk_parser(file)
			parser = ApkXml.new(file)
			parser.parse_xml("AndroidManifest.xml", false, true)

			elements = parser.xml_elements

			res = {}

			%w(manifest activity application uses-sdk).each do |attrb|
				element = elements.select {|element| element.name == attrb}.first
				res[attrb] = element.attributes.map { |attribute| { attribute.name => attribute.value } }
			end

			puts res
		end

		def ipa_parser(file)
			ipa = IpaReader::IpaFile.new("butcele.ipa")
			#name target_os_version minimum_os_version url_schemes bundle_identifier icon_prerendered
			#ipa.instance_variables.each {|var| hash[var.to_s.delete("@")] = ipa.instance_variable_get(var) }
			hash = {'name' => ipa.name, 
					'target_os' => ipa.target_os_version,
					'min_os' => ipa.minimum_os_version,
					'bundle_identifier' => ipa.bundle_identifier,
					'icon' => ipa.icon_prerendered,
					'url_schemes' => ipa.url_schemes
				}
				
			p hash
		end
	end
end

if ARGV.length != 1
	puts "usage: get_app_version <APKFile>"
	exit(1)
end

file = ARGV[0]
unless file =~ /(.ipa|.apk)$/
	puts 'Wrong type of file'
	exit(1)
end
meth = file =~ /.ipa$/ ? 'ipa_parser' : 'apk_parser'
Parser.send(meth, file)
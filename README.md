# Siegfried2Premis
Stylesheet to transform output of the Siegfried format identification tool to the PREMIS/XML format.

To use this stylesheet, you'll have to transform it to XML first, and it should be formatted like this:
<?xml version="1.0" encoding="UTF-8"?>
<root>
	<created>2017-06-29T14:53:59+02:00</created>
	<files>
		<errors>empty source</errors>
		<filename>/path/to/file</filename>
		<filesize>0</filesize>
		<matches>
			<basis/>
			<format/>
			<id>UNKNOWN</id>
			<mime/>
			<ns>pronom</ns>
			<version/>
			<warning>no match</warning>
		</matches>
		<md5>d41d8cd98f00b204e9800998ecf8427e</md5>
		<modified>1997-03-10T10:51:49+01:00</modified>
	</files>

To apply the template, use a tool like Saxon (or any other XML transformation tool you like)
e.g. (on Mac):
  $ saxon -s:path/to/source.xml -xsl:path/to/stylesheet.xsl -o:path/to/output.xml 
or (Windows):
  $ Transform -s:/path/to/siegfriedout.xml -xsl:/path/to/SF2PREMIS.xsl -o:/path/to/PREMIS- APA.xml
 

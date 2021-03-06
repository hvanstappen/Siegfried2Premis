# Siegfried2Premis
Stylesheet to transform JSON output of the Siegfried format identification tool to the PREMIS/XML format.

To use this stylesheet, you'll have to transform the Siegfried JSON output to XML first. You can use a tool like [Catmandu](https://github.com/LibreCat/Catmandu). The result should be structered like this:

\<?xml version="1.0" encoding="UTF-8"?>
\<root>
	\<created>2017-06-29T14:53:59+02:00\</created>
	\<files>
		\<errors>empty source\</errors>
		\<filename>/path/to/file\</filename>
		\<filesize>0\</filesize>
		\<matches>
			\<basis/>
			\<format/>
			\<id>UNKNOWN\</id>
			\<mime/>
			\<ns>pronom\</ns>
			\<version/>
			\<warning>no match\</warning>
		\</matches>
		\<md5>d41d8cd98f00b204e9800998ecf8427e\</md5>
		\<modified>1997-03-10T10:51:49+01:00\</modified>
	\</files>
	\<identifiers>
		\<details>DROID_SignatureFile_V90.xml; container-signature-20170330.xml; extensions: localsigfile.xml\</details>
		\<name>pronom\</name>
	\</identifiers>
	\<scandate>2017-07-25T16:23:28+02:00\</scandate>
	\<siegfried>1.7.2\</siegfried>
	\<signature>default.sig\</signature>
\<root>

To apply the template, use a tool like Saxon (or any other XML transformation tool you like)
e.g. (on Mac):

  $ saxon -s:path/to/source.xml -xsl:path/to/stylesheet.xsl -o:path/to/output.xml 
  
or (Windows):

  $ Transform -s:/path/to/siegfriedout.xml -xsl:/path/to/SF2PREMIS.xsl -o:/path/to/PREMIS- APA.xml
 

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:uuid="java.util.UUID" exclude-result-prefixes="xs xd uuid" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> June 14, 2017</xd:p>
            <xd:p><xd:b>Author:</xd:b>henkvanstappen</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="root">
        <!-- create event id based on event timestamp -->
        <xsl:variable name="eventid" select="replace(scandate, '[^0-9]', '')"/>
        <!-- create agent id 'siegfried' + version -->
        <xsl:variable name="agentid" select="concat('siegfried',replace(siegfried, '[^0-9]', ''))"/>
        <xsl:comment select="'object'"/>
        <premis:premis xmlns:premis="http://www.loc.gov/premis/v3"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/premis/v3 https://www.loc.gov/standards/premis/premis.xsd"
            version="3.0">
            <xsl:for-each select="files">
                <premis:object xsi:type="premis:file">
                    <premis:objectIdentifier>
                            <premis:objectIdentifierType authority="objectIdentifierType"
                                authorityURI="http://id.loc.gov/vocabulary/identifiers"
                                valueURI="http://id.loc.gov/vocabulary/identifiers/local">local</premis:objectIdentifierType>
                        <premis:objectIdentifierValue>
                                <xsl:variable name="i" select="position()" />
                                    <xsl:value-of select="concat($eventid,'-',$i)"/>
                        </premis:objectIdentifierValue>
                    </premis:objectIdentifier>
                    <xsl:comment>preservation level - given by policy</xsl:comment>
                    <xsl:text>&#xa;</xsl:text>
                    <premis:preservationLevel>
                        <premis:preservationLevelType>Bit preservation</premis:preservationLevelType>
                        <premis:preservationLevelValue/>
                        <premis:preservationLevelRole authority="preservationLevelRole"
                            authorityURI="http://id.loc.gov/vocabulary/preservation/preservationLevelRole"
                            valueURI="http://id.loc.gov/vocabulary/preservation/preservationLevelRole/req"
                            >requirement</premis:preservationLevelRole>
                        <premis:preservationLevelRationale>pre ingest</premis:preservationLevelRationale>
                        <premis:preservationLevelDateAssigned/>
                    </premis:preservationLevel>
                    <premis:objectCharacteristics>
                        <!-- Technical properties of a file or bitstream that are applicable to all or most formats -->
                        <premis:compositionLevel>0</premis:compositionLevel>
                        <!-- An indication of whether the Object is subject to one or more processes of decoding or unbundling. Level of 1 or 
                        higher indicates that one or more decodings must be applied. The compositionLevel should be set whenever possible, 
                        however it is permitted to omit (or use “unknown”) if it not possible to calculate -
                        For example, two encrypted files zipped together and stored in an archive as one file object would be described as three 
                        separate objects, each with its own associated metadata. The storage location of the two inner objects would point to the 
                        ZIP file, but the ZIP file itself would have only a single composition level (of zero) whose format would be “zip.” -->
                        <xsl:if test="md5">
                            <premis:fixity>
                                <premis:messageDigestAlgorithm authority="messageDigestAlgorithm"
                                    authorityURI="http://id.loc.gov/vocabulary/preservation/cryptographicHashFunctions"
                                    valueURI="http://id.loc.gov/vocabulary/preservation/cryptographicHashFunctions/md5"
                                    >MD5</premis:messageDigestAlgorithm>
                                <premis:messageDigest>
                                    <xsl:value-of select="md5"/>
                                </premis:messageDigest>
                                <premis:messageDigestOriginator>
                                    <xsl:value-of select="concat('Siegfried ',../siegfried)"/>
                                </premis:messageDigestOriginator>
                                <!-- If the calculation of the initial message digest is treated by the repository as an Event, this information 
                            could be obtained from an Event record. (...) The act of performing a fixity check and the date it occurred would be recorded as an Event. 
                            The result of the check would be recorded as the eventOutcome. -->
                                <!-- The originator of the message digest could be represented by a string representing the Agent (e.g., “DRS” referring to the archive itself) 
                            or a pointer to an Agent description (e.g., “A0000978” taken here to be an agentIdentifierValue). -->
                            </premis:fixity>
                        </xsl:if>
                        <xsl:if test="sha1">
                            <premis:fixity>
                                <premis:messageDigestAlgorithm authority="messageDigestAlgorithm"
                                    authorityURI="http://id.loc.gov/vocabulary/preservation/cryptographicHashFunctions"
                                    valueURI="http://id.loc.gov/vocabulary/preservation/cryptographicHashFunctions/sha1"
                                    >SHA-1</premis:messageDigestAlgorithm>
                                <premis:messageDigest>
                                    <xsl:value-of select="sha1"/>
                                </premis:messageDigest>
                                <premis:messageDigestOriginator>
                                    <xsl:value-of select="concat('Siegfried ',../siegfried)"/>
                                </premis:messageDigestOriginator>
                            </premis:fixity>
                        </xsl:if>
                        <premis:size>
                            <xsl:value-of select="filesize"/>
                        </premis:size>
                        <xsl:for-each select="matches">
                            <premis:format>
                                <premis:formatDesignation>
                                    <premis:formatName>
                                        <xsl:value-of select="format"/>
                                    </premis:formatName>
                                    <!-- <empty if no version is available -->
                                    <premis:formatVersion>
                                        <xsl:value-of select="version"/>
                                    </premis:formatVersion>
                                </premis:formatDesignation>
                                <premis:formatRegistry>
                                    <xsl:choose>
                                        <!-- set to 'local' if a custom signature file is used -->
                                        <!-- criterium is name of name of namespace (ns element) -->
                                        <xsl:when test="ns = 'pronom'">
                                            <premis:formatRegistryName>
                                                <xsl:value-of select="ns"/>
                                            </premis:formatRegistryName>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <premis:formatRegistryName>
                                                <xsl:text>local</xsl:text>
                                            </premis:formatRegistryName>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <premis:formatRegistryKey>
                                        <xsl:value-of select="id"/>
                                    </premis:formatRegistryKey>
                                    <premis:formatRegistryRole authority="formatRegistryRole"
                                        authorityURI="http://id.loc.gov/vocabulary/preservation/formatRegistryRole"
                                        valueURI="http://id.loc.gov/vocabulary/preservation/formatRegistryRole/val"
                                        >validation profile</premis:formatRegistryRole>
                                    <!-- The purpose or expected use of the registry. -->
                                </premis:formatRegistry>
                                <xsl:if test="../errors != ''">
                                    <premis:formatNote>
                                        <xsl:value-of select="concat('ERROR: ',../errors)"/>
                                    </premis:formatNote>
                                </xsl:if>
                                <xsl:if test="../basis != ''">
                                    <premis:formatNote>
                                        <xsl:value-of select="concat('BASIS: ',../basis)"/>
                                    </premis:formatNote>
                                </xsl:if>
                                <xsl:if test="../warning != ''">
                                    <premis:formatNote>
                                        <xsl:value-of select="concat('WARNING: ',../warning)"/>
                                    </premis:formatNote>
                                </xsl:if>
                                <!-- Additional information about format. Qualifying information may be needed to supplement format 
                            designation and registry information or to record a status for identification.-->
                            </premis:format>
                        </xsl:for-each>
                        <premis:creatingApplication>
                            <!-- The creation date, in PREMIS terms, of an Object is the time that it was last modified; that is, 
                                the last time the document was saved. This is discussed in the 1:1 Principle section. (Data Dictionary p. 79)-->
                            <premis:dateCreatedByApplication>
                                <xsl:value-of select="modified"/>
                            </premis:dateCreatedByApplication>
                        </premis:creatingApplication>
                    </premis:objectCharacteristics>
                    <premis:originalName>
                        <!-- select string after last '/' -->
                        <xsl:value-of select="tokenize(filename,'/')[last()]"/>
                    </premis:originalName>
                    <premis:storage>
                        <premis:contentLocation>
                            <premis:contentLocationType authority="contentLocationType"
                                >url</premis:contentLocationType>
                            <premis:contentLocationValue>
                                <xsl:value-of select="filename"/>
                            </premis:contentLocationValue>
                        </premis:contentLocation>
                        <premis:storageMedium>hard disk</premis:storageMedium>
                        <!-- original hdd designation -->
                    </premis:storage>
                    <premis:relationship>
                        <premis:relationshipType authority="relationshipType"
                            authorityURI="http://id.loc.gov/vocabulary/preservation/relationshipType"
                            valueURI="http://id.loc.gov/vocabulary/preservation/relationshipType/structural"/>
                        <premis:relationshipSubType authority="relationshipSubType"
                            authorityURI="http://id.loc.gov/vocabulary/preservation/relationshipSubType"
                            valueURI="http://id.loc.gov/vocabulary/preservation/relationshipType/isPartOf"/>
                        <premis:relatedObjectIdentifier>
                            <premis:relatedObjectIdentifierType>local</premis:relatedObjectIdentifierType>
                            <premis:relatedObjectIdentifierValue>
                                <xsl:choose>
                                    <!-- select the name of the dmg -->
                                    <xsl:when test="substring(filename,36,3)='/CK'">
                                        <xsl:value-of select="concat(substring(filename,37,3),'.dmg')"/></xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>unknown</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </premis:relatedObjectIdentifierValue>
                        </premis:relatedObjectIdentifier>
                    </premis:relationship>
                    <premis:linkingEventIdentifier>
                        <premis:linkingEventIdentifierType>local</premis:linkingEventIdentifierType>
                        <premis:linkingEventIdentifierValue>
                            <xsl:value-of select="$eventid"/>
                        </premis:linkingEventIdentifierValue>
                    </premis:linkingEventIdentifier>
                </premis:object>
            </xsl:for-each>
            <xsl:comment>event</xsl:comment>
            <premis:event>
                <premis:eventIdentifier>
                    <premis:eventIdentifierType>local</premis:eventIdentifierType>
                    <premis:eventIdentifierValue>
                        <xsl:value-of select="$eventid"/>
                    </premis:eventIdentifierValue>
                </premis:eventIdentifier>
                <!-- siegfried executes 2 types of events: checksum and format identification, but eventType is not repeatable -->
                <premis:eventType>format identification and message digest calculation</premis:eventType>
                <premis:eventDateTime>
                    <xsl:value-of select="scandate"/>
                </premis:eventDateTime>
                <premis:linkingAgentIdentifier>
                    <premis:linkingAgentIdentifierType>local</premis:linkingAgentIdentifierType>
                    <premis:linkingAgentIdentifierValue>
                        <xsl:value-of select="$agentid"/>
                    </premis:linkingAgentIdentifierValue>
                </premis:linkingAgentIdentifier>
            </premis:event>
            <xsl:comment select="'agent'"/>
            <premis:agent>
                <!-- person, organization, or software program/system associated with Events in the life of an Object, or with Rights attached to an Object. It can also be related to an environment Object that acts as an Agent. -->
                <premis:agentIdentifier>
                    <premis:agentIdentifierType>local</premis:agentIdentifierType>
                    <premis:agentIdentifierValue>
                        <xsl:value-of select="$agentid"/>
                    </premis:agentIdentifierValue>
                </premis:agentIdentifier>
                <premis:agentName>Siegfried identification tool</premis:agentName>
                <premis:agentType>software</premis:agentType>
                <premis:agentVersion>
                    <xsl:value-of select="siegfried"/>
                </premis:agentVersion>
                <premis:agentNote>Siegfried with custom Signature files</premis:agentNote>
                <premis:agentNote>
                    <xsl:value-of select="concat('signature file creation date: ',created)"/>
                </premis:agentNote>
                <premis:agentNote>
                    <xsl:value-of select="concat('signature file name: ',identifiers/name)"/>
                </premis:agentNote>
                <premis:agentNote>
                    <xsl:value-of select="concat('signature file details: ',identifiers/details)"/>
                </premis:agentNote>
            </premis:agent>
        </premis:premis>
    </xsl:template>
</xsl:stylesheet>

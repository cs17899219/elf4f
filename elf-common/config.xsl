<?xml version="1.0" encoding="UTF-8"?>
<!-- 
	Generate the config file.
	<xslt
		in=".flexLibProperties"
		out="${config}"
	    style="config.xsl">
	</xslt>
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

	<xsl:template match="/">
		<flex-config>
			<include-classes>
				<xsl:for-each select="flexLibProperties/includeClasses/classEntry">
					<class>
						<xsl:value-of select="@path" />
					</class>
				</xsl:for-each>
			</include-classes>
			<namespaces>
				<xsl:apply-templates select="flexLibProperties/namespaceManifests" />
			</namespaces>
		</flex-config>
	</xsl:template>

	<xsl:template match="flexLibProperties/namespaceManifests">
		<!-- Specify a URI to associate with a manifest of components for use as MXML -->
		<!-- elements.                                                                -->
		<namespace>
			<uri>
				<xsl:value-of select="namespaceManifestEntry/@namespace" />
			</uri>
			<manifest>
				<xsl:value-of select="namespaceManifestEntry/@manifest" />
			</manifest>
		</namespace>
	</xsl:template>

</xsl:stylesheet>
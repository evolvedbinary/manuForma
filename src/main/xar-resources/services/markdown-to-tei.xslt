<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:m2t="http://markdown-2-tei"
  exclude-result-prefixes="xs"
  version="2.0">

  <!--
    Convert Markdown to TEI from manuForma forms
    @author Adam Retter
  -->

  <xsl:output method="xml" version="1.0" omit-xml-declaration="no" encoding="UTF-8" indent="yes"/>


  <xsl:template name="markdown-to-tei">
    <xsl:apply-templates select="." mode="markdown-to-tei"/>
  </xsl:template>

  <!-- Replace heading 1 Markdown with tei:hi h1 Element -->
  <xsl:template match="text()[matches(., '(^|[^#])#\s+.+')]" mode="markdown-to-tei">
    <xsl:apply-templates select="m2t:h1(.)" mode="#current"/>
  </xsl:template>

  <!-- Replace heading 2 Markdown with tei:hi h2 Element -->
  <xsl:template match="text()[matches(., '(^|[^#])##\s+.+')]" mode="markdown-to-tei">
    <xsl:apply-templates select="m2t:h2(.)" mode="#current"/>
  </xsl:template>

  <!-- Replace heading 3 Markdown with tei:hi h3 Element -->
  <xsl:template match="text()[matches(., '(^|[^#])###\s+.+')]" mode="markdown-to-tei">
    <xsl:apply-templates select="m2t:h3(.)" mode="#current"/>
  </xsl:template>

  <!-- Replace bold Markdown with tei:emph bold Element -->
  <xsl:template match="text()[matches(., '\*\*([^*]+)\*\*')]" mode="markdown-to-tei">
    <xsl:apply-templates select="m2t:bold(.)" mode="#current"/>
  </xsl:template>

  <!-- Replace italic Markdown with tei:emph italic Element -->
  <xsl:template match="text()[matches(., '(^|[^*\\])\*[^*]*[^*\\]\*([^*]|$)]')]" mode="markdown-to-tei">
    <xsl:apply-templates select="m2t:italic(.)" mode="#current"/>
  </xsl:template>

  <!-- Default: Identity trasform everything --> 
  <xsl:template match="node()|@*" mode="markdown-to-tei" priority="-3">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:function name="m2t:h1" as="node()+">
    <xsl:param name="markdown" as="text()" required="true"/>
    <xsl:analyze-string select="$markdown" regex="(^|[^#])#\s+(.+)">
      <xsl:matching-substring>
        <xsl:if test="m2t:non-empty(regex-group(1))"><xsl:value-of select="regex-group(1)"/></xsl:if><tei:hi rend="h1"><xsl:value-of select="normalize-space(regex-group(2))"/></tei:hi>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <xsl:function name="m2t:h2" as="node()+">
    <xsl:param name="markdown" as="text()" required="true"/>
    <xsl:analyze-string select="$markdown" regex="(^|[^#])##\s+(.+)">
      <xsl:matching-substring>
        <xsl:if test="m2t:non-empty(regex-group(1))"><xsl:value-of select="regex-group(1)"/></xsl:if><tei:hi rend="h2"><xsl:value-of select="normalize-space(regex-group(2))"/></tei:hi>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <xsl:function name="m2t:h3" as="node()+">
    <xsl:param name="markdown" as="text()" required="true"/>
    <xsl:analyze-string select="$markdown" regex="(^|[^#])###\s+(.+)">
      <xsl:matching-substring>
        <xsl:if test="m2t:non-empty(regex-group(1))"><xsl:value-of select="regex-group(1)"/></xsl:if><tei:hi rend="h3"><xsl:value-of select="normalize-space(regex-group(2))"/></tei:hi>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <xsl:function name="m2t:bold" as="node()+">
    <xsl:param name="markdown" as="text()" required="true"/>
    <xsl:analyze-string select="$markdown" regex="(^|[^\\])\*\*([^*]*[^*\\])\*\*">
      <xsl:matching-substring>
        <xsl:if test="m2t:non-empty(regex-group(1))"><xsl:value-of select="regex-group(1)"/></xsl:if><tei:emph rend="bold"><xsl:value-of select="regex-group(2)"/></tei:emph>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <xsl:function name="m2t:italic" as="node()+">
    <xsl:param name="markdown" as="text()" required="true"/>
    <xsl:analyze-string select="$markdown" regex="(^|[^*\\])\*([^*]*[^*\\])\*([^*]|$)">
      <xsl:matching-substring>
        <xsl:if test="m2t:non-empty(regex-group(1))"><xsl:value-of select="regex-group(1)"/></xsl:if><tei:emph rend="italic"><xsl:value-of select="regex-group(2)"/></tei:emph><xsl:if test="m2t:non-empty(regex-group(3))"><xsl:value-of select="regex-group(3)"/></xsl:if>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <xsl:function name="m2t:non-empty" as="xs:string*">
    <xsl:param name="inputs" as="xs:string*" required="true"/>
    <xsl:sequence select="$inputs[string-length(.) gt 0]"/>
  </xsl:function>

</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:t2m="http://tei-to-manuforma-form"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!--
    Convert TEI into a TEI like format suitable for use by a manuForma form
    @author Adam Retter
  -->
  
  
  <xsl:import href="tei-to-markdown.xslt"/>
  
  <xsl:output method="xml" version="1.0" omit-xml-declaration="no" encoding="UTF-8" indent="yes"/>
  
  
  <xsl:template match="tei:TEI">
    <xsl:copy>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="tei:note|tei:summary[not(parent::tei:layoutDesc)]|tei:quote|tei:ab[@type ne 'factoid' or @subtype ne 'relation']">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()" mode="tei-to-markdown"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="tei:reation[exists((@active, @mutual, @passive))]">
    <xsl:copy>
      <xsl:apply-templates select="@*[not(name(.) = ('active', 'mutual', 'passive'))]"/>
      
    </xsl:copy>
  </xsl:template>
  
  <!--
    case element(tei:relation) return 
            if($node[@mutual] or $node[@active] or $node[@passive]) then
                let $collection := '/db/apps/majlis-data/data'
                return 
                <relation xmlns="http://www.tei-c.org/ns/1.0">
                    {$node/@*[not(local-name() = 'mutual') and not(local-name() = 'active') and not(local-name() = 'passive')]}
                    {
                        let $active := 
                            if(contains($node/@active,' ')) then
                                for $a in tokenize($node/@active,' ')
                                let $ref := $a
                                let $doc := 
                                    (collection($collection)//tei:idno[@type='URI'][. = $ref]/ancestor::tei:TEI | 
                                    collection($collection)//tei:idno[@type='URI'][. = concat($ref,'/')]/ancestor::tei:TEI |
                                    collection($collection)//tei:idno[@type='URI'][. = concat($ref,'/tei')]/ancestor::tei:TEI)[1]
                                let $label := $doc/descendant::tei:title[1]/descendant-or-self::text()    
                                return  
                                    <active xmlns="http://www.tei-c.org/ns/1.0" ref="{$ref}">{normalize-space($label)}</active>
                            else 
                                let $ref := string($node/@active)
                                let $doc := 
                                    if($ref != '') then 
                                        (collection($collection)//tei:idno[@type='URI'][. = $ref]/ancestor::tei:TEI | 
                                        collection($collection)//tei:idno[@type='URI'][. = concat($ref,'/')]/ancestor::tei:TEI |
                                        collection($collection)//tei:idno[@type='URI'][. = concat($ref,'/tei')]/ancestor::tei:TEI)[1]
                                    else ()
                                let $label := $doc/descendant::tei:title[1]/descendant-or-self::text() 
                                return 
                                    <active xmlns="http://www.tei-c.org/ns/1.0" ref="{$ref}">{normalize-space($label)}</active>
                        let $passive := 
                            if(contains($node/@passive,' ')) then
                                for $p in tokenize($node/@passive,' ')
                                let $ref := $p
                                let $doc := 
                                    if($ref != '') then 
                                        (collection($collection)//tei:idno[@type='URI'][. = $ref]/ancestor::tei:TEI | 
                                        collection($collection)//tei:idno[@type='URI'][. = concat($ref,'/')]/ancestor::tei:TEI |
                                        collection($collection)//tei:idno[@type='URI'][. = concat($ref,'/tei')]/ancestor::tei:TEI)[1]
                                    else ()
                                let $label := $doc/descendant::tei:title[1]/descendant-or-self::text()    
                                return  
                                    <passive xmlns="http://www.tei-c.org/ns/1.0" ref="{$ref}">{normalize-space($label)}</passive>
                            else 
                                let $ref := string($node/@passive)
                                let $doc := 
                                    if($ref != '') then 
                                        (collection($collection)//tei:idno[@type='URI'][. = $ref]/ancestor::tei:TEI | 
                                        collection($collection)//tei:idno[@type='URI'][. = concat($ref,'/')]/ancestor::tei:TEI |
                                        collection($collection)//tei:idno[@type='URI'][. = concat($ref,'/tei')]/ancestor::tei:TEI)[1]
                                    else ()
                                let $label := $doc/descendant::tei:title[1]/descendant-or-self::text() 
                                return
                                    <passive xmlns="http://www.tei-c.org/ns/1.0" ref="{$ref}">{normalize-space($label)}</passive>
                        let $mutual := 
                            if(contains($node/@mutual,' ')) then
                                for $m in tokenize($node/@mutual,' ')
                                let $ref := $m
                                let $doc := 
                                    if($ref != '') then 
                                        (collection($collection)//tei:idno[@type='URI'][. = $ref]/ancestor::tei:TEI | 
                                        collection($collection)//tei:idno[@type='URI'][. = concat($ref,'/')]/ancestor::tei:TEI |
                                        collection($collection)//tei:idno[@type='URI'][. = concat($ref,'/tei')]/ancestor::tei:TEI)[1]
                                    else ()
                                let $label := $doc/descendant::tei:title[1]/descendant-or-self::text()  
                                return  
                                    <mutual xmlns="http://www.tei-c.org/ns/1.0" ref="{$ref}">{normalize-space($label)}</mutual>
                            else 
                                let $ref := string($node/@mutual)
                                let $doc := 
                                    if($ref != '') then 
                                        (collection($collection)//tei:idno[@type='URI'][. = $ref]/ancestor::tei:TEI | 
                                        collection($collection)//tei:idno[@type='URI'][. = concat($ref,'/')]/ancestor::tei:TEI |
                                        collection($collection)//tei:idno[@type='URI'][. = concat($ref,'/tei')]/ancestor::tei:TEI)[1]
                                    else ()
                                let $label := $doc/descendant::tei:title[1]/descendant-or-self::text()     
                                return 
                                    <mutual xmlns="http://www.tei-c.org/ns/1.0" ref="{$ref}">{normalize-space($label)}</mutual>
                       return ($active,$passive,$mutual)
                        
                    }
                    {local:markdown($node/node())}
                </relation>
  -->
  
  <!-- Default: Normalize space in text nodes -->
  <xsl:template match="text()" priority="-1">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>
  
  <!-- Default: Identity trasform everything whilst updating the 'source' attribute -->
  <xsl:template match="node()|@*" priority="-2">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
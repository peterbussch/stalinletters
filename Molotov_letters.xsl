<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xhtml" html-version="5" omit-xml-declaration="no" include-content-type="no"
        indent="yes"/>
    <!-- <xsl:sort select='translate(., "&apos;", "")'/> 
     <xsl:template match="line">
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::line">
            <br/>
            <xsl:text>&#x0A;</xsl:text>
        </xsl:if>
    </xsl:template> -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Stalin's Letters to Molotov</title>
            </head>
            <body>
                <h1>Letters between Joseph Stalin and Vyacheslav Molotov</h1>
                <h2>Contents</h2>
                <ul>
                  <li><xsl:apply-templates select="//letter/@id" mode="toc"> </xsl:apply-templates></li>
                </ul>
                <hr/>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>
    <!-- toc -->
    <xsl:template match="letter" mode="toc">
        <ul>
            <li>
                <a href="#letter{@id}">
                   <ul> <xsl:text> (</xsl:text>
                    <xsl:apply-templates select="@id"/>
                       <xsl:text>)</xsl:text> </ul>
                </a>
            </li>
        </ul>
    </xsl:template>
    <xsl:template match="line">
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::line">
            <br/>
        </xsl:if>
    </xsl:template>
    <!-- letters-->
    <xsl:template match="letter">
        <section id="letter{@id}">
            <h2>
                <xsl:apply-templates select="@id"/>
            </h2>
            <p>
                <xsl:apply-templates select="body"/>
            </p>
        </section>
    </xsl:template>

</xsl:stylesheet>

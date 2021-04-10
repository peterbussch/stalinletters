<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xhtml" html-version="5" omit-xml-declaration="no" include-content-type="no"
        indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Stalin's Letters to Molotov</title>
            </head>
            <body>
                <h1>Letters between Joseph Stalin and Vyacheslav Molotov</h1>
                <h2>Contents</h2>
                <xsl:apply-templates select="//letter" mode="toc"> </xsl:apply-templates>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>

    <!-- toc -->
    <xsl:template match="letter" mode="toc">
        <ul>
            <strong>
                <a href="#letter{@id}">
                    <xsl:text> (</xsl:text>
                    <xsl:apply-templates select="@id"/>
                    <xsl:text>)</xsl:text>
                </a>
                <xsl:text> </xsl:text>
            </strong>


            <a href="#letter{@id}">
                <em>
                    <xsl:apply-templates select="date" mode="toc"/>
                    <xsl:apply-templates select="@year"/>
                    <xsl:text> </xsl:text>
                </em>
                <xsl:apply-templates select="body/opening" mode="toc"/>
                <xsl:apply-templates select="opening"/>
            </a>
        </ul>

    </xsl:template>

    <xsl:template match="letter/body" mode="toc">
        <a href="//body/opening">
            <xsl:text> (</xsl:text>
            <xsl:apply-templates select="opening"/>
            <xsl:text>)</xsl:text>
        </a>
    </xsl:template>

    <!--   <xsl:text> (</xsl:text>
    <xsl:apply-templates select="opening"/>
    <xsl:text>)</xsl:text> -->


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

    <xsl:template match="//letter/date/@year" mode="toc">
        <xsl:apply-templates/>
    </xsl:template>
    
</xsl:stylesheet>

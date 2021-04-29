<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg"
    version="3.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="barWidth" select="20" as="xs:integer"/>
    <xsl:variable name="interbarSpacing" select="$barWidth div 2" as="xs:double"/>
    <xsl:variable name="barInterval" select="$barWidth + $interbarSpacing" as="xs:double"/>
    <xsl:variable name="yScale" select="300" as="xs:integer"/>
    <xsl:template match="/">
        <svg height="{1.5 * $yScale}">
            <g transform="translate(30, 330)">
                <line x1="0" x2="{count(//policy) * $barInterval + $interbarSpacing}"
                    y1="-{$yScale div 2}" y2="-{$yScale div 2}" stroke="lightgray"
                    stroke-dasharray="8 4" stroke-width="1"/>
                <xsl:apply-templates select="//policy"/>
                <xsl:variable name="xAxisLength" as="xs:double"
                    select="count(//policy) * $barInterval + $interbarSpacing"/>
                <line x1="0" x2="{$xAxisLength}" y1="0" y2="0" stroke="black" stroke-width="1"
                    stroke-linecap="square"/>
                <line x1="0" x2="0" y1="0" y2="-{$yScale}" stroke="black" stroke-width="1"
                    stroke-linecap="square"/>
                <text x="-5" y="0" text-anchor="end" dominant-baseline="middle">0</text>
                <text x="-5" y="-{$yScale div 2}" text-anchor="end" dominant-baseline="middle"
                    >50</text>
                <text x="-5" y="-{$yScale}" text-anchor="end" dominant-baseline="middle">100</text>
                <text x="{$xAxisLength div 2}" y="50" text-anchor="middle" font-size="x-large"
                    >Policy</text>
                <text x="-50" y="-{$yScale div 2}" text-anchor="middle" writing-mode="tb"
                    font-size="x-large">Policy by Year</text>
                <text x="{$xAxisLength div 2}" y="90" text-anchor="middle" font-size="xx-large"
                    >Number of Policy References</text>
            </g>
        </svg>
<!-- When I tested out the svg within svg 1.1, I was able to get the outline of the bar graph, but I am unsure what I should do to input the policy data within the graph.-->
    </xsl:template>
    <xsl:template match="policy">
        <xsl:variable name="policyYear" select="position()" as="xs:integer"/>
        <xsl:variable name="xPosition" select="$policyYear * $barInterval + $interbarSpacing"
            as="xs:double"/>
        <xsl:variable name="midBarPostion" as="xs:double" select="$xPosition + $barWidth div 2"/>
        <xsl:variable name="totalPolicys" select="sum(policy)" as="xs:double"/>
        <xsl:variable name="typePolicys" select="policy[@name = 'Weight (Poods)'| 'Trade Export' | 'Construction' | 'Industrialization' | 'Military' | 'Rubles' | 'Technology Dev' | 'Agricultural Industry' | 'Trade Import' | 'International Relations' | 'Cooperative Farms' | 'Kolkhoz' | 'Imperialism' | 'Schooling' | 'Anti-Bureaucracy' | 'Sovkhoz' | 'Constitution']" as="xs:integer"/>
<!-- Should I create a new xsl:variable for each policy element and name attribute or is the way I listed the text okay? -->
        <xsl:variable name="barHeight" as="xs:double" select="$totalPolicys * $yScale"/>
        <xsl:variable name="acro" select="@acro" as="xs:string"/>
        <xsl:variable name="barColor" as="xs:string" select="
            if ($Construction ge 1) then
            'blue'
            "/>
<!-- Am I going about coloring the bar graphs appropriately? Similar to the policy types, should I create an xsl:variable to give each text its own color or am I able to do so within one xsl:variable? -->
        <rect x="{$xPosition}" y="-{$barHeight}" stroke="black" stroke-width=".5" fill="{$barColor}"
            width="{$barWidth}" height="{$barHeight}"/>
        <text x="{$midBarPostion}" y="20" text-anchor="middle" fill="black" font-size="small">
            <xsl:value-of select="$acro"/>
        </text>
        <text x="{$midBarPostion}" y="-{$barHeight + 5}" text-anchor="middle" fill="black"
            font-size="small">
        </text>
    </xsl:template>
</xsl:stylesheet>

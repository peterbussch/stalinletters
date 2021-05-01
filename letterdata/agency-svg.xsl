<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg"
    version="3.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">
    <!-- ========================================================== -->
    <!-- SVG is XML, so use the "xml" output method                 -->
    <!-- ========================================================== -->    
    <xsl:output method="xml" indent="yes"/>
    <!-- ========================================================== -->
    <!-- Stylesheet variables                                       -->
    <!--                                                            -->
    <!-- $barWidth : width of rectangular bar                       -->
    <!-- $interbarSpacing : space between the right edge of one bar -->
    <!--    and the left edge of the next                           -->
    <!-- $barInterval : distance between the left sides of adjacent -->
    <!--    bars, equal to $barWidth plus $interbarSpacing          -->
    <!-- $yScale : multiplier so that bars are not too short        -->
    <!-- ========================================================== -->
    <xsl:variable name="barWidth" select="20" as="xs:integer"/>
    <xsl:variable name="interbarSpacing" select="$barWidth div 2" as="xs:double"/>
    <xsl:variable name="barInterval" select="$barWidth + $interbarSpacing" as="xs:double"/>
    <xsl:variable name="yScale" select="300" as="xs:integer"/>
    <!-- ========================================================== -->
    <!-- Templates                                                  -->
    <!-- ========================================================== -->
    <xsl:template match="/">
        <svg height="100%" width="665%">
            <!--<svg height="{1.2 * $yScale}">-->
            <g transform="translate(30, 330)">
                <!-- ============================================== -->
                <!-- Plot in upper right, move down with @transform -->
                <!-- Draw in z-index order: ruling, bars, axes      -->
                <!-- ============================================== -->
                <!-- Dashed line at 50% on the y axis               -->
                <!-- ============================================== -->
                <!-- Ruling line                                    -->
                <line x1="{20}" x2="{count(//letter) * $barInterval + 20}" y1="-{$yScale div 2}"
                    y2="-{$yScale div 2}" stroke="lightgray" stroke-dasharray="8 4" stroke-width="1"/>
                <!-- ============================================== -->
                <!-- Bars for letters                                -->
                <!-- ============================================== -->
                <xsl:apply-templates select="//letter"/>
                <!-- ============================================== -->
                <!-- Axes and labels                                -->
                <!-- X axis length computed from number of states   -->
                <!-- Y axis height computed from $yScale, with      -->
                <!--     added space for labels                     -->
                <!-- ============================================== -->
                <line x1="20" x2="20" y1="0" y2="-320" stroke="black" stroke-width="1"
                    stroke-linecap="square"/>
                <line x1="20" x2="{count(//letter) * $barInterval + 20}" y1="0" y2="0" stroke="black"
                    stroke-width="1" stroke-linecap="square"/>
                <text x="10" y="0" text-anchor="end" dominant-baseline="middle">0%</text>
                <text x="10" y="-{$yScale div 2}" text-anchor="end" dominant-baseline="middle"
                    >50%</text>
                <text x="10" y="-{$yScale}" text-anchor="end" dominant-baseline="middle">100%</text>
            </g>
        </svg>
    </xsl:template>
    <xsl:template match="letter">
        <!-- ====================================================== -->
        <!-- Template variables are different for each state        -->
        <!-- ====================================================== -->
        <xsl:variable name="statePos" select="position()" as="xs:integer"/>
        <xsl:variable name="xPosition" select="$statePos * $barInterval" as="xs:double"/>
        <xsl:variable name="policyRef" select="count(body/agency) div 20" as="xs:double"/>
        <!--<xsl:variable name="publicationRef" select="count(body/publication) div 20" as="xs:double"/>-->
        <!-- <xsl:variable name="barColor" as="xs:string" select="
            if ($policy ge 1) then
            'green'
            "/>
        <xsl:variable name="publicationRef" select="count(body/publication) div 20" as="xs:double"/>
        <xsl:variable name="barColor" as="xs:string" select="
            if ($publication ge 1) then
            'red'
            "/>-->
        <!-- <xsl:variable name="typePolicy" select="count(policy[@name = 'Construction'])" as="xs:integer"/>
        <xsl:variable name="barColor" as="xs:string" select="
            if ($Construction ge 1) then
            'green'
            "/>
        <xsl:variable name="typePolicy" select="count(policy[@name = 'Industrialization'])" as="xs:integer"/>
        <xsl:variable name="barColor" as="xs:string" select="
            if ($Industrialization ge 1) then
            'red'
            "/>-->
        <!--<xsl:variable name="demVotes" select="candidate[@party = 'Democrat']" as="xs:integer"/>
        <xsl:variable name="demPer" select="$demVotes div $totalVotes" as="xs:double"/>-->
        <xsl:variable name="letterID" select="@id" as="xs:string"/>
        <!-- ====================================================== -->
        <rect x="{$xPosition}" y="-{$policyRef * $yScale}" stroke="black" stroke-width=".5" fill="blue"
            width="{$barWidth}" height="{$policyRef * $yScale}"/>
        <text x="{$xPosition + $barWidth div 2}" y="20" text-anchor="middle">
            <xsl:value-of select="$letterID"/>
        </text>
    </xsl:template>
</xsl:stylesheet>

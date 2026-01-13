<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg"
    xmlns:math="http://exslt.org/math" xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="math exsl"
    version="1.0">
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Variables for pie chart dimensions -->
    <xsl:variable name="centerX" select="500"/>
    <xsl:variable name="centerY" select="350"/>
    <xsl:variable name="radius" select="250"/>
    <xsl:variable name="pi" select="3.141592653589793"/>
    
    <!-- Get all policies and calculate totals -->
    <xsl:variable name="allPolicies" select="//policy"/>
    <xsl:variable name="totalPolicies" select="count($allPolicies)"/>
    
    <!-- Muenchian grouping key -->
    <xsl:key name="policy-by-name" match="policy" use="@name"/>
    
    <!-- Policy name mapping to display labels -->
    <xsl:template name="getDisplayName">
        <xsl:param name="policyName"/>
        <xsl:choose>
            <xsl:when test="$policyName = 'Kolkhoz'">Collective Farms</xsl:when>
            <xsl:when test="$policyName = 'Trade Export'">Export (Trade)</xsl:when>
            <xsl:when test="$policyName = 'Trade Import'">Import (Trade)</xsl:when>
            <xsl:when test="$policyName = 'International Relations'">Foreign Policy</xsl:when>
            <xsl:when test="$policyName = 'Technology Dev'">Technology</xsl:when>
            <xsl:when test="$policyName = 'Agricultural Industry'">Agricultural</xsl:when>
            <xsl:when test="$policyName = 'Anti-Bureaucracy'">Bureaucracy</xsl:when>
            <xsl:when test="$policyName = 'Schooling'">Education</xsl:when>
            <xsl:when test="$policyName = 'Cooperative Farms'">Cooperatives</xsl:when>
            <xsl:when test="$policyName = 'Industrialization'">Industry</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$policyName"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Color mapping for policy types -->
    <xsl:template name="getColor">
        <xsl:param name="displayName"/>
        <xsl:choose>
            <xsl:when test="$displayName = 'Technology'">#87CEEB</xsl:when>
            <xsl:when test="$displayName = 'Agricultural'">#DC143C</xsl:when>
            <xsl:when test="$displayName = 'Bureaucracy'">#00008B</xsl:when>
            <xsl:when test="$displayName = 'Collective Farms'">#FFA500</xsl:when>
            <xsl:when test="$displayName = 'Constitution'">#228B22</xsl:when>
            <xsl:when test="$displayName = 'Construction'">#FF8C00</xsl:when>
            <xsl:when test="$displayName = 'Cooperatives'">#008B8B</xsl:when>
            <xsl:when test="$displayName = 'Education'">#4682B4</xsl:when>
            <xsl:when test="$displayName = 'Export (Trade)'">#FA8072</xsl:when>
            <xsl:when test="$displayName = 'Foreign Policy'">#F0E68C</xsl:when>
            <xsl:when test="$displayName = 'Import (Trade)'">#90EE90</xsl:when>
            <xsl:when test="$displayName = 'Industry'">#FFD700</xsl:when>
            <xsl:otherwise>#CCCCCC</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Convert degrees to radians -->
    <xsl:template name="degToRad">
        <xsl:param name="degrees"/>
        <xsl:value-of select="$degrees * $pi div 180"/>
    </xsl:template>
    
    <!-- Get cosine using EXSLT math -->
    <xsl:template name="cos">
        <xsl:param name="rad"/>
        <xsl:value-of select="math:cos($rad)"/>
    </xsl:template>
    
    <!-- Get sine using EXSLT math -->
    <xsl:template name="sin">
        <xsl:param name="rad"/>
        <xsl:value-of select="math:sin($rad)"/>
    </xsl:template>
    
    <xsl:template match="/">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 700" style="background-color: #8B0000;">
            <!-- White circular background for chart -->
            <circle cx="{$centerX}" cy="{$centerY}" r="{$radius}" fill="white" stroke="black" stroke-width="2"/>
            
            <!-- Group for pie chart slices and labels -->
            <g>
                <!-- Get unique policy names using Muenchian grouping -->
                <xsl:for-each select="$allPolicies[generate-id() = generate-id(key('policy-by-name', @name)[1])]">
                    <xsl:sort select="count(key('policy-by-name', @name))" order="descending" data-type="number"/>
                    
                    <xsl:variable name="policyName" select="@name"/>
                    <xsl:variable name="count" select="count(key('policy-by-name', $policyName))"/>
                    <xsl:variable name="percentage" select="($count div $totalPolicies) * 100"/>
                    
                    <xsl:variable name="displayNameVar">
                        <xsl:call-template name="getDisplayName">
                            <xsl:with-param name="policyName" select="$policyName"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="displayName" select="string($displayNameVar)"/>
                    
                    <xsl:variable name="colorVar">
                        <xsl:call-template name="getColor">
                            <xsl:with-param name="displayName" select="$displayName"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="color" select="string($colorVar)"/>
                    
                    <!-- Calculate start angle: sum of all previous counts -->
                    <xsl:variable name="currentPos" select="position()"/>
                    <xsl:variable name="startAngle">
                        <xsl:choose>
                            <xsl:when test="$currentPos = 1">-90</xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="prevCount">
                                    <xsl:call-template name="sumPreviousCounts">
                                        <xsl:with-param name="currentPos" select="$currentPos"/>
                                        <xsl:with-param name="allPolicies" select="$allPolicies"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:value-of select="-90 + ($prevCount div $totalPolicies) * 360"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <xsl:variable name="sliceAngle" select="($percentage div 100) * 360"/>
                    <xsl:variable name="endAngle" select="$startAngle + $sliceAngle"/>
                    <xsl:variable name="midAngle" select="$startAngle + ($sliceAngle div 2)"/>
                    
                    <!-- Draw pie slice -->
                    <xsl:call-template name="drawPieSlice">
                        <xsl:with-param name="startAngle" select="$startAngle"/>
                        <xsl:with-param name="endAngle" select="$endAngle"/>
                        <xsl:with-param name="color" select="$color"/>
                    </xsl:call-template>
                    
                    <!-- Draw label with connecting line -->
                    <xsl:call-template name="drawLabel">
                        <xsl:with-param name="angle" select="$midAngle"/>
                        <xsl:with-param name="label">
                            <xsl:value-of select="$displayName"/>
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="format-number($percentage, '#.#')"/>
                            <xsl:text>%)</xsl:text>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:for-each>
            </g>
        </svg>
    </xsl:template>
    
    <!-- Template to sum counts of previous policy groups -->
    <xsl:template name="sumPreviousCounts">
        <xsl:param name="currentPos"/>
        <xsl:param name="allPolicies"/>
        <xsl:variable name="sum">
            <xsl:for-each select="$allPolicies[generate-id() = generate-id(key('policy-by-name', @name)[1])]">
                <xsl:sort select="count(key('policy-by-name', @name))" order="descending" data-type="number"/>
                <xsl:if test="position() &lt; $currentPos">
                    <item><xsl:value-of select="count(key('policy-by-name', @name))"/></item>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="sumNodes" select="exsl:node-set($sum)"/>
        <xsl:value-of select="sum($sumNodes/item)"/>
    </xsl:template>
    
    <!-- Template to draw a pie slice -->
    <xsl:template name="drawPieSlice">
        <xsl:param name="startAngle"/>
        <xsl:param name="endAngle"/>
        <xsl:param name="color"/>
        
        <xsl:variable name="startRadVar">
            <xsl:call-template name="degToRad">
                <xsl:with-param name="degrees" select="$startAngle"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="startRad" select="number($startRadVar)"/>
        
        <xsl:variable name="endRadVar">
            <xsl:call-template name="degToRad">
                <xsl:with-param name="degrees" select="$endAngle"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="endRad" select="number($endRadVar)"/>
        
        <xsl:variable name="cosStart">
            <xsl:call-template name="cos">
                <xsl:with-param name="rad" select="$startRad"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="sinStart">
            <xsl:call-template name="sin">
                <xsl:with-param name="rad" select="$startRad"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="cosEnd">
            <xsl:call-template name="cos">
                <xsl:with-param name="rad" select="$endRad"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="sinEnd">
            <xsl:call-template name="sin">
                <xsl:with-param name="rad" select="$endRad"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="x1" select="$centerX + $radius * number($cosStart)"/>
        <xsl:variable name="y1" select="$centerY - $radius * number($sinStart)"/>
        <xsl:variable name="x2" select="$centerX + $radius * number($cosEnd)"/>
        <xsl:variable name="y2" select="$centerY - $radius * number($sinEnd)"/>
        
        <xsl:variable name="angleDiff" select="$endAngle - $startAngle"/>
        <xsl:variable name="largeArc">
            <xsl:choose>
                <xsl:when test="$angleDiff > 180">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <path d="M {$centerX},{$centerY} L {$x1},{$y1} A {$radius},{$radius} 0 {$largeArc},1 {$x2},{$y2} Z"
            fill="{$color}" stroke="black" stroke-width="1"/>
    </xsl:template>
    
    <!-- Template to draw label with connecting line -->
    <xsl:template name="drawLabel">
        <xsl:param name="angle"/>
        <xsl:param name="label"/>
        
        <xsl:variable name="radVar">
            <xsl:call-template name="degToRad">
                <xsl:with-param name="degrees" select="$angle"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="rad" select="number($radVar)"/>
        
        <xsl:variable name="cosRad">
            <xsl:call-template name="cos">
                <xsl:with-param name="rad" select="$rad"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="sinRad">
            <xsl:call-template name="sin">
                <xsl:with-param name="rad" select="$rad"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="labelRadius" select="$radius + 50"/>
        <xsl:variable name="labelX" select="$centerX + $labelRadius * number($cosRad)"/>
        <xsl:variable name="labelY" select="$centerY - $labelRadius * number($sinRad)"/>
        <xsl:variable name="lineEndX" select="$centerX + $radius * number($cosRad)"/>
        <xsl:variable name="lineEndY" select="$centerY - $radius * number($sinRad)"/>
        
        <!-- Connecting line -->
        <line x1="{$lineEndX}" y1="{$lineEndY}" x2="{$labelX}" y2="{$labelY}" 
            stroke="gray" stroke-width="1"/>
        
        <!-- Label text -->
        <xsl:variable name="textAnchor">
            <xsl:choose>
                <xsl:when test="$labelX &lt; $centerX">end</xsl:when>
                <xsl:otherwise>start</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <text x="{$labelX}" y="{$labelY}" font-family="serif" font-size="14" fill="black"
            text-anchor="{$textAnchor}" dominant-baseline="middle">
            <xsl:value-of select="$label"/>
        </text>
    </xsl:template>
    
</xsl:stylesheet>

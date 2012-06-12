<!--
////////////////////////////////////////////////////////////////////////////////
// Copyright 2012, Qualcomm Innovation Center, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
////////////////////////////////////////////////////////////////////////////////
-->
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="fileName"/>
<xsl:param name="baseFileName"/>

<xsl:output method="text" version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>

<xsl:template match="/">////////////////////////////////////////////////////////////////////////////////
//
//  ALLJOYN MODELING TOOL - GENERATED CODE
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//  <xsl:value-of select="$baseFileName"/>.h
//
////////////////////////////////////////////////////////////////////////////////

#import "AJN<xsl:value-of select="$baseFileName"/>.h"

<xsl:apply-templates match=".//node" mode="objc-category-declaration"/>

</xsl:template>

<xsl:template match="node" mode="objc-category-declaration">
////////////////////////////////////////////////////////////////////////////////
//
//  <xsl:value-of select="./annotation[@name='org.alljoyn.lang.objc']/@value"/>
//
////////////////////////////////////////////////////////////////////////////////

@interface <xsl:value-of select="./annotation[@name='org.alljoyn.lang.objc']/@value" /> : AJN<xsl:value-of select="./annotation[@name='org.alljoyn.lang.objc']/@value" />

@end

////////////////////////////////////////////////////////////////////////////////

</xsl:template>

<xsl:template match="interface" mode="objc-interface-list">
    <xsl:if test="position() > 1">, </xsl:if>
    <xsl:value-of select="./annotation[@name='org.alljoyn.lang.objc']/@value"/>
</xsl:template>

<xsl:template match="method" mode="objc-declaration">
    <xsl:text>- (</xsl:text>
    <xsl:choose>
        <xsl:when test="count(./arg[@direction='out']) > 1 or count(./arg[@direction='out']) = 0">
            <xsl:text>void</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="./arg[@direction='out']" mode="objc-argType"/>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>)</xsl:text>
    <xsl:choose>
        <xsl:when test="count(./arg) = 0 or (count(./arg) = 1 and count(./arg[@direction='out']) = 1)">
            <xsl:value-of select="@name"/>
        </xsl:when>
        <xsl:when test="count(./arg[@direction='out']) > 1">
            <xsl:apply-templates select="./arg[@direction='in']" mode="objc-messageParam"/>
            <xsl:if test="count(./arg[@direction='in']) > 1">
                <xsl:text>&#32;</xsl:text>
            </xsl:if>
            <xsl:apply-templates select="./arg[@direction='out']" mode="objc-messageParam"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="./arg[@direction='in']" mode="objc-messageParam"/>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>;&#13;&#10;</xsl:text>
</xsl:template>

<xsl:template match="signal" mode="objc-declaration">
    <xsl:text>- (void)send</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>:</xsl:text>
    <xsl:if test="count(./arg) > 0">
        <xsl:apply-templates select="./arg" mode="objc-messageParam"/>
        <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:text>inSession:(AJNSessionId)sessionId toDestination:(NSString*)destinationPath</xsl:text>
    <xsl:text>;&#13;&#10;</xsl:text>
</xsl:template>

<xsl:template match="property" mode="objc-declaration">
    <xsl:text>@property (nonatomic,</xsl:text>
    <xsl:choose>
        <xsl:when test="@access='readwrite'">
            <xsl:if test="@type!='b'">
                <xsl:text> strong</xsl:text>
            </xsl:if>
        </xsl:when>
        <xsl:when test="@access='read'">
            <xsl:text> readonly</xsl:text>
        </xsl:when>
    </xsl:choose>
    <xsl:text>) </xsl:text>
    <xsl:call-template name="objcArgType"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>;&#13;&#10;</xsl:text>
</xsl:template>

<xsl:template match="arg" mode="objc-messageParam">
    <xsl:if test="position() > 1">
        <xsl:text>&#32;</xsl:text>
    </xsl:if>
    <xsl:value-of select="./annotation[@name='org.alljoyn.lang.objc']/@value" />
    <xsl:text>(</xsl:text>
        <xsl:apply-templates select="." mode="objc-argType"/>
        <xsl:if test="@direction='out'">
            <xsl:text>*</xsl:text>
        </xsl:if>
    <xsl:text>)</xsl:text>
    <xsl:value-of select="@name"/>
</xsl:template>

<xsl:template match="arg" mode="objc-argType">
    <xsl:call-template name="objcArgType"/>
</xsl:template>

<xsl:template name="objcArgType">
    <xsl:choose>
        <xsl:when test="@type='y'">
            <xsl:text>NSNumber*</xsl:text>
        </xsl:when>
        <xsl:when test="@type='b'">
            <xsl:text>BOOL</xsl:text>
        </xsl:when>
        <xsl:when test="@type='n'">
            <xsl:text>NSNumber*</xsl:text>
        </xsl:when>
        <xsl:when test="@type='q'">
            <xsl:text>NSNumber*</xsl:text>
        </xsl:when>
        <xsl:when test="@type='i'">
            <xsl:text>NSNumber*</xsl:text>
        </xsl:when>
        <xsl:when test="@type='u'">
            <xsl:text>NSNumber*</xsl:text>
        </xsl:when>
        <xsl:when test="@type='x'">
            <xsl:text>NSNumber*</xsl:text>
        </xsl:when>
        <xsl:when test="@type='t'">
            <xsl:text>NSNumber*</xsl:text>
        </xsl:when>
        <xsl:when test="@type='d'">
            <xsl:text>NSNumber*</xsl:text>
        </xsl:when>
        <xsl:when test="@type='s'">
            <xsl:text>NSString*</xsl:text>
        </xsl:when>
        <xsl:when test="@type='o'">
            <xsl:text>NString*</xsl:text>
        </xsl:when>
        <xsl:when test="@type='a'">
            <xsl:text>NSArray*</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>==== ERROR: UNKNOWN DBUS TYPE SPECIFIED ("</xsl:text><xsl:value-of select="@type"/><xsl:text>")====</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
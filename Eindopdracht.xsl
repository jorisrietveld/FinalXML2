<?xml version="1.0" encoding="UTF-8"?>
<!--
  -  Author: Joris Rietveld
  -  Created: 11-04-2019 04:47
  -  Licence: GPLv3 - General Public Licence version 3
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output method="html" version="5.0"/>

    <!-- Matched to the root, this contains the html skeleton.-->
    <xsl:template match="/">
        <html>
            <head>
                <title>Garages</title>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <link rel="stylesheet" type="text/css" href="style.css"/>
            </head>

            <body class="container">
                <!-- The navigation sidebar that lists all stored car dealers. -->
                <nav class="sidenav">
                    <a href="#top">Scroll to top</a>
                    <hr/>
                    <xsl:for-each select="Garages/Garage">
                        <a href="#{Website}">
                            <xsl:value-of select="./Naam"/>
                        </a>
                    </xsl:for-each>
                </nav>

                <!-- Holds the main content of the webpage  -->
                <main>
                    <header id="top">
                        <h1>Overzicht van Garages</h1>
                        <h4>Aantal gevonden garages:
                            <xsl:value-of select="count(Garages/Garage)"/>
                        </h4>
                    </header>

                    <!-- Renderes a article for each stored car dealer. -->
                    <xsl:apply-templates/>

                    <hr/>
                    <!-- This secion states the authors of the document. -->
                    <footer id="footer">
                        <h1>XML Eind opdracht gemaakt door:</h1>
                        <address class="authors">
                            <a href="https://github.com/DavidDorenbos" rel="author">David Dorenbos,</a>
                            <a href="https://github.com//IvarHuizing" rel="author">Ivar Huizing,</a>
                            <a href="https://github.com/MichielTombergen" rel="author">Michiel Tombergen,</a>
                            <a href="https://github.com/andrew946" rel="author">Andrej Rodzevic,</a>
                            <a href="https://github.com/" rel="author">Thomas Fluit,</a>
                            <a href="https://github.com/jorisrietveld" rel="author">Joris Rietveld</a>
                        </address>
                    </footer>
                </main>
            </body>
        </html>
    </xsl:template>

    <!-- This template renders a article that includes information about a car dealer. -->
    <xsl:template match="Garage">
        <hr/>
        <article id="{Website}" class="page">
            <header class="dealer-header">
                <h1>Garage:
                    <xsl:value-of select="Naam"/>
                </h1>
                <h5>
                    <xsl:value-of select="Omschrijving"/>
                </h5>

                <div class="row">
                    <table class="dealer-information column">
                        <thead>
                            <tr>
                                <th colspan="2">Gegevens van garage</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:apply-templates
                                    select="Telefoonnummer|Website|Email|Services|Automerken|Faciliteiten|Werkzaamheden|AangeslotenOrganizaties|Routebeschrijving"/>
                        </tbody>
                    </table>

                    <picture class="column">
                        <img src="" alt="The picture bla is not found."/>
                    </picture>
                </div>
            </header>

            <xsl:apply-templates select="Autos"/>

            <footer class="dealer-footer">
                <hr/>
                <address class="dealer-address">
                    Address
                    <xsl:value-of select="Naam"/>
                    <xsl:apply-templates select="Adres"/>
                </address>
            </footer>
        </article>
    </xsl:template>

    <xsl:template match="Adres">
        <span>
            <xsl:value-of select="Straat"/>
            <xsl:value-of select="Huisnummer"/>
        </span>
        <span>
            <xsl:value-of select="Postcode"/><xsl:value-of select="Plaats"/>
        </span>
        <xsl:value-of select="Provincie"/>
    </xsl:template>

    <xsl:template match="AangeslotenOrganizaties">

        <xsl:choose>
            <xsl:when test="@naam ='BOVAG'">
                <img src="images/bovag-garantie.png" alt="Aangesloten bij BOVAG"/>
            </xsl:when>
            <xsl:when test="@naam ='RDW'">
                <img src="images/bovag-garantie.png" alt="Erkend door de RDW"/>
            </xsl:when>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="VkOpeningstijden | WPOpeningstijden">
        <table>
            <caption>
                <xsl:choose>
                    <xsl:when test="local-name()='VkOpeningstijden'">
                        Openingstijden Winkel
                    </xsl:when>
                    <xsl:when test="local-name()='WPOpeningstijden'">
                        Openingstijden Werkplaats
                    </xsl:when>
                    <xsl:otherwise>
                        Geen aangesloten organizaties gevonden.
                    </xsl:otherwise>
                </xsl:choose>
            </caption>
            <thead>
                <tr>
                    <th>Dag</th>
                    <th>Geopend</th>
                    <th>Sluit</th>
                </tr>
            </thead>
            <tbody>
                <!-- Voor elke dag -->
                <xsl:for-each select="./*">
                    <xsl:variable name="opens" select="normalize-space(substring-before(.,  '-'))"/>
                    <xsl:variable name="closes" select="normalize-space(substring-after(.,  '-'))"/>
                    <tr>
                        <td>
                            <xsl:value-of select="local-name()"/>
                        </td>
                        <td>
                            <time datetime="{$opens}">
                                <xsl:value-of select="$opens"/>
                            </time>
                        </td>
                        <td>
                            <time datetime="{$closes}">
                                <xsl:value-of select="$closes"/>
                            </time>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template match="Services|Automerken|Werkzaamheden">
        <tr>
            <td>
                <xsl:value-of select="local-name(.)"/>
            </td>
            <td>
                <xsl:for-each select=".">
                    <xsl:value-of select="."/>&#160;
                </xsl:for-each>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="Email|Telefoonnummer">
        <tr>
            <td>
                <xsl:value-of select="local-name(.)"/>
            </td>
            <td>
                <xsl:value-of select="."/>&#160;
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="Website|Routebeschrijving">
        <tr>
            <td>
                <xsl:value-of select="local-name(.)"/>
            </td>
            <td>
                <a href="{.}">
                    <xsl:value-of select="."/>
                </a>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="Faciliteiten/*">
        <xsl:choose>
            <xsl:when test="local-name() = 'Pompen'">
                <tr>
                    <td>
                        Pompen beschibaar
                    </td>
                    <td>
                        <xsl:value-of select="count(*)"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        Brandstof beschibaar
                    </td>
                    <td>
                        <xsl:for-each select="Pomp/Brandstoffen/*">
                            <xsl:value-of select="local-name(.)"/>&#160;
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:when>
            <xsl:otherwise>
                <tr>
                    <td>
                        Faciliteiten
                    </td>
                    <td>
                        <xsl:value-of select="local-name(.)"/>
                    </td>
                </tr>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="Autos">
        <section>
            <h2>Auto's te koop</h2>
            <xsl:apply-templates select="Auto"/>
        </section>
    </xsl:template>

    <xsl:template match="Auto">
        <xsl:variable name="apk-expires" select=" concat(
                      normalize-space(string(DatumAPK/Dag)),
                      normalize-space(string(DatumAPK/Maand)),
                      normalize-space(string(DatumAPK/Jaar) ))"/>
        <hr/>
        <h4>
            <xsl:value-of select="Automerk"/><xsl:value-of select="Type"/>
        </h4>
        <table class="car-information">
            <thead>
                <tr>
                    <th colspan="2">Informatie</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Merk</td>
                    <td>
                        <xsl:value-of select="Automerk"/>
                    </td>
                </tr>
                <tr>
                    <td>Types</td>
                    <td>
                        <xsl:value-of select="Type"/>
                    </td>
                </tr>
                <tr>
                    <td>Bouwjaar</td>
                    <td>
                        <xsl:value-of select="Automerk"/>
                    </td>
                </tr>
                <tr>
                    <td>Brandstof</td>
                    <td>
                        <xsl:value-of select="local-name(Brandstof/.)"/>
                    </td>
                </tr>
                <tr>
                    <td>Bouwjaar</td>
                    <td>
                        <time datetime="{Bouwjaar}">
                            <xsl:value-of select="Bouwjaar"/>
                        </time>
                    </td>
                </tr>
                <tr>
                    <td>APK geldig tot</td>
                    <td>
                        <time datetime="{$apk-expires}">
                            <xsl:value-of select="$apk-expires"/>
                        </time>
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template match="Medewerkers">

    </xsl:template>
</xsl:stylesheet>
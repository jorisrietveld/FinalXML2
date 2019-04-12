<?xml version="1.0" encoding="UTF-8"?>
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
                    <a href="#page-header">Scroll to top</a>
                    <hr/>
                    <!-- Generate links that scroll to a car dealer -->
                    <xsl:for-each select="Garages/Garage">
                        <a href="#{Website}">
                            <xsl:value-of select="./Naam"/>
                        </a>
                    </xsl:for-each>
                </nav>

                <!-- Holds the main content of the webpage  -->
                <main>
                    <header id="page-header" class="">
                        <h1>Garage Overzicht NL</h1>
                        <xsl:call-template name="statistics"/>

                    </header>

                    <!-- Renderes a article for each stored car dealer. -->
                    <xsl:apply-templates/>

                    <!-- This secion states the authors of the document. -->
                    <footer id="footer">
                        <h1>XML Eind opdracht gemaakt door:</h1>
                        <address class="authors">
                            <a href="https://github.com/DavidDorenbos" rel="author">&#8982; David Dorenbos,</a>
                            <a href="https://github.com//IvarHuizing" rel="author">&#8982; Ivar Huizing,</a>
                            <a href="https://github.com/MichielTombergen" rel="author">&#8982; Michiel Tombergen,</a>
                            <a href="https://github.com/andrew946" rel="author">&#8982; Andrej Rodzevic,</a>
                            <a href="https://github.com/" rel="author">&#8982; Thomas Fluit,</a>
                            <a href="https://github.com/jorisrietveld" rel="author">&#8982; Joris Rietveld</a>
                        </address>
                    </footer>
                </main>
            </body>
        </html>
    </xsl:template>

    <!-- This template renders a article that includes information about a car dealer. -->
    <xsl:template match="Garage">
        <article id="{Website}" class="page">
            <header class="dealer-header text-center">
                <h1 class="align-center">Garage:
                    <xsl:value-of select="Naam"/>
                </h1>
                <h5 class="align-center">
                    <xsl:value-of select="Omschrijving"/>
                </h5>
            </header>
            <!--Make a 2 column layout for the info and business hour tables. -->
            <div class="row">
                <div class="column">
                    <h4 class="align-center">Gegevens van garage</h4>
                    <table class="dealer-information">
                        <tbody>
                            <!-- These will render the rows that contain all information about the car dealer. -->
                            <xsl:apply-templates
                                    select="Telefoonnummer|Website|Email|Services|Automerken|Faciliteiten|Werkzaamheden|AangeslotenOrganizaties|Routebeschrijving"/>
                        </tbody>
                    </table>
                </div>
                <!-- Divide the second color in 2 for the 2 business hours tables. -->
                <div class="column">
                    <h4 class="align-center">Openingstijden</h4>
                    <div class="row">
                        <section class="column">
                            <xsl:apply-templates select="VkOpeningstijden"/>
                        </section>
                        <section class="column">
                            <xsl:apply-templates select="WPOpeningstijden"/>
                        </section>
                    </div>
                </div>
            </div>
            <!-- Only render the car dealers foto's when they are present. -->
            <xsl:choose>
                <xsl:when test="Fotos/Foto">
                    <xsl:apply-templates select="Foto"/>
                </xsl:when>
            </xsl:choose>


            <!-- This will render the advertisements for all the cars the dealer has for sale or rental.-->
            <xsl:apply-templates select="Autos"/>

            <!-- This will render the advertisements for all the cars the dealer has for sale or rental.-->
            <xsl:apply-templates select="Medewerkers"/>

            <footer class="dealer-footer">
                <div class="row">
                    <address class="dealer-address column">
                        <xsl:apply-templates select="Adres"/>
                    </address>
                    <div class="certification-icons column">
                        <xsl:if test="AangeslotenOrganizaties/Organizatie/@naam ='BOVAG'">
                            <img src="images/bovag-garantie.png" alt="Aangesloten bij BOVAG" id="bovag-logo"/>
                        </xsl:if>
                        <xsl:if test="AangeslotenOrganizaties/Organizatie/@naam ='RDW'">
                            <img src="images/rdw-geregistreed.png" alt="Erkend door de RDW" id="rdw-logo"/>
                        </xsl:if>
                    </div>
                </div>
            </footer>
        </article>
    </xsl:template>

    <xsl:template match="Adres">
        <b>
            Address gegevens:
        </b>
        <span title="Naam van het bedrijf">
            <xsl:value-of select="../Naam"/>
        </span>
        <span title="Straatnaam en huisnummer.">
            <xsl:value-of select="Straat"/>
            <xsl:value-of select="Huisnummer"/>
        </span>
        <span title="Postcode en plaats.">
            <xsl:value-of select="Postcode"/><xsl:value-of select="Plaats"/>
        </span>
        <span title="Provincie">
            <xsl:value-of select="Provincie"/>
        </span>
    </xsl:template>

    <xsl:template match="Foto">
        <figure class="column">
            <img src="{.}" alt="The picture bla is not found."/>
        </figure>
    </xsl:template>

    <xsl:template match="VkOpeningstijden | WPOpeningstijden">
        <table class="business-hour-table">
            <caption>
                <xsl:choose>
                    <xsl:when test="local-name()='VkOpeningstijden'">
                        Verkoop
                    </xsl:when>
                    <xsl:when test="local-name()='WPOpeningstijden'">
                        Werkplaats
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
        <section class="dealer-content-sales">
            <h2 class="align-center">Aangeboden auto's:</h2>
            <hr/>
            <div id="dealer-sales">
                <xsl:apply-templates select="Auto"/>
            </div>
        </section>
    </xsl:template>

    <xsl:template match="Auto">
        <xsl:variable name="apk-expires" select=" concat(
                      normalize-space(string(DatumAPK/Dag)),
                      '-',
                      normalize-space(string(DatumAPK/Maand)),
                      '-',
                      normalize-space(string(DatumAPK/Jaar) ))"/>
        <section>
            <h4>
                <xsl:value-of select="Automerk"/><xsl:value-of select="Type"/>
            </h4>
            <div class="row">
                <div class="column-25">
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
                                    <time datetime="{Automerk}">
                                        <xsl:value-of select="Automerk"/>
                                    </time>
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
                                <td>APK t\m</td>
                                <td>
                                    <time datetime="{$apk-expires}">
                                        <xsl:value-of select="$apk-expires"/>
                                    </time>
                                </td>
                            </tr>
                            <tr>
                                <td>Kenteken</td>
                                <td>
                                    <xsl:value-of select="Kenteken"/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="column-75">
                    <xsl:apply-templates select="Fotos"/>
                </div>
            </div>
        </section>
    </xsl:template>

    <xsl:template match="Fotos">
        <div id="car-picture-cards">
            <xsl:apply-templates select="Foto"/>
        </div>
    </xsl:template>

    <xsl:template match="Foto">
        <figure class="employee-figures">
            <img alt="Imgag {../../Automerk} {../../Type}" src="{.}"/>
            <figcaption>
                <xsl:value-of select="substring-before(.,'.jpg')"/>
            </figcaption>
        </figure>
    </xsl:template>

    <xsl:template match="Medewerkers">
        <section class="dealer-content-employee">
            <h2 class="align-center">Ons team:</h2>
            <hr/>
            <div id="employee-cards">
                <xsl:apply-templates select="Medewerker"/>
            </div>
        </section>
    </xsl:template>

    <xsl:template match="Medewerker">
        <figure class="employee-figures">
            <img alt="Picture of {Naam}" src="{Foto}"/>
            <figcaption>
                <span title="Employee name">
                    <xsl:value-of select="Naam"/>
                </span>
                <span title="Employee Job Title">
                    <xsl:value-of select="Functie"/>
                </span>
            </figcaption>
        </figure>
    </xsl:template>

    <xsl:template name="statistics">
        <xsl:variable name="fuel-list" select="/Garages/Garage/Autos/Auto/Brandstof/*"/>

        <table id="dev-statistics">
            <caption>Statastieken</caption>
            <tbody>
                <tr>
                    <td>Aantal garages:</td>
                    <td>
                        <xsl:value-of select="count(Garages/Garage)"/>
                    </td>
                </tr>
                <tr>
                    <td>Auto's totaal</td>
                    <td>
                        <xsl:value-of select="count(/Garages/Garage/Autos/Auto)"/>
                    </td>
                </tr>
                <tr>
                    <td>Brandstoffen</td>
                    <td>
                        Benzine: <xsl:value-of select="count($fuel-list[local-name(.) = 'Benzine'])"/>,
                        Gas:
                        <xsl:value-of select="count($fuel-list[local-name(.) = 'Gas'])"/>
                        Diesel:
                        <xsl:value-of select="count($fuel-list[local-name(.) = 'Diesel'])"/>
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>
</xsl:stylesheet>
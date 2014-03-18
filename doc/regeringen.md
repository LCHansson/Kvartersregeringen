Hur funkar Kvartersregeringen.se?
=================================

När du söker på en adress i Sverige, letar vi upp det _valdistrikt_ adressen ligger i. (Läs mer om [valdistrikt](http://www.val.se/det_svenska_valsystemet/allmant_om_val/valgeografi/index.html)) Vi tar sedan reda på hur invånarna i valdistriktet röstade i senaste riksdagsvalet och simulerar en möjlig regering.

Simuleringen bygger på de regler som gäller för mandatfördelningen i Sveriges riksdag (4%-spärren och den _jämkade uddatalsmetoden_) och för hur regeringen bildas. (Läs mer om [riksdagsval](http://www.riksdagen.se/sv/Sa-funkar-riksdagen/Demokrati/Val-till-riksdagen/Sa-fordelas-platserna-i-riksdagen/) och [regeringsbildning](http://www.riksdagen.se/sv/Sa-funkar-riksdagen/Demokrati/Sa-bildas-regeringen/Sa-bildas-en-ny-regering/))

Alla partier vill inte regera med alla andra partier. Det är till exempel otänkbart att Vänsterpartiet och Sverigedemokraterna skulle kunna sitta i samma regering. För att avgöra vilka partier som kan hamna i samma regeringskoalition simulerar vi en _preferensordning_ för alla partier. Det betyder att vi har angivit en skala för hur gärna ett parti kan tänka sig att bilda regering med något annat parti. Vi har också angivit vilka partier som inte alls kan tänka sig att regera tillsammans.


### Varför hamnar min sökning fel?

**Det är för närvarande svårt att söka på "rätt" adress i Kvartersregeringen.** Applikationen zoomar ofta in på en gata med rätt namn men i fel stad, eller har svårt att identifiera rätt gatnummer. Vi är medvetna om problemet och arbetar på att förbättra detta.

Tills vidare gäller att bäst precision i sökningen fås om man söker på följande form:

"Adressvägen 1, Kommun"

Alltså t.ex. "Sveavägen 28, Stockholm" eller "Bergsgatan 20, Malmö". Glöm inte stor bokstav i namn och ett komma mellan adress och kommun!

**För att hitta gator i Göteborg, prova att söka på "Gothenburg" istället för Göteborg.**


### Mer om regeringsbildning

Regeringsbildningen går till så att det största partiet i Riksdagen får frågan från talmannen om att samla en regering som har stöd av en majoritet i riksdagen.

Om det största partiet lyckas hitta en majoritet i riksdagen bildar det regering, ibland tillsammans med en eller flera koalitionspartners. Statsministern utses från det största partiet och de övriga ministerposterna fördelas på koalitionspartierna baserat på hur många mandat de har i riksdagen.

Om det största partiet misslyckas med att hitta en majoritet, går frågan om att bilda en majoritetskoalition över till det näst största partiet.


### Hur funkar politiska preferenser?

Inför valet 2010 var blockmentaliteten starkt cementerad inom svensk partipolitik. Därför är huvudalternativet för partierna alltid att bilda koalitioner inom det egna politiska blocket - Socialdemokraterna med Miljöpartiet och Vänsterpartiet -- Moderaterna med Folkpartiet, Kristdemokraterna och Centern.

I många delar av Sverige fick dock inget av blocken en egen majoritet av riksdagsrösterna. I dessa fall har vi simulerat att Socialdemokraterna kan ta hjälp av Folkpartiet, medan Alliansen kan ta hjälp av Miljöpartiet för att bilda en majoritetsregering.


### Varför majoritetsregering?

I Kvartersregeringens simulering bildas bara _majoritetsregeringar_. Det betyder att de partier som ingår i regeringen också har en majoritet av platserna i Riksdagen. Men under större delen av 1900-talet har Sverige styrts av minoritetsregeringar. Så varför inte simulera minoritetsregeringar?

De senaste två mandatperioderna har en [ändring av vallagen](http://www.regeringen.se/sb/d/12165/a/137077) röstats fram av Sveriges riksdag. I korthet innebär förändringen att det från och med valet 2014 kommer att bli svårare att bilda minoritetsregeringar i Sverige. **Kvartersregeringen** tar det säkra före det osäkra och utesluter möjligheten att bilda en minoritetsregering.


### Varför är Sverigedemokraterna med i vissa koalitioner?

Det är inte särskilt troligt att något partiblock hade velat bilda koalition med Sverigedemokraterna efter riksdagsvalet 2010. För vissa adresser simulerar **Kvartersregeringen** ändå en regering där Sverigedemokraterna ingår.

Detta händer i det fåtal områden där det inte finns någon möjlig majoritetskoalition för endera av de politiska blocken _inklusive_ ett möjligt blockbyte hos mittenpartierna Miljöpartiet och Folkpartiet i riksdagen.

Eftersom Sverigedemokraterna oftast röstar med Alliansen simulerar vi i dessa fåtaliga fall en koalition mellan samtliga Allianspartier samt Sverigedemokraterna. Kanske hade en sådan parlamentarisk situation slutat med nyval istället, men det är inte säkert.

Kvartersregeringen
==================
http://www.kvartersregeringen.se/

*Det här är resultatet av laget __Drop Tables__ arbete under hackathonet [__Hack for Sweden__](http://hackforsweden.se/) den 15-16 mars 2014.*

- Love Hansson, https://github.com/LCHansson
- Jens Finnäs, https://github.com/jensfinnas
- Jonathan Hise Kaldma, https://github.com/hisekaldma

Kvartersregeringen är ett roligt och engagerande sätt att visualisera valdata. I stället för abstrakta procentsatser och pajdiagram fokuserar vi på något som alla kan ta till sig: vilka personer skulle sitta i regeringen om just ditt kvarter fått bestämma. 

Du säger var du bor. Vi berättar hur landet skulle styras om ditt valdistrikt fick bestämma. Utifrån valresultatet 2010 räknar vi ut en tänkbar regeringssammansättning. Du kan kolla andra valdistrikt och dela med dina kompisar. 

Enkelt, roligt och informativt.

Idécredd till konceptet går till [Leo Wallentin](https://twitter.com/leo_wallentin).

### Metod och verktyg

Vi har utgått från [valresultatsdata på distriktsnivå](http://www.val.se/tidigare_val/val2010/valresultat/). Datan har bearbetats i __R__. Där har vi även skrivit den algoritm som räknar ut tänkbar mandatfördelning givet ett visst valresultat. Algoritmen fungerar i korthet så att det största partiet får en chans att bilda regering, antingen själva eller i koalition med andra. Om det inte lyckas går turen vidare till det näst största partiet, osv.

Simuleringen bygger på samma regelverk som gäller för mandatfördelningen till Sveriges riksdag och hur regeringsbildningen går till. För att bilda regeringar simuleras partiernas politiska preferenser för koalitionspartners.

För att koppla en adress till rätt valdistrikt var vi tvungna att skriva ett eget litet API i __Flask/Python__. API:t tar emot ett koordinatpar och returnerar ett valdistrikt.

Frontend är byggt med [HTML5 Boilerplate](http://html5boilerplate.com/) och [Bootstrap](http://getbootstrap.com/) som grund. Vi använder __Mapbox__ för att rita och formge kartan.

### Roadmap

På http://kvartersregeringen.herokuapp.com/ finns en funktionell beta. Vi planerar göra en fullt fungerande release med öppen källkod så småningom. 

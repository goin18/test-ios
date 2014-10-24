iOS test
========

Testna aplikacija je sestavljena iz naslednjih delov:

* Seznama stroškov/prihodkov, razdeljenega po dnevih, znotraj dneva pa je lahko več vnosov. Vsak dan lahko uporabnik odpre/zapre. Seznam naj se črpa iz baze s pomočjo CoreData.
* Gumba za dodajanje stroškov/prihodkov/transakcij. Uporabnik pritisne gumb in ga nato vleče po krožnici od enega stanja do drugega. Če uporabnik gumb izpusti na krožnici, potem se izvede koda, ki je povezana s tistim stanjem, če pa uporabnik povleče gumb izven krožnice, potem se interakcija prekine in zaključi, gumb pa se vrne v prvotno stanje. Nad gumbom se tudi izpisuje ime akcije, ki se bo izvedla. Ko je gumb v tretjini stroška, je rdeče barve, ko je v tretjini prihodka, je zelene, in sive ko je v tretjini transakcije.
* Okna za dodajanje stroška/prihodka/transakcije. Ko user vpiše znesek, se ta shrani v bazo, okno se zapre in seznam se osveži.
* Okna za pregled vnešenega stroška/prihodka/transakcije, kjer lahko uporabnik strošek/prihodek ali transakcijo tudi pobriše (kar zopet osveži seznam).

Kako vse skupaj izgleda, je vidno v priloženem videu: 

https://www.dropbox.com/s/4g38qpaovm44y0i/timeline-and-add.mov?dl=0

App naj deluje identično na iPhone 4S, 5, 5S, 6 in 6+ resolucijah.

# Lösung zu KM7-01 — Mittelwertsvergleich: z-Test und t-Test

Name: Teodor Guigov &nbsp;&nbsp;&nbsp; Abgabe: 2026-11-17

> **Reproduzierbarkeit:** Alle Zahlen stammen aus `assets/betriebsdaten.csv` und
> sind mit `pmm-km7-01/analyse.R` nachvollziehbar. Dafür zuerst die Datei
> `pmm-km7-01/pmm-km7-01.Rproj` in RStudio öffnen, damit der relative Pfad
> `assets/betriebsdaten.csv` funktioniert.

**Kurzfassung der Ergebnisse**

| Größe | M1 | M2 | M3 |
|---|---|---|---|
| gültige Messungen | 37 | 39 | 40 |
| Mittelwert (mm) | 10,00054 | 9,97692 | 10,06275 |
| Standardabweichung (mm) | 0,03153 | 0,04001 | 0,06961 |
| Abstand zum Sollmaß 10,00 mm | 0,00054 | 0,02308 | **0,06275** |
| Teile außerhalb 9,85–10,15 mm | 0 | 0 | 4 |

| Test | t | df | p | 95-%-KI der Differenz |
|---|---|---|---|---|
| M1–M3, ungepaart (Welch) | −5,1132 | 55,27 | 4,09 × 10⁻⁶ | [−0,08659; −0,03783] (M1−M3) |
| M3–M1, gepaart (10 Chargen) | 5,9822 | 9 | 0,000207 | [0,03938; 0,08728] (M3−M1) |
| M1–M2, ungepaart (Welch) | 2,8658 | 71,63 | 0,005456 | [0,00719; 0,04005] (M1−M2) |

---

## 1. Vorhersagen — Kontrolle

**a)** Wie viele gültige Messungen hat jede Maschine?

| Maschine | gültig | fehlend |
|---|---|---|
| M1 | 37 | 3 |
| M2 | 39 | 1 |
| M3 | 40 | 0 |

Insgesamt 116 gültige von 120 Messungen. Deine Vorhersage („ungefähr gleich
viele") stimmt im Trend: 37/39/40 liegen dicht beieinander. Die kleinen
Unterschiede entstehen genau durch die vier fehlenden Messungen — M1 hat drei,
M2 eine, M3 keine.

**b)** Welche Maschine hat den größten Abstand zum Sollmaß?

M3, und zwar 0,06275 mm ≈ **6,3 Hundertstel**. Zum Vergleich: M2 liegt
0,02308 mm ≈ 2,3 Hundertstel und M1 nur 0,00054 mm ≈ 0,05 Hundertstel neben dem
Sollmaß. Deine Vermutung „M3" war also richtig.

**c)** Welcher Vergleich fällt statistisch leichter durch?

**M1 gegen M3** — deine Richtung war richtig, die Begründung war aber noch
unvollständig. Es reicht nicht, nur auf den größeren Mittelwertsunterschied zu
schauen; entscheidend ist das Verhältnis von Effekt und Streuung:

- M1–M2: Differenz ≈ 0,024 mm bei Streuungen 0,032/0,040 mm → Effektstärke
  *d* ≈ 0,65, t ≈ 2,87, p ≈ 0,0055.
- M1–M3: Differenz ≈ 0,062 mm bei Streuungen 0,032/0,070 mm → Effektstärke
  *d* ≈ 1,14, t ≈ 5,11, p ≈ 4 × 10⁻⁶.

Die Streuung von M3 ist zwar rund 1,7-mal größer als die von M2, aber der
Mittelwertsunterschied ist rund 2,6-mal größer. Die größere Differenz
überkompensiert den Nachteil der größeren Streuung deutlich: Das
Signal-Rausch-Verhältnis ist bei M1–M3 fast doppelt so gut. Genau darum fällt
dieser Vergleich leichter durch. **Feedback:** Ergänze deinen Satz um den
Hinweis, dass die Streuung bremst, der Effekt aber überwiegt — darum geht es in
der Frage.

---

## 2. Der ungepaarte Vergleich (M1 gegen M3, Welch)

**Hypothesen** (deine Formulierung war inhaltlich richtig, hier formal
präzisiert):

- H₀: μ_M1 − μ_M3 = 0 — die beiden Maschinen haben denselben wahren Mittelwert.
- H₁: μ_M1 − μ_M3 ≠ 0 — die wahren Mittelwerte unterscheiden sich (zweiseitig).

**Warum Welch?** Die Streuungen sind mit 0,0315 mm und 0,0696 mm mehr als
doppelt so unterschiedlich; der Welch-Test nimmt keine gemeinsame Varianz an
und korrigiert die Freiheitsgrade entsprechend.

**Ergebnis:**

- t-Wert: **−5,1132** (R rechnet M1 − M3; für M3 − M1 ist es **+5,1132**)
- Freiheitsgrade: **55,27** (nicht 37 + 40 − 2 = 75, weil Welch korrigiert)
- p-Wert: **4,09 × 10⁻⁶ ≈ 0,0000041**
- 95-%-Konfidenzintervall: **[−0,08659; −0,03783] mm** für μ_M1 − μ_M3,
  äquivalent für μ_M3 − μ_M1: **[0,03783; 0,08659] mm**; Punkteschätzung
  0,06221 mm.

**Das Intervall in ganzen Sätzen gelesen:**

M3 liegt im Mittel um *mindestens* 0,0378 mm und *höchstens* 0,0866 mm über M1;
am wahrscheinlichsten ist ein Unterschied von rund 0,062 mm. Das gesamte
Intervall liegt innerhalb der Toleranz von ± 0,15 mm — es ragt **nicht**
hinaus. Für die Lage (Mittelwerte) ist die Toleranz also eingehalten.

Wichtig für die Prozessbewertung: Die Streuung von M3 ist mit 0,0696 mm mehr als
doppelt so groß wie die von M1 (0,0315 mm). Vier Einzelteile von M3 liegen
tatsächlich über der oberen Toleranzgrenze (10,16 / 10,16 / 10,18 / 10,20 mm).
Die Verschiebung des Mittelwerts allein ist unkritisch — die Streuung von M3
ist das eigentliche Problem.

---

## 3. Der gepaarte Vergleich (Chargenmittel M3 vs. M1)

**a)** Wie viele Differenzen sind positiv/negativ?

**10 positiv, 0 negativ** — M3 liegt in jeder der 10 Chargen über M1. (Würde man
M1 − M3 rechnen, wären es 10 negative.) Beachte: Charge 103 hat bei M1 nur drei
gültige Messungen, zählt aber trotzdem als ein Paar.

**b)**

- t-Wert: **5,9822**
- Freiheitsgrade: **9**
- p-Wert: **0,000207**
- 95-%-KI: [0,03938; 0,08728] mm, mittlere Differenz 0,06333 mm

**c)** Warum 9 Freiheitsgrade?

Der gepaarte Test rechnet **nicht** mit den 37 bzw. 40 Rohmessungen, sondern mit
den **10 Differenzen der Chargenmittel** — eine Differenz pro Charge. Aus
diesen 10 Zahlen werden nur zwei Parameter geschätzt (Mittelwert und Streuung
der Differenzen), daher n − 1 = **9** Freiheitsgrade. Die 77 Rohmessungen gehen
nur in die Berechnung der Chargenmittel ein; die unabhängigen Beobachtungen des
Tests sind die **Paare (Chargen)**, nicht die Teile.

**d)** t von Hand nachrechnen

*Über die Differenzen:*

- d̄ = 0,063333 mm, s_d = 0,033479 mm, n = 10
- Standardfehler = s_d / √10 = 0,033479 / 3,1623 = 0,010587 mm
- t = 0,063333 / 0,010587 = **5,9822** ✅ stimmt mit R überein

*Über die Messwerte (Mittelwertdifferenz / Streuung):*

- Mittelwertdifferenz = 10,06275 − 10,00054 = 0,062209 mm
- Welch-Standardfehler = √(0,03153²/37 + 0,06961²/40) = 0,012166 mm →
  t = **5,1132**
- mit gepoolter Varianz: Standardfehler = 0,012487 mm → t = **4,9818**

**Was man daraus lernt:** Der Wert über die Differenzen (5,98) stimmt mit dem
gepaarten R-Test überein; die Messwert-Formeln ergeben 5,11 bzw. 4,98 — also
genau den *ungepaarten* Test aus Aufgabe 2.

Die gepaarte Formel ist kein anderer Rechenweg für denselben Datensatz, sondern
ein Test auf einer **anderen Stichprobe**, nämlich den 10 innerhalb-Paar-
Differenzen. Die Zuordnung nach Charge entfernt die Charge-zu-Charge-Streuung
(Materiallos, Schicht, Umgebungstemperatur), weil sie beide Maschinen gleich
trifft und sich beim Substrahieren aufhebt. Dadurch wird der Standardfehler
kleiner (0,0106 statt 0,0122 mm) und der t-Wert größer (5,98 statt 5,11), obwohl
nur 9 statt rund 55 Freiheitsgrade vorliegen. Zusätzlich erhalten alle 10
Chargen gleiches Gewicht — auch Charge 103 mit nur drei Messungen bei M1 —, was
den Mittelwert leicht von 0,0622 auf 0,0633 mm verschiebt. Voraussetzung ist
allerdings, dass die Paare inhaltlich zusammengehören; `paired = TRUE` darf man
R nur mit paarweise geordneten Vektoren geben (hier: die 10 Chargenmittel).

---

## 4. Kapitel-Check (Navarro Kap. 13)

**a)** Warum t-Test, wenn σ unbekannt ist?

Der z-Test setzt voraus, dass die wahre Standardabweichung der Grundgesamtheit
σ bekannt ist — das ist in der Praxis praktisch nie der Fall. Wir schätzen σ
daher aus der Stichprobe mit s. Diese Schätzung ist selbst zufällig: Bei kleinem
n unterschätzt s die wahre Streuung im Mittel und schwankt stark. Der t-Test
trägt dieser zusätzlichen Unsicherheit Rechnung, indem er die Teststatistik
nicht mit der Standardnormalverteilung, sondern mit der **t-Verteilung**
vergleicht. Deren Ränder sind dicker, die kritischen Werte also größer — der
Test ist konservativer. Mit wachsenden Freiheitsgraden geht die t-Verteilung in
die Normalverteilung über: Bei df ≈ 55 (Aufgabe 2) liegt der kritische Wert
bereits nahe bei 1,96, bei df = 9 (Aufgabe 3) noch deutlich höher bei 2,262.
Kurz gesagt: Der t-Test „bestraft" die geschätzte Streuung durch dickere
Ränder, der z-Test tut so, als wäre σ exakt bekannt.

**b)** Kollege bei p = 0,42: „Die beiden Maschinen sind also gleich gut."

**Nein, er hat nicht recht.** p = 0,42 bedeutet nur: Wenn die Maschinen wirklich
gleich wären, wäre ein so extremes oder extremeres Ergebnis in 42 % der Fälle
zu erwarten — das ist nichts Ungewöhnliches. Wir können H₀ daher nicht
ablehnen, aber wir können sie auch nicht **beweisen**. Genau hier lauert der
**Fehler 2. Art**: Wir übersehen einen tatsächlich vorhandenen Unterschied,
vielleicht weil die Stichprobe zu klein ist und die Teststärke (1 − β) gering.
Die Aussage „die Maschinen sind gleich gut" wäre eine Aussage *zugunsten* von
H₀, für die dieser Test nicht ausgelegt ist — dafür bräuchte man einen
Äquivalenztest mit einer vorher definierten Schranke. Den **Fehler 1. Art**
(fälschlich Gleichheit verwerfen und einen Unterschied behaupten) begeht der
Kollege gerade *nicht*; er tappt in die entgegengesetzte Falle. Korrekt wäre:
„Wir haben keinen statistischen Nachweis für einen Unterschied gefunden."

**c)** Drei Situationen für den gepaarten t-Test in der Fertigung

1. **Dasselbe Teil vor und nach einer Prozessumstellung messen** (z. B.
   Durchmesser vor/nach einem Werkzeugwechsel) — paarweise, weil es sich um
   dasselbe Werkstück mit derselben individuellen Streuung handelt.
2. **Zwei Prüfer oder zwei Messsysteme messen dieselben 10 Teile** (z. B.
   Messschieber A gegen Messschieber B) — paarweise, weil jedes Teil von
   beiden bewertet wird und der Teileeinfluss sich beim Differenzieren
   herausrechnet.
3. **Zwei Maschinen fertigen dieselben Chargen aus demselben Materiallos**
   (wie hier M1 gegen M3) — paarweise, weil Chargenstreuung (Material, Schicht,
   Umgebung) beide Maschinen gleichzeitig trifft.

Weitere Beispiele wären gleiche Teile an zwei Messplätzen oder vor/nach
Lagerung.

---

## 5. Die Frage hinter der Aufgabe

**a)** Wäre die Signifikanz bei M1–M2 eine Basis für eine Prozessänderung?

**Nein — der p-Wert allein ist dafür keine Basis.** Er beantwortet nur die
Frage, wie überraschend ein Unterschied von 0,024 mm unter der Annahme der
Gleichheit wäre (p = 0,005456: ziemlich überraschend), **nicht** ob der
Unterschied groß oder wirtschaftlich bedeutsam ist. 0,024 mm sind 16 % der
einfachen Toleranz von 0,15 mm bzw. 8 % der gesamten Toleranzbreite von
0,30 mm. Beide Mittelwerte liegen komfortabel innerhalb von 9,85–10,15 mm, und
das Konfidenzintervall [0,0072; 0,0400] mm endet weit vor der Toleranzgrenze.
Eine Prozessumstellung kostet Aufwand und bringt kaum Qualitätsgewinn — sie
wäre nur sinnvoll, wenn vorab eine wirtschaftliche Relevanzschranke (z. B.
„ab 0,05 mm") überschritten wird oder Streuung/Cpk problematisch wären. Der
eigentliche Handlungsbedarf liegt bei M3 mit vier Teilen über 10,15 mm.

**b)** Unterschied zwischen den zwei Sätzen

- „M1 und M2 unterscheiden sich **signifikant**" ist eine **statistische**
  Aussage über H₀ bei festgelegtem α: p < 0,05, also ablehnen. Sie skaliert mit
  der Stichprobengröße — bei sehr großem n wird selbst ein mikroskopischer
  Unterschied signifikant.
- „M1 und M2 unterscheiden sich **wirtschaftlich nicht relevant**" ist eine
  **fachlich-ökonomische** Bewertung der Effektgröße im Verhältnis zu Toleranz,
  Ausschusskosten und Umstellungskosten — unabhängig vom p-Wert.

Es sind also zwei verschiedene Aussageebenen: Die **Stärke** des Tests liegt
in der sicheren Ja/Nein-Entscheidung (Schutz vor Fehler 1. Art), seine **Grenze**
in der Bewertung „wie viel" — er misst nicht die Bedeutung des Effekts. Bei
großem n wird er überempfindlich (signifikant, aber irrelevant), bei kleinem n
übersieht er relevante Effekte (Fehler 2. Art). Deshalb immer Signifikanz +
Effektgröße + Konfidenzintervall + Toleranz gemeinsam beurteilen.

**c)** Welche Stichprobengröße, und was wirksamer vermehren?

Mehr Beobachtungen — aber wirksamer ist es, die **Zahl der Chargen** zu
erhöhen, nicht bloß die Zahl der Teile pro Charge. Der Standardfehler fällt mit
1/√n: Um bei gleicher Streuung den t-Wert von 2,87 auf etwa 3,5 zu heben
(p ≈ 0,001), braucht man rund (3,5/2,87)² ≈ 1,5-mal so viele unabhängige
Einheiten, also ungefähr **60 statt 40 je Maschine**; für sehr kleine p-Werte
ein Vielfaches.

Entscheidend ist, was die unabhängigen Einheiten sind: Die **Charge** ist die
Stichprobeneinheit, die Teile innerhalb einer Charge sind nur Wiederholungen.
Wer mehr Teile aus denselben 10 Chargen misst, verkleinert zwar den
Messfehler *innerhalb* der Charge, lässt aber die Chargenstreuung (Material,
Schicht, Umgebung) unverändert — im Extremfall (alle Teile aus einer Charge)
hat man effektiv n = 1. Mehr Chargen erhöhen die Zahl der unabhängigen Paare
und die Freiheitsgrade (10 → 20 Chargen = 19 df) und senken den Standardfehler
der Differenz tatsächlich. Genau das zeigt Aufgabe 3: Der gepaarte Test hat
trotz 77 Rohmessungen nur 9 Freiheitsgrade, weil die 10 Chargen die eigentliche
Information tragen.

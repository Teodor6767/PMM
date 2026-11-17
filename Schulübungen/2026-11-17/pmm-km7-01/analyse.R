# KM7-01 — Mittelwertsvergleich: z-Test und t-Test
# Abgabe: 2026-11-17 | Teodor Guigov
#
# Vor dem Ausführen: pmm-km7-01.Rproj öffnen, damit der Pfad zu
# assets/betriebsdaten.csv relativ zum Projektordner aufgelöst wird.

library(tidyverse)

# -----------------------------------------------------------------------------
# Daten laden (3 Maschinen x 10 Chargen x 4 Teile, 4 Messungen fehlen)
# -----------------------------------------------------------------------------
daten <- read_csv("assets/betriebsdaten.csv")

# -----------------------------------------------------------------------------
# Aufgabe 1: deskriptive Übersicht
# -----------------------------------------------------------------------------
uebersicht <- daten |>
  group_by(maschine) |>
  summarise(
    n = sum(!is.na(masse_mm)),              # gültige Messungen je Maschine
    mw = mean(masse_mm, na.rm = TRUE),      # Mittelwert
    s = sd(masse_mm, na.rm = TRUE),         # Standardabweichung
    .groups = "drop"
  ) |>
  mutate(abstand_soll_mm = abs(mw - 10.00)) # Abstand zum Sollmaß
uebersicht
# # A tibble: 3 × 5
#   maschine     n    mw      s  abstand_soll_mm
#   <chr>    <int> <dbl>  <dbl>           <dbl>
# 1 M1          37 10.0005 0.0315        0.000541
# 2 M2          39  9.9769 0.0400        0.0231
# 3 M3          40 10.0628 0.0696        0.0628  <- größter Abstand

# -----------------------------------------------------------------------------
# Aufgabe 2: ungepaarter Welch-t-Test M1 gegen M3
# H0: mu_M1 = mu_M3   |   H1: mu_M1 != mu_M3 (zweiseitig)
# -----------------------------------------------------------------------------
vergleich <- daten |> filter(maschine %in% c("M1", "M3"))
t.test(masse_mm ~ maschine, data = vergleich)
# Welch Two Sample t-test
# t = -5.1132, df = 55.272, p-value = 4.092e-06
# 95 percent confidence interval: -0.08659 -0.03783   (M1 - M3)
# mean in group M1 10.00054 | mean in group M3 10.06275
# Für M3 - M1: t = +5.1132, KI [0.03783; 0.08659] mm.

# -----------------------------------------------------------------------------
# Aufgabe 3: gepaarter Vergleich über die Chargenmittel (10 Paare)
# -----------------------------------------------------------------------------
chargen <- daten |>
  group_by(maschine, charge) |>
  summarise(mm = mean(masse_mm, na.rm = TRUE), .groups = "drop") |>
  pivot_wider(names_from = maschine, values_from = mm) |>
  mutate(differenz = M3 - M1)

chargen$differenz       # 10 Differenzen, alle positiv
sum(chargen$differenz > 0)   # 10
sum(chargen$differenz < 0)   #  0

t.test(chargen$M3, chargen$M1, paired = TRUE)
# Paired t-test
# t = 5.9822, df = 9, p-value = 0.000207
# 95 percent confidence interval: 0.03938 0.08728
# mean difference 0.06333333

# t von Hand über die Differenzen: t = dbar / (s_d / sqrt(n))
mean(chargen$differenz) / (sd(chargen$differenz) / sqrt(nrow(chargen)))
# 5.9822  <- stimmt mit R überein

# t über die Rohmesswerte (entspricht Aufgabenteil 2, nicht dem gepaarten Test):
m1 <- daten |> filter(maschine == "M1") |> pull(masse_mm) |> na.omit()
m3 <- daten |> filter(maschine == "M3") |> pull(masse_mm) |> na.omit()
(mean(m3) - mean(m1)) / sqrt(var(m1) / length(m1) + var(m3) / length(m3))
# 5.1132  (Welch-Variante)

sp2 <- ((length(m1) - 1) * var(m1) + (length(m3) - 1) * var(m3)) /
  (length(m1) + length(m3) - 2)
(mean(m3) - mean(m1)) / sqrt(sp2 * (1 / length(m1) + 1 / length(m3)))
# 4.9818  (gepoolte Variante)

# -----------------------------------------------------------------------------
# Aufgabe 5: M1 gegen M2 (signifikant, aber wirtschaftlich irrelevant)
# -----------------------------------------------------------------------------
t.test(masse_mm ~ maschine, data = filter(daten, maschine %in% c("M1", "M2")))
# Welch Two Sample t-test
# t = 2.8658, df = 71.633, p-value = 0.005456
# 95 percent confidence interval: 0.007188 0.040047   (M1 - M2)
# mean in group M1 10.00054 | mean in group M2 9.97692

# Außer-Toleranz-Werte (Soll 10.00 mm, Toleranz +/- 0.15 mm)
daten |> filter(masse_mm < 9.85 | masse_mm > 10.15) |> count(maschine)
# # A tibble: 1 x 2
#   maschine     n
#   <chr>    <int>
# 1 M3           4   (10.16, 10.16, 10.20, 10.18 mm)

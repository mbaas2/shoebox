:Namespace Shoebox
⍝ === VARIABLES ===

_←⍬
_,←'*** Shoebox-Versuche, Kapitel 1 ;-)' ''
_,←,⊂'Ein Projekt des FRAPL-Meetups von Nadja & Harald Vajkonny und Michael Baas'
Doc←_

⎕ex '_'

⍝ === End of variables definition ===

(⎕IO ⎕ML ⎕WX)←1 1 3

∇ mat←LeseDB name;txt;vec
 txt←leseDatei name     ⍝ Textdatei einlesen...
      ⍝ eingelesenen vektor umwandeln in zeilenweise nested vectors
 vec←{(1,1↓⍵=⎕UCS 13)⊂⍵}txt~⎕UCS 10
      ⍝ entferneZeilenvorschub aus den einzelnen Vektoren sowie leere Elemente aus dem Gesamtvektor
 vec←(vec~¨⎕UCS 13)~⊂''
      ⍝ erzeuge zweispaltige Tabelle und entferne "\le " bzw. "\me "-Präfixe
      ⍝ vereinfachende Annahme: es gibt immer nur eine le und me-Zeile und die beiden folgen einander
 mat←{4↓¨(⌽2,0.5×⍴⍵)⍴⍵}vec
∇

 Translate←{
      ⍝ liefert Übersetzung für ⍵ aus Tabelle ⍺
      ⍝ Falls Begriff nicht gefunden gibt es Fehler - das ist aber erwünscht
     ⍺[⍺[;1]⍳⊂⍵;2]
 }

 hex←{⎕CT ⎕IO←0                          ⍝ Hexadecimal from decimal.
     ⍺←⊢                                 ⍝ no width specification.
     1≠≡,⍵:⍺ ∇¨⍵                         ⍝ simple-array-wise:
     1∊⍵=1+⍵:'Too big'⎕SIGNAL 11         ⍝ loss of precision.
     n←⍬⍴⍺,2*⌈2⍟2⌈16⍟1+⌈/|⍵              ⍝ default width.
     ↓[0]'0123456789abcdef'[(n/16)⊤⍵]    ⍝ character hex numbers.
 }

∇ txt←leseDatei name;nu
      ⍝ Problem: ⎕NREAD schwächelt beim Einlesen von
      ⍝ Unicode-Dateien - das funktioniert damit nicht.
      ⍝ Normalerweise verwendet man für so etwas dann eine
      ⍝ externe Bibliothek, das ist aber eine zusätzliche
      ⍝ "Komplikationsstufe", die ich uns erstmal ersparen möchte.
      ⍝ Beim nächsten Treffen können wir die Funktion dann anpassen!
     
 nu←name ⎕NTIE 0
 txt←⎕NREAD nu,80,⎕NSIZE nu
 ⎕NUNTIE nu
∇

:EndNamespace 

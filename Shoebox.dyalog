:Namespace Shoebox
⍝      DB←#.Shoebox.LeseDB'H:\GitHub\shoebox\frz.ctrl'
⍝      DB gloss'H:\GitHub\shoebox\test.itx'


⍝ === VARIABLES ===

    _←⍬
    _,←'*** Shoebox-Versuche, Kapitel 1 ;-)' ''
    _,←,⊂'Ein Projekt des FRAPL-Meetups von Nadja & Harald Vajkonny und Michael Baas'
    Doc←_

    ⎕ex '_'

⍝ === End of variables definition ===

    (⎕IO ⎕ML ⎕WX)←1 1 3

    ∇ DB←LeseDB name;txt;vec;vier;z;From;To;ref;j;mat;i;ctrl;AllIsWell
    ⍝ name=name der steuerdatei
      ⎕CY'dfns'    ⍝ kopiere dfns-workspace
      ctrl←1⊃⎕NGET name 1    ⍝ Textdatei einlesen...
      AllIsWell←i←1
      DB←⍬
      :While AllIsWell
          j←⍸(⊂'\fn',⍕i)≡¨4↑¨ctrl 
          i+←1
          :If AllIsWell←×≢j
              ref←4↓j⊃ctrl  ⍝ dateiname from to
              (ref From To)←1↓¨{(+\⍵=' ')⊆ ⍵}ref
              vec←1⊃⎕NGET ref 1
              vier←4↑¨vec
              z←vier∊'\',¨From To,¨' '
              vec←z/vec
            ⍝ erzeuge zweispaltige Tabelle und entferne "\le " bzw. "\me "-Präfixe
            ⍝ vereinfachende Annahme: es gibt immer nur eine le und me-Zeile und die beiden folgen einander
              mat←{4↓¨(⌽2,0.5×⍴⍵)⍴⍵}vec
            ⍝ ; als Trennzeichen für Übersetzungsvarianten
              mat[;2]←{0=⍴⍵:'' ⋄ {(+/∧\⍵∊'; ')↓⍵}¨(1,1↓⍵=';')⊂⍵}¨mat[;2]
              DB,←⊂mat
          :EndIf
      :EndWhile
     
     
    ∇

      Übersetze←{
      ⍝ liefert Übersetzung für ⍵ aus Tabelle ⍺
      ⍝ Falls Begriff nicht gefunden gibt es leeres Ergebnis,
      ⍝ für mehrfach vorkommende Begriffe werden alle Übersetzungen geliefert.
          ⍺[⍸⍺[;1]≡¨⊂⍵;2]
      }

      hex←{⎕CT ⎕IO←0                          ⍝ Hexadecimal from decimal.
          ⍺←⊢                                 ⍝ no width specification.
          1≠≡,⍵:⍺ ∇¨⍵                         ⍝ simple-array-wise:
          1∊⍵=1+⍵:'Too big'⎕SIGNAL 11         ⍝ loss of precision.
          n←⍬⍴⍺,2*⌈2⍟2⌈16⍟1+⌈/|⍵              ⍝ default width.
          ↓[0]'0123456789abcdef'[(n/16)⊤⍵]    ⍝ character hex numbers.
      }

    ∇ res←DB gloss datei;zeile;tx;wort;wort∆
      tx←1⊃⎕NGET datei 1
      res←''
      :For zeile :In tx
          zeile←dxb(4×'\tx '≡4↑zeile)↓zeile
          :For wort :In {(+\⍵=' ')⊆⍵}' ',zeile
              wort←1↓wort  ⍝ blank weg
              wort∆←(1⊃DB)Übersetze wort
              res←res,⊂wort∆
          :EndFor
      :EndFor
     
    ∇

:EndNamespace

:Namespace Shoebox
⍝      DB←#.Shoebox.LeseDB'C:\GitHub\shoebox\.shsrc'
⍝      DB gloss'C:\GitHub\shoebox\test.itx'


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
      ⎕CY'dfns'    ⍝ kopiere dfns-workspace  (benötigt für dbx in "gloss")
      ctrl←1⊃⎕NGET name 1    ⍝ Textdatei einlesen...
      dir←1⊃⎕NPARTS name     ⍝ merke quellverzeichnis
      AllIsWell←i←1
      DB←0 2⍴''
      :While AllIsWell
          j←⍸(⊂'\fn',⍕i)≡¨4↑¨ctrl
          i+←1
          :If AllIsWell←×≢j
              ref←4↓j⊃ctrl  ⍝ dateiname from to
              (ref From)←1↓¨{(+\⍵=' ')⊆⍵}ref
              vec←1⊃⎕NGET(dir,ref)1
              vec←1↓vec  ⍝ simple: ignoriere erste zeile!
              vier←4↑¨vec
              z←∊'\'=1↑¨vier
              tags←∪('\\[_a-z]*\s+'⎕S'&')z/vier
              mat←(0,≢tags)⍴''  ⍝ sätze x tags
              :While 0<≢vec
                  row←(≢tags)⍴''
                  vec←(∨\0<≢¨vec)/vec ⍝ leerzeilen am dateianfangentfernen
                  :While 0<≢1⊃vec
                      zeile←1⊃vec
                      typ←{(¯1+⍵⍳' ')↑⍵}zeile
                      col←tags⍳⊂typ
                      row[col]←⊂(1+⍴typ)↓zeile
                  :EndWhile
                  mat⍪←row
              :EndWhile
            ⍝ ; als Trennzeichen für Übersetzungsvarianten
              DB⍪←(dir,ref)mat
          :EndIf
      :EndWhile
     
     
    ∇

    ∇ R←DB Übersetze wort;i
      ⍝ liefert Übersetzung für ⍵ aus Tabelle ⍺
      ⍝ ermittele Indices passender Begriffe
     
      i←⍸DB[;1]≡¨⊂,wort
      :Select ≢i   ⍝ anzahl treffer?
      :Case 0      ⍝ nix gefunden
         ⍝ nachfrage / eingabe...
          ⎕←'Keine Übersetzung gefunden. Nummer des zu ergänzenden Wörterbuchs eingeben? (0=keines,...)'
          j←2⊃⎕VFI⍞
          :If j>0
           ⍝ eingabe begriffsübersetzung und in DB speichern
          :Else
              R←'***'
          :EndIf
      :Case 1      ⍝ 1 Treffer!
          R←2⊃DB[⍬⍴i;]       ⍝ gleich als Ergebnis zurückgeben
      :Else        ⍝ mehrere Treffer! Auswahl etc:
          ⎕←'=== Es gibt mehrere Übersetzungsmöglichkeiten für Begriff "',wort,'":'
          {(¯1+⍳≢⍵),[1.5]⍵}(⊂'Nicht übersetzen'),DB[i;2],⊂'DB ergänzen um neue Übersetzung'
          j←2⊃⎕VFI⍞
          :If j=0
              R←'***'
          :ElseIf j>≢i
              R←ErgänzeDB wort
              ⍝ hier auch berücksichtigen:
              ⍝ auswahl DB und dann:
              ⍝ als neuen Begriff eintragen
              ⍝ als neue Möglichkeit an bestehenden Satz anfügen
          :Else
              R←i[j]⊃DB[;2]
          :EndIf
     
        ⍝ auswahl
      :EndSelect
    ∇

    ∇ res←DB gloss datei;zeile;tx;wort;wort∆
      tx←1⊃⎕NGET datei 1
      res←0 2⍴''
      :For zeile :In tx
          zeile←dxb(4×'\tx '≡4↑zeile)↓zeile
          :For wort :In {(+\⍵=' ')⊆⍵}' ',zeile
              wort←1↓wort  ⍝ blank weg
              wort∆←DB Übersetze wort
              res←res⍪wort wort∆
          :EndFor
      :EndFor
    ∇



      hex←{⎕CT ⎕IO←0                          ⍝ Hexadecimal from decimal.
          ⍺←⊢                                 ⍝ no width specification.
          1≠≡,⍵:⍺ ∇¨⍵                         ⍝ simple-array-wise:
          1∊⍵=1+⍵:'Too big'⎕SIGNAL 11         ⍝ loss of precision.
          n←⍬⍴⍺,2*⌈2⍟2⌈16⍟1+⌈/|⍵              ⍝ default width.
          ↓[0]'0123456789abcdef'[(n/16)⊤⍵]    ⍝ character hex numbers.
      }

:EndNamespace

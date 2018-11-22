:Namespace Shoebox
⍝      DB←#.Shoebox.LeseDB'C:\GitHub\shoebox\.shsrc'
⍝      DB[1 2 ;]#.Shoebox.Übersetze'son' '\me'
⍝┌───────────────────────┬───────┬───────────────────────┐
⍝│Klang; Ton; Laut; Kleie│3sPOSSm│Klang; Ton; Laut; Kleie│
⍝└───────────────────────┴───────┴───────────────────────┘
⍝      DB #.Shoebox.Übersetze'maisons' '\bk'
⍝┌────────┐
⍝│maison-s│
⍝└────────┘
⍝
⍝ DB #.Shoebox.Interlinearisiere'C:\GitHub\shoebox\test.itx'
⍝ gibt INDEX ERROR, weil es in der Datei, in der maisons gefunden wird, kein \me-Tag gibt.
⍝ Welches Tag gesucht werden soll, muß der Konfig-Datei entnommen werden!
⍝ ⍺ für Interlin sollte wahrscheinlich eher Konfig-Datei als DB sein!
⍝ Ebenso können wir der Konfigdatei entnehmen, welches Format "res" in Interlin haben soll.
⍝ Beim nächsten Mal zu lösen!
⍝ 
⍝ Hausaufgaben:
⍝ HV: VI-Syntax
⍝ MB: Code-Syntax
⍝ MB: VI installieren (SubDir  von Shoebox!)


⍝ === VARIABLES ===

    _←⍬
    _,←'*** Shoebox-Versuche, Kapitel 1 ;-)' ''
    _,←,⊂'Ein Projekt des FRAPL-Meetups von Nadja & Harald Vajkonny und Michael Baas'
    Doc←_
    ExtEditor←'c:\programme\vs code\code.exe $name -search="$suche"'

    ⎕ex '_'

⍝ === End of variables definition ===

    (⎕IO ⎕ML ⎕WX)←1 1 3

    ∇ DB←LeseDB name;txt;vec;vier;z;From;To;ref;j;mat;i;ctrl;AllIsWell;col;row;typ;zeile;tags
     
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
              vec←(⌽∨\⌽0<≢¨vec~¨⊂' ',⎕AV[10])/vec
              vec←((⊂'\_sh')≢¨4↑¨vec)/vec
              z←⍸∊{('\'≠1↑⍵)∧0<≢⍵~' '}¨vec           ⍝ ermittle indices von zeile, die nicht mit \ beginnen und keine leerzeilen sind
              vec[z-1]←vec[z-1],¨vec[z]              ⍝ dies sind fortsetzungszeilen! verknüpfe mit voriger zeile
              vec←vec[(⍳⍴vec)~z]                     ⍝ und lösche eigene Inhalte der Zeile
              z←∊'\'=1↑¨vec
              tags←{(⌽∨\⌽⍵≠' ')/⍵}¨∪('\\[_a-z]*\s+'⎕S'&')z/vec
⍝         mat←(0,≢tags)⍴''  ⍝ sätze x tags
              mat←,[0.5]tags
              :While 0<≢vec
                  row←(≢tags)⍴''
                  vec←(∨\0<≢¨vec)/vec ⍝ leerzeilen am dateianfang entfernen
                  :While 0<≢1⊃vec,⊂''
                      zeile←1⊃vec
                      typ←{(¯1+⍵⍳' ')↑⍵}zeile
                      col←tags⍳⊂typ
                      row[col]←⊂{(⌽∨\⌽~⍵∊' ',⎕AV[10])/⍵}(1+⍴typ)↓zeile
                      vec←1↓vec
                  :EndWhile
                  mat⍪←row
              :EndWhile
            ⍝ ; als Trennzeichen für Übersetzungsvarianten
              DB⍪←(∊1 ⎕NPARTS dir,ref)mat
          :EndIf
      :EndWhile
⍝
⍝ 3 Gäste - 30€, jeder 10€
⍝ rabatt: 5€ zurück
⍝ jeder kd kriegt 1€, kellner 2€.
⍝ also: jeder gast statt 10 nur 9€ ausgegeben, zusammen 27€. +2€ trinkgeld ist 29. wo ist der fehlende €?
⍝
    ∇

    ∇ res←DB Interlinearisiere datei;zeilen;txt;ü;w;res;worte;wort
      zeilen←1⊃⎕NGET datei 1
     
      :For txt :In 3↓¨((⊂'\tx ')≡¨4↑¨zeilen)/zeilen
          worte←{(∊0<⍴¨⍵)/⍵}{(∨\⍵≠' ')/⍵}¨{(⍵=' ')⊂⍵}txt
          res←(worte,[0.5]' ')⍪' '
     
          :For w :In ⍳≢worte
          ⎕←⎕ucs 13
              ⎕SE.Dyalog.Utils.disp res
              ü←DB Übersetze(w⊃worte)'\me'
              res[2 3;w]←∊¨worte[w] (ü)
          :EndFor
      :EndFor
     
     
    ∇


    ∇ ret←DB ErgänzeWort wort
      d←1
      :If 1<≢DB   ⍝ falls es mehr als 1 Datenbank gibt...
          ⎕←'Welche Datenbank ergänzen?'
          ⎕←'0 Abbrechen'
          ⎕←(⍳≢DB),DB[;,1]
          d←2⊃⎕VFI⍞
      :EndIf
      :If d=0 ⋄ →ret←0 ⋄ :EndIf
      DB Übersetze wort'\_no'
⍝ ext editor öffnen und nach Zeile mit Eintrag "\_no ###" suchen lassen!
⍝ VI installieren?
     
    ∇


    ∇ R←DB Übersetze(wort returnTag);i
      ⍝ liefert Übersetzung für ⍵ aus Tabelle ⍺
      ⍝ ermittele Indices passender Begriffe
      ⍝ DB Übersetze 'wort' '\me'
      R←⍳0
      :For tabelle :In DB[;2]
          :If 0<≢i←⍸tabelle[;1]≡¨⊂,wort
              R∪←tabelle[i;tabelle[1;]⍳⊂returnTag]
          :EndIf
      :EndFor
    ⍝ schrittweise wird R jetzt in Ergebnisliste umgewandelt:
      R←∊R,¨';'     ⍝ mit ; als Trennzeichen alle Ergebnisse zusammenfügen (kann auch einzelne durch ; getrennte Ergebnisse aus einer Tabelle enthalten)
      R←{(∊0<⍴¨⍵)/⍵}{(∨\~⍵∊'; ')/⍵}¨{(⍵=';')⊂⍵}';',R
      :Select i←≢R   ⍝ anzahl treffer?
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
          →0   ⍝ gleich als Ergebnis zurückgeben
      :Else        ⍝ mehrere Treffer! Auswahl etc:
          ⎕←'=== Es gibt mehrere Übersetzungsmöglichkeiten für Begriff "',wort,'":'
          {(¯1+⍳≢⍵),[1.5]⍵}(⊂'Nicht übersetzen'),R,⊂'DB ergänzen um neue Übersetzung(en)'
          j←2⊃⎕VFI⍞
          :If j=0
              R←'***'
          :ElseIf j>≢i
              ret←DB ErgänzeDB wort
          :Else
              R←j⊃R
          :EndIf
      :EndSelect
    ∇

    ∇ res←DB gloss datei;zeile;tx;wort;wort∆
      tx←1⊃⎕NGET datei 1
      res←0 2⍴''
      :For zeile :In tx
          zeile←(4×'\tx '≡4↑zeile)↓zeile
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

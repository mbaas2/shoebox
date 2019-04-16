:Namespace Shoebox
⍝
⍝ neuer ablauf:
⍝ ]load    C:\Git\shoebox\Shoebox.dyalog
⍝ )cs #.Shoebox
⍝ sb   ⍝ Hautproghramm
⍝ läuft auf ∘∘∘, dann:
⍝ DB Interlinearisiere'C:\Git\shoebox\Projekt_frz-1\test.itx'
⍝
⍝
⍝------Alte Notizen:
⍝      DB←#.Shoebox.LeseDB'C:\Git\shoebox\.shsrc'
⍝      DB[1 2 ;]#.Shoebox.Übersetze'son' '\me'
⍝┌───────────────────────┬───────┬───────────────────────┐
⍝│Klang; Ton; Laut; Kleie│3sPOSSm│Klang; Ton; Laut; Kleie│
⍝└───────────────────────┴───────┴───────────────────────┘
⍝      DB #.Shoebox.Übersetze'maisons' '\bk'
⍝┌────────┐
⍝│maison-s│
⍝└────────┘
⍝
⍝ boxes #.Shoebox.Interlinearisiere'C:\Git\shoebox\Projekt_frz-1\test.itx'
⍝ gibt INDEX ERROR, weil es in der Datei, in der maisons gefunden wird, kein \me-Tag gibt.
⍝ Welches Tag gesucht werden soll, muß der Konfig-Datei entnommen werden!
⍝ ⍺ für Interlin sollte wahrscheinlich eher Konfig-Datei als DB sein!
⍝ Ebenso können wir der Konfigdatei entnehmen, welches Format "res" in Interlin haben soll.
⍝ Beim nächsten Mal zu lösen!
⍝
⍝ ⍝ vim +[lineno] filename
⍝ vim +[lineno3] filename3 +"vsp +[lineno2] filename2" +"vsp +[lineno1] filename1"

⍝ Hausaufgaben:
⍝ HV: ncruses-Vorstellung
⍝ MB: ncurses interface aus dyalog?


⍝ Konfig-Datei: \aln verarbeiten und aufgrund dessen den Ablauf steuern, dabei mbk-Character berücksichtigen
⍝ vi-Einbindung bei Neueintrag oder Änderungen
⍝ [G]UI
⍝
⍝ === VARIABLES ===

    _←⍬
    _,←'*** Shoebox-Versuche, Kapitel 1 ;-)' ''
    _,←,⊂'Ein Projekt des FRAPL-Meetups von Nadja & Harald Vajkonny und Michael Baas'
    Doc←_
    ExtEditor←'c:\programme\vs code\code.exe $name -search="$suche"'

    ⎕ex '_'

⍝ === End of variables definition ===

    (⎕IO ⎕ML ⎕WX)←1 1 3

    ∇ sb;ctrl;j;DB;AllIsWell;ref;i;aktDir;CONFIG;fnz;f
⍝ .shsrc im Projektpfad suchen
⍝ "Projektpfad" ist entweder das aktuelle Verzeichnis oder die Umgebungsvariable shprj
      ⎕CY'dfns'    ⍝ kopiere dfns-workspace  (benötigt für dbx in "gloss")
     
      aktDir←1⊃1 ⎕NPARTS''   ⍝ akt. Verzeichnis beim Aufruf
     
      :If ~⎕NEXISTS aktDir,'.shsrc'  ⍝ gibt dort eine Konfig-Datei?
          aktDir←2 ⎕NQ'.' 'GetEnvironment' 'shprj'    ⍝ suche nach Umgebungsvariable
          :If ~⎕NEXISTS aktDir,'.shsrc'  ⍝ gibt dort eine Konfig-Datei?
              ⎕←'Keine .shsrc-Datei gefunden - Pech gehabt!'
              →0
          :EndIf
      :EndIf
     
      ctrl←1⊃⎕NGET(aktDir,'.shsrc')1    ⍝ Konfigurationdatei einlesen und verarbeiten
     
    ⍝ breakChar = morpheme break, \mbk der steuerdatei
      breakChar←{0=≢⍵:'-' ⋄ ⍵}ctrl GetConfig'mbk'
     
      fnz←('\\fn(\d+)\s(.*)'⎕S'\1:\2')ctrl
      fn←∊{2⊃⎕VFI(¯1+⍵⍳':')↑⍵}¨fnz
      boxes←(3,≢fn)⍴'' ⋄ j←1
      :For f :In fnz
          i←{2⊃⎕VFI(¯1+⍵⍳':')↑⍵}f
          boxes[1;j]←i
          boxes[2;j]←⊂{(⍵⍳':')↓⍵}f
          j+←1
      :EndFor
     
      aln←0 5⍴' '
      :While (≢ctrl)≥i←(5↑¨ctrl)⍳⊂'\aln '
          aln⍪←{(⍵=' ')⊂⍵}4↓i⊃ctrl
          ctrl[i]←⊂''
      :EndWhile
     
     
     
      :For i :In ⍳¯1↑⍴boxes
          ref←2⊃boxes[;i]
          :If './'≡2↑ref ⋄ :OrIf '.\'≡2↑ref ⋄ ref←aktDir,2↓ref ⋄ :EndIf
          boxes[3;i]←⊂LeseDB ref
              ⍝⎕←'=== LeseDB ',name
      :EndFor
     
      ∘∘∘
    ∇

    ∇ r←cfg GetConfig tag
      i←((2+⍴tag)↑¨cfg)⍳⊂'\',tag,' '
      r←i⊃cfg,⊂''
    ∇

    ∇ mat←LeseDB name;txt;vec;vier;z;From;To;ref;j;mat;i;ctrl;AllIsWell;col;row;typ;zeile;tags;vbs;vbx;fz;iv;lz;v;v∆;vmax;lineno;colIdx
      ⎕←'=== LeseDB ',name
      vec←1⊃⎕NGET name 1
⍝      vec←(⌽∨\⌽0<≢¨vec~¨⊂' ',⎕AV[10])/vec
⍝      vec←((⊂'\_sh')≢¨4↑¨vec)/vec
      z←⍸∊{('\'≠1↑⍵)∧0<≢⍵~' '}¨vec           ⍝ ermittle indices von zeilen, die nicht mit \ beginnen und keine leerzeilen sind
      lineno←⍳⍴vec
      vec[z-1]←vec[z-1],¨vec[z]              ⍝ dies sind fortsetzungszeilen! verknüpfe mit voriger zeile
      lineno~←z
      vec←vec[(⍳⍴vec)~z]                     ⍝ und lösche eigene Inhalte der Zeile
      vec←1↓vec ⋄ lineno←1↓lineno  ⍝ verhindere verarbeitung zeile 0
      z←∊'\'=1↑¨vec
      tags←({(⌽∨\⌽⍵≠' ')/⍵}¨∪('\\[_a-z]*\s+'⎕S'&')z/vec),⊂''
      colIdx←⍴tags
      ⍝         mat←(0,≢tags)⍴''  ⍝ sätze x tags
      mat←,[0.5]tags
      fz←~lz←0=≢¨vec    ⍝ Zeilen mit Inhalt
      iv←⍳≢vec
      v←0
      vmax←≢vec
     
      :While vmax≥(v←v+1)
⍝          ⎕←'v=',v
          row←(≢tags)⍴''
          vbs←⍬⍴⍸fz∧v≤iv       ⍝ Anfang des Blocks
          vbx←vmax{⍵=0:⍺ ⋄ ⍵}⍬⍴⍸lz∧vbs<iv  ⍝ Ende des Blocks ist nächste Leerzeile-1
⍝          'vbs/vbx=',vbs,vbx
          row[colIdx]←vbs⊃lineno ⍝ Dateiposition dieses Blocks
           ⍝TODO: vermeide Verarbeitung Zeile0!
          :For v∆ :In (vbs-1)+⍳1+vbx-vbs  ⍝TODO: läuft ggf. auch in letzte Zeile! :(
              :If ∨/~(⎕UCS zeile←v∆⊃vec)∊9 32  ⍝ keine tabs oder blanks
                  typ←{(¯1+⍵⍳' ')↑⍵}zeile
                  col←tags⍳⊂typ
                  row[col]←⊂{(⌽∨\⌽~⍵∊' ',⎕AV[10])/⍵}(1+⍴typ)↓zeile
              :EndIf
          :EndFor
          mat⍪←row
          v←vbx
 ⍝         ⎕←'v←',v
      :EndWhile
            ⍝ ; als Trennzeichen für Übersetzungsvarianten
⍝
⍝ 3 Gäste - 30€, jeder 10€
⍝ rabatt: 5€ zurück
⍝ jeder kd kriegt 1€, kellner 2€.
⍝ also: jeder gast statt 10 nur 9€ ausgegeben, zusammen 27€. +2€ trinkgeld ist 29. wo ist der fehlende €?
⍝
    ∇

    ∇ res←boxes Interlinearisiere datei;zeilen;txt;ü;w;res;worte;wort
      zeilen←1⊃⎕NGET datei 1
     
      :For txt :In 3↓¨((⊂'\tx ')≡¨4↑¨zeilen)/zeilen
          worte←{(∊0<⍴¨⍵)/⍵}{(∨\⍵≠' ')/⍵}¨{(⍵=' ')⊂⍵}txt
          res←(worte,[0.5]' ')⍪' '
     
          :For w :In ⍳≢worte
              ⎕←⎕UCS 13
              ⎕SE.Dyalog.Utils.disp res
              ü←boxes Übersetze(w⊃worte)'\me'
              res[2 3;w]←∊¨worte[w](ü)
          :EndFor
      :EndFor
     
     
    ∇


    ∇ ret←boxes ErgänzeWort wort
      d←1
      :If 1<¯1↑⍴boxes   ⍝ falls es mehr als 1 Datenbank gibt...
          ⎕←'Welche Box ergänzen?'
          ⎕←'0 Abbrechen'
          ⎕←⍉boxes[1 2;]
          d←2⊃⎕VFI⍞
      :EndIf
      :If d=0 ⋄ →ret←0 ⋄ :EndIf
      ∘∘∘   ⍝ TODO: was genau soll hier geschehen? muss evtl. an neuen Aufbau (boxes stat DB) angepasst werden!
      boxes Übersetze wort'\_no'
⍝ ext editor öffnen und nach Zeile mit Eintrag "\_no ###" suchen lassen!
⍝ VI installieren?
     
    ∇


    ∇ R←boxes Übersetze(wort returnTag);i;j;ret;lineno;m;tabelle;menu
      ⍝ liefert Übersetzung für ⍵ aus Tabelle ⍺
      ⍝ ermittele Indices passender Begriffe
      ⍝ boxes Übersetze 'wort' '\me'
     again:
      R←⍳0
      :For tabelle :In boxes[3;]
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
          ⎕←menu←{(¯1+⍳≢⍵),[1.5]⍵}(⊂'Nicht übersetzen'),R,⊂'DB ergänzen um neue Übersetzung(en)'
          j←2⊃⎕VFI⍞
          :If j=0
              R←'***'
          :ElseIf (j+1)=≢menu
              lineno←⍳0
              :For m :In boxes[3;]
                  j←(m⍪1)[m[;1]⍳⊂wort;¯1↑⍴m]
                  lineno,←j
              :EndFor
     
              lineno ErgänzeDB boxes[2;]
              ⎕←'Bitte Eingabe 1 zum erneuten Einlesen der DB oder 0 zum direkten Fortsetzen...'
              j←2⊃⎕VFI⍞
              :For m :In ⍳¯1↑⍴boxes
                  boxes[3;m]←⊂LeseDB(m⊃boxes[2;])
              :EndFor
              →again
          :Else
              R←j⊃R
          :EndIf
      :EndSelect
    ∇

    ∇ res←box gloss datei;zeile;tx;wort;wort∆
      tx←1⊃⎕NGET datei 1
      res←0 2⍴''
      :For zeile :In tx
          zeile←(4×'\tx '≡4↑zeile)↓zeile
          :For wort :In {(+\⍵=' ')⊆⍵}' ',zeile
              wort←1↓wort  ⍝ blank weg
              wort∆←box Übersetze wort
              res←res⍪wort wort∆
          :EndFor
      :EndFor
    ∇

    ∇ lineno ErgänzeDB dateien;cmd;i;vsp;z
      :If (,'W')≡3⊃'.'⎕WG'aplversion'
⍝ TODO: konfigurierbar!
          cmd←'C:\Program Files (x86)\Vim\vim81\vim.exe '
⍝ vim +6 file1 +"sp +3 file2".
⍝ vim +[lineno3] filename3 +"vsp +[lineno2] filename2" +"vsp +[lineno1] filename1"
          :For i :In ⌽⍳≢lineno
              z←i<≢lineno
              cmd←cmd,(z/'+"vsp '),('+',⍕lineno[i]),' ',(i⊃dateien),(z/'"'),' '
          :EndFor
⍝          cmd←¯6↓cmd
          ⎕CMD ⎕←cmd'normal'
      :Else
          ⎕SH'vim ',∊(⊆dateien),¨' '
      :EndIf
    ∇

      hex←{⎕CT ⎕IO←0                          ⍝ Hexadecimal from decimal.
          ⍺←⊢                                 ⍝ no width specification.
          1≠≡,⍵:⍺ ∇¨⍵                         ⍝ simple-array-wise:
          1∊⍵=1+⍵:'Too big'⎕SIGNAL 11         ⍝ loss of precision.
          n←⍬⍴⍺,2*⌈2⍟2⌈16⍟1+⌈/|⍵              ⍝ default width.
          ↓[0]'0123456789abcdef'[(n/16)⊤⍵]    ⍝ character hex numbers.
      }

:EndNamespace

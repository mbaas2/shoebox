## The basics

I originally titled this "Data structures" and later noticed that I wasn't writing about DS at all. 
And it is probably better to first make sure we have a common understanding of the situation - so I'll describe 
some of the features that I understood ;-)
Pls. feel free to correct and add as appropriate!

### Tags

Per sentence:

* `\ref` (Reference) = a unique key (manually assigned in SB)
* `\tx` (Text) = One sentence in the source-language.
* `\fr` = free text (Proper translation of the entire phrase)

Every sentence contains words - and they are entered in rows with mb/gl-Tag per row and space-separated.
* `\mb` (morpheme break) = translation of corresponding tx-element 
* `\gl` (Glossary) = Wordwise translation

*Glossary-files* use these tags:
* `\le` (Lemma, lexical entry) - original term
* ´\me` (Meaning) - Translation
* ´\co` (Comment) - any comments/explanations/remarks the translater may have

*Parsing:*
* `\fl`(Full)
* `bk`(Broken)

## shoebox-files
Up to 9 files can be used in an interlinearisation-process. 
Haralds examples uses 3 files for Words, Suffixes, Parsing, Source.

##Interlinear Setup
These rules are used to define the process of moving from one row to the next

Source Line marker: tx 
 From "tx" annotate lower line "mb"


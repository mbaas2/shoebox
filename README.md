# shoebox
Bringing good ol' Shoebox from DOS back to life. Trying to - at least...

#Usage 
Copy Shoebox.dyalog and the "database" fr.db to a convenient location.
Start Dyalog APL and do:
    ]load {convenient location}\Shoebox 
This will load all definitions from the file into a namespace "Shoebox",
so you can then do:
    db←#.Shoebox.LeseDB '{convenient location}\Shoebox\fr.db'
    db #.Shoebox.Translate'lapin'
    
Note: we didn't speak about "namespaces"during the evening - it's just like subdirectories in a workspace ;-)
So, instead of referring to the commands with fully qualified pathnames 
as above, you can also simplify things by doing the CD-equivalent (change directory) 
and "change space":
    )cs #.Shoebox
    db←LeseDB '{convenient location}\Shoebox\fr.db'
    db Translate'lapin'
    
#Questions?
Post them @ https://www.meetup.com/de-DE/Frankfurt-APLers/messages/boards/
or https://github.com/mbaas2/shoebox/issues
or mb@mbaas.de  :-)
     
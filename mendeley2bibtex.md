Convert a .bib file from Mendeley to use in BibDesk.
The initial .bib file was exported with the Mendeley option "Escape LaTeX
special characters" on.

Text editing of the .bib file mostly done in Vim, with some sed for groups at
the end.

Some of the edits below would not be required if instead of a .bib file, we
exported a .ris file from Mendeley. But then there would be other edits
required.

# bib: change file to local-url and more...
In Vim ex mode:
g/^file/normal 0celocal-urljj
g/^local\-url/s/:pdf\|:doc\>\|:docx//g
g/^local\-url/s+:+/+g

# (only for me) change directory location
In Vim ex mode:
%s+Documents/References/+Documents/references/+

# there will be problems with Tex escaping file names. They will match:
/^local\-url.*{\\/e-1

Some that can be fixed automatically are:
g/^local\-url.*{\\_}/s/{\\_}/_/g
g/^local\-url.*{\\&}/s/{\\&}/\&/g

Some require change of file name too, like:
s/{\\"{u}}/u/g

Checking entries with multiple files:
/^local\-url[^;]*;/e

BibDesk does not import the multiple files. So it's better to remove multiple
entries for this field, and add again in the GUI.

# there are similar issues with url field:
/^url.*{\\/

Common fixes:
g/^url.*{\\_}/s/{\\_}/_/g
g/^url.*{\\&}/s/{\\&}/\&/g
g/^url.*{\\%}/s/{\\%}/%/g


# convert the mendeley-tags?
In Vim ex mode:
%s/^keywords/author-keywords/
%s/^mendeley\-tags/keywords/

Cases where author-keywords are the same as the keywords (probably Mendely
copied one to the other, and the author-keywords should go empty)

/^author-keywords.*{\(.*\)},\_skeywords.*{\1}

# Quotes in the abstract
:g/^abstract/s/"\<\([^"]\+\)\>"/``\1''/g

Double-check with:
/^abstract.*"/e

(this can happen in annote field as well)

# checking IDs with special characters:
/^@[^{]\+{\w*\W.*,$

# Converting Folders into Static Groups

Steps:
- create the static group in BibTex. This will add a new entry (key-group name)
  at the @comment section in the end of the file.
- export the Folder in Mendeley
- collect the keys from the exported file
    :let @a = ""
    :g/^@/normal f{l"Ayf,

Or in shell:
    sed -n 's/@[^{]*{//p'|tr -d '\n'

For all files (only filenames without spaces):
    for f in `ls -1 *.bib`; do sed -n 's/@[^{]*{//p' $f |tr -d '\n'> $f.group; done

- add the list of keys to the @comment section, in the group

Alternative:
- use a special field (say, Type) to have group specific values. Later, use
  those values to filter entries in BibTex, selecting them to be added to the
  corresponding groups.

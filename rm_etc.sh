name_work="Masterarbeit_AbelHodelinHernandez"

# delete extra created files
# cd $1
if [ -f "$name_work.bcf" ]
then
  rm *.bcf
fi

if [ -f "$name_work.aux" ]
then
  rm *.aux
fi

if [ -f "$name_work.bbl" ]
then
  rm *.bbl
fi

if [ -f "$name_work.blg" ]
then
  rm *.blg
fi

if [ -f "$name_work.lof" ]
then
  rm *.lof
fi

if [ -f "$name_work.log" ]
then
  rm *.log
fi

if [ -f "$name_work.lol" ]
then
  rm *.lol
fi

if [ -f "$name_work.lot" ]
then
  rm *.lot
fi

if [ -f "$name_work.out" ]
then
  rm *.out
fi

if [ -f "$name_work.run.xml" ]
then
  rm *.run.xml
fi

if [ -f "$name_work.synctex.gz" ]
then
  rm *.synctex.gz
fi

if [ -f "$name_work.toc" ]
then
  rm *.toc
fi

# rm *.aux *.l* *.o* *.sy* *.to* *.b* *.r*

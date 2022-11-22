name_work="Masterarbeit_AbelHodelinHernandez"
da=`date +%d-%m-%Y`
date_sign="-signed-$da"
if [ ! -f "$name_work.bcf" ]
then 
  pdflatex $name_work.tex
  biber $name_work
  pdflatex --interaction=batchmode $name_work.tex 2>&1 /dev/null
else
  pdflatex $name_work.tex
fi

cp $name_work.pdf $name_work$date_sign.pdf

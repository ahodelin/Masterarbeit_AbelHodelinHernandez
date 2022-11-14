name_work="Masterarbeit_AbelHodelinHernandez"

if [ ! -f "$name_work.bcf" ]
then 
  pdflatex $name_work.tex
  biber $name_work
  pdflatex --interaction=batchmode $name_work.tex 2>&1 /dev/null
else
  pdflatex $name_work.tex
fi

# cp $name_work.pdf $name_work-signed.pdf

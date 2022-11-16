git add *.tex
d=`date`
git commit -m "$d"
git fetch origin 
git push origin main 

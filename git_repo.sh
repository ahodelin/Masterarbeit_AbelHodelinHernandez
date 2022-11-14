git add *.tex *.sh *.sty *.pdf
git add data/db/*.sql
#git add bibliography/biblio.bib
git add data/csv/*.csv
#git add python_scripts/*

d=`date`
git commit -m "Last update $d"
git fetch origin
git push origin main

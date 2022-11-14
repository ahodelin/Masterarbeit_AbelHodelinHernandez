#system=`lsb_release -d | grep -o Ubuntu`
pcname=`hostname`
if [[ $pcname =~ "vmubuntu22" ]]; then
  dbpass=`pass db/her11a_admin`
  export PGPASSWORD=$dbpass
  /usr/local/pg15/bin/pg_dump > /home/ahodelin/git_repos/Thesis_AbelHodelinHernandez/data/db/thesis.sql -U her11a_admin -d thesis -O -x -w
fi

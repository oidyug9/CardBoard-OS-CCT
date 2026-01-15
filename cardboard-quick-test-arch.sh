clear
rm -rf ./computers/0/
mkdir ./computers ./computers/0
cp src/* ./computers/0/ -r
craftos --cli --start-dir ./computers/0
rm -rf ./computers
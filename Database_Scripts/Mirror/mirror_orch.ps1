#setup mirror orchastration 

osql -S SQLSERVER-1 -E -i <location>\SQL_Mirror_Setup_1.sql

osql -S SQLSERVER-2 -E -i <location>\SQL_Mirror_Setup_2.sql

osql -S SQLSERVER-1 -E -i <location>\SQL_Mirror_Setup_3.sql

osql -S SQLSERVER-2 -E -i <location>\SQL_Mirror_Setup_4.sql

osql -S SQLSERVER-3 -E -i <location>\SQL_Mirror_Setup_5.sql

osql -S SQLSERVER-2 -E -i <location>\SQL_Mirror_Setup_6.sql

osql -S SQLSERVER-1 -E -i <location>\SQL_Mirror_Setup_7.sql
#get_tasks_count
import SQLForce

session = SQLForce.Session('Production', 'jacy.york@scalearc.com', 'Bear0817urTD1zfLaz1Y3y9NM2SAYhyR' )
session.setenv('QUERY_ALL', "true" ) # Force archived records to be read.

##
## SOQL that determines what records to delete. BE VERY CAREFUL HERE!
##s
#taskSOQL = """SELECT DISTINCT subject, count(subject) FROM Task WHERE isDeleted=false GROUP BY subject ORDER BY subject DESC"""
#taskSOQL = 'SELECT COUNT(DISTINCT subject) FROM TASK WHERE IsArchived = "True"'
#session = SQLForce.Session('Production', 'jacy.york@scalearc.com', 'Bear0817urTD1zfLaz1Y3y9NM2SAYhyR' )
for rec in session.selectRecords("SELECT DISTINCT subject FROM TASK WHERE IsArchived = true AND subject LIKE 'Was Sent Email %'"):
    print rec.subject

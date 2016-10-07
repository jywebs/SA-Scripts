import SQLForce

session = SQLForce.Session('Production', 'jacy.york@scalearc.com', 'Bear0817urTD1zfLaz1Y3y9NM2SAYhyR' )
session.setenv('QUERY_ALL', "true" ) # Force archived records to be read.

##
## SOQL that determines what records to delete. BE VERY CAREFUL HERE!
##s

#Cleanup of Was Sent Email
#taskSOQL = """SELECT id, subject FROM Task WHERE isDeleted=false AND IsArchived = true AND subject LIKE 'Was Sent Email%' order by systemmodstamp DESC"""

#Cleanup of Was Added to List
#taskSOQL = """SELECT id, subject FROM Task WHERE isDeleted=false AND IsArchived = true AND subject LIKE 'Was Added to List%' order by systemmodstamp DESC"""

#Cleanup Mass Email
#taskSOQL = """SELECT id, subject FROM Task WHERE isDeleted=false AND IsArchived = true AND subject LIKE 'Mass Email%' order by systemmodstamp DESC"""

#Clean ALL
taskSOQL = """SELECT id, subject FROM Task WHERE isDeleted=false AND IsArchived = true order by systemmodstamp DESC"""
# AND (subject LIKE 'Mass Email%' OR subject LIKE 'Was Added to List%' OR subject LIKE 'Was Sent Email%' OR subject LIKE'Left VM%' OR subject LIKE 'Was Sent Sales Email%' OR subject LIKE '%Email Click-through%' OR subject LIKE 'Call%' OR subject LIKE 'BOUNCED Email%' OR subject LIKE "Att%" OR subject LIKE 'AA%') 


#taskSOQL = """SELECT id, subject FROM Task WHERE isDeleted=false AND IsArchived = true AND subject LIKE 'Direct Phone Number%' order by systemmodstamp DESC"""

nDeleted = 0
maxPerBatch = 1000 # This is a good size to prevent the Task query from timing out.
maxPerRun = 150000   # quit once this number of deletes has happened.

while True:
    idsToDelete = []
    soql = taskSOQL + " LIMIT " + str(maxPerBatch)
    print(soql)
    for rec in session.selectRecords(soql):
        idsToDelete.append( rec.id )

    if not idsToDelete:
        break
    

    nThisTime = session.delete('Task', idsToDelete )
 
    nDeleted += nThisTime
    print("Deleted " + str(nDeleted) + " records so far")
    if nDeleted >= maxPerRun:
        break

print("Finished")
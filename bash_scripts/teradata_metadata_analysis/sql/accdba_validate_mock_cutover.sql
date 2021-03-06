CREATE VOLATILE TABLE MOCKRUN_UPG_CHG_LIST AS 
(
SELECT * FROM CLARITY_DBA_MAINT.CLARITY_UPG_CHG_LIST
WHERE RUN_ID=MY_RUN_ID
)
WITH DATA ON COMMIT PRESERVE ROWS;


UPDATE MOCKRUN_UPG_CHG_LIST SET PROD_DB='MY_DRYRUN_REPORT_DB' WHERE PROD_DB='MY_REPORT_DB';

UPDATE MOCKRUN_UPG_CHG_LIST SET EP_VIEW_DB='MY_DRYRUN_EP_DB' WHERE EP_VIEW_DB='MY_EP_DB';

UPDATE MOCKRUN_UPG_CHG_LIST SET USER_VIEW_DB='MY_DRYRUN_USER_DB' WHERE USER_VIEW_DB='MY_USER_DB';



SELECT 'Column Not in EP VIEW but present in Reporting' AS ERROR_DESC, TRIM(TableName),TRIM(ColumnName)
FROM DBC.Columns B
JOIN MOCKRUN_UPG_CHG_LIST A
ON  TRIM(A.UPG_TABLE_NAME)=TRIM(B.TableName)
   AND TRIM(A.PROD_DB)=TRIM(B.DatabaseName)
 AND A.RUN_ID=MY_RUN_ID
 AND A.CHANGE_TYPE NOT IN ('Table Drop','View Only','Rename Table')
 
 MINUS
 
SELECT 'Column Not in EP VIEW but present in Reporting', TRIM(TableName),TRIM(ColumnName)
FROM DBC.Columns B
JOIN MOCKRUN_UPG_CHG_LIST A
ON  TRIM(A.UPG_TABLE_NAME)=TRIM(B.TableName)
   AND TRIM(A.EP_VIEW_DB)=TRIM(B.DatabaseName)
 AND A.RUN_ID=MY_RUN_ID
 AND A.CHANGE_TYPE NOT IN ('Table Drop','View Only','Rename Table')
;
 
 
SELECT 'Column Not in USER VIEW but present in Reporting' AS ERROR_DESC,TRIM(TableName),TRIM(ColumnName)
FROM DBC.Columns B
JOIN MOCKRUN_UPG_CHG_LIST A
ON  TRIM(A.UPG_TABLE_NAME)=TRIM(B.TableName)
   AND TRIM(A.PROD_DB)=TRIM(B.DatabaseName)
 AND A.RUN_ID=MY_RUN_ID
 AND A.CHANGE_TYPE NOT IN ('Table Drop','View Only','Rename Table')
 
 MINUS
 
SELECT 'Column Not in USER VIEW but present in Reporting',TRIM(TableName),TRIM(ColumnName)
FROM DBC.Columns B
JOIN MOCKRUN_UPG_CHG_LIST A
ON  TRIM(A.UPG_TABLE_NAME)=TRIM(B.TableName)
   AND TRIM(A.USER_VIEW_DB)=TRIM(B.DatabaseName)
 AND A.RUN_ID=MY_RUN_ID
 AND A.CHANGE_TYPE NOT IN ('Table Drop','View Only','Rename Table')
;
 
  
SELECT 'Column Not in USER VIEW but present in EP VIEW' AS ERROR_DESC,TRIM(TableName),TRIM(ColumnName)
FROM DBC.Columns B
JOIN MOCKRUN_UPG_CHG_LIST A
ON  TRIM(A.UPG_TABLE_NAME)=TRIM(B.TableName)
   AND TRIM(A.EP_VIEW_DB)=TRIM(B.DatabaseName)
 AND A.RUN_ID=MY_RUN_ID
 AND A.CHANGE_TYPE NOT IN ('Table Drop','View Only','Rename Table')
 
 MINUS
 
SELECT 'Column Not in USER VIEW but present in EP VIEW', TRIM(TableName),TRIM(ColumnName)
FROM DBC.Columns B
JOIN MOCKRUN_UPG_CHG_LIST A
ON  TRIM(A.UPG_TABLE_NAME)=TRIM(B.TableName)
   AND TRIM(A.USER_VIEW_DB)=TRIM(B.DatabaseName)
 AND A.RUN_ID=MY_RUN_ID
 AND A.CHANGE_TYPE NOT IN ('Table Drop','View Only','Rename Table')
;
 
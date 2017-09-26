SET LINESIZE 250 PAGESIZE 2000
COMPUTE SUM OF LABEL 'TOTAL_BYTES' ON day
COLUMN day FORMAT a12
BREAK ON day SKIP 1
COLUMN segment_name FORMAT a30
COLUMN bytes FORMAT 999,999,999,999

SELECT    TO_CHAR(SYSDATE, 'HH24:MI:SS') DAY, segment_name, bytes
FROM      dba_segments
WHERE     segment_type = 'TEMPORARY'
ORDER BY  3;

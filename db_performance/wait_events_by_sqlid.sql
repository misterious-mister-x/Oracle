-- To get it from Shared Pool.
SELECT    event,
          time_waited "time_waited(s)",
          CASE WHEN time_waited = 0 THEN
            0
          ELSE
            ROUND(time_waited*100 / SUM(time_waited) OVER(), 2)
          END "percentage"
FROM      (
          SELECT    event, SUM(time_waited) time_waited
          FROM      v$active_session_history
          WHERE     sql_id = '&sql_id'
          GROUP BY  event
          )
ORDER BY  time_waited DESC;


-- To obtain from AWR.
SELECT    event,
          time_waited "time_waited(s)",
          CASE WHEN time_waited = 0 THEN
            0
          ELSE
            ROUND(time_waited*100 / SUM(time_waited) OVER(), 2)
          END "percentage"
from      (
          SELECT event, SUM(time_waited) time_waited
          FROM dba_hist_active_sess_history
          WHERE sql_id = '&sql_id'
          GROUP BY event
          )
ORDER BY  time_waited DESC;

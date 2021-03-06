SET SERVEROUTPUT ON
DECLARE
  l_plans_loaded  PLS_INTEGER;
BEGIN
  l_plans_loaded := DBMS_SPM.load_plans_from_cursor_cache(sql_id => '&sql_id', plan_hash_value => &plan_hash_value);
  DBMS_OUTPUT.put_line('Plans Loaded: ' || l_plans_loaded);
END;
/

SELECT  TO_CHAR(created, 'DD-MON-RR HH24:MI:SS') CREATED,
        TO_CHAR(last_modified, 'DD-MON-RR HH24:MI:SS') LAST_MODIFIED,
        TO_CHAR(last_executed, 'DD-MON-RR HH24:MI:SS') LAST_EXECUTED,
        sql_handle,
        plan_name,
        enabled,
        accepted,
        fixed
FROM    dba_sql_plan_baselines
WHERE   signature IN (SELECT exact_matching_signature FROM v$sql WHERE sql_id='&SQL_ID');

SELECT *
FROM   TABLE(DBMS_XPLAN.display_sql_plan_baseline(plan_name=>'&plan_name'));

SET SERVEROUTPUT ON
DECLARE
  l_plans_altered PLS_INTEGER;
BEGIN
  l_plans_altered := DBMS_SPM.alter_sql_plan_baseline(sql_handle => '&sql_handle', plan_name => '&plan_name', attribute_name => 'FIXED', attribute_value => 'YES');
  DBMS_OUTPUT.put_line('Plans Altered: ' || l_plans_altered);
END;
/

SET SERVEROUTPUT ON
DECLARE
  l_plans_dropped  PLS_INTEGER;
BEGIN
  l_plans_dropped := DBMS_SPM.drop_sql_plan_baseline(sql_handle => '&sql_handle', plan_name  => '&plan_name');
  DBMS_OUTPUT.put_line('Plans Dropped: ' ||l_plans_dropped);
END;
/

-- To check if your session you connected is via TCPS.
set serveroutput on
BEGIN
  IF SYS_CONTEXT('USERENV','NETWORK_PROTOCOL')!='tcps' THEN
    DBMS_OUTPUT.PUT_LINE(chr(10)||'TCPS is not enabled.');
  ELSE
    DBMS_OUTPUT.PUT_LINE(chr(10)||'TCPS is enabled.');
  END IF;
END;
/

-- To check if TCPS is enabled for the database.
set serveroutput on
DECLARE
  tcps_count number(5);
BEGIN
  SELECT COUNT(*) INTO tcps_count
  FROM
  (
    SELECT
    CASE WHEN program NOT LIKE 'ora___@% (P%)' THEN
    (
    SELECT  MAX
            (
            CASE  WHEN network_service_banner LIKE '%TCP/IP%' THEN 'TCP'
                  WHEN network_service_banner LIKE '%Bequeath%' THEN 'BEQUEATH'
                  WHEN network_service_banner LIKE '%IPC%' THEN 'IPC'
                  WHEN network_service_banner LIKE '%SDP%' THEN 'SDP'
                  WHEN network_service_banner LIKE '%NAMED P%' THEN 'Named pipe'
                  WHEN network_service_banner IS NULL THEN 'TCPS'
            END
            )
    FROM    v$session_connect_info i
    WHERE   i.sid=s.sid
    )
    END     protocol
    FROM    v$session s
  )
WHERE     protocol = 'TCPS'
GROUP BY  protocol;

  IF tcps_count > 0 THEN
    DBMS_OUTPUT.PUT_LINE(chr(10)||'TCPS is enabled.');
  ELSE
    DBMS_OUTPUT.PUT_LINE(chr(10)||'TCPS is not enabled.');
  END IF;
END;
/
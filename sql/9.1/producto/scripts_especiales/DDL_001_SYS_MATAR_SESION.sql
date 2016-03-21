--SCRIPT PL/SQL PARA CONTROL DE SESIONES, BLOQUEOS, ETC.
--
--DEBE INSTALARSE COMO SYS:
--
--  sqlplus sys / as sysdba @control_de_sesiones_y_bloqueos.sql
--
--Autor: Emilio Elena (enero 2016)


create or replace PROCEDURE "SYS"."MATAR_SESION" (p_sid NUMBER, p_serial NUMBER)
    AS
      v_username VARCHAR2(40);
     BEGIN
		SELECT username
		INTO v_username
		FROM v$session
		WHERE sid = p_sid AND serial# = p_serial;
		
		IF v_username IS NOT NULL AND 
		  (v_username LIKE ('%01%') OR
		   v_username LIKE ('%02%') OR
		   v_username LIKE ('%TX') OR
		   v_username LIKE ('%MASTER') OR
		   v_username LIKE ('RECOVERY_%'))
		THEN		
			EXECUTE immediate 'alter system kill session '''|| p_sid ||','|| p_serial||'''';
		ELSE
			raise_application_error(-20000,'Sesion protegida contra comando KILL');
		END IF;
     END;
/


CREATE OR REPLACE VIEW "SYS"."SESIONES_TRANSACTION"
AS SELECT osuser as "Usuario(S.O)",
		  username as "Usuario(B.D)",
          sid as "Sid",
          serial# as "Serial",
          program as "Programa",
          machine as "Maquina",
          sql_text as "SQL Text",
          start_time as "Hora de Inicio",
          cpu_time/1000000 as "Tiempo de CPU",
          elapsed_time/1000000 as "Tiempo de Ejecucion",
          to_number(sysdate-to_date(c.start_time,'MM/DD/YY HH24:MI:SS'))*24*60 as "Tiempo Actividad Query"
FROM 	  gv$session a, gv$sqlarea b, gv$transaction c
WHERE
          ((a.sql_address = b.address
            and a.sql_hash_value = b.hash_value)
           or (a.prev_sql_addr = b.address
                and a.prev_hash_value = b.hash_value))
           and c.ses_addr = a.saddr
ORDER BY username,
         start_time
;
/


CREATE OR REPLACE VIEW "SYS"."OBJETOS_BLOQUEADOS" AS
SELECT
   c.owner,
   c.object_name,
   c.object_type,
   b.sid,
   b.serial#,
   b.status,
   b.osuser,
   b.machine
from
   v$locked_object a,
   v$session b,
   dba_objects c
where
   b.sid = a.session_id and
   a.object_id = c.object_id
order by 
   c.owner,
   c.object_name,
   c.object_type
;
/

-- otorga permisos para todos nuestros usuarios en todos los clientes:
begin
   FOR x IN (SELECT username FROM dba_users where username LIKE ('BANK%') OR username LIKE ('HAYA%') OR username LIKE ('LIN%') OR username LIKE ('CM%') OR username LIKE ('RECO%') OR username LIKE ('AXA%') OR username LIKE ('PRODUC%')) LOOP
      EXECUTE IMMEDIATE ('GRANT EXECUTE ON SYS.MATAR_SESION TO ' || x.username);
      EXECUTE IMMEDIATE ('GRANT SELECT ON SYS.SESIONES_TRANSACTION TO ' || x.username);
      EXECUTE IMMEDIATE ('GRANT SELECT ON SYS.OBJETOS_BLOQUEADOS TO ' || x.username);
   END LOOP;
end;
/




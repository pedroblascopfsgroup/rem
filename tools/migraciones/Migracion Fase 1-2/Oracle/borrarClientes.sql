-- ****************************************************** --
-- * Este script eliminará aquellos clientes duplicados * --
-- * y ACTIVOS que pertenezcan a la mis perosona.       * --
-- * Además borrará los timers de esos clientes         * --
-- ****************************************************** --

--Creamos una tabla auxiliar de trabajo
CREATE TABLE TEMP_CLIENTES_DUPLICADOS AS
SELECT cli.CLI_ID as cli_id, cli.per_id as per_id, cli.CLI_PROCESS_BPM as bpm_id
FROM CLI_CLIENTES cli, 
(
    SELECT per_id, COUNT (*)
        FROM cli_clientes
       WHERE borrado = 0 AND dd_ecl_id <> 3
    GROUP BY per_id
      HAVING COUNT (*) > 1
) P
WHERE 1=1
    and cli.per_id = P.per_id
    and cli.cli_id NOT IN  
    (
        SELECT min(cli.CLI_ID)
        FROM CLI_CLIENTES cli, 
        (
            SELECT per_id, COUNT (*)
                FROM cli_clientes
               WHERE borrado = 0 AND dd_ecl_id <> 3
            GROUP BY per_id
              HAVING COUNT (*) > 1
        ) P
        WHERE cli.per_id = P.per_id
        GROUP BY cli.per_id
     );


--Actualizamos los clientes como cancelados
update cli_clientes set borrado = 1
where cli_id IN (select cli_id from TEMP_CLIENTES_DUPLICADOS);


--Borramos los timers de los clientes que acabamos de borrar
delete from pfsmaster.jbpm_job
where processinstance_ IN (select bpm_id from TEMP_CLIENTES_DUPLICADOS) 


--Cancelamos los BPM que estuvieran activos para los clientes borrados
update pfsmaster.jbpm_processinstance
set end_ = sysdate, issuspended_ = 1
where id_ IN (select bpm_id from TEMP_CLIENTES_DUPLICADOS) 


commit;

--Borramos la tabla auxiliar de trabajo
DROP TABLE TEMP_CLIENTES_DUPLICADOS;






  
  
  
  
  
  
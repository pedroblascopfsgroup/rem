--/*
--##########################################
--## AUTOR=Pedro S.
--## FECHA_CREACION=20160421
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-xxxx
--## PRODUCTO=NO
--## 
--## Finalidad: Grants a usuarios CM
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
create or replace PROCEDURE ASIGNAR_GRANTS(O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creación: Abril 2015
-- Responsable ultima modificacion: Pedro S.
-- Fecha ultima modificacion: 21/04/2016
-- Motivos del cambio: Añado grants a usuarios Cajamar
-- Cliente: Recovery BI CAJAMAR
--
-- Descripción: Asigna los permisos de las tablas
-- ===============================================================================================

BEGIN

  for rs in (select table_name 
                 from ALL_TABLES 
           where UPPER(OWNER) = 'RECOVERY_CM_DATASTAGE'
                 order by table_name) loop            
        for us in (select username 
                     from ALL_USERS 
               where UPPER(username) IN  ('RECOVERY_CM_DWH','PSM16198','DRS16184')
                     ) loop            
                 
                  EXECUTE IMMEDIATE 'GRANT INDEX, SELECT, INSERT, UPDATE ON RECOVERY_CM_DATASTAGE.' || rs.table_name || ' TO ' || us.username ||'';  
      end loop;
  end loop;
  
  
EXCEPTION
   WHEN OTHERS THEN
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM; 


END ASIGNAR_GRANTS;
/
EXIT



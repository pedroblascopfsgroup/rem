--/*
--##########################################
--## AUTOR=G ESTELLES
--## FECHA_CREACION=20150902
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=-
--## PRODUCTO=SI
--##
--## Finalidad: Actualiza a 32CHAR campos de enlace de sincronización para conectividad entre recovery GUID
--## INSTRUCCIONES: Relanzable.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
   
BEGIN	

    VAR_TABLENAME := 'PRC_PROCEDIMIENTOS';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;
	
    VAR_TABLENAME := 'ASU_ASUNTOS';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;

    VAR_TABLENAME := 'TAR_TAREAS_NOTIFICACIONES';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;

    VAR_TABLENAME := 'RCR_RECURSOS_PROCEDIMIENTOS';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;

    VAR_TABLENAME := 'ACU_ACUERDO_PROCEDIMIENTOS';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;

    VAR_TABLENAME := 'PRB_PRC_BIE';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;
	

    VAR_TABLENAME := 'CEX_CONTRATOS_EXPEDIENTE';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;

    VAR_TABLENAME := 'SUB_SUBASTA';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;

    VAR_TABLENAME := 'LOS_LOTE_SUBASTA';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;

    VAR_TABLENAME := 'EXP_EXPEDIENTES';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;

    VAR_TABLENAME := 'ACU_ACUERDO_PROCEDIMIENTOS';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;

	
    VAR_TABLENAME := 'TEA_TERMINOS_ACUERDO';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;

    VAR_TABLENAME := 'AAR_ACTUACIONES_REALIZADAS';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;

    VAR_TABLENAME := 'AEA_ACTUACIO_EXPLOR_ACUERDO';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;
	
-- COV_CONVENIOS
	VAR_TABLENAME := 'COV_CONVENIOS';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;

-- COV_CONVENIOS_CREDITOS
	VAR_TABLENAME := 'COV_CONVENIOS_CREDITOS';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;
	
-- CRE_PRC_CEX
	VAR_TABLENAME := 'CRE_PRC_CEX';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    V_SQL := 'update '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' SET sys_guid=upper(replace(sys_guid,''-'','''')) where sys_guid is not null';
    EXECUTE IMMEDIATE V_SQL;
	COMMIT;
    V_SQL := 'alter table '||V_ESQUEMA||'.'|| VAR_TABLENAME ||' MODIFY (SYS_GUID VARCHAR(32))';
    EXECUTE IMMEDIATE V_SQL;

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
    
END;
/

EXIT;
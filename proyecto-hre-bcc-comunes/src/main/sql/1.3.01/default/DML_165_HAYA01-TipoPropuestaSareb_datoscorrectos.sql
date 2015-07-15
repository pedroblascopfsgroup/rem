--/*
--##########################################
--## Author: Roberto
--## Finalidad: DDL crear diccionario de datos de Tipo de Propuesta de Elevación a Sareb (Subasta)
--## INSTRUCCIONES:  Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_MSQL_2 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	

    V_SQL := 'delete from DD_TIP_TIPOPROPUESTASAREB ';
    EXECUTE IMMEDIATE V_SQL;		
    
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''Quita'',''Quita'',''Quita'',0,''DML'',sysdate,0)';
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''Desembolso'',''Desembolso'',''Desembolso'',0,''DML'',sysdate,0)';
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''Dación'',''Dación'',''Dación'',0,''DML'',sysdate,0)';
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''Subasta'',''Subasta'',''Subasta'',0,''DML'',sysdate,0)';
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''Ejecución'',''Ejecución'',''Ejecución'',0,''DML'',sysdate,0)';
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''Propuesta Convenio'',''Propuesta de Convenio'',''Propuesta de Convenio'',0,''DML'',sysdate,0)';
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''Restructuración'',''Restructuración'',''Restructuración'',0,''DML'',sysdate,0)';
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''Venta de Deuda'',''Venta de Deuda'',''Venta de Deuda'',0,''DML'',sysdate,0)';
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''AutoQuita'',''AutoQuita'',''AutoQuita'',0,''DML'',sysdate,0)';
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''Liberación IPF'',''Liberación IPF'',''Liberación IPF'',0,''DML'',sysdate,0)';
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''FS Informativo'',''FS Informativo'',''FS Informativo'',0,''DML'',sysdate,0)';
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''PDV'',''PDV'',''PDV'',0,''DML'',sysdate,0)';
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''Revisión de PDVs'',''Revisión de PDVs'',''Revisión de PDVs'',0,''DML'',sysdate,0)';
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''Planes Liquidación'',''Planes de Liquidación'',''Planes de Liquidación'',0,''DML'',sysdate,0)';
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''Quita Indiv. PA 2014'',''Quita Individual PA 2014'',''Quita Individual PA 2014'',0,''DML'',sysdate,0)';
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''PDV PA 2014'',''PDV PA 2014'',''PDV PA 2014'',0,''DML'',sysdate,0)';
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'insert into DD_TIP_TIPOPROPUESTASAREB (dd_tip_id,dd_tip_codigo,dd_tip_descripcion,dd_tip_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TIP_TIPOPROPUESTASAREB.nextval,''Refinanciaciones'',''Refinanciaciones'',''Refinanciaciones'',0,''DML'',sysdate,0)';    
	EXECUTE IMMEDIATE V_SQL;

    commit;


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

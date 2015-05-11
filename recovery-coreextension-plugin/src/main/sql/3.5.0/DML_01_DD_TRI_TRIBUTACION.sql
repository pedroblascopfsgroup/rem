--/*
--##########################################
--## Author: Nacho
--## Finalidad: DDL crear diccionario de datos de Tributación
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
    V_MSQL_3 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_MSQL_4 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_MSQL_5 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	

    DBMS_OUTPUT.PUT_LINE('******** DD_TRI_TRIBUTACION ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TRI_TRIBUTACION... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TRI_TRIBUTACION';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la PK
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.DD_TRI_TRIBUTACION...no se modificará nada.');
	ELSE
		V_MSQL_1 := 'insert into DD_TRI_TRIBUTACION (dd_tri_id,dd_tri_codigo,dd_tri_descripcion,dd_tri_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TRI_TRIBUTACION.nextval,''ITP'',''ITP'',''ITP'',0,''DML'',sysdate,0)';
		V_MSQL_2 := 'insert into DD_TRI_TRIBUTACION (dd_tri_id,dd_tri_codigo,dd_tri_descripcion,dd_tri_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TRI_TRIBUTACION.nextval,''IGIC'',''IGIC Deducible'',''IGIC Deducible'',0,''DML'',sysdate,0)';
        V_MSQL_3 := 'insert into DD_TRI_TRIBUTACION (dd_tri_id,dd_tri_codigo,dd_tri_descripcion,dd_tri_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TRI_TRIBUTACION.nextval,''IGICNO'',''IGIC No Deducible'',''IGIC No Deducible'',0,''DML'',sysdate,0)';
    	V_MSQL_4 := 'insert into DD_TRI_TRIBUTACION (dd_tri_id,dd_tri_codigo,dd_tri_descripcion,dd_tri_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TRI_TRIBUTACION.nextval,''IVA'',''IVA Sujeto y Deducible'',''IVA Sujeto y Deducible'',0,''DML'',sysdate,0)';
    	V_MSQL_5 := 'insert into DD_TRI_TRIBUTACION (dd_tri_id,dd_tri_codigo,dd_tri_descripcion,dd_tri_descripcion_larga,version,usuariocrear,fechacrear,borrado) values(S_DD_TRI_TRIBUTACION.nextval,''IVANO'',''IVA Sujeto y No Deducible'',''IVA Sujeto y No Deducible'',0,''DML'',sysdate,0)';
    END IF;		

    EXECUTE IMMEDIATE V_MSQL_1;
    EXECUTE IMMEDIATE V_MSQL_2;
    EXECUTE IMMEDIATE V_MSQL_3;
    EXECUTE IMMEDIATE V_MSQL_4;
    EXECUTE IMMEDIATE V_MSQL_5;
    
    commit;

	DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.DD_TRI_TRIBUTACION ya insertados.');	
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');


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

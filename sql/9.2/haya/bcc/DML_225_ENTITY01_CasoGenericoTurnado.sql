--/*
--##########################################
--## AUTOR=Alberto Soler
--## FECHA_CREACION=20160527
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK= PRODUCTO-1435
--## PRODUCTO=NO
--##
--## Finalidad: DML
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_REG_EXT VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    V_NUM_TABLAS2 NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_TABLAS3 NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_TABLAS4 NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    v_numero NUMBER(16);
BEGIN	

    
	-------------------------------
	-------CONFIGURACIÓN DE CASOS GENÉRICOS TURNADO
	-------[INICIO]
	----------------------------------------------------------------

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TUP_ETP_ESQ_TURNADO_PROCU ... Insertar registros');
	V_MSQL := 'SELECT count(1) FROM all_tables where TABLE_NAME= ''TUP_ETP_ESQ_TURNADO_PROCU'' ';
	EXECUTE IMMEDIATE V_MSQL INTO v_numero;
  DBMS_OUTPUT.PUT_LINE('[INFO] el numero es:  '||v_numero);
  
  IF v_numero > 0 THEN
  V_MSQL := 'Insert into '||V_ESQUEMA||'.TUP_ETP_ESQ_TURNADO_PROCU
   (ETP_ID, ETP_CODIGO, ETP_DESCRIPCION, ETP_DESCRIPCION_LARGA, DD_EET_ID, ETP_FECHA_INI_VIGENCIA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ('||V_ESQUEMA||'.S_TUP_ETP_ESQ_TURNADO_PROCU.NEXTVAL, ''1'', ''Genérica'', ''Genérica'', 2, SYSDATE, 0, ''ODG'', SYSDATE, 0)';
		DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO:  '||V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[FIN] Registros insertados en la tabla '||V_ESQUEMA||'.TUP_ETP_ESQ_TURNADO_PROCU ');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[FIN] No existe la tabla '||V_ESQUEMA||'.TUP_ETP_ESQ_TURNADO_PROCU ');
  END IF;




  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TUP_EPT_ESQUEMA_PLAZAS_TPO ... Insertar registros');
  V_MSQL := 'SELECT count(1) FROM all_tables where TABLE_NAME= ''TUP_EPT_ESQUEMA_PLAZAS_TPO'' ';
  EXECUTE IMMEDIATE V_MSQL INTO v_numero;
  DBMS_OUTPUT.PUT_LINE('[INFO] el numero es:  '||v_numero);
  
  V_SQL := 'SELECT ETP_ID FROM '||V_ESQUEMA||'.TUP_ETP_ESQ_TURNADO_PROCU where ETP_CODIGO= ''1'' and rownum=1';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  IF v_numero > 0 THEN
  V_MSQL := 'Insert into '||V_ESQUEMA||'.TUP_EPT_ESQUEMA_PLAZAS_TPO
    (EPT_ID, ETP_ID, EPT_GRUPO_ASIGNADO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ('||V_ESQUEMA||'.S_TUP_EPT_ESQUEMA_PLAZAS_TPO.NEXTVAL, '||V_NUM_TABLAS||', 1, 0, ''ODG'', SYSDATE, 0)';
    DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO:  '||V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[FIN] Registros insertados en la tabla '||V_ESQUEMA||'.TUP_EPT_ESQUEMA_PLAZAS_TPO ');
  ELSE
    DBMS_OUTPUT.PUT_LINE('[FIN] No existe la tabla '||V_ESQUEMA||'.TUP_EPT_ESQUEMA_PLAZAS_TPO ');
  END IF;
  

  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TUP_TPC_TURNADO_PROCU_CONFIG ... Insertar registros');
  V_MSQL := 'SELECT count(1) FROM all_tables where TABLE_NAME= ''TUP_TPC_TURNADO_PROCU_CONFIG'' ';
  EXECUTE IMMEDIATE V_MSQL INTO v_numero;
  DBMS_OUTPUT.PUT_LINE('[INFO] el numero es:  '||v_numero);
  
  V_SQL := 'SELECT EPT_ID FROM '||V_ESQUEMA||'.TUP_EPT_ESQUEMA_PLAZAS_TPO where DD_PLA_ID IS NULL AND DD_TPO_ID IS NULL and rownum=1';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  V_SQL := 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS where USU_USERNAME = ''GRLECO''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS2;
  IF v_numero > 0 THEN
  V_MSQL := 'Insert into '||V_ESQUEMA||'.TUP_TPC_TURNADO_PROCU_CONFIG
   (TPC_ID, EPT_ID, TPC_IMPORTE_DESDE, TPC_IMPORTE_HASTA, TPC_PORCENTAJE, USU_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   ('||V_ESQUEMA||'.S_TUP_TPC_TURNADO_PROCU_CONFIG.NEXTVAL, '||V_NUM_TABLAS||', 0, 999999999, 100, '||V_NUM_TABLAS2||', 0, ''ODG'', SYSDATE, 0)';
    DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO:  '||V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[FIN] Registros insertados en la tabla '||V_ESQUEMA||'.TUP_TPC_TURNADO_PROCU_CONFIG ');
  ELSE
    DBMS_OUTPUT.PUT_LINE('[FIN] No existe la tabla '||V_ESQUEMA||'.TUP_TPC_TURNADO_PROCU_CONFIG ');
  END IF;

	COMMIT;
	    
    -------------------------------
	-------CONFIGURACIÓN DE CASOS GENÉRICOS TURNADO
	-------[FIN]
	----------------------------------------------------------------
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
  	
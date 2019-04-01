--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20190307
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3539
--## PRODUCTO=NO
--##
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-3013'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    ACT_NUM_ACTIVO NUMBER(16);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV(70925),
		T_JBV(142952),
		T_JBV(154734),
		T_JBV(151280),
		T_JBV(154736),
		T_JBV(173818),
		T_JBV(159119),
		T_JBV(159125),
		T_JBV(138234)
	); 
	V_TMP_JBV T_JBV;
    
BEGIN	

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	ACT_NUM_ACTIVO := TRIM(V_TMP_JBV(1));
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION COLUMNA ACT_NUM_ACTIVO');
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO 
				   SET ACT_NUM_ACTIVO = -'||ACT_NUM_ACTIVO||', 
				   ACT_NUM_ACTIVO_SAREB = NULL, 
				   ACT_RECOVERY_ID = NULL, 
				   BORRADO = 1, 
				   USUARIOBORRAR = '''||V_USR||''', 
				   FECHABORRAR = SYSDATE 
				   WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO;
	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[FIN] REGISTRO CON ACT_NUM_ACTIVO: '||ACT_NUM_ACTIVO||' ACTUALIZADO');
		
		V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[FIN] REGISTRO NO EXISTE');
		
	END IF;
	
	END LOOP;
		
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado en total '||V_COUNT_UPDATE||' registros');
 
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

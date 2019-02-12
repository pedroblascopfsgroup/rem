--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20191209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3013
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
		T_JBV(15812687),
		T_JBV(16606646),
		T_JBV(16606763),
		T_JBV(16606880),
		T_JBV(17859053),
		T_JBV(19680930),
		T_JBV(19681005),
		T_JBV(19681122),
		T_JBV(19681239),
		T_JBV(19681356),
		T_JBV(19681473),
		T_JBV(19681590),
		T_JBV(19681608),
		T_JBV(19681725),
		T_JBV(19681842),
		T_JBV(19681959),
		T_JBV(19682034),
		T_JBV(19682151),
		T_JBV(19682268),
		T_JBV(19682385),
		T_JBV(19682403),
		T_JBV(19682520),
		T_JBV(19682637),
		T_JBV(19682754),
		T_JBV(19682871),
		T_JBV(19682988),
		T_JBV(19683063),
		T_JBV(19683180),
		T_JBV(19683297),
		T_JBV(19683315),
		T_JBV(19683432),
		T_JBV(19683549),
		T_JBV(19683666),
		T_JBV(19683783),
		T_JBV(95748)
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

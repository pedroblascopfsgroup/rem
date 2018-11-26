--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20181106
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2443
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
    V_TABLA VARCHAR2(45 CHAR); -- Nombre de la tabla
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-2443'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
							T_JBV('BIE_ANC_ANALISIS_CONTRATOS'),
							T_JBV('BIE_CAR_CARGAS'),
							T_JBV('BIE_ADJ_ADJUDICACION'),
							T_JBV('BIE_TEA'),
							T_JBV('BIE_BIEN_ENTIDAD'),
							T_JBV('PRB_PRC_BIE'),
							T_JBV('BIE_SUI_SUBASTA_INSTRUCCIONES'),
							T_JBV('BIE_VALORACIONES'),
							T_JBV('BIE_CNT'),
							T_JBV('BIE_DATOS_REGISTRALES'),
							T_JBV('BIE_LOCALIZACION'),
							T_JBV('BIE_PER'),
							T_JBV('BIE_ADICIONAL'),
							T_JBV('BIE_BIEN'),
							T_JBV('HAC_HISTORICO_ACCESOS'),
							T_JBV('EMP_EMBARGOS_PROCEDIMIENTOS'),
							T_JBV('EMP_NMBEMBARGOS_PROCEDIMIENTOS'),
							T_JBV('ACT_ACTIVO')); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION COLUMNA BORRADO');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	V_TABLA := TRIM(V_TMP_JBV(1));
  	
  	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TABLA||' 
			  WHERE BIE_ID = (SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 78574)';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS <> 0 THEN
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
			SET BORRADO = 0,
			USUARIOMODIFICAR = '''||V_USR||''',
			FECHAMODIFICAR = SYSDATE 
			WHERE BIE_ID = (SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 78574)
			AND USUARIOBORRAR = ''REMVIP-436''
			AND BORRADO = 1';
	
	EXECUTE IMMEDIATE V_MSQL;
    
	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla: '||V_TABLA||' ACTUALIZADA');
		
	V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla: '||V_TABLA||' no cumple la condicion como para ser actualizada');
		
	END IF;
	
	END LOOP;
		
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE||' tablas con columna BIE_ID');
 
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

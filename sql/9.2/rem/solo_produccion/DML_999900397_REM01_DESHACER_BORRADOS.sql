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
							T_JBV('ACT_ADO_ADMISION_DOCUMENTO'),
							T_JBV('ACT_AGA_AGRUPACION_ACTIVO'),
							T_JBV('ACT_FOT_FOTO'),
							T_JBV('ACT_TBJ_TRABAJO'),
							T_JBV('ACT_AOB_ACTIVO_OBS'),
							T_JBV('ACT_TAS_TASACION'),
							T_JBV('ACT_TRA_TRAMITE'),
							T_JBV('ACT_PTO_PRESUPUESTO'),
							T_JBV('ACT_AAH_AGRUP_ACTIVO_HIST'),
							T_JBV('ACT_HVA_HIST_VALORACIONES'),
							T_JBV('ACT_COE_CONDICION_ESPECIFICA'),
							T_JBV('ACT_HEP_HIST_EST_PUBLICACION'),
							T_JBV('VIS_VISITAS'),
							T_JBV('ECO_COND_CONDICIONES_ACTIVO'),
							T_JBV('ECB_ESTADOS_COMERCIAL_BK'),
							T_JBV('ECO_TAN_TANTEO_ACTIVO'),
							T_JBV('ACT_ECO_INFORME_JURIDICO'),
							T_JBV('ACT_CAC_COPROP_ACTIVO'),
							T_JBV('ACT_AMO_ACTIVOS_MOD'),
							T_JBV('ACT_ACTIVO_BNK'),
							T_JBV('GC3464_ACT_TIT_TITULO'),
							T_JBV('ACT_ACTIVO'),
							T_JBV('TAC_TAREAS_ACTIVOS'),
							T_JBV('ACT_ADM_INF_ADMINISTRATIVA'),
							T_JBV('ACT_PAC_PROPIETARIO_ACTIVO'),
							T_JBV('ACT_TIT_TITULO'),
							T_JBV('ACT_ADA_ADJUNTO_ACTIVO'),
							T_JBV('ACT_AJD_ADJJUDICIAL'),
							T_JBV('ACT_PDV_PLAN_DIN_VENTAS'),
							T_JBV('ACT_ADN_ADJNOJUDICIAL'),
							T_JBV('ACT_LLV_LLAVE'),
							T_JBV('ACT_SPS_SIT_POSESORIA'),
							T_JBV('ACT_VAL_VALORACIONES'),
							T_JBV('ACT_REG_INFO_REGISTRAL'),
							T_JBV('ACT_LOC_LOCALIZACION'),
							T_JBV('ACT_CRG_CARGAS'),
							T_JBV('ACT_CAT_CATASTRO'),
							T_JBV('ACT_ICO_INFO_COMERCIAL'),
							T_JBV('GEX_GASTOS_EXPEDIENTE'),
							T_JBV('ACT_HIC_EST_INF_COMER_HIST'),
							T_JBV('ACT_ICM_INF_COMER_HIST_MEDI'),
							T_JBV('AIN_ACTIVO_INTEGRADO'),
							T_JBV('ACT_PAC_PERIMETRO_ACTIVO'),
							T_JBV('ACT_ABA_ACTIVO_BANCARIO'),
							T_JBV('ACT_BEX_BLOQ_EXP_FORMALIZAR'),
							T_JBV('ACT_HAL_HIST_ALQUILERES'),
							T_JBV('DGG_DOC_GES_GASTOS'),
							T_JBV('AIA_ADMIN_IMPUESTOS_ACTIVO'),
							T_JBV('GPL_GASTOS_PRINEX_LBK'),
							T_JBV('ACT_PTA_PATRIMONIO_ACTIVO'),
							T_JBV('HIST_PTA_PATRIMONIO_ACTIVO')); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION COLUMNA BORRADO');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	V_TABLA := TRIM(V_TMP_JBV(1));
  	
  	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TABLA||' 
			  WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 78574)';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS <> 0 THEN
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
			SET BORRADO = 0,
			USUARIOMODIFICAR = '''||V_USR||''',
			FECHAMODIFICAR = SYSDATE 
			WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 78574)
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
	
	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE||' tablas con columna ACT_ID');
 
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

--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200811
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6692
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_MSQL1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	V_TABLA VARCHAR2(2400 CHAR) := 'AUX_REMVIP_6692'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TABLA_ICO VARCHAR2(2400 CHAR) := 'ACT_ICO_INFO_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TABLA_VIV VARCHAR2(2400 CHAR) := 'ACT_VIV_VIVIENDA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TABLA_APR VARCHAR2(2400 CHAR) := 'ACT_APR_PLAZA_APARCAMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TABLA_LCO VARCHAR2(2400 CHAR) := 'ACT_LCO_LOCAL_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6692';

    
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	/*
	--ACT_BNY_BANYO
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR DATOS EN ACT_BNY_BANYO');
	
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_BNY_BANYO WHERE ICO_ID IN
				(
				SELECT DISTINCT ICO_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' 
				WHERE BORRADO = 1
			)';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS BORRADOS EN ACT_BNY_BANYO');
    
    
    --ACT_CRE_CARPINTERIA_EXT
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR DATOS EN ACT_CRE_CARPINTERIA_EXT');
	
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT WHERE ICO_ID IN
				(
				SELECT DISTINCT ICO_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' 
				WHERE BORRADO = 1
			)';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS BORRADOS EN ACT_CRE_CARPINTERIA_EXT');
    
    
    --ACT_CRI_CARPINTERIA_INT
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR DATOS EN ACT_CRI_CARPINTERIA_INT');
	
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT WHERE ICO_ID IN
				(
				SELECT DISTINCT ICO_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' 
				WHERE BORRADO = 1
			)';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS BORRADOS EN ACT_CRI_CARPINTERIA_INT');
    
    
    --ACT_COC_COCINA
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR DATOS EN ACT_COC_COCINA');
	
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_COC_COCINA WHERE ICO_ID IN
				(
				SELECT DISTINCT ICO_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' 
				WHERE BORRADO = 1
			)';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS BORRADOS EN ACT_COC_COCINA');
    
    
    
    --ACT_DIS_DISTRIBUCION
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR DATOS EN ACT_DIS_DISTRIBUCION');
	
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION WHERE ICO_ID IN
				(
				SELECT DISTINCT ICO_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' 
				WHERE BORRADO = 1
			)';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS BORRADOS EN ACT_DIS_DISTRIBUCION');
    
      
    
    --ACT_EDI_EDIFICIO
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR DATOS EN ACT_EDI_EDIFICIO');
	
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_EDI_EDIFICIO WHERE ICO_ID IN
				(
				SELECT DISTINCT ICO_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' 
				WHERE BORRADO = 1
			)';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS BORRADOS EN ACT_EDI_EDIFICIO');
    
    
    
    --ACT_INF_INFRAESTRUCTURA
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR DATOS EN ACT_INF_INFRAESTRUCTURA');
	
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA WHERE ICO_ID IN
				(
				SELECT DISTINCT ICO_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' 
				WHERE BORRADO = 1
			)';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS BORRADOS EN ACT_INF_INFRAESTRUCTURA');
    
    
    
    --ACT_INS_INSTALACION
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR DATOS EN ACT_INS_INSTALACION');
	
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_INS_INSTALACION WHERE ICO_ID IN
				(
				SELECT DISTINCT ICO_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' 
				WHERE BORRADO = 1
			)';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS BORRADOS EN ACT_INS_INSTALACION');
    
    
    --ACT_PRV_PARAMENTO_VERTICAL
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR DATOS EN ACT_PRV_PARAMENTO_VERTICAL');
	
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL WHERE ICO_ID IN
				(
				SELECT DISTINCT ICO_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' 
				WHERE BORRADO = 1
			)';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS BORRADOS EN ACT_PRV_PARAMENTO_VERTICAL');
    
    
    --ACT_SOL_SOLADO
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR DATOS EN ACT_SOL_SOLADO');
	
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_SOL_SOLADO WHERE ICO_ID IN
				(
				SELECT DISTINCT ICO_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' 
				WHERE BORRADO = 1
			)';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS BORRADOS EN ACT_SOL_SOLADO');
    
    
    --ACT_ZCO_ZONA_COMUN
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR DATOS EN ACT_ZCO_ZONA_COMUN');
	
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN WHERE ICO_ID IN
				(
				SELECT DISTINCT ICO_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' 
				WHERE BORRADO = 1
			)';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS BORRADOS EN ACT_ZCO_ZONA_COMUN');
    
    --ACT_VIV_VIVIENDA
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR DATOS EN '''||V_TABLA_VIV||'''');
	
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA_VIV||' WHERE ICO_ID IN
				(
				SELECT DISTINCT ICO_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' 
				WHERE BORRADO = 1
			)';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS BORRADOS EN '''||V_TABLA_VIV||'''');
    
    --ACT_LCO_LOCAL_COMERCIAL
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR DATOS EN '''||V_TABLA_LCO||'''');
	
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA_LCO||' WHERE ICO_ID IN
				(
				SELECT DISTINCT ICO_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' 
				WHERE BORRADO = 1
			)';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS BORRADOS EN '''||V_TABLA_LCO||'''');
    
    --ACT_APR_PLAZA_APARCAMIENTO
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR DATOS EN '''||V_TABLA_APR||'''');
	
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA_APR||' WHERE ICO_ID IN
				(
				SELECT DISTINCT ICO_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' 
				WHERE BORRADO = 1
			)';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS BORRADOS EN '''||V_TABLA_APR||'''');
    
    COMMIT;

	--COPIA DE SEGURIDAD INICIAL
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRANDO Y INSERTANDO DATOS EN ICO_INFO_COMERCIAL');
	
	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' WHERE BORRADO = 1';
			
	EXECUTE IMMEDIATE V_MSQL;
	COMMIT;
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO USING
				(
				SELECT DISTINCT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA||'
			)AUX ON (AUX.ICO_ID = ICO.ICO_ID) 
			WHEN MATCHED THEN UPDATE SET ICO.BORRADO = 1, ICO.USUARIOBORRAR = '''||V_USUARIO||''', ICO.FECHABORRAR = SYSDATE, ICO.ICO_MEDIADOR_ID = NULL, ICO.ICO_WEBCOM_ID = NULL';
			
	EXECUTE IMMEDIATE V_MSQL;
	COMMIT;
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET DD_TIC_ID = NULL';
	COMMIT;*/
	V_MSQL1 := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ICO||'
				SELECT '||V_ESQUEMA||'.S_'||V_TABLA_ICO||'.NEXTVAL, 
										ACT_ID, 
										DD_UAC_ID, 
										DD_ECT_ID, 
										DD_ECV_ID, 
										DD_TIC_ID, 
										ICO_MEDIADOR_ID, 
										ICO_DESCRIPCION, 
										ICO_ANO_CONSTRUCCION, 
										ICO_ANO_REHABILITACION, 
										ICO_APTO_PUBLICIDAD, 
										ICO_ACTIVOS_VINC, 
										ICO_FECHA_EMISION_INFORME, 
										ICO_FECHA_ULTIMA_VISITA, 
										ICO_FECHA_ACEPTACION, 
										ICO_FECHA_RECHAZO, 
										ICO_CONDICIONES_LEGALES, 
										VERSION, 
										USUARIOCREAR, 
										FECHACREAR, 
										USUARIOMODIFICAR,
										FECHAMODIFICAR,
										USUARIOBORRAR,
										FECHABORRAR,									
										BORRADO, 
										ICO_AUTORIZACION_WEB, 
										ICO_FECHA_AUTORIZ_HASTA, 
										ICO_FECHA_RECEP_LLAVES, 
										DD_TPA_ID, 
										DD_SAC_ID, 
										DD_EAC_ID, 
										DD_TVI_ID, 
										ICO_NOMBRE_VIA, 
										ICO_NUM_VIA, 
										ICO_ESCALERA, 
										ICO_PLANTA, 
										ICO_PUERTA, 
										ICO_LATITUD, 
										ICO_LONGITUD, 
										ICO_ZONA, 
										ICO_DISTRITO, 
										DD_LOC_ID, 
										DD_PRV_ID, 
										ICO_CODIGO_POSTAL, 
										ICO_JUSTIFICACION_VENTA, 
										ICO_JUSTIFICACION_RENTA, 
										ICO_CUOTACP_ORIENTATIVA, 
										ICO_DERRAMACP_ORIENTATIVA, 
										ICO_FECHA_ESTIMACION_VENTA, 
										ICO_FECHA_ESTIMACION_RENTA, 
										DD_UPO_ID, 
										ICO_INFO_DESCRIPCION, 
										ICO_INFO_DISTRIBUCION_INTERIOR, 
										DD_DIS_ID, 
										ICO_WEBCOM_ID, 
										ICO_POSIBLE_HACER_INF, 
										ICO_MOTIVO_NO_HACER_INF, 
										ICO_FECHA_RECEP_LLAVES_HAYA, 
										ICO_FECHA_ENVIO_LLAVES_API, 
										ICO_RECIBIO_IMPORTE_ADM, 
										ICO_IBI_IMPORTE_ADM, 
										ICO_DERRAMA_IMPORTE_ADM, 
										ICO_DET_DERRAMA_IMPORTE_ADM, 
										DD_TVP_ID, 
										ICO_VALOR_MAX_VPO, 
										ICO_VALOR_ESTIMADO_VENTA, 
										ICO_VALOR_ESTIMADO_RENTA, 
										ICO_OCUPADO, 
										ICO_NUM_TERRAZA_DESCUBIERTA, 
										ICO_DESC_TERRAZA_DESCUBIERTA, 
										ICO_NUM_TERRAZA_CUBIERTA, 
										ICO_DESC_TERRAZA_CUBIERTA, 
										ICO_DESPENSA_OTRAS_DEP, 
										ICO_LAVADERO_OTRAS_DEP, 
										ICO_AZOTEA_OTRAS_DEP, 
										ICO_OTROS_OTRAS_DEP, 
										ICO_PRESIDENTE_NOMBRE, 
										ICO_PRESIDENTE_TELF, 
										ICO_ADMINISTRADOR_NOMBRE, 
										ICO_ADMINISTRADOR_TELF, 
										ICO_EXIS_COM_PROP, 
										DD_LOC_REGISTRO_ID, 
										ICO_MEDIADOR_ESPEJO_ID FROM '||V_ESQUEMA||'.'||V_TABLA;
			
	EXECUTE IMMEDIATE V_MSQL1;
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS BORRADOS Y INSERTADOS EN ICO_INFO_COMERCIAL');
	COMMIT;
	
	
	--1.-VIVIENDA
	EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA;
	EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
				SELECT DISTINCT ICO.* FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO ON ICO.ACT_ID = ACT.ACT_ID AND ICO.BORRADO = 0
				INNER JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID AND TPA.BORRADO = 0
				LEFT JOIN '||V_ESQUEMA||'.DD_TIC_TIPO_INFO_COMERCIAL TIC ON TIC.DD_TIC_ID = ICO.DD_TIC_ID AND TIC.BORRADO = 0
				LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_VIV||' VIV ON VIV.ICO_ID = ICO.ICO_ID
				LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_APR||' APR ON APR.ICO_ID = ICO.ICO_ID
				LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_LCO||' LCO ON LCO.ICO_ID = ICO.ICO_ID 
				WHERE ACT.BORRADO = 0 AND TPA.DD_TPA_CODIGO = ''02'' AND (VIV.ICO_ID IS NULL OR APR.ICO_ID IS NOT NULL OR LCO.ICO_ID IS NOT NULL)';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET DD_TIC_ID = 1';
	COMMIT;
		
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN ICO_INFO_COMERCIAL DE VIVIENDAS');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO USING
				(
				SELECT DISTINCT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA||'
			)AUX ON (AUX.ICO_ID = ICO.ICO_ID) 
			WHEN MATCHED THEN UPDATE SET ICO.BORRADO = 1, ICO.USUARIOBORRAR = '''||V_USUARIO||''', ICO.FECHABORRAR = SYSDATE, ICO.ICO_MEDIADOR_ID = NULL, ICO.ICO_WEBCOM_ID = NULL';
			
	EXECUTE IMMEDIATE V_MSQL;
	COMMIT;
	
	
			
	EXECUTE IMMEDIATE V_MSQL1;
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN ICO_INFO_COMERCIAL DE VIVIENDAS');
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR DATOS EN VIVIENDA');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_VIV||' VIV USING
				(
				SELECT DISTINCT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA||'
			)AUX ON (AUX.ICO_ID = VIV.ICO_ID) 
			WHEN NOT MATCHED THEN INSERT (ICO_ID) VALUES (AUX.ICO_ID)';
			
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS INSERTADOS EN VIVIENDA');
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN INFORME COMERCIAL DE VIVIENDAS');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO USING
				(
				SELECT DISTINCT ICO.ICO_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO ON ICO.ACT_ID = ACT.ACT_ID AND ICO.BORRADO = 0
				INNER JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID AND TPA.BORRADO = 0
				LEFT JOIN '||V_ESQUEMA||'.DD_TIC_TIPO_INFO_COMERCIAL TIC ON TIC.DD_TIC_ID = ICO.DD_TIC_ID AND TIC.BORRADO = 0
				LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_VIV||' VIV ON VIV.ICO_ID = ICO.ICO_ID
				LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_APR||' APR ON APR.ICO_ID = ICO.ICO_ID
				LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_LCO||' LCO ON LCO.ICO_ID = ICO.ICO_ID 
				WHERE ACT.BORRADO = 0 AND TPA.DD_TPA_CODIGO = ''02'' AND VIV.ICO_ID IS NOT NULL AND ICO.DD_TIC_ID != 1
			)AUX ON (AUX.ICO_ID = ICO.ICO_ID) 
			WHEN MATCHED THEN UPDATE SET ICO.DD_TIC_ID = 1, ICO.USUARIOMODIFICAR = '''||V_USUARIO||''', ICO.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN INFORME COMERCIAL DE VIVIENDAS');
	COMMIT;
	
	
	--2.-LOCAL COMERCIAL
	
	
	EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA;
	EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
				SELECT DISTINCT ICO.* FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO ON ICO.ACT_ID = ACT.ACT_ID AND ICO.BORRADO = 0
				INNER JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID AND TPA.BORRADO = 0
				LEFT JOIN '||V_ESQUEMA||'.DD_TIC_TIPO_INFO_COMERCIAL TIC ON TIC.DD_TIC_ID = ICO.DD_TIC_ID AND TIC.BORRADO = 0
				LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_VIV||' VIV ON VIV.ICO_ID = ICO.ICO_ID
				LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_APR||' APR ON APR.ICO_ID = ICO.ICO_ID
				LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_LCO||' LCO ON LCO.ICO_ID = ICO.ICO_ID 
				WHERE ACT.BORRADO = 0 AND TPA.DD_TPA_CODIGO = ''03'' AND (VIV.ICO_ID IS NOT NULL OR APR.ICO_ID IS NOT NULL OR LCO.ICO_ID IS NULL)';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET DD_TIC_ID = 2';			
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN ICO_INFO_COMERCIAL DE LOCALES COMERCIALES');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO USING
				(
				SELECT DISTINCT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA||'
			)AUX ON (AUX.ICO_ID = ICO.ICO_ID) 
			WHEN MATCHED THEN UPDATE SET ICO.BORRADO = 1, ICO.USUARIOBORRAR = '''||V_USUARIO||''', ICO.FECHABORRAR = SYSDATE, ICO.ICO_MEDIADOR_ID = NULL, ICO.ICO_WEBCOM_ID = NULL';
			
	EXECUTE IMMEDIATE V_MSQL;
	COMMIT;
	
	
	EXECUTE IMMEDIATE V_MSQL1;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN ICO_INFO_COMERCIAL DE LOCALES COMERCIALES');
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR DATOS EN LOCAL COMERCIAL');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_LCO||' LCO USING
				(
				SELECT DISTINCT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA||'
			)AUX ON (AUX.ICO_ID = LCO.ICO_ID) 
			WHEN NOT MATCHED THEN INSERT (ICO_ID) VALUES (AUX.ICO_ID)';
			
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS INSERTADOS EN LOCAL COMERCIAL');
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN ICO_INFO_COMERCIAL DE LOCALES COMERCIALES');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO USING
				(
				SELECT DISTINCT ICO.ICO_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO ON ICO.ACT_ID = ACT.ACT_ID AND ICO.BORRADO = 0
				INNER JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID AND TPA.BORRADO = 0
				LEFT JOIN '||V_ESQUEMA||'.DD_TIC_TIPO_INFO_COMERCIAL TIC ON TIC.DD_TIC_ID = ICO.DD_TIC_ID AND TIC.BORRADO = 0
				LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_VIV||' VIV ON VIV.ICO_ID = ICO.ICO_ID
				LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_APR||' APR ON APR.ICO_ID = ICO.ICO_ID
				LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_LCO||' LCO ON LCO.ICO_ID = ICO.ICO_ID 
				WHERE ACT.BORRADO = 0 AND TPA.DD_TPA_CODIGO = ''03'' AND LCO.ICO_ID IS NOT NULL AND ICO.DD_TIC_ID != 2
			)AUX ON (AUX.ICO_ID = ICO.ICO_ID) 
			WHEN MATCHED THEN UPDATE SET ICO.DD_TIC_ID = 2, ICO.USUARIOMODIFICAR = '''||V_USUARIO||''', ICO.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN ICO_INFO_COMERCIAL DE LOCALES COMERCIALES');
	COMMIT;
	
	
	--3.-PLAZA APARCAMIENTO
	
	EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA;
	EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
					SELECT DISTINCT ICO.* FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
					INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO ON ICO.ACT_ID = ACT.ACT_ID AND ICO.BORRADO = 0
					INNER JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID AND TPA.BORRADO = 0
					INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_ID = ACT.DD_SAC_ID AND SAC.BORRADO = 0
					LEFT JOIN '||V_ESQUEMA||'.DD_TIC_TIPO_INFO_COMERCIAL TIC ON TIC.DD_TIC_ID = ICO.DD_TIC_ID AND TIC.BORRADO = 0
					LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_VIV||' VIV ON VIV.ICO_ID = ICO.ICO_ID
					LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_APR||' APR ON APR.ICO_ID = ICO.ICO_ID
					LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_LCO||' LCO ON LCO.ICO_ID = ICO.ICO_ID 
					WHERE ACT.BORRADO = 0 AND SAC.DD_SAC_CODIGO = ''24'' AND TPA.DD_TPA_CODIGO = ''07'' AND (VIV.ICO_ID IS NOT NULL OR APR.ICO_ID IS NULL OR LCO.ICO_ID IS NOT NULL)';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET DD_TIC_ID = 3';
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN ICO_INFO_COMERCIAL DE PLAZAS APARCAMIENTO');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO USING
				(
				SELECT DISTINCT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA||'
			)AUX ON (AUX.ICO_ID = ICO.ICO_ID) 
			WHEN MATCHED THEN UPDATE SET ICO.BORRADO = 1, ICO.USUARIOBORRAR = '''||V_USUARIO||''', ICO.FECHABORRAR = SYSDATE, ICO.ICO_MEDIADOR_ID = NULL, ICO.ICO_WEBCOM_ID = NULL';
			
	EXECUTE IMMEDIATE V_MSQL;
	COMMIT;
	
	
			
	EXECUTE IMMEDIATE V_MSQL1;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN ICO_INFO_COMERCIAL DE PLAZAS APARCAMIENTO');
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR DATOS EN PLAZA APARCAMIENTO');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_APR||' APR USING
				(
				SELECT DISTINCT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA||'
			)AUX ON (AUX.ICO_ID = APR.ICO_ID) 
			WHEN NOT MATCHED THEN INSERT (ICO_ID) VALUES (AUX.ICO_ID)';
			
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS INSERTADOS EN PLAZA APARCAMIENTO');
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN ICO_INFO_COMERCIAL DE PLAZAS APARCAMIENTO');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO USING
				(
				SELECT DISTINCT ICO.ICO_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO ON ICO.ACT_ID = ACT.ACT_ID AND ICO.BORRADO = 0
				INNER JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID AND TPA.BORRADO = 0
				INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_ID = ACT.DD_SAC_ID AND SAC.BORRADO = 0
				LEFT JOIN '||V_ESQUEMA||'.DD_TIC_TIPO_INFO_COMERCIAL TIC ON TIC.DD_TIC_ID = ICO.DD_TIC_ID AND TIC.BORRADO = 0
				LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_VIV||' VIV ON VIV.ICO_ID = ICO.ICO_ID
				LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_APR||' APR ON APR.ICO_ID = ICO.ICO_ID
				LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_LCO||' LCO ON LCO.ICO_ID = ICO.ICO_ID 
				WHERE ACT.BORRADO = 0 AND SAC.DD_SAC_CODIGO = ''24'' AND TPA.DD_TPA_CODIGO = ''07'' AND APR.ICO_ID IS NOT NULL AND ICO.DD_TIC_ID != 3
			)AUX ON (AUX.ICO_ID = ICO.ICO_ID) 
			WHEN MATCHED THEN UPDATE SET ICO.DD_TIC_ID = 3, ICO.USUARIOMODIFICAR = '''||V_USUARIO||''', ICO.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN ICO_INFO_COMERCIAL DE PLAZAS APARCAMIENTO');

    COMMIT;
    
	--ACT_BNY_BANYO
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN ACT_BNY_BANYO');
	
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_BNY_BANYO BNY USING
				(
				SELECT DISTINCT BNY.BNY_ID, ICO.ICO_ID, (SELECT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' WHERE ACT_ID = ICO.ACT_ID AND BORRADO = 0) AS ICO_ID_NUEVO
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO
				INNER JOIN '||V_ESQUEMA||'.ACT_BNY_BANYO BNY ON BNY.ICO_ID = ICO.ICO_ID
				WHERE ICO.BORRADO = 1 AND ICO.USUARIOBORRAR = '''||V_USUARIO||''' 
			) AUX ON (AUX.BNY_ID = BNY.BNY_ID)
			WHEN MATCHED THEN UPDATE SET BNY.ICO_ID = AUX.ICO_ID_NUEVO, BNY.USUARIOMODIFICAR = '''||V_USUARIO||''', BNY.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN ACT_BNY_BANYO');
    
    
    --ACT_CRE_CARPINTERIA_EXT
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN ACT_CRE_CARPINTERIA_EXT');
	
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT CRE USING
				(
				SELECT DISTINCT CRE.CRE_ID, ICO.ICO_ID, (SELECT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' WHERE ACT_ID = ICO.ACT_ID AND BORRADO = 0) AS ICO_ID_NUEVO
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO
				INNER JOIN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT CRE ON CRE.ICO_ID = ICO.ICO_ID
				WHERE ICO.BORRADO = 1 AND ICO.USUARIOBORRAR = '''||V_USUARIO||''' 
			) AUX ON (AUX.CRE_ID = CRE.CRE_ID)
			WHEN MATCHED THEN UPDATE SET CRE.ICO_ID = AUX.ICO_ID_NUEVO, CRE.USUARIOMODIFICAR = '''||V_USUARIO||''', CRE.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN ACT_CRE_CARPINTERIA_EXT');
    
    
    --ACT_CRI_CARPINTERIA_INT
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN ACT_CRI_CARPINTERIA_INT');
	
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT CRI USING
				(
				SELECT DISTINCT CRI.CRI_ID, ICO.ICO_ID, (SELECT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' WHERE ACT_ID = ICO.ACT_ID AND BORRADO = 0) AS ICO_ID_NUEVO
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO
				INNER JOIN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT CRI ON CRI.ICO_ID = ICO.ICO_ID
				WHERE ICO.BORRADO = 1 AND ICO.USUARIOBORRAR = '''||V_USUARIO||''' 
			) AUX ON (AUX.CRI_ID = CRI.CRI_ID)
			WHEN MATCHED THEN UPDATE SET CRI.ICO_ID = AUX.ICO_ID_NUEVO, CRI.USUARIOMODIFICAR = '''||V_USUARIO||''', CRI.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN ACT_CRI_CARPINTERIA_INT');
    
    
    --ACT_COC_COCINA
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN ACT_COC_COCINA');
	
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_COC_COCINA COC USING
				(
				SELECT DISTINCT COC.COC_ID, ICO.ICO_ID, (SELECT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' WHERE ACT_ID = ICO.ACT_ID AND BORRADO = 0) AS ICO_ID_NUEVO
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO
				INNER JOIN '||V_ESQUEMA||'.ACT_COC_COCINA COC ON COC.ICO_ID = ICO.ICO_ID
				WHERE ICO.BORRADO = 1 AND ICO.USUARIOBORRAR = '''||V_USUARIO||''' 
			) AUX ON (AUX.COC_ID = COC.COC_ID)
			WHEN MATCHED THEN UPDATE SET COC.ICO_ID = AUX.ICO_ID_NUEVO, COC.USUARIOMODIFICAR = '''||V_USUARIO||''', COC.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN ACT_COC_COCINA');
    
    
    
    --ACT_DIS_DISTRIBUCION
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN ACT_DIS_DISTRIBUCION');
	
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS USING
				(
				SELECT DISTINCT DIS.DIS_ID, ICO.ICO_ID, (SELECT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' WHERE ACT_ID = ICO.ACT_ID AND BORRADO = 0) AS ICO_ID_NUEVO
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO
				INNER JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID
				WHERE ICO.BORRADO = 1 AND ICO.USUARIOBORRAR = '''||V_USUARIO||''' 
			) AUX ON (AUX.DIS_ID = DIS.DIS_ID)
			WHEN MATCHED THEN UPDATE SET DIS.ICO_ID = AUX.ICO_ID_NUEVO, DIS.USUARIOMODIFICAR = '''||V_USUARIO||''', DIS.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN ACT_DIS_DISTRIBUCION');
    
      
    
    --ACT_EDI_EDIFICIO
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN ACT_EDI_EDIFICIO');
	
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_EDI_EDIFICIO EDI USING
				(
				SELECT DISTINCT EDI.EDI_ID, ICO.ICO_ID, (SELECT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' WHERE ACT_ID = ICO.ACT_ID AND BORRADO = 0) AS ICO_ID_NUEVO
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO
				INNER JOIN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO EDI ON EDI.ICO_ID = ICO.ICO_ID
				WHERE ICO.BORRADO = 1 AND ICO.USUARIOBORRAR = '''||V_USUARIO||''' 
			) AUX ON (AUX.EDI_ID = EDI.EDI_ID)
			WHEN MATCHED THEN UPDATE SET EDI.ICO_ID = AUX.ICO_ID_NUEVO, EDI.USUARIOMODIFICAR = '''||V_USUARIO||''', EDI.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN ACT_EDI_EDIFICIO');
    
    
    
    --ACT_INF_INFRAESTRUCTURA
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN ACT_INF_INFRAESTRUCTURA');
	
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA INF USING
				(
				SELECT DISTINCT INF.INF_ID, ICO.ICO_ID, (SELECT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' WHERE ACT_ID = ICO.ACT_ID AND BORRADO = 0) AS ICO_ID_NUEVO
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO
				INNER JOIN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA INF ON INF.ICO_ID = ICO.ICO_ID
				WHERE ICO.BORRADO = 1 AND ICO.USUARIOBORRAR = '''||V_USUARIO||''' 
			) AUX ON (AUX.INF_ID = INF.INF_ID)
			WHEN MATCHED THEN UPDATE SET INF.ICO_ID = AUX.ICO_ID_NUEVO, INF.USUARIOMODIFICAR = '''||V_USUARIO||''', INF.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN ACT_INF_INFRAESTRUCTURA');
    
    
    
    --ACT_INS_INSTALACION
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN ACT_INS_INSTALACION');
	
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_INS_INSTALACION INS USING
				(
				SELECT DISTINCT INS.INS_ID, ICO.ICO_ID, (SELECT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' WHERE ACT_ID = ICO.ACT_ID AND BORRADO = 0) AS ICO_ID_NUEVO
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO
				INNER JOIN '||V_ESQUEMA||'.ACT_INS_INSTALACION INS ON INS.ICO_ID = ICO.ICO_ID
				WHERE ICO.BORRADO = 1 AND ICO.USUARIOBORRAR = '''||V_USUARIO||''' 
			) AUX ON (AUX.INS_ID = INS.INS_ID)
			WHEN MATCHED THEN UPDATE SET INS.ICO_ID = AUX.ICO_ID_NUEVO, INS.USUARIOMODIFICAR = '''||V_USUARIO||''', INS.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN ACT_INS_INSTALACION');
    
    
    --ACT_PRV_PARAMENTO_VERTICAL
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN ACT_PRV_PARAMENTO_VERTICAL');
	
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL PRV USING
				(
				SELECT DISTINCT PRV.PRV_ID, ICO.ICO_ID, (SELECT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' WHERE ACT_ID = ICO.ACT_ID AND BORRADO = 0) AS ICO_ID_NUEVO
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO
				INNER JOIN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL PRV ON PRV.ICO_ID = ICO.ICO_ID
				WHERE ICO.BORRADO = 1 AND ICO.USUARIOBORRAR = '''||V_USUARIO||''' 
			) AUX ON (AUX.PRV_ID = PRV.PRV_ID)
			WHEN MATCHED THEN UPDATE SET PRV.ICO_ID = AUX.ICO_ID_NUEVO, PRV.USUARIOMODIFICAR = '''||V_USUARIO||''', PRV.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN ACT_PRV_PARAMENTO_VERTICAL');
    
    
    --ACT_SOL_SOLADO
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN ACT_SOL_SOLADO');
	
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_SOL_SOLADO SOL USING
				(
				SELECT DISTINCT SOL.SOL_ID, ICO.ICO_ID, (SELECT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' WHERE ACT_ID = ICO.ACT_ID AND BORRADO = 0) AS ICO_ID_NUEVO
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO
				INNER JOIN '||V_ESQUEMA||'.ACT_SOL_SOLADO SOL ON SOL.ICO_ID = ICO.ICO_ID
				WHERE ICO.BORRADO = 1 AND ICO.USUARIOBORRAR = '''||V_USUARIO||''' 
			) AUX ON (AUX.SOL_ID = SOL.SOL_ID)
			WHEN MATCHED THEN UPDATE SET SOL.ICO_ID = AUX.ICO_ID_NUEVO, SOL.USUARIOMODIFICAR = '''||V_USUARIO||''', SOL.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN ACT_SOL_SOLADO');
    
    
    --ACT_ZCO_ZONA_COMUN
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN ACT_ZCO_ZONA_COMUN');
	
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN ZCO USING
				(
				SELECT DISTINCT ZCO.ZCO_ID, ICO.ICO_ID, (SELECT ICO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' WHERE ACT_ID = ICO.ACT_ID AND BORRADO = 0) AS ICO_ID_NUEVO
				FROM '||V_ESQUEMA||'.'||V_TABLA_ICO||' ICO
				INNER JOIN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN ZCO ON ZCO.ICO_ID = ICO.ICO_ID
				WHERE ICO.BORRADO = 1 AND ICO.USUARIOBORRAR = '''||V_USUARIO||''' 
			) AUX ON (AUX.ZCO_ID = ZCO.ZCO_ID)
			WHEN MATCHED THEN UPDATE SET ZCO.ICO_ID = AUX.ICO_ID_NUEVO, ZCO.USUARIOMODIFICAR = '''||V_USUARIO||''', ZCO.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' DATOS ACTUALIZADOS EN ACT_ZCO_ZONA_COMUN');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: FINALIZADO CORRECTAMENTE ');

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

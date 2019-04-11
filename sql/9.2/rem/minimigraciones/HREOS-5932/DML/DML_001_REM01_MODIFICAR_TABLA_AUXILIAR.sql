--/*
--#########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190325
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.9.0
--## INCIDENCIA_LINK=HREOS-5932
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(5000 CHAR);
	TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_COUNT NUMBER(16);
	
BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de modificar la tabla auxiliar ...'); 

	-- BORRADO DUPLICADOS 
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.AUX_HREOS_5932 
				WHERE ROWID IN  (select ROWID from ( 
						    select ID_HAYA , row_number() over (partition by ID_HAYA order by ID_HAYA desc) AS ORDEN 
						    from '||V_ESQUEMA||'.AUX_HREOS_5932 AUX )
						where ORDEN > 1
						)';
						
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han borrado '||SQL%ROWCOUNT||' registros. Motivo -> DUPLICADOS'); 
	
	V_MSQL := 'SELECT COUNT(1) FROM (

			(SELECT ACT.ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
			inner join '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO aga on act.act_id = aga.act_id
			inner join '||V_ESQUEMA||'.ACT_AGR_AGRUPACION agr on aga.agr_id = agr.agr_id AND AGR.AGR_FECHA_BAJA IS NULL
			WHERE AGR.AGR_NUM_AGRUP_REM in (SELECT AGR.AGR_NUM_AGRUP_REM
						            FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX
						            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACt on ACT.ACT_NUM_ACTIVO = aux.id_haya
						            inner join '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO aga on act.act_id = aga.act_id
						            inner join '||V_ESQUEMA||'.ACT_AGR_AGRUPACION agr on aga.agr_id = agr.agr_id AND AGR.AGR_FECHA_BAJA IS NULL
						            inner join '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION tag on tag.dd_tag_id = agr.dd_tag_id 
						            WHERE TAG.DD_TAG_CODIGO = ''02''
						        )
			)MINUS(
			    SELECT ACT.ACT_NUM_ACTIVO 
			    FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX
			    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACt on ACT.ACT_NUM_ACTIVO = aux.id_haya
			))';
	
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

	DBMS_OUTPUT.PUT_LINE('	[INFO] Numero activos que no esten en la excel y que compartan agrupacion restringida con un activo que si este en la excel '||V_COUNT||'');
	
	--DD_TCO_TIPO_COMERCIALIZACION
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_HREOS_5932 SET DESTINO_COMERCIAL = ''02'' WHERE UPPER(TRIM(DESTINO_COMERCIAL)) = UPPER(TRIM(''Alquiler y venta''))';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. DESTINO_COMERCIAL - Alquiler y venta'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_HREOS_5932 SET DESTINO_COMERCIAL = ''03'' WHERE DESTINO_COMERCIAL = ''Alquiler''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. DESTINO_COMERCIAL - Alquiler'); 
	
	--DD_ADA_ADECUACION_ALQUILER
		
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_HREOS_5932 SET ESTADO_ADECUACION = ''01'' WHERE ESTADO_ADECUACION = ''S''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. ESTADO_ADECUACION - Si'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_HREOS_5932 SET ESTADO_ADECUACION = ''02'' WHERE ESTADO_ADECUACION = ''N''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. ESTADO_ADECUACION - No'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_HREOS_5932 SET ESTADO_ADECUACION = ''03'' WHERE ESTADO_ADECUACION = ''NO APLICA''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. ESTADO_ADECUACION - No Aplica'); 
	
	--DD_TAL_TIPO_ALQUILER
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_HREOS_5932 SET TIPO_CONTRATO_ALQUILER = ''01'' WHERE TIPO_CONTRATO_ALQUILER = ''Ordinario''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. TIPO_CONTRATO_ALQUILER - Ordinario'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_HREOS_5932 SET TIPO_CONTRATO_ALQUILER = ''02'' WHERE TIPO_CONTRATO_ALQUILER = ''Con opcion a compra'' OR UPPER(TRIM(TIPO_CONTRATO_ALQUILER)) = UPPER(TRIM(''Con opciÃ³n de compra'')) OR TIPO_CONTRATO_ALQUILER like ''%compra%''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. TIPO_CONTRATO_ALQUILER - Con opcion a compra'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_HREOS_5932 SET TIPO_CONTRATO_ALQUILER = ''03'' WHERE TIPO_CONTRATO_ALQUILER = ''FSV''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. TIPO_CONTRATO_ALQUILER - FSV'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_HREOS_5932 SET TIPO_CONTRATO_ALQUILER = ''04'' WHERE TIPO_CONTRATO_ALQUILER = ''Especial''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. TIPO_CONTRATO_ALQUILER - Especial'); 
	
	-- SUBROGADO
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_HREOS_5932 SET SUBROGADO = ''1'' WHERE SUBROGADO = ''S''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. SUBROGADO - Si'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_HREOS_5932 SET SUBROGADO = ''0'' WHERE SUBROGADO = ''N''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. SUBROGADO - No'); 
	
	-- RENTA ANTIGUA
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_HREOS_5932 SET RENTA_ANTIGUA = ''1'' WHERE RENTA_ANTIGUA = ''S''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. RENTA_ANTIGUA - Si'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_HREOS_5932 SET RENTA_ANTIGUA = ''0'' WHERE RENTA_ANTIGUA = ''N''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. RENTA_ANTIGUA - No'); 
	
	-- DD_EAL_ESTADO_ALQUILER
	EXECUTE IMMEDIATE  'UPDATE AUX_HREOS_5932 SET ALQUILADO = ''01'' WHERE ALQUILADO = ''N'' OR UPPER(TRIM(ALQUILADO)) = UPPER(TRIM(''Libre''))';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. ESTADO_ALQUILER - Libre'); 
	EXECUTE IMMEDIATE  'UPDATE AUX_HREOS_5932 SET ALQUILADO = ''02'' WHERE ALQUILADO = ''S'' OR UPPER(TRIM(ALQUILADO)) = UPPER(TRIM(''Alquilado'')) ';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. ESTADO_ALQUILER - Alquilado'); 
	
	--DD_TPI_TIPO_INQUILINO
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_HREOS_5932 SET INQUILINO_ANT_PROP = ''01'' WHERE TRIM(INQUILINO_ANT_PROP) = ''Normal''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. INQUILINO_ANT_PROP - Normal'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_HREOS_5932 SET INQUILINO_ANT_PROP = ''02'' WHERE INQUILINO_ANT_PROP = ''Antiguo deudor''';
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. INQUILINO_ANT_PROP - Antiguo deudor'); 

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT

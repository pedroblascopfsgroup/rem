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
--##        0.2 ODP 05/06/19 Añadido borrado duplicados
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
	
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_HREOS_5932 (ID_HAYA)
				SELECT ACT_NUM_ACTIVO FROM (

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
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('	[INFO] Se insertan los activos que no esten en la excel y que compartan agrupacion restringida con un activo que si este en la excel '||V_COUNT||'');
	
	-- ACTUALIZAR ACTIVOS INSERTADOS NUEVOS
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.AUX_HREOS_5932 T1 USING (
															WITH DATOS AS (
																SELECT ACTIVO,DESTINO_COMERCIAL,TIPO_CONTRATO_ALQUILER,ESTADO_ADECUACION,SUBROGADO,ALQUILADO,INQUILINO_ANT_PROP,RENTA_ANTIGUA,AGR_ID FROM (
																SELECT AUX2.ID_HAYA AS ACTIVO,AUX2.DESTINO_COMERCIAL,AUX2.TIPO_CONTRATO_ALQUILER,AUX2.ESTADO_ADECUACION,AUX2.SUBROGADO,AUX2.ALQUILADO,AUX2.INQUILINO_ANT_PROP,AUX2.RENTA_ANTIGUA,AGR.AGR_ID,
																	ROW_NUMBER() OVER (PARTITION BY AGR.AGR_ID ORDER BY 1 ASC) AS RN
																FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX2
																INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX2.ID_HAYA
																INNER JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0
																INNER JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0
																INNER JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON AGR.DD_TAG_ID = TAG.DD_TAG_ID
																WHERE TAG.DD_TAG_CODIGO = ''02'' AND AGR.AGR_FECHA_BAJA IS NULL AND AUX2.DESTINO_COMERCIAL  IS NOT NULL
																) WHERE RN = 1
															)
															SELECT AUX.ID_HAYA,DAT.ACTIVO,DAT.DESTINO_COMERCIAL,DAT.TIPO_CONTRATO_ALQUILER,DAT.ESTADO_ADECUACION,DAT.SUBROGADO,DAT.ALQUILADO,DAT.INQUILINO_ANT_PROP,DAT.RENTA_ANTIGUA
															FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX 
															INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA
															INNER JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0
															INNER JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0
															INNER JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON AGR.DD_TAG_ID = TAG.DD_TAG_ID
															INNER JOIN DATOS DAT ON DAT.AGR_ID = AGR.AGR_ID
															WHERE TAG.DD_TAG_CODIGO = ''02'' AND AGR.AGR_FECHA_BAJA IS NULL  AND
															AUX.DESTINO_COMERCIAL  IS NULL AND
															AUX.TIPO_CONTRATO_ALQUILER IS NULL AND
															AUX.ESTADO_ADECUACION IS NULL AND
															AUX.SUBROGADO IS NULL AND
															AUX.ALQUILADO IS NULL AND
															AUX.INQUILINO_ANT_PROP IS NULL AND
															AUX.RENTA_ANTIGUA IS NULL
															)T2
				ON (T1.ID_HAYA = T2.ID_HAYA)
				WHEN MATCHED THEN UPDATE SET
				 T1.DESTINO_COMERCIAL       =   T2.DESTINO_COMERCIAL
				,T1.TIPO_CONTRATO_ALQUILER	=	T2.TIPO_CONTRATO_ALQUILER
				,T1.ESTADO_ADECUACION		=	T2.ESTADO_ADECUACION
				,T1.SUBROGADO		        =	T2.SUBROGADO
				,T1.ALQUILADO		        =	T2.ALQUILADO
				,T1.INQUILINO_ANT_PROP		=	T2.INQUILINO_ANT_PROP
				,T1.RENTA_ANTIGUA		    =	T2.RENTA_ANTIGUA ';
				
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('	[INFO] Se actualizan los activos que no esten en la excel y que compartan agrupacion restringida con un activo que si este en la excel '||V_COUNT||'');



--##        0.2 ODP 05/06/19 Añadido borrado duplicados
	-- BORRADO DUPLICADOS 
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.AUX_HREOS_5932 
				WHERE ROWID IN  (select ROWID from ( 
						    select ID_HAYA , row_number() over (partition by ID_HAYA order by ID_HAYA desc) AS ORDEN 
						    from '||V_ESQUEMA||'.AUX_HREOS_5932 AUX )
						where ORDEN > 1
						)';
						
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han borrado '||SQL%ROWCOUNT||' registros. Motivo -> NUEVOS DUPLICADOS'); 
	


	-- BORRADO VENDIDOS
	
	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.AUX_HREOS_5932 
				WHERE ID_HAYA IN (SELECT AUX.ID_HAYA 
									FROM '||V_ESQUEMA||'.AUX_HREOS_5932 aux
									INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO act on AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO
									inner join '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL scm on scm.dd_scm_id = ACT.DD_SCM_ID
									WHERE SCM.DD_SCM_CODIGO = ''05'')';
	
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han eliminado '||SQL%ROWCOUNT||' vendidos.');
	
	--DD_TCO_TIPO_COMERCIALIZACION
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET DESTINO_COMERCIAL = ''02'' WHERE UPPER(TRIM(DESTINO_COMERCIAL)) = UPPER(TRIM(''Alquiler y venta''))';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. DESTINO_COMERCIAL - Alquiler y venta'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET DESTINO_COMERCIAL = ''03'' WHERE DESTINO_COMERCIAL in (''Alquiler'',''ALQUILER'')';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. DESTINO_COMERCIAL - Alquiler'); 
	
	--DD_ADA_ADECUACION_ALQUILER
		
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET ESTADO_ADECUACION = ''01'' WHERE ESTADO_ADECUACION = ''S''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. ESTADO_ADECUACION - Si'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET ESTADO_ADECUACION = ''02'' WHERE ESTADO_ADECUACION = ''N''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. ESTADO_ADECUACION - No'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET ESTADO_ADECUACION = ''03'' WHERE ESTADO_ADECUACION = ''NO APLICA''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. ESTADO_ADECUACION - No Aplica'); 
	
	--DD_TAL_TIPO_ALQUILER
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET TIPO_CONTRATO_ALQUILER = ''01'' WHERE TIPO_CONTRATO_ALQUILER = ''Ordinario''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. TIPO_CONTRATO_ALQUILER - Ordinario'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET TIPO_CONTRATO_ALQUILER = ''02'' WHERE TIPO_CONTRATO_ALQUILER = ''Con opcion a compra'' OR UPPER(TRIM(TIPO_CONTRATO_ALQUILER)) = UPPER(TRIM(''Con opciÃ³n de compra'')) OR TIPO_CONTRATO_ALQUILER like ''%compra%''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. TIPO_CONTRATO_ALQUILER - Con opcion a compra'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET TIPO_CONTRATO_ALQUILER = ''03'' WHERE TIPO_CONTRATO_ALQUILER = ''FSV''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. TIPO_CONTRATO_ALQUILER - FSV'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET TIPO_CONTRATO_ALQUILER = ''04'' WHERE TIPO_CONTRATO_ALQUILER = ''Especial''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. TIPO_CONTRATO_ALQUILER - Especial'); 
	
	-- SUBROGADO
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET SUBROGADO = ''1'' WHERE SUBROGADO in (''S'',''s'')';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. SUBROGADO - Si'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET SUBROGADO = ''0'' WHERE SUBROGADO = ''N''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. SUBROGADO - No'); 
	
	-- RENTA ANTIGUA
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET RENTA_ANTIGUA = ''1'' WHERE RENTA_ANTIGUA = ''S''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. RENTA_ANTIGUA - Si'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET RENTA_ANTIGUA = ''0'' WHERE RENTA_ANTIGUA = ''N''';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. RENTA_ANTIGUA - No'); 
	
	-- DD_EAL_ESTADO_ALQUILER
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET ALQUILADO = ''01'' WHERE TRIM(ALQUILADO) = TRIM(''N'') OR UPPER(TRIM(ALQUILADO)) = UPPER(TRIM(''Libre''))';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. ESTADO_ALQUILER - Libre'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET ALQUILADO = ''02'' WHERE TRIM(ALQUILADO) = TRIM(''S'') OR UPPER(TRIM(ALQUILADO)) = UPPER(TRIM(''Alquilado'')) ';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. ESTADO_ALQUILER - Alquilado'); 
	
	--DD_TPI_TIPO_INQUILINO
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET INQUILINO_ANT_PROP = ''01'' WHERE TRIM(INQUILINO_ANT_PROP) = ''Normal'' OR TRIM(INQUILINO_ANT_PROP) = TRIM(''N'')';
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. INQUILINO_ANT_PROP - Normal'); 
	EXECUTE IMMEDIATE  'UPDATE '||V_ESQUEMA||'.AUX_INF_HREOS_5932 SET INQUILINO_ANT_PROP = ''02'' WHERE INQUILINO_ANT_PROP = ''Antiguo deudor'' OR TRIM(INQUILINO_ANT_PROP) = TRIM(''S'')';
	
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

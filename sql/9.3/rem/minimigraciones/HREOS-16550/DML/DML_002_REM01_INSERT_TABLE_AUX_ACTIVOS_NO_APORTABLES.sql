--/*
--#########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20221221
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## ARTEFACTO=batch
--## INCIDENCIA_LINK=HREOS-19105
--## PRODUCTO=NO
--## 
--## Finalidad:
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-16550] - Santi Monzó (20212002)
--##        0.2 Eliminar de la segunda validción los estados anulados y denegados del expediente comercial, poner NOT para el DD_EEC_ID - [HREOS-19071] - Alejandra García (20221209)
--##        0.3 Modificar la condición del DD_EEC_ID para que tenga un NOT IN y luego un IN - [HREOS-19105] - Alejandra García (20221221)
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-16550';
V_SQL VARCHAR2(2500 CHAR) := '';
V_NUM NUMBER(25);


--Tabla ACTIVOS
V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';
V_TABLA_AUX_ACT_NA VARCHAR2 (30 CHAR) := 'AUX_ACTIVOS_NO_APORTABLES';
V_SENTENCIA VARCHAR2(2600 CHAR);


BEGIN


	--INSERT EN AUX_ACTIVOS_NO_APORTABLES

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_ACTIVOS_NO_APORTABLES(
					ID_ACTIVO_CAJAMAR,
					ID_ACTIVO_JAGUAR,
					MOTIVO_RECHAZO
					)

					WITH NUM_ACT_TOT
					AS( 
						SELECT AUX.AGR_ID, COUNT(ACT_NUM_ACTIVO) AS TOT
						FROM (
							SELECT DISTINCT AGA.AGR_ID
							FROM '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX
							JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT 
							JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND aga.BORRADO = 0
							JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
							WHERE AGR.DD_TAG_ID IN (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO IN (''02'',''14'',''15''))
							AND (AGR.AGR_FECHA_BAJA IS NULL OR AGR.AGR_FECHA_BAJA > TRUNC(SYSDATE)+1)
						) AUX
						JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AUX.AGR_ID
						JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AGA.ACT_ID = ACT.ACT_ID
						WHERE AGA.BORRADO = 0
						GROUP BY (AUX.AGR_ID)
					),
					NUM_ACT_TOT_AUX
					AS( 
						SELECT AGR.AGR_ID, COUNT(ACT_NUM_ACTIVO) AS TOT
						FROM (
							SELECT DISTINCT AGA.AGR_ID
							FROM '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX
							JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT 
							JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND aga.BORRADO = 0
							JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
							WHERE AGR.DD_TAG_ID IN (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO IN (''02'',''14'',''15''))
							AND (AGR.AGR_FECHA_BAJA IS NULL OR AGR.AGR_FECHA_BAJA > TRUNC(SYSDATE)+1)
						) AGR
						JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID
						JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AGA.ACT_ID = ACT.ACT_ID
						JOIN '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
						WHERE AGA.BORRADO = 0
						GROUP BY (AGR.AGR_ID)
					)   

					SELECT DISTINCT
						ACT_NUM_ACTIVO_ANT AS ID_ACTIVO_CAJAMAR
						,ACT_NUM_ACTIVO_NUV AS ID_ACTIVO_JAGUAR
						,''AGRUPACION CON ACTIVOS NO APORTABLES'' AS MOTIVO_RECHAZO

					FROM '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO                  
					JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0  					
					JOIN NUM_ACT_TOT ACT_TOT ON ACT_TOT.AGR_ID = AGA.AGR_ID
					JOIN NUM_ACT_TOT_AUX ACT_TOT_AUX ON ACT_TOT_AUX.AGR_ID = AGA.AGR_ID            

					WHERE ACT_TOT.TOT <> ACT_TOT_AUX.TOT';
      EXECUTE IMMEDIATE V_SQL;

			V_SQL := 'MERGE INTO '||V_ESQUEMA||'.AUX_ACTIVOS_NO_APORTABLES AUX
				using (	

					SELECT DISTINCT 
						AUX.ACT_NUM_ACTIVO_ANT AS ID_ACTIVO_CAJAMAR
						,AUX.ACT_NUM_ACTIVO_NUV AS ID_ACTIVO_JAGUAR
						,''OFERTA APROBADA'' AS MOTIVO_RECHAZO
					
					FROM '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
					JOIN '||V_ESQUEMA||'.ACT_OFR ACT_OFR ON ACT_OFR.ACT_ID = ACT.ACT_ID
					JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ACT_OFR.OFR_ID
					LEFT JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
					
					WHERE OFR.DD_EOF_ID IN (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = (''01''))
					AND ECO.DD_EEC_ID NOT IN (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO IN (''01'',''04'',''10'',''14'',''38'',''43'')))
					
					us ON (us.ID_ACTIVO_CAJAMAR = AUX.ID_ACTIVO_CAJAMAR )
										WHEN MATCHED THEN UPDATE SET
											AUX.MOTIVO_RECHAZO = CONCAT(CONCAT(AUX.MOTIVO_RECHAZO,'' | ''),us.MOTIVO_RECHAZO)
																
											WHEN NOT MATCHED THEN
											INSERT 
											(ID_ACTIVO_CAJAMAR,
											ID_ACTIVO_JAGUAR,
											MOTIVO_RECHAZO
											)
											VALUES(
											us.ID_ACTIVO_CAJAMAR,
											us.ID_ACTIVO_JAGUAR,
											us.MOTIVO_RECHAZO
											)';
      EXECUTE IMMEDIATE V_SQL;

	--BORRAR EN AUX_ACT_TRASPASO_ACTIVO LOS ACTIVOS DE AUX_ACTIVOS_NO_APORTABLES

				V_SQL := 'DELETE FROM '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX2 WHERE EXISTS (
							SELECT DISTINCT ID_ACTIVO_CAJAMAR FROM '||V_ESQUEMA||'.AUX_ACTIVOS_NO_APORTABLES AUX
							WHERE AUX.ID_ACTIVO_CAJAMAR = AUX2.ACT_NUM_ACTIVO_ANT)';
      EXECUTE IMMEDIATE V_SQL;


  
  COMMIT;


  
  
EXCEPTION

WHEN OTHERS THEN
     DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
     DBMS_OUTPUT.put_line('-----------------------------------------------------------');
     DBMS_OUTPUT.put_line(SQLERRM);
     ROLLBACK;
     RAISE;
END;
/

EXIT;

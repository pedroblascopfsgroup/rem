--/*
--##########################################
--## AUTOR=Carles Molins Pascual
--## FECHA_CREACION=20190618
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4243
--## PRODUCTO=NO
--## Finalidad: Stored Procedure que actualiza la situacion comercial VACIA de los activos en REM.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - Carles Molins
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

create or replace PROCEDURE SP_ASC_ACT_SIT_COM_VACIOS (ID_ACTIVO IN NUMBER DEFAULT 0) AS

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
	V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
	V_SQL VARCHAR2(32000 CHAR);
	V_COUNT NUMBER(16);
	V_USUARIO VARCHAR2(30 CHAR) := 'SP_ASC_SCM';
	TABLA_ACTIVO VARCHAR2(30 CHAR) := 'ACT_ACTIVO';
	vWHERE VARCHAR2(4000 CHAR);

	--CODIGOS DICCIONARIO
	SITCOM_NO_COMERCIALIZABLE VARCHAR2(2 CHAR) := '01';
	SITCOM_VENTA VARCHAR2(2 CHAR) := '02';
	SITCOM_VENTA_OFERTA VARCHAR2(2 CHAR) := '03';
	SITCOM_VENTA_RESERVA VARCHAR2(2 CHAR) := '04';
	SITCOM_VENDIDO VARCHAR2(2 CHAR) := '05';
	SITCOM_ALQUILER VARCHAR2(2 CHAR) := '07';
	SITCOM_VENTA_ALQUILER VARCHAR2(2 CHAR) := '08';
	SITCOM_CONDICIONADO VARCHAR2(2 CHAR) := '09';
	SITCOM_ALQUILADO VARCHAR2(2 CHAR) := '10';
	SITCOM_ALQUILER_OFERTA VARCHAR2(2 CHAR) := '11';
	SITCOM_VENTA_ALQUILER_OFERTA VARCHAR2(2 CHAR) := '12';

	TIPOCOM_VENTA VARCHAR2(2 CHAR) := '01';
	TIPOCOM_ALQUILER_VENTA VARCHAR2(2 CHAR) := '02';
	TIPOCOM_ALQUILER VARCHAR2(2 CHAR) := '03';

	ESTADORES_FIRMADA VARCHAR2(2 CHAR) := '02';
	ESTADOOFE_ACEPTADA VARCHAR2(2 CHAR) := '01';
	EXPEDIENTE_ANULADO VARCHAR2(2 CHAR) := '02';

	TIPOOFERTA_VENTA VARCHAR2(2 CHAR) := '01';
	TIPOOFERTA_ALQUILER VARCHAR2(2 CHAR) := '02';

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO DE ACTUALIZACIÓN DE ESTADOS COMERCIALES.');
    DBMS_OUTPUT.PUT_LINE('[INFO] HORA INICIO ' ||SYSTIMESTAMP);

	IF ID_ACTIVO > 0 THEN

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' WHERE ACT_ID = '||ID_ACTIVO||' AND BORRADO = 0 AND DD_SCM_ID IS NULL';
		EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

		DBMS_OUTPUT.PUT_LINE('[INFO] Se ejecutará el proceso para el Activo '||ID_ACTIVO||'.');
		vWHERE := ' ACT.ACT_ID = '||ID_ACTIVO;

	ELSE

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' WHERE BORRADO = 0 AND DD_SCM_ID IS NULL';
		EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

		DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizará la Situación Comercial para todos los Activos.');
		vWHERE := ' ACT.DD_SCM_ID IS NULL ';

	END IF;

	IF V_COUNT > 0 THEN

		V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
					USING (
						SELECT ACT_ID, DD_SCM_ID
						FROM (
							SELECT ACT_ID, DD_SCM_ID, ROW_NUMBER () OVER (PARTITION BY ACT_ID ORDER BY ORDEN ASC) ROWNUMBER
							FROM(

								SELECT ACT.ACT_ID
								   ,SCM.DD_SCM_ID
								   ,1 ORDEN
										FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
										LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_CODIGO = '''||SITCOM_VENDIDO||''' AND SCM.BORRADO = 0 /*Vendido externo*/
										WHERE ACT.ACT_VENTA_EXTERNA_FECHA IS NOT NULL
										AND ACT.BORRADO = 0
										AND '||vWHERE||'
								UNION
								SELECT ACT.ACT_ID
								   ,SCM.DD_SCM_ID
								   ,1 ORDEN
										FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
										JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.ACT_ID = ACT.ACT_ID
										JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AO.OFR_ID AND OFR.BORRADO = 0
										JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = AO.OFR_ID AND ECO.BORRADO = 0
										LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_CODIGO = '''||SITCOM_VENDIDO||''' AND SCM.BORRADO = 0 /*Vendido*/
										WHERE DD_TOF_ID = (SELECT DD_TOF_ID FROM '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA WHERE DD_TOF_CODIGO = '''||TIPOOFERTA_VENTA||''')
										AND ECO.ECO_FECHA_VENTA IS NOT NULL
										AND ACT.BORRADO = 0
										AND '||vWHERE||'
								UNION
								SELECT ACT.ACT_ID
								   ,SCM.DD_SCM_ID
								   ,2 ORDEN
										FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
										JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.ACT_ID = ACT.ACT_ID
										JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AO.OFR_ID AND OFR.BORRADO = 0
										JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = AO.OFR_ID AND ECO.BORRADO = 0
										LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_CODIGO = '''||SITCOM_ALQUILADO||''' AND SCM.BORRADO = 0 /*Alquilado*/
										WHERE DD_TOF_ID = (SELECT DD_TOF_ID FROM '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA WHERE DD_TOF_CODIGO = '''||TIPOOFERTA_ALQUILER||''')
										AND ECO.ECO_FECHA_INICIO_ALQUILER IS NOT NULL
										AND ECO.ECO_FECHA_FIN_ALQUILER IS NULL
										AND ACT.BORRADO = 0
										AND '||vWHERE||'
								UNION
								SELECT ACT.ACT_ID
								   ,SCM.DD_SCM_ID
								   ,3 ORDEN
										FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
										JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
										LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_CODIGO = '''||SITCOM_NO_COMERCIALIZABLE||''' AND SCM.BORRADO = 0 /*No comercializable*/
										WHERE PAC.PAC_CHECK_COMERCIALIZAR = 0
										AND ACT.BORRADO = 0
										AND '||vWHERE||'
								UNION
								SELECT ACT.ACT_ID
								   ,SCM.DD_SCM_ID
								   ,4 ORDEN
										FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
										JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.ACT_ID = ACT.ACT_ID
										JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AO.OFR_ID
										JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
										JOIN '||V_ESQUEMA||'.RES_RESERVAS RES ON RES.ECO_ID = ECO.ECO_ID AND RES.BORRADO = 0
										LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_CODIGO = '''||SITCOM_VENTA_RESERVA||''' AND SCM.BORRADO = 0 /*Disponible para la venta con reserva*/
										WHERE RES.DD_ERE_ID = (SELECT DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = '''||ESTADORES_FIRMADA||''')
										AND ECO.DD_EEC_ID <> (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = '''||EXPEDIENTE_ANULADO||''')
										AND ACT.BORRADO = 0
										AND '||vWHERE||'
								UNION
								SELECT ACT.ACT_ID
								   ,SCM.DD_SCM_ID
								   ,5 ORDEN
										FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
										JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
										JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.ACT_ID = ACT.ACT_ID
										JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AO.OFR_ID AND OFR.BORRADO = 0
										LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_CODIGO = '''||SITCOM_VENTA_ALQUILER_OFERTA||''' AND SCM.BORRADO = 0 /*Disponible para venta y alquiler con oferta*/
										WHERE APU.DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = '''||TIPOCOM_ALQUILER_VENTA||''')
										AND OFR.DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '''||ESTADOOFE_ACEPTADA||''')
										AND ACT.BORRADO = 0
										AND '||vWHERE||'
								UNION
								SELECT ACT.ACT_ID
								   ,SCM.DD_SCM_ID
								   ,6 ORDEN
										FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
										JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
										JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.ACT_ID = ACT.ACT_ID
										JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AO.OFR_ID AND OFR.BORRADO = 0
										LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_CODIGO = '''||SITCOM_ALQUILER_OFERTA||''' AND SCM.BORRADO = 0 /*Disponible para alquiler con oferta*/
										WHERE APU.DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = '''||TIPOCOM_ALQUILER||''')
										AND OFR.DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '''||ESTADOOFE_ACEPTADA||''')
										AND ACT.BORRADO = 0
										AND '||vWHERE||'
								UNION
								SELECT ACT.ACT_ID
								   ,SCM.DD_SCM_ID
								   ,7 ORDEN
										FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
										JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
										JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.ACT_ID = ACT.ACT_ID
										JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AO.OFR_ID AND OFR.BORRADO = 0
										LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_CODIGO = '''||SITCOM_VENTA_OFERTA||''' AND SCM.BORRADO = 0 /*Disponible para la venta con oferta*/
										WHERE APU.DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = '''||TIPOCOM_VENTA||''')
										AND OFR.DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '''||ESTADOOFE_ACEPTADA||''')
										AND ACT.BORRADO = 0
										AND '||vWHERE||'
								UNION
								SELECT ACT.ACT_ID
								   ,SCM.DD_SCM_ID
								   ,8 ORDEN
										FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
										JOIN '||V_ESQUEMA||'.V_COND_DISPONIBILIDAD V ON V.ACT_ID = ACT.ACT_ID
										LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_CODIGO = '''||SITCOM_CONDICIONADO||''' AND SCM.BORRADO = 0 /*Disponible condicionado*/
										WHERE V.ES_CONDICIONADO = 1
										AND ACT.BORRADO = 0
										AND '||vWHERE||'
								UNION
								SELECT ACT.ACT_ID
								   ,SCM.DD_SCM_ID
								   ,9 ORDEN
										FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
										JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
										LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_CODIGO = '''||SITCOM_VENTA_ALQUILER||''' AND SCM.BORRADO = 0 /*Disponible para venta y alquiler*/
										WHERE APU.DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = '''||TIPOCOM_ALQUILER_VENTA||''')
										AND ACT.BORRADO = 0
										AND '||vWHERE||'
								UNION
								SELECT ACT.ACT_ID
								   ,SCM.DD_SCM_ID
								   ,10 ORDEN
										FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
										JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
										LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_CODIGO = '''||SITCOM_ALQUILER||''' AND SCM.BORRADO = 0 /*Disponible para alquiler*/
										WHERE APU.DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = '''||TIPOCOM_ALQUILER||''')
										AND ACT.BORRADO = 0
										AND '||vWHERE||'
								UNION
								SELECT ACT.ACT_ID
								   ,SCM.DD_SCM_ID
								   ,11 ORDEN
										FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
										JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
										LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_CODIGO = '''||SITCOM_VENTA||''' AND SCM.BORRADO = 0 /*Disponible para la venta*/
										WHERE APU.DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = '''||TIPOCOM_VENTA||''')
										AND ACT.BORRADO = 0
										AND '||vWHERE||'
							)
						)AUX WHERE AUX.ROWNUMBER = 1
					) T2
					ON (T1.ACT_ID = T2.ACT_ID)
                    WHEN MATCHED THEN UPDATE SET
						 T1.DD_SCM_ID = T2.DD_SCM_ID
						,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
						,T1.FECHAMODIFICAR = SYSDATE';

		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' Activos actualizados.');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] No hay activos que actualizar.');

	END IF;

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] HORA FIN ' || SYSTIMESTAMP);
    DBMS_OUTPUT.PUT_LINE('[OK] - PROCESO FINALIZADO.');

EXCEPTION

    WHEN OTHERS THEN

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);

    ROLLBACK;
    RAISE;

END SP_ASC_ACT_SIT_COM_VACIOS;
/
EXIT

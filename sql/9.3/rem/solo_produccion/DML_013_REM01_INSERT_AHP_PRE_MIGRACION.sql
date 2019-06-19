--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190614
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4407
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.

BEGIN

	DBMS_OUTPUT.put_line('[INICIO]');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
				USING (
					SELECT HEP.HEP_FECHA_DESDE, APU.* 
					FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
					JOIN '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION HEP ON HEP.ACT_ID = APU.ACT_ID
					) T2
				ON (T1.ACT_ID = T2.ACT_ID AND T1.BORRADO = 0)
				WHEN NOT MATCHED THEN INSERT (
					T1.AHP_ID
					,T1.ACT_ID
					,T1.DD_TPU_ID
					,T1.DD_EPV_ID
					,T1.DD_EPA_ID
					,T1.DD_TCO_ID
					,T1.DD_MTO_V_ID
					,T1.AHP_MOT_OCULTACION_MANUAL_V
					,T1.AHP_CHECK_PUBLICAR_V
					,T1.AHP_CHECK_OCULTAR_V
					,T1.AHP_CHECK_OCULTAR_PRECIO_V
					,T1.AHP_CHECK_PUB_SIN_PRECIO_V
					,T1.DD_MTO_A_ID
					,T1.AHP_MOT_OCULTACION_MANUAL_A
					,T1.AHP_CHECK_PUBLICAR_A
					,T1.AHP_CHECK_OCULTAR_A
					,T1.AHP_CHECK_OCULTAR_PRECIO_A
					,T1.AHP_CHECK_PUB_SIN_PRECIO_A
					,T1.AHP_FECHA_INI_VENTA
					,T1.AHP_FECHA_FIN_VENTA
					,T1.AHP_FECHA_INI_ALQUILER
					,T1.AHP_FECHA_FIN_ALQUILER
					,T1.VERSION
					,T1.USUARIOCREAR
					,T1.FECHACREAR
					,T1.BORRADO
					,T1.ES_CONDICONADO_ANTERIOR
					,T1.DD_TPU_V_ID
					,T1.DD_TPU_A_ID
					) VALUES (
					'||V_ESQUEMA||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL
					,T2.ACT_ID
					,T2.DD_TPU_ID
					,T2.DD_EPV_ID
					,T2.DD_EPA_ID
					,T2.DD_TCO_ID
					,T2.DD_MTO_V_ID
					,T2.APU_MOT_OCULTACION_MANUAL_V
					,T2.APU_CHECK_PUBLICAR_V
					,T2.APU_CHECK_OCULTAR_V
					,T2.APU_CHECK_OCULTAR_PRECIO_V
					,T2.APU_CHECK_PUB_SIN_PRECIO_V
					,T2.DD_MTO_A_ID
					,T2.APU_MOT_OCULTACION_MANUAL_A
					,T2.APU_CHECK_PUBLICAR_A
					,T2.APU_CHECK_OCULTAR_A
					,T2.APU_CHECK_OCULTAR_PRECIO_A
					,T2.APU_CHECK_PUB_SIN_PRECIO_A
					,CASE WHEN T2.DD_TCO_ID IN (1,2) THEN T2.HEP_FECHA_DESDE
						  ELSE NULL
					 END
					,NULL
					,CASE WHEN T2.DD_TCO_ID IN (2,3) THEN T2.HEP_FECHA_DESDE
						  ELSE NULL
					 END
					,NULL
					,0
					,''REMVIP-4407''
					,SYSDATE
					,0
					,T2.ES_CONDICONADO_ANTERIOR
					,T2.DD_TPU_V_ID
					,T2.DD_TPU_A_ID
					)';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.put_line('[INFO]	Se han actualizado '||SQL%ROWCOUNT||' filas.');

	COMMIT;
	DBMS_OUTPUT.put_line('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

--/*
--##########################################
--## AUTOR=CARLOS LOPEZ
--## FECHA_CREACION=20180315
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-3936
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

create or replace PROCEDURE SP_MOTIVO_OCULTACION (pACT_ID IN NUMBER
                                                , pOCULTAR OUT NUMBER
                                                , pMOTIVO OUT VARCHAR2) IS

	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.

    V_MSQL VARCHAR2(20000 CHAR); -- Sentencia a ejecutar 
    vWHERE VARCHAR2(4000 CHAR);
    nORDEN NUMBER;
  BEGIN
	    DBMS_OUTPUT.PUT_LINE('[INICIO]');

      IF pACT_ID IS NOT NULL THEN
        vWHERE := ' WHERE V.ACT_ID'||pACT_ID;
      END IF;

      V_MSQL := '
            SELECT OCULTO, DD_MTO_CODIGO
              FROM (
                  SELECT OCULTO, DD_MTO_CODIGO, ROW_NUMBER () OVER (PARTITION BY ACT_ID ORDER BY ORDEN DESC) ROWNUMBER
                    FROM(
                          SELECT APU.ACT_ID
                               , DECODE(PAC.PAC_CHECK_PUBLICAR,0,1,1,0,0)OCULTO
                               , MTO.DD_MTO_CODIGO
                               , 1 ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
                                    JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = APU.ACT_ID AND PAC.BORRADO = 0
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''01'' AND MTO.BORRADO = 0 /*No Publicable*/
                                   WHERE APU.BORRADO = 0
                                     AND APU.ACT_ID= '||pACT_ID||
                         ' UNION           
                          SELECT APU.ACT_ID
                               , DECODE(SCM.DD_SCM_CODIGO,''01'',1,0)OCULTO /*No comercializable*/
                               , MTO.DD_MTO_CODIGO
                               , 2 ORDEN
                                    FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
                                    JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = APU.ACT_ID AND ACT.BORRADO = 0
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND  SCM.BORRADO = 0
                                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''02'' AND MTO.BORRADO = 0 /*No Comercializable*/
                                   WHERE APU.BORRADO = 0
                                     AND APU.ACT_ID= '||pACT_ID||
                       ') 
                    )AUX WHERE AUX.ROWNUMBER = 1 
                 '
       ;
      /*DBMS_OUTPUT.PUT_LINE(V_MSQL);*/
      EXECUTE IMMEDIATE V_MSQL INTO pOCULTAR, pMOTIVO;

	  DBMS_OUTPUT.PUT_LINE('[FIN]');

	  COMMIT;

	EXCEPTION
	  WHEN OTHERS THEN
	    ERR_NUM := SQLCODE;
	    ERR_MSG := SQLERRM;
	    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
	    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
	    DBMS_OUTPUT.put_line(ERR_MSG);
	    ROLLBACK;
	    RAISE;

	END SP_MOTIVO_OCULTACION;
/

EXIT;

--/*
--##########################################
--## AUTOR=CARLOS LOPEZ
--## FECHA_CREACION=20181006
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4525
--## PRODUCTO=NO
--## Finalidad: 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
create or replace PROCEDURE SP_MOTIVO_OCULTACION_A_AGR (pAGR_ID IN NUMBER
												, pTIPO IN VARCHAR2 /*ALQUILER/VENTA*/
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
	    /*DBMS_OUTPUT.PUT_LINE('[INICIO]');*/

      pOCULTAR := 0;
      pMOTIVO  := 0;

      V_MSQL := '
            SELECT OCULTO, DD_MTO_CODIGO
              FROM AUX_MOT_OCULT_A_AGR
            WHERE AGR_ID= '||pAGR_ID
       ;

      BEGIN
        EXECUTE IMMEDIATE V_MSQL INTO pOCULTAR, pMOTIVO;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          pOCULTAR := 0;
          pMOTIVO  := 0;
      END;

	  /*DBMS_OUTPUT.PUT_LINE('[FIN]');*/

	  --COMMIT;

	EXCEPTION
	  WHEN OTHERS THEN
	    ERR_NUM := SQLCODE;
	    ERR_MSG := SQLERRM;
	    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
	    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
	    DBMS_OUTPUT.put_line(ERR_MSG);
	    ROLLBACK;
	    RAISE;

	END SP_MOTIVO_OCULTACION_A_AGR;
/
EXIT;

--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20220228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17078
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica en ACT_P20_PRORRATA_DIARIO20 los datos añadidos en T_ARRAY_DATA
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-17078';
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICACION ACT_PAC_PERIMETRO_ACTIVO');

    V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO ACT
                USING (				
                  SELECT 
                          MEC.DD_MEC_DESCRIPCION AS PAC_MOT_EXCL_COMERCIALIZAR 
                        ,ACT2.ACT_ID AS ACT_ID
                    FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
                    JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO AND ACT2.BORRADO=0
                    JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT2.ACT_ID AND PAC.BORRADO = 0
                    LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''MOTIVO_NO_COMERCIAL''  AND eqv1.DD_CODIGO_CAIXA = aux.MOTIVO_NO_COMERCIAL AND EQV1.BORRADO=0
                    LEFT JOIN '|| V_ESQUEMA ||'.DD_MEC_MOTIVO_EXCLU_CAIXA MEC ON MEC.DD_MEC_CODIGO = eqv1.DD_CODIGO_REM
                    WHERE MEC.DD_MEC_ID IS NOT NULL
                    AND PAC.PAC_CHECK_COMERCIALIZAR = 0
                    AND PAC.PAC_MOT_EXCL_COMERCIALIZAR IS NULL
                    ) US ON (US.ACT_ID = ACT.ACT_ID AND ACT.BORRADO = 0)
                    WHEN MATCHED THEN UPDATE SET
                        ACT.PAC_MOT_EXCL_COMERCIALIZAR = US.PAC_MOT_EXCL_COMERCIALIZAR
                        ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                        ,ACT.FECHAMODIFICAR = SYSDATE';

      EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla ACT_PAC_PERIMETRO_ACTIVO MODIFICADA CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
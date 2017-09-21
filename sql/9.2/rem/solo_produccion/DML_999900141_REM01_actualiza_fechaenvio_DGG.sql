--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20170920
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2877
--## PRODUCTO=NO
--##
--## Finalidad: Actualizamos la fechaenvio de DGG_DOC_GES_GASTOS para que se vuelva a enviar la información a las gestorías.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
 

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de DGG_DOC_GES_GASTOS');


    V_MSQL:= 'update '||V_ESQUEMA||'.DGG_DOC_GES_GASTOS 
                       set  fechaenvio = null
                          , usuarioenvio = null
                          , usuariomodificar = ''HREOS-2877''
                          , fechamodificar = sysdate
                        where trunc(fechaenvio) < trunc(to_date(20170919,''YYYYMMDD''))';

     EXECUTE IMMEDIATE V_MSQL;
        

         DBMS_OUTPUT.PUT_LINE('[FIN] Filas '||SQL%ROWCOUNT||' actualizadas correctamente en DGG_DOC_GES_GASTOS.'); 
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
END;
/
EXIT;
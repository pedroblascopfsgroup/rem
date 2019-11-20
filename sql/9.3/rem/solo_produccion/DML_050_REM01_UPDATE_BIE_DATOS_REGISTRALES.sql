--/*
--##########################################
--## AUTOR=Adriaán Molina
--## FECHA_CREACION=20191014
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5369
--## PRODUCTO=NO
--##
--## Finalidad: Actualización campo BIE_DATOS_REGISTRALES
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
    V_SEQ_GEH NUMBER(16);
	V_TIPO_ID NUMBER(16); --Vle para el id DD_TTR_TIPO_TRABAJO
           
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- Updatear los valores en ACT_ACTIVO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN BIE_DATOS_REGISTRALES] ');
         
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: Modificamos el campo BIE_DATOS_REGISTRALES');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES BIE
						SET DD_LOC_ID = NULL,
						USUARIOMODIFICAR = ''REMVIP-5369'',
						FECHAMODIFICAR = SYSDATE
						WHERE BIE.BIE_ID IN (267112, 267001, 266284, 266334)
						';
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' BIEN ACTUALIZADO');
          
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES ACTUALIZADA CORRECTAMENTE');   

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
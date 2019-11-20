--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20191007
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5386
--## PRODUCTO=NO
--##
--## Finalidad: Actualización datos BIE_LOCALIZACION
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
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN BIE_LOCALIZACION.DD_UPO_ID ');
         
    			V_MSQL := 'UPDATE '||V_ESQUEMA||'.BIE_LOCALIZACION BIE
						SET DD_UPO_ID = ( SELECT DD_UPO_ID FROM ' || V_ESQUEMA_M ||'.DD_UPO_UNID_POBLACIONAL WHERE DD_UPO_CODIGO = ''40640005'' ),
						USUARIOMODIFICAR = ''REMVIP-5386_2'',
						FECHAMODIFICAR = SYSDATE
						WHERE BIE_LOC_ID = 300820
						';
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' registro actualizado de BIE_LOCALIZACION ');
          
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_ESQUEMA||'.BIE_LOCALIZACION ACTUALIZADA CORRECTAMENTE');   

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

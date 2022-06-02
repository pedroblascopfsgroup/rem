--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20220513
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11675
--## PRODUCTO=NO
--##
--## Finalidad: 
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
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.CVD_CONF_DOC_OCULTAR_PERFIL 
          SET BORRADO = 1,
          USUARIOBORRAR = ''REMVIP-11675'', FECHABORRAR = SYSDATE 
          WHERE CVD_ID IN (
							SELECT CVD.CVD_ID
							FROM '||V_ESQUEMA||'.CVD_CONF_DOC_OCULTAR_PERFIL CVD
							INNER JOIN '||V_ESQUEMA||'.PEF_PERFILES PEF ON PEF.PEF_ID = CVD.PEF_ID
							INNER JOIN '||V_ESQUEMA||'.DD_TDO_TIPO_DOC_ENTIDAD TDO ON TDO.DD_TDO_ID = CVD.DD_TDO_ID
							WHERE PEF.PEF_CODIGO = ''CARTERA_BBVA''
							AND TDO.DD_TDO_CODIGO IN (''0023'', ''0042'', ''0855'', ''0011'', ''0010'', ''0012'')
							)';

  EXECUTE IMMEDIATE V_MSQL;
    
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA CVD_CONF_DOC_OCULTAR_PERFIL ACTUALIZADA CORRECTAMENTE ');
   			

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
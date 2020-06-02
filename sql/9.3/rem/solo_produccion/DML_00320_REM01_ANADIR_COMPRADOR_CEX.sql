--/*
--##########################################
--## AUTOR=Pier Gotta
--## FECHA_CREACION=20200601
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-7403
--## PRODUCTO=NO
--##
--## Finalidad: Script que inserta en la CEX_COMPRADOR_EXPEDIENTE
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
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CEX_COMPRADOR_EXPEDIENTE] ');
			
                V_MSQL := 'SELECT COM_ID FROM '||V_ESQUEMA||'.COM_COMPRADOR WHERE COM_DOCUMENTO = ''44446088Z''';
                EXECUTE IMMEDIATE V_MSQL INTO V_ID;
                
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE (COM_ID, ECO_ID, DD_ECV_ID, DD_REM_ID, CEX_DOCUMENTO_CONYUGE, CEX_PORCION_COMPRA, CEX_TITULAR_RESERVA, CEX_TITULAR_CONTRATACION, VERSION, BORRADO, DD_PAI_ID,  DD_TDI_ID_CONYUGE)
				VALUES (
				'||V_ID||',
				(SELECT ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = 210599),
				(SELECT DD_ECV_ID FROM '||V_ESQUEMA||'.DD_ECV_ESTADOS_CIVILES WHERE DD_ECV_CODIGO = ''02''),
				(SELECT DD_REM_ID FROM '||V_ESQUEMA||'.DD_REM_REGIMENES_MATRIMONIALES WHERE DD_REM_CODIGO = ''01''),
				''53611022T'',
				50,
				0,
				0,
				0,
				0,
				(SELECT DD_PAI_ID FROM '||V_ESQUEMA||'.DD_PAI_PAISES WHERE DD_PAI_CODIGO = ''28''),				
				(SELECT DD_TDI_ID FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = ''01'')				
				)';
		    	
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.POP_PLANTILLAS_OPERACION insertados correctamente.');
	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: CEX_COMPRADOR_EXPEDIENTE CREADO CORRECTAMENTE ');
   

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
EXIT;





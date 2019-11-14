--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20190916
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7578
--## PRODUCTO=NO
--##
--## Finalidad: Script que cambia a los usuarios de la subcartera APPLE a la subcartera DIVARIAN.
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
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'UCA_USUARIO_CARTERA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_DD VARCHAR2(30 CHAR) := 'DD_SCR_SUBCARTERA'; -- Vble. auxiliar para almacenar el nombre de la tabla diccionario.
    
    V_ID_SCR_APPLE VARCHAR2(20 CHAR);
    V_ID_SCR_DIVARIAN VARCHAR2(20 CHAR);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
        
BEGIN   
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
	V_SQL := 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_DD||' WHERE DD_SCR_CODIGO = ''138''';
    EXECUTE IMMEDIATE V_SQL INTO V_ID_SCR_APPLE;
    
    DBMS_OUTPUT.PUT_LINE('ID DE LA SUBCARTERA APPLE RECOGIDO.');
    
    V_SQL := 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_DD||' WHERE DD_SCR_CODIGO = ''150''';
    EXECUTE IMMEDIATE V_SQL INTO V_ID_SCR_DIVARIAN;
	
    DBMS_OUTPUT.PUT_LINE('ID DE LA SUBCARTERA DIVARIAN RECOGIDO.');
        
    -- Update que modifica los datos para replicar datos de Apple para Divarian.
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE DE LA TABLA' ||V_TEXT_TABLA);
          
   	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' UCA
			 SET UCA.DD_SCR_ID = '||V_ID_SCR_DIVARIAN||'
			 WHERE UCA.DD_SCR_ID = '||V_ID_SCR_APPLE||'';

	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE('');
			 
        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[FIN] Finalizado el proceso de modificación de usuarios y carteras de Apple y Divarian.');
    COMMIT;
   

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

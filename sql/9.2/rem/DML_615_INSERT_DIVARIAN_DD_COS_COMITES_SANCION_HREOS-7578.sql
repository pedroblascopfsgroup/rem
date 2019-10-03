--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20190916
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7578
--## PRODUCTO=NO
--##
--## Finalidad: Script que replica los valores de la cartera Apple para la cartera Divarian en la tabla DD_COS_COMITES_SANCION.
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
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'DD_COS_COMITES_SANCION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
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
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: COMIENZA PROCESO DE REPLICAR DATOS DE APPLE PARA DIVARIAN EN LA TABLA: ' ||V_TEXT_TABLA);
 
    V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (DD_COS_ID, DD_COS_CODIGO, DD_COS_DESCRIPCION,
				DD_COS_DESCRIPCION_LARGA, DD_CRA_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_SCR_ID)
				SELECT S_DD_COS_COMITES_SANCION.NEXTVAL, ''38'', ''Divarian'', ''Divarian'',
				COS.DD_CRA_ID, 0, ''HREOS-7578'', FECHACREAR, BORRADO, '||V_ID_SCR_DIVARIAN||'
				FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' COS WHERE COS.DD_SCR_ID = '||V_ID_SCR_APPLE||' AND COS.BORRADO = 0';
    
	EXECUTE IMMEDIATE V_SQL;
				
	DBMS_OUTPUT.PUT_LINE('[FIN] FINALIZADO EL PROCESO DE REPLICA DE GESTORES DE APPLE PARA DIVARIAN');
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

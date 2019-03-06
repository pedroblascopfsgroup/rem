--/*
--##########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20190226
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3458
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en USD_USUARIOS_DESPACHOS
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
	
    V_TABLA VARCHAR(50 CHAR) := 'USD_USUARIOS_DESPACHOS'; -- Vlbe. que almacena el nombre de la tabla.
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    DBMS_OUTPUT.PUT_LINE('[INFO] Se va a comprobar que no exista la relación entre el usuario ''Dorseran Serveis de la Construcció'' (B60546611) y el desoacho externo ''REMPTEC''.');
			
			V_SQL :=    'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||'
			            WHERE DES_ID = (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = ''REMPTEC'') 
				        AND USU_ID =  (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''B60546611'')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS...no se modifica nada.');
			ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] Se va a insertar el nuevo dato.');
				V_SQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS
							(USD_ID
                            ,DES_ID
                            ,USU_ID
                            ,USD_GESTOR_DEFECTO
                            ,USD_SUPERVISOR
                            ,USUARIOCREAR
                            ,FECHACREAR
                            ,BORRADO)
							SELECT '||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL
							,(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = ''REMPTEC'')
							,(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''B60546611'')
							,1
                            ,1
                            ,''REMVIP-3458''
                            ,SYSDATE
                            ,0 FROM DUAL';
		    	
				EXECUTE IMMEDIATE V_SQL;

				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS insertados correctamente.');
				
		    END IF;	

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] USD_USUARIOS_DESPACHOS ACTUALIZADO CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          DBMS_OUTPUT.put_line(V_SQL);
          ROLLBACK;
          RAISE;          

END;

/

EXIT



   


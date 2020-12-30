--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20200925
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8131
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar apellido comprador
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8131'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='COM_COMPRADOR'; --Vble. auxiliar para almacenar la tabla a actualizar

    V_NIF_COMPRADOR VARCHAR2(100 CHAR) :='B43593854';
    
    
	
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar
    
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente


BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN COM_COMPRADOR ');    
       
        
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE COM_DOCUMENTO='''||V_NIF_COMPRADOR||''' ';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos comprador: '''|| V_NIF_COMPRADOR ||''' ');

              V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                        COM_APELLIDOS = NULL,
                        USUARIOMODIFICAR = '''||V_USUARIO||''', 
                        FECHAMODIFICAR = SYSDATE
                        WHERE COM_DOCUMENTO='''||V_NIF_COMPRADOR||''' ';
                        
                EXECUTE IMMEDIATE V_SQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE COMPRADOR CON NIF: '''||V_NIF_COMPRADOR||''' ');
               
            ELSE
              DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE COMPRADOR CON EL DOCUMENTO INDICADO: '''|| V_NIF_COMPRADOR ||''' ');
            END IF;

        

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    
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
EXIT

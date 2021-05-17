--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210505
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9293
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Borrado logico de configuracion de tarifas insertadas
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-9293'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_CFT_CONFIG_TARIFA'; --Vble. auxiliar para almacenar la tabla a insertar 

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN '||V_TABLA||' ');            

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR='''||V_USUARIO||''' ';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;            
    
    IF V_NUM_TABLAS > 0 THEN

        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS BORRADO LOGICO DE LAS TARIFAS: '''||V_USUARIO||''' ');
            
        
        V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
                BORRADO = 1,
                USUARIOBORRAR = '''||V_USUARIO||''', 
                FECHABORRAR = SYSDATE 
                WHERE USUARIOCREAR='''||V_USUARIO||''' ';

        EXECUTE IMMEDIATE V_MSQL;


        IF sql%rowcount > 0 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO]: Modificado tarifas con el USUARIOCREAR: '''||V_USUARIO||''' ');
            DBMS_OUTPUT.PUT_LINE('[INFO]:                                                             ');
        END IF;

    ELSE                
        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTEN TARIFAS CON EL USUARIOCREAR: '''||V_USUARIO||''' ');

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
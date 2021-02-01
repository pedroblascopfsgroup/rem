--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201214
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8438
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Modificar TBJ_TARIFICADO de dos ofertas para que puedan añadir presupuestos
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8438'; --Vble. auxiliar para almacenar el usuario
    V_TABLA_TRABAJO VARCHAR2(100 CHAR) :='ACT_TBJ_TRABAJO'; --Vble. auxiliar para almacenar la tabla a insertar 

    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar    
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN '||V_TABLA_TRABAJO||' ');            

    -- Comprobar si el trabajo existe
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_TRABAJO||' WHERE TBJ_NUM_TRABAJO = 916964361744';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;         
    
    IF V_NUM_TABLAS > 0 THEN

        DBMS_OUTPUT.PUT_LINE('[INFO]: PONEMOS A 0 EL CAMPO TBJ_TARIFICADO');
        
        V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA_TRABAJO||' SET 
                TBJ_TARIFICADO = 0,
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE 
                WHERE TBJ_NUM_TRABAJO = 916964361744';

        EXECUTE IMMEDIATE V_MSQL;

    ELSE                
        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL TRABAJO CON TBJ_NUM_TRABAJO = 916964361744');

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
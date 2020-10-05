--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20200925
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8124
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar subfase de publicacion de fase
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8124'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='DD_SFP_SUBFASE_PUBLICACION'; --Vble. auxiliar para almacenar la tabla a actualizar
    V_TABLA_FASES VARCHAR2(100 CHAR) := 'DD_FSP_FASE_PUBLICACION'; --Vble. auxiliar para almacenar la tabla de las fases a consultar

    V_SUBFASE_DESCRIPCION VARCHAR2(100 CHAR) :='Gestion APIs';
    V_FASE_CODIGO VARCHAR2(100 CHAR) :='09';
    
    
	
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar
    
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente


BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN DD_SFP_SUBFASE_PUBLICACION ');    
       
        
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_SFP_DESCRIPCION='''||V_SUBFASE_DESCRIPCION||''' ';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS > 0 THEN
              

            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_FASES||' WHERE DD_FSP_CODIGO='''||V_FASE_CODIGO||''' ';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS > 0 THEN
                V_SQL := 'SELECT DD_FSP_ID FROM '||V_ESQUEMA||'.'||V_TABLA_FASES||' WHERE DD_FSP_CODIGO='''||V_FASE_CODIGO||''' ';
            EXECUTE IMMEDIATE V_SQL INTO V_ID;

                DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos subfase: '''|| V_SUBFASE_DESCRIPCION ||''' ');

              V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                        DD_FSP_ID = '||V_ID||',
                        USUARIOMODIFICAR = '''||V_USUARIO||''', 
                        FECHAMODIFICAR = SYSDATE
                        WHERE DD_SFP_CODIGO=(SELECT DD_SFP_CODIGO FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_SFP_DESCRIPCION='''||V_SUBFASE_DESCRIPCION||''')';
                        
                EXECUTE IMMEDIATE V_SQL;
               
                V_COUNT:=V_COUNT+1;

            ELSE
              DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE FASE CON EL CODIGO INDICADO: '''|| V_FASE_CODIGO ||''' ');
            END IF;

                DBMS_OUTPUT.PUT_LINE('[INFO]:                                    ');
                DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE:= '''|| V_SUBFASE_DESCRIPCION ||''' ');
                DBMS_OUTPUT.PUT_LINE('[INFO]:                                    ');
            ELSE
              DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE LA SUBFASE CON LA DESCRIPCION INDICADA: '''|| V_SUBFASE_DESCRIPCION ||''' ');
            END IF;

        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS CORRECTAMENTE: '''||V_COUNT||''' REGISTROS ');

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
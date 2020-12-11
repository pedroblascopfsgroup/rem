--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201210
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8459
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Eliminar fechas fin de valoraciones
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8459'; --Vble. auxiliar para almacenar el usuario
    V_TABLA_VALORACIONES VARCHAR2(100 CHAR) :='ACT_VAL_VALORACIONES'; --Vble. auxiliar para almacenar la tabla a insertar 
    V_TABLA_ACTIVO VARCHAR2(100 CHAR) :='ACT_ACTIVO'; --Vble. auxiliar para almacenar la tabla a insertar    

    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar    
    
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente
    V_COUNT_TOTAL NUMBER(16):=0; --Vble. Para contar el total de registros de la iteracion


 TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('115204'),
        T_TIPO_DATA('116513'),
        T_TIPO_DATA('115174')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN '||V_TABLA_VALORACIONES||' ');            

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

        -- Comprobar si el activo existe
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO='''||V_TMP_TIPO_DATA(1)||''' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;         
        
        IF V_NUM_TABLAS > 0 THEN

            -- Obtener el ID del activo
            V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO='''||V_TMP_TIPO_DATA(1)||''' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;    

            DBMS_OUTPUT.PUT_LINE('[INFO]: PONEMOS A NULL LOS VAL_FECHA_FIN DEL ACTIVO: '''||V_TMP_TIPO_DATA(1)||''' ');
            
            V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA_VALORACIONES||' SET 
                    VAL_FECHA_FIN = NULL,
                    USUARIOMODIFICAR = '''||V_USUARIO||''', 
                    FECHAMODIFICAR = SYSDATE 
                    WHERE ACT_ID = '||V_ID||'';

            EXECUTE IMMEDIATE V_MSQL;

        ELSE                
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL ACTIVO CON ACT_NUM_ACTIVO: '''||V_TMP_TIPO_DATA(1)||''' ');

        END IF;

    END LOOP;

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
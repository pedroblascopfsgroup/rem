--/*
--######################################### 
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210517
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9741
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar webcom_id
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-9741'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_ICO_INFO_COMERCIAL'; --Vble. auxiliar para almacenar la tabla a insertar
    V_ID NUMBER(16); --Vble. Para almacenar el id 
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--          NUM_ACTIVO  ID_WEBCOM
        T_TIPO_DATA('7433713','865537'),
        T_TIPO_DATA('7433727','865531'),
        T_TIPO_DATA('7433728','865539')); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en ACT_ICO_INFO_COMRCIAL
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN ACT_ICO_INFO_COMRCIAL');
            
        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
        
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);


            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_ID = (SELECT ACT_ID FROM REM01.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '|| TRIM(V_TMP_TIPO_DATA(1)) ||' ) ';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS > 0 THEN
                V_SQL := 'SELECT ACT_ID FROM REM01.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '|| TRIM(V_TMP_TIPO_DATA(1)) ||' ';

                EXECUTE IMMEDIATE V_SQL INTO V_ID;

                V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                        ICO_WEBCOM_ID = '|| TRIM(V_TMP_TIPO_DATA(2)) ||' ,
                        USUARIOMODIFICAR = '''||V_USUARIO||''', 
                        FECHAMODIFICAR = SYSDATE
                        WHERE ACT_ID='||V_ID||'';
                        
                EXECUTE IMMEDIATE V_SQL;
               
                DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE:= '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
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

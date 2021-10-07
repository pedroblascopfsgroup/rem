--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210922
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10480
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar tipo y subtipo banco españa
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_ACTIVO NUMBER(16); -- Vble. sin prefijo.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-10480'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_ILB_NFO_LIBERBANK'; --Vble. auxiliar para almacenar la tabla a insertar
    V_TABLA_ACTIVO VARCHAR2(100 CHAR) :='ACT_ACTIVO'; --Vble. auxiliar para almacenar la tabla a insertar
    V_ID NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('6949118','8',1),
T_TIPO_DATA('6947941','8',1),
T_TIPO_DATA('6947942','8',1),
T_TIPO_DATA('6949589','8',1),
T_TIPO_DATA('6949583','8',1),
T_TIPO_DATA('6965219','17',1),
T_TIPO_DATA('7009665','7',1),
T_TIPO_DATA('6948067','8',1),
T_TIPO_DATA('6948080','8',1),
T_TIPO_DATA('6948920','8',1),
T_TIPO_DATA('6948842','8',1),
T_TIPO_DATA('6948107','8',1),
T_TIPO_DATA('6948082','8',1),
T_TIPO_DATA('6948933','8',1),
T_TIPO_DATA('7017938','17',1),
T_TIPO_DATA('7017941','17',1),
T_TIPO_DATA('6875128','17',1),
T_TIPO_DATA('6947990','8',1),
T_TIPO_DATA('6947869','8',1),
T_TIPO_DATA('6949142','8',1),
T_TIPO_DATA('6949153','8',1),
T_TIPO_DATA('6948062','8',1),
T_TIPO_DATA('6947721','8',1),
T_TIPO_DATA('7018039','17',1),
T_TIPO_DATA('7226589','10',1),
T_TIPO_DATA('7017958','17',1),
T_TIPO_DATA('6876554','17',1),
T_TIPO_DATA('7073146','6',1),
T_TIPO_DATA('6949148','8',1),
T_TIPO_DATA('6948956','8',1),
T_TIPO_DATA('6949578','8',1),
T_TIPO_DATA('6948104','8',1),
T_TIPO_DATA('6949540','8',1),
T_TIPO_DATA('7017957','17',1),
T_TIPO_DATA('7226593','10',1),
T_TIPO_DATA('6851222','17',1),
T_TIPO_DATA('6935676','17',1),
T_TIPO_DATA('6849345','17',1),
T_TIPO_DATA('6883885','17',1),
T_TIPO_DATA('6876820','17',1),
T_TIPO_DATA('6949397','21',2),
T_TIPO_DATA('6863435','6',2),
T_TIPO_DATA('7100989','1',2),
T_TIPO_DATA('6870955','1',2),
T_TIPO_DATA('7100992','1',2),
T_TIPO_DATA('7226593','2',2)


    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DD_TBE_ID Y DD_SBE_ID EN '||V_TABLA||'');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        --Comprobar si ya existe en la tabla sin el prefijo 999.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' ILB
                    JOIN '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT ON ILB.ACT_ID=ACT.ACT_ID        
                    WHERE ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' AND ACT.BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        -- Si no existe sin el prefijo 999 se actualiza.
        IF V_NUM_TABLAS = 1 AND V_TMP_TIPO_DATA(3) = 1 THEN

            --Comprobar si ya existe en la tabla sin el prefijo 999.
            V_MSQL := 'SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' ILB
                        JOIN '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT ON ILB.ACT_ID=ACT.ACT_ID        
                        WHERE ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' AND ACT.BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;
       	
            V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
                DD_SBE_ID = '''||V_TMP_TIPO_DATA(2)||'''
                WHERE ACT_ID = '||V_ID||' ';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado el activo: '''||TRIM(V_TMP_TIPO_DATA(1))||''' con DD_SBE_ID '''||TRIM(V_TMP_TIPO_DATA(2))||'''  ');

		ELSIF V_NUM_TABLAS = 1 AND V_TMP_TIPO_DATA(3) = 2 THEN
                        --Comprobar si ya existe en la tabla sin el prefijo 999.
            V_MSQL := 'SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' ILB
                    JOIN '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT ON ILB.ACT_ID=ACT.ACT_ID        
                    WHERE ACT.ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' AND ACT.BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;
       	
            V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
                DD_TBE_ID = '''||V_TMP_TIPO_DATA(2)||'''
                WHERE ACT_ID = '||V_ID||' ';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado el activo: '''||TRIM(V_TMP_TIPO_DATA(1))||''' con DD_TBE_ID '''||TRIM(V_TMP_TIPO_DATA(2))||'''  ');
        ELSE
            -- Si ya existe el código sin el prefijo se muestra por consola
			DBMS_OUTPUT.PUT_LINE('[INFO]: El activo '''||V_TMP_TIPO_DATA(1)||''' NO tiene registro en la '||V_TABLA||'');

		END IF;

      END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TABLA||' ACTUALIZADA CORRECTAMENTE ');
    
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
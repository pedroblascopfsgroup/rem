--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190128
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3074
--## PRODUCTO=NO
--## 
--## Finalidad: Borrado lógico del activo 6851293
--##
--## INSTRUCCIONES:  
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
  V_NUM_ACT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_NUM_ACT_BAJA NUMBER(16); -- Vble. para validar la existencia de una tabla.
  V_COUNT1 NUMBER(16);
  V_COUNT2 NUMBER(16);
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-3074';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	--------- NUM ACTIVO
    T_TIPO_DATA('6851293')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para actualizar los valores en ACT_PRO_PROPIETARIO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: DAR DE BAJA ACTIVOS');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        V_SQL:= 'SELECT COUNT(1) FROM REM01.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(1))||'';
        
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_ACT;
        
        V_SQL:= 'SELECT COUNT(1) FROM REM01.ACT_ACTIVO WHERE ACT_NUM_ACTIVO =  -'||TRIM(V_TMP_TIPO_DATA(1))||'';
        
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_ACT_BAJA;
                
        
        --Si existe realizamos otra comprobacion
        IF V_NUM_ACT = 1 AND V_NUM_ACT_BAJA = 0 THEN		
        V_COUNT1:= V_COUNT1 + 1;
        V_COUNT2:= V_COUNT2 + 1;
				-- Por agrupación de activos
            
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO
								SET
									ACT_NUM_ACTIVO = -'||TRIM(V_TMP_TIPO_DATA(1))||',
									USUARIOBORRAR = '''||V_USUARIO||''',
									FECHABORRAR = SYSDATE,
									BORRADO = 1
							WHERE
								ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(1))||'';
                
                EXECUTE IMMEDIATE V_MSQL;
                
                DBMS_OUTPUT.PUT_LINE('[INFO]: SE HA BORRADO EL ACTIVO '||TRIM(V_TMP_TIPO_DATA(1))||' ');

        ELSE
            IF V_NUM_ACT = 0 THEN       
                DBMS_OUTPUT.PUT_LINE('[ERROR]: EL ACTIVO '''||TRIM(V_TMP_TIPO_DATA(1))||''' NO EXISTE ');
            ELSE IF V_NUM_ACT_BAJA = 1 THEN
                DBMS_OUTPUT.PUT_LINE('[ERROR]: EL ACTIVO '''||TRIM(V_TMP_TIPO_DATA(1))||''' SE DIO DE BAJA CON ANTERIORIDAD');
            ELSE 
                DBMS_OUTPUT.PUT_LINE('[ERROR]: ERROR NO CONTROLADO EN LA QUERY : '||V_MSQL||'');
            END IF;
            END IF;
        END IF;
        
        IF V_COUNT1 > 50 THEN
            V_COUNT1 := 0;
            COMMIT;
        END IF;
        
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: SE HAN BORRADO '||V_COUNT2||' ACTIVOS ');

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
EXIT;

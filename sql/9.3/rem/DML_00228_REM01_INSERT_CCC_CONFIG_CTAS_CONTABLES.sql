--/*
--######################################### 
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200910
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8052
--## PRODUCTO=NO
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
    V_TABLA VARCHAR2(30 CHAR) := 'CCC_CONFIG_CTAS_CONTABLES';
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8052';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    V_DD_CRA_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la cartera.
	V_EJE_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del año.
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    -- CODIGO_STG,		CODIGO_CRA,		CODIGO_SCR,		CUENTA_CONTABLE,		ANYO_EJE 		
	T_TIPO_DATA('55','07','138','6230100020','2020')	
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;  
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en CPS_CONFIG_SUBPTDAS_PRE -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CCC_CONFIG_CTAS_CONTABLES] ');
    
    
    -- Recogemos el valor id de la cartera, porque es el mismo para todos
    V_SQL :=    'SELECT DD_CRA_ID 
                FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
                WHERE DD_CRA_CODIGO = ''07''';
   EXECUTE IMMEDIATE V_SQL INTO V_DD_CRA_ID;
    
   -- Recogemos el valor id del año, porque es el mismo para todos
   V_SQL :=    'SELECT EJE_ID 
                FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO 
                WHERE EJE_ANYO = 2020';
   EXECUTE IMMEDIATE V_SQL INTO V_EJE_ID;
    
        
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);    
        
        --Comprobamos el dato a insertar
	   	V_SQL :=   'SELECT COUNT(1) 
                    FROM '||V_ESQUEMA||'.'||V_TABLA||' 
                    WHERE DD_STG_ID = (SELECT DD_STG_ID 
										FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO								
										WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
					AND DD_CRA_ID = '||V_DD_CRA_ID||' 
					AND DD_SCR_ID = (SELECT DD_SCR_ID 
										FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA								
										WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''')
					AND CCC_CUENTA_CONTABLE = '''||TRIM(V_TMP_TIPO_DATA(4))||''' 
					AND EJE_ID = '||V_EJE_ID||' 
					AND CCC_ARRENDAMIENTO = 0';
					
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;        
        
       --Si no existe, lo insertamos
        IF V_NUM_TABLAS = 0 THEN            
         V_SQL :=    'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
                        (
                              CCC_ID
                            , DD_STG_ID
                            , DD_CRA_ID
                            , DD_SCR_ID
                            , VERSION
                            , USUARIOCREAR
                            , FECHACREAR
                            , BORRADO
                            , CCC_CUENTA_CONTABLE
                            , EJE_ID
                            , CCC_ARRENDAMIENTO                          
                        )
                        VALUES
                        (
                            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL
                            , (SELECT DD_STG_ID 
								FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG								
								WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
                            , '||V_DD_CRA_ID||'
                            , (SELECT DD_SCR_ID 
										FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR								
										WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''')
                            , 0
                            , '''||V_USUARIO||'''
                            , SYSDATE
                            , 0
                            , '||TRIM(V_TMP_TIPO_DATA(4))||'
                            , '||V_EJE_ID||'
                            , 0                           
                        )';
						
          EXECUTE IMMEDIATE V_SQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO CCC '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''  '''|| TRIM(V_TMP_TIPO_DATA(4)) ||''' INSERTADO CORRECTAMENTE');
          
        
        ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el subgasto con código '||TRIM(V_TMP_TIPO_DATA(1))||' en la cuenta contable '||TRIM(V_TMP_TIPO_DATA(4))||' para el año '||TRIM(V_TMP_TIPO_DATA(5))||'.');		
          
       END IF;
      END LOOP;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] Script finalizado correctamente');
    
    
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

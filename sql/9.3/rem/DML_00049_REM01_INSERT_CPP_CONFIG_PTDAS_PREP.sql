--/*
--######################################### 
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9235
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
    V_TABLA VARCHAR2(30 CHAR) := 'CPP_CONFIG_PTDAS_PREP';
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-9235';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    V_DD_CRA_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la cartera.
    V_DD_SCR_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la subcartera.
	V_EJE_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del año.
    
	CURSOR SUBCARTERA IS SELECT DD_SCR_ID FROM #ESQUEMA#.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO in ('138','151','152');
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    -- CODIGO_STG,		PARTIDA_PRESUPUESTARIA 		
	T_TIPO_DATA('03','PP054'),
	T_TIPO_DATA('04','PP055'),
	T_TIPO_DATA('05','PP050'),
	T_TIPO_DATA('06','PP054'),
	T_TIPO_DATA('07','PP057'),
	T_TIPO_DATA('08','PP054'),
	T_TIPO_DATA('09','PP054'),
	T_TIPO_DATA('10','PP054'),
	T_TIPO_DATA('11','PP054'),
	T_TIPO_DATA('12','PP054'),
	T_TIPO_DATA('13','PP054'),
	T_TIPO_DATA('14','PP054'),
	T_TIPO_DATA('15','PP054'),
	T_TIPO_DATA('16','PP054'),
	T_TIPO_DATA('17','PP054'),
	T_TIPO_DATA('18','PP054'),
	T_TIPO_DATA('19','PP054'),
	T_TIPO_DATA('20','PP054'),
	T_TIPO_DATA('21','PP059'),
	T_TIPO_DATA('22','PP059'),
	T_TIPO_DATA('23','PP059'),
	T_TIPO_DATA('24','PP059'),
	T_TIPO_DATA('25','PP059'),
	T_TIPO_DATA('26','PP011'),
	T_TIPO_DATA('27','PP011'),
	T_TIPO_DATA('28','PP011'),
	T_TIPO_DATA('29','PP011'),
	T_TIPO_DATA('30','PP011'),
	T_TIPO_DATA('31','PP011'),
	T_TIPO_DATA('32','PP011'),
	T_TIPO_DATA('33','PP011'),
	T_TIPO_DATA('34','PP011'),
	T_TIPO_DATA('35','PP041'),
	T_TIPO_DATA('36','PP042'),
	T_TIPO_DATA('37','PP043'),
	T_TIPO_DATA('38','PP043'),
	T_TIPO_DATA('39','PP039'),
	T_TIPO_DATA('40','PP039'),
	T_TIPO_DATA('41','PP039'),
	T_TIPO_DATA('42','PP039'),
	T_TIPO_DATA('43','PP026'),
	T_TIPO_DATA('44','PP025'),
	T_TIPO_DATA('46','PP021'),
	T_TIPO_DATA('47','PP021'),
	T_TIPO_DATA('48','PP020'),
	T_TIPO_DATA('49','PP036'),
	T_TIPO_DATA('50','PP036'),
	T_TIPO_DATA('51','PP030'),
	T_TIPO_DATA('52','PP037'),
	T_TIPO_DATA('53','PP036'),
	T_TIPO_DATA('54','PP036'),
	T_TIPO_DATA('57','PP035'),
	T_TIPO_DATA('58','PP031'),
	T_TIPO_DATA('59','PP035'),
	T_TIPO_DATA('60','PP035'),
	T_TIPO_DATA('61','PP035'),
	T_TIPO_DATA('62','PP035'),
	T_TIPO_DATA('63','PP035'),
	T_TIPO_DATA('64','PP026'),
	T_TIPO_DATA('65','PP035'),
	T_TIPO_DATA('66','PP035'),
	T_TIPO_DATA('67','PP035'),
	T_TIPO_DATA('68','PP035'),
	T_TIPO_DATA('69','PP035'),
	T_TIPO_DATA('70','PP007'),
	T_TIPO_DATA('71','PP007'),
	T_TIPO_DATA('72','PP010'),
	T_TIPO_DATA('73','PP010'),
	T_TIPO_DATA('74','PP010'),
	T_TIPO_DATA('75','PP010'),
	T_TIPO_DATA('76','PP010'),
	T_TIPO_DATA('77','PP007'),
	T_TIPO_DATA('78','PP007'),
	T_TIPO_DATA('81','PP007'),
	T_TIPO_DATA('82','PP007'),
	T_TIPO_DATA('83','PP007'),
	T_TIPO_DATA('84','PP007'),
	T_TIPO_DATA('85','PP049'),
	T_TIPO_DATA('86','PP048'),
	T_TIPO_DATA('87','PP048'),
	T_TIPO_DATA('88','PP040'),
	T_TIPO_DATA('89','PP043'),
	T_TIPO_DATA('90','PP020'),
	T_TIPO_DATA('93','PP011'),
	T_TIPO_DATA('94','PP036'),
	T_TIPO_DATA('97','PP021'),
	T_TIPO_DATA('98','PP020'),
	T_TIPO_DATA('99','PP020')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;  
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');    
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CPP_CONFIG_PTDAS_PREP] ');
    
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
   
   -- LOOP para insertar los valores en CPP_CONFIG_PTDAS_PREP segun la subcartera-----------------------------------------------------------------	
	FOR SCR IN SUBCARTERA LOOP
	
		V_DD_SCR_ID:=SCR.DD_SCR_ID;    		
    
	   -- LOOP para insertar los valores en CPP_CONFIG_PTDAS_PREP -----------------------------------------------------------------    
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
						AND DD_SCR_ID = '||V_DD_SCR_ID||' 
						AND CPP_PARTIDA_PRESUPUESTARIA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' 
						AND EJE_ID = '||V_EJE_ID||' 
						AND CPP_ARRENDAMIENTO = 0';
						
	        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;        
	        
	       --Si no existe, lo insertamos
	        IF V_NUM_TABLAS = 0 THEN            
	         V_SQL :=    'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
	                        (
	                              CPP_ID
	                            , DD_STG_ID
	                            , DD_CRA_ID
	                            , DD_SCR_ID
	                            , VERSION
	                            , USUARIOCREAR
	                            , FECHACREAR
	                            , BORRADO
	                            , CPP_PARTIDA_PRESUPUESTARIA
	                            , EJE_ID
	                            , CPP_ARRENDAMIENTO                          
	                        )
	                        VALUES
	                        (
	                            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL
	                            , (SELECT DD_STG_ID 
									FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG								
									WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
	                            , '||V_DD_CRA_ID||'
	                            , '||V_DD_SCR_ID||'
	                            , 0
	                            , '''||V_USUARIO||'''
	                            , SYSDATE
	                            , 0
	                            , '''||TRIM(V_TMP_TIPO_DATA(2))||'''
	                            , '||V_EJE_ID||'
	                            , 0                           
	                        )';
	         
							
	          EXECUTE IMMEDIATE V_SQL;
	          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO CPP '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''  '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' INSERTADO CORRECTAMENTE');
	          
	        
	        ELSE 
	            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro '||TRIM(V_TMP_TIPO_DATA(1))||' - '||TRIM(V_TMP_TIPO_DATA(2))||'');		
	          
	       END IF;
	      END LOOP;
	      
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

--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20211210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8511
--## PRODUCTO=NO
--## Finalidad: Carga de datos en ACT_EJE_EJERCICIO
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
V_ID NUMBER(16);
V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_EJE_EJERCICIO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

V_ANYO_INI NUMBER(16) := 2022;
V_ANYO_FIN NUMBER(16) := 2022;

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
	-- LOOP para insertar los valores en la tabla indicada
    	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||'] ');
    	FOR I IN V_ANYO_INI .. V_ANYO_FIN
      	LOOP
			DBMS_OUTPUT.PUT_LINE('[INFO]: ANYO '||I||'] ');
	        --Comprobamos el dato a insertar
        	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE EJE_ANYO = '''||I||'''';
        	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
	        --Si existe lo modificamos
        	IF V_NUM_TABLAS > 0 THEN				
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| I ||'''');
	       	  	V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
		        		'SET EJE_ANYO = '''||I||''''|| 
					', 	EJE_FECHAINI = TO_DATE('||'''01/01/'||I||''',''dd/mm/YYYY'')'|| 
					', 	EJE_FECHAFIN = TO_DATE('||'''31/12/'||I||''',''dd/mm/YYYY'')'|| 
					',  EJE_DESCRIPCION = ''Ejercicio correspondiente al año '|| I || ''''|| 
					',  USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'   WHERE EJE_ANYO = '''||I||'''';
		  	EXECUTE IMMEDIATE V_MSQL;
		  	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          	--Si no existe, lo insertamos   
			
       		ELSE
       			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| I ||'''');   
          		V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          		EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          		V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      		'EJE_ID, EJE_ANYO, EJE_FECHAINI , EJE_FECHAFIN, EJE_DESCRIPCION,' ||
				' VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      		'SELECT '|| V_ID || ','''||I||''',TO_DATE('||'''01/01/'||I||''',''dd/mm/YYYY''),TO_DATE('||'''31/12/'||I||''',''dd/mm/YYYY''), ''Ejercicio correspondiente al año '|| I || ''','||
                      		'0, ''DML'',SYSDATE,0 FROM DUAL';
			DBMS_OUTPUT.PUT_LINE(V_MSQL);
          		EXECUTE IMMEDIATE V_MSQL;
          		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
				
        	END IF;
      	END LOOP;
    	
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');
	

EXCEPTION

	WHEN OTHERS THEN

		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------');
		DBMS_OUTPUT.put_line(SQLERRM);

    ROLLBACK;
    RAISE;

END;
/
EXIT

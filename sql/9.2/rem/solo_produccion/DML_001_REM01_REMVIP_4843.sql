--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190717
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4843
--## PRODUCTO=NO
--##
--## Finalidad: SCRIPT PARA CAMBIAR LOS USERNAME DE LA ACT_GES_DIST_GESTORES
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
		T_FUNCION('gen.2659701','B35680149'),
		T_FUNCION('bri.mtoribio','47718980Y'),
		T_FUNCION('leg.legazpi','B85884336'),
		T_FUNCION('ine.integraval','B98493190'),
		T_FUNCION('home.reparalia','A82451410'),
		T_FUNCION('bri.mmiralles','43196798S'),
		T_FUNCION('gen.5865504','B60546611')
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN	
    
    -- LOOP para insertar los valores -----------------------------------------------------------------

    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
    	
      --Comprobamos el dato a insertar
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES WHERE USERNAME = '''||TRIM(V_TMP_FUNCION(2))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      --Si existe lo modificamos
      IF V_NUM_TABLAS > 0 THEN				
        
        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_FUNCION(2)) ||'''');
        
        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES 
					SET 
						USERNAME = '''||TRIM(V_TMP_FUNCION(1))||''',
						USUARIOMODIFICAR = ''REMVIP-4843'',
						FECHAMODIFICAR = SYSDATE
					WHERE USERNAME = '''||TRIM(V_TMP_FUNCION(2))||''' AND BORRADO = 0';
			
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
             
      END IF;

    END LOOP;
  COMMIT;
   

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(V_MSQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;

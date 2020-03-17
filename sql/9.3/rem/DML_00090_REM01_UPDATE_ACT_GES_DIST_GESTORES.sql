--/*
--##########################################
--## AUTOR=Joaquin Bahamonde
--## FECHA_CREACION=20200127
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9179
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza en ACT_GES_DIST_GESTORES los usuarios de la cartera SAREB y con el tipo de gestor "GACT" a "grupgact" 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


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
    V_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'HREOS-9179';

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('2', 'GACT', 'grupgact', 'Grupo Gestión de activos')
     	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	 
    -- LOOP para actualizar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACIÓN EN ACT_GES_DIST_GESTORES');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
           
        --Comprobamos el dato a insertar
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        --Modificamos los valores
        IF V_NUM_TABLAS > 0 THEN
		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
            'SET USERNAME = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
		    ', NOMBRE_USUARIO = '''||TRIM(V_TMP_TIPO_DATA(4))||''''|| 
            ', USUARIOMODIFICAR = '''||V_INCIDENCIA||''' , FECHAMODIFICAR = SYSDATE '||
            'WHERE COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
            'AND TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(2))||''' ';
          EXECUTE IMMEDIATE V_MSQL;
       END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_GES_DIST_GESTORES MODIFICADA CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
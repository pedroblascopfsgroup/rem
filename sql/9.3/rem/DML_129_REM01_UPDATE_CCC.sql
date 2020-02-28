--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200227
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9612
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en proveedores los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ID_COD_REM NUMBER(16);
    V_ID_PVC NUMBER(16);
    V_ID_ETP NUMBER(16);
    V_BOOLEAN NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-9612';
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('01','2020', '151','6311001'),
      T_TIPO_DATA('01','2019', '151','6311000'),
      T_TIPO_DATA('01','2018', '151','6311003'),
      T_TIPO_DATA('02','2020', '151','6311001'),
      T_TIPO_DATA('02','2019', '151','6311000'),
      T_TIPO_DATA('02','2018', '151','6311003'),
      T_TIPO_DATA('01','2020', '152','6311001'),
      T_TIPO_DATA('01','2019', '152','6311000'),
      T_TIPO_DATA('01','2018', '152','6311003'),
      T_TIPO_DATA('02','2020', '152','6311001'),
      T_TIPO_DATA('02','2019', '152','6311000'),
      T_TIPO_DATA('02','2018', '152','6311003')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: COMENZAMOS ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) 
        FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
        JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CCC.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
        LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CCC.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
        LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CCC.DD_STG_ID = STG.DD_STG_ID
        WHERE SCR.DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''
        AND STG.DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
        AND EJE.EJE_ANYO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
        AND CCC.CCC_CUENTA_CONTABLE = '''||TRIM(V_TMP_TIPO_DATA(4))||'''
        AND CCC.BORRADO = 0
        ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --1 existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN	

          DBMS_OUTPUT.PUT_LINE('[INFO]: NO SE TIENE QUE MODIFICAR LA CUENTA: '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''');  

        ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''' y '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''');  

          V_MSQL := '
            UPDATE '|| V_ESQUEMA ||'.CCC_CONFIG_CTAS_CONTABLES CCC SET
            CCC.EJE_ID = (SELECT EJE.EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''')
            , CCC.USUARIOMODIFICAR = '''||TRIM(V_ITEM)||'''
            , CCC.FECHAMODIFICAR = SYSDATE
            WHERE CCC.CCC_ID = (
              SELECT CCC.CCC_ID
              FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
              JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON CCC.EJE_ID = EJE.EJE_ID AND EJE.BORRADO = 0
              LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON CCC.DD_SCR_ID = SCR.DD_SCR_ID AND SCR.BORRADO = 0
              LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON CCC.DD_STG_ID = STG.DD_STG_ID
              WHERE SCR.DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''
              AND STG.DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
              AND CCC.CCC_CUENTA_CONTABLE = '''||TRIM(V_TMP_TIPO_DATA(4))||'''
              AND CCC.BORRADO = 0)
          ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]:  MODIFICADO CORRECTAMENTE ');
   

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

EXIT

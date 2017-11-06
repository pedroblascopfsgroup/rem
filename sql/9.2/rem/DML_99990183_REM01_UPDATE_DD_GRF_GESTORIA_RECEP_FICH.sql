--/*
--##########################################
--## AUTOR=Isidro Sotoca
--## FECHA_CREACION=20171103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3087
--## PRODUCTO=NO
--##
--## Finalidad: modifica la información del campo PVE_COD_REM de la tabla DD_GRF_GESTORIA_RECEP_FICH 
--## con la información del excel adjunto para las gestorías del Bankia.
--##
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
    
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(50 CHAR) := 'DD_GRF_GESTORIA_RECEP_FICH';
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-3147';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);

    -- FILAS A MODIFICAR O CREAR
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                    --DD_GRF_CODIGO		--PVE_COD_REM
        T_TIPO_DATA('4',             	'10005592'	), -- pinos
        T_TIPO_DATA('3',              	'10004978'	), -- uniges
        T_TIPO_DATA('2',              	'10004652'	), -- montalvo
        T_TIPO_DATA('1',             	'10004484'	), -- gutierrez_labrador
        T_TIPO_DATA('5',              	'10004837'	), -- garsa
        T_TIPO_DATA('8',              	'10006316'	), -- diagonal_company
        T_TIPO_DATA('9',             	'10009469'	)  -- grupoBC
    );
    V_TMP_TIPO_DATA T_TIPO_DATA;
    V_BORRADO NUMBER(1,0) := 0;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	-- LOOP para insertar los valores en DD_GRF_GESTORIA_RECEP_FICH -----------------------------------------------------------------
  	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO REGISTROS DE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'] ');
  	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    	LOOP

      		V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
        	DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  	V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
	            'SET PVE_COD_REM = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
	            ', BORRADO = '''||V_BORRADO||''' '||
	            ', USUARIOMODIFICAR = '''||TRIM(V_USUARIO)||'''
	            , FECHAMODIFICAR = SYSDATE '||
	            'WHERE DD_GRF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        	EXECUTE IMMEDIATE V_MSQL;
        	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
        	
    	END LOOP;

  	COMMIT;
  	DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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
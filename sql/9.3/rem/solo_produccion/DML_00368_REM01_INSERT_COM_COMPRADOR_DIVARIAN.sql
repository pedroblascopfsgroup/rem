--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200702
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-7702
--## PRODUCTO=NO
--##
--## Finalidad: Script que borra en CLC_CLIENTES_COMERCIALES los datos añadidos en T_ARRAY_DATA
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
    V_NUM_TABLAS2 NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

	T_TIPO_DATA(1764307,'JORDI','15','39104658N','MIG','99999','','','99','1','','','','ARMENGOL SANCHEZ',''),
	T_TIPO_DATA(1764309,'Calvo mora investment servicies s.l','02','B66992629','MIG','99999','','','99','2','','15','','','00000001R')


    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_LOC_LOCALIDAD -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CLC_CLIENTE_COMERCIAL] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
  
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.COM_COMPRADOR (' ||
                      	'COM_ID,
			DD_TPE_ID,
			COM_NOMBRE,
			COM_APELLIDOS,
			DD_TDI_ID,
			COM_DOCUMENTO,
			COM_TELEFONO1,
			COM_EMAIL,
			COM_CODIGO_POSTAL,
			VERSION,
			USUARIOCREAR,
			FECHACREAR,
			BORRADO,
			CLC_ID,
			DD_LOC_ID,
			DD_PRV_ID,
			COM_COD_COMPRADOR_DIVARIAN) 	SELECT '|| V_ESQUEMA ||'.S_COM_COMPRADOR.NEXTVAL,(SELECT DD_TPE_ID FROM '||V_ESQUEMA||'.DD_TPE_TIPO_PERSONA WHERE DD_TPE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(10))||'''), '''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(14))||''',(SELECT DD_TDI_ID FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''),'''||TRIM(V_TMP_TIPO_DATA(4))||''', ''666666666'', '''||TRIM(V_TMP_TIPO_DATA(5))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', 0,''REMVIP-7702'', SYSDATE, 0, (SELECT CLC_ID FROM '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL WHERE CLC_COD_CLIENTE_PRINEX = '''||TRIM(V_TMP_TIPO_DATA(1))||'''), (SELECT DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(6))||'''), (SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(9))||'''), '''||TRIM(V_TMP_TIPO_DATA(11))||''' FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE EN LA COM_COMPRADOR');

      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: HA ACABADO CORRECTAMENTE LA INSERCIÓN DE COM_COMPRADOR');
   

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

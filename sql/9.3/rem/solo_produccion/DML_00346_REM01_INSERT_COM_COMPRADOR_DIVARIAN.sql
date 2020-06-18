--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200618
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-7567
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade COM_COMPRADORES los datos añadidos en T_ARRAY_DATA
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

T_TIPO_DATA(1605282,'JUAN MANUEL  DIAZ  MONSALVE','01','39043699A','EPEREZ@CLODOSA.COM','08187','08201','','8','1','CO/453726'),
	T_TIPO_DATA(1581613,'MARIA DEL CARMEN TORRALBA MATEO','01','21512930H','ganchique1@gmail.com','03014','03001','30140002','3','1','CO/453005'),
	T_TIPO_DATA(1674746,'PETROINSTAL, SL SL SL','02','B64680937','josepm.riba@petroinstal.com','08102','08700','81020001','8','2','CO/452690'),
	T_TIPO_DATA(1675834,'RAMOON 1983 SL ZHOU','02','B76234459','FUERCHINA@HOTMAIL.ES','35014','35660','350140002','35','2','CO/418116'),
	T_TIPO_DATA(1673465,'AULA 10 FORMACIÓN Y SERVICIOS  S.L.','02','B54213087','inmopuerto@hotmail.es','','','','','2','CO/442295'),
	T_TIPO_DATA(1671119,'MACARENEL  S.L. B06495139.','02','B06495139','gestion@tecnicasa.net','','','','','2','CO/449577'),
	T_TIPO_DATA(1678092,'REBOLLOS AZOR CB .. ..','02','E90300633','fnunezasesores@gmail.com','','','','','2','CO/451656')/*,
	T_TIPO_DATA(1588843,'VICENTE JOSÉ UMBRIA  LÓPEZ','01','27337609Q','umbriaservicios@gmail.com','11012','11004','110120001','11','1','CO/453495')*/,
	T_TIPO_DATA(1668409,'GUILLERMO AARON TORRES  DE LA ROSA','01','78705768K','portivas@hotmail.com','','','','','1','CO/452810'),
	T_TIPO_DATA(1581518,'ABRAHAM VIÑA FERNANDEZ','01','21489573Y','ganchique1@gmail.com','03014','03001','30140002','3','1','CO/453004'),
	T_TIPO_DATA(1672320,'QUESADA Y CUEVAS SL','02','B29568532','MIG','11012','11004','110120001','11','2','CO/456412'),
	T_TIPO_DATA(1596222,'ANTONIA MANZANILLA VERA','01','33862064S','687284182@687284182.null','08187','08201','','8','1','CO/453725'),
	T_TIPO_DATA(1673274,'IRUANE SOCIEDAD ANONIMA','02','B48732770','bego.albo@hotmail.com','','','','','2','CO/453928'),
	T_TIPO_DATA(1618383,'FRANCISCO NUÑEZ ROMERO','01','44032020S','arc@comunidadesdelsur.com','','','','','1','CO/454134'),
	T_TIPO_DATA(1616144,'IVAN CUENCA VALDIVIA','01','43527126V','ivan.cuencavaldivia@cofidis.es','08006','08350','80060001','8','1','CO/454171')/*,
	T_TIPO_DATA(1687885,'CRISTIAN IOAN PETRULE','03','X6120121M','MIG','28060','28597','280600001','28','1','CO/453268')*/





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
			COM_COD_COMPRADOR_DIVARIAN) 	SELECT '|| V_ESQUEMA ||'.S_COM_COMPRADOR.NEXTVAL,(SELECT DD_TPE_ID FROM '||V_ESQUEMA||'.DD_TPE_TIPO_PERSONA WHERE DD_TPE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(10))||'''), '''||TRIM(V_TMP_TIPO_DATA(2))||''',(SELECT DD_TDI_ID FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''),'''||TRIM(V_TMP_TIPO_DATA(4))||''', ''666666666'', '''||TRIM(V_TMP_TIPO_DATA(5))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', 0,''REMVIP-7567'', SYSDATE, 0, (SELECT CLC_ID FROM '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL WHERE CLC_COD_CLIENTE_PRINEX = '''||TRIM(V_TMP_TIPO_DATA(1))||'''), (SELECT DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(6))||'''), (SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(9))||'''), '''||TRIM(V_TMP_TIPO_DATA(11))||''' FROM DUAL';
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

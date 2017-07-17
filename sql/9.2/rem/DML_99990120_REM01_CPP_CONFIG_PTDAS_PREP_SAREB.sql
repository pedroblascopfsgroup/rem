--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20170309
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1684
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en CPP_CONFIG_PTDAS_PREP los datos añadidos en T_ARRAY_DATA.
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
    V_TABLA VARCHAR2(50 CHAR) := 'CPP_CONFIG_PTDAS_PREP';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- PARATIDAS PARA ANYO EN CURSO (2017)
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(	
    	--			EJE_ANYO	DD_STG_COD	DD_CRA_COD	DD_SCR_COD	PRO_COD	PVE_COD	CPP_PARTIDA_PRESUPUESTARIA	CPP_ARRENDAMIENTO
		-- Tipo gasto: IMPUESTO
		T_TIPO_DATA('2017'		,'01'		,'02'		,''			,''		,''		,'G011311'					,'0'),
		T_TIPO_DATA('2017'		,'02'		,'02'		,''			,''		,''		,'G011311'					,'0'),
		T_TIPO_DATA('2017'		,'03'		,'02'		,''			,''		,''		,'G011367'					,'0'),
		T_TIPO_DATA('2017'		,'04'		,'02'		,''			,''		,''		,'G011324'					,'0'),
		T_TIPO_DATA('2017'		,'92'		,'02'		,''			,''		,''		,'G011379'					,'0'),
		-- Tipo gasto: TASA
		T_TIPO_DATA('2017'		,'08'		,'02'		,''			,''		,''		,'G011323'					,'0'),
		T_TIPO_DATA('2017'		,'09'		,'02'		,''			,''		,''		,'G011323'					,'0'),
		T_TIPO_DATA('2017'		,'10'		,'02'		,''			,''		,''		,'G011323'					,'0'),
		T_TIPO_DATA('2017'		,'11'		,'02'		,''			,''		,''		,'G011323'					,'0'),
		T_TIPO_DATA('2017'		,'12'		,'02'		,''			,''		,''		,'G011323'					,'0'),
		T_TIPO_DATA('2017'		,'16'		,'02'		,''			,''		,''		,'G011338'					,'0'),
		T_TIPO_DATA('2017'		,'18'		,'02'		,''			,''		,''		,'G011323'					,'0'),
		-- Tipo gasto: OTROS TRIBUTOS
		T_TIPO_DATA('2017'		,'19'		,'02'		,''			,''		,''		,'G011323'					,'0'),
		-- Tipo gasto: SANCIÓN
		T_TIPO_DATA('2017'		,'21'		,'02'		,''			,''		,''		,'G011325'					,'0'),
		T_TIPO_DATA('2017'		,'22'		,'02'		,''			,''		,''		,'G011325'					,'0'),
		T_TIPO_DATA('2017'		,'23'		,'02'		,''			,''		,''		,'G011325'					,'0'),
		T_TIPO_DATA('2017'		,'24'		,'02'		,''			,''		,''		,'G011325'					,'0'),
		T_TIPO_DATA('2017'		,'25'		,'02'		,''			,''		,''		,'G011325'					,'0'),
		-- Tipo gasto: COMUNIDAD DE PROPIETAROS
		T_TIPO_DATA('2017'		,'26'		,'02'		,''			,''		,''		,'G011309'					,'0'),
		T_TIPO_DATA('2017'		,'27'		,'02'		,''			,''		,''		,'G011309'					,'0'),
		T_TIPO_DATA('2017'		,'93'		,'02'		,''			,''		,''		,'G011378'					,'0'),
		-- Tipo gasto: JUNTA COMPENSACIÓN / EUC
		T_TIPO_DATA('2017'		,'30'		,'02'		,''			,''		,''		,'G011313'					,'0'),
		T_TIPO_DATA('2017'		,'31'		,'02'		,''			,''		,''		,'G011357'					,'0'),
		-- Tipo gasto: SUMINISTRO
		T_TIPO_DATA('2017'		,'35'		,'02'		,''			,''		,''		,'G011335'					,'0'),
		T_TIPO_DATA('2017'		,'36'		,'02'		,''			,''		,''		,'G011336'					,'0'),
		T_TIPO_DATA('2017'		,'37'		,'02'		,''			,''		,''		,'G011337'					,'0'),
			-- Gastos de SUMINISTRO - ARRENDATARIOS
		T_TIPO_DATA('2017'		,'35'		,'02'		,''			,''		,''		,'G011373'					,'1'),
		T_TIPO_DATA('2017'		,'36'		,'02'		,''			,''		,''		,'G011374'					,'1'),
		T_TIPO_DATA('2017'		,'37'		,'02'		,''			,''		,''		,'G011375'					,'1'),	
		-- Tipo gasto: SEGUROS
		T_TIPO_DATA('2017'		,'39'		,'02'		,''			,''		,''		,'G011321'					,'0'),
		T_TIPO_DATA('2017'		,'40'		,'02'		,''			,''		,''		,'G011321'					,'0'),
		T_TIPO_DATA('2017'		,'41'		,'02'		,''			,''		,''		,'G011321'					,'0'),
		T_TIPO_DATA('2017'		,'42'		,'02'		,''			,''		,''		,'G011321'					,'0'),
		-- Tipo gasto: SERVICIOS PROFESIONALES INDEPENDIENTES
		T_TIPO_DATA('2017'		,'43'		,'02'		,''			,''		,''		,'G011360'					,'0'),
		T_TIPO_DATA('2017'		,'44'		,'02'		,''			,''		,''		,'G011301'					,'0'),
		T_TIPO_DATA('2017'		,'95'		,'02'		,''			,''		,''		,'G011358'					,'0'),
		T_TIPO_DATA('2017'		,'96'		,'02'		,''			,''		,''		,'G011358'					,'0'),
		T_TIPO_DATA('2017'		,'97'		,'02'		,''			,''		,''		,'G011358'					,'0'),
		T_TIPO_DATA('2017'		,'46'		,'02'		,''			,''		,''		,'G011334'					,'0'),
		T_TIPO_DATA('2017'		,'47'		,'02'		,''			,''		,''		,'G011377'					,'0'),
		T_TIPO_DATA('2017'		,'49'		,'02'		,''			,''		,''		,'G011377'					,'0'),
		T_TIPO_DATA('2017'		,'51'		,'02'		,''			,''		,''		,'G011318'					,'0'),
		-- Tipo gasto: GESTORÍA
		T_TIPO_DATA('2017'		,'53'		,'02'		,''			,''		,''		,'G011361'					,'0'),
		T_TIPO_DATA('2017'		,'54'		,'02'		,''			,''		,''		,'G011328'					,'0'),
		-- Tipo gasto: INFORMES TÉCNICOS y OBTENCIÓN DOCUMENTOS
		T_TIPO_DATA('2017'		,'57'		,'02'		,''			,''		,''		,'G011332'					,'0'),
		T_TIPO_DATA('2017'		,'58'		,'02'		,''			,''		,''		,'G011329'					,'0'),
		T_TIPO_DATA('2017'		,'59'		,'02'		,''			,''		,''		,'G011351'					,'0'),
		T_TIPO_DATA('2017'		,'60'		,'02'		,''			,''		,''		,'G011330'					,'0'),
		T_TIPO_DATA('2017'		,'61'		,'02'		,''			,''		,''		,'G011333'					,'0'),
		T_TIPO_DATA('2017'		,'62'		,'02'		,''			,''		,''		,'G011346'					,'0'),
		T_TIPO_DATA('2017'		,'63'		,'02'		,''			,''		,''		,'G011332'					,'0'),
		T_TIPO_DATA('2017'		,'64'		,'02'		,''			,''		,''		,'G011360'					,'0'),
		T_TIPO_DATA('2017'		,'65'		,'02'		,''			,''		,''		,'G011376'					,'0'),
		T_TIPO_DATA('2017'		,'66'		,'02'		,''			,''		,''		,'G011376'					,'0'),
		T_TIPO_DATA('2017'		,'67'		,'02'		,''			,''		,''		,'G011376'					,'0'),
		-- Tipo gasto: ACTUACIÓN TÉCNICA Y MANTENIMIENTO
		T_TIPO_DATA('2017'		,'70'		,'02'		,''			,''		,''		,'G011317'					,'0'),
		T_TIPO_DATA('2017'		,'71'		,'02'		,''			,''		,''		,'G011316'					,'0'),
		T_TIPO_DATA('2017'		,'72'		,'02'		,''			,''		,''		,'G011315'					,'0'),
		T_TIPO_DATA('2017'		,'73'		,'02'		,''			,''		,''		,'G011315'					,'0'),
		T_TIPO_DATA('2017'		,'74'		,'02'		,''			,''		,''		,'G011315'					,'0'),
		T_TIPO_DATA('2017'		,'75'		,'02'		,''			,''		,''		,'G011315'					,'0'),
		T_TIPO_DATA('2017'		,'76'		,'02'		,''			,''		,''		,'G011316'					,'0'),
		T_TIPO_DATA('2017'		,'77'		,'02'		,''			,''		,''		,'G011316'					,'0'),
		T_TIPO_DATA('2017'		,'78'		,'02'		,''			,''		,''		,'G011316'					,'0'),
		T_TIPO_DATA('2017'		,'79'		,'02'		,''			,''		,''		,'G011316'					,'0'),
		T_TIPO_DATA('2017'		,'81'		,'02'		,''			,''		,''		,'G011332'					,'0'),
		T_TIPO_DATA('2017'		,'82'		,'02'		,''			,''		,''		,'G011316'					,'0'),
		T_TIPO_DATA('2017'		,'83'		,'02'		,''			,''		,''		,'G011316'					,'0'),
		-- Tipo gasto: VIGILANCIA Y SEGURIDAD
		T_TIPO_DATA('2017'		,'85'		,'02'		,''			,''		,''		,'G011327'					,'0'),
		T_TIPO_DATA('2017'		,'86'		,'02'		,''			,''		,''		,'G011327'					,'0'),
		T_TIPO_DATA('2017'		,'87'		,'02'		,''			,''		,''		,'G011327'					,'0'),
		-- Tipo gasto: OTROS GASTOS
		T_TIPO_DATA('2017'		,'89'		,'02'		,''			,''		,''		,'G011349'					,'0')
					
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    -- PARTIDAS PARA ANYOS ANTERIORES (2012-2016)
    TYPE T_ARRAY_ANTERIOR IS TABLE OF T_TIPO_DATA;
    V_TIPO_ANTERIOR T_ARRAY_ANTERIOR := T_ARRAY_ANTERIOR(
    	--			DD_STG_COD	DD_CRA_COD	DD_SCR_COD	PRO_COD	PVE_COD	CPP_PARTIDA_PRESUPUESTARIA	CPP_ARRENDAMIENTO
    	-- Tipo gasto: IMPUESTO
    	T_TIPO_DATA('01'		,'02'		,''			,''		,''		,'G011340'),
    	T_TIPO_DATA('02'		,'02'		,''			,''		,''		,'G011340'),
    	T_TIPO_DATA('03'		,'02'		,''			,''		,''		,'G011368'),
    	T_TIPO_DATA('04'		,'02'		,''			,''		,''		,'G011359'),
    	T_TIPO_DATA('92'		,'02'		,''			,''		,''		,'G011379'),
    	-- Tipo gasto: SANCIÓN
		T_TIPO_DATA('21'		,'02'		,''			,''		,''		,'G011325'),
		T_TIPO_DATA('22'		,'02'		,''			,''		,''		,'G011325'),
		T_TIPO_DATA('23'		,'02'		,''			,''		,''		,'G011325'),
		T_TIPO_DATA('24'		,'02'		,''			,''		,''		,'G011325'),
		T_TIPO_DATA('25'		,'02'		,''			,''		,''		,'G011325'),
		-- Tipo gasto: COMUNIDAD DE PROPIETAROS
		T_TIPO_DATA('26'		,'02'		,''			,''		,''		,'G011339'),
		T_TIPO_DATA('27'		,'02'		,''			,''		,''		,'G011339')
    	
    ); 
    V_TMP_TIPO_ANTERIOR T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    -- Mientras sea una tabla de configuración de la que extraemos información y no haya ninguna FK apuntando a su id, 
    -- podemos borrar la tabla completa y volver a generar la configuración.
    V_MSQL := 'TRUNCATE TABLE '|| V_ESQUEMA ||'.'|| V_TABLA; 
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: TABLA TRUNCADA');
	 
    -- LOOP para insertar los valores en CPP_CONFIG_PTDAS_PREP -----  EJECICIO 2017   -------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CPP_CONFIG_PTDAS_PREP - EJECICIO 2017 ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '||I);   
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_CPP_CONFIG_PTDAS_PREP.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CPP_CONFIG_PTDAS_PREP (' ||
                    'CPP_ID, EJE_ID, DD_STG_ID, DD_CRA_ID, DD_SCR_ID, PRO_ID, PVE_ID, CPP_PARTIDA_PRESUPUESTARIA, CPP_ARRENDAMIENTO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES' ||
                      '('|| V_ID || ',
                      (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||V_TMP_TIPO_DATA(1)||'''),
					  (SELECT DD_STG_ID FROM '||V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
					  (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''),
					  (SELECT DD_SCR_ID FROM '||V_ESQUEMA ||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(4)||'''),
					  (SELECT PRO_ID FROM '||V_ESQUEMA ||'.ACT_PRO_PROPIETARIO WHERE PRO_CODIGO_UVEM = '''||V_TMP_TIPO_DATA(5)||'''),
					  (SELECT PVE_ID FROM '||V_ESQUEMA ||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '''||V_TMP_TIPO_DATA(6)||'''),
                      '''||TRIM(V_TMP_TIPO_DATA(7))||''', '||V_TMP_TIPO_DATA(8) ||'
                      , 0, ''DML_F2'',SYSDATE,0 )';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

      END LOOP;
      
    -- LOOP para insertar los valores en CPP_CONFIG_PTDAS_PREP -----  EJECICIO 2012-2016   -------------------------------------------  
    FOR anyo IN 2012 .. 2016 
     LOOP
     	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CPP_CONFIG_PTDAS_PREP - EJECICIO '||anyo);
      	FOR I IN V_TIPO_ANTERIOR.FIRST .. V_TIPO_ANTERIOR.LAST  
       	 LOOP
      
      		V_TMP_TIPO_ANTERIOR := V_TIPO_ANTERIOR(I);
	   		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '||I);   
		    V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_CPP_CONFIG_PTDAS_PREP.NEXTVAL FROM DUAL';
		    EXECUTE IMMEDIATE V_MSQL INTO V_ID;
		    V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CPP_CONFIG_PTDAS_PREP (' ||
                    'CPP_ID, EJE_ID, DD_STG_ID, DD_CRA_ID, DD_SCR_ID, PRO_ID, PVE_ID, CPP_PARTIDA_PRESUPUESTARIA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES' ||
                      '('|| V_ID || ',
                      (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||anyo||'''),
					  (SELECT DD_STG_ID FROM '||V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_ANTERIOR(1)||'''),
					  (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_ANTERIOR(2)||'''),
					  (SELECT DD_SCR_ID FROM '||V_ESQUEMA ||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_TIPO_ANTERIOR(3)||'''),
					  (SELECT PRO_ID FROM '||V_ESQUEMA ||'.ACT_PRO_PROPIETARIO WHERE PRO_CODIGO_UVEM = '''||V_TMP_TIPO_ANTERIOR(4)||'''),
					  (SELECT PVE_ID FROM '||V_ESQUEMA ||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '''||V_TMP_TIPO_ANTERIOR(5)||'''),
                      '''||TRIM(V_TMP_TIPO_ANTERIOR(6))||''',
                       0, ''DML_F2'',SYSDATE,0 )';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
		    
		    
      	END LOOP;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA CPP_CONFIG_PTDAS_PREP ACTUALIZADA CORRECTAMENTE ');
   

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

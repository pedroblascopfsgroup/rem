--/*
--##########################################
--## AUTOR=Sonia Garcia
--## FECHA_CREACION=20190219
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-5530
--## PRODUCTO=NO
--##
--## Finalidad: Se crea nuevos motivos de rechazos
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

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	T_TIPO_DATA('F39' , 'Gastos tipo plusvalía por gestoras Postventa',
			'No pueden darse de alta gastos de tipo plusvalía por gestorías de tipo "Postventa".', '1', 
			'INNER JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.COD_ACTIVO
		 	 INNER JOIN '|| V_ESQUEMA ||'.GAC_GESTOR_ADD_ACTIVO GAC on GAC.ACT_ID = ACT.ACT_ID
		 	 INNER JOIN '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.BORRADO = 0
		 	 INNER JOIN '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO =''''GTOPOSTV''''
			 INNER JOIN '|| V_ESQUEMA_M ||'.USU_USUARIOS USU ON USU.USU_ID = GEE.USU_ID
			 INNER JOIN '|| V_ESQUEMA ||'.DD_GRF_GESTORIA_RECEP_FICH GRF ON GRF.USERNAME_GIAADMT = USU.USU_USERNAME and GRF.DD_GRF_CODIGO = AUX.COD_GESTORIA
			 INNER JOIN '|| V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = AUX.SUBTIPO_GASTO AND STG.DD_STG_CODIGO in (''''03'''',''''04'''')'),

	T_TIPO_DATA('F36' ,'Gastos IBI por gestoras Plusvalía',
            'No pueden darse de alta gastos de IBI y comunidades por gestorías de tipo "Plusvalía".', '1', 
			'INNER JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.COD_ACTIVO
			 INNER JOIN '|| V_ESQUEMA ||'.GAC_GESTOR_ADD_ACTIVO GAC on GAC.ACT_ID = ACT.ACT_ID
			 INNER JOIN '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.BORRADO = 0
			 INNER JOIN '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO =''''GTOPLUS''''
			 INNER JOIN '|| V_ESQUEMA_M ||'.USU_USUARIOS USU ON USU.USU_ID = GEE.USU_ID
			 INNER JOIN '|| V_ESQUEMA ||'.DD_GRF_GESTORIA_RECEP_FICH GRF ON GRF.USERNAME_GIAADMT = USU.USU_USERNAME and GRF.DD_GRF_CODIGO = AUX.COD_GESTORIA
			 INNER JOIN '|| V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = AUX.SUBTIPO_GASTO AND STG.DD_STG_CODIGO in (''''01'''',''''02'''')'),

	T_TIPO_DATA('F37', 'Gastos IBI por gestora Administración teniendo Postventa', 
            'No pueden darse de alta gastos de IBI y comunidades por una gestoría de tipo “Administración” debido a que tiene asignada una gestoría de Postventa.', '1', 
			'INNER JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.COD_ACTIVO
			 INNER JOIN '|| V_ESQUEMA ||'.GAC_GESTOR_ADD_ACTIVO GAC on GAC.ACT_ID = ACT.ACT_ID
			 INNER JOIN '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.BORRADO = 0
			 INNER JOIN '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO =''''GIAADMT''''
			 INNER JOIN '|| V_ESQUEMA_M ||'.USU_USUARIOS USU ON USU.USU_ID = GEE.USU_ID
			 INNER JOIN '|| V_ESQUEMA ||'.DD_GRF_GESTORIA_RECEP_FICH GRF ON GRF.USERNAME_GIAADMT = USU.USU_USERNAME and GRF.DD_GRF_CODIGO = AUX.COD_GESTORIA
			 INNER JOIN '|| V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = AUX.SUBTIPO_GASTO AND STG.DD_STG_CODIGO in (''''01'''',''''02'''')
			 INNER JOIN '|| V_ESQUEMA ||'.GAC_GESTOR_ADD_ACTIVO GAC2 on GAC2.ACT_ID = ACT.ACT_ID
			 INNER JOIN '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD GEE2 ON GEE2.GEE_ID = GAC2.GEE_ID AND GEE.BORRADO = 0
			 INNER JOIN '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR TGE2 ON TGE2.DD_TGE_ID = GEE2.DD_TGE_ID AND TGE2.DD_TGE_CODIGO =''''GTOPOSTV''''  ' ),


	T_TIPO_DATA('F38' ,'Gastos plusvalía por gestora Administración teniendo Plusvalía',
            'No pueden darse de alta gastos de plusvalía por una gestoría de tipo “Administración” debido a que tiene asignada una gestoría de Plusvalía.', '1', 
			'INNER JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.COD_ACTIVO
			 INNER JOIN '|| V_ESQUEMA ||'.GAC_GESTOR_ADD_ACTIVO GAC on GAC.ACT_ID = ACT.ACT_ID
			 INNER JOIN '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.BORRADO = 0
			 INNER JOIN '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO =''''GIAADMT''''
			 INNER JOIN '|| V_ESQUEMA_M ||'.USU_USUARIOS USU ON USU.USU_ID = GEE.USU_ID
			 INNER JOIN '|| V_ESQUEMA ||'.DD_GRF_GESTORIA_RECEP_FICH GRF ON GRF.USERNAME_GIAADMT = USU.USU_USERNAME and GRF.DD_GRF_CODIGO = AUX.COD_GESTORIA
			 INNER JOIN '|| V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = AUX.SUBTIPO_GASTO AND STG.DD_STG_CODIGO in (''''03'''',''''04'''')
			 INNER JOIN '|| V_ESQUEMA ||'.GAC_GESTOR_ADD_ACTIVO GAC2 on GAC2.ACT_ID = ACT.ACT_ID
			 INNER JOIN '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD GEE2 ON GEE2.GEE_ID = GAC2.GEE_ID AND GEE.BORRADO = 0
			 INNER JOIN '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR TGE2 ON TGE2.DD_TGE_ID = GEE2.DD_TGE_ID AND TGE2.DD_TGE_CODIGO =''''GTOPLUS''''  ' )
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_MRG_MOTIVO_RECHAZO_GASTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_MRG_MOTIVO_RECHAZO_GASTO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_MRG_MOTIVO_RECHAZO_GASTO WHERE DD_MRG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_MRG_MOTIVO_RECHAZO_GASTO '||
                    'SET DD_MRG_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_MRG_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', PROCESO_VALIDAR = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', QUERY_ITER = '''||TRIM(V_TMP_TIPO_DATA(5))||''''||
					', USUARIOMODIFICAR = ''HREOS-5530'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_MRG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_MRG_MOTIVO_RECHAZO_GASTO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_MRG_MOTIVO_RECHAZO_GASTO (' ||
                      'DD_MRG_ID, DD_MRG_CODIGO, DD_MRG_DESCRIPCION, DD_MRG_DESCRIPCION_LARGA, PROCESO_VALIDAR, QUERY_ITER, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', '''||TRIM(V_TMP_TIPO_DATA(4))||''', '''||TRIM(V_TMP_TIPO_DATA(5))||''', 0, ''HREOS-5530'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_MRG_MOTIVO_RECHAZO_GASTO ACTUALIZADO CORRECTAMENTE ');
   

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



   

--/*
--######################################### 
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20220914
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18722
--## PRODUCTO=NO
--## 
--## Finalidad: Añadimos motivos de rechazo a DD_MRG_MOTIVO_RECHAZO_GASTO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    T_TIPO_DATA('F62' ,'Tipo Operación Domiciliación puede enviarse si es CaixaBank y tipos Tasa y Suministro o subtipos IBI', '1', 'JOIN #ESQUEMA#.ACT_ACTIVO ACT  ON ACT.ACT_NUM_ACTIVO = AUX.COD_ACTIVO
JOIN #ESQUEMA#.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0 
WHERE (AUX.TIPO_OPERACION = ''''06'''' AND CRA.DD_CRA_CODIGO != ''''03'''') 
OR NOT EXISTS 
(SELECT 1 FROM #ESQUEMA#.APR_AUX_GES_GASTOS_GR AUX2
WHERE AUX2.COD_GASTO_GESTORIA = AUX.COD_GASTO_GESTORIA AND (AUX2.TIPO_GASTO IN (''''09'''', ''''02'''') OR (AUX2.TIPO_GASTO = ''''01'''' AND AUX2.SUBTIPO_GASTO IN (''''01'''',''''02''''))))')
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
					', DD_MRG_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
					', PROCESO_VALIDAR = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', QUERY_ITER = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', USUARIOMODIFICAR = ''HREOS-18722'' , FECHAMODIFICAR = SYSDATE '||
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
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(3))||''', '''||TRIM(V_TMP_TIPO_DATA(4))||''', 0, ''HREOS-18722'',SYSDATE,0 FROM DUAL';
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
          DBMS_OUTPUT.put_line(V_MSQL);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

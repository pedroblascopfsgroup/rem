--/*
--######################################### 
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20220113
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16831
--## PRODUCTO=NO
--## 
--## Finalidad: Modificamos motivos de rechazo a DD_MRG_MOTIVO_RECHAZO_GASTO
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
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3000);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    T_TIPO_DATA('F14' , 'WHERE AUX.COD_ACTIVO is null AND AUX.SUBTIPO_GASTO NOT IN (''''154'''',''''155'''',''''156'''')'),
    T_TIPO_DATA('F58' , 'WHERE AUX.COD_ACTIVO IS NOT NULL AND AUX.NIF_DESTINATARIO NOT IN (	SELECT PRO.PRO_DOCIDENTIF FROM REM01.ACT_ACTIVO ACT	JOIN REM01.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID=ACT.ACT_ID JOIN REM01.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID=PAC.PRO_ID	WHERE ACT.ACT_NUM_ACTIVO=AUX.COD_ACTIVO AND PRO.PRO_DOCIDENTIF=AUX.NIF_DESTINATARIO	AND ACT.BORRADO=0 AND PAC.BORRADO=0 AND PRO.BORRADO=0)' )
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
                    'SET QUERY_ITER = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
					', USUARIOMODIFICAR = ''HREOS-16831'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_MRG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
        
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

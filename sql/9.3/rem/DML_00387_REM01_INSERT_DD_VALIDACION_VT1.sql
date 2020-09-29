--/*
--##########################################
--## AUTOR=Dean Ibañez Viño
--## FECHA_CREACION=20200916
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11061
--## PRODUCTO=NO
--##
--## Finalidad: Insertar en la tabla DD_VALIDACION_VT1 
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
    V_TABLA VARCHAR2(30 CHAR) := 'DD_VALIDACION_VT1';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
 
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3200);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('ERR001','Campo CEXPER Nulo','A','SELECT NUM_INTERNO FROM AUX_APR_MAIN_VT1_BBVA WHERE OPERACION = ''''A'''' AND CEXPER_MORA IS NULL'),
      T_TIPO_DATA('ERR002','Campo IUC Nulo','A','SELECT NUM_INTERNO FROM AUX_APR_MAIN_VT1_BBVA WHERE OPERACION = ''''A'''' AND IUC IS NULL'),
      T_TIPO_DATA('ERR003','Campo Proindiviso debe estar entre 0 y 100','A','SELECT NUM_INTERNO FROM AUX_APR_MAIN_VT1_BBVA WHERE OPERACION = ''''A'''' AND PROINDIVISO NOT BETWEEN 0 AND 100'),
      T_TIPO_DATA('ERR004','No se envian activos de recompra ni con procedencia Leasing o Desafecto','A','SELECT NUM_INTERNO FROM AUX_APR_MAIN_VT1_BBVA AUX JOIN ACT_ACTIVO ACT ON AUX.NUM_INTERNO = ACT.ACT_NUM_ACTIVO JOIN DD_OAN_ORIGEN_ANTERIOR OAN ON ACT.DD_OAN_ID = OAN.DD_OAN_ID AND DD_OAN_CODIGO = ''''08'''' WHERE OPERACION = ''''A'''''),
      T_TIPO_DATA('ERR002','Campo Subtipo Nulo','A','SELECT NUM_INTERNO FROM AUX_APR_MAIN_VT1_BBVA AUX JOIN ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.NUM_INTERNO AND ACT.DD_SAC_ID IS NULL WHERE OPERACION = ''''A'''''),


      T_TIPO_DATA('ERR005','Campo NUMERO_ACTIVO_SAP Nulo','M','SELECT NUM_INTERNO FROM AUX_APR_MAIN_VT1_BBVA WHERE OPERACION = ''''M'''' AND NUMERO_ACTIVO_SAP IS NULL'),
      T_TIPO_DATA('ERR006','Campo SUBNUMERO_ACTIVO_SAP Nulo','M','SELECT NUM_INTERNO FROM AUX_APR_MAIN_VT1_BBVA WHERE OPERACION = ''''M'''' AND SUBNUMERO_ACTIVO_SAP IS NULL'),
      T_TIPO_DATA('ERR002','Campo Subtipo Nulo','M','SELECT NUM_INTERNO FROM AUX_APR_MAIN_VT1_BBVA AUX JOIN ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.NUM_INTERNO AND ACT.DD_SAC_ID IS NULL WHERE OPERACION = ''''M'''''),

      T_TIPO_DATA('ERR007','Campo NUMERO_ACTIVO_SAP Nulo','V','SELECT NUM_INTERNO FROM AUX_APR_MAIN_VT1_BBVA WHERE OPERACION = ''''V'''' AND NUMERO_ACTIVO_SAP IS NULL'),
      T_TIPO_DATA('ERR008','Campo SUBNUMERO_ACTIVO_SAP Nulo','V','SELECT NUM_INTERNO FROM AUX_APR_MAIN_VT1_BBVA WHERE OPERACION = ''''V'''' AND SUBNUMERO_ACTIVO_SAP IS NULL'),
      T_TIPO_DATA('ERR009','Importe total de la oferta no puede ser nulo ni 0','V','SELECT NUM_INTERNO FROM AUX_APR_MAIN_VT1_BBVA WHERE OPERACION = ''''V'''' AND PRECIO_VENTA IS NULL OR PRECIO_VENTA = 0'),
      T_TIPO_DATA('ERR010','La fecha de la venta de la oferta no puede ser nulo','V','SELECT NUM_INTERNO FROM AUX_APR_MAIN_VT1_BBVA WHERE OPERACION = ''''V'''' AND FECHA_VENTA IS NULL OR FECHA_VENTA = 0')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

            DBMS_OUTPUT.PUT_LINE('Codigo: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');

	    	--Comprobar codigo      
	          	V_SQL := 'SELECT COUNT(1)
					FROM '||V_ESQUEMA||'.'||V_TABLA||' 
					WHERE DD_VAL_VT1_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	          
				-- Insertar el nuevo codigo y matricula
				IF V_NUM_TABLAS = 0 THEN 	
		       	   V_MSQL := '
		                     INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
		                        DD_VAL_VT1_ID,
		                        DD_VAL_VT1_CODIGO,
		                        DD_VAL_VT1_DESCRIPCION,
		                        DD_VAL_VT1_OPERACION,
 								DD_VAL_VT1_QUERY	                       
		                    ) VALUES (
		                        '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL,
		                        '''||V_TMP_TIPO_DATA(1)||''',
		                        '''||V_TMP_TIPO_DATA(2)||''',
		                        '''||V_TMP_TIPO_DATA(3)||''',
								'''||V_TMP_TIPO_DATA(4)||'''	                        
		                      )';
		
		          EXECUTE IMMEDIATE V_MSQL;

		        
		    ELSE
                    --Actualizar matricula				
                    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||'
                                            SET DD_VAL_VT1_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                                            DD_VAL_VT1_OPERACION = '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                                            DD_VAL_VT1_QUERY = '''||TRIM(V_TMP_TIPO_DATA(4))||'''
                                        WHERE DD_VAL_VT1_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''';
                    EXECUTE IMMEDIATE V_MSQL;
			END IF;           
      
      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');


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

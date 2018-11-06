--/*
--###########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20181029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2220
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATEAR FECHAS EXPEDIENTE
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


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
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	-- NUM EXPEDIENTE A ACTUALIZAR , FECHA ALTA OFERTA 	, FECHA ACEPTACION 	, FECHA DE SANCION 	, FECHA VENTA 	, FECHA FIRMA RESERVA 	, FECHA INGRESO CHEQUE 	, USUARIO MODIFICAR 
    T_TIPO_DATA('133403'		   ,'NULL'	 			,'NULL'   			,'NULL'     		,'26/10/2018' 	,'NULL'      			,'NULL' 				,'REMVIP-2431'     )
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para actualizar los valores en ACT_PRO_PROPIETARIO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE FECHAS EXPEDIENTE');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a modificar
        V_SQL := 'SELECT COUNT(1) FROM REM01.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = '||TRIM(V_TMP_TIPO_DATA(1))||''; 
		
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos otra comprobacion
        IF V_NUM_TABLAS = 1 THEN		
				
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS DATOS DEL EXPEDIENTE '||TRIM(V_TMP_TIPO_DATA(1))||'');	
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET ';
            
			IF V_TMP_TIPO_DATA(2) != 'NULL' THEN
				V_SQL :=  'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS SET OFR_FECHA_ALTA = TO_DATE('''||TRIM(V_TMP_TIPO_DATA(2))||''',''DD/MM/YYYY''),
																	USUARIOMODIFICAR = '''||UPPER(TRIM(V_TMP_TIPO_DATA(8)))||''',
																	FECHAMODIFICAR = SYSDATE 
																	WHERE OFR_ID = (SELECT OFR.OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
																	INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON OFR.OFR_ID = ECO.OFR_ID 
																	WHERE ECO.ECO_NUM_EXPEDIENTE = '||TRIM(V_TMP_TIPO_DATA(1))||')';
				EXECUTE IMMEDIATE V_SQL;
				
			END IF;
			IF V_TMP_TIPO_DATA(3) != 'NULL' THEN
				V_MSQL := V_MSQL || ' ECO_FECHA_ALTA = TO_DATE('''||TRIM(V_TMP_TIPO_DATA(3))||''',''DD/MM/YYYY''), ';
			END IF;
			IF V_TMP_TIPO_DATA(4) != 'NULL' THEN
				V_MSQL := V_MSQL || ' ECO_FECHA_SANCION = TO_DATE('''||TRIM(V_TMP_TIPO_DATA(4))||''',''DD/MM/YYYY'') ';
			END IF;
			IF V_TMP_TIPO_DATA(5) != 'NULL' THEN
				V_MSQL := V_MSQL || ' ECO_FECHA_VENTA = TO_DATE('''||TRIM(V_TMP_TIPO_DATA(5))||''',''DD/MM/YYYY''), ';
			END IF;
			IF V_TMP_TIPO_DATA(6) != 'NULL' THEN
				V_SQL := ' UPDATE '||V_ESQUEMA||'.RES_RESERVAS SET RES_FECHA_FIRMA = TO_DATE('''||TRIM(V_TMP_TIPO_DATA(6))||''',''DD/MM/YYYY''), 
																	USUARIOMODIFICAR = '''||UPPER(TRIM(V_TMP_TIPO_DATA(8)))||''',
																	FECHAMODIFICAR = SYSDATE 
																	WHERE RES_ID = (SELECT RES.RES_ID FROM '||V_ESQUEMA||'.RES_RESERVAS RES 
																	INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON RES.ECO_ID = ECO.ECO_ID 
																	WHERE ECO.ECO_NUM_EXPEDIENTE = )';
				EXECUTE IMMEDIATE V_SQL;
				
			END IF;
			IF V_TMP_TIPO_DATA(7) != 'NULL' THEN
				V_MSQL := V_MSQL || ' ECO_FECHA_CONT_PROPIETARIO = TO_DATE('''||TRIM(V_TMP_TIPO_DATA(7))||''',''DD/MM/YYYY''), ';
			END IF;
			V_MSQL := V_MSQL || ' USUARIOMODIFICAR = '''||UPPER(TRIM(V_TMP_TIPO_DATA(8)))||''','|| 
                                ' FECHAMODIFICAR = SYSDATE '||
							    ' WHERE ECO_NUM_EXPEDIENTE = '||TRIM(V_TMP_TIPO_DATA(1))||'';	
							 
			EXECUTE IMMEDIATE V_MSQL;
			
		--El activo no existe
		ELSE
			  DBMS_OUTPUT.PUT_LINE('[INFO]: EL EXPEDIENTE '''||TRIM(V_TMP_TIPO_DATA(1))||' NO HA SIDO ACTUALIZADO');
		END IF;
		
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ACUALIZACIÓN FECHAS EXPEDIENTE ');

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

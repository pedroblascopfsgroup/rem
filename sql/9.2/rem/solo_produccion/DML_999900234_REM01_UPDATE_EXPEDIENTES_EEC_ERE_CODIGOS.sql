--/*
--##########################################
--## AUTOR=Pau Serrano
--## FECHA_CREACION=20180124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3622
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica los codigos dd_eec y dd_ere de ciertos expedientes 
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
    V_NUM_REGISTRO NUMBER(16); -- Vble. para validar la existencia de un registro.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	V_ECO_NUM NUMBER(16);
    
	CURSOR ACTUALIZACION_ECO
	IS
		select distinct 
			eco.eco_id 
		from #ESQUEMA#.ECO_EXPEDIENTE_COMERCIAL eco
			join #ESQUEMA#.RES_RESERVAS res on res.eco_id=eco.eco_id
			join #ESQUEMA#.DD_ERE_ESTADOS_RESERVA ere on ere.dd_ere_id=res.dd_ere_id
			join #ESQUEMA#.DD_EEC_EST_EXP_COMERCIAL eec on eec.dd_eec_id=eco.dd_eec_id
		where 
			eec.dd_eec_codigo='06' and
			ere.dd_ere_codigo='02' and
			res.res_fecha_firma is null;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Se inicia el proceso de actualización de los expexdientes y resoluciones.');
	
	OPEN ACTUALIZACION_ECO;
	FETCH ACTUALIZACION_ECO into V_ECO_NUM;
	WHILE (ACTUALIZACION_ECO%FOUND) LOOP
	
		DBMS_OUTPUT.PUT_LINE('[INFO] *********************************************************************************');
		DBMS_OUTPUT.PUT_LINE('[INFO] ID del expediente a actualizar: '||V_ECO_NUM||'.');
		
		DBMS_OUTPUT.PUT_LINE('[INFO] **ECO_EXPEDIENTE_COMERCIAL**');
		
		--Comprobamos si existe el expediente en tabla destino
	    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_ID = '||V_ECO_NUM||' AND BORRADO = 0';
	    EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
		
		--Si existe lo actualizamos
		IF V_NUM_REGISTRO > 0 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO] Modicicamos el diccionario DD_EEC_EST_EXP_COMERCIAL del registro');
		
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL eco
					   SET
					   		eco.dd_eec_id = (select eec.dd_eec_id from '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL eec where eec.dd_eec_codigo = ''11'')
					   WHERE
					   		eco_id = '||V_ECO_NUM||'';

			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE el DD_EEC_ID de ECO_EXPEDIENTE_COMERCIAL');

			--Comprobamos si existe el expediente en tabla destino
	    	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.RES_RESERVAS WHERE ECO_ID = '||V_ECO_NUM||' AND BORRADO = 0';
	    	EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;

	    	--Si existe lo actualizamos
			IF V_NUM_REGISTRO > 0 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] Modicicamos el diccionario DD_ERE_ESTADOS_RESERVA del registro');
		
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS res
					   SET
					   		res.dd_ere_id = (select ere.dd_ere_id from '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ere where ere.dd_ere_codigo = ''01'')
					   WHERE
					   		res.eco_id = '||V_ECO_NUM||'';

				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE el DD_ERE_ID de RES_RESERVAS');
			--Si no existe, lo indicamos
			ELSE		
				DBMS_OUTPUT.PUT_LINE('[INFO]: No existe el registro '''||V_ECO_NUM||''' en la tabla '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL - No se puede actualizar');		
			END IF;

		--Si no existe, lo indicamos
		ELSE		
			DBMS_OUTPUT.PUT_LINE('[INFO]: No existe el registro '''||V_ECO_NUM||''' en la tabla '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL - No se puede actualizar');		
		END IF;
	
	FETCH ACTUALIZACION_ECO into V_ECO_NUM;
	
	END LOOP;	
	
	CLOSE ACTUALIZACION_ECO;
	

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]:  El proceso de actualización de los EXPEDIENTES a finalizado correctamente.');
   

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



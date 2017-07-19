--/*
--##########################################
--## AUTOR=Carlos Pons
--## FECHA_CREACION=20170819
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2379
--## PRODUCTO=NO
--##
--## Finalidad: Script que inserta en el campo DD_SDE_VINCULABLE de la tabla DD_SDE_SUBTIPO_DOC_EXP
--## 			- Un 1 si el valor de DD_SDE_CODIGO ESTÁ EN V_CODIGOS_SDE_VINCULABLES
--##			- Un 0 si el valor de DD_SDE_CODIGO NO ESTÁ EN V_CODIGOS_SDE_VINCULABLES			
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
       
	/**
		06 - Contrato reserva
		12 - Justificante ingreso reserva
		17 - Justificante ingreso precio compraventa
		20 - Liquidación plusvalía
		16 - Copia simple escritura de venta
		09 - Contrato alquiler 

    24 - Contrato ampliación arras
    27 - Copia simple escritura de venta
    19 - Catastro: alteración catastral
    28 - Subsanación de escritura de venta
    35 - Retrocesión de la venta
	 */ 
	
    V_CODIGOS_SDE_VINCULABLES VARCHAR2(2400 CHAR) := '''06'',''12'',''17'',''20'',''16'',''09'',''24'',''27'',''19'',''28'',''35''';
    
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
          
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS LOS REGISTROS QUE SON VINCULABLES');
    V_MSQL := 	'UPDATE '|| V_ESQUEMA ||'.DD_SDE_SUBTIPO_DOC_EXP '||
              	'SET DD_SDE_VINCULABLE = 1 ' ||   
				'WHERE DD_SDE_CODIGO IN ('||V_CODIGOS_SDE_VINCULABLES||')';
   	EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS VINCULABLES MODIFICADOS CORRECTAMENTE');
          
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS LOS REGISTROS QUE NO SON VINCULABLES');
    V_MSQL := 	'UPDATE '|| V_ESQUEMA ||'.DD_SDE_SUBTIPO_DOC_EXP '||
              	'SET DD_SDE_VINCULABLE = 0 ' ||   
				'WHERE DD_SDE_CODIGO NOT IN ('||V_CODIGOS_SDE_VINCULABLES||')';
   	EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS NO VINCULABLES MODIFICADOS CORRECTAMENTE');
          
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_SDE_SUBTIPO_DOC_EXP ACTUALIZADO CORRECTAMENTE ');
   

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
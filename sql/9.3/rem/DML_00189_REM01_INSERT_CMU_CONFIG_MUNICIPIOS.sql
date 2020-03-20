--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20200311
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6636
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en CMU_CONFIG_MUNICIPIOS todos los municipios de Cataluña
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
    V_USUARIOCREAR VARCHAR(100 CHAR):= 'REMVIP-6636';
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_ID NUMBER(16);
    V_NUM_REGISTROS NUMBER(16) := 0; -- Vble. para validar la existencia de una tabla. 
       
    CURSOR CPOS IS 
	SELECT LOC.DD_LOC_ID
	FROM #ESQUEMA_MASTER#.DD_CCA_COMUNIDAD CCA
	INNER JOIN #ESQUEMA_MASTER#.DD_PRV_PROVINCIA PRV ON PRV.DD_CCA_ID = CCA.DD_CCA_ID
	INNER JOIN #ESQUEMA_MASTER#.DD_LOC_LOCALIDAD LOC ON LOC.DD_PRV_ID = PRV.DD_PRV_ID
	LEFT JOIN #ESQUEMA#.CMU_CONFIG_MUNICIPIOS CMU ON CMU.DD_LOC_ID = LOC.DD_LOC_ID
	WHERE CCA.DD_CCA_CODIGO = '09' AND CMU.CMU_ID IS NULL;

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en CMU_CONFIG_MUNICIPIOS -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CMU_CONFIG_MUNICIPIOS ');
    FOR NCP IN CPOS LOOP
          
		--Comprobamos el dato a insertar
		V_SQL := 'SELECT COUNT(*)
					FROM '|| V_ESQUEMA ||'.CMU_CONFIG_MUNICIPIOS CMU
					WHERE CMU.DD_LOC_ID = ' || NCP.DD_LOC_ID;
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		       
		--Si existe lo insertamos en la tabla CMU
		IF V_NUM_TABLAS = 0 THEN
	        	
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL MUNICIPIO CON DD_LOC_ID '|| NCP.DD_LOC_ID);
			V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_CMU_CONFIG_MUNICIPIOS.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
			V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CMU_CONFIG_MUNICIPIOS 
						(CMU_ID, DD_LOC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
						SELECT '|| V_ID ||', '|| NCP.DD_LOC_ID ||', 0, '''|| V_USUARIOCREAR ||''', SYSDATE, 0 FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL;
			V_NUM_REGISTROS := V_NUM_REGISTROS + 1;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
			
		END IF;
          
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADAS '|| V_NUM_REGISTROS ||' FILAS');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA CMU_CONFIG_MUNICIPIOS ACTUALIZADO CORRECTAMENTE ');
   

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



   

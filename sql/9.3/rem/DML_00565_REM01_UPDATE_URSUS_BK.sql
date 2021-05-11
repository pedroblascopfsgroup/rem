--/*
--##########################################
--## AUTOR=Sento Visiedo Rubio
--## FECHA_CREACION=20210505
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.2.0
--## INCIDENCIA_LINK=HREOS-13135
--## PRODUCTO=NO
--## Finalidad: actualizar datos a null de URSUS
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Se añade nuevo error
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
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'COM_COMPRADOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_SEC VARCHAR2(2400 CHAR) := 'CEX_COMPRADOR_EXPEDIENTE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-13135';
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATEAMOS VALORES EN '||V_TEXT_TABLA);
			
          -- Si existe se modifica.
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO');

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' COMPRA 
                    SET ID_COMPRADOR_URSUS =  NULL 
                    , PROBLEMAS_URSUS = NULL 
					, NOMBRE_CONYUGE_URSUS = NULL 
                    , DD_ECV_ID_URSUS = NULL 
                    , DD_REM_ID_URSUS = NULL 
                    , N_URSUS_CONYUGE = NULL 
					, USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE 
					
                    WHERE EXISTS (SELECT com_id FROM '|| V_ESQUEMA ||'.CEX_COMPRADOR_EXPEDIENTE CEX WHERE COMPRA.COM_ID = CEX.COM_ID AND exists 
                    (SELECT ECO.ECO_ID FROM '|| V_ESQUEMA ||'.eco_expediente_comercial ECO
                    JOIN '|| V_ESQUEMA ||'.dd_eec_est_exp_comercial EXPCOM ON EXPCOM.DD_EEC_ID = ECO.DD_EEC_ID AND EXPCOM.DD_EEC_CODIGO IN (''01'',''27'',''04'',''34'',''14'',''43'')
                    WHERE cex.eco_id = eco.eco_id)) AND COMPRA.id_comprador_ursus_bh IS NULL';
        DBMS_OUTPUT.put_line(V_MSQL);

          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
                    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO ');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA_SEC||' CEX 
                    SET CEX_CLI_URSUS_CONYUGE_REM = NULL 
					, CEX_NUM_URSUS_CONYUGE_REM = NULL 
					, USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE 
				    WHERE exists 
                        (SELECT ECO.ECO_ID FROM '|| V_ESQUEMA ||'.eco_expediente_comercial ECO
                        JOIN '|| V_ESQUEMA ||'.dd_eec_est_exp_comercial EXPCOM ON EXPCOM.DD_EEC_ID = ECO.DD_EEC_ID AND EXPCOM.DD_EEC_CODIGO IN (''01'',''27'',''04'',''34'',''14'',''43'')
                        WHERE cex.eco_id = eco.eco_id)
                        AND  NOT EXISTS (
                        SELECT COMPRADOR.COM_ID FROM '|| V_ESQUEMA ||'.COM_COMPRADOR COMPRADOR WHERE cex.com_id=COMPRADOR.COM_ID AND comprador.id_comprador_ursus_bh IS NULL)';
DBMS_OUTPUT.put_line(V_MSQL);

          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');


      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
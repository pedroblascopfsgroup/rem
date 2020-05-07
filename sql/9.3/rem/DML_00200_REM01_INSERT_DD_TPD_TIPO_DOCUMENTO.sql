--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200505
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6830
--## PRODUCTO=NO
--##
--## Finalidad:
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7075';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_MATRICULA_GD = ''AI-10-CERT-30''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	-- Si existe el registro
	IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('	[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO...no se modifica nada.');
		
	ELSE
		V_MSQL := 'INSERT INTO REM01.DD_TPD_TIPO_DOCUMENTO (
					    DD_TPD_ID, DD_TPD_CODIGO, DD_TPD_DESCRIPCION, DD_TPD_DESCRIPCION_LARGA
					    , VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPD_MATRICULA_GD, DD_TPD_VISIBLE
					) SELECT REM01.S_DD_TDP_TIPO_DOC_PROVEEDOR.NEXTVAL, ''160''
					    ,''Eficiencia energética:No Calificable CEE'', ''Eficiencia energética:No Calificable CEE''
					    ,0, ''REMVIP-6830'', SYSDATE, 0, ''AI-10-CERT-30'', 1
					  FROM DUAL';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO insertados correctamente.');
		
    END IF;
	
	COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');   

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
EXIT;
--/*
--##########################################
--## AUTOR=Carlos Górriz
--## FECHA_CREACION=20190503
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6320
--## PRODUCTO=NO
--##
--## Finalidad: Insertar relación documento CEE con tipo activo Edificio completo en la ACT_CFD_CONFIG_DOCUMENTO
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
    V_NUM_EXISTE NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** ACT_CFD_CONFIG_DOCUMENTO ********'); 
    	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO... Insertando relaciones para el documento CEE en la ACT_CFD_CONFIG_DOCUMENTO'); 

		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO (CFD_ID, DD_TPA_ID, DD_TPD_ID, CFD_OBLIGATORIO, CFD_APLICA_F_CADUCIDAD, CFD_APLICA_F_ETIQUETA, CFD_APLICA_CALIFICACION, VERSION, USUARIOCREAR, FECHACREAR) 
				SELECT '||V_ESQUEMA||'.S_ACT_CFD_CONFIG_DOCUMENTO.NEXTVAL, TPA.DD_TPA_ID, TPD.DD_TPD_ID, 0, 0, 0, 0, 0, ''HREOS-6320'',SYSDATE FROM DD_TPA_TIPO_ACTIVO TPA
				JOIN DD_TPD_TIPO_DOCUMENTO TPD ON TPD.DD_TPD_CODIGO = ''92'' 
				WHERE NOT EXISTS (
   				SELECT 1
   				FROM ACT_CFD_CONFIG_DOCUMENTO CFD
   				WHERE CFD.DD_TPA_ID = TPA.DD_TPA_ID
       				AND CFD.DD_TPD_ID = TPD.DD_TPD_ID
   			)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' registro/s insertado/s.');
    COMMIT;
	
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

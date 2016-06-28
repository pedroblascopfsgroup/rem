--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20160623
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-2120
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
BEGIN
	DBMS_OUTPUT.PUT_LINE('******** ACU_CAMPOS_TIPO_ACUERDO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE CMP_NOMBRE_CAMPO = ''fechaSolucionPrevista'' AND CMP_OBLIGATORIO = 0';
    DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET CMP_OBLIGATORIO= 1 WHERE CMP_NOMBRE_CAMPO = ''fechaSolucionPrevista'' AND CMP_OBLIGATORIO = 0 ';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizados en '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO');
	ELSE	
		DBMS_OUTPUT.PUT_LINE('[INFO] Todas las fechaSolucionPrevista existentes están como obligatorias');

	END IF;
	
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE CMP_NOMBRE_CAMPO = ''fechaSolucionPrevista'' AND CMP_LABEL= ''fechaSolucionPrevista''';
    DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET CMP_LABEL= ''Fecha Sol. Prevista'' WHERE CMP_NOMBRE_CAMPO = ''fechaSolucionPrevista'' AND CMP_LABEL= ''fechaSolucionPrevista'' ';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizados en '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO');
	ELSE	
		DBMS_OUTPUT.PUT_LINE('[INFO] Todas las etiquetas están correctas');

	END IF;
	
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

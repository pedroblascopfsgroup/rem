--/*
--##########################################
--## AUTOR=Ruben rovira
--## FECHA_CREACION=20160523
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HR-2534
--## PRODUCTO=NO
--## Finalidad: DML arregla diccionario origen cobro
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema este caso haya01
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master este caso hayamaster
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    v_plaza VARCHAR2(25 CHAR);
BEGIN
 
  V_SQL := 'update '||V_ESQUEMA||'.DD_OC_ORIGEN_COBRO set dd_oc_descripcion=''SIN VALORES'', DD_OC_DESCRIPCION_LARGA=''SIN VALORES'' WHERE DD_OC_CODIGO=''0''';
  EXECUTE IMMEDIATE V_SQL;
    
 
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] ARREGLADA DESCRIPCION ORIGEN COBRO'); 

  EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR PROCEDIMIENTO]');
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('[FIN PROCEDIMIENTO]'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
    
END;
/
EXIT;

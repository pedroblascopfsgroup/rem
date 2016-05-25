--/*
--##########################################
--## AUTOR=CARLOS LOPEZ
--## FECHA_CREACION=20160523
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=CMREC-3327
--## PRODUCTO=NO
--## Finalidad: DML UPDATE ALERTAS MIGRADAS
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

BEGIN
  DBMS_OUTPUT.PUT_LINE('[INICIO CMREC-3327] '); 

  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_MNC_MTO_CORRECTIVO WHERE DD_MNC_CODIGO = ''PREVIOVAL'' ';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
  IF V_NUM_TABLAS > 0 THEN    
    DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA_M||'.DD_MNC_MTO_CORRECTIVO');
  ELSE    
    V_MSQL := '
	insert into '||V_ESQUEMA_M||'.DD_MNC_MTO_CORRECTIVO(DD_MNC_CODIGO,DD_MNC_DESCRIPCION)
	values(''PREVIOVAL'',''Cadena principal, antes del proceso APR_VALIDACION_PC'')';

    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
    V_MSQL := '
	insert into '||V_ESQUEMA_M||'.DD_MNC_MTO_CORRECTIVO(DD_MNC_CODIGO,DD_MNC_DESCRIPCION)
	values(''PREVIOREV'',''Cadena principal, antes del proceso APR_REVISION'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
 
    V_MSQL := '
	insert into '||V_ESQUEMA_M||'.DD_MNC_MTO_CORRECTIVO(DD_MNC_CODIGO,DD_MNC_DESCRIPCION)
	values(''POSALTAASU'',''Cadena sincronización, tras APR_ALTA_ASUNTOS_CM y APR_FI_EXPEDIENTES_CM, y antes del envío de los litigios a Haya.'')';

    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;  
  END IF;


  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN CMREC-3327] '); 

  EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR PROCEDIMIENTO]-----------CMREC-3327-----------');
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('[FIN PROCEDIMIENTO]-------------CMREC-3327-----------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
    
END;
/
EXIT;

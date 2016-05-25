--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20160229
--## ARTEFACTO=BATCH
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-2264
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
	DBMS_OUTPUT.PUT_LINE('******** DD_TVE_TIPO_VENCIDO ********'); 
    
    
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TVE_TIPO_VENCIDO SET DD_TVE_DESCRIPCION=''Dudosos'', DD_TVE_DESCRIPCION_LARGA=''Dudosos: Operaciones que ya esten en dudoso. Aqui puede darse el caso que una operacion este eb dudoso y ademas al no ser morosa, pueda estar tambien otro de los tramos anteriores.'', USUARIOMODIFICAR=''DD'', FECHAMODIFICAR= SYSDATE  WHERE DD_TVE_CODIGO=''DUD''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro DUD insertado en '||V_ESQUEMA||'.DD_TVE_TIPO_VENCIDO');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TVE_TIPO_VENCIDO SET DD_TVE_DESCRIPCION=''Vencidos'', DD_TVE_DESCRIPCION_LARGA=''Vencidos: Operaciones que van entrando en impago en el mes en curso.'', USUARIOMODIFICAR=''DD'', FECHAMODIFICAR= SYSDATE  WHERE DD_TVE_CODIGO=''VEN''';
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro VEN insertado en '||V_ESQUEMA||'.DD_TVE_TIPO_VENCIDO');
		
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TVE_TIPO_VENCIDO SET DD_TVE_DESCRIPCION=''Deterioro Circulante'', DD_TVE_DESCRIPCION_LARGA=''Deterioro Circulante'', USUARIOMODIFICAR=''DD'', FECHAMODIFICAR= SYSDATE  WHERE DD_TVE_CODIGO=''DETCI''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro DETCI insertado en '||V_ESQUEMA||'.DD_TVE_TIPO_VENCIDO');
		
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TVE_TIPO_VENCIDO SET DD_TVE_DESCRIPCION=''Previo PreProyectado'', DD_TVE_DESCRIPCION_LARGA=''Previo pre-proyectado: Operaciones que entraN en dudoso en el mes en curso + 2.'', USUARIOMODIFICAR=''DD'', FECHAMODIFICAR= SYSDATE  WHERE DD_TVE_CODIGO=''PREVI''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro PREVI insertado en '||V_ESQUEMA||'.DD_TVE_TIPO_VENCIDO');
		
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TVE_TIPO_VENCIDO SET DD_TVE_DESCRIPCION=''Proyectado'', DD_TVE_DESCRIPCION_LARGA=''Proyectado: Operaciones que entran en dudoso en el mes en curso.'', USUARIOMODIFICAR=''DD'', FECHAMODIFICAR= SYSDATE  WHERE DD_TVE_CODIGO=''PRO''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro PRO insertado en '||V_ESQUEMA||'.DD_TVE_TIPO_VENCIDO');
		
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TVE_TIPO_VENCIDO SET DD_TVE_DESCRIPCION=''Seguimiento Especial'', DD_TVE_DESCRIPCION_LARGA=''Seguimiento Especial'', USUARIOMODIFICAR=''DD'', FECHAMODIFICAR= SYSDATE  WHERE DD_TVE_CODIGO=''SEGES''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro SEGES insertado en '||V_ESQUEMA||'.DD_TVE_TIPO_VENCIDO');
		
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TVE_TIPO_VENCIDO SET DD_TVE_DESCRIPCION=''Preproyectado'', DD_TVE_DESCRIPCION_LARGA=''Pre-proyectado: Operaciones que entran en dudoso en el mes en curso + 1'', USUARIOMODIFICAR=''DD'', FECHAMODIFICAR= SYSDATE  WHERE DD_TVE_CODIGO=''PRE''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro PRE insertado en '||V_ESQUEMA||'.DD_TVE_TIPO_VENCIDO');

	
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

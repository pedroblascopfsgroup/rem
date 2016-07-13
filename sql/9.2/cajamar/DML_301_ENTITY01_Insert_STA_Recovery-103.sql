--/*
--##########################################
--## AUTOR=Óscar Dorado
--## FECHA_CREACION=20160701
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-103
--## PRODUCTO=NO
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN


  DBMS_OUTPUT.PUT_LINE('[INICIO]');

  V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''DGEANREC''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
    DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
  ELSE
    DBMS_OUTPUT.put_line('[INFO] Insertando nuevo valor');

    V_SQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE
    		(DD_STA_ID,DD_TAR_ID,DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR,BORRADO,DD_TGE_ID)
    	VALUES
    		('||V_ESQUEMA_M||'.S_DD_STA_SUBTIPO_TAREA_BASE.nextval,(select tar.DD_TAR_ID from '||V_ESQUEMA_M||'.DD_TAR_TIPO_TAREA_BASE tar where tar.DD_TAR_CODIGO = ''1''),''DGEANREC'',''Toma decisión Gestor análisis de recuperaciones'',''Toma de decisión del Gestor análisis de recuperaciones'',null,''RECOVERY-103'',sysdate,0,(select tge.dd_tge_id from '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR tge where tge.DD_TGE_CODIGO =''GEANREC''))';
    EXECUTE IMMEDIATE V_SQL;
  END IF;
  
  
  V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''DSUCHRE''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
    DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
  ELSE
    DBMS_OUTPUT.put_line('[INFO] Insertando nuevo valor');

    V_SQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE
    		(DD_STA_ID,DD_TAR_ID,DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR,BORRADO,DD_TGE_ID)
    	VALUES
    		('||V_ESQUEMA_M||'.S_DD_STA_SUBTIPO_TAREA_BASE.nextval,(select tar.DD_TAR_ID from '||V_ESQUEMA_M||'.DD_TAR_TIPO_TAREA_BASE tar where tar.DD_TAR_CODIGO = ''1''),''DSUCHRE'',''Toma decisión Supervisor control gestión HRE'',''Toma de decisión del Supervisor control gestión HRE'',null,''RECOVERY-103'',sysdate,0,(select tge.dd_tge_id from '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR tge where tge.DD_TGE_CODIGO =''SUCHRE''))';
    EXECUTE IMMEDIATE V_SQL;
  END IF;
  
 
  V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''DSUCHRE''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
    DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
  ELSE
    DBMS_OUTPUT.put_line('[INFO] Insertando nuevo valor');

    V_SQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE
    		(DD_STA_ID,DD_TAR_ID,DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR,BORRADO,DD_TGE_ID)
    	VALUES
    		('||V_ESQUEMA_M||'.S_DD_STA_SUBTIPO_TAREA_BASE.nextval,(select tar.DD_TAR_ID from '||V_ESQUEMA_M||'.DD_TAR_TIPO_TAREA_BASE tar where tar.DD_TAR_CODIGO = ''1''),''DSUCHRE'',''Toma decisión Supervisor control gestión HRE'',''Toma de decisión del Supervisor control gestión HRE'',null,''RECOVERY-103'',sysdate,0,(select tge.dd_tge_id from '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR tge where tge.DD_TGE_CODIGO =''SUCHRE''))';
    EXECUTE IMMEDIATE V_SQL;
  END IF;
  
  
  V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''DSUINC''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
    DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
  ELSE
    DBMS_OUTPUT.put_line('[INFO] Insertando nuevo valor');

    V_SQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE
    		(DD_STA_ID,DD_TAR_ID,DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,DD_STA_GESTOR,USUARIOCREAR,FECHACREAR,BORRADO,DD_TGE_ID)
    	VALUES
    		('||V_ESQUEMA_M||'.S_DD_STA_SUBTIPO_TAREA_BASE.nextval,(select tar.DD_TAR_ID from '||V_ESQUEMA_M||'.DD_TAR_TIPO_TAREA_BASE tar where tar.DD_TAR_CODIGO = ''1''),''DSUINC'',''Toma decisión Supervisor de incumplimiento'',''Toma de decisión del Supervisor de incumplimiento'',null,''RECOVERY-103'',sysdate,0,(select tge.dd_tge_id from '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR tge where tge.DD_TGE_CODIGO =''SUINC''))';
    EXECUTE IMMEDIATE V_SQL;
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

EXIT


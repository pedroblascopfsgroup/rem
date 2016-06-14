--/*
--##########################################
--## AUTOR=CARLOS LÓPEZ VIDAL
--## FECHA_CREACION=20160613
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK= PRODUCTO-1971
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar a la fecha de la implantación la Fecha de Avaluo de los Asuntos que la tiene a null.
--##                   
--##       
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    USUARIO VARCHAR(50) := 'PRODUCTO-1971';

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION FECHAS 01/01/0001');

    v_sql := '
	UPDATE '||v_esquema||'.BIE_VALORACIONES DAT 
	   SET DAT.BIE_FECHA_VALOR_SUBJETIVO = NULL
	     , DAT.USUARIOMODIFICAR = ''PRODUCTO-1851''
	     , DAT.FECHAMODIFICAR = SYSDATE  
	 WHERE TRUNC(DAT.BIE_FECHA_VALOR_SUBJETIVO) = to_date(''01/01/0001'',''DD/MM/RRRR'') ';
    execute immediate v_sql;

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.BIE_VALORACIONES, CAMPO BIE_FECHA_VALOR_SUBJETIVO ACTUALIZADO. '||SQL%ROWCOUNT||' Filas');

    v_sql := '  
	UPDATE '||v_esquema||'.BIE_VALORACIONES DAT 
	   SET DAT.BIE_FECHA_VALOR_APRECIACION = NULL
	     , DAT.USUARIOMODIFICAR = ''PRODUCTO-1851''
	     , DAT.FECHAMODIFICAR = SYSDATE   
	 WHERE TRUNC(DAT.BIE_FECHA_VALOR_APRECIACION) = to_date(''01/01/0001'',''DD/MM/RRRR'') ';
    execute immediate v_sql;

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.BIE_VALORACIONES, CAMPO BIE_FECHA_VALOR_TASACION ACTUALIZADO. '||SQL%ROWCOUNT||' Filas');

    v_sql := '  
	UPDATE '||v_esquema||'.BIE_VALORACIONES DAT 
	   SET DAT.BIE_FECHA_VALOR_TASACION = NULL
	     , DAT.USUARIOMODIFICAR = ''PRODUCTO-1851''
	     , DAT.FECHAMODIFICAR = SYSDATE 
	 WHERE TRUNC(DAT.BIE_FECHA_VALOR_TASACION) = to_date(''01/01/0001'',''DD/MM/RRRR'') ';
    execute immediate v_sql;

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.BIE_VALORACIONES, CAMPO BIE_FECHA_VALOR_SUBJETIVO ACTUALIZADO. '||SQL%ROWCOUNT||' Filas');

    v_sql := '  
	UPDATE '||v_esquema||'.BIE_DATOS_REGISTRALES DAT 
	   SET DAT.BIE_DREG_FECHA_INSCRIPCION = NULL
	     , DAT.USUARIOMODIFICAR = ''PRODUCTO-1851''
	     , DAT.FECHAMODIFICAR = SYSDATE 
	 WHERE TRUNC(DAT.BIE_DREG_FECHA_INSCRIPCION) = to_date(''01/01/0001'',''DD/MM/RRRR'') ';
    execute immediate v_sql;

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.BIE_DATOS_REGISTRALES, CAMPO BIE_DREG_FECHA_INSCRIPCION ACTUALIZADO. '||SQL%ROWCOUNT||' Filas');
    
Commit;


DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZACION FECHAS 01/01/0001');

EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------');
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;

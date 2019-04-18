--/*
--##########################################
--## AUTOR=sERGIO bELENGUER gADEA
--## FECHA_CREACION=20190416
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.8
--## INCIDENCIA_LINK=hreos-6080
--## PRODUCTO=NO
--## 
--## Finalidad: Borrar gestores asignados por SP
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN

	DBMS_OUTPUT.put_line('[INFO] EMPIEZA GNS'|| TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'));
	
	DBMS_OUTPUT.put_line('[INFO] PASO ESTADÍSTICAS');
	
    V_MSQL :=  'BEGIN #ESQUEMA#.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GAC_GESTOR_ADD_ACTIVO''); END;';
    execute immediate V_MSQL;
    V_MSQL :=  'BEGIN #ESQUEMA#.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GEE_GESTOR_ENTIDAD''); END;';
    execute immediate V_MSQL;
    V_MSQL :=  'BEGIN #ESQUEMA#.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GAH_GESTOR_ACTIVO_HISTORICO''); END;';
    execute immediate V_MSQL;
    V_MSQL :=  'BEGIN #ESQUEMA#.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GEH_GESTOR_ENTIDAD_HIST''); END;';
    execute immediate V_MSQL;
    
	DBMS_OUTPUT.put_line('[INFO] FIN ESTADÍSTICAS');
	
    -------------------------------------------------------
    --  DIR_DIRECCIONES, DIR_PER, IAC_EXTRA_DIRECCIONES  --
    -------------------------------------------------------
    
		
	-- Borramos los gestores en GAC_GESTOR_ADD_ACTIVO
	loop
		delete from REM01.GAC_GESTOR_ADD_ACTIVO t1
		where exists (select 1 from GAC_GESTOR_ADD_ACTIVO gac
			join GEE_GESTOR_ENTIDAD gee on gee.gee_id=gac.gee_id
			join REMMASTER.DD_TGE_TIPO_GESTOR tge on tge.dd_tge_id=gee.dd_tge_id
			where gee.USUARIOCREAR='SP_AGA_V4' and t1.gee_id=gee.gee_id)
		and rownum <=5000;
		
		V_NUM_TABLAS := sql%rowcount;
		
		COMMIT;	
		
		DBMS_OUTPUT.put_line('[INFO] '|| TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS') ||' Direcciones borradas en GAC_GESTOR_ADD_ACTIVO: '|| V_NUM_TABLAS);
		
	exit when V_NUM_TABLAS = 0;
    end loop;
	-- Borramos los gestores en GEE_GESTOR_ENTIDAD
	loop
		delete from REM01.GEE_GESTOR_ENTIDAD t1
		where exists (select 1 from GEE_GESTOR_ENTIDAD gee
			join REMMASTER.DD_TGE_TIPO_GESTOR tge on tge.dd_tge_id=gee.dd_tge_id
			where gee.USUARIOCREAR='SP_AGA_V4' and t1.gee_id=gee.gee_id)
		and rownum <=5000;
		
		V_NUM_TABLAS := sql%rowcount;
		
		COMMIT;	
		
		DBMS_OUTPUT.put_line('[INFO] '|| TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS') ||' Direcciones borradas en GEE_GESTOR_ENTIDAD: '|| V_NUM_TABLAS);
		
	exit when V_NUM_TABLAS = 0;
    end loop;
	-- Borramos los gestores en GAH_GESTOR_ACTIVO_HISTORICO
	loop
		delete from REM01.GAH_GESTOR_ACTIVO_HISTORICO t1
		where exists (select 1 from GAH_GESTOR_ACTIVO_HISTORICO gac
			join GEH_GESTOR_ENTIDAD_HIST gee on gee.geh_id=gac.geh_id
			join REMMASTER.DD_TGE_TIPO_GESTOR tge on tge.dd_tge_id=gee.dd_tge_id
			where gee.USUARIOCREAR='SP_AGA_V4' and t1.geh_id=gee.geh_id)
		and rownum <=5000;
		
		V_NUM_TABLAS := sql%rowcount;
		
		COMMIT;	
		
		DBMS_OUTPUT.put_line('[INFO] '|| TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS') ||' Direcciones borradas en GAH_GESTOR_ACTIVO_HISTORICO: '|| V_NUM_TABLAS);
		
	exit when V_NUM_TABLAS = 0;
    end loop;
	-- Borramos los gestores en GEH_GESTOR_ENTIDAD_HIST
	loop
		delete from REM01.GEH_GESTOR_ENTIDAD_HIST t1
		where exists (select 1 from GEH_GESTOR_ENTIDAD_HIST gee
			join REMMASTER.DD_TGE_TIPO_GESTOR tge on tge.dd_tge_id=gee.dd_tge_id
			where gee.USUARIOCREAR='SP_AGA_V4' and t1.geh_id=gee.geh_id)
		and rownum <=5000;
		
		V_NUM_TABLAS := sql%rowcount;
		
		COMMIT;	
		
		DBMS_OUTPUT.put_line('[INFO] '|| TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS') ||' Direcciones borradas en GEH_GESTOR_ENTIDAD_HIST: '|| V_NUM_TABLAS);
		
	exit when V_NUM_TABLAS = 0;
    end loop;
    
    DBMS_OUTPUT.put_line('[INFO] FIN GNS'|| TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'));
    
	COMMIT;
	
	DBMS_OUTPUT.put_line('[INFO] PASO ESTADÍSTICAS');
	
    V_MSQL :=  'BEGIN #ESQUEMA#.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GAC_GESTOR_ADD_ACTIVO''); END;';
    execute immediate V_MSQL;
    V_MSQL :=  'BEGIN #ESQUEMA#.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GEE_GESTOR_ENTIDAD''); END;';
    execute immediate V_MSQL;
    V_MSQL :=  'BEGIN #ESQUEMA#.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GAH_GESTOR_ACTIVO_HISTORICO''); END;';
    execute immediate V_MSQL;
    V_MSQL :=  'BEGIN #ESQUEMA#.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''GEH_GESTOR_ENTIDAD_HIST''); END;';
    execute immediate V_MSQL;
    
	DBMS_OUTPUT.put_line('[INFO] FIN ESTADÍSTICAS');
	
	DBMS_OUTPUT.put_line('[INFO] '|| TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'));
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


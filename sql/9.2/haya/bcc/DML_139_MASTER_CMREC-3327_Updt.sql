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

  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.MNC_MTO_CORRECTIVO WHERE MNC_PROPIETARIO = '''||V_ESQUEMA||'''
                                                                        AND DD_MNC_CODIGO = ''PREVIOREV''
                                                                        AND MNC_ORDEN = 1 ';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
  IF V_NUM_TABLAS > 0 THEN    
    DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA_M||'.MNC_MTO_CORRECTIVO');
  ELSE    
    V_MSQL := '
	INSERT INTO '||V_ESQUEMA_M||'.MNC_MTO_CORRECTIVO(
	 MNC_PROPIETARIO
	,DD_MNC_CODIGO
	,MNC_ORDEN
	,MNC_QUERY
	,MNC_RESPONSABLE
	,MNC_FECHA_INICIO
	,MNC_FECHA_FIN
	,MNC_RAZON
	,BORRADO)
	VALUES('''||V_ESQUEMA||''',
	''PREVIOREV'',
	1,
	''update '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar 
            set tar.tar_alerta = 1, tar.usuariomodificar = ''''PFS'''', tar.fechamodificar = sysdate
	  where (tar.tar_tarea_finalizada is null or tar.tar_tarea_finalizada = 0) 
            and tar.borrado = 0 and (tar.tar_alerta is null or tar.tar_alerta = 0) 
            and (tar.asu_id is not null or tar.prc_id is not null)
	    and tar.tar_fecha_venc < trunc(sysdate)'',
	''Diego Rodríguez'',
	to_date(''18/04/2016'',''DD/MM/RRRR''),
	to_date(''01/01/2017'',''DD/MM/RRRR''),
	''CMREC-3327 Actualiza de manera diaria las tareas, activando el indicador de alerta cuando se sobrepase la fecha objetivo'',
	0
	)';
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

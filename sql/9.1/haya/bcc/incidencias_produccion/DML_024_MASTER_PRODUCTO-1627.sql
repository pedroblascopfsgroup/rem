--/*
--##########################################
--## AUTOR=CARLOS LOPEZ VIDAL
--## FECHA_CREACION=20160606
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-1627
--## PRODUCTO=NO
--## 
--## Finalidad: Corrige BPMs
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 20151126 GMN Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


BEGIN

  V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.MNC_MTO_CORRECTIVO WHERE MNC_PROPIETARIO = '''||V_ESQUEMA||'''
                                                                        AND DD_MNC_CODIGO = ''POSALTAASU''
                                                                        AND MNC_ORDEN = 1 ';
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
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
	''POSALTAASU'',
	1,
	''update '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO 
            set gah_gestor_id=21723,
                usuariomodificar = ''''PRODUCTO-1627'''',
                fechamodificar = sysdate
          where gah_gestor_id=21542 
           and usuariocrear = ''''SINCRO_CM_HAYA'''' '',
	''CARLOS LOPEZ'',
	to_date(''07/06/2016'',''DD/MM/RRRR''),
	to_date(''17/06/2016'',''DD/MM/RRRR''),
	''PRODUCTO-1627 Actualiza el gestor SUP de todos los asuntos'',
	0
	)';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;  

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
	''POSALTAASU'',
	2,
	''update '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO
            set gah_gestor_id=21723,
                usuariomodificar = ''''PRODUCTO-1627'''',
                fechamodificar = sysdate
          where gah_gestor_id=21542 
           and usuariocrear = ''''SINCRO_CM_HAYA'''' '',
	''CARLOS LOPEZ'',
	to_date(''07/06/2016'',''DD/MM/RRRR''),
	to_date(''17/06/2016'',''DD/MM/RRRR''),
	''PRODUCTO-1627 Actualiza el gestor SUP de todos los asuntos'',
	0
	)';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;  

  END IF; 
     
COMMIT;      

                             
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          RAISE;   
END;
/

EXIT;

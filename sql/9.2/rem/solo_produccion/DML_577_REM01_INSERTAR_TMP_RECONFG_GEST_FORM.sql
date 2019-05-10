--/*
--##########################################
--## AUTOR=IKER ADOT
--## FECHA_CREACION=20190509
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6274
--## PRODUCTO=NO
--##
--## Finalidad: Script para rellenar la tabla TMP_RECONFG_GEST_FORM con GIAFORM
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
    ERR_NUM NUMBER(25); -- Numero de errores
    ERR_MSG VARCHAR2(2048 CHAR); -- Mensaje de error   
    
    V_TABLA VARCHAR2(27 CHAR) := 'TMP_RECONFG_GEST_FORM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para realizar los cambios de gestores/gestorias en vuelo'; -- Vble. para los comentarios de las tablas
	
BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] ... Empezando a insertar datos en la tabla');
    
    --Comprobamos que la tabla existe
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla 
    IF V_NUM_TABLAS = 1 THEN
		--Borrado de la tabla
		--V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA||'';
		--EXECUTE IMMEDIATE V_MSQL;
		
		--Procedemos a insertar los datos a la tabla temporal
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (' ||
                  'ECO_ID, GEE_ID, USU_ID, TIPO_GESTOR, USU_ID_NUEVO) ' ||
                  'SELECT DISTINCT ECO.ECO_ID, GEE.GEE_ID, GEE.USU_ID, VGA.TIPO_GESTOR, USU.USU_ID
					FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
					JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GIAFORM'' AND TGE.BORRADO = 0
					JOIN '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO GCO ON GCO.GEE_ID = GEE.GEE_ID 
					JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = GCO.ECO_ID
					JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
					JOIN '||V_ESQUEMA||'.ACT_OFR AOFR ON AOFR.OFR_ID = OFR.OFR_ID
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO AACT ON AACT.ACT_ID = AOFR.ACT_ID
					JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = AACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''01''
					JOIN '||V_ESQUEMA||'.V_GESTORES_ACTIVO VGA ON VGA.ACT_ID = AACT.ACT_ID AND VGA.TIPO_GESTOR = ''GIAFORM'' AND VGA.DD_CRA_CODIGO = ''1''
					JOIN '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES GES ON GES.TIPO_GESTOR = VGA.TIPO_GESTOR AND GES.COD_CARTERA = VGA.DD_CRA_CODIGO AND GES.COD_PROVINCIA = VGA.DD_PRV_CODIGO
					JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = GES.USERNAME AND USU.BORRADO = 0
					WHERE GEE.BORRADO = 0';

        EXECUTE IMMEDIATE V_MSQL;        
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS CORRECTAMENTE');
        
        V_MSQL := 'DELETE 
				   FROM '||V_ESQUEMA||'.TMP_RECONFG_GEST_FORM TMP
				   WHERE (GEE_ID, USU_ID, TIPO_GESTOR, ECO_ID, USU_ID_NUEVO) IN 
                   (SELECT GEE_ID, USU_ID, TIPO_GESTOR, ECO_ID, USU_ID_NUEVO
                   FROM (
						SELECT GEE_ID, USU_ID, TIPO_GESTOR, ECO_ID, USU_ID_NUEVO, ROW_NUMBER () OVER (PARTITION BY GEE_ID, USU_ID, TIPO_GESTOR, ECO_ID
                                  ORDER BY USU_ID_NUEVO DESC) rn
						FROM '||V_ESQUEMA||'.TMP_RECONFG_GEST_FORM     
						) 
				   AUX WHERE AUX.RN>1)';
				   
		EXECUTE IMMEDIATE V_MSQL;        
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS DUPLICADOS ELIMINADOS CORRECTAMENTE');
        
        V_MSQL := 'DELETE 
				   FROM '||V_ESQUEMA||'.TMP_RECONFG_GEST_FORM TMP
				   WHERE NOT EXISTS (SELECT 1
									   FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL 		ECO 
									   JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO               TBJ ON TBJ.TBJ_ID = ECO.TBJ_ID
									   JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE	      		TRA ON TRA.TBJ_ID = TBJ.TBJ_ID
									   JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS	      	TAC ON TAC.TRA_ID = TRA.TRA_ID
									   JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES	  	TAR ON TAR.TAR_ID = TAC.TAR_ID AND TAR.TAR_FECHA_FIN IS NULL AND TAR.TAR_TAREA_FINALIZADA = 0
									   JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO		TPO ON TPO.DD_TPO_ID = TRA.DD_TPO_ID AND TPO.DD_TPO_CODIGO = ''T013''
									   WHERE TMP.ECO_ID = ECO.ECO_ID)';
				   
		EXECUTE IMMEDIATE V_MSQL;        
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS DUPLICADOS ELIMINADOS CORRECTAMENTE');
        
           
    ELSE
    
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.'||V_TABLA||' ... No existe.');
    
    END IF;
    			
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[INFO] Datos en la tabla '||V_ESQUEMA||'.'||V_TABLA||' insertados correctamente.');

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

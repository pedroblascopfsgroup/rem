--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20171110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3212
--## PRODUCTO=SI
--##
--## Finalidad: Insertar presupuesto perdido para Activo Num: 6044300
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_MSQL2 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_SQL2 VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PTO_PRESUPUESTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA2 VARCHAR2(2400 CHAR) := 'ACT_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA3 VARCHAR2(2400 CHAR) := 'ACT_EJE_EJERCICIO';
    V_USUARIOCREAR VARCHAR2(50 CHAR) := 'HREOS-3212';
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    V_NUM_ACTIVO NUMBER(16) := 6044300;
    V_ID_ACTIVO NUMBER(16);
    
BEGIN
	
		DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de actualización de la tabla '||V_TEXT_TABLA2);
		
		V_SQL := 'SELECT COUNT(ACT_ID) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA2||' WHERE ACT_NUM_ACTIVO = '||V_NUM_ACTIVO||' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS = 1 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO] insertando en  ACT_PTO_PRESUPUESTO');

		    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (pto_id,act_id,eje_id,pto_importe_inicial,pto_fecha_asignacion,version,usuariocrear,fechacrear,borrado) values
				(
					S_ACT_PTO_PRESUPUESTO.NEXTVAL
					,(SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA2||' WHERE ACT_NUM_ACTIVO = '||V_NUM_ACTIVO||' )
					,(SELECT EJE_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA3||' WHERE EJE_ANYO = ''2016'' )
					,50000
					,to_date(''04/10/16'',''dd/mm/yy'')
					,0
					,'''||V_USUARIOCREAR||'''
					,SYSDATE
					,0
				)';
		    EXECUTE IMMEDIATE V_MSQL;
		    DBMS_OUTPUT.PUT_LINE('[INFO] Se han INSERTADO '||sql%rowcount||' FILAS en '||V_ESQUEMA||'.'||V_TEXT_TABLA||'');
		   
		 ELSE
		 
			DBMS_OUTPUT.PUT_LINE('[INICIO] el ACT_NUM_ACTIVO '||V_NUM_ACTIVO||' no existe. No se hace nada');
		  
		END IF;

		DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de INSERCCION de la tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||' a finalizado correctamente');

		
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

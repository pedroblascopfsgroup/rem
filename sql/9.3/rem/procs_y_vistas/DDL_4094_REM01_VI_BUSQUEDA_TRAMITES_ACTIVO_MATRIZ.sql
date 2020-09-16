--/*
--##########################################
--## AUTOR=SERGIO SALT
--## FECHA_CREACION=20190619
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Procedimiento que asigna Gestores a Activos: GESTOR DE ACTIVO (POR ACTIVO), GESTOR DE ADMISION (TODOS LOS ACTIVOS),
--##			SUPERVISOR DE ADMISION (TODOS LOS ACTIVOS), GESTORIAS DE ADMISION*, SUPERVISOR DEL ACTIVO*
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
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'V_BUSQUEDA_TRAMITES_ACTIVO_MATRIZ'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR);     
BEGIN
	DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
	EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE EDITIONABLE VIEW "'||V_ESQUEMA||'"."'||V_TEXT_VISTA||'" ("TRA_ID", "TIPO_TRAMITE_ID", "TIPO_TRAMITE_CODIGO", "TIPO_TRAMITE_DESCRIPCION", "TRAMITE_PADRE_ID", "ACT_ID", "NUM_ACTIVO", "NOMBRE", "ESTADO_CODIGO", "ESTADO_DESCRIPCION", "SUBTIPO_TBJ_CODIGO", "SUBTIPO_TBJ_DESCRIPCION", "FECHA_INICIO", "FECHA_FIN") AS 
							SELECT
								TRAMITES.TRA_ID,
								TRA.DD_TPO_ID AS TIPO_TRAMITE_ID,
								TPO.DD_TPO_CODIGO AS TIPO_TRAMITE_CODIGO,
								TPO.DD_TPO_DESCRIPCION AS TIPO_TRAMITE_DESCRIPCION,
								TRA.TRA_TRA_ID AS TRAMITE_PADRE_ID,
								TRAMITES.ACT_ID,
								(SELECT ACT_NUM_ACTIVO FROM ACT_ACTIVO ACT WHERE ACT.ACT_ID = TRAMITES.ACT_ID) AS NUM_ACTIVO,
								TPO.DD_TPO_DESCRIPCION AS NOMBRE,
								EPR.DD_EPR_CODIGO AS ESTADO_CODIGO,
								EPR.DD_EPR_DESCRIPCION AS ESTADO_DESCRIPCION,
								DD.DD_STR_CODIGO AS SUBTIPO_TBJ_CODIGO,
								DD.DD_STR_DESCRIPCION AS SUBTIPO_TBJ_DESCRIPCION,
								TRA.TRA_FECHA_INICIO AS FECHA_INICIO,
								TRA.TRA_FECHA_FIN AS FECHA_FIN

							FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA
								LEFT JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TRA.DD_TPO_ID = TPO.DD_TPO_ID
								LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_EPR_ESTADO_PROCEDIMIENTO EPR ON EPR.DD_EPR_ID = TRA.DD_EPR_ID
								LEFT JOIN
									(SELECT TBJ.TBJ_ID, DD_STR_CODIGO, DD_STR_DESCRIPCION
											FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR
											LEFT JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.DD_STR_ID=STR.DD_STR_ID
											where tbj.borrado = 0
									) DD ON DD.TBJ_ID=TRA.TBJ_ID
								INNER JOIN
								(
									SELECT TRA_ID,ACT_ID FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE
									UNION
									SELECT TRA.TRA_ID,TBJ.ACT_ID FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA
										LEFT JOIN '||V_ESQUEMA||'.ACT_TBJ TBJ ON TRA.TBJ_ID=TBJ.TBJ_ID
										WHERE TBJ.ACT_ID IS NOT NULL
								) TRAMITES ON TRAMITES.TRA_ID = TRA.TRA_ID AND TRA.BORRADO = 0
								INNER JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = TRAMITES.ACT_ID
								INNER JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
								INNER JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION  TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.DD_TAG_CODIGO = ''16''';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...Creada OK');
	COMMIT;
EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/

EXIT;

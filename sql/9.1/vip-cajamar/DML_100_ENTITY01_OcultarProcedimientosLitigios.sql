--/*
--##########################################
--## AUTOR=GONZALO ESTELLES
--## FECHA_CREACION=20150802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hcj
--## INCIDENCIA_LINK=VARIAS
--## PRODUCTO=NO
--##
--## Finalidad: Ocultar los procedimientos de litigios usados para conectividad por MENSAJES
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-730');

	DBMS_OUTPUT.PUT_LINE('[INICIO] Limpia tipos de procedimientos');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.Dd_Tpo_Tipo_Procedimiento' ||
		' SET BORRADO=1,USUARIOBORRAR=''GONZALO'' WHERE DD_TPO_CODIGO IN ' || 
		' (''H016'',''H018'',''H020'',''H001'',''H022'',''H024'',''H026'',''H028'',''H005'',''HC100'',''H030'',''HC101'',''H006'' '||
		' ,''H064'',''H032'',''H007'',''H034'',''H036'',''H038'',''H040'',''H066'',''H042'',''H044'',''HC102'',''H046'',''H011'',''P400'' '||
		' ,''H048'',''H015'',''H050'',''HC103'',''H008'',''HC104'',''H002'',''H004'',''H052'',''H065'',''H054'',''H058'',''H062'',''HC105'',''HC106'', ''P420'', ''H067'' '||
		' ,''P404'',''H010'',''H012'',''H037'', ''H019'', ''H060'')';

	DBMS_OUTPUT.PUT_LINE('[INICIO] Limpia tipos de actuación');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.Dd_Tac_Tipo_Actuacion' ||
		' SET BORRADO=1,USUARIOBORRAR=''GONZALO'' WHERE DD_TAC_ID IN ' || 
		' (select dd_tac_id from '||V_ESQUEMA||'.Dd_Tac_Tipo_Actuacion tac where borrado=0 and not exists (select 1 from '||V_ESQUEMA||'.Dd_Tpo_Tipo_Procedimiento prc where prc.dd_Tac_id=tac.dd_tac_id and prc.borrado=0))';

	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-730');
	
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
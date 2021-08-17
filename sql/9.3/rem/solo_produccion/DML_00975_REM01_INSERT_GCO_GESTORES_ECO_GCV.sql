--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20210726
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10212
--## PRODUCTO=NO
--## 
--## Finalidad: Aprovisionar la tabla 'TMP_GCO_GCH' con ECO_ID
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


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
    V_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TMP_GCO_GCH'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'REMVIP-10212';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
          
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO (ECO_ID, GEE_ID)
  SELECT ECO_ID, GEE_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS INSERTADOS CORRECTAMENTE EN GCO_GESTOR_ADD_ECO: ' || sql%rowcount);

  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO (ECO_ID, GEH_ID)
  SELECT ECO_ID, GEH_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADO CORRECTAMENTE');
  DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS INSERTADOS CORRECTAMENTE EN GCH_GESTOR_ECO_HISTORICO: ' || sql%rowcount);

  V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.TMP_GCO_GCH';
  EXECUTE IMMEDIATE V_MSQL;
   
  COMMIT;   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20201027
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11815
--## PRODUCTO=NO
--## 
--## Finalidad: Aprovisionar la tabla 'TMP_GCO_GCH_HREOS_11815' con ECO_ID
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TMP_GCO_GCH_HREOS_11815'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'HREOS-11815';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'';
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	 
    -- LOOP para insertar los valores en TMP_GCO_GCH -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN TMP_GCO_GCH_HREOS_11815 ');
    FOR I IN 1..V_NUM_TABLAS
      LOOP
    
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST (GEH_ID, USU_ID, DD_TGE_ID, GEH_FECHA_DESDE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                      SELECT '|| V_ID || '
                      ,  (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''GESTFORM'')
                      , (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GFORM'')
                      , SYSDATE
                      , 0
                      , '''||V_INCIDENCIA||'''
                      , SYSDATE
                      , 0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;  

          V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
          SET GEH_ID = '||V_ID||' WHERE ID = '||I||'';    
          EXECUTE IMMEDIATE V_MSQL; 

    END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: TMP_GCO_GCH MODIFICADO CORRECTAMENTE ');
   

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

--/*
--######################################### 
--## AUTOR=Vicente Martinez Cifrre
--## FECHA_CREACION=20190618
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6797
--## PRODUCTO=SI
--## 
--## Finalidad: Rellenar campo CLIENTE_WS en tabla MGD_MAPEO_GESTOR_DOC.
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
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.    
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
  --Array que contiene los registros que se van a crear
  TYPE T_COL IS TABLE OF VARCHAR2(250);
  TYPE T_ARRAY_COL IS TABLE OF T_COL;
  V_COL T_ARRAY_COL := T_ARRAY_COL(
      -- Recordatorios
  	  T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','Gescobro','GESCOBRO'),
      T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','Promontoria Agora','PROMONTORIA AGORA'),
      T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','Global Licata SA','LICATA'),
      T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','Global Pantelaria SA','PANTELARIA'),
      T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','Bankia','BANKIA'),
      T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','Cajamar','CAJAMAR'),
      T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','Caser','CASER'),
      T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','Promontoria 227','PROMONTORIA 227'),
      T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','LCM Partners','LCM PARTNERS'),
      T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','Goldentree','GOLDENTREE'),
      T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','Haya Titulizacion','HAYA TITULACION'),
      T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','Ing','ING'),
      T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','Jaipur','JAIPUR'),
      T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','Liberbank','LIBERBANK'),
      T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','Sareb','SAREB'),
      T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','Solvia','SOLVIA'),
      T_COL(''||V_ESQUEMA||'','MGD_MAPEO_GESTOR_DOC', 'CLIENTE_WS','Waterfall','WATERFALL')
 
  );  
  V_TMP_COL T_COL;
  
BEGIN
    	
    -----------------------
    ---     CAMPOS      ---
    -----------------------

    DBMS_OUTPUT.PUT_LINE('[INICIO CAMPOS]');
    
    FOR I IN V_COL.FIRST .. V_COL.LAST
    LOOP
        V_TMP_COL := V_COL(I);
        
        
        V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TMP_COL(2)||' MGD USING (SELECT MGD_ID FROM MGD_MAPEO_GESTOR_DOC WHERE CLIENTE_GD = '''||V_TMP_COL(4)||''') MGD2
          ON (MGD.MGD_ID = MGD2.MGD_ID)
          WHEN MATCHED THEN
          UPDATE SET 
          MGD.'||V_TMP_COL(3)||' = '''||V_TMP_COL(5)||'''';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('  [INFO] ' ||SQL%ROWCOUNT|| ' FILAS ACTUALIZADAS'); 
    
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[FIN CAMPOS]');
    
    COMMIT;  
    
    DBMS_OUTPUT.PUT_LINE('[FIN CLAVES FORANEAS]');
  
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

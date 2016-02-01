--/*
--##########################################
--## AUTOR=Carlos Pérez
--## FECHA_CREACION=20151021
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-359
--## PRODUCTO=SI
--## Finalidad: DDL
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN

    DBMS_OUTPUT.PUT_LINE('******** UTILES ********'); 

    
    V_MSQL := 'create or replace PACKAGE UTILES AS 
    
  procedure analiza_tabla(USUARIO IN VARCHAR2, NOM_TABLA IN varchar2); 
  -- Analiza las estadísticas de una tabla y sus índices, usando porcentaje de estadísticas automático.
   
  procedure analiza_tabla(USUARIO IN VARCHAR2, NOM_TABLA IN varchar2, PORCENTAJE IN NUMBER); 
  -- Analiza las estadísticas de una tabla y sus índices, usando porcentaje de estadísticas indicado por parámetro (de 1 a 100).
  
  procedure analiza_esquema(USUARIO IN VARCHAR2); 
  -- Analiza las estadísticas de un esquema completo, sus tablas y sus índices, usando porcentaje de estadísticas automático.
  
  procedure analiza_esquema(USUARIO IN VARCHAR2, PORCENTAJE IN NUMBER); 
  -- Analiza las estadísticas de un esquema completo, sus tablas y sus índices, usando porcentaje de estadísticas indicado por parámetro (de 1 a 100).
  
  procedure analiza_indice(USUARIO IN VARCHAR2, NOM_INDICE IN VARCHAR2); 
  -- Analiza las estadísticas de un indice, usando porcentaje de estadísticas automático.
  
  procedure analiza_indice(USUARIO IN VARCHAR2, NOM_INDICE IN VARCHAR2, PORCENTAJE IN NUMBER); 
  -- Analiza las estadísticas de un indice, usando porcentaje de estadísticas indicado por parámetro (de 1 a 100).

END UTILES;


-----------------------------------------------------------';

--DBMS_OUTPUT.PUT_LINE(V_MSQL);
DBMS_OUTPUT.PUT_LINE('[INFO] PACKAGE CREADO');
EXECUTE IMMEDIATE V_MSQL;

V_MSQL := 'create or replace PACKAGE BODY UTILES
AS
  PROCEDURE analiza_tabla(USUARIO IN VARCHAR2, NOM_TABLA IN VARCHAR2)
  AS
  -- Analiza las estadísticas de una tabla y sus índices, usando porcentaje de estadísticas automático.
  BEGIN
  
    DBMS_STATS.GATHER_TABLE_STATS ( 
    ownname => USUARIO, 
    tabname => NOM_TABLA, 
    estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, 
    method_opt => ''FOR ALL COLUMNS SIZE AUTO'', 
    degree => DBMS_STATS.AUTO_DEGREE, 
    granularity => ''ALL'', 
    CASCADE => TRUE);
    
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (''ERROR: analizando tabla '' || USUARIO || ''.'' || NOM_TABLA || ''. '' || sqlcode || '' --- '' || sqlerrm);
    RAISE;    
    
  END analiza_tabla;
  
  
  procedure analiza_tabla(USUARIO IN VARCHAR2, NOM_TABLA IN varchar2, PORCENTAJE IN NUMBER) AS
    -- Analiza las estadísticas de una tabla y sus índices, usando porcentaje de estadísticas indicado por parámetro (de 1 a 100).
  BEGIN

    DBMS_STATS.GATHER_TABLE_STATS ( 
    ownname => USUARIO, 
    tabname => NOM_TABLA, 
    estimate_percent => PORCENTAJE, 
    method_opt => ''FOR ALL COLUMNS SIZE AUTO'', 
    degree => DBMS_STATS.AUTO_DEGREE, 
    granularity => ''ALL'', 
    CASCADE => TRUE);
    
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (''ERROR: analizando tabla '' || USUARIO || ''.'' || NOM_TABLA || ''. '' || sqlcode || '' --- '' || sqlerrm);
    RAISE;     

  END analiza_tabla;
  
  
  procedure analiza_esquema(USUARIO IN VARCHAR2) AS
      -- Analiza las estadísticas de un esquema completo, sus tablas y sus índices, usando porcentaje de estadísticas automático.
  BEGIN

    DBMS_STATS.GATHER_SCHEMA_STATS ( 
    ownname => USUARIO, 
    estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, 
    method_opt => ''FOR ALL COLUMNS SIZE AUTO'', 
    degree => DBMS_STATS.AUTO_DEGREE, 
    granularity => ''ALL'', 
    CASCADE => TRUE);
    
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (''ERROR: analizando esquema '' || USUARIO || ''. '' || sqlcode || '' --- '' || sqlerrm);
    RAISE;     
    
  END analiza_esquema;
  

  procedure analiza_esquema(USUARIO IN VARCHAR2, PORCENTAJE IN NUMBER) AS
      -- Analiza las estadísticas de un esquema completo, sus tablas y sus índices, usando porcentaje de estadísticas indicado por parámetro (de 1 a 100).
  BEGIN

    DBMS_STATS.GATHER_SCHEMA_STATS ( 
    ownname => USUARIO, 
    estimate_percent => PORCENTAJE, 
    method_opt => ''FOR ALL COLUMNS SIZE AUTO'', 
    degree => DBMS_STATS.AUTO_DEGREE, 
    granularity => ''ALL'', 
    CASCADE => TRUE);
    
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (''ERROR: analizando esquema '' || USUARIO || ''. '' || sqlcode || '' --- '' || sqlerrm);
    RAISE;      

  END analiza_esquema;
  
  
  procedure analiza_indice(USUARIO IN VARCHAR2, NOM_INDICE IN VARCHAR2) AS
  -- Analiza las estadísticas de un indice, usando porcentaje de estadísticas automático.
  BEGIN
  
    DBMS_STATS.GATHER_INDEX_STATS ( 
    ownname => USUARIO, 
    indname => NOM_INDICE,
    estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,  
    degree => DBMS_STATS.AUTO_DEGREE, 
    granularity => ''ALL'');
    
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (''ERROR: analizando indice '' || USUARIO || ''.'' || NOM_INDICE || ''. '' || sqlcode || '' --- '' || sqlerrm);
    RAISE;      
  
  END;
  
  
  procedure analiza_indice(USUARIO IN VARCHAR2, NOM_INDICE IN VARCHAR2, PORCENTAJE IN NUMBER) AS
  -- Analiza las estadísticas de un indice, usando porcentaje de estadísticas indicado por parámetro (de 1 a 100).
  BEGIN
  
    DBMS_STATS.GATHER_INDEX_STATS ( 
    ownname => USUARIO, 
    indname => NOM_INDICE,
    estimate_percent => PORCENTAJE,  
    degree => DBMS_STATS.AUTO_DEGREE, 
    granularity => ''ALL'');
    
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE (''ERROR: analizando indice '' || USUARIO || ''.'' || NOM_INDICE || ''. '' || sqlcode || '' --- '' || sqlerrm);
    RAISE;    
  
  END;
  
  
END UTILES;';

--DBMS_OUTPUT.PUT_LINE (V_MSQL);
DBMS_OUTPUT.PUT_LINE('[INFO] PACKAGE BODY CREADO');
EXECUTE IMMEDIATE V_MSQL;




DBMS_OUTPUT.PUT_LINE('[INFO] Fin script.');

    
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
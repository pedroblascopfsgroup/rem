create or replace PACKAGE UTILES AS 

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
/

-------------------------------------------------------------

create or replace PACKAGE BODY UTILES
AS
  PROCEDURE analiza_tabla(USUARIO IN VARCHAR2, NOM_TABLA IN VARCHAR2)
  AS
  -- Analiza las estadísticas de una tabla y sus índices, usando porcentaje de estadísticas automático.
  BEGIN
  
    DBMS_STATS.GATHER_TABLE_STATS ( 
    ownname => USUARIO, 
    tabname => NOM_TABLA, 
    estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, 
    method_opt => 'FOR ALL COLUMNS SIZE AUTO', 
    degree => DBMS_STATS.AUTO_DEGREE, 
    granularity => 'ALL', 
    CASCADE => TRUE);
    
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('ERROR: analizando tabla ' || USUARIO || '.' || NOM_TABLA || '. ' || sqlcode || ' --- ' || sqlerrm);
    RAISE;    
    
  END analiza_tabla;
  
  
  procedure analiza_tabla(USUARIO IN VARCHAR2, NOM_TABLA IN varchar2, PORCENTAJE IN NUMBER) AS
    -- Analiza las estadísticas de una tabla y sus índices, usando porcentaje de estadísticas indicado por parámetro (de 1 a 100).
  BEGIN

    DBMS_STATS.GATHER_TABLE_STATS ( 
    ownname => USUARIO, 
    tabname => NOM_TABLA, 
    estimate_percent => PORCENTAJE, 
    method_opt => 'FOR ALL COLUMNS SIZE AUTO', 
    degree => DBMS_STATS.AUTO_DEGREE, 
    granularity => 'ALL', 
    CASCADE => TRUE);
    
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('ERROR: analizando tabla ' || USUARIO || '.' || NOM_TABLA || '. ' || sqlcode || ' --- ' || sqlerrm);
    RAISE;     

  END analiza_tabla;
  
  
  procedure analiza_esquema(USUARIO IN VARCHAR2) AS
      -- Analiza las estadísticas de un esquema completo, sus tablas y sus índices, usando porcentaje de estadísticas automático.
  BEGIN

    DBMS_STATS.GATHER_SCHEMA_STATS ( 
    ownname => USUARIO, 
    estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, 
    method_opt => 'FOR ALL COLUMNS SIZE AUTO', 
    degree => DBMS_STATS.AUTO_DEGREE, 
    granularity => 'ALL', 
    CASCADE => TRUE);
    
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('ERROR: analizando esquema ' || USUARIO || '. ' || sqlcode || ' --- ' || sqlerrm);
    RAISE;     
    
  END analiza_esquema;
  

  procedure analiza_esquema(USUARIO IN VARCHAR2, PORCENTAJE IN NUMBER) AS
      -- Analiza las estadísticas de un esquema completo, sus tablas y sus índices, usando porcentaje de estadísticas indicado por parámetro (de 1 a 100).
  BEGIN

    DBMS_STATS.GATHER_SCHEMA_STATS ( 
    ownname => USUARIO, 
    estimate_percent => PORCENTAJE, 
    method_opt => 'FOR ALL COLUMNS SIZE AUTO', 
    degree => DBMS_STATS.AUTO_DEGREE, 
    granularity => 'ALL', 
    CASCADE => TRUE);
    
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('ERROR: analizando esquema ' || USUARIO || '. ' || sqlcode || ' --- ' || sqlerrm);
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
    granularity => 'ALL');
    
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('ERROR: analizando indice ' || USUARIO || '.' || NOM_INDICE || '. ' || sqlcode || ' --- ' || sqlerrm);
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
    granularity => 'ALL');
    
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('ERROR: analizando indice ' || USUARIO || '.' || NOM_INDICE || '. ' || sqlcode || ' --- ' || sqlerrm);
    RAISE;    
  
  END;
  
  
END UTILES;
/

exit;
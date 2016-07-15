--/*
--##########################################
--## AUTOR=Manuel Rodriguez Sajardo
--## FECHA_CREACION=20160706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=RECOVERY-2021
--## PRODUCTO=NO
--##
--## Finalidad: PASAR ESTADISTICAS A LA TABLA MIG_EXPEDIENTES_LIQUIDACIONES
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;

DECLARE
    
    ERR_NUM    NUMBER(25);
    ERR_MSG    VARCHAR2(1024 CHAR);  
    EXISTE     NUMBER;
    V_SQL      VARCHAR2(1000);
    V_ESQUEMA  VARCHAR2(25 CHAR) := 'HAYA02';
    
    TYPE T_TABLAS IS TABLE OF VARCHAR2(70);      
    TYPE T_ARRAY_TABLAS IS TABLE OF T_TABLAS;
    V_TEMP_TABLAS  T_TABLAS;
        
    V_TABLA T_ARRAY_TABLAS := T_ARRAY_TABLAS
        (T_TABLAS(''||V_ESQUEMA||'','MIG_EXPEDIENTES_LIQUIDACIONES')
    );

BEGIN
                
    --** Actualiza estadisticas de tablas de interface tras loader
    FOR I IN V_TABLA.FIRST .. V_TABLA.LAST
    LOOP
          
        V_TEMP_TABLAS := V_TABLA(I);
        EXISTE := 0;
        V_SQL:= 'SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEMP_TABLAS(2)||''' AND OWNER = '''||V_TEMP_TABLAS(1)||'''';
        EXECUTE IMMEDIATE V_SQL INTO EXISTE;
        IF (EXISTE>0) 
          THEN 
            DBMS_OUTPUT.PUT_LINE(''''||V_TEMP_TABLAS(1)||'''.UTILES.ANALIZA_TABLA( '''||V_TEMP_TABLAS(1)||''','''||V_TEMP_TABLAS(2)||''' )');
            HAYA02.UTILES.ANALIZA_TABLA(V_TEMP_TABLAS(1),V_TEMP_TABLAS(2));
            DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Estadisticas sobre '||V_TEMP_TABLAS(1)||'.'||V_TEMP_TABLAS(2)||' actualizadas.');
          ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' La tabla '||V_TEMP_TABLAS(1)||'.'||V_TEMP_TABLAS(2)||' no existe.');
        END IF;
     
    END LOOP;
  
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] - '||to_char(sysdate,'HH24:MI:SS')||' Error actualizando estadisticas.');
    DBMS_OUTPUT.put_line('[ERROR] - '||to_char(sysdate,'HH24:MI:SS')||' Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   

END;
/

EXIT

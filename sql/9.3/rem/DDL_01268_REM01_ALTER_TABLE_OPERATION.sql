
--/*
--######################################### 
--## AUTOR=DAP
--## FECHA_CREACION=20220228
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11125
--## PRODUCTO=NO
--## 
--## Finalidad: Cambio campo DD_SCR_ID en tablas del array a no obligatorio
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
  V_TABLA VARCHAR2(30 CHAR); -- Vble. nombre tabla auxiliar.
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
  --Array que contiene los registros que se van a crear
  TYPE T_COL IS TABLE OF VARCHAR2(250);
  TYPE T_ARRAY_COL IS TABLE OF T_COL;
  V_COL T_ARRAY_COL := T_ARRAY_COL(
    T_COL('TOB_TESTIGOS_OBLIGATORIOS'),
    T_COL('COR_CONFIG_RECOMENDACION_RCDC')
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

        V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_SCR_ID'' AND NULLABLE = ''N'' AND TABLE_NAME = '''||V_TMP_COL(1)||''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN

            DBMS_OUTPUT.PUT_LINE('	[INFO] COLUMNA DD_SCR_ID EN TABLA '''||V_TMP_COL(1)||''' ES NO NULLABLE. SE PROCEDE A CAMBIAR A NULLABLE');

            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(1)||' 
	                    MODIFY (DD_SCR_ID NULL)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('	[INFO] COLUMNA DD_SCR_ID EN TABLA '''||V_TMP_COL(1)||''' MODIFICADA A NULLABLE.');

        ELSE 

            DBMS_OUTPUT.PUT_LINE('	[INFO] COLUMNA DD_SCR_ID EN TABLA '''||V_TMP_COL(1)||''' NO EXISTE O YA ES NULLABLE.');

        END IF;
    
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
  
    
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

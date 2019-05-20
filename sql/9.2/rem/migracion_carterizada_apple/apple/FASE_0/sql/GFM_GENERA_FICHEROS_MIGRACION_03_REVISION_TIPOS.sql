WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
   	-- user defined exception 
	FALTAN_TIPOS  EXCEPTION; 

	TABLE_COUNT  NUMBER(3);
	EXISTE       NUMBER;
	V_SQL        VARCHAR2(12000 CHAR);
	V_SQL2        VARCHAR2(12000 CHAR);
	V_SQL3        VARCHAR2(12000 CHAR);
	V_TABLENAME  VARCHAR2(50 CHAR); 

	V_ESQUEMA    VARCHAR2(25 CHAR):= 'REM01';
	ERR_NUM      NUMBER(25);
	ERR_MSG      VARCHAR2(1024 CHAR);          
	V_NUMBER     NUMBER;
	V_COUNT      NUMBER;
	V_DEBUG     BOOLEAN := FALSE;
	V_FLAG_EXTRA10  NUMBER;
	V_COLUMNA_PK  VARCHAR2(50);
	V_NUM_TABLAS  VARCHAR2(50);
        
BEGIN
    
    ------------------
    --   INSERT INF_INFORME_DIARIO_PROCESOS
    ------------------   
    DBMS_OUTPUT.PUT_LINE( '[INICIO] REVISION INF_INFORME_DIARIO_PROCESOS');



    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.GFM_GENERA_FICHEROS_MIGRACION GFM LEFT JOIN '||V_ESQUEMA||'.GFM_REEMPLAZO_TIPOS RT ON RT.TIPO_CAMPO = GFM.TIPO_CAMPO
 WHERE RT.TEXTO_DEFECTO IS NULL';
    DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
DBMS_OUTPUT.PUT_LINE('[V_NUM_TABLAS] '||V_NUM_TABLAS);
	IF V_NUM_TABLAS > 0 THEN
		RAISE FALTAN_TIPOS;		
	ELSE
		DBMS_OUTPUT.PUT_LINE('[FIN]REVISION INF_INFORME_DIARIO_PROCESOS - Todos los tipos de campo existen:' || sql%rowcount);
	END IF;
    


EXCEPTION
   WHEN FALTAN_TIPOS THEN 
      ERR_NUM := SQLCODE;
      ERR_MSG := '
***************************** [FIN]: HAY ' || V_NUM_TABLAS || ' TIPOS DE CAMPO SIN REGISTRO***************************** 
	Ejecute el siguiente comando para localizar:
SELECT DISTINCT GFM.TIPO_CAMPO FROM '||V_ESQUEMA||'.GFM_GENERA_FICHEROS_MIGRACION GFM LEFT JOIN '||V_ESQUEMA||'.GFM_REEMPLAZO_TIPOS RT ON RT.TIPO_CAMPO = GFM.TIPO_CAMPO
 WHERE RT.TEXTO_DEFECTO IS NULL;



';
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;    
/

EXIT;

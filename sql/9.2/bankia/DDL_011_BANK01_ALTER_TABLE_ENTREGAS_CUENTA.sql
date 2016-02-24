/*
--##########################################
--## AUTOR=Alejandro I�igo
--## FECHA_CREACION=20160118
--## ARTEFACTO=ETL
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=BKREC-706
--## PRODUCTO=NO
--##########################################
--*/



WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); /* Sentencia a ejecutar    */
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; /* Configuracion Esquema*/
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; /* Configuracion Esquema Master*/
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; /* Configuracion Indice*/
    V_SQL VARCHAR2(4000 CHAR); /* Vble. para consulta que valida la existencia de una tabla.*/
    V_NUM_TABLAS NUMBER(16); /* Vble. para validar la existencia de una tabla.  */
    ERR_NUM NUMBER(25);  /* Vble. auxiliar para registrar errores en el script.*/
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.*/

    V_TEXT1 VARCHAR2(2400 CHAR); /* Vble. auxiliar*/
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; /* Configuracion Esquema minirec*/
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; /* Configuracion Esquema recovery_bankia_dwh*/
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; /* Configuracion Esquema recovery_bankia_datastage*/
	
BEGIN

    /*  tabla ECL_ENTREGAS_CUENTA_LIQ <-- ELIMINAR*/
	
    DBMS_OUTPUT.PUT_LINE('[START] DROP CONSTRAINT tabla ECL_ENTREGAS_CUENTA_LIQ -- ECL_UNIQUE_LIQ_EXTERN_ID');	
    
    V_NUM_TABLAS := 0;
    V_SQL:= 'select count(*) from all_constraints where constraint_name=''ECL_UNIQUE_LIQ_EXTERN_ID'' and table_name=''ECL_ENTREGAS_CUENTA_LIQ'' and owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
    IF (V_NUM_TABLAS=1) THEN
       EXECUTE IMMEDIATE('ALTER TABLE ECL_ENTREGAS_CUENTA_LIQ DROP CONSTRAINT ECL_UNIQUE_LIQ_EXTERN_ID CASCADE ');
	   DBMS_OUTPUT.PUT_LINE('Constraint ECL_UNIQUE_LIQ_EXTERN_ID borrado');
	ELSE
	   DBMS_OUTPUT.PUT_LINE('Constraint ECL_UNIQUE_LIQ_EXTERN_ID no encontrado');
    END IF;	

    DBMS_OUTPUT.PUT_LINE('[START] DROP INDEX tabla ECL_ENTREGAS_CUENTA_LIQ -- ECL_UNIQUE_LIQ_EXTERN_ID');	
    
    V_NUM_TABLAS := 0;
    V_SQL:= 'select count(*) from all_indexes where index_name=''ECL_UNIQUE_LIQ_EXTERN_ID'' and table_name=''ECL_ENTREGAS_CUENTA_LIQ'' and table_owner = ''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
    IF (V_NUM_TABLAS=1) THEN
       EXECUTE IMMEDIATE('DROP INDEX ECL_UNIQUE_LIQ_EXTERN_ID ');
	   DBMS_OUTPUT.PUT_LINE('Índice ECL_UNIQUE_LIQ_EXTERN_ID borrado');
	ELSE
	   DBMS_OUTPUT.PUT_LINE('Índice ECL_UNIQUE_LIQ_EXTERN_ID no encontrado');
    END IF;
	
	DBMS_OUTPUT.PUT_LINE('[START] Ampliación campo USUARIOCREAR');	
	
    V_NUM_TABLAS := 0;    
    V_SQL:= 'SELECT COUNT(1) FROM user_tab_cols WHERE UPPER(table_name) =  ''ECL_ENTREGAS_CUENTA_LIQ'' and UPPER(column_name) = ''USUARIOCREAR'' ';		
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;	

    IF V_NUM_TABLAS = 1 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.ECL_ENTREGAS_CUENTA_LIQ MODIFY USUARIOCREAR VARCHAR2(50 CHAR)';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.Campo ECL_ENTREGAS_CUENTA_LIQ.USUARIOCREAR modificado');
	ELSE
	    DBMS_OUTPUT.PUT_LINE('Campo ECL_ENTREGAS_CUENTA_LIQ.USUARIOCREAR no encontrado');		
    END IF;		
	
	DBMS_OUTPUT.PUT_LINE('[START] Ampliación campo USUARIOMODIFICAR');	
	
    V_NUM_TABLAS := 0;    
    V_SQL:= 'SELECT COUNT(1) FROM user_tab_cols WHERE UPPER(table_name) =  ''ECL_ENTREGAS_CUENTA_LIQ'' and UPPER(column_name) = ''USUARIOMODIFICAR'' ';		
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;	

    IF V_NUM_TABLAS = 1 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.ECL_ENTREGAS_CUENTA_LIQ MODIFY USUARIOMODIFICAR VARCHAR2(50 CHAR)';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.Campo ECL_ENTREGAS_CUENTA_LIQ.USUARIOMODIFICAR modificado');
	ELSE
	    DBMS_OUTPUT.PUT_LINE('Campo ECL_ENTREGAS_CUENTA_LIQ.USUARIOMODIFICAR no encontrado');		
    END IF;		
	
	DBMS_OUTPUT.PUT_LINE('[START] Ampliación campo USUARIOBORRAR');	
	
    V_NUM_TABLAS := 0;    
    V_SQL:= 'SELECT COUNT(1) FROM user_tab_cols WHERE UPPER(table_name) =  ''ECL_ENTREGAS_CUENTA_LIQ'' and UPPER(column_name) = ''USUARIOBORRAR'' ';		
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;	

    IF V_NUM_TABLAS = 1 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.ECL_ENTREGAS_CUENTA_LIQ MODIFY USUARIOBORRAR VARCHAR2(50 CHAR)';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.Campo ECL_ENTREGAS_CUENTA_LIQ.USUARIOBORRAR modificado');
	ELSE
	    DBMS_OUTPUT.PUT_LINE('Campo ECL_ENTREGAS_CUENTA_LIQ.USUARIOBORRAR no encontrado');		
    END IF;	

    V_NUM_TABLAS := 0;    
    V_SQL:= 'SELECT COUNT(1) FROM user_tab_cols WHERE UPPER(table_name) =  ''ECL_ENTREGAS_CUENTA_LIQ'' and UPPER(column_name) = ''ECL_CDINTS'' ';		
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;	

    IF V_NUM_TABLAS = 1 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.ECL_ENTREGAS_CUENTA_LIQ MODIFY ECL_CDINTS NUMBER(9,6)';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.Campo ECL_ENTREGAS_CUENTA_LIQ.ECL_CDINTS modificado');
	ELSE
	    DBMS_OUTPUT.PUT_LINE('Campo ECL_ENTREGAS_CUENTA_LIQ.ECL_CDINTS no encontrado');		
    END IF;			
    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit

--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20220107
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16737
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla auxiliar para AUX_CAT_CATASTRO
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

	V_MSQL VARCHAR2(32000 CHAR); 
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';
	V_SQL VARCHAR2(4000 CHAR);
	V_NUM NUMBER(16);
	ERR_NUM NUMBER(25);  
	ERR_MSG VARCHAR2(1024 CHAR); 
	V_TABLA VARCHAR2(50 CHAR):= 'AUX_CAT_CATASTRO';


BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO.');
	
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	IF V_NUM != 0 THEN
	
		DBMS_OUTPUT.PUT_LINE('[INFO] LA TABLA '''||V_TABLA||''' YA EXISTE.');
		V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
		EXECUTE IMMEDIATE V_MSQL;
		
	END IF;	

	EXECUTE IMMEDIATE '
	CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
		 CAT_ID	                        VARCHAR2(50 CHAR)
        ,CAT_REF_CATASTRAL	            VARCHAR2(50 CHAR)
        ,CAT_SUPERFICIE_PARCELA	        VARCHAR2(50 CHAR)
        ,CAT_SUPERFICIE_CONSTRUIDA	    VARCHAR2(50 CHAR)
        ,CAT_SUPERFICIE_ZONAS_COMUNES	VARCHAR2(50 CHAR)
        ,CAT_ANYO_CONSTRUCCION	        VARCHAR2(50 CHAR)
        ,CAT_COD_POSTAL	                VARCHAR2(50 CHAR)
        ,DD_TVI_ID	                    VARCHAR2(50 CHAR)
        ,CAT_DESCRIPCION_VIA	        VARCHAR2(50 CHAR)
        ,CAT_NUM_VIA	                VARCHAR2(50 CHAR)
        ,CAT_PISO	                    VARCHAR2(50 CHAR)
        ,CAT_PLANTA	                    VARCHAR2(50 CHAR)
        ,CAT_PUERTA	                    VARCHAR2(50 CHAR)
        ,CAT_ESCALERA	                VARCHAR2(50 CHAR)
        ,CAT_CLASE	                    VARCHAR2(50 CHAR)
        ,CAT_USO_PRINCIPAL	            VARCHAR2(50 CHAR)
        ,CAT_DIV_HORIZONTAL             VARCHAR2(50 CHAR)
        ,DD_PRV_ID	                    VARCHAR2(50 CHAR)
        ,DD_LOC_ID	                    VARCHAR2(50 CHAR)
        ,CAT_LATITUD	                VARCHAR2(50 CHAR)
        ,CAT_LONGITUD	                VARCHAR2(50 CHAR)
        ,CAT_GEODISTANCIA	            VARCHAR2(50 CHAR)
        ,ACT_ID	                      NUMBER(16,0)
	)';

	DBMS_OUTPUT.PUT_LINE('[INFO] LA TABLA '''||V_TABLA||''' HA SIDO CREADA CON EXITO.');
  COMMIT;
 
  
  DBMS_OUTPUT.PUT_LINE('[INFO] PROCESO FINALIZADO.');

         
EXCEPTION

   WHEN OTHERS THEN
   
        err_num := SQLCODE;
        err_msg := SQLERRM;

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);

        ROLLBACK;
        RAISE;          

END;
/
EXIT

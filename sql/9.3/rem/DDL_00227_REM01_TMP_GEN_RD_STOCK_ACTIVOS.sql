--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20210302
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9099
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla auxiliar para TMP_GEN_RD_STOCK_ACTIVOS
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
	V_TABLA VARCHAR2(50 CHAR):= 'TMP_GEN_RD_STOCK_ACTIVOS';


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
		"FECHA_ORIGEN"                    DATE
	    , "ID_HAYA"                       NUMBER(16, 0) NOT NULL ENABLE
	    , "NUM_ACTIVO_CLIENTE"            VARCHAR2(100 CHAR)
	    , "TIPO_ACTIVO"                   VARCHAR2(100 CHAR)
	    , "SUBTIPO_ACTIVO"                VARCHAR2(100 CHAR)
	    , "CARTERA"                       VARCHAR2(100 CHAR)
	    , "SUBCARTERA"                    VARCHAR2(100 CHAR)
	    , "NOMBRE"                        VARCHAR2(250 CHAR)
	    , "TIPO_VIA"                      VARCHAR2(50 CHAR)
	    , "CALLE"                         VARCHAR2(100 CHAR)
	    , "NUMERO"                        VARCHAR2(100 CHAR)
	    , "ESCALERA"                      VARCHAR2(50 CHAR)
	    , "PISO"                          VARCHAR2(50 CHAR)
	    , "PUERTA"                        VARCHAR2(50 CHAR)
	    , "CODIGO_POSTAL"                 VARCHAR2(250 CHAR)
	    , "AMBITO_GEOGRAFICO"             VARCHAR2(250 CHAR)
	    , "COMUNIDAD_AUTONOMA"            VARCHAR2(50 CHAR)
	    , "PROVINCIA"                     VARCHAR2(50 CHAR)
	    , "MUNICIPIO"                     VARCHAR2(50 CHAR)
	    , "LATITUD"                       NUMBER(21, 15)
	    , "LONGITUD"                      NUMBER(21, 15)
	    , "SUPERFICIE_CONSTRUIDA"         NUMBER(16, 2)
	    , "SUPERFICIE_UTIL"               NUMBER(16, 2)
	    , "SUPERFICIE_ZONAS_COMUNES"      NUMBER(16, 2)
	    , "FASE"                          VARCHAR2(100 CHAR)
	    , "ID_PRINEX"                     NUMBER(16, 0)
	    , "ID_CLIENTE"                    NUMBER(16, 0)
	    , "ID_UFIR"                       VARCHAR2(50 CHAR)
	    , "REF_CATASTRAL"                 VARCHAR2(50 CHAR)
	    , "FECHA_REGISTRO"                DATE
	    , "NUM_DORMITORIOS"               NUMBER(2, 0)
	    , "NUM_BANYOS"                    NUMBER(2, 0)
	    , "SUP_UTIL_DESCRIPTOR"           NUMBER(16, 2)
	    , "SUP_CONSTRUIDA_DESCRIPTOR"     NUMBER(16, 2)
	    , "DESTINO_COMERCIAL"             VARCHAR2(100 CHAR)
	    , "FECHA_INI_COMERCIALIZACION"    DATE
	    , "SITUACION_COMERCIAL"           VARCHAR2(100 CHAR)
	    , "SITUACION_OCUPACIONAL"         VARCHAR2(100 CHAR)
	    , "VALOR_NETO_CONTABLE"           NUMBER(16, 2)
	    , "DEUDA_BRUTA"                   NUMBER(16, 2)
	    , "VALOR_VENTA_HAYA"              NUMBER(16, 2)
	    , "FECHA_VALOR_VENTA"             DATE
	    , "VALOR_RENTA_HAYA"              NUMBER(16, 2)
	    , "LIQUIDEZ"                      VARCHAR2(50 CHAR)
	    , "REGISTRADOR_PROPIEDAD"         VARCHAR2(50 CHAR)
	    , "REGISTRO"                      VARCHAR2(50 CHAR)
	    , "MUNICIPIO_REGISTRO"            VARCHAR2(50 CHAR)
	    , "LIBRO"                         VARCHAR2(50 CHAR)
	    , "TOMO"                          VARCHAR2(50 CHAR)
	    , "HOJA"                          VARCHAR2(50 CHAR)
	    , "PROPIETARIO"                   NUMBER(16, 0)
	    , "PROPIETARIO_NOMBRE"            VARCHAR2(100 CHAR)
	    , "VALOR_RBA"                     NUMBER(16, 2)
	    , "FECHA_TASACION"                DATE
	    , "VALOR_TASACION"                NUMBER(16, 2)
	    , "VALOR_TASACION_HET"            NUMBER(16, 2)
	    , "VALOR_RAZONABLE"               NUMBER(16, 2)
	    , "VALOR_APROBACION_VENTA"        NUMBER(16, 2)
	    , "FECHA_CONCESION"               DATE
	    , "FECHA_POSESION"                DATE
	    , "OCUPADO"                       NUMBER(1, 0)
	    , "FECHA_CONCESION_BOLETIN_GAS"   DATE
	    , "FECHA_CONCESION_BOLETIN_AGUA"  DATE
	    , "FECHA_CONCESION_BOLETIN_LUZ"   DATE
	    , "FECHA_APLICACION_LPO"          DATE
	    , "FECHA_CONCESION_LPO"           DATE
	    , "FECHA_VALIDACION_LPO"          DATE
	    , "FECHA_FIRMA_CFO"               DATE
	    , "ESTADO_FISICO_ACTIVO"          VARCHAR2(100 CHAR)
	    , "ESTADO_BANCO_ESPANA"           VARCHAR2(50 CHAR)
	    , "SUBESTADO_BANCO_ESPANA"        VARCHAR2(50 CHAR)
	    , "TIENE_ACTUACIONES_TECNICAS"    NUMBER(1, 0)
	    , "FECHA_CEE"                     DATE
	    , "FECHA_VALIDACION_CEE"          DATE
	    , "CALIFICACION_CEE"              VARCHAR2(250 CHAR)
	    , "TIPO_TITULO"                   VARCHAR2(100 CHAR)
	    , "SUBTIPO_TITULO"                VARCHAR2(100 CHAR)
	    , "ES_ADJUDICACION_JUDICIAL"      NUMBER(1, 0)
	    , "FECHA_TITULO"                  DATE
	    , "FECHA_FINAL_TITULO"            DATE
	    , "FECHA_AUTO"                    DATE
	    , "FECHA_FINAL_AUTO"              DATE
	    , "LINK_PUBLICACION_VENTA"        VARCHAR2(250 CHAR)
	    , "LINK_PUBLICACION_ALQUILER"     VARCHAR2(250 CHAR)
	    , "EN_PERIMETRO_HAYA"             NUMBER(1, 0)
	    , "APLICA_GESTION"                NUMBER(1, 0)
	    , "FECHA_ALTA_REM"                DATE
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

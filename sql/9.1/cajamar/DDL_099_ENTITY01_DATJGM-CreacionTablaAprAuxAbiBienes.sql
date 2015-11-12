--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151110
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-1095   
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla APR_AUX_ABI_BIENES_CONSOL
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30) :='APR_AUX_ABI_BIENES_CONSOL';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA;

 V_MSQL:= 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||'
   (
        FECHA_EXTRACCION              DATE            NOT NULL,
        FECHA_DATO                    DATE            NOT NULL,
        CODIGO_ENTIDAD                NUMBER(5)       NOT NULL,
        CODIGO_PROPIETARIO            NUMBER(6)       NOT NULL,
        CODIGO_BIEN                   NUMBER(16)      NOT NULL,
        TIPO_BIEN                     VARCHAR2(20 CHAR) NOT NULL,
        TIPO_INMUEBLE                 VARCHAR2(4 CHAR),
        TIPO_PROD_BANCARIO            VARCHAR2(4 CHAR),
        DESCRIPCION_BIEN              VARCHAR2(250 CHAR),
        VALOR_ACTUAL                  NUMBER(16,2),
        VALOR_TASACION                NUMBER(16,2),
        BIE_FECHA_VALOR_TASACION      DATE,
        VALOR_SUBJETIVO               NUMBER(16,2),
        FECHA_VALORACION_SUBJETIVA    DATE,
        VALOR_APRECIACION             NUMBER(16,2),
        FECHA_VALORACION_APRECIACION  DATE,
        IMPORTE_CARGAS_ANTERIORES     NUMBER(16,2),
        SUPERFICIE                    NUMBER(13,2),
        SUPERFICIE_CONSTRUIDA         NUMBER(13,2),
        DIRECCION                     VARCHAR2(250 CHAR),
        POBLACION                     VARCHAR2(100 CHAR),
        CODIGO_POSTAL                 VARCHAR2(10 CHAR),
        REFERENCIA_CATASTRAL          VARCHAR2(50 CHAR),
        MUNICIPIO_LIBRO               VARCHAR2(50 CHAR),
        NUMERO_REGISTRO               VARCHAR2(50 CHAR),
        TOMO                          VARCHAR2(50 CHAR),
        LIBRO                         VARCHAR2(50 CHAR),
        FOLIO                         VARCHAR2(50 CHAR),
        NUMERO_FINCA                  VARCHAR2(50 CHAR),
        INSCRIPCION                   VARCHAR2(50 CHAR),
        FECHA_INSCRIPCION             DATE,
        NOMBRE_EMPRESA                VARCHAR2(250 CHAR),
        CIF_EMPRESA                   VARCHAR2(20 CHAR),
        CNAE_EMPRESA                  VARCHAR2(50 CHAR),
        ENTIDAD                       VARCHAR2(150 CHAR),
        NUM_CUENTA                    VARCHAR2(150 CHAR),
        MARCA                         VARCHAR2(50 CHAR),
        MODELO                        VARCHAR2(50 CHAR),
        BASTIDOR                      VARCHAR2(50 CHAR),
        MATRICULA                     VARCHAR2(50 CHAR),
        FECHA_MATRICULA               DATE,
        CHAR_EXTRA1                   VARCHAR2(50 CHAR),
        CHAR_EXTRA2                   VARCHAR2(50 CHAR),
        CHAR_EXTRA3                   VARCHAR2(50 CHAR),
        FLAG_EXTRA1                   VARCHAR2(1 CHAR),
        FLAG_EXTRA2                   VARCHAR2(1 CHAR),
        DATE_EXTRA1                   DATE,
        DATE_EXTRA2                   DATE,
        DATE_EXTRA3                   DATE,
        NUM_EXTRA1                    NUMBER(16,2),
        NUM_EXTRA2                    NUMBER(16,2),
        NUM_EXTRA3                    NUMBER(16,2)
)';


  IF V_EXISTE = 0 THEN
  EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');

  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA||' CASCADE CONSTRAINTS ');
     DBMS_OUTPUT.PUT_LINE(TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');     
  END IF; 
 
 
  
          
--Fin crear tabla

--Excepciones

EXCEPTION
WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
END;
/
EXIT;   




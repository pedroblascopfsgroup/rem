--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20150930
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-868   
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla MIG_BIENES
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
 TABLA VARCHAR(30) :='MIG_BIENES';
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA;

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (	
	  ID_BIENES                     NUMBER(16) 	  NOT NULL,
	  CD_BIEN                       VARCHAR2(20 CHAR) NOT NULL,
	  ID_BIEN_NUSE                  NUMBER(9),
	  NUMERO_ACTIVO                 NUMBER(9),
	  SITUACION_ORIGEN_BIEN         NUMBER(1) 	  NOT NULL,
	  BIEN_GARANTIAS                NUMBER(1),
	  TIPO_BIEN                     VARCHAR2(10 CHAR) NOT NULL,
	  DESCRIPCION_DEL_BIEN          VARCHAR2(250 CHAR),
	  DIRECCION                     VARCHAR2(250 CHAR),
	  POBLACION                     VARCHAR2(250 CHAR),
	  CODIGO_POSTAL                 VARCHAR2(250 CHAR),
	  SUPERFICIE                    NUMBER(10,2),
	  SUPERFICIE_CONSTRUIDA         NUMBER(10,2),
	  REFERENCIA_CATASTRAL          VARCHAR2(50 CHAR),
	  MUNICIPIO_LIBRO               VARCHAR2(50 CHAR),
	  NUMERO_REGISTRO               VARCHAR2(50 CHAR),
	  TOMO                          VARCHAR2(50 CHAR),
	  LIBRO                         VARCHAR2(50 CHAR),
	  FOLIO                         VARCHAR2(50 CHAR),
	  NUMERO_FINCA                  VARCHAR2(50 CHAR),
	  TIPO_BIENBK                   VARCHAR(2) ,
	  TIPO_INMUEBLEBK               VARCHAR(2),
	  CONSTRAINT "PK_ID_BIENES" PRIMARY KEY ("ID_BIENES") 
	  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 NOCOMPRESS LOGGING
	  TABLESPACE '||ITABLE_SPACE||'  ENABLE
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING';
 
 
  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA );
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





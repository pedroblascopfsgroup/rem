--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20160304
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-868
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla MIG_CONCURSOS_CABECERA
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master;
 TABLA VARCHAR(30) :='MIG_CONCURSOS_CABECERA';
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA;

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (	
	  ID_CONCURSO_CABECERA	          NUMBER (16)        NOT NULL,
	  CD_CONCURSO                     NUMBER(16) 	     NOT NULL,
	  CD_PROCEDIMIENTO_ORIGEN         NUMBER(16),
	  ENTIDAD_PROPIETARIA             VARCHAR2(20 CHAR)  NOT NULL,
	  NIF                             VARCHAR2(10 CHAR)  NOT NULL,
	  FECHA_PUBLICACION_BOE           DATE,
	  CD_DESPACHO                     VARCHAR2(20 CHAR)  NOT NULL,
	  CD_PROCURADOR                   VARCHAR2(20 CHAR)  NOT NULL,
	  TIPO_CONCURSO                   VARCHAR2(20 CHAR)  NOT NULL,
	  SUBTIPO_CONCURSO                VARCHAR2(20 CHAR)  NOT NULL,
	  FASE_CONCURSO                   VARCHAR2(20 CHAR)  NOT NULL,
	  PLAZA                           VARCHAR2(20 CHAR)  NOT NULL,
	  JUZGADO                         VARCHAR2(20 CHAR)  NOT NULL,
	  NUM_AUTOS                       VARCHAR2(10 CHAR),
	  NUM_AUTO_SIN_FORMATO            VARCHAR(50),
	  IMPORTE_PRINCIPAL               NUMBER(16,2) 	     NOT NULL,
	  FECHA_PRECONCURSO               DATE,
	  FECHA_AUTO_DECLAR_CONCURSO      DATE,
	  ADM_CONCURSAL_NOMBRE            VARCHAR2(200 CHAR),
	  ADM_CONCURSAL_TELF              VARCHAR2(20 CHAR),
	  ADM_CONCURSAL_FAX               VARCHAR2(20 CHAR),
	  ADM_CONCURSAL_MAIL              VARCHAR2(100 CHAR),
	  FECHA_LIMITE_COMUNIC_CREDITOS   DATE,
	  FECHA_COMUNICACION_CREDITOS     DATE,
	  TOTAL_CONTRA_MASA               NUMBER(16,2),
	  TOTAL_PRIVILEGIADO              NUMBER(16,2),
	  TOTAL_ORDINARIO                 NUMBER(16,2),
	  TOTAL_SUBORDINADO               NUMBER(16,2),
	  TOTAL_CONTINGENTE               NUMBER(16,2),
	  FECHA_INFORME_ADM_CONCURSAL     DATE,
	  POSTURA_ENTIDAD_ADM_CONCURSAL   NUMBER(1),
	  FECHA_IMPUGNACION               DATE,
	  FECHA_RESULTADO_IMPUGNACION     DATE,
	  POSTURA_ENTIDAD_IMPUGNACION     NUMBER(1),
	  FECHA_JUNTA_ACREEDORES          DATE,
	  RESULTADO_JUNTA_ACREEDORES      NUMBER(1),
	  TIPO_CONVENIO_APROBADO          VARCHAR2(10 CHAR),
	  FECHA_LIQUIDACION               DATE,
	  CONSIDERACIONES_LIQUIDACION     VARCHAR2(1000 CHAR),
	  FECHA_AUTO_CALIF_CONCURSO       DATE,
	  RESULTADO_CALIFICACION          NUMBER(1),
	  RESULTADO_SEGUIMIENTO_CONVENIO  NUMBER(1),
	  ULTIMO_HITO                     VARCHAR2(100 CHAR) NOT NULL,
	  GESTION_PLATAFORMA              VARCHAR2 (1) 	     NOT NULL,
	  GESTOR_PROC                     VARCHAR2 (8)       NOT NULL,
	  FECHA_APROBACION_CONVENIO       DATE, 
	  FECHA_APERTURA                  DATE, 
	  FECHA_APROBACION_PLAN 		  DATE, 
	  FECHA_SUBASTA 				  DATE, 
	  ALEGACIONES_PLAN_LIQUIDACION 	  VARCHAR2(1 BYTE),
	  CONCURSO_CONCLUIDO 			  VARCHAR2(1 BYTE),
	  CONSTRAINT "PK_ID_CONCURSO_CABECERA" PRIMARY KEY ("ID_CONCURSO_CABECERA") 
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


--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151001
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-868
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla MIG_PROCEDIMIENTOS_BIENES
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
 TABLA VARCHAR(30) :='MIG_PROCEDIMIENTOS_BIENES';
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA||'';

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (	
	  ID_PROC_BIENES                 NUMBER(16)        NOT NULL,
	  CD_PROCEDIMIENTO               NUMBER(16)        NOT NULL,
	  CD_BIEN                        VARCHAR2(20 CHAR) NOT NULL,
	  FECHA_INSCRIPCION              DATE,
	  FECHA_SOLICITUD_ULT_TASACION   DATE,
	  FECHA_ULTIMA_TASACION          DATE,
	  VALOR_ACTUAL                   NUMBER(16,2),
	  VALOR_TASACION                 NUMBER(16,2),
	  TASADORA                       VARCHAR2(20 CHAR),
	  VIVIENDA_HABITUAL              NUMBER(1),
	  OCUPANTES                      NUMBER(1),
	  FECHA_DECRETO_ADJ_NO_FIRME     DATE,
	  FECHA_DECRETO_ADJ_FIRME        DATE,
	  CESION_REMATE                  NUMBER(1),
	  FECHA_CESION                   DATE,
	  ENTIDAD_ADJUDICATARIA          VARCHAR2(20 CHAR),
	  FONDO                          VARCHAR2(20 CHAR),
	  PORCENTAJE_PROPIEDAD           NUMBER(5,2),
	  FECHA_POSESION                 DATE,
	  FECHA_LANZAMIENTO              DATE,
	  TOTAL_CARGAS_ANTERIORES        NUMBER(16,2),
	  FECHA_CERTIFICACION_CARGAS     DATE,
	  TOTAL_CARGAS_POSTERIORES       NUMBER(16,2),
	  FECHA_NOTIFICACION_ACREEDORES  DATE,
	  ULTIMO_HITO_BIEN_PROC          VARCHAR2(100 CHAR),
	  INSCRIPCION                    VARCHAR2(50 CHAR),
	  SITUACION_POSESORIA            VARCHAR2(20 CHAR),
	  GESTORIA_ADJUDICACION          VARCHAR2(20 CHAR),
	  FECHA_ENTREGA_TITULO_GESTOR    DATE,
	  FECHA_PRESENTACION_HACIENDA    DATE,
	  FECHA_PRESENTACION_REGISTRO    DATE,
	  FECHA_SEGUNDA_PRES_REGISTRO    DATE,
	  FECHA_RECEPCION_TITULO         DATE,
	  FECHA_INSCRIPCION_TITULO       DATE,
	  FECHA_ENVIO_AUTO_ADICION       DATE,
	  SITUACION_TITULO               VARCHAR2(10),
	  POSIBLE_POSESION               NUMBER(1),
	  FECHA_SOLICITUD_POSESION       DATE,
	  FECHA_SENYALAMIENTO_POSESION   DATE,
	  FECHA_REALIZACION_POSESION     DATE,
	  OCUPANTES_REALIZ_DILIGENCIA    NUMBER(1),
	  LANZAMIENTO_NECESARIO          NUMBER(1),
	  FECHA_SOLICITUD_LANZAMIENTO    DATE,
	  FECHA_SENYALAMIENTO_LANZAM     DATE,
	  FECHA_SOLICITUD_MORATORIA      DATE,
	  FECHA_RESOLUCION_MORATORIA     DATE,
	  RESOLUCION_MORATORIA           NUMBER(1),
	  ENTREGA_VOLUNTARIA_POSESION    NUMBER(1),
	  NECESARIA_FUERZA_POSESION      NUMBER(1),
	  NECESARIA_FUERZA_LANZAMIENTO   NUMBER(1),
	  EXISTE_INQUILINO               NUMBER(1),
	  FECHA_CONTRATO_ARREND          DATE,
	  NOMBRE_ARRENDATARIO            VARCHAR2(300 CHAR),
	  GESTION_LLAVES_NECESARIA       NUMBER(1),
	  FECHA_CAMBIO_CERRADURA         DATE,
	  NOMBRE_PRIMER_DEPOSITARIO      VARCHAR2(300 CHAR),
	  FECHA_ENVIO_PRIMER_DEPOS       DATE,
	  FECHA_RECEP_PRIMER_DEPOS       DATE,
	  NOMBRE_DEPOSITARIO_FINAL       VARCHAR2(300 CHAR),
	  FECHA_ENVIO_DEPOS_FINAL        DATE,
	  FECHA_RECEP_DEPOS_FINAL        DATE,
	  OBSERVACIONES_ADJUDICACION     VARCHAR2(3000 CHAR),
	  OBSERVACIONES_INSCRIPCION      VARCHAR2(3000 CHAR),
	  OBSERVACIONES_POSESION         VARCHAR2(3000 CHAR),
	  IMPORTE_ADJUDICACION           NUMBER(16,2),
	  ADJUDICACION                   NUMBER(1),               
	  TIPO_SUBASTA                   NUMBER(16,2) ,
	  CONSTRAINT "PK_ID_PROC_BIENES" PRIMARY KEY ("ID_PROC_BIENES") 
	  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 NOCOMPRESS LOGGING
	  TABLESPACE '||ITABLE_SPACE||'  ENABLE
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING';
 
 
  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE( TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA );
     DBMS_OUTPUT.PUT_LINE( TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE( TABLA||' CREADA');     
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




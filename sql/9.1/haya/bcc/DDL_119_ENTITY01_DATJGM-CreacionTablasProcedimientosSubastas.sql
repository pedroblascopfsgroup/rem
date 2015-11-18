--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151001
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-868
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla MIG_PROCEDIMIENTOS_SUBASTAS
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
 TABLA VARCHAR(30) :='MIG_PROCEDIMIENTOS_SUBASTAS';
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
	  ID_PROC_SUBASTA             NUMBER(16)        NOT NULL,
	  CD_SUBASTA                  NUMBER(16)        NOT NULL,
	  CD_PROCEDIMIENTO            NUMBER(16)        NOT NULL,
	  FECHA_SOLICITUD_SUBASTA     DATE,
	  FECHA_SENALAMIENTO_SUBASTA  DATE	 	NOT NULL,
	  SUBASTA_CELEBRADA           NUMBER(1)		NOT NULL,
	  FECHA_CELEBRACION_SUBASTA   DATE,
	  FECHA_DECRETO_ADJUDICACION  DATE,
	  TIPO_SUBASTA                NUMBER(2),
	  SUSPENDIDA_POR              NUMBER(1),
	  MOTIVO_SUSPENSION           VARCHAR2(10 CHAR),
	  MOTIVO_SUBASTA_CANCELADA    NUMBER(1),
	  FECHA_RECEPCION_ACTA        DATE,
	  RESOLUCION_COMITE           NUMBER(1),
	  FECHA_RESOLUCION_PROPUESTA  DATE,
	  DEUDA_JUDICIAL              NUMBER(15,2),
	  MINUTA_LETRADO              NUMBER(15,2),
	  MINUTA_PROCURADOR           NUMBER(15,2),
	  CONSTRAINT "PK_ID_PROC_SUBASTA" PRIMARY KEY ("ID_PROC_SUBASTA") 
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




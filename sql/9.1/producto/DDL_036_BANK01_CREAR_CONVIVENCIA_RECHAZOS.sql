--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20150709
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-109
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN

SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_tab_cols  
         WHERE UPPER(table_name) = 'CNV_AUX_CCDD_RECHAZOS_NUSE' and (UPPER(column_name) = 'ID_ACUERDO_CIERRE') 
         AND OWNER = V_ESQUEMA; 
          
     if V_NUM_TABLAS = 0 then 
	 
      
     	 
EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.CNV_AUX_CCDD_RECHAZOS_NUSE
(
	ID_EXPEDIENTE			NUMBER(16)          NOT NULL,
	ID_PROCEDIMIENTO		NUMBER(16)          NOT NULL,
	ID_ACUERDO_CIERRE		NUMBER(16)			NOT NULL,
	FECHA_EXTRACCION		TIMESTAMP(6)        NOT NULL,
	FICHERO_DAT				VARCHAR2(50 BYTE)   NOT NULL,
	CLAVE_FICHERO			VARCHAR2(250 BYTE)	NOT NULL,
	ERROR					NUMBER(10)  		NOT NULL,
	DS_ERROR				VARCHAR2(100 BYTE)  NOT NULL,
	FECHA_ERROR				TIMESTAMP(6)        NOT NULL
)
TABLESPACE '||V_ESQUEMA||'
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING';


EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.PK_CNV_AUX_CCDD_RECHAZOS_NUSE ON '||V_ESQUEMA||'.CNV_AUX_CCDD_RECHAZOS_NUSE
(FECHA_EXTRACCION, ID_EXPEDIENTE, ID_ACUERDO_CIERRE, FICHERO_DAT, CLAVE_FICHERO, ERROR)
LOGGING
TABLESPACE '||V_ESQUEMA||'
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL';


EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.CNV_AUX_CCDD_RECHAZOS_NUSE ADD (
  CONSTRAINT PK_CNV_AUX_CCDD_RECHAZOS_NUSE PRIMARY KEY
 (FECHA_EXTRACCION, ID_EXPEDIENTE, ID_ACUERDO_CIERRE, FICHERO_DAT, CLAVE_FICHERO, ERROR)
    USING INDEX 
    TABLESPACE '||V_ESQUEMA||'
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ))';
			   
DBMS_OUTPUT.PUT_LINE('[INFO] CREADOS CNV_AUX_CCDD_RECHAZOS_NUSE'); 			   
end if; 			  
			 
	
COMMIT;


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
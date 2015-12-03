--/*
--##########################################
--## AUTOR=Teresa_Alonso_Rodriguez
--## FECHA_CREACION=20151117
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=BKREC-1342
--## PRODUCTO=NO
--## 
--## Finalidad:     DDL para crear tabla APR_AUX_GAA_GESTOR
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR)  := '#ESQUEMA#';        -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3);                                -- Vble. para validar la existencia de las Secuencias.
    table_count number(3);                              -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3);                           -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3);                       -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER;                                     -- Numero de errores
    err_msg VARCHAR2(2048);                             -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);

    -- Otras variables

 BEGIN

    -- ******** APR_AUX_GAA_GESTOR *******
    DBMS_OUTPUT.PUT_LINE('Creacion de la Tabla APR_AUX_GAA_GESTOR en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.APR_AUX_GAA_GESTOR... Comprobaciones previas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 


    -- Comprobamos si existe la tabla   
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''APR_AUX_GAA_GESTOR'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO table_count;

    -- Si existe la borramos
    IF table_count = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.APR_AUX_GAA_GESTOR CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.APR_AUX_GAA_GESTOR... Tabla borrada');  

    END IF;
 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.APR_AUX_GAA_GESTOR... Comprobaciones previas FIN'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    --Creamos la tabla y secuencias
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.APR_AUX_GAA_GESTOR... Creacion de tablas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.APR_AUX_GAA_GESTOR
				      (
					AAG_ASU_ID			NUMBER(16,0)			NOT NULL,
					AAG_USU_USERNAME_ORIG		VARCHAR2(10 CHAR)		NOT NULL,
					AAG_USU_USERNAME_DEST		VARCHAR2(10 CHAR)		NOT NULL,
					AAG_DD_TGE_CODIGO		VARCHAR2(20 CHAR)		NOT NULL,
					AAG_FECHA_EFECTIVIDAD          	DATE				NOT NULL
	
				      )


					TABLESPACE '|| V_ESQUEMA ||'
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


    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.APR_AUX_GAA_GESTOR... Tabla creada');

   DBMS_OUTPUT.PUT_LINE('Fin creacion correcta de la Tabla APR_AUX_GAA_GESTOR en el Esquema: ' || V_ESQUEMA);
   DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;



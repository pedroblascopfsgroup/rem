--/*
--##########################################
--## AUTOR=Teresa_Alonso_Rodriguez
--## FECHA_CREACION=20151117
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=BKREC-1342
--## PRODUCTO=NO
--## 
--## Finalidad:     DDL para crear tablaAPR_AUX_GAA_GESTOR_REJECTS
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA          VARCHAR2(25 CHAR):= '#ESQUEMA#';        -- Configuracion Esquema
    V_ESQUEMA_M        VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count          number(3);                              -- Vble. para validar la existencia de las Secuencias.
    table_count        number(3);                              -- Vble. para validar la existencia de las Tablas.
    v_column_count     number(3);                              -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3);                              -- Vble. para validar la existencia de las Constraints.
    err_num            NUMBER;                                 -- Numero de errores
    err_msg            VARCHAR2(2048);                         -- Mensaje de error
    V_MSQL             VARCHAR2(4000 CHAR);

    -- Otras variables

 BEGIN

    -- ********APR_AUX_GAA_GESTOR_REJECTS *******
    DBMS_OUTPUT.PUT_LINE('Creacion de la TablaAPR_AUX_GAA_GESTOR_REJECTS en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.APR_AUX_GAA_GESTOR_REJECTS... Comprobaciones previas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 


    -- Comprobamos si existe la tabla   
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''APR_AUX_GAA_GESTOR_REJECTS'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO table_count;

    -- Si existe la borramos
    IF table_count = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.APR_AUX_GAA_GESTOR_REJECTS CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.APR_AUX_GAA_GESTOR_REJECTS... Tabla borrada');  

    END IF;
 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.APR_AUX_GAA_GESTOR_REJECTS... Comprobaciones previas FIN'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    --Creamos la tabla y secuencias
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.APR_AUX_GAA_GESTOR_REJECTS... Creacion de tablas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.APR_AUX_GAA_GESTOR_REJECTS
				      (
					AAG_FECHA_EJECUCION		DATE				NOT NULL,
					AAG_ASU_ID			NUMBER(16,0)			,
					AAG_USU_USERNAME_ORIG		VARCHAR2(10 CHAR)		,
					AAG_USU_USERNAME_DEST		VARCHAR2(10 CHAR)		,
					AAG_DD_TGE_CODIGO		VARCHAR2(20 CHAR)		,
					AAG_FECHA_EFECTIVIDAD           DATE				,
					AAG_ERRORMESSAGE		VARCHAR2(255 BYTE)	
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
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.APR_AUX_GAA_GESTOR_REJECTS... Tabla creada');

   DBMS_OUTPUT.PUT_LINE('Fin creacion correcta de la TablaAPR_AUX_GAA_GESTOR_REJECTS en el Esquema: ' || V_ESQUEMA);
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



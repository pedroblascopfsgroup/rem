--/*
--##########################################
--## AUTOR=RAFAEL ARACIL
--## FECHA_CREACION=20160211
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=BKREC-1786
--## PRODUCTO=NO
--## 
--## Finalidad: CREAR TABLA EN EL ESQUEMA V_ESQUEMA_MINIREC EN LA CUAL DEJAREMOS LOS COMENTARIOS DE LA FINALIZACION DE PROCEDIMIENTOS POR VENTA CARTERA
--## INSTRUCCIONES: EJECUTAR Y LISTO
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_ESQUEMA_MINIREC VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);

    -- Otras variables

 BEGIN

    DBMS_OUTPUT.PUT_LINE('[START]  tabla VENTA_CARTERA_COMENTARIOS');

    EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''VENTA_CARTERA_COMENTARIOS'' and owner = ''' || V_ESQUEMA_MINIREC || '''' into table_count;
    if table_count = 0 then
    EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA_MINIREC||'."VENTA_CARTERA_COMENTARIOS" 
   (	"ENTIDAD" NUMBER(5,0), 
	"NUMERO_EXP" VARCHAR2(20 CHAR), 
	"ID_EXPEDIENTE" NUMBER(8,0), 
	"ID_ANOTACION" NUMBER(16,0), 
	"FECHA_ANOTACION" DATE, 
	"TITULO_ANOTACION" VARCHAR2(100 CHAR), 
	"CODIGO_ANOTACION" VARCHAR2(100 CHAR), 
	"EMPLEADO" VARCHAR2(10 CHAR), 
	"GESTOR" VARCHAR2(50 CHAR), 
	"ID_PROCEDI" NUMBER(12,0), 
	"TEXTO_LIBRE" VARCHAR2(2500 CHAR), 
	 CONSTRAINT "PK_VCC" PRIMARY KEY ("ID_ANOTACION")
)';

   EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_MINIREC||'."VENTA_CARTERA_COMENTARIOS"."ENTIDAD" IS '' código propietario indicado por el fichero de venta de cartera''';
 
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_MINIREC||'."VENTA_CARTERA_COMENTARIOS"."NUMERO_EXP" IS ''NUMERO_EXP_NUSE de EXPEDIENTES''';
 
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_MINIREC||'."VENTA_CARTERA_COMENTARIOS"."ID_EXPEDIENTE" IS ''CD_EXPEDIENTE_NUSE de EXPEDIENTES ''';
 
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_MINIREC||'."VENTA_CARTERA_COMENTARIOS"."ID_ANOTACION" IS '' 	Identificador Decisión-Procedimiento ''';
 
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_MINIREC||'."VENTA_CARTERA_COMENTARIOS"."FECHA_ANOTACION" IS '' Fecha más reciente de la anotación ''';
 
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_MINIREC||'."VENTA_CARTERA_COMENTARIOS"."TITULO_ANOTACION" IS ''Identificacion Asunto original (migracion BANKIA FASE2)''';
 
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_MINIREC||'."VENTA_CARTERA_COMENTARIOS"."CODIGO_ANOTACION" IS ''Identificacion Asunto original (migracion BANKIA FASE2)''';
 
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_MINIREC||'."VENTA_CARTERA_COMENTARIOS"."EMPLEADO" IS '' Usuario DPR (USUARIOCREAR / USUARIOMODIFICAR , USAREMOS EL MÁS ACTUAL)''';
 
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_MINIREC||'."VENTA_CARTERA_COMENTARIOS"."GESTOR" IS '' Gestor del Asunto ''';
 
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_MINIREC||'."VENTA_CARTERA_COMENTARIOS"."ID_PROCEDI" IS '' ASU_ID_EXTERNO de ASUNTOS ''';
 
   EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_MINIREC||'."VENTA_CARTERA_COMENTARIOS"."TEXTO_LIBRE" IS '' DPR_COMETARIOS ''';
 


    DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| V_ESQUEMA_MINIREC ||'.VENTA_CARTERA_COMENTARIOS.. Tabla creada OK');


  end if;
  
  

 EXCEPTION

    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);

    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;

END;
/

EXIT;

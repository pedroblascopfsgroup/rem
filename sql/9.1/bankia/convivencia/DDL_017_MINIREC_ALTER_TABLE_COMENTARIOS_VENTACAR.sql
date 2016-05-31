--/*
--##########################################
--## AUTOR=RAFAEL ARACIL
--## FECHA_CREACION=20160223
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=BKREC-1786
--## PRODUCTO=NO
--## 
--## Finalidad: MODIFICAR TABLA COMENTARIOS_VENTA_CARTERA
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
    V_NUM_TABLAS NUMBER(16); /* Vble. para validar la existencia de una tabla.  */
    -- Otras variables

 BEGIN

 DBMS_OUTPUT.PUT_LINE('[START] Comprobamos si existen campos');

    select count(1) into V_NUM_TABLAS from ALL_TAB_COLUMNS where table_name = 'VENTA_CARTERA_COMENTARIOS' AND COLUMN_NAME = 'PRC_ID' ;
    if V_NUM_TABLAS = 0 then
        EXECUTE IMMEDIATE ' ALTER TABLE '|| V_ESQUEMA_MINIREC ||'.VENTA_CARTERA_COMENTARIOS ADD PRC_ID NUMBER(16,0)';
        DBMS_OUTPUT.PUT_LINE('COLUMNA '|| V_ESQUEMA_MINIREC ||'.VENTA_CARTERA_COMENTARIOS.PRC_ID añadida correctamente.');
	else
	  DBMS_OUTPUT.PUT_LINE('COLUMNA '|| V_ESQUEMA_MINIREC ||'.VENTA_CARTERA_COMENTARIOS.PRC_ID ya existente.');
    end if;

    select count(1) into V_NUM_TABLAS from ALL_TAB_COLUMNS where table_name = 'VENTA_CARTERA_COMENTARIOS' AND COLUMN_NAME = 'TIPO_TAR_DPR' ;
    if V_NUM_TABLAS = 0 then
        EXECUTE IMMEDIATE ' ALTER TABLE '|| V_ESQUEMA_MINIREC ||'.VENTA_CARTERA_COMENTARIOS ADD TIPO_TAR_DPR VARCHAR2(10 CHAR)';
        DBMS_OUTPUT.PUT_LINE('COLUMNA '|| V_ESQUEMA_MINIREC ||'.VENTA_CARTERA_COMENTARIOS.TIPO_TAR_DPR añadida correctamente.');
	else
	  DBMS_OUTPUT.PUT_LINE('COLUMNA '|| V_ESQUEMA_MINIREC ||'.VENTA_CARTERA_COMENTARIOS.TIPO_TAR_DPR ya existente.');
    end if;	  		  	



    select count(1) into V_NUM_TABLAS from ALL_CONSTRAINTS where CONSTRAINT_NAME = 'PK_VCC' AND TABLE_NAME = 'VENTA_CARTERA_COMENTARIOS' ;
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' ALTER TABLE '|| V_ESQUEMA_MINIREC ||'.VENTA_CARTERA_COMENTARIOS DROP CONSTRAINT PK_VCC';
        EXECUTE IMMEDIATE ' ALTER TABLE '|| V_ESQUEMA_MINIREC ||'.VENTA_CARTERA_COMENTARIOS ADD CONSTRAINT PK_VCC PRIMARY KEY (ID_ANOTACION, TIPO_TAR_DPR)';
        DBMS_OUTPUT.PUT_LINE('PK '|| V_ESQUEMA_MINIREC ||'.VENTA_CARTERA_COMENTARIOS.PK_VCC MODIFICADA correctamente.');
	else
EXECUTE IMMEDIATE ' ALTER TABLE '|| V_ESQUEMA_MINIREC ||'.VENTA_CARTERA_COMENTARIOS ADD CONSTRAINT PK_VCC PRIMARY KEY (ID_ANOTACION, TIPO_TAR_DPR)';
        DBMS_OUTPUT.PUT_LINE('PK '|| V_ESQUEMA_MINIREC ||'.VENTA_CARTERA_COMENTARIOS.PK_VCC añadida correctamente.');    end if;	  

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
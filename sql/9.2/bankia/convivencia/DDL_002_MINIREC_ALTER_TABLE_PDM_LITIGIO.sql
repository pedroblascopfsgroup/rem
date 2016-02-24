--/*
--##########################################
--## AUTOR=RAFAEL ARACIL
--## FECHA_CREACION=20160224
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=BKREC-1656
--## PRODUCTO=NO
--## 
--## Finalidad: AÑADIR CAMPOS FECHA_ACEPTACION Y FEHA_FIN_HITO_PRELITIGIO A LA TABLA RCV_GEST_PDM_LITIGIO
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

    select count(1) into V_NUM_TABLAS from ALL_TAB_COLUMNS where table_name = 'RCV_GEST_PDM_LITIGIO' AND COLUMN_NAME = 'FECHA_ACEPTACION' ;
    if V_NUM_TABLAS = 0 then
        EXECUTE IMMEDIATE ' ALTER TABLE '|| V_ESQUEMA_MINIREC ||'.RCV_GEST_PDM_LITIGIO ADD FECHA_ACEPTACION DATE';
        DBMS_OUTPUT.PUT_LINE('COLUMNA '|| V_ESQUEMA_MINIREC ||'.RCV_GEST_PDM_LITIGIO.FECHA_ACEPTACION añadida correctamente.');
	else
	  DBMS_OUTPUT.PUT_LINE('COLUMNA '|| V_ESQUEMA_MINIREC ||'.RCV_GEST_PDM_LITIGIO.FECHA_ACEPTACION ya existente.');
    end if;

    select count(1) into V_NUM_TABLAS from ALL_TAB_COLUMNS where table_name = 'RCV_GEST_PDM_LITIGIO' AND COLUMN_NAME = 'FECHA_FIN_HITO_PRELITIGIO' ;
    if V_NUM_TABLAS = 0 then
        EXECUTE IMMEDIATE ' ALTER TABLE '|| V_ESQUEMA_MINIREC ||'.RCV_GEST_PDM_LITIGIO ADD FECHA_FIN_HITO_PRELITIGIO DATE';
        DBMS_OUTPUT.PUT_LINE('COLUMNA '|| V_ESQUEMA_MINIREC ||'.RCV_GEST_PDM_LITIGIO.FECHA_FIN_HITO_PRELITIGIO añadida correctamente.');
	else
	  DBMS_OUTPUT.PUT_LINE('COLUMNA '|| V_ESQUEMA_MINIREC ||'.RCV_GEST_PDM_LITIGIO.FECHA_FIN_HITO_PRELITIGIO ya existente.');
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
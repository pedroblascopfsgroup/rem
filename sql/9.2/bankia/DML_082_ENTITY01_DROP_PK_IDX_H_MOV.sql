--/*
--##########################################
--## AUTOR=Rafael Aracil López
--## FECHA_CREACION=20160516
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2.5
--## INCIDENCIA_LINK=BKREC-2448
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUACIÓN EN H_MOV_MOVIMIENTOS
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE

    V_MSQL VARCHAR2(32000 CHAR); /* Sentencia a ejecutar    */
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; /* Configuracion Esquema*/
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; /* Configuracion Esquema Master*/
    V_TS_INDEX VARCHAR2(25 CHAR):= '#ESQUEMA#'; /* Configuracion Indice*/
    V_SQL VARCHAR2(4000 CHAR); /* Vble. para consulta que valida la existencia de una tabla.*/
    V_NUM_TABLAS NUMBER(16); /* Vble. para validar la existencia de una tabla.  */
    ERR_NUM NUMBER(25);  /* Vble. auxiliar para registrar errores en el script.*/
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.*/

    V_TEXT1 VARCHAR2(2400 CHAR); /* Vble. auxiliar*/

BEGIN
	
    DBMS_OUTPUT.PUT_LINE('[START] Actuacion en H_MOV_MOVIMIENTOS');	
	
		SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_constraints WHERE UPPER(constraint_name) = 'PK_H_MOV_MOVIMIENTOS' and UPPER(owner) = '' || V_ESQUEMA || '';
		
		IF V_NUM_TABLAS = 1 THEN
			EXECUTE IMMEDIATE 'alter table ' || V_ESQUEMA || '.H_MOV_MOVIMIENTOS drop constraint PK_H_MOV_MOVIMIENTOS';
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.H_MOV_MOVIMIENTOS modificado: PK eliminada');
		END IF;	
    
    V_NUM_TABLAS := 0;
	
		SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_indexes WHERE UPPER(INDEX_NAME) = 'PK_H_MOV_MOVIMIENTOS' and UPPER(owner) = '' || V_ESQUEMA || '';
		
		IF V_NUM_TABLAS = 1 THEN
			EXECUTE IMMEDIATE 'drop index ' || V_ESQUEMA || '.PK_H_MOV_MOVIMIENTOS';
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.H_MOV_MOVIMIENTOS modificado: indice borrado');
		END IF;			

    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');


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
	

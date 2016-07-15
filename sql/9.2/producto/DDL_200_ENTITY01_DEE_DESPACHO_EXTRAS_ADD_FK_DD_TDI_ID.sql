--/*
--##########################################
--## AUTOR=Rafael Aracil López
--## FECHA_CREACION=20160714
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2.6
--## INCIDENCIA_LINK=RECOVERY-998
--## PRODUCTO=NO
--## 
--## Finalidad: CAMBIAR PK DEE_DESPACHO_EXTRAS
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
    V_ESQUEMA_MINIREC VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; /* Configuracion Esquema Master*/
    V_TS_INDEX VARCHAR2(25 CHAR):= '#ESQUEMA#'; /* Configuracion Indice*/
    V_SQL VARCHAR2(4000 CHAR); /* Vble. para consulta que valida la existencia de una tabla.*/
    V_NUM_TABLAS NUMBER(16); /* Vble. para validar la existencia de una tabla.  */
    ERR_NUM NUMBER(25);  /* Vble. auxiliar para registrar errores en el script.*/
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.*/
   V_DDNAME VARCHAR2(50 CHAR):= 'DEE_DESPACHO_EXTRAS';
    V_TEXT1 VARCHAR2(2400 CHAR); /* Vble. auxiliar*/
     


    V_ENTIDAD_ID NUMBER(16);
    

BEGIN
	
    DBMS_OUTPUT.PUT_LINE('[START] AÑADIMOS FK EN DEE_DESPACHO_EXTRAS');	
	
		SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_constraints WHERE UPPER(constraint_name) = 'FK_DEE_TDI_ID' and UPPER(owner) = '' || V_ESQUEMA || '';
		
		IF V_NUM_TABLAS = 1 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DEE_DESPACHO_EXTRAS FK_DEE_TDI_ID YA EXISTE');
      
      ELSE
      
      EXECUTE IMMEDIATE 'ALTER TABLE '|| V_ESQUEMA ||'.DEE_DESPACHO_EXTRAS
      ADD CONSTRAINT FK_DEE_TDI_ID FOREIGN KEY  (DD_TDI_ID) REFERENCES '|| V_ESQUEMA ||'.DD_TDI_TIPO_DOCUMENTO_ID (DD_TDI_ID)';
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DEE_DESPACHO_EXTRAS modificado: PK CREADA');
		END IF;	
    
    V_NUM_TABLAS := 0;
	

    
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
	
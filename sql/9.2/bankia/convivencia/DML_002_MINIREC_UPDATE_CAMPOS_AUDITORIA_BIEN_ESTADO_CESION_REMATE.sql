--/*
--##########################################
--## AUTOR=Rafael Aracil López
--## FECHA_CREACION=20160701
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2.5
--## INCIDENCIA_LINK=RECOVERY-1794
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATEAMOS CAMPOS AUDITORIA
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
   V_DDNAME VARCHAR2(50 CHAR):= 'BIEN_ESTADO_CESION_REMATE';
    V_TEXT1 VARCHAR2(2400 CHAR); /* Vble. auxiliar*/
     
    
  
    

BEGIN
	
    DBMS_OUTPUT.PUT_LINE('[START] Completamos campos auditoría');	
	
		
            EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA_MINIREC||'.' || V_DDNAME|| ' 
            SET VERSION=0,USUARIOCREAR=''ETL_CESREM'',FECHACREAR=SYSDATE,BORRADO=0';  



    
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
	
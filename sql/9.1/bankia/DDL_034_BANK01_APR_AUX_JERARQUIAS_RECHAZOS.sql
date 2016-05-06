/*
--##########################################
--## AUTOR=Alejandro Iñigo
--## FECHA_CREACION=20160210
--## ARTEFACTO=ETL
--## VERSION_ARTEFACTO=1.00
--## INCIDENCIA_LINK=BKREC-1718
--## PRODUCTO=NO
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); /* Sentencia a ejecutar    */
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; /* Configuracion Esquema*/
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; /* Configuracion Esquema Master*/
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; /* Configuracion Indice*/
    V_SQL VARCHAR2(4000 CHAR); /* Vble. para consulta que valida la existencia de una tabla.*/
    V_NUM_TABLAS NUMBER(16); /* Vble. para validar la existencia de una tabla.  */
    ERR_NUM NUMBER(25);  /* Vble. auxiliar para registrar errores en el script.*/
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.*/

    V_TEXT1 VARCHAR2(2400 CHAR); /* Vble. auxiliar*/
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; /* Configuracion Esquema minirec*/
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; /* Configuracion Esquema recovery_bankia_dwh*/
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; /* Configuracion Esquema recovery_bankia_datastage*/
	
BEGIN

    /*  tabla APR_AUX_JERARQUIAS_RECHAZOS <-- ELIMINAR */

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla APR_AUX_JERARQUIAS_RECHAZOS');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'APR_AUX_JERARQUIAS_RECHAZOS';
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA ||'.APR_AUX_JERARQUIAS_RECHAZOS CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA ||'.APR_AUX_JERARQUIAS_RECHAZOS... Tabla borrada OK');
	else
	  DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA ||'.APR_AUX_JERARQUIAS_RECHAZOS... No existe');
    end if;
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| V_ESQUEMA ||'.APR_AUX_JERARQUIAS_RECHAZOS (
		ROWREJECTED      VARCHAR(1000 CHAR),
		ERRORCODE		 VARCHAR(255 CHAR),
		ERRORMESSAGE	 VARCHAR(255 CHAR),
        USUARIOCREAR     VARCHAR2(50 CHAR) NOT NULL,
        FECHACREAR       TIMESTAMP(6)      NOT NULL,
        USUARIOMODIFICAR VARCHAR2(50 CHAR),
        FECHAMODIFICAR   TIMESTAMP(6),		
		VERSION          INTEGER DEFAULT 0 NOT NULL,
		USUARIOBORRAR    VARCHAR2(50 CHAR),
		FECHABORRAR      TIMESTAMP(6)         ,
		BORRADO          NUMBER(1) DEFAULT 0 NOT NULL ) ' ;    
  		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.APR_AUX_JERARQUIAS_RECHAZOS... Tabla creada');				

    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit

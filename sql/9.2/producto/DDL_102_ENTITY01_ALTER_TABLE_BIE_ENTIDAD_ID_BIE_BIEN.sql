--/*
--##########################################
--## AUTOR=RAFAEL ARACIL LOPEZ
--## FECHA_CREACION=26-04-2016
--## ARTEFACTO=BIE_BIEN
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2286
--## PRODUCTO=NO
--## Finalidad: cAMBIO NOMBRE A BIE_ENTIDAD_ID
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE
    V_MSQL VARCHAR(32000);   
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

    
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  

BEGIN

dbms_output.enable(1000000);

--##########################################
--## BACKUP DE TABLAS DE BIENES
--##########################################

   DBMS_OUTPUT.PUT_LINE('********************' );
   DBMS_OUTPUT.PUT_LINE('**CAMBIO BIE_SAREB_ID A BIE_ENTIDAD_ID**' );
   DBMS_OUTPUT.PUT_LINE('********************' );
 
                
            DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBAMOS SI EXISTE EL CAMPO BIE_SAREB_ID EN LA TABLA BIE_BIEN');
                    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME=''BIE_SAREB_ID'' AND TABLE_NAME=''BIE_BIEN'' AND OWNER='''||V_ESQUEMA||'''';   
                   EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] EXISTE EL CAMPO, CAMBIAMOS EL NOMBRE DEL CAMPO POR BIE_ENTIDAD_ID');
                                 EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN RENAME COLUMN BIE_SAREB_ID TO BIE_ENTIDAD_ID';   

	ELSE

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE BIE_SAREB_ID, SEGUIMOS');

            DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBAMOS SI EXISTE EL CAMPO BIE_HAYA_ID EN LA TABLA BIE_BIEN');
                    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME=''BIE_HAYA_ID'' AND TABLE_NAME=''BIE_BIEN'' AND OWNER='''||V_ESQUEMA||'''';   
                   EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] EXISTE EL CAMPO, CAMBIAMOS EL NOMBRE DEL CAMPO POR BIE_ENTIDAD_ID');
                                 EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN RENAME COLUMN BIE_HAYA_ID TO BIE_ENTIDAD_ID';   

ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE BIE_HAYA_ID, SEGUIMOS');

            DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBAMOS SI EXISTE EL CAMPO BIE_ENTIDAD_ID EN LA TABLA BIE_BIEN');
                    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME=''BIE_ENTIDAD_ID'' AND TABLE_NAME=''BIE_BIEN'' AND OWNER='''||V_ESQUEMA||'''';   
                   EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] EXISTE BIE_ENTIDAD_ID');

ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE BIE_ENTIDAD_ID, LO CREAMOS');
                                 EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN ADD  BIE_ENTIDAD_ID VARCHAR2(20 CHAR)';   


END IF;
END IF;
  
		END IF;

                           

   COMMIT;   


   DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO' );



EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE( TO_CHAR(SQLCODE) || ' ' || SQLERRM );

 
END;
/
EXIT


SE


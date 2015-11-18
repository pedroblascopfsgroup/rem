--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20151013
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-451
--## PRODUCTO=NO
--## 
--## Finalidad: Informar correspondencia de IDs sin especificar , esquema #ESQUEMA#.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
  
      
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
   V_ESQUEMA          VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_MASTER   VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   err_num            NUMBER; -- Numero de errores
   err_msg            VARCHAR2(2048); -- Mensaje de error    
   V_MSQL             VARCHAR2(5000);
   V_GAL_ID           NUMBER(5);
   V_GRC_ID           NUMBER(5);

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';

                  
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   
   
BEGIN
                     

                     
    DBMS_OUTPUT.PUT_LINE('Obtenemos el id de GAL sin especificar');
    V_MSQL := 'SELECT GAL_ID 
               FROM '||V_ESQUEMA||'.GAL_GRUPO_ALERTA
               WHERE GAL_DESCRIPCION like ''%NO ESPECIFICADO%''';  
    
    EXECUTE IMMEDIATE V_MSQL INTO V_GAL_ID  ;
    
/*    SELECT GAL_ID INTO V_GAL_ID 
    FROM GAL_GRUPO_ALERTA
    WHERE GAL_DESCRIPCION like '%NO ESPECIFICADO%';  */
    
    
    DBMS_OUTPUT.PUT_LINE('Obtenemos el id de GRC sin especificar');
    V_MSQL := 'SELECT GRC_ID  
               FROM '||V_ESQUEMA||'.GRC_GRUPO_CARGA
               WHERE GRC_DESCRIPCION like ''%NO ESPECIFICADO%'''; 
    
    EXECUTE IMMEDIATE V_MSQL INTO V_GRC_ID;
      
/*   SELECT GRC_ID INTO V_GRC_ID 
               FROM GRC_GRUPO_CARGA
               WHERE GRC_DESCRIPCION like '%NO ESPECIFICADO%' */               
               
   /*****************************************************/
   /*** PENDIENTE CORRESPONDENCIA GAL_ID y GRC_ID  ******/
   /*****************************************************/   
   
   DBMS_OUTPUT.PUT_LINE('Actualizando TAL_TIPO_ALERTA......');

      V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAL_TIPO_ALERTA SET ' ||
                 ' GAL_ID ='||  V_GAL_ID || ',
                   GRC_ID ='||  V_GRC_ID ;
      
      EXECUTE IMMEDIATE V_MSQL;
   
   

   COMMIT;

EXCEPTION

WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
END;
/

EXIT;



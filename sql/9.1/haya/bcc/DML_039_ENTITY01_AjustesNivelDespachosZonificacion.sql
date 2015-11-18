--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20150921
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-532
--## PRODUCTO=NO
--## 
--## Finalidad: Se ajustan los valores por defecto del NIVEL_ID de la BBDD importada
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
  
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

   
BEGIN

    DBMS_OUTPUT.PUT_LINE('Se borran los registros de DES_DESPACHO_EXTERNO donde ZON_ID <> 12501');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DES_DESPACHO_EXTERNO WHERE ZON_ID <> 12501');
 
    
    DBMS_OUTPUT.PUT_LINE('Se updatea ZON_ZONIFICACION para poner el NIV_ID = 1 para ZON_ID = 12501');
    EXECUTE IMMEDIATE('UPDATE '|| V_ESQUEMA ||'.ZON_ZONIFICACION SET NIV_ID = 1 WHERE ZON_ID = 12501');
       


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

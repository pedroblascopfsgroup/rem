--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20151111
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-866
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de TABLAS DE DICCIONARIOS DE PLAZAS
--##                   
--##                               , esquema CM01. Con estructura correcta
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 GMN: Se incluye el código de plaza
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE



--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master 
 TABLADD1 VARCHAR(30) :='DD_PLA_PLAZAS'; 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);


BEGIN 

 
 --PLAZAS -- Actualizamos las plazas completando con 0 hasta 0  

      V_MSQL1 := 'UPDATE ' ||V_ESQUEMA|| '.'||TABLADD1||' 
                  SET DD_PLA_CODIGO = LPAD(DD_PLA_CODIGO,5,''0'')
                  WHERE LENGTH(DD_PLA_CODIGO) <6';

       
       EXECUTE IMMEDIATE V_MSQL1;
   

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

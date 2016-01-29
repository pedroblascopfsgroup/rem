--/*
--##########################################
--## AUTOR=ENRIQUE JIMENEZ
--## FECHA_CREACION=20151115
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-1124
--## PRODUCTO=NO
--## 
--## Finalidad: Elimina logicamente las plazas que no tienen Juzgado.
--## INSTRUCCIONES:  Debe de haberse ejecutado previamente el DML_324
--## VERSIONES:
--##        0.1 Versión inicial
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
 TABLADD1 VARCHAR(31) :='DD_JUZ_JUZGADOS_PLAZA'; 
 TABLADD2 VARCHAR(31) :='DD_PLA_PLAZAS';  
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL1 VARCHAR2(2500 CHAR);
 V_MSQL2 VARCHAR2(2500 CHAR); 
 V_MSQL3 VARCHAR2(2500 CHAR); 
 V_PLA_ID VARCHAR2(10 CHAR);  

 V_EXISTE NUMBER (1):=null;

BEGIN 

 DBMS_OUTPUT.PUT_LINE('Tras insertar Plazas/Juzgados, damos de baja logica las Plazas sin Juzgado');
       
 V_MSQL3 := 'UPDATE ' ||V_ESQUEMA|| '.'||TABLADD2||' PLAx SET PLAx.BORRADO = 1 
             WHERE PLAx.DD_PLA_ID IN (
                SELECT PLA.DD_PLA_ID
                FROM ' ||V_ESQUEMA|| '.DD_PLA_PLAZAS PLA
                 LEFT OUTER JOIN ' ||V_ESQUEMA|| '.DD_JUZ_JUZGADOS_PLAZA JUZ ON PLA.DD_PLA_ID = JUZ.DD_PLA_ID
                WHERE JUZ.DD_JUZ_ID IS NULL
             )';
 
 EXECUTE IMMEDIATE V_MSQL3;


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

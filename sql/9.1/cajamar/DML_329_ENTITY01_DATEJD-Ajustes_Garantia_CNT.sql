--/*
--##########################################
--## AUTOR=ENRIQUE JIMENEZ DIAZ 
--## FECHA_CREACION=20150810
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-1227
--## PRODUCTO=NO
--## 
--## Finalidad: Resolver los "0"s a la izquierda del Codigo de Garantia que imposibilita asignarla a Contratos.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## TABLAS AFECTADAS
--##	DD_GCN_GARANTIA_CONTRATO
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master 
 TABLADD1 VARCHAR(31) :='DD_GCN_GARANTIA_CONTRATO'; 
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL1 VARCHAR2(2500 CHAR);
 V_EXISTE NUMBER (1):=null;

BEGIN

 V_MSQL1 := 'UPDATE ' ||V_ESQUEMA|| '.'||TABLADD1||' gcn SET gcn.DD_GCN_CODIGO = TO_NUMBER(gcn.DD_GCN_CODIGO)';
 
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

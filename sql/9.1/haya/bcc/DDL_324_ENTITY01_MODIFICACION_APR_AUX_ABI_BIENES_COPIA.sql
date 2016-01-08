--/*
--##########################################
--## AUTOR=ENRIQUE JIMENEZ DIAZ 
--## FECHA_CREACION=20151130
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-1227
--## PRODUCTO=NO
--## 
--## Finalidad: Alteramos la precision de Superficie y Sup. Contruida para Bienes. 
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## TABLAS AFECTADAS
--##	APR_AUX_ABI_BIENES_COPIA
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE; -- Abortar en caso de error.

SET SERVEROUTPUT ON; 

DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master 
 TABLADD1 VARCHAR(31) :='APR_AUX_ABI_BIENES_COPIA'; 
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL1 VARCHAR2(2500 CHAR);
 V_EXISTE NUMBER (1):=null;

BEGIN

 V_MSQL1 := ' ALTER TABLE ' ||V_ESQUEMA|| '.APR_AUX_ABI_BIENES_COPIA MODIFY (
		  SUPERFICIE                   NUMBER(13,2),
		  SUPERFICIE_CONSTRUIDA        NUMBER(13,2)
		)';

 EXECUTE IMMEDIATE V_MSQL1;

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

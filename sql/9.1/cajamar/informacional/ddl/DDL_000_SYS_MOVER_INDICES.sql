--/*
--##########################################
--## AUTOR=Pedro S.
--## FECHA_CREACION=20160311
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=GC-XXXX
--## PRODUCTO=NO
--## 
--## Finalidad: MOVER INDICES A TABLASPACE
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30) :='D_CNT_ZONA';
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);


BEGIN 

  
  V_MSQL := '
  BEGIN
   FOR x IN (SELECT owner, index_name FROM dba_indexes where owner like ''RECOVERY_CM%'' and upper(index_type) = ''NORMAL'' and tablespace_name not in ('''|| ITABLE_SPACE ||''')) LOOP
        EXECUTE IMMEDIATE(''alter index  '' || x.owner || ''.'' || x.index_name || '' rebuild online tablespace '|| ITABLE_SPACE ||' parallel 2'');
   END LOOP;
  END;
';
 
  EXECUTE IMMEDIATE V_MSQL;

  DBMS_OUTPUT.PUT_LINE('INDICES MOVIDOS CORRECTAMENTE');


--Excepciones
          

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
EXIT

--/*
--##########################################
--## AUTOR=SERGIO HERNANDEZ
--## FECHA_CREACION=20160226
--## ARTEFACTO=BATCH
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=NINGUNA
--## PRODUCTO=NO
--## Finalidad: DML
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
 

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO] ANALIZE');
UTILES.analiza_esquema('HAYA02','100');
DBMS_OUTPUT.PUT_LINE('[FIN] ANALIZE');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT


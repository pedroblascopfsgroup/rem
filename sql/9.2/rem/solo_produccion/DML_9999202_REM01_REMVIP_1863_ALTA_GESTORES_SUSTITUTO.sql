--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20180913
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1863
--## PRODUCTO=NO
--##
--## Finalidad: Insertar gestor sustituto
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
   
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error;
    PL_OUTPUT VARCHAR2(20000 CHAR);
    OPERACION VARCHAR2(10 CHAR) := 'ALTA';

BEGIN


#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2(OPERACION, 'agonzaleza', 'egomez', '22/09/2018', '25/09/2018', PL_OUTPUT);
DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
 
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2(OPERACION, 'mfuentes', 'jtoro', '14/09/2018', '01/10/2018', PL_OUTPUT);
DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
 
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2(OPERACION, 'bmorant', 'egomezme', '13/09/2018', '16/09/2018', PL_OUTPUT);
DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);


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

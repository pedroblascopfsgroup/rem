--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20180731
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1440
--## PRODUCTO=NO
--##
--## Finalidad: Insertar gestor sustituto, alta, baja 
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

--baja

#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('BAJA', 'jhernandez', 'spalma', '11/07/2018', '30/09/2018', PL_OUTPUT);
 DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

--alta

#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2(OPERACION, 'jhernandez', 'emoreno', '01/08/2018', '31/08/2018', PL_OUTPUT);
 DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

--baja

#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('BAJA', 'alirola', 'emoreno', '01/08/2018', '21/08/2018', PL_OUTPUT);
 DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

--alta

#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2(OPERACION, 'alirola', 'mcumbreras', '01/08/2018', '20/08/2018', PL_OUTPUT);
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

--/*
--##########################################
--## AUTOR=Alejandro Valverde Herrera
--## FECHA_CREACION=20181105
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4704
--## PRODUCTO=NO
--##
--## Finalidad: EJECUCION SP ASIGNACION GESTORES ACTIVO
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
   
	  V_USUARIO VARCHAR2(3200);
	  PL_OUTPUT VARCHAR2(3200);
	  P_ACT_ID NUMBER;
	  P_ALL_ACTIVOS NUMBER;
	  P_CLASE_ACTIVO VARCHAR2(3200);


BEGIN	

  	REM01.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3('SP_AGA_V4', PL_OUTPUT, NULL, NULL, '02');

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

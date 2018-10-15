--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20180826
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1628
--## PRODUCTO=NO
--##
--## Finalidad: Comprador duplicado con distinto dni, borrar comprador y corregir dni
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1628';
    V_SQL VARCHAR2(4000 CHAR); 
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error;
    PL_OUTPUT VARCHAR2(20000 CHAR);

BEGIN


      V_SQL := 'UPDATE '||V_ESQUEMA||'.COM_COMPRADOR SET 
		  COM_DOCUMENTO = ''527372930H'' 
		, BORRADO = 1 
		, USUARIOBORRAR = '''||V_USUARIO||''' 
		, FECHABORRAR = SYSDATE  
		WHERE COM_ID = 109058 AND COM_DOCUMENTO = ''52737293H''';

      EXECUTE IMMEDIATE V_SQL;
		
      DBMS_OUTPUT.PUT_LINE('Se han borrado '||SQL%ROWCOUNT||' registros en COM_COMPRADOR');

      V_SQL := 'UPDATE '||V_ESQUEMA||'.COM_COMPRADOR SET 
		  COM_DOCUMENTO = ''52737293H'' 
		, USUARIOMODIFICAR = '''||V_USUARIO||''' 
		, FECHAMODIFICAR = SYSDATE  
		WHERE COM_ID = 109062 AND COM_DOCUMENTO = ''53737293H''';

      EXECUTE IMMEDIATE V_SQL;
		
      DBMS_OUTPUT.PUT_LINE('Se han actualizado '||SQL%ROWCOUNT||' registros en COM_COMPRADOR');

	

    COMMIT;


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

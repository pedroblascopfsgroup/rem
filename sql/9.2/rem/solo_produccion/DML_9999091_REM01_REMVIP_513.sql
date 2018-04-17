--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180416
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-513
--## PRODUCTO=NO
--##
--## Finalidad: Asignar presupuesto al activo
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    PL_OUTPUT VARCHAR2(32000 CHAR);
    
 BEGIN

	INSERT INTO REM01.ACT_PTO_PRESUPUESTO (PTO_ID,ACT_ID,EJE_ID,PTO_IMPORTE_INICIAL,PTO_FECHA_ASIGNACION,VERSION,
                                      USUARIOCREAR,FECHACREAR,BORRADO)
	SELECT 
	  REM01.S_ACT_PTO_PRESUPUESTO.NEXTVAL,
	  ACT.ACT_ID,
	  EJE.EJE_ID,
	  50000,
	  SYSDATE,
	  0,
	  'REMVIP-513',
	  SYSDATE,
	  0
	  FROM REM01.ACT_ACTIVO ACT
	  INNER JOIN REM01.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ANYO = 2018
	  WHERE ACT.ACT_NUM_ACTIVO = 6967692;

    DBMS_OUTPUT.PUT_LINE('Registro insertado correctamente');
    
   COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

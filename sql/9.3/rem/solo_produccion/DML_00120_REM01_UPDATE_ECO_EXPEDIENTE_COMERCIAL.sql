--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20190121
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-7076
--## PRODUCTO=NO
--##
--## Finalidad: Modificar fecha ingreso cheque de expediente
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
    --V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-7076';

 BEGIN


  EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
	  					   ECO_FECHA_CONT_PROPIETARIO = null
	  					 , DD_EEC_ID = 3
						 , USUARIOMODIFICAR = '''||V_USUARIO||'''
						 , FECHAMODIFICAR = SYSDATE
					 WHERE OFR_ID IN (SELECT OFR_ID FROM OFR_OFERTAS WHERE OFR_NUM_OFERTA IN (
					                    90236851,
                                        90243364,
                                        90236426,
                                        90244138,
                                        90247516,
                                        90242612,
                                        90243028,
                                        90236336,
                                        90242972,
                                        90243384,
                                        90238745,
                                        90239887,
                                        90238984,
                                        90240014,
                                        90244434,
                                        90243386,
                                        90242953,
                                        90248182,
                                        90241486,
                                        90243893,
                                        90244417,
                                        90247501,
                                        90232316,
                                        90239875,
                                        90245239,
                                        90245445,
                                        90241845,
                                        90247841,
                                        90243553,
                                        90241806,
                                        90247658,
                                        90242383,
                                        90240060,
                                        90239890,
                                        90247377,
                                        90244318,
                                        90241953))
  					';

	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);

 COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;
END;
/
EXIT;
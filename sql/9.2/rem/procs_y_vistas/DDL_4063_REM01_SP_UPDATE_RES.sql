--/*
--##########################################
--## AUTOR=Guillermo Llidó
--## FECHA_CREACION=20180618
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1076
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--## 		0.2 Se elimina la fecha firma y se comprueba por código
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE #ESQUEMA#.UPDATE_RES
   (  ECO_NUM_EXPEDIENTE IN NUMBER
    , RES_NUM_RESERVA IN NUMBER
	, DD_ERE_CODIGO IN VARCHAR2
    , USUARIO_MODIFICAR VARCHAR2
	, PL_OUTPUT OUT VARCHAR2
   )

   AS

   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   DESCRIPCION VARCHAR2(150 CHAR); -- Descripción del estado de la reserva
   V_AUX NUMBER(1); -- Variable auxiliar

/*
ESTADOS DE LA RESERVA    Código Descripción
                            01	Pendiente firma
                            02	Firmada
                            03	Resuelta
                            04	Anulada
                            05	Pendiente de devolución
                            06	Resuelta. Importe devuelto
                            07	Resuelta. Posible reintegro
                            08	Resuelta. Importe reintegrado
*/

BEGIN

	IF DD_ERE_CODIGO IS NOT NULL THEN
        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = '''||DD_ERE_CODIGO||'''' INTO V_AUX;
        
        IF V_AUX > 0 THEN
            EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.RES_RESERVAS RES
                                    INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON RES.ECO_ID = ECO.ECO_ID AND ECO.BORRADO = 0
                                WHERE RES_NUM_RESERVA = '||RES_NUM_RESERVA||' AND ECO.ECO_NUM_EXPEDIENTE = '||ECO_NUM_EXPEDIENTE||' AND RES.BORRADO = 0' INTO V_AUX;

            IF V_AUX > 0 THEN
                EXECUTE IMMEDIATE 'SELECT DD_ERE_DESCRIPCION FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = '''||DD_ERE_CODIGO||'''' INTO DESCRIPCION;
                
                V_SQL := 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS 
                            SET DD_ERE_ID = (SELECT DD_ERE_ESTADOS_RESERVA.DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_ESTADOS_RESERVA.BORRADO = 0 AND DD_ERE_CODIGO ='''||DD_ERE_CODIGO||''')
                                ,USUARIOMODIFICAR = '''||USUARIO_MODIFICAR||'''
                                ,FECHAMODIFICAR = SYSDATE 
                            WHERE BORRADO = 0 AND RES_NUM_RESERVA = '||RES_NUM_RESERVA||' AND ECO_ID IN (SELECT ECO.ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
                                                                                            WHERE ECO.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||ECO_NUM_EXPEDIENTE||')';
                                                                                            
                EXECUTE IMMEDIATE V_SQL;
                
                PL_OUTPUT := '[INFO] Actualizado el estado de la reserva  '||RES_NUM_RESERVA||' a '||DESCRIPCION||' asociado al expediente '||ECO_NUM_EXPEDIENTE||' ';

            ELSE
                PL_OUTPUT := '[ERROR] No existe una reserva en la tabla RES_RESERVAS con el código '||RES_NUM_RESERVA||' ';
            END IF;

        ELSE 
            PL_OUTPUT := '[ERROR] El código '''||DD_ERE_CODIGO||''' no existe en la tabla DD_ERE_ESTADOS_RESERVA';
        END IF;

    ELSE 
        PL_OUTPUT := '[ERROR] No se ha informado correctamente del campo DD_ERE_CODIGO ';
	END IF;


COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END UPDATE_RES;
/
EXIT;

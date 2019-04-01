--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190227
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3401
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-3401'; -- USUARIOCREAR/USUARIOMODIFICAR
    
BEGIN	

		DBMS_OUTPUT.PUT_LINE('[INFO] Se van a actualizar los datos del propietario de los activos Galeon incorrectos ');

        V_MSQL :=   '
			UPDATE '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO
			SET PRO_ID = ( SELECT PRO_ID
			               FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO
			               WHERE PRO.DD_CRA_ID = ( SELECT DD_CRA_ID
                                       				FROM '||V_ESQUEMA||'.DD_CRA_CARTERA
			                                       WHERE DD_CRA_CODIGO = ''15''
			                                     )
			             ),
			    USUARIOMODIFICAR = ''REMVIP-3401'',
			    FECHAMODIFICAR   = SYSDATE
			WHERE 1 = 1
			AND EXISTS ( SELECT 1
			             FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
			             WHERE 1 = 1
			             AND ACT_PAC_PROPIETARIO_ACTIVO.ACT_ID = ACT.ACT_ID
			             AND ACT.ACT_NUM_ACTIVO IN (
			                                            6971703,
			                                            6971705,
			                                            6972447,
			                                            6972893,
			                                            6976431,
			                                            7004016,
			                                            6136650
			                                        )
			              AND ACT.DD_CRA_ID = ( SELECT DD_CRA_ID
			                                    FROM '||V_ESQUEMA||'.DD_CRA_CARTERA
			                                    WHERE DD_CRA_CODIGO = ''15''
			                                  )
			             ) ';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[FIN] Propietario actualizado correctamente.');
        
        COMMIT;
  
EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;          

END;

/

EXIT

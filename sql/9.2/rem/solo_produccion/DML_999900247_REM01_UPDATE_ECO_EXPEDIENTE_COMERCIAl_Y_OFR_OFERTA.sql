--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20180222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-124
--## PRODUCTO=NO
--##
--## Finalidad: Cambiar la incidencia de que el activo aparece como vendido pero no lo está
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
    V_TABLA VARCHAR2(27 CHAR):= 'ECO_EXPEDIENTE_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-124';

 BEGIN
  
  EXECUTE IMMEDIATE 'UPDATE empleados
                        SET orden = CASE id_empleado
                            WHEN 12 THEN 1
                            WHEN 254 THEN 4
                            WHEN 87 THEN 8
                            WHEN 23 THEN 14
                        END,
                        edad = CASE id_empleado
                            WHEN 12 THEN 32
                            WHEN 254 THEN 19
                            WHEN 87 THEN 43
                            WHEN 23 THEN 51
                        END
                            WHERE id_empleado IN (12, 254, 87, 23)
';


  					
  EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS SET
	  					   DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''01'')
						 , AGR_ID = NULL
						 , USUARIOMODIFICAR = '''||V_USUARIO||'''
						 , FECHAMODIFICAR = SYSDATE
					 WHERE OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.'||V_TABLA||'
					 WHERE ECO_NUM_EXPEDIENTE = 17451)
  					';
  					
  DBMS_OUTPUT.PUT_LINE('[INFO] Cancelada la venta por error del activo 6077839 y reposicionado a Posicionamiento y firma');
 
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


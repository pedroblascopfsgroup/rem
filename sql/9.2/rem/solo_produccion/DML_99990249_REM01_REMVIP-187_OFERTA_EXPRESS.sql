--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20180301
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-187
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar el campo OFR_OFERTAS_EXPRESS nulos a 0
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
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'OFR_OFERTAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-187';
	V_ACT_ID_HAYA VARCHAR2(32 CHAR);
	
    
 BEGIN
   		
		
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
		   OFR_OFERTA_EXPRESS = 0
	 	 , USUARIOMODIFICAR = '''||V_USUARIO||'''
		 , FECHAMODIFICAR = SYSDATE
		 WHERE OFR_OFERTA_EXPRESS IS NULL';

		 EXECUTE IMMEDIATE V_SQL;
		 DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICADO: '||SQL%ROWCOUNT);
		

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

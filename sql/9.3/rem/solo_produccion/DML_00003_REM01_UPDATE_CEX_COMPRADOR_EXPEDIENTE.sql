--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20191017
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-4946
--## PRODUCTO=NO
--## Finalidad:
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(24 CHAR):= 'REMVIP-4946'; -- Usuario modificar
	V_SQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar

    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error
   
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := 'UPDATE '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE CEX 
					SET CEX.DD_PAI_ID = (SELECT DD_PAI_ID FROM '||V_ESQUEMA||'.DD_PAI_PAISES WHERE DD_PAI_CODIGO = ''55'')
				WHERE CEX.COM_ID = (SELECT COM_ID FROM '||V_ESQUEMA||'.COM_COMPRADOR COM WHERE COM_DOCUMENTO = ''24306884R'')';
	EXECUTE IMMEDIATE V_SQL;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');

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

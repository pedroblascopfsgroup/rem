--/*
--###########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20181106
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-9999
--## PRODUCTO=NO
--## 
--## Finalidad: Creacion de Usuarios REM
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


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
  
BEGIN	

DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PEF_PERFILES (PEF_ID, PEF_DESCRIPCION_LARGA, PEF_DESCRIPCION, USUARIOCREAR, FECHACREAR, PEF_CODIGO)
		VALUES
		(S_PEF_PERFILES.NEXTVAL, ''Perfil de carga masiva Venta Cartera'', ''Perfil de carga masiva Venta Cartera'', ''REMVIP-2455'', SYSDATE, ''PMSVVC'');';

	#ESQUEMA#.SP_PERFILADO_FUNCIONES('REMVIP-2455');
    
   COMMIT;
   
DBMS_OUTPUT.PUT_LINE('[FIN]');
 

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

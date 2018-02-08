--/*
--###########################################
--## AUTOR=CARLOS LOPEZ
--## FECHA_CREACION=20180208
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMNIVDOS-3683
--## PRODUCTO=NO
--## 
--## Finalidad: Borrar ACT_AGA_AGRUPACION_ACTIVO
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
  V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  V_USU_NUEVO NUMBER(16); -- Vble. para validar la existencia de un usuario.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO WHERE BORRADO = 1 ';
	EXECUTE IMMEDIATE V_MSQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] BORRADOS: '||SQL%ROWCOUNT||' REGISTROS EN ACT_AGA_AGRUPACION_ACTIVO.');
	
	DBMS_OUTPUT.PUT_LINE('[FIN]  PROCESO FINALIZADO CORRECTAMENTE ');

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

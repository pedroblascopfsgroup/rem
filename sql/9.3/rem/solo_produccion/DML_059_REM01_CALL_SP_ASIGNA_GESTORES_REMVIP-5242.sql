--/*
--###########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20190916
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5242
--## PRODUCTO=NO
--## 
--## Finalidad: asignar gestores a 3 activos
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
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-5242';
  PL_OUTPUT VARCHAR2(32000 CHAR);

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	#ESQUEMA#.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3(''||V_USUARIO||'', PL_OUTPUT, 421870, NULL, '02');
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
	#ESQUEMA#.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3(''||V_USUARIO||'', PL_OUTPUT, 421873, NULL, '02');
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT); 
	#ESQUEMA#.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3(''||V_USUARIO||'', PL_OUTPUT, 421871, NULL, '02');
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT); 

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
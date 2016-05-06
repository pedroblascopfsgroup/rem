--/*
--##########################################
--## AUTOR=Joaquín Sánchez Valverde
--## FECHA_CREACION=20160504
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=CMREC-3256
--## PRODUCTO=NO
--## Finalidad: DML Soluciona CMREC-3256
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- 'CM01'; Configuracion Esquema este caso haya01
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; --'CMMASTER'; -- Configuracion Esquema Master este caso hayamaster
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
	V_AUXILIAR VARCHAR2(200 CHAR); -- Vble. auxiliar en este caso peticion o nombre del sql
    V_TABLA VARCHAR2(50 CHAR); -- Vble. Tabla con la que trabajamos.
	V_Campo VARCHAR2(50 CHAR);--Campo de búsqueda.
	V_Valor VARCHAR2(1000 CHAR);--Valor buscado.

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO PROCEDIMIENTO]******** Soluciona_CMREC-3256 ********'); 
	
	V_AUXILIAR := 'CMREC-3256'; --identificador del item que soluciona o nombre del sql.
	
	V_TABLA := 'usu_usuarios';
	V_CAMPO := 'usu_username';
	V_VALOR := 'lmp5361';
	
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.' || V_TABLA || ' WHERE ' || V_Campo || '= '''||V_Valor||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	DBMS_OUTPUT.PUT_LINE (V_SQL);
	IF V_NUM_TABLAS < 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] No existen el registro con valor:'''||V_Valor||''' en la tabla '||V_ESQUEMA||'.' ||V_TABLA);
	ELSE
		--eliminamos zonificacion
		V_MSQL := 'delete from '||V_ESQUEMA||'.zon_pef_usu zpu where zpu.usu_id = (SELECT usu.usu_id FROM CMmaster.usu_usuarios usu WHERE usu.usu_username = ''' || V_Valor || ''' )' ||
				'and zpu.zon_id != (SELECT MAX(zon.zon_id) FROM '|| V_ESQUEMA || '.zon_zonificacion zon WHERE zon.ZON_NUM_CENTRO =''03058019804'')'
		;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE (V_MSQL);		
	    --eliminamos zonificacion duplicada
		V_MSQL := 'delete from '||V_ESQUEMA||'.zon_pef_usu zpu where zpu.ZPU_ID = (select min(zpu.ZPU_ID) from '|| V_ESQUEMA || '.zon_pef_usu zpu where zpu.usu_id = (SELECT usu.usu_id FROM '|| 
				V_ESQUEMA_M || '.usu_usuarios usu WHERE usu.usu_username =  ''' || V_Valor || ''' )' ||
				'and zpu.zon_id = (SELECT MAX(zon.zon_id) FROM '|| V_ESQUEMA || '.zon_zonificacion zon WHERE zon.ZON_NUM_CENTRO =''03058019804'')) '
		;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE (V_MSQL);
	END IF;

	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN PROCEDIMIENTO]******** Soluciona_CMREC-3256  ********'); 

	EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
	DBMS_OUTPUT.put_line('[ERROR PROCEDIMIENTO]----------- Soluciona_CMREC-3256  -----------');
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('[FIN PROCEDIMIENTO]------------- Soluciona_CMREC-3256  -----------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
    
END;
/

EXIT;
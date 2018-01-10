--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180110
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3594
--## PRODUCTO=NO
--## Finalidad: Borrar las cargas de REM correspondientes a activos de cartera SAREB.
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

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TABLA_1 VARCHAR2(50 CHAR):= 'ACT_CRG_CARGAS';
    V_TABLA_2 VARCHAR2(50 CHAR):= 'BIE_CAR_CARGAS';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  
    
BEGIN
	 
    DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de borrado de las cargas de REM correspondientes a la cartera de SAREB');
    
    V_SQL := ' SELECT COUNT(1) FROM (
			select 1 from '||V_ESQUEMA||'.BIE_CAR_CARGAS car
			join '||V_ESQUEMA||'.ACT_CRG_CARGAS crg on CRG.BIE_CAR_ID=CAR.BIE_CAR_ID
			join '||V_ESQUEMA||'.ACT_ACTIVO act on act.act_id=CRG.ACT_ID
			join '||V_ESQUEMA||'.DD_CRA_CARTERA cra on cra.dd_cra_id=act.dd_cra_id
			join PFSREM.aux_cargas_canyon_ultimate last on last.BIE_ID=act.ACT_RECOVERY_ID
			left join '||V_ESQUEMA||'.DD_ODT_ORIGEN_DATO odt on odt.dd_odt_id=crg.dd_odt_id
			where 
			CRA.DD_CRA_CODIGO=''02''
			and 
			(dd_odt_codigo=''02'' or dd_odt_codigo is null)
			and crg.borrado=0
			and car.borrado=0
			and car.BIE_CAR_ID_RECOVERY is  null
			GROUP BY CRG.CRG_ID)';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_1||'... PROCEDEMOS A BORRAR '||V_NUM_TABLAS||' REGISTROS');
		
		V_SQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA_1||' CRG1 WHERE CRG1.CRG_ID IN(
					select distinct CRG.CRG_ID from '||V_ESQUEMA||'.BIE_CAR_CARGAS car
					join '||V_ESQUEMA||'.'||V_TABLA_1||' crg on CRG.BIE_CAR_ID=CAR.BIE_CAR_ID
					join '||V_ESQUEMA||'.ACT_ACTIVO act on act.act_id=CRG.ACT_ID
					join '||V_ESQUEMA||'.DD_CRA_CARTERA cra on cra.dd_cra_id=act.dd_cra_id
					join aux_cargas_canyon_ultimate last on last.BIE_ID=act.ACT_RECOVERY_ID
					left join '||V_ESQUEMA||'.DD_ODT_ORIGEN_DATO odt on odt.dd_odt_id=crg.dd_odt_id
					where 
					CRA.DD_CRA_CODIGO=''02''
					and 
					(dd_odt_codigo=''02'' or dd_odt_codigo is null)
					and crg.borrado=0
					and car.borrado=0
					and car.BIE_CAR_ID_RECOVERY is  null)';
        EXECUTE IMMEDIATE V_SQL; 
        
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_1||'... SE HAN BORRADO CORRECTAMENTE '||SQL%ROWCOUNT||' REGISTROS');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TABLA_1||'... NO HAY REGISTROS QUE BORRAR');
	END IF;
	
	
    V_SQL := 'select count(1) from PFSREM.AUX_CARGAS_BORRAR_ULTIMATE car';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_2||'... PROCEDEMOS A BORRAR '||V_NUM_TABLAS||' REGISTROS');
		
		V_SQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA_2||' CAR1 WHERE CAR1.BIE_CAR_ID IN( 
					SELECT BIE_CAR_ID FROM PFSREM.AUX_CARGAS_BORRAR_ULTIMATE)';
        EXECUTE IMMEDIATE V_SQL; 
        
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_2||'... SE HAN BORRADO CORRECTAMENTE '||SQL%ROWCOUNT||' REGISTROS');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TABLA_2||'... NO HAY REGISTROS QUE BORRAR');
	END IF;
	DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de borrado de las cargas de REM correspondientes a la cartera de SAREB a finalizado correctamente');
	
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

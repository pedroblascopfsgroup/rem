--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20221010
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11287
--## PRODUCTO=NO
--## 
--## Finalidad: Crear vista para obtener el precio maximo VPO de los activos
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 [REMVIP-11287] Versión inicial (Creación de la vista)
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE    
    ERR_NUM NUMBER; -- Numero de error
    ERR_MSG VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';
    V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';
    V_MSQL VARCHAR2(4000 CHAR); 
    V_TABLA VARCHAR2(100 CHAR):= 'VI_PRECIO_MAX_VPO_ACTIVO';
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('CREATE OR REPLACE VIEW '|| V_ESQUEMA ||'.'||V_TABLA||'...');
    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.'||V_TABLA||' 
                AS    
                    SELECT DISTINCT ACT.ACT_ID, NVL(ADM_PRECIO_MAX_VENTA, ADM_MAX_PRECIO_VENTA) AS PRECIO_MAX_VPO
                    FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                    JOIN '|| V_ESQUEMA ||'.ACT_ADM_INF_ADMINISTRATIVA ADM ON ADM.ACT_ID = ACT.ACT_ID AND ADM.BORRADO = 0
                    WHERE ACT.BORRADO = 0';

    IF V_ESQUEMA_M != V_ESQUEMA THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_M||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_M||''); 

	END IF;

	IF V_ESQUEMA_3 != V_ESQUEMA THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_3||''); 

	END IF;

	IF V_ESQUEMA_4 != V_ESQUEMA THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_4||''); 

	END IF;
        
DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.'||V_TABLA||'...Creada OK');
  
EXCEPTION
    WHEN OTHERS THEN
         ERR_NUM := SQLCODE;
         ERR_MSG := SQLERRM;

         DBMS_OUTPUT.PUT_LINE('KO no modificada');
         DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
         DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
         DBMS_OUTPUT.PUT_LINE(ERR_MSG);

         ROLLBACK;
         RAISE;   
		 
END;
/

EXIT;

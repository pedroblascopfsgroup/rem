--/*
--######################################### 
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20201127
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8417
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar webcom_id
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8417'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_ICO_INFO_COMERCIAL'; --Vble. auxiliar para almacenar la tabla a insertar
    

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
 
   	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN ACT_ICO_INFO_COMRCIAL');
            
                
        V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL T1 USING (
			SELECT DISTINCT ICO.ICO_ID, AUX.ICO_WEBCOM_ID
			FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO 
			INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID
			INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_8417 AUX ON AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO 
			WHERE ICO.ICO_WEBCOM_ID IS NULL) T2
		ON (T1.ICO_ID = T2.ICO_ID) 
		WHEN MATCHED THEN UPDATE SET 
		    T1.ICO_WEBCOM_ID = T2.ICO_WEBCOM_ID,
		    T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
		    T1.FECHAMODIFICAR = SYSDATE';
                
        EXECUTE IMMEDIATE V_SQL;
    
    
        DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS EN ACT_ICO_INFO_COMERCIAL');  

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
EXIT

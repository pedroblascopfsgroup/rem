--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20200929
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8154
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Dar de baja agrupaciones que no tengan ofertas asociadas que hayan sido creadas desde CRM
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8154'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_AGR_AGRUPACION'; --Vble. auxiliar para almacenar la tabla a actualizar
    V_TABLA_OFERTAS VARCHAR2(100 CHAR) :='OFR_OFERTAS'; --Vble. auxiliar para almacenar la tabla a consultar
    
    
	
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar
    
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente


    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN '||V_TABLA||' ');

    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 
            USING(	
                SELECT AGR.AGR_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' AGR
                WHERE AGR.USUARIOCREAR=''REST-USER''
                AND AGR.AGR_FECHA_BAJA IS NULL 
                AND AGR.AGR_ID NOT IN(
                SELECT AGR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_OFERTAS||' WHERE AGR_ID IS NOT NULL)
                ) T2
                ON (T1.AGR_ID = T2.AGR_ID)
            WHEN MATCHED THEN UPDATE SET		 
            T1.AGR_FECHA_BAJA = SYSDATE,		   		     
            T1.FECHAMODIFICAR = SYSDATE,
            T1.USUARIOMODIFICAR = '''||V_USUARIO||'''';
                        
                EXECUTE IMMEDIATE V_SQL;             
               
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros '); 
       

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
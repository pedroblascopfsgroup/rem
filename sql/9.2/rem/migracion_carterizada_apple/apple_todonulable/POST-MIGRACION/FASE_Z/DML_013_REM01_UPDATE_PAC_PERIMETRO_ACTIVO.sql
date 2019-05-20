--/*
--######################################### 
--## AUTOR=Albert Pastor
--## FECHA_CREACION=20190324
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5773
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- #ESQUEMA_MASTER#
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); --Vble .aux para almacenar el valor de la sequencia
    V_NUM_MAXID NUMBER(16); --Vble .aux para almacenar el valor maximo...
    V_USU VARCHAR2(50 CHAR) := 'MIG_APPLE'; 
    V_TABLA VARCHAR2(30 CHAR);
    
BEGIN
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizamos '||V_TABLA||'');
    

	V_MSQL :=  'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO T1
				USING (
					SELECT ACT.ACT_ID,
						   PAC.PAC_ID
					FROM '||V_ESQUEMA||'.ACT_ACTIVO              		ACT
					LEFT JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO  PAC ON PAC.ACT_ID = ACT.ACT_ID
					WHERE ACT.USUARIOCREAR = ''MIG_APPLE''
				) T2
				ON (T1.PAC_ID = T2.PAC_ID)
				WHEN MATCHED THEN UPDATE SET
					 T1.PAC_INCLUIDO = 0
					,T1.PAC_CHECK_TRA_ADMISION = NULL
					,T1.PAC_FECHA_TRA_ADMISION = NULL
					,T1.PAC_MOTIVO_TRA_ADMISION = NULL
					,T1.PAC_CHECK_GESTIONAR = NULL
					,T1.PAC_FECHA_GESTIONAR = NULL
					,T1.PAC_MOTIVO_GESTIONAR = NULL
					,T1.PAC_CHECK_ASIGNAR_MEDIADOR = NULL
					,T1.PAC_FECHA_ASIGNAR_MEDIADOR = NULL
					,T1.PAC_MOTIVO_ASIGNAR_MEDIADOR = NULL
					,T1.PAC_CHECK_COMERCIALIZAR = NULL
					,T1.PAC_FECHA_COMERCIALIZAR = NULL
					,T1.DD_MCO_ID = NULL
					,T1.PAC_CHECK_FORMALIZAR = NULL
					,T1.PAC_FECHA_FORMALIZAR = NULL
					,T1.PAC_MOTIVO_FORMALIZAR = NULL
					,T1.PAC_MOT_EXCL_COMERCIALIZAR = NULL
					,T1.PAC_CHECK_PUBLICAR = NULL
					,T1.PAC_FECHA_PUBLICAR = NULL
					,T1.PAC_MOTIVO_PUBLICAR = NULL
				WHEN NOT MATCHED THEN 
				INSERT (T1.PAC_ID,T1.ACT_ID,T1.PAC_INCLUIDO,T1.USUARIOCREAR,T1.FECHACREAR,T1.BORRADO)
				VALUES (
					 '||V_ESQUEMA||'.S_ACT_PAC_PERIMETRO_ACTIVO.NEXTVAL
					,T2.ACT_ID
					,0
					,''MIG_APPLE''
					,SYSDATE
					,0
				)
	';		

    EXECUTE IMMEDIATE V_MSQL; 
    V_NUM_TABLAS := SQL%ROWCOUNT;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||V_NUM_TABLAS||' registros en la tabla '||V_TABLA||''); 
    
    COMMIT;


    DBMS_OUTPUT.PUT_LINE('[FIN]');    

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    err_num := SQLCODE;
    err_msg := SQLERRM;
    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    
    ROLLBACK;
    RAISE;          

END;


/

EXIT;

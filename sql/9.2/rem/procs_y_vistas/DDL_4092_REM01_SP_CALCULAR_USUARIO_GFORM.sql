--/*
--##########################################
--## AUTOR=IKER ADOT
--## FECHA_CREACION=20190516
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6417
--## PRODUCTO=NO
--## Finalidad: DDL para crear un SP para obtener el usuario que debe ser gestor de formalización (GFORM) de un expediente comercial dado un activo concreto.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE #ESQUEMA#.SP_CALCULAR_USUARIO_GFORM (P_ACT_ID IN NUMBER) AUTHID CURRENT_USER AS		

	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    		
	ACTIVO NUMBER(16);
	USUARIO NUMBER(16);
	P_USERNAME VARCHAR2(50 CHAR);
	P_DD_CRA_CODIGO NUMBER(16);
	P_DD_PRV_CODIGO NUMBER(16);
	P_DD_SCR_CODIGO NUMBER(16);	
	v_UsuarioCrear varchar2(50 char):='SP_CALCULAR_USUARIO_GFORM2';
    nDD_TGE_ID NUMBER(16);
    nSEQ_GEE NUMBER(16);
    nSEQ_GEH NUMBER(16);
    nExiste NUMBER(16);	
	vHacerUpdate VARCHAR2(10 CHAR):= 'S';
	nPAC_CHECK_FORMALIZAR NUMBER(1);
	
	BEGIN
	
		BEGIN
          SELECT NVL(PAC_CHECK_FORMALIZAR,0)
            INTO nPAC_CHECK_FORMALIZAR
            FROM #ESQUEMA#.ACT_PAC_PERIMETRO_ACTIVO PAC
           WHERE PAC.ACT_ID = P_ACT_ID
             AND PAC.BORRADO = 0;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            nPAC_CHECK_FORMALIZAR := 0; 
        END;
        
        IF nPAC_CHECK_FORMALIZAR = 1 THEN
		
			--DBMS_OUTPUT.PUT_LINE('INICIO');			
			INSERT INTO #ESQUEMA#.AUX_BALANCEO_GFORM (USERNAME, DD_CRA_CODIGO, DD_SCR_CODIGO, DD_PRV_CODIGO, ASIGNADO)
			SELECT V.USERNAME, V.DD_CRA_CODIGO, V.DD_SCR_CODIGO, V.DD_PRV_CODIGO, 0 ASIGNADO 
			FROM #ESQUEMA#.V_GESTORES_ACTIVO V
			LEFT JOIN #ESQUEMA#.AUX_BALANCEO_GFORM AUX ON AUX.DD_CRA_CODIGO = V.DD_CRA_CODIGO 
													  AND NVL(AUX.DD_PRV_CODIGO,0) = NVL(V.DD_PRV_CODIGO,0) 
													  AND AUX.USERNAME = V.USERNAME 
													  AND NVL(AUX.DD_SCR_CODIGO,0) = NVL(V.DD_SCR_CODIGO,0)
			WHERE V.ACT_ID = P_ACT_ID 
			  AND V.TIPO_GESTOR = 'GFORM'
			  AND AUX.USERNAME IS NULL;
	 
			--DBMS_OUTPUT.PUT_LINE('INSERT FINALIZADO'); 
			DELETE 
			  FROM #ESQUEMA#.AUX_BALANCEO_GFORM AUX
			 WHERE NOT EXISTS (SELECT 1
								 FROM #ESQUEMA#.ACT_GES_DIST_GESTORES V
								WHERE AUX.DD_CRA_CODIGO = V.COD_CARTERA 
								  AND NVL(AUX.DD_PRV_CODIGO,0) = NVL(V.COD_PROVINCIA,0) 
								  AND AUX.USERNAME = V.USERNAME
								  AND NVL(AUX.DD_SCR_CODIGO,0) = NVL(V.COD_SUBCARTERA,0)
								  AND V.TIPO_GESTOR = 'GFORM');

			--DBMS_OUTPUT.PUT_LINE('DELETE FINALIZADO');        
			MERGE INTO #ESQUEMA#.AUX_BALANCEO_GFORM T1
			USING (
				SELECT DISTINCT DD_CRA_CODIGO, DD_SCR_CODIGO, DD_PRV_CODIGO
				  FROM #ESQUEMA#.AUX_BALANCEO_GFORM AUX
				 WHERE NOT EXISTS (
								SELECT 1
								  FROM #ESQUEMA#.AUX_BALANCEO_GFORM AUX2
								 WHERE AUX2.DD_CRA_CODIGO = AUX.DD_CRA_CODIGO
								   AND NVL(AUX2.DD_SCR_CODIGO,0) = NVL(AUX.DD_SCR_CODIGO,0)
								   AND NVL(AUX2.DD_PRV_CODIGO,0) = NVL(AUX.DD_PRV_CODIGO,0)
								   AND AUX2.ASIGNADO = 0
								)
				) T2
			ON (T1.DD_CRA_CODIGO = T2.DD_CRA_CODIGO AND NVL(T1.DD_SCR_CODIGO,0) = NVL(T2.DD_SCR_CODIGO,0) 
				AND T1.DD_PRV_CODIGO = T2.DD_PRV_CODIGO)
			WHEN MATCHED THEN UPDATE SET
				T1.ASIGNADO = 0;
	 
			--DBMS_OUTPUT.PUT_LINE('MERGE FINALIZADO');
		BEGIN
			SELECT USU_ID AS USUARIO, ACT_ID AS ACTIVO, USERNAME, DD_CRA_CODIGO, DD_PRV_CODIGO, DD_SCR_CODIGO
			  INTO USUARIO, ACTIVO, P_USERNAME, P_DD_CRA_CODIGO, P_DD_PRV_CODIGO, P_DD_SCR_CODIGO
			  FROM (
				SELECT USU.USU_ID, VISTA.ACT_ID ,VISTA.USERNAME, VISTA.DD_CRA_CODIGO, VISTA.DD_PRV_CODIGO, VISTA.DD_SCR_CODIGO
				  FROM #ESQUEMA#.V_GESTORES_ACTIVO VISTA
				  JOIN #ESQUEMA_MASTER#.USU_USUARIOS USU ON USU.USU_USERNAME = VISTA.USERNAME
				  JOIN #ESQUEMA#.AUX_BALANCEO_GFORM AUX ON AUX.USERNAME = VISTA.USERNAME 
						 AND VISTA.DD_CRA_CODIGO = AUX.DD_CRA_CODIGO
						 AND NVL(VISTA.DD_SCR_CODIGO,0) = NVL(AUX.DD_SCR_CODIGO,0)
						 AND NVL(VISTA.DD_PRV_CODIGO,0) = NVL(AUX.DD_PRV_CODIGO,0)
				 WHERE VISTA.TIPO_GESTOR = 'GFORM' AND AUX.ASIGNADO = 0
				 ORDER BY AUX.USERNAME
				) 
			 WHERE ROWNUM = 1 AND ACT_ID = P_ACT_ID;
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
			SELECT USU_ID
			  INTO USUARIO
			  FROM REMMASTER.USU_USUARIOS
			 WHERE USU_USERNAME = 'GESTFORM'
			   AND BORRADO = 0;
			   
			 vHacerUpdate := 'N';
		END;
		  
		IF vHacerUpdate = 'S' THEN  
			UPDATE #ESQUEMA#.AUX_BALANCEO_GFORM AUX
			   SET AUX.ASIGNADO = 1
			 WHERE AUX.DD_CRA_CODIGO = P_DD_CRA_CODIGO 
			   AND NVL(AUX.DD_PRV_CODIGO,0) = NVL(P_DD_PRV_CODIGO,0) 
			   AND AUX.USERNAME = P_USERNAME 
			   AND NVL(AUX.DD_SCR_CODIGO,0) = NVL(P_DD_SCR_CODIGO,0);
		END IF;
	ELSE
		 SELECT USU_ID
          INTO USUARIO
          FROM REMMASTER.USU_USUARIOS
         WHERE USU_USERNAME = 'GESTFORM'
           AND BORRADO = 0;    
    END IF;
		   
	DELETE FROM #ESQUEMA#.TMP_ASIGNACION_USU_GFORM WHERE ACT_ID = P_ACT_ID;
    INSERT INTO #ESQUEMA#.TMP_ASIGNACION_USU_GFORM (ACT_ID, USUARIO) VALUES(P_ACT_ID, USUARIO);	
			
		--DBMS_OUTPUT.PUT_LINE('FIN');
		--DBMS_OUTPUT.PUT_LINE('USUARIO: '||USUARIO);			
			
		COMMIT;
		DBMS_OUTPUT.PUT_LINE('USUARIO = '||USUARIO);
		
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

END SP_CALCULAR_USUARIO_GFORM;
/

EXIT

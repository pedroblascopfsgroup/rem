--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211117
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9845
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Juan Bautista Alfonso [REMVIP-9845] Modificacion para nuevas vistas V_COND_DISPONIBILIDAD
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE SP_PORTALES_ACTIVO (
    P_ACT_ID        IN #ESQUEMA#.ACT_ACTIVO.ACT_ID%TYPE,
    P_AGR_ID        IN #ESQUEMA#.ACT_AGR_AGRUPACION.AGR_ID%TYPE,
    V_USUARIO       VARCHAR2,
    PL_OUTPUT       OUT VARCHAR2) AS

    V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
    V_MSQL VARCHAR2(6000 CHAR);
	V_NUM_TABLAS NUMBER(16);
    V_POR_V NUMBER(16);
    V_POR_A NUMBER(16);

    V_CRA VARCHAR2(10 CHAR);
	/* Para todos los activos la vista es muy lenta, por lo que materializamos  V_COND_DISPONIBILIDAD */
	VPA VARCHAR2(6000 CHAR) := 'SELECT DISTINCT ACT.ACT_ID, 
	CASE
        WHEN 
			SIN_TOMA_POSESION_INICIAL = 0 AND OCUPADO_CONTITULO = 0 AND PENDIENTE_INSCRIPCION  = 0 AND PROINDIVISO  = 0 AND TAPIADO  = 0 AND OBRANUEVA_SINDECLARAR = 0 
			AND OBRANUEVA_ENCONSTRUCCION = 0 AND DIVHORIZONTAL_NOINSCRITA = 0 AND RUINA = 0 AND VANDALIZADO = 0 AND COMBO_OTRO = 0 AND SIN_INFORME_APROBADO = 0 
			AND SIN_INFORME_APROBADO_REM = 0 AND CON_CARGAS = 0 AND SIN_ACCESO = 0 AND OCUPADO_SINTITULO = 0 AND ESTADO_PORTAL_EXTERNO = 0
            THEN (SELECT POR.DD_POR_ID FROM '|| V_ESQUEMA ||'.DD_POR_PORTAL POR WHERE POR.DD_POR_CODIGO = ''01'')
        WHEN
            SIN_TOMA_POSESION_INICIAL = 0 AND PROINDIVISO  = 0 AND TAPIADO  = 0 AND OBRANUEVA_SINDECLARAR = 0 AND OBRANUEVA_ENCONSTRUCCION = 0 AND DIVHORIZONTAL_NOINSCRITA = 0 
			AND RUINA = 0 AND VANDALIZADO = 0 AND COMBO_OTRO = 0 AND SIN_INFORME_APROBADO = 0 AND SIN_INFORME_APROBADO_REM = 0 AND SIN_ACCESO = 0 AND ESTADO_PORTAL_EXTERNO = 0
            AND (COND.PENDIENTE_INSCRIPCION = 0 OR CNP.CNP_PENDIENTE_INSCRIPCION = 1 AND COND.PENDIENTE_INSCRIPCION = 1)
            AND (COND.CON_CARGAS = 0 OR CNP.CNP_CON_CARGAS = 1 AND COND.CON_CARGAS = 1)
            AND (COND.OCUPADO_SINTITULO = 0 OR CNP.CNP_OCUPADO_SIN_TITULO = 1 AND COND.OCUPADO_SINTITULO = 1)
            AND (COND.OCUPADO_CONTITULO = 0 OR CNP.CNP_OCUPADO_CON_TITULO = 1 AND COND.OCUPADO_CONTITULO = 1)
            THEN (SELECT POR.DD_POR_ID FROM '|| V_ESQUEMA ||'.DD_POR_PORTAL POR WHERE POR.DD_POR_CODIGO = ''01'')
        ELSE (SELECT POR.DD_POR_ID FROM '|| V_ESQUEMA ||'.DD_POR_PORTAL POR WHERE POR.DD_POR_CODIGO = ''02'')
    END DD_POR_ID
    FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
	JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
		AND CRA.BORRADO = 0
		AND CRA.DD_CRA_CODIGO <> ''03''
    INNER JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID AND APU.BORRADO = 0
    INNER JOIN '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD_M COND ON COND.ACT_ID = ACT.ACT_ID
    LEFT JOIN '|| V_ESQUEMA ||'.ACT_CNP_CONFIG_PORTAL CNP ON ACT.DD_CRA_ID = CNP.DD_CRA_ID AND CNP.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = APU.DD_EPV_ID AND EPV.BORRADO = 0
    WHERE
    ACT.BORRADO = 0
    AND EPV.DD_EPV_CODIGO IN (''03'',''04'')
    AND NOT EXISTS (SELECT 1 FROM '|| V_ESQUEMA ||'.ACT_ACTIVO AUX
                    JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AUX.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0
                    JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0
                    LEFT JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0
                    WHERE DD_TAG_CODIGO = ''02'' AND AUX.ACT_ID = ACT.ACT_ID)';
-- 0.1
BEGIN
   	PL_OUTPUT := PL_OUTPUT || '[INICIO]' || CHR(10);

   	IF P_ACT_ID IS NOT NULL THEN
   		V_MSQL := 'SELECT DD_CRA_CODIGO 
   			FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA
   			JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.DD_CRA_ID = CRA.DD_CRA_ID
   				AND ACT.BORRADO = 0
   			WHERE ACT.ACT_ID = '||P_ACT_ID;
   		EXECUTE IMMEDIATE V_MSQL INTO V_CRA;
   	END IF;

   	IF P_AGR_ID IS NOT NULL THEN
   		V_MSQL := 'SELECT DISTINCT DD_CRA_CODIGO 
   			FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA
   			JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.DD_CRA_ID = CRA.DD_CRA_ID
   				AND ACT.BORRADO = 0
   			JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND
   				AGA.BORRADO = 0
   			WHERE AGA.AGR_ID = '||P_AGR_ID;
   		EXECUTE IMMEDIATE V_MSQL INTO V_CRA;
   	END IF;

		IF P_ACT_ID IS NULL AND P_AGR_ID IS NULL AND UPPER(V_USUARIO) = 'PROC_CALCULO_PORTAL' THEN 

			V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''V_COND_DISPONIBILIDAD_M'' and owner = '''||V_ESQUEMA||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

			IF V_NUM_TABLAS = 1 THEN
				V_MSQL := 'DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD_M';
				EXECUTE IMMEDIATE V_MSQL;
			END IF;

			V_MSQL := 'CREATE MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD_M AS 
				SELECT COND.ACT_ID, COND.SIN_TOMA_POSESION_INICIAL, COND.OCUPADO_CONTITULO, COND.PENDIENTE_INSCRIPCION, COND.PROINDIVISO
					, COND.TAPIADO, COND.OBRANUEVA_SINDECLARAR, COND.OBRANUEVA_ENCONSTRUCCION, COND.DIVHORIZONTAL_NOINSCRITA, COND.RUINA
					, COND.VANDALIZADO, COND.COMBO_OTRO, COND.SIN_INFORME_APROBADO, SININF.SIN_INFORME_APROBADO_REM, COND.REVISION
					, COND.PROCEDIMIENTO_JUDICIAL, COND.CON_CARGAS, COND.SIN_ACCESO, COND.OCUPADO_SINTITULO, COND.ESTADO_PORTAL_EXTERNO
					, ESCON.ES_CONDICIONADO 
				FROM '|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD COND
				JOIN '||V_ESQUEMA||'.V_ES_CONDICIONADO ESCON ON ESCON.ACT_ID = COND.ACT_ID 
				JOIN '||V_ESQUEMA||'.V_SIN_INFORME_APROBADO_REM SININF ON SININF.ACT_ID=COND.ACT_ID
				JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = COND.ACT_ID
					AND ACT.BORRADO = 0
				JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
					AND CRA.BORRADO = 0
					AND CRA.DD_CRA_CODIGO <> ''03''
				WHERE COND.BORRADO = 0';

			EXECUTE IMMEDIATE V_MSQL;

			V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION AHP
			   USING (
			            SELECT
			                AHP.AHP_ID
			            FROM ACT_AHP_HIST_PUBLICACION AHP
					    JOIN ('||VPA||') VPA ON VPA.ACT_ID = AHP.ACT_ID
					    JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU ON VPA.ACT_ID = APU.ACT_ID AND APU.BORRADO = 0
					WHERE AHP.BORRADO = 0 AND AHP.AHP_FECHA_INI_VENTA IS NOT NULL AND AHP.AHP_FECHA_FIN_VENTA IS NULL AND (APU.DD_POR_ID IS NULL OR APU.DD_POR_ID <> VPA.DD_POR_ID)
					 ) AUX
			   ON (AHP.AHP_ID = AUX.AHP_ID)
			   WHEN MATCHED THEN
			   UPDATE SET
			    AHP.AHP_FECHA_FIN_VENTA = SYSDATE
			    ,AHP.USUARIOMODIFICAR = '''||V_USUARIO||'''
			    ,AHP.FECHAMODIFICAR = SYSDATE';

			EXECUTE IMMEDIATE V_MSQL;
		    
			V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION (
												AHP_ID
												, ACT_ID
												, DD_TPU_A_ID
												, DD_TPU_V_ID
												, DD_EPV_ID
												, DD_EPA_ID
												, DD_TCO_ID
												, DD_MTO_V_ID
												, AHP_MOT_OCULTACION_MANUAL_V
												, AHP_CHECK_PUBLICAR_V
												, AHP_CHECK_OCULTAR_V
												, AHP_CHECK_OCULTAR_PRECIO_V
												, AHP_CHECK_PUB_SIN_PRECIO_V
												, DD_MTO_A_ID
												, AHP_MOT_OCULTACION_MANUAL_A
												, AHP_CHECK_PUBLICAR_A
												, AHP_CHECK_OCULTAR_A
												, AHP_CHECK_OCULTAR_PRECIO_A
												, AHP_CHECK_PUB_SIN_PRECIO_A
												, AHP_FECHA_INI_VENTA
												, VERSION
												, USUARIOCREAR
												, FECHACREAR
												, BORRADO
												, ES_CONDICONADO_ANTERIOR
												, DD_POR_ID
												)
					SELECT  '|| V_ESQUEMA ||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL
												, APU.ACT_ID
												, APU.DD_TPU_A_ID
												, APU.DD_TPU_V_ID
												, APU.DD_EPV_ID
												, APU.DD_EPA_ID
												, APU.DD_TCO_ID
												, APU.DD_MTO_V_ID
												, APU.APU_MOT_OCULTACION_MANUAL_V
												, APU.APU_CHECK_PUBLICAR_V
												, APU.APU_CHECK_OCULTAR_V
												, APU.APU_CHECK_OCULTAR_PRECIO_V
												, APU.APU_CHECK_PUB_SIN_PRECIO_V
												, APU.DD_MTO_A_ID
												, APU.APU_MOT_OCULTACION_MANUAL_A
												, APU.APU_CHECK_PUBLICAR_A
												, APU.APU_CHECK_OCULTAR_A
												, APU.APU_CHECK_OCULTAR_PRECIO_A
												, APU.APU_CHECK_PUB_SIN_PRECIO_A
												, SYSDATE
												, APU.VERSION
												, '''||V_USUARIO||''' USUARIOCREAR
												, SYSDATE FECHACREAR
												, 0 BORRADO
												, APU.ES_CONDICONADO_ANTERIOR
												, VPA.DD_POR_ID
						FROM ACT_APU_ACTIVO_PUBLICACION APU
						JOIN ('||VPA||') VPA ON VPA.ACT_ID = APU.ACT_ID
						WHERE (APU.DD_POR_ID IS NULL OR APU.DD_POR_ID <> VPA.DD_POR_ID) AND APU.BORRADO = 0';
					EXECUTE IMMEDIATE V_MSQL;
			PL_OUTPUT := PL_OUTPUT || 'Se inserta un nuevo registro en el histórico de publicaciones para ' ||SQL%ROWCOUNT|| ' activos' || CHR(10);
		     
			V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
			       USING (
			                SELECT
			                    APU.APU_ID
			                    , VPA.DD_POR_ID
			            FROM ACT_APU_ACTIVO_PUBLICACION APU
					    JOIN ('||VPA||') VPA ON VPA.ACT_ID = APU.ACT_ID
					WHERE (APU.DD_POR_ID IS NULL OR APU.DD_POR_ID <> VPA.DD_POR_ID) AND APU.BORRADO = 0
					) AUX
			       ON (APU.APU_ID = AUX.APU_ID)
			       WHEN MATCHED THEN
			       UPDATE SET
			        APU.DD_POR_ID = AUX.DD_POR_ID
			        ,APU.USUARIOMODIFICAR = '''||V_USUARIO||'''
			        ,APU.FECHAMODIFICAR = SYSDATE';

			EXECUTE IMMEDIATE V_MSQL;
			PL_OUTPUT := PL_OUTPUT || 'Se ha cambiado el canal de publicación para ' ||SQL%ROWCOUNT|| ' activos' || CHR(10);
			
			

					V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION AHP
			   USING (
			            SELECT
			                AHP.AHP_ID
			            FROM '|| V_ESQUEMA ||'.V_PORTALES_AGRUPACION VPA
	                    JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON VPA.AGR_ID = AGA.AGR_ID AND AGA.BORRADO = 0
	                    JOIN '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION AHP ON AHP.ACT_ID = AGA.ACT_ID AND AHP.BORRADO = 0				    
					    JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU ON AHP.ACT_ID = APU.ACT_ID AND APU.BORRADO = 0
						JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = APU.ACT_ID
							AND ACT.BORRADO = 0
						JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
							AND CRA.BORRADO = 0
							AND CRA.DD_CRA_CODIGO <> ''03''
					WHERE AHP.BORRADO = 0 AND AHP.AHP_FECHA_INI_VENTA IS NOT NULL AND AHP.AHP_FECHA_FIN_VENTA IS NULL AND (APU.DD_POR_ID IS NULL OR APU.DD_POR_ID <> VPA.DD_POR_ID)
					) AUX
			   ON (AHP.AHP_ID = AUX.AHP_ID)
			   WHEN MATCHED THEN
			   UPDATE SET
			    AHP.AHP_FECHA_FIN_VENTA = SYSDATE
			    ,AHP.USUARIOMODIFICAR = '''||V_USUARIO||'''
			    ,AHP.FECHAMODIFICAR = SYSDATE';

			EXECUTE IMMEDIATE V_MSQL;
		    
		    
			V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION (
			                                      AHP_ID
			                                      , ACT_ID
			                                      , DD_TPU_A_ID
			                                      , DD_TPU_V_ID
			                                      , DD_EPV_ID
			                                      , DD_EPA_ID
			                                      , DD_TCO_ID
			                                      , DD_MTO_V_ID
			                                      , AHP_MOT_OCULTACION_MANUAL_V
			                                      , AHP_CHECK_PUBLICAR_V
			                                      , AHP_CHECK_OCULTAR_V
			                                      , AHP_CHECK_OCULTAR_PRECIO_V
			                                      , AHP_CHECK_PUB_SIN_PRECIO_V
			                                      , DD_MTO_A_ID
			                                      , AHP_MOT_OCULTACION_MANUAL_A
			                                      , AHP_CHECK_PUBLICAR_A
			                                      , AHP_CHECK_OCULTAR_A
			                                      , AHP_CHECK_OCULTAR_PRECIO_A
			                                      , AHP_CHECK_PUB_SIN_PRECIO_A
			                                      , AHP_FECHA_INI_VENTA
			                                      , VERSION
			                                      , USUARIOCREAR
			                                      , FECHACREAR
			                                      , BORRADO
			                                      , ES_CONDICONADO_ANTERIOR
			                                      , DD_POR_ID
			                                      )
			        SELECT  '|| V_ESQUEMA ||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL
			                                      , APU.ACT_ID
			                                      , APU.DD_TPU_A_ID
			                                      , APU.DD_TPU_V_ID
			                                      , APU.DD_EPV_ID
			                                      , APU.DD_EPA_ID
			                                      , APU.DD_TCO_ID
			                                      , APU.DD_MTO_V_ID
			                                      , APU.APU_MOT_OCULTACION_MANUAL_V
			                                      , APU.APU_CHECK_PUBLICAR_V
			                                      , APU.APU_CHECK_OCULTAR_V
			                                      , APU.APU_CHECK_OCULTAR_PRECIO_V
			                                      , APU.APU_CHECK_PUB_SIN_PRECIO_V
			                                      , APU.DD_MTO_A_ID
			                                      , APU.APU_MOT_OCULTACION_MANUAL_A
			                                      , APU.APU_CHECK_PUBLICAR_A
			                                      , APU.APU_CHECK_OCULTAR_A
			                                      , APU.APU_CHECK_OCULTAR_PRECIO_A
			                                      , APU.APU_CHECK_PUB_SIN_PRECIO_A
			                                      , SYSDATE
			                                      , APU.VERSION
			                                      , '''||V_USUARIO||''' USUARIOCREAR
			                                      , SYSDATE FECHACREAR
			                                      , 0 BORRADO
			                                      , APU.ES_CONDICONADO_ANTERIOR
			                                      , VPA.DD_POR_ID
			            FROM '|| V_ESQUEMA ||'.V_PORTALES_AGRUPACION VPA
	                    JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON VPA.AGR_ID = AGA.AGR_ID AND AGA.BORRADO = 0				    
					    JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = AGA.ACT_ID AND APU.BORRADO = 0
					    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = APU.ACT_ID
							AND ACT.BORRADO = 0
						JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
							AND CRA.BORRADO = 0
							AND CRA.DD_CRA_CODIGO <> ''03''
						WHERE (APU.DD_POR_ID IS NULL OR APU.DD_POR_ID <> VPA.DD_POR_ID)';

			EXECUTE IMMEDIATE V_MSQL;
			PL_OUTPUT := PL_OUTPUT || 'Se inserta un nuevo registro en el histórico de publicaciones para ' ||SQL%ROWCOUNT|| ' activos de agrupaciones restringidas' || CHR(10);
		     
			V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
			       USING (
			            SELECT
			                APU.APU_ID
							, VPA.DD_POR_ID
			            FROM '|| V_ESQUEMA ||'.V_PORTALES_AGRUPACION VPA
	                    JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON VPA.AGR_ID = AGA.AGR_ID AND AGA.BORRADO = 0			    
					    JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU ON AGA.ACT_ID = APU.ACT_ID AND APU.BORRADO = 0
					    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = APU.ACT_ID
							AND ACT.BORRADO = 0
						JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
							AND CRA.BORRADO = 0
							AND CRA.DD_CRA_CODIGO <> ''03''
					WHERE (APU.DD_POR_ID IS NULL OR APU.DD_POR_ID <> VPA.DD_POR_ID)
					) AUX
			       ON (APU.APU_ID = AUX.APU_ID)
			       WHEN MATCHED THEN
			       UPDATE SET
			        APU.DD_POR_ID = AUX.DD_POR_ID
			        ,APU.USUARIOMODIFICAR = '''||V_USUARIO||'''
			        ,APU.FECHAMODIFICAR = SYSDATE';

			EXECUTE IMMEDIATE V_MSQL;
			PL_OUTPUT := PL_OUTPUT || 'Se ha cambiado el canal de publicación para ' ||SQL%ROWCOUNT|| ' activos de agrupaciones restringidas' || CHR(10);

			#ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','ACT_AHP_HIST_PUBLICACION',1);
			#ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','ACT_APU_ACTIVO_PUBLICACION',1);
			
			PL_OUTPUT := PL_OUTPUT || 'OK. Se han realizado los cambios de portal' || CHR(10);   
	 	
	    ELSIF P_ACT_ID IS NOT NULL AND P_AGR_ID IS NULL AND V_CRA <> '03' THEN --ACTIVOS 
	        EXECUTE IMMEDIATE 'SELECT APU.DD_POR_ID FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU WHERE APU.BORRADO = 0 AND APU.ACT_ID = '||P_ACT_ID INTO V_POR_A;
			EXECUTE IMMEDIATE 'SELECT VPA.DD_POR_ID FROM '||V_ESQUEMA||'.V_PORTALES_ACTIVO VPA WHERE VPA.ACT_ID = '||P_ACT_ID INTO V_POR_V;
	        IF V_POR_V IS NULL OR (V_POR_V IS NOT NULL AND V_POR_V = V_POR_A) THEN
	            PL_OUTPUT := PL_OUTPUT || 'OK. Sin cambios que realizar' || CHR(10);
	        ELSE 
	             V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
	                   USING (
	                            SELECT 
	                                APU.APU_ID
	                                , '||V_POR_V||' DD_POR_ID
	                            FROM 
	                                '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
	                            WHERE APU.BORRADO = 0 AND APU.ACT_ID = '||P_ACT_ID||
	                          ') AUX
	                   ON (APU.APU_ID = AUX.APU_ID)
	                   WHEN MATCHED THEN
	                   UPDATE SET
	                    APU.DD_POR_ID = AUX.DD_POR_ID
	                    ,APU.USUARIOMODIFICAR = '''||V_USUARIO||'''
	                    ,APU.FECHAMODIFICAR = SYSDATE';

	            EXECUTE IMMEDIATE V_MSQL;
	            
	            PL_OUTPUT := PL_OUTPUT || 'Se ha cambiado el canal de publicación para ' ||SQL%ROWCOUNT|| ' activos' || CHR(10);
	            
	            PL_OUTPUT := PL_OUTPUT || 'OK. Se han realizado los cambios de portal' || CHR(10);
	        END IF;
	    ELSIF P_ACT_ID IS NULL AND P_AGR_ID IS NOT NULL AND V_CRA <> '03' THEN-- AGRUPACIONES
	        EXECUTE IMMEDIATE 'SELECT APU.DD_POR_ID FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
				    JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ACT_PRINCIPAL = APU.ACT_ID AND AGR.BORRADO = 0
			    	WHERE APU.BORRADO = 0 AND AGR.AGR_ID = '||P_AGR_ID||'' INTO V_POR_A;
			EXECUTE IMMEDIATE 'SELECT VPA.DD_POR_ID FROM '||V_ESQUEMA||'.V_PORTALES_AGRUPACION VPA WHERE VPA.AGR_ID = '||P_AGR_ID INTO V_POR_V;
	        IF V_POR_V IS NULL OR (V_POR_V IS NOT NULL AND V_POR_V = V_POR_A) THEN
	            PL_OUTPUT := PL_OUTPUT || 'OK. Sin cambios que realizar' || CHR(10);
	        ELSE 
	             V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
	                   USING (
	                            SELECT
	                                APU.APU_ID
	                                , '||V_POR_V||' DD_POR_ID
	                            FROM 
	                                '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
	                                JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON APU.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0
	                            WHERE APU.BORRADO = 0 AND AGA.AGR_ID = '||P_AGR_ID||
	                          ') AUX
	                   ON (APU.APU_ID = AUX.APU_ID)
	                   WHEN MATCHED THEN
	                   UPDATE SET
	                    APU.DD_POR_ID = AUX.DD_POR_ID
	                    ,APU.USUARIOMODIFICAR = '''||V_USUARIO||'''
	                    ,APU.FECHAMODIFICAR = SYSDATE';

	            EXECUTE IMMEDIATE V_MSQL;
	            
	            PL_OUTPUT := PL_OUTPUT || 'Se ha cambiado el canal de publicación para ' ||SQL%ROWCOUNT|| ' activos' || CHR(10);
	            PL_OUTPUT := PL_OUTPUT || 'OK. Se han realizado los cambios de portal' || CHR(10);
	        END IF;  
	    ELSIF V_USUARIO IS NULL OR P_ACT_ID IS NOT NULL AND P_AGR_ID IS NOT NULL OR P_ACT_ID IS NULL AND P_AGR_ID IS NULL AND V_USUARIO IS NOT NULL THEN
	        PL_OUTPUT := PL_OUTPUT || 'KO. No se ha podido completar la operativa' || CHR(10);  
	    ELSE
			PL_OUTPUT := PL_OUTPUT || 'OK. Sin cambios que realizar' || CHR(10); 
	    END IF;

    COMMIT;
	PL_OUTPUT := PL_OUTPUT || '[FIN]' || CHR(10);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        PL_OUTPUT := PL_OUTPUT || 'OK. Sin cambios que realizar' || CHR(10);
    WHEN OTHERS THEN
        PL_OUTPUT := PL_OUTPUT || 'KO. No se ha podido completar la operativa: ' || TO_CHAR(SQLCODE) || CHR(10);
        PL_OUTPUT := PL_OUTPUT || '-----------------------------------------------------------' || CHR(10);
        PL_OUTPUT := PL_OUTPUT || SQLERRM || CHR(10);
        PL_OUTPUT := PL_OUTPUT || V_MSQL || CHR(10);
        ROLLBACK;
        RAISE;
END SP_PORTALES_ACTIVO;
/
EXIT;

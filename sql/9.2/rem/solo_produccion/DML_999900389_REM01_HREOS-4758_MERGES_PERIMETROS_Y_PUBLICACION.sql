--/*
--###########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20181109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4758
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizamos los perímetros del activo y sus estado/motivos de ocultación.
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
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  
  
BEGIN		
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso...');

	V_MSQL :=  'MERGE INTO REM01.ACT_PAC_PERIMETRO_ACTIVO T1
				USING (
						SELECT DISTINCT PAC.PAC_ID          AS PAC_ID,
										PAC.PAC_INCLUIDO    AS PAC_INCLUIDO,
										SCM.DD_SCM_CODIGO   AS DD_SCM_CODIGO
						FROM REM01.ACT_ACTIVO                         ACT
						JOIN REM01.ACT_PAC_PERIMETRO_ACTIVO           PAC
						  ON PAC.ACT_ID = ACT.ACT_ID
						JOIN REM01.ACT_APU_ACTIVO_PUBLICACION         APU
						  ON APU.ACT_ID = ACT.ACT_ID
						JOIN REM01.DD_SCM_SITUACION_COMERCIAL         SCM
						  ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
						JOIN REM01.DD_TCO_TIPO_COMERCIALIZACION       TCO
						  ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
						WHERE PAC.PAC_INCLUIDO = 0 
						   OR (SCM.DD_SCM_CODIGO IN (''01'',''05''))
				) T2
				ON (T1.PAC_ID = T2.PAC_ID)
				WHEN MATCHED THEN 
				UPDATE SET
					T1.PAC_CHECK_GESTIONAR =     CASE  WHEN T2.PAC_INCLUIDO = 0        	 AND (T1.PAC_CHECK_GESTIONAR IS NULL OR T1.PAC_CHECK_GESTIONAR <> 0)          THEN 0
													   WHEN T2.DD_SCM_CODIGO IN (''05'') AND (T1.PAC_CHECK_GESTIONAR IS NULL OR T1.PAC_CHECK_GESTIONAR <> 1)          THEN 1
													   WHEN T2.DD_SCM_CODIGO IN (''01'') AND (T1.PAC_CHECK_GESTIONAR IS NULL OR T1.PAC_CHECK_GESTIONAR <> 1)          THEN 1
																																									  ELSE T1.PAC_CHECK_GESTIONAR
												 END,
					T1.PAC_FECHA_GESTIONAR =     CASE  WHEN T2.PAC_INCLUIDO = 0          AND (T1.PAC_CHECK_GESTIONAR IS NULL OR T1.PAC_CHECK_GESTIONAR <> 0)          THEN SYSDATE
													   WHEN T2.DD_SCM_CODIGO IN (''05'') AND (T1.PAC_CHECK_GESTIONAR IS NULL OR T1.PAC_CHECK_GESTIONAR <> 1)          THEN SYSDATE
													   WHEN T2.DD_SCM_CODIGO IN (''01'') AND (T1.PAC_CHECK_GESTIONAR IS NULL OR T1.PAC_CHECK_GESTIONAR <> 1)          THEN SYSDATE
																																									  ELSE T1.PAC_FECHA_GESTIONAR
												 END,
					T1.PAC_MOTIVO_GESTIONAR =    CASE  WHEN T2.PAC_INCLUIDO = 0          AND (T1.PAC_CHECK_GESTIONAR IS NULL OR T1.PAC_CHECK_GESTIONAR <> 0)          THEN ''Activo fuera del perimetro HAYA''
													   WHEN T2.DD_SCM_CODIGO IN (''05'') AND (T1.PAC_CHECK_GESTIONAR IS NULL OR T1.PAC_CHECK_GESTIONAR <> 1)          THEN ''Activo vendido''
													   WHEN T2.DD_SCM_CODIGO IN (''01'') AND (T1.PAC_CHECK_GESTIONAR IS NULL OR T1.PAC_CHECK_GESTIONAR <> 1)          THEN ''Activo no comercializable''
																																									  ELSE T1.PAC_MOTIVO_GESTIONAR
												 END,
					T1.PAC_CHECK_PUBLICAR =      CASE  WHEN T2.PAC_INCLUIDO = 0          AND (T1.PAC_CHECK_PUBLICAR IS NULL OR T1.PAC_CHECK_PUBLICAR <> 0)            THEN 0
													   WHEN T2.DD_SCM_CODIGO IN (''05'') AND (T1.PAC_CHECK_PUBLICAR IS NULL OR T1.PAC_CHECK_PUBLICAR <> 0)            THEN 0
													   WHEN T2.DD_SCM_CODIGO IN (''01'') AND (T1.PAC_CHECK_PUBLICAR IS NULL OR T1.PAC_CHECK_PUBLICAR <> 0)            THEN 0
																																									  ELSE T1.PAC_CHECK_PUBLICAR
												 END,
					T1.PAC_FECHA_PUBLICAR =      CASE  WHEN T2.PAC_INCLUIDO = 0          AND (T1.PAC_CHECK_PUBLICAR IS NULL OR T1.PAC_CHECK_PUBLICAR <> 0)            THEN SYSDATE
													   WHEN T2.DD_SCM_CODIGO IN (''05'') AND (T1.PAC_CHECK_PUBLICAR IS NULL OR T1.PAC_CHECK_PUBLICAR <> 1)            THEN SYSDATE
													   WHEN T2.DD_SCM_CODIGO IN (''01'') AND (T1.PAC_CHECK_PUBLICAR IS NULL OR T1.PAC_CHECK_PUBLICAR <> 1)            THEN SYSDATE
																																									  ELSE T1.PAC_FECHA_PUBLICAR
												 END,
					T1.PAC_MOTIVO_PUBLICAR =     CASE  WHEN T2.PAC_INCLUIDO = 0          AND (T1.PAC_CHECK_PUBLICAR IS NULL OR T1.PAC_CHECK_PUBLICAR <> 0)            THEN ''Activo fuera del perimetro HAYA''
													   WHEN T2.DD_SCM_CODIGO IN (''05'') AND (T1.PAC_CHECK_PUBLICAR IS NULL OR T1.PAC_CHECK_PUBLICAR <> 1)            THEN ''Activo vendido''
													   WHEN T2.DD_SCM_CODIGO IN (''01'') AND (T1.PAC_CHECK_PUBLICAR IS NULL OR T1.PAC_CHECK_PUBLICAR <> 1)            THEN ''Activo no comercializable''
																																									  ELSE T1.PAC_MOTIVO_PUBLICAR
												 END,                            
					T1.PAC_CHECK_COMERCIALIZAR = CASE  WHEN T2.PAC_INCLUIDO = 0          AND (T1.PAC_CHECK_COMERCIALIZAR IS NULL OR T1.PAC_CHECK_COMERCIALIZAR <> 0)  THEN 0
													   WHEN T2.DD_SCM_CODIGO IN (''05'') AND (T1.PAC_CHECK_COMERCIALIZAR IS NULL OR T1.PAC_CHECK_COMERCIALIZAR <> 0)  THEN 0
													   WHEN T2.DD_SCM_CODIGO IN (''01'') AND (T1.PAC_CHECK_COMERCIALIZAR IS NULL OR T1.PAC_CHECK_COMERCIALIZAR <> 1)  THEN 1
																																									  ELSE T1.PAC_CHECK_COMERCIALIZAR
												 END,
					T1.PAC_FECHA_COMERCIALIZAR = CASE  WHEN T2.PAC_INCLUIDO = 0          AND (T1.PAC_CHECK_COMERCIALIZAR IS NULL OR T1.PAC_CHECK_COMERCIALIZAR <> 0)  THEN SYSDATE
													   WHEN T2.DD_SCM_CODIGO IN (''05'') AND (T1.PAC_CHECK_COMERCIALIZAR IS NULL OR T1.PAC_CHECK_COMERCIALIZAR <> 1)  THEN SYSDATE
													   WHEN T2.DD_SCM_CODIGO IN (''01'') AND (T1.PAC_CHECK_COMERCIALIZAR IS NULL OR T1.PAC_CHECK_COMERCIALIZAR <> 1)  THEN SYSDATE
																																									  ELSE T1.PAC_FECHA_COMERCIALIZAR
												 END,
					T1.PAC_MOT_EXCL_COMERCIALIZAR =    CASE  WHEN T2.PAC_INCLUIDO = 0    AND (T1.PAC_CHECK_COMERCIALIZAR IS NULL OR T1.PAC_CHECK_COMERCIALIZAR <> 0)  THEN ''Activo fuera del perimetro HAYA''
													   WHEN T2.DD_SCM_CODIGO IN (''05'') AND (T1.PAC_CHECK_COMERCIALIZAR IS NULL OR T1.PAC_CHECK_COMERCIALIZAR <> 1)  THEN ''Activo vendido''
													   WHEN T2.DD_SCM_CODIGO IN (''01'') AND (T1.PAC_CHECK_COMERCIALIZAR IS NULL OR T1.PAC_CHECK_COMERCIALIZAR <> 1)  THEN ''Activo no comercializable''
																																									  ELSE T1.PAC_MOT_EXCL_COMERCIALIZAR
												 END,                             
					T1.PAC_CHECK_FORMALIZAR =    CASE  WHEN T2.PAC_INCLUIDO = 0          AND (T1.PAC_CHECK_FORMALIZAR IS NULL OR T1.PAC_CHECK_FORMALIZAR <> 0)        THEN 0
													   WHEN T2.DD_SCM_CODIGO IN (''05'') AND (T1.PAC_CHECK_FORMALIZAR IS NULL OR T1.PAC_CHECK_FORMALIZAR <> 0)        THEN 0
													   WHEN T2.DD_SCM_CODIGO IN (''01'') AND (T1.PAC_CHECK_FORMALIZAR IS NULL OR T1.PAC_CHECK_FORMALIZAR <> 1)        THEN 1
																																									  ELSE T1.PAC_CHECK_FORMALIZAR
												 END,
					T1.PAC_FECHA_FORMALIZAR =    CASE  WHEN T2.PAC_INCLUIDO = 0          AND (T1.PAC_CHECK_FORMALIZAR IS NULL OR T1.PAC_CHECK_FORMALIZAR <> 0)        THEN SYSDATE
													   WHEN T2.DD_SCM_CODIGO IN (''05'') AND (T1.PAC_CHECK_FORMALIZAR IS NULL OR T1.PAC_CHECK_FORMALIZAR <> 1)        THEN SYSDATE
													   WHEN T2.DD_SCM_CODIGO IN (''01'') AND (T1.PAC_CHECK_FORMALIZAR IS NULL OR T1.PAC_CHECK_FORMALIZAR <> 1)        THEN SYSDATE
																																									  ELSE T1.PAC_FECHA_FORMALIZAR
												 END,
					T1.PAC_MOTIVO_FORMALIZAR =   CASE  WHEN T2.PAC_INCLUIDO = 0          AND (T1.PAC_CHECK_FORMALIZAR IS NULL OR T1.PAC_CHECK_FORMALIZAR <> 0)        THEN ''Activo fuera del perimetro HAYA''
													   WHEN T2.DD_SCM_CODIGO IN (''05'') AND (T1.PAC_CHECK_FORMALIZAR IS NULL OR T1.PAC_CHECK_FORMALIZAR <> 1)        THEN ''Activo vendido''
													   WHEN T2.DD_SCM_CODIGO IN (''01'') AND (T1.PAC_CHECK_FORMALIZAR IS NULL OR T1.PAC_CHECK_FORMALIZAR <> 1)        THEN ''Activo no comercializable''
																																									  ELSE T1.PAC_MOTIVO_FORMALIZAR
												 END,                            
					T1.USUARIOMODIFICAR = ''HREOS-4758'',
					T1.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_MSQL; 
	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan los perímetros de '||SQL%ROWCOUNT||' activos en la ACT_PAC_PERIMETRO_ACTIVO.');  
	
	
	
	V_MSQL :=  'MERGE INTO REM01.ACT_APU_ACTIVO_PUBLICACION T1
				USING (
						SELECT DISTINCT APU.APU_ID                                                                                AS APU_ID,
										PAC.PAC_INCLUIDO                                                                          AS PAC_INCLUIDO,
										SCM.DD_SCM_CODIGO                                                                         AS DD_SCM_CODIGO,
										TCO.DD_TCO_CODIGO                                                                         AS DD_TCO_CODIGO,
										(SELECT DD_MTO_ID FROM REM01.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO IN (''08''))   AS SALIDA_PERIMETRO,
										(SELECT DD_MTO_ID FROM REM01.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO IN (''13''))   AS VENDIDO,
										(SELECT DD_MTO_ID FROM REM01.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO IN (''01''))   AS NO_PUBLICABLE,
										(SELECT DD_EPA_ID FROM REM01.DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO IN (''04''))  AS OCULTO_ALQUILER,
										(SELECT DD_EPV_ID FROM REM01.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO IN (''04''))     AS OCULTO_VENTA
						FROM REM01.ACT_ACTIVO                         ACT
						JOIN REM01.ACT_PAC_PERIMETRO_ACTIVO           PAC
						  ON PAC.ACT_ID = ACT.ACT_ID
						JOIN REM01.ACT_APU_ACTIVO_PUBLICACION         APU
						  ON APU.ACT_ID = ACT.ACT_ID
						JOIN REM01.DD_SCM_SITUACION_COMERCIAL         SCM
						  ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
						JOIN REM01.DD_TCO_TIPO_COMERCIALIZACION       TCO
						  ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
						WHERE PAC.PAC_INCLUIDO = 0 
						   OR (SCM.DD_SCM_CODIGO IN (''01'',''05''))
				) T2
				ON (T1.APU_ID = T2.APU_ID)
				WHEN MATCHED THEN 
				UPDATE SET
					T1.APU_CHECK_OCULTAR_A =  CASE  WHEN T2.PAC_INCLUIDO = 0        AND T2.DD_TCO_CODIGO IN (''02'',''03'',''04'') AND (T1.APU_CHECK_OCULTAR_A IS NULL OR T1.APU_CHECK_OCULTAR_A <> 1)    	THEN 1
													WHEN T2.DD_SCM_CODIGO IN (''05'') AND T2.DD_TCO_CODIGO IN (''02'',''03'',''04'') AND (T1.APU_CHECK_OCULTAR_A IS NULL OR T1.APU_CHECK_OCULTAR_A <> 1)    THEN 1
													WHEN T2.DD_SCM_CODIGO IN (''01'') AND T2.DD_TCO_CODIGO IN (''02'',''03'',''04'') AND (T1.APU_CHECK_OCULTAR_A IS NULL OR T1.APU_CHECK_OCULTAR_A <> 1)    THEN 1
																																																			ELSE T1.APU_CHECK_OCULTAR_A
											  END,
					T1.DD_EPA_ID =            CASE  WHEN T2.DD_TCO_CODIGO IN (''02'',''03'',''04'') AND (T1.DD_EPA_ID IS NULL OR T1.DD_EPA_ID <> T2.OCULTO_ALQUILER)                                      	THEN T2.OCULTO_ALQUILER
																																																			ELSE T1.DD_EPA_ID
											  END,
					T1.DD_MTO_A_ID =          CASE  WHEN T2.PAC_INCLUIDO = 0        AND T2.DD_TCO_CODIGO IN (''02'',''03'',''04'') AND (T1.DD_MTO_A_ID IS NULL OR T1.DD_MTO_A_ID <> T2.SALIDA_PERIMETRO)  	THEN T2.SALIDA_PERIMETRO
													WHEN T2.DD_SCM_CODIGO IN (''05'') AND T2.DD_TCO_CODIGO IN (''02'',''03'',''04'') AND (T1.DD_MTO_A_ID IS NULL OR T1.DD_MTO_A_ID <> T2.VENDIDO)           THEN T2.VENDIDO
													WHEN T2.DD_SCM_CODIGO IN (''01'') AND T2.DD_TCO_CODIGO IN (''02'',''03'',''04'') AND (T1.DD_MTO_A_ID IS NULL OR T1.DD_MTO_A_ID <> T2.NO_PUBLICABLE)     THEN T2.NO_PUBLICABLE
																																																			ELSE T1.DD_MTO_A_ID
											  END,
					T1.APU_CHECK_OCULTAR_V =  CASE  WHEN T2.PAC_INCLUIDO = 0        AND T2.DD_TCO_CODIGO IN (''01'',''02'') AND (T1.APU_CHECK_OCULTAR_V IS NULL OR T1.APU_CHECK_OCULTAR_V <> 1)         	THEN 1
													WHEN T2.DD_SCM_CODIGO IN (''05'') AND T2.DD_TCO_CODIGO IN (''01'',''02'') AND (T1.APU_CHECK_OCULTAR_V IS NULL OR T1.APU_CHECK_OCULTAR_V <> 1)         	THEN 1
													WHEN T2.DD_SCM_CODIGO IN (''01'') AND T2.DD_TCO_CODIGO IN (''01'',''02'') AND (T1.APU_CHECK_OCULTAR_V IS NULL OR T1.APU_CHECK_OCULTAR_V <> 1)         	THEN 1
																																																			ELSE T1.APU_CHECK_OCULTAR_V
											  END,
					T1.DD_EPV_ID =            CASE WHEN T2.DD_TCO_CODIGO IN (''01'',''02'') AND (T1.DD_EPV_ID IS NULL OR T1.DD_EPV_ID <> T2.OCULTO_VENTA)                                               	THEN T2.OCULTO_VENTA
																																																			ELSE T1.DD_EPV_ID
											  END,
					T1.DD_MTO_V_ID =          CASE  WHEN T2.PAC_INCLUIDO = 0        AND T2.DD_TCO_CODIGO IN (''01'',''02'') AND (T1.DD_MTO_V_ID IS NULL OR T1.DD_MTO_V_ID <> T2.SALIDA_PERIMETRO)       	THEN T2.SALIDA_PERIMETRO
													WHEN T2.DD_SCM_CODIGO IN (''05'') AND T2.DD_TCO_CODIGO IN (''01'',''02'') AND (T1.DD_MTO_V_ID IS NULL OR T1.DD_MTO_V_ID <> T2.VENDIDO)                	THEN T2.VENDIDO
													WHEN T2.DD_SCM_CODIGO IN (''01'') AND T2.DD_TCO_CODIGO IN (''01'',''02'') AND (T1.DD_MTO_V_ID IS NULL OR T1.DD_MTO_V_ID <> T2.NO_PUBLICABLE)          	THEN T2.NO_PUBLICABLE
																																																			ELSE T1.DD_MTO_V_ID
											  END,
					T1.USUARIOMODIFICAR = ''HREOS-4758'',
					T1.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_MSQL; 
	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan los datos de publicación de '||SQL%ROWCOUNT||' activos en la ACT_APU_ACTIVO_PUBLICACION.');  
	
	COMMIT;  
	DBMS_OUTPUT.PUT_LINE('[FIN]: Fin del proceso.');
 

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

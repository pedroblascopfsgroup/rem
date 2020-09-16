--/*
--##########################################
--## AUTOR=MIGUEL LOPEZ
--## FECHA_CREACION=20190829
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7398
--## PRODUCTO=NO
--## Finalidad: Actualiza el tipo comercializar (Singular/Retail) del activo. Modificacion de criterios y actualizacion del SP.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - Daniel Gutierrez (HREOS-1814) (20170320) Actualiza el tipo comercializar (Singular/Retail) del activo
--##        0.2 Marco Munoz - (HREOS-3860) (20180227) Modificacion de criterios para calcular activos singulares o retail. Se actualiza estructura del SP.
--##        0.3 Miguel Lopez - HREOS-7398 Cambiar el calculo por el nuevo.
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
create or replace PROCEDURE CALCULO_SINGULAR_RETAIL_AUTO (
   p_act_id       	IN #ESQUEMA#.act_activo.act_id%TYPE,
   p_username     	IN #ESQUEMA#.act_activo.usuariomodificar%TYPE,
   p_all_activos	IN NUMBER,
   p_ignore_block	IN NUMBER
)
AUTHID CURRENT_USER IS
-- Definición parámetros de entrada ---------------------------------------------------------------------------------------
-- p_act_id, 		id del activo a comprobar (si viene a null, los comprabará todos)**(Condicionado con p_all_activos)
-- p_username, 		usuario que hace la llamada (se insertará en usuariomodificar)
-- p_all_activos,	si viene a 1, se analizarán todos los activos, sino, solo aquellos que no tengan informado el dd_tcr_id
-- p_ignore_block,	si viene a 1, se ignora el bloqueo automático(ACT_BLOQUEO_TIPO_COMERCIALIZAR) para actualizar el TCR
-- ------------------------------------------------------------------------------------------------------------------------

V_MSQL 			   VARCHAR2(32000 CHAR);								--Sentencia SQL a ejecutar
V_WHERE 		   VARCHAR2(32000 CHAR);								--Condicion en los updates según los FLAGS (parametros del SP)
V_IGNORE_BLOCK     NUMBER;
V_ALL_ACTIVOS      NUMBER;
V_USERNAME         #ESQUEMA#.ACT_ACTIVO.USUARIOMODIFICAR%TYPE;

BEGIN


V_IGNORE_BLOCK := P_IGNORE_BLOCK;
V_ALL_ACTIVOS := P_ALL_ACTIVOS;
V_USERNAME := P_USERNAME;
V_WHERE   := '';


DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso CALCULO_SINGULAR_RETAIL_AUTO');

/*******************************************************************************
CALCULAMOS LAS CONDICIONES ADICIONALES (SEGÚN LOS FLAGS DEL SP)
********************************************************************************/
IF (V_IGNORE_BLOCK IS NULL) THEN V_IGNORE_BLOCK := 0; END IF;
IF (V_ALL_ACTIVOS  IS NULL) THEN V_ALL_ACTIVOS  := 0; END IF;

IF (V_IGNORE_BLOCK = 0)                     THEN    V_WHERE := V_WHERE||' AND ACT.ACT_BLOQUEO_TIPO_COMERCIALIZAR = 0 '; END IF;
IF (P_ACT_ID IS NULL AND V_ALL_ACTIVOS = 0) THEN    V_WHERE := V_WHERE||' AND ACT.DD_TCR_ID IS NULL ';                  END IF;
IF (P_ACT_ID IS NOT NULL)                   THEN    V_WHERE := V_WHERE||' AND ACT.ACT_ID = '||P_ACT_ID||' ';            END IF;
IF (V_USERNAME IS NULL)                     THEN    V_USERNAME := 'SP_CALCULO_SING_RET';                                END IF;
            
            
DBMS_OUTPUT.PUT_LINE('[INFO] Updateamos el DD_TRC_ID de los activos singulares.');

/*******************************************************************************
CALCULAMOS LOS ACTIVOS SINGULARES
********************************************************************************/             
V_MSQL :=
'UPDATE #ESQUEMA#.ACT_ACTIVO     ACT                                                                                                   			--ACTUALIZAMOS ESTOS CAMPOS DE LOS ACTIVOS:
   SET ACT.DD_TCR_ID        = (SELECT TCR.DD_TCR_ID FROM #ESQUEMA#.DD_TCR_TIPO_COMERCIALIZAR TCR WHERE TCR.DD_TCR_CODIGO IN (''01'')),     		--ACTIVO SINGULAR
       ACT.USUARIOMODIFICAR = '''||V_USERNAME||''',                                                                                             --USUARIO MODIFICAR 
       ACT.FECHAMODIFICAR   =  SYSDATE                                                                                                          --FECHA MODIFICAR
   WHERE 
   ACT.BORRADO = 0 AND
          ACT.ACT_ID 
          NOT IN 
         (SELECT      ACT.ACT_ID                                                                                                
            FROM      #ESQUEMA#.ACT_ACTIVO                                          ACT
            JOIN      #ESQUEMA#.DD_EAC_ESTADO_ACTIVO                                EAC   ON   ACT.DD_EAC_ID  = EAC.DD_EAC_ID
            JOIN      #ESQUEMA#.DD_TPA_TIPO_ACTIVO                                  TPA   ON   ACT.DD_TPA_ID  = TPA.DD_TPA_ID
            JOIN      #ESQUEMA#.DD_SAC_SUBTIPO_ACTIVO                               SAC   ON   ACT.DD_SAC_ID  = SAC.DD_SAC_ID
            LEFT JOIN #ESQUEMA#.ACT_ADO_ADMISION_DOCUMENTO                          ADO   ON   ACT.ACT_ID     = ADO.ACT_ID
            LEFT JOIN #ESQUEMA#.ACT_CFD_CONFIG_DOCUMENTO                            CFD   ON   ADO.CFD_ID     = CFD.CFD_ID
            LEFT JOIN #ESQUEMA#.DD_TPD_TIPO_DOCUMENTO                               TPD   ON   CFD.DD_TPD_ID  = TPD.DD_TPD_ID
            LEFT JOIN #ESQUEMA#.DD_EDC_ESTADO_DOCUMENTO								EDC   ON   ADO.DD_EDC_ID = EDC.DD_EDC_ID
            WHERE 
                  (
	                (
	                  TPA.DD_TPA_CODIGO IN (''02'')                   		OR              --TODOS LOS ACTIVOS QUE SON VIVIENDAS
	                  SAC.DD_SAC_CODIGO IN (''24'',''25'')                              	--TODOS LOS ACTIVOS QUE SON GARAJES O TRASTEROS
	                )                                                 		AND
	                EAC.DD_EAC_CODIGO IN (''04'',''08'',''11'')       		OR              --TODOS LOS ACTIVOS TERMINADOS (OBRA NUEVA, SEGUNDA MANO)
	                (
	                  EAC.DD_EAC_CODIGO IN (''03'',''07'',''10'')        	AND             --TODOS LOS ACTIVOS TERMINADOS (OBRA NUEVA)
	                  TPD.DD_TPD_CODIGO IN (''12'')		                 	AND          	--TODOS LOS ACTIVOS CON LPO
	                  EDC.DD_EDC_CODIGO = ''01''
	                )
                  )  
          GROUP BY ACT.ACT_ID
) '||V_WHERE||'';
--DBMS_OUTPUT.PUT_LINE(V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' Activos actualizados como singulares');


DBMS_OUTPUT.PUT_LINE('[INFO] Updateamos el DD_TRC_ID de los activos Retail.');

/*******************************************************************************
CALCULAMOS LOS ACTIVOS RETAIL
********************************************************************************/             
V_MSQL :=
'UPDATE #ESQUEMA#.ACT_ACTIVO     ACT                                                                                                         --ACTUALIZAMOS ESTOS CAMPOS DE LOS ACTIVOS:
   SET ACT.DD_TCR_ID        = (SELECT TCR.DD_TCR_ID FROM #ESQUEMA#.DD_TCR_TIPO_COMERCIALIZAR TCR WHERE TCR.DD_TCR_CODIGO IN (''02'')),       --ACTIVO RETAIL
       ACT.USUARIOMODIFICAR = '''||V_USERNAME||''',                                                                                          --USUARIO MODIFICAR 
       ACT.FECHAMODIFICAR   =  SYSDATE                                                                                                       --FECHA MODIFICAR
   WHERE 
   ACT.BORRADO = 0 AND
          ACT.ACT_ID 
          IN 
         (SELECT      ACT.ACT_ID                                                                                                
            FROM      #ESQUEMA#.ACT_ACTIVO                                          ACT
            JOIN      #ESQUEMA#.DD_EAC_ESTADO_ACTIVO                                EAC   ON   ACT.DD_EAC_ID  = EAC.DD_EAC_ID
            JOIN      #ESQUEMA#.DD_TPA_TIPO_ACTIVO                                  TPA   ON   ACT.DD_TPA_ID  = TPA.DD_TPA_ID
            JOIN      #ESQUEMA#.DD_SAC_SUBTIPO_ACTIVO                               SAC   ON   ACT.DD_SAC_ID  = SAC.DD_SAC_ID
            LEFT JOIN #ESQUEMA#.ACT_ADO_ADMISION_DOCUMENTO                          ADO   ON   ACT.ACT_ID     = ADO.ACT_ID
            LEFT JOIN #ESQUEMA#.ACT_CFD_CONFIG_DOCUMENTO                            CFD   ON   ADO.CFD_ID     = CFD.CFD_ID
            LEFT JOIN #ESQUEMA#.DD_TPD_TIPO_DOCUMENTO                               TPD   ON   CFD.DD_TPD_ID  = TPD.DD_TPD_ID
            LEFT JOIN #ESQUEMA#.DD_EDC_ESTADO_DOCUMENTO								EDC   ON   ADO.DD_EDC_ID = EDC.DD_EDC_ID
            WHERE 
                (
	                (
	                	TPA.DD_TPA_CODIGO IN (''02'')                   	OR              --TODOS LOS ACTIVOS QUE SON VIVIENDAS
	                	SAC.DD_SAC_CODIGO IN (''24'',''25'')                              	--TODOS LOS ACTIVOS QUE SON GARAJES O TRASTEROS
	                )                                                 		AND
	                EAC.DD_EAC_CODIGO IN (''04'',''08'',''11'')       		OR              --TODOS LOS ACTIVOS TERMINADOS (OBRA NUEVA, SEGUNDA MANO)
	                (
	                	EAC.DD_EAC_CODIGO IN (''03'',''07'',''10'')         AND             --TODOS LOS ACTIVOS TERMINADOS (OBRA NUEVA)
	                  	TPD.DD_TPD_CODIGO IN (''12'')		                AND          	--TODOS LOS ACTIVOS CON LPO
	                  	EDC.DD_EDC_CODIGO = ''01''
	                )
                ) 
          GROUP BY ACT.ACT_ID
) '||V_WHERE||'';
--DBMS_OUTPUT.PUT_LINE(V_MSQL);
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' Activos actualizados como retail');


DBMS_OUTPUT.PUT_LINE('[FIN] Acaba el proceso CALCULO_SINGULAR_RETAIL_AUTO');
COMMIT;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || TO_CHAR (SQLCODE));
      DBMS_OUTPUT.put_line (SQLERRM);
      ROLLBACK;
      RAISE;
END CALCULO_SINGULAR_RETAIL_AUTO;
/
EXIT

--/*
--#########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20161025
--## ARTEFACTO=migracion
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-962
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración Fase 2, para la generacion de tramites.
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

      V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
      V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
      V_TABLA VARCHAR2(40 CHAR) := 'MIG2_TRA_TRAMITES_OFERTAS'; -- Vble. Tabla pivote
      
      -- Vbls. para el cursor
      V_OFR_ID NUMBER(16) := 0; -- Vble. para almacenar el OFR_ID
      S_TBJ NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TBJ_ID
      S_NUM NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TBJ_NUM_TRABAJO
      S_TRA NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TRA_ID
      S_TAR NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TAR_ID
      S_TEX NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TEX_ID
      
      -- Cursor que almacena las secuencias
      CURSOR CURSOR_OFERTAS IS
      SELECT DISTINCT OFR_ID  FROM REM01.MIG2_TRA_TRAMITES_OFERTAS TRA
      ;

      -- Tablas de volcado
      V_TABLA_TBJ VARCHAR2(30 CHAR) := 'ACT_TBJ_TRABAJO';
      V_TABLA_ACT_TBJ VARCHAR2(30 CHAR) := 'ACT_TBJ';
      V_TABLA_ECO VARCHAR2(30 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL';
      V_TABLA_TRA VARCHAR2(30 CHAR) := 'ACT_TRA_TRAMITE';
      V_TABLA_TAR VARCHAR2(30 CHAR) := 'TAR_TAREAS_NOTIFICACIONES';
      V_TABLA_ETN VARCHAR2(30 CHAR) := 'ETN_EXTAREAS_NOTIFICACIONES';
      V_TABLA_TEX VARCHAR2(30 CHAR) := 'TEX_TAREA_EXTERNA';
      V_TABLA_TAC VARCHAR2(30 CHAR) := 'TAC_TAREAS_ACTIVOS';
      
      -- Vles. para el SP de Altas BPM
      V_IN VARCHAR2(30 CHAR) := 'MIG2'; --Vble. de entrada para el  SP que sera el USUARIOCREAR
      V_OUT VARCHAR2(32000 CHAR); --Vble. de salida para el  SP que almacena la salida del SP
      
BEGIN
    
		  DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------') ;
		  DBMS_OUTPUT.PUT_LINE('PROCESO DE GENERACION DE TRAMITES PARA LAS OFERTAS MIGRADAS EN FASE 2....') ;
		  DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------') ;

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT MIG2_TRA_TRAMITES_OFERTAS --
      ---------------------------------------------------------------------------------------------------------------

      DBMS_OUTPUT.PUT_LINE('[INFO] APROVISIONANDO LA TABLA AUXILIAR '||V_TABLA||'...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO MIG2_TRA_TRAMITES_OFERTAS (
                  OFR_ID
                  ,ACT_ID
                  ,TPO_ID
                  ,TAP_ID
                  ,USU_ID
                  ,SUP_ID
            )
            WITH OFERTAS_VALIDAS AS (
                  SELECT
                        OFR.OFR_ID
                        , ACT.ACT_ID
                        , CASE TOF.DD_TOF_CODIGO
                              WHEN ''01'' 
                                    THEN (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''T013'' AND BORRADO = 0)
                              WHEN ''02'' 
                                    THEN (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''T014'' AND BORRADO = 0)
                        END AS TPO_ID
                        , CASE
                              --Firma propietario
                              WHEN TOF.DD_TOF_CODIGO = ''01'' -- Venta
                                    AND ACH.ACH_CODIGO_HITO = 1 
                                    AND EEC.DD_EEC_CODIGO = ''10'' -- Pent. Sancion
                                    AND PAC_CHECK_FORMALIZAR = 0
                                          THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_FirmaPropietario'')
                              --Resolución comité
                              WHEN TOF.DD_TOF_CODIGO = ''01'' -- Venta
                                    AND ACH.ACH_CODIGO_HITO = 2 
                                    AND EEC.DD_EEC_CODIGO = ''10'' -- Pent. Sancion
                                    AND PAC_CHECK_FORMALIZAR = 1
                                          THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_ResolucionComite'')
                              --Instrucciones reserva
                              WHEN TOF.DD_TOF_CODIGO = ''01'' -- Venta
                                    AND ACH.ACH_CODIGO_HITO = 3 
                                    AND EEC.DD_EEC_CODIGO = ''06'' -- Reservado
                                    AND PAC_CHECK_FORMALIZAR = 1
                                          THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_InstruccionesReserva'')
                              --Informe jurídico
                              WHEN TOF.DD_TOF_CODIGO = ''01'' -- Venta
                                    AND ACH.ACH_CODIGO_HITO = 4 
                                    AND EEC.DD_EEC_CODIGO = ''11'' -- Aprobado
                                    AND PAC_CHECK_FORMALIZAR = 1
                                          THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_InformeJuridico'')
                              --Instrucciones reserva
                              WHEN TOF.DD_TOF_CODIGO = ''01'' -- Venta
                                    AND ACH.ACH_CODIGO_HITO = 5 
                                    AND EEC.DD_EEC_CODIGO = ''11'' -- Reservado
                                    AND PAC_CHECK_FORMALIZAR = 1
                                          THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_InstruccionesReserva'')
                              --Informe jurídico
                              WHEN TOF.DD_TOF_CODIGO = ''01'' -- Venta
                                    AND ACH.ACH_CODIGO_HITO = 6 
                                    AND EEC.DD_EEC_CODIGO = ''04'' -- Contraofertado
                                    AND PAC_CHECK_FORMALIZAR = 1
                                          THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_InformeJuridico'')
                              --Instrucciones reserva
                              WHEN TOF.DD_TOF_CODIGO = ''01'' -- Venta
                                    AND ACH.ACH_CODIGO_HITO = 7 
                                    AND EEC.DD_EEC_CODIGO = ''04'' -- Contraofertado
                                    AND PAC_CHECK_FORMALIZAR = 1
                                          THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_InstruccionesReserva'')
                              --Posicionamiento y firma
                              WHEN TOF.DD_TOF_CODIGO = ''01'' -- Venta
                                    AND ACH.ACH_CODIGO_HITO = 9 
                                    AND EEC.DD_EEC_CODIGO = ''07'' -- Posicionado
                                    AND PAC_CHECK_FORMALIZAR = 1
                                          THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_PosicionamientoYFirma'')
                              --Devolución de llaves HRE
                              WHEN TOF.DD_TOF_CODIGO = ''01'' -- Venta
                                    AND ACH.ACH_CODIGO_HITO = 10 
                                    AND EEC.DD_EEC_CODIGO = ''03'' -- Firmado
                                    AND PAC_CHECK_FORMALIZAR = 1
                                          THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_DevolucionLlaves'')
                              --Documentos post-venta Cierre económico
                              WHEN TOF.DD_TOF_CODIGO = ''01'' -- Venta
                                    AND ACH.ACH_CODIGO_HITO = 11 
                                    AND EEC.DD_EEC_CODIGO = ''03'' -- Firmado
                                    AND PAC_CHECK_FORMALIZAR = 1
                                          THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_DocumentosPostVenta'')
                              --T014_DefinicionOferta
                              WHEN TOF.DD_TOF_CODIGO = ''02'' -- Alquiler
                                          THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T014_DefinicionOferta'')
                        END TAP_ID,
                        (SELECT MAX(GEE.USU_ID) 
                              FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC 
                              JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID
                              WHERE GAC.ACT_ID = ACT.ACT_ID AND GEE.DD_TGE_ID = (SELECT TGE.DD_TGE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''GACT'')
                        ) AS USU_ID,
                      (SELECT MAX(GEE.USU_ID) 
                            FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC 
                            JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID 
                            WHERE GAC.ACT_ID = ACT.ACT_ID AND GEE.DD_TGE_ID = (SELECT TGE.DD_TGE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''SUPACT'')
                      ) AS SUP_ID
                  FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO 
                        INNER JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID AND EEC.BORRADO = 0 
                        INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID AND ECO.BORRADO = 0
                        INNER JOIN '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA TOF ON TOF.DD_TOF_ID = OFR.DD_TOF_ID AND TOF.BORRADO = 0 
                        INNER JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID 
                        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID AND ACT.BORRADO = 0 
                        INNER JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                        INNER JOIN '||V_ESQUEMA||'.MIG2_ACH_ACTIVOS_HITO ACH ON ACH.ACH_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
                  WHERE EEC.DD_EEC_CODIGO IN (''10'',''06'',''11'',''04'',''07'',''03'')  
            )
            SELECT
                  OV.OFR_ID
                  , OV.ACT_ID
                  , OV.TPO_ID
                  , OV.TAP_ID
                  , OV.USU_ID
                  , OV.SUP_ID
            FROM OFERTAS_VALIDAS OV
            WHERE OV.TAP_ID IS NOT NULL
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
--      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      ---------------------------------------------------------------------------------------------------------------
      -- UPDATE MIG2_TRA_TRAMITES_OFERTAS (TBJ_ID, TRA_ID, TAR_ID, TEX_ID) --
      ---------------------------------------------------------------------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('[INFO] GENERANDO TBJ_ID, TRA_ID, TAR_ID, TEX_ID...');
      
      OPEN CURSOR_OFERTAS;
      
      LOOP
            FETCH CURSOR_OFERTAS INTO V_OFR_ID;
            EXIT WHEN CURSOR_OFERTAS%NOTFOUND;
            
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_ACT_TBJ_TRABAJO.NEXTVAL FROM DUAL' INTO S_TBJ;
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_TBJ_NUM_TRABAJO.NEXTVAL FROM DUAL' INTO S_NUM;
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_ACT_TRA_TRAMITE.NEXTVAL FROM DUAL' INTO S_TRA;
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL FROM DUAL' INTO S_TAR;
                  EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_TEX_TAREA_EXTERNA.NEXTVAL FROM DUAL' INTO S_TEX;
                  
                  EXECUTE IMMEDIATE '
                        UPDATE '||V_ESQUEMA||'.MIG2_TRA_TRAMITES_OFERTAS TRA
                        SET TRA.TBJ_ID = '||S_TBJ||'
                              , TRA.TBJ_NUM_TRABAJO = '||S_NUM||'
                              , TRA.TRA_ID = '||S_TRA||'
                              , TRA.TAR_ID = '||S_TAR||'
                              , TRA.TEX_ID = '||S_TEX||'
                        WHERE OFR_ID = '||V_OFR_ID||'
                  '
                  ;
                  
      END LOOP;
      
      CLOSE CURSOR_OFERTAS; 
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada.';
      
--      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      ---------------------------------------------------------------------------------------------------------------
      -- UPDATE MIG2_TRA_TRAMITES_OFERTAS (USU_ID, SUP_ID) --
      ---------------------------------------------------------------------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO USU_ID Y SUP_ID...');
      
      EXECUTE IMMEDIATE '
            MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' MIG2
            USING 
            (
                WITH USU_ID AS (
                      SELECT
                            TRA.ACT_ID
                            , MAX(USU_GEE.USU_ID) AS USU_ID
                      FROM '||V_TABLA||' TRA
                        JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = TRA.ACT_ID
                        JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD USU_GEE ON USU_GEE.GEE_ID = GAC.GEE_ID AND USU_GEE.DD_TGE_ID = (SELECT TGE.DD_TGE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''GACT'')
                        GROUP BY TRA.ACT_ID, USU_GEE.USU_ID
                ), SUP_ID AS (
                      SELECT
                            TRA.ACT_ID
                            , MAX(SUP_GEE.USU_ID) AS USU_ID
                      FROM '||V_TABLA||' TRA
                        JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = TRA.ACT_ID
                        JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD SUP_GEE ON SUP_GEE.GEE_ID = GAC.GEE_ID AND SUP_GEE.DD_TGE_ID = (SELECT TGE.DD_TGE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''SUPACT'')
                        GROUP BY TRA.ACT_ID, SUP_GEE.USU_ID
                )
                SELECT DISTINCT
                      TRA.ACT_ID
                      , USU_ID.USU_ID AS USU_ID
                      , SUP_ID.USU_ID AS SUP_ID
                FROM '||V_TABLA||' TRA
                    INNER JOIN USU_ID ON USU_ID.ACT_ID = TRA.ACT_ID
                    INNER JOIN SUP_ID ON SUP_ID.ACT_ID = TRA.ACT_ID
            ) AUX
            ON (AUX.ACT_ID = MIG2.ACT_ID)
            WHEN MATCHED THEN UPDATE
                  SET MIG2.USU_ID = AUX.USU_ID
                         , MIG2.SUP_ID = AUX.SUP_ID
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada. '||SQL%ROWCOUNT||' Filas.');
      
--      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      ---------------------------------------------------------------------------------------------------------------
      -- INSERT ACT_TBJ_TRABAJO --
      ---------------------------------------------------------------------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL VOLCADO A LAS TABLAS DEFINITIVAS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TRABAJOS...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TBJ||' (
                  TBJ_ID
                  , AGR_ID
                  , TBJ_NUM_TRABAJO
                  , USU_ID
                  , DD_TTR_ID
                  , DD_STR_ID
                  , DD_EST_ID
                  , TBJ_FECHA_SOLICITUD
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
            )
            SELECT DISTINCT
                  MIG2.TBJ_ID                                             AS TBJ_ID
                  , OFR.AGR_ID                                           AS AGR_ID
                  , MIG2.TBJ_NUM_TRABAJO                         AS TBJ_NUM_TRABAJO
                  , (SELECT USU_ID
                          FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS
                          WHERE USU_USERNAME = ''MIGRACION''
                          AND BORRADO = 0
                    )                                                          AS USU_ID 
                  , (SELECT DD_TTR_ID
                          FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO
                          WHERE DD_TTR_CODIGO = ''06''
                          AND BORRADO = 0
                    )                                                           AS DD_TTR_ID    
                  , CASE TOF.DD_TOF_CODIGO
                          WHEN ''01''
                                THEN (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = ''55'' AND BORRADO = 0)   
                          WHEN ''02''
                                THEN (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = ''56'' AND BORRADO = 0)   
                    END                                                     AS DD_STR_ID 
                  , (SELECT DD_EST_ID
                          FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO
                          WHERE DD_EST_CODIGO = ''04''
                          AND BORRADO = 0
                    )                                                           AS DD_EST_ID 
                  , SYSDATE                                              AS TBJ_FECHA_SOLICITUD
                  , 0                                                          AS VERSION
                  , ''MIG2''                                                   AS USUARIOCREAR
                  , SYSDATE                                              AS FECHACREAR
                  , 0                                                           AS BORRADO
            FROM '||V_ESQUEMA||'.MIG2_TRA_TRAMITES_OFERTAS MIG2
                  INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = MIG2.OFR_ID
                  INNER JOIN '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA TOF ON TOF.DD_TOF_ID = OFR.DD_TOF_ID      
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TBJ||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
--      COMMIT;

      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_TBJ||' COMPUTE STATISTICS');
      
      ---------------------------------------------------------------------------------------------------------------
      -- INSERT ACT_TBJ --
      ---------------------------------------------------------------------------------------------------------------

      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO RELACION ACTIVOS-TRABAJOS...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ACT_TBJ||' (
                  ACT_ID
                  ,TBJ_ID
                  ,ACT_TBJ_PARTICIPACION
                  ,VERSION
            )
            WITH PARTICIPACION AS (
                  SELECT
                        MIG2.TBJ_ID              AS TBJ_ID
                        , COUNT(1)              AS TOTAL
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  GROUP BY MIG2.TBJ_ID
            )
            SELECT DISTINCT
                  MIG2.ACT_ID                                         AS ACT_ID
                  , MIG2.TBJ_ID                                        AS TBJ_ID
                  , ROUND(100/NVL(TOTAL,1),2)             AS ACT_TBJ_PARTICIPACION
                  , 0                                                       AS VERSION
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN PARTICIPACION PAR ON PAR.TBJ_ID = MIG2.TBJ_ID    
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_ACT_TBJ||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
--      COMMIT;

      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_ACT_TBJ||' COMPUTE STATISTICS'); 
      
      ---------------------------------------------------------------------------------------------------------------
      -- UPDATE ECO_EXPEDIENTE_COMERCIAL (TBJ_ID) --
      ---------------------------------------------------------------------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO EL TRABAJO DE LOS EXPEDIENTES COMERCIALES...');
      
      EXECUTE IMMEDIATE '
            MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ECO||' ECO
            USING 
            (
                  SELECT DISTINCT OFR_ID, TBJ_ID
                  FROM '||V_ESQUEMA||'.'||V_TABLA||'
            ) AUX
            ON (AUX.OFR_ID = ECO.OFR_ID)
            WHEN MATCHED THEN UPDATE
                  SET ECO.TBJ_ID = AUX.TBJ_ID            
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_ECO||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
--      COMMIT;

      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_ECO||' COMPUTE STATISTICS'); 
      
      ---------------------------------------------------------------------------------------------------------------
      -- INSERT ACT_TRA_TRAMITE --
      ---------------------------------------------------------------------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TRAMITES...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TRA||'
            (
                  TRA_ID
                  ,TBJ_ID
                  ,DD_TPO_ID
                  ,DD_EPR_ID
                  ,TRA_DECIDIDO
                  ,TRA_PROCESS_BPM
                  ,TRA_PARALIZADO
                  ,TRA_FECHA_INICIO
                  ,VERSION
                  ,USUARIOCREAR
                  ,FECHACREAR
                  ,BORRADO
                  ,DD_TAC_ID
            )
            SELECT DISTINCT
                  MIG2.TRA_ID                                                                         AS TRA_ID
                  , MIG2.TBJ_ID                                                                        AS TBJ_ID
                  , MIG2.TPO_ID                                                                       AS DD_TPO_ID
                  , (SELECT DD_EPR_ID 
                        FROM '||V_ESQUEMA_MASTER||'.DD_EPR_ESTADO_PROCEDIMIENTO 
                        WHERE DD_EPR_CODIGO = ''10''
                        AND BORRADO = 0
                  )                                                                                           AS DD_EPR_ID
                  , 0                                                                                        AS TRA_DECIDIDO
                  , NULL                                                                                  AS TRA_PROCESS_BPM
                  , 0                                                                                        AS TRA_PARALIZADO
                  , SYSDATE                                                                           AS TRA_FECHA_INICIO
                  , 1                                                                                        AS VERSION
                  , ''MIG2''                                                                                 AS USUARIOCREAR
                  , SYSDATE                                                                           AS FECHACREAR         
                  , 0                                                                                        AS BORRADO
                  , (SELECT DD_TAC_ID 
                          FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION  
                          WHERE DD_TAC_CODIGO = ''GES''
                          AND BORRADO = 0
                  )                                                                                           AS DD_TAC_ID
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TRA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      COMMIT;

      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_TRA||' COMPUTE STATISTICS');
      
      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TAR_TAREAS_NOTIFICACIONES --
      ---------------------------------------------------------------------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TAREAS NOTIFICACIONES...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TAR||'
            (
                  TAR_ID
                  , DD_EIN_ID
                  , DD_STA_ID
                  , TAR_CODIGO
                  , TAR_TAREA
                  , TAR_DESCRIPCION
                  , TAR_FECHA_INI
                  , TAR_EN_ESPERA
                  , TAR_ALERTA
                  , TAR_TAREA_FINALIZADA
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
                  , TAR_FECHA_VENC
                  , DTYPE
                  , NFA_TAR_REVISADA
            )
            SELECT DISTINCT
                  MIG2.TAR_ID                                                                               AS TAR_ID
                  , (SELECT EIN.DD_EIN_ID 
                          FROM '||V_ESQUEMA_MASTER||'.DD_EIN_ENTIDAD_INFORMACION EIN 
                          WHERE EIN.DD_EIN_CODIGO = ''61''
                          AND BORRADO = 0
                  )                                                                                                 AS DD_EIN_ID
                  , STA.DD_STA_ID                                                                         AS DD_STA_ID
                  , 1                                                                                              AS TAR_CODIGO
                  , TAP.TAP_DESCRIPCION                                                               AS TAR_TAREA
                  , TAP.TAP_DESCRIPCION                                                               AS TAR_DESCRIPCION
                  , SYSDATE                                                                                 AS TAR_FECHA_INI
                  , 0                                                                                             AS TAR_EN_ESPERA
                  , 0                                                                                              AS TAR_ALERTA
                  , 0                                                                                             AS TAR_TAREA_FINALIZADA
                  , 0                                                                                             AS VERSION
                  , ''MIG2''                                                                                      AS USUARIOCREAR
                  , SYSDATE                                                                                 AS FECHACREAR
                  , 0                                                                                             AS BORRADO
                  , (SELECT SYSDATE + 3 FROM DUAL)                                          AS TAR_FECHA_VENC
                  , ''EXTTareaNotificacion''                                                               AS DTYPE
                  , 0                                                                                             AS NFA_TAR_REVISADA
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG2.TAP_ID
                  INNER JOIN '||V_ESQUEMA_MASTER||'.DD_STA_SUBTIPO_TAREA_BASE STA ON STA.DD_STA_ID = TAP.DD_STA_ID
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TAR||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
--      COMMIT;

      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_TAR||' COMPUTE STATISTICS');
      
      ---------------------------------------------------------------------------------------------------------------
      -- INSERT ETN_EXTAREAS_NOTIFICACIONES --
      ---------------------------------------------------------------------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TAREAS EXTERNAS NOTIFICACIONES...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ETN||'
            (
                  TAR_ID
                  ,TAR_FECHA_VENC_REAL
            )
            SELECT DISTINCT
                  MIG2.TAR_ID
                  ,(SELECT SYSDATE + 3 FROM DUAL) AS TAR_FECHA_VENC_REAL
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_ETN||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
--      COMMIT;

      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_ETN||' COMPUTE STATISTICS');

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TEX_TAREA_EXTERNA --
      ---------------------------------------------------------------------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO TAREAS EXTERNAS...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TEX||'
            (
                  TEX_ID
                  , TAR_ID
                  , TAP_ID
                  , TEX_TOKEN_ID_BPM
                  , TEX_DETENIDA
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
                  , TEX_NUM_AUTOP
                  , DTYPE
            )
            SELECT DISTINCT
                  MIG2.TEX_ID             AS TEX_ID
                  , MIG2.TAR_ID          AS TAR_ID
                  , MIG2.TAP_ID           AS TAP_ID
                  , NULL                     AS TEX_TOKEN_ID_BPM
                  , 0                           AS TEX_DETENIDA
                  , 0                           AS VERSION
                  , ''MIG2''                 AS USUARIOCREAR
                  , SYSDATE               AS FECHACREAR
                  , 0                              AS BORRADO
                  , 0                             AS TEX_NUM_AUTOP
                  , ''EXTTareaExterna''     AS DTYPE
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG2.TAP_ID
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TEX||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
--      COMMIT;

      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_TEX||' COMPUTE STATISTICS');

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT TAC_TAREAS_ACTIVOS --
      ---------------------------------------------------------------------------------------------------------------
      
      DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO RELACION TAREAS ACTIVOS...');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TAC||'
            (
                  TAR_ID
                  , TRA_ID
                  , ACT_ID
                  , USU_ID
                  , SUP_ID
                  , VERSION
                  , USUARIOCREAR
                  , FECHACREAR
                  , BORRADO
            )
            WITH UNICO_ACTIVO AS (
                  SELECT DISTINCT
                        MIG2.TAR_ID          
                        , MIG2.TRA_ID       
                        , MIG2.ACT_ID       
                        , MIG2.USU_ID        
                        , MIG2.SUP_ID        
                        , ROW_NUMBER () OVER (PARTITION BY MIG2.TAR_ID ORDER BY MIG2.ACT_ID DESC) AS ORDEN
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
            )
            SELECT
                  UA.TAR_ID             AS TAR_ID
                  , UA.TRA_ID           AS TRA_ID
                  , UA.ACT_ID           AS ACT_ID
                  , UA.USU_ID           AS USU_ID
                  , UA.SUP_ID           AS SUP_ID
                  , 0                       AS VERSION
                  , ''MIG2''                AS USUARIOCREAR
                  , SYSDATE           AS FECHACREAR
                  ,0                        AS BORRADO
            FROM UNICO_ACTIVO UA
            WHERE UA.ORDEN = 1
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TAC||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
     COMMIT;

      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_TAC||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO DE GENERACION DE TRAMITES PARA LAS OFERTAS MIGRADAS EN FASE 2.');

      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------') ;
      DBMS_OUTPUT.PUT_LINE('PROCESO DE ALTAS DE INSTANCIAS PARA LOS BPMS...') ;
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------') ;
      
      REM01.ALTA_BPM_INSTANCES(V_IN,V_OUT);
      
EXCEPTION
      WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.put_line('-----------------------------------------------------------');
            DBMS_OUTPUT.put_line(SQLERRM);
            ROLLBACK;
            RAISE;
END;

/

EXIT;

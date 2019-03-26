--/*
--#########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180823
--## ARTEFACTO=migracion
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-962
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración Fase 2, para la generacion de tramites.
--##                    
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial GUILLEM REY
--##		0.2 Evitar violación PK TAR y TEX SOG
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

      V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
      V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
      V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
      V_TABLA VARCHAR2(40 CHAR) := 'MIG2_TRA_TRAMITES_OFERTAS'; -- Vble. Tabla pivote
      V_SENTENCIA VARCHAR2(2600 CHAR);
      V_UPDATE NUMBER(16);

      -- Vbls. para el cursor
      V_OFR_ID NUMBER(16) := 0; -- Vble. para almacenar el OFR_ID
      V_TAP_ID NUMBER(16) := 0; -- Vble. para almacenar el TAP_ID
      S_TBJ NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TBJ_ID
      S_NUM NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TBJ_NUM_TRABAJO
      S_TRA NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TRA_ID
      S_TAR NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TAR_ID
      S_TEX NUMBER(16) := 0; -- Vble. para almacenar la secuencia generada para el TEX_ID
      
      -- Cursor que almacena las secuencias
      CURSOR CURSOR_OFERTAS IS
      SELECT DISTINCT OFR_ID  FROM REM01.MIG2_TRA_TRAMITES_OFERTAS TRA
      ;
      
      --Cursos que almacena las TAP
      CURSOR CURSOR_TAP IS
      SELECT DISTINCT TAP_ID FROM REM01.MIG2_TRA_TRAMITES_OFERTAS TRA WHERE TRA.OFR_ID = V_OFR_ID
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
      
BEGIN

      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------') ;
      DBMS_OUTPUT.PUT_LINE('PROCESO DE GENERACION DE TRAMITES PARA LAS OFERTAS MIGRADAS EN FASE 2....') ;
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------') ;

      ---------------------------------------------------------------------------------------------------------------
      -- INSERT MIG2_TRA_TRAMITES_OFERTAS --
      ---------------------------------------------------------------------------------------------------------------

      DBMS_OUTPUT.PUT_LINE('[INFO] APROVISIONANDO LA TABLA AUXILIAR '||V_TABLA||'...');
       EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.MIG2_TRA_TRAMITES_OFERTAS';
      /*EXECUTE IMMEDIATE '
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
                              WHEN OFR.DD_EOF_ID =(SELECT DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO=''01'')
                                AND TOF.DD_TOF_CODIGO = ''01''
                                AND EEC.DD_EEC_CODIGO IN (''10'') -- Pte. Sanción 
                                AND PAC.PAC_CHECK_FORMALIZAR = 1
                                AND (ECO.DD_COS_ID IS NOT NULL AND  ECO.DD_COS_ID <> (SELECT DD_COS_ID FROM DD_COS_COMITES_SANCION WHERE DD_COS_COMITES_SANCION.DD_COS_CODIGO=''3''))
                                AND ECO.ECO_FECHA_SANCION_COMITE IS NULL
                                        THEN (SELECT TAP.TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_ResolucionComite'' AND BORRADO = 0)
                             
                              WHEN OFR.DD_EOF_ID =(SELECT DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO=''01'')
                                AND TOF.DD_TOF_CODIGO = ''01''
                                AND EEC.DD_EEC_CODIGO IN (''10'') -- Pte. Sanción 
                                AND ECO.DD_COS_ID IS NULL 
                                AND ECO.ECO_FECHA_SANCION_COMITE IS NULL
                                        THEN (SELECT TAP.TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_DefinicionOferta'' AND BORRADO = 0)
                              
                              WHEN OFR.DD_EOF_ID =(SELECT DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO=''01'')
                                AND PAC.PAC_CHECK_FORMALIZAR = 0
                                        THEN (SELECT TAP.TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_DefinicionOferta'' AND BORRADO = 0)

                              WHEN OFR.DD_EOF_ID =(SELECT DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO=''01'')
                                AND TOF.DD_TOF_CODIGO = ''01''       
                                AND PAC.PAC_CHECK_FORMALIZAR = 1
                                AND (
                                (
                                EEC.DD_EEC_CODIGO IN (''06'') -- Reservado 
                                AND RES.RES_FECHA_FIRMA IS NOT NULL --Con reserva firmada
                                )
                                OR (
                                EEC.DD_EEC_CODIGO IN (''11'') -- Aprobado 
                                AND RES.ECO_ID IS NULL -- Sin reserva
                                AND ECO.ECO_FECHA_SANCION_COMITE IS NOT NULL-- Con fecha comite
                                AND ECO.ECO_FECHA_ANULACION IS NULL -- sin fecha anulacion
                                AND (ECO.DD_COS_ID IS NOT NULL AND  ECO.DD_COS_ID <> (SELECT DD_COS_ID FROM DD_COS_COMITES_SANCION WHERE DD_COS_COMITES_SANCION.DD_COS_CODIGO=''3''))--comite bankia
                                )
                                OR (
                                EEC.DD_EEC_CODIGO IN (''11'') -- Aprobado 
                                AND RES.ECO_ID IS NULL -- Sin reserva
                                AND ECO.ECO_FECHA_ANULACION IS NULL -- sin fecha anulacion
                                AND (ECO.DD_COS_ID IS NOT NULL AND  ECO.DD_COS_ID = (SELECT DD_COS_ID FROM DD_COS_COMITES_SANCION WHERE DD_COS_COMITES_SANCION.DD_COS_CODIGO=''3''))--comite plataforma
                                )
                                )
                                        THEN (SELECT TAP.TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_ResultadoPBC'' AND BORRADO = 0)
                              
                              WHEN OFR.DD_EOF_ID =(SELECT DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO=''01'')
                                AND TOF.DD_TOF_CODIGO = ''01''
                                AND(
                                (
                                EEC.DD_EEC_CODIGO IN (''11'')  -- Aprobado 
                                AND RES.RES_ID IS NULL
                                )
                                OR 
                                (
                                EEC.DD_EEC_CODIGO IN (''06'')  -- Reservado
                                AND RES.RES_ID IS NOT NULL
                                )
                                )
                                AND ECO.ECO_ESTADO_PBC = 1
                                AND ECO.ECO_FECHA_VENTA IS NULL
                               -- AND POS.POS_FECHA_POSICIONAMIENTO IS NOT NULL
                                AND PAC.PAC_CHECK_FORMALIZAR = 1
                                        THEN (SELECT TAP.TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_ResultadoPBC'' AND BORRADO = 0)                            
                              
                              WHEN OFR.DD_EOF_ID =(SELECT DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO=''01'')
                                AND TOF.DD_TOF_CODIGO = ''01''
                                AND EEC.DD_EEC_CODIGO IN (''11'') -- Aprobado 
                                AND RES.ECO_ID IS NOT NULL -- Con reserva
                                AND(
                                (ECO.ECO_FECHA_SANCION_COMITE IS NOT NULL
                                AND (ECO.DD_COS_ID IS NOT NULL AND  ECO.DD_COS_ID <> (SELECT DD_COS_ID FROM DD_COS_COMITES_SANCION WHERE DD_COS_COMITES_SANCION.DD_COS_CODIGO=''3''))--comite bankia
                                )
                                OR 
                                (
                                 (ECO.DD_COS_ID IS NOT NULL AND  ECO.DD_COS_ID = (SELECT DD_COS_ID FROM DD_COS_COMITES_SANCION WHERE DD_COS_COMITES_SANCION.DD_COS_CODIGO=''3''))--comite plataforma
                                )
                                )
                                AND ECO.ECO_FECHA_ANULACION IS NULL
                                AND PAC.PAC_CHECK_FORMALIZAR = 1
                                        THEN (SELECT TAP.TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_InstruccionesReserva'' AND BORRADO = 0)                            

                              WHEN OFR.DD_EOF_ID =(SELECT DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO=''01'')
                                AND EEC.DD_EEC_CODIGO IN (''04'') -- Contraofertado 
                                AND OFR.OFR_FECHA_CONTRAOFERTA IS NOT NULL
                                AND PAC.PAC_CHECK_FORMALIZAR = 1
                                AND TOF.DD_TOF_CODIGO = ''01''
                                        THEN (SELECT TAP.TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_RespuestaOfertante'' AND BORRADO = 0)  
                            
                              WHEN TOF.DD_TOF_CODIGO = ''02'' -- Alquiler
                                          THEN (SELECT TAP.TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T014_DefinicionOferta'' AND BORRADO = 0)
                        END TAP_ID,
                        NULL AS USU_ID,
                        NULL AS SUP_ID
                  FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO 
                        INNER JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID AND EEC.BORRADO = 0 
                        INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID AND ECO.BORRADO = 0
                        INNER JOIN '||V_ESQUEMA||'.MIG2_OFR_OFERTAS MIG2 ON MIG2.OFR_COD_OFERTA = OFR.OFR_NUM_OFERTA
                        INNER JOIN '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA TOF ON TOF.DD_TOF_ID = OFR.DD_TOF_ID AND TOF.BORRADO = 0 
                        INNER JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID 
                        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID AND ACT.BORRADO = 0 
                        INNER JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                        LEFT JOIN '||V_ESQUEMA||'.RES_RESERVAS RES ON RES.ECO_ID = ECO.ECO_ID
                  WHERE ECO.TBJ_ID IS NULL AND EEC.DD_EEC_CODIGO IN (''10'',''06'',''11'',''04'') -- Pte. Sanción || Reservado || Aprobado || Contraofertado
            )
            SELECT DISTINCT
                  OV.OFR_ID
                  , OV.ACT_ID
                  , OV.TPO_ID
                  , OV.TAP_ID
                  , OV.USU_ID
                  , OV.SUP_ID
            FROM OFERTAS_VALIDAS OV
            WHERE OV.TAP_ID IS NOT NULL
      '
      ;*/
      
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
							  WHEN  MIG2.OFR_COD_ESTADO_OFERTA IN (''01-01'')
									THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_ResolucionComite'' AND BORRADO = 0)
							  WHEN  MIG2.OFR_COD_ESTADO_OFERTA IN (''01-10'',''01-14'')
									THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_DefinicionOferta'' AND BORRADO = 0)
							  WHEN  MIG2.OFR_COD_ESTADO_OFERTA IN (''01-11'')
									THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_ObtencionContratoReserva'' AND BORRADO = 0)
							  WHEN  MIG2.OFR_COD_ESTADO_OFERTA IN (''01-12'',''01-13'',''01-17'',''01-18'')
									THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_ResultadoPBC'' AND BORRADO = 0)
							  WHEN  MIG2.OFR_COD_ESTADO_OFERTA IN (''01-04'')
									THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_RespuestaOfertante'' AND BORRADO = 0)
							  WHEN  MIG2.OFR_COD_ESTADO_OFERTA IN (''01-16'')
									THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_InstruccionesReserva'' AND BORRADO = 0)
							  WHEN  MIG2.OFR_COD_ESTADO_OFERTA IN (''01-20'',''01-21'',''01-22'',''01-23'')
									THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_PosicionamientoYFirma'' AND BORRADO = 0)
							  WHEN  MIG2.OFR_COD_ESTADO_OFERTA IN (''01-24'',''01-25'')
									THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_DocumentosPostVenta'' AND BORRADO = 0)
							  WHEN  MIG2.OFR_COD_ESTADO_OFERTA IN (''01-01'',''01-02'',''01-03'',''01-04'',''01-06'') AND TOF.DD_TOF_CODIGO = ''01''
									THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_DefinicionOferta'' AND BORRADO = 0)
							  WHEN  MIG2.OFR_COD_ESTADO_OFERTA IN (''01-01'',''01-02'',''01-03'',''01-04'',''01-06'') AND TOF.DD_TOF_CODIGO = ''02''
									THEN (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T014_DefinicionOferta'' AND BORRADO = 0)  
                          END TAP_ID
                        , NULL AS USU_ID
                        , NULL AS SUP_ID
                  FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO 
                        INNER JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID AND EEC.BORRADO = 0 
                        INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID AND ECO.BORRADO = 0
                        INNER JOIN '||V_ESQUEMA||'.MIG2_OFR_OFERTAS MIG2 ON MIG2.OFR_COD_OFERTA = OFR.OFR_NUM_OFERTA
                        INNER JOIN '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA TOF ON TOF.DD_TOF_ID = OFR.DD_TOF_ID AND TOF.BORRADO = 0 
                        INNER JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID 
                        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID AND ACT.BORRADO = 0 
                        INNER JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                        LEFT JOIN '||V_ESQUEMA||'.RES_RESERVAS RES ON RES.ECO_ID = ECO.ECO_ID
                  WHERE ECO.TBJ_ID IS NULL AND MIG2.OFR_COD_ESTADO_OFERTA NOT IN (''01-08'',''01-09'',''02'',''03'',''04'')
            )
            SELECT DISTINCT
                    OV.OFR_ID
                  , OV.ACT_ID
                  , OV.TPO_ID
                  , OV.TAP_ID
                  , OV.USU_ID
                  , OV.SUP_ID
            FROM OFERTAS_VALIDAS OV
            WHERE OV.TAP_ID IS NOT NULL
      ';
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      EXECUTE IMMEDIATE '
			INSERT INTO MIG2_TRA_TRAMITES_OFERTAS (
							   OFR_ID
							  ,ACT_ID
							  ,TPO_ID
							  ,TAP_ID
							  ,USU_ID
							  ,SUP_ID
						)
			SELECT TRA.OFR_ID,
				   TRA.ACT_ID,
				   TRA.TPO_ID,
				   (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T013_InformeJuridico'' AND BORRADO = 0) AS TAP_ID,
				   TRA.USU_ID,
				   TRA.SUP_ID
			FROM '||V_ESQUEMA||'.MIG2_TRA_TRAMITES_OFERTAS TRA
			JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = TRA.OFR_ID
			JOIN '||V_ESQUEMA||'.MIG2_OFR_OFERTAS MIG2 ON MIG2.OFR_COD_OFERTA = OFR.OFR_NUM_OFERTA
			WHERE MIG2.OFR_COD_ESTADO_OFERTA IN (''01-12'',''01-13'')
      ';
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');

      
      --Tareas, excepto (T013_ResultadoPBC) 
      --T013_DefinicionOferta, T013_InstruccionesReserva, T013_RespuestaOfertante, T013_ResolucionComite, T014_DefinicionOferta --> USU_ID, SUP_ID
      --Faltaban: T013_DocumentosPostVenta, T013_PosicionamientoYFirma, T013_ObtencionContratoReserva
      
      V_UPDATE := 0;
      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRA_TRAMITES_OFERTAS T1
        USING (
            SELECT DISTINCT MIG.OFR_ID, GEE.USU_ID
            FROM REM01.MIG2_TRA_TRAMITES_OFERTAS MIG
            JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG.TAP_ID AND TAP.TAP_CODIGO IN (''T013_DefinicionOferta'',''T013_InstruccionesReserva'',''T013_RespuestaOfertante'',''T013_ResolucionComite'',''T014_DefinicionOferta'',''T013_DocumentosPostVenta'',''T013_PosicionamientoYFirma'',''T013_ObtencionContratoReserva'')
            JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = MIG.OFR_ID
            JOIN REM01.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
            JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID
            JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''HAYAGBOINM'') T2
        ON (T1.OFR_ID = T2.OFR_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.USU_ID = T2.USU_ID';
      V_UPDATE := SQL%ROWCOUNT;

      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRA_TRAMITES_OFERTAS T1
        USING (SELECT GEE.USU_ID, GAC.ACT_ID, ROW_NUMBER() OVER(PARTITION BY GAC.ACT_ID ORDER BY GEE.USU_ID DESC) RN
          FROM REM01.GEE_GESTOR_ENTIDAD GEE
          JOIN REM01.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
          JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''HAYAGBOINM'') T2
        ON (T1.ACT_ID = T2.ACT_ID AND T2.RN = 1)
        WHEN MATCHED THEN UPDATE SET
          T1.USU_ID = T2.USU_ID
        WHERE T1.USU_ID IS NULL AND T1.TAP_ID IN (SELECT TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO IN (''T013_DefinicionOferta'',''T013_InstruccionesReserva'',''T013_RespuestaOfertante'',''T013_ResolucionComite'',''T014_DefinicionOferta'',''T013_DocumentosPostVenta'',''T013_PosicionamientoYFirma'',''T013_ObtencionContratoReserva''))';
      V_UPDATE := V_UPDATE + SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (Gestor comercial). '||V_UPDATE||' Filas.');

      V_UPDATE := 0;
      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRA_TRAMITES_OFERTAS T1
        USING (
            SELECT DISTINCT MIG.OFR_ID, GEE.USU_ID, TGE.DD_TGE_CODIGO
            FROM REM01.MIG2_TRA_TRAMITES_OFERTAS MIG
            JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG.TAP_ID AND TAP.TAP_CODIGO IN (''T013_DefinicionOferta'',''T013_InstruccionesReserva'',''T013_RespuestaOfertante'',''T013_ResolucionComite'',''T014_DefinicionOferta'',''T013_DocumentosPostVenta'',''T013_PosicionamientoYFirma'',''T013_ObtencionContratoReserva'')
            JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = MIG.OFR_ID
            JOIN REM01.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
            JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID
            JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''SBACKOFFICEINMLIBER'') T2
        ON (T1.OFR_ID = T2.OFR_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.SUP_ID = T2.USU_ID';
      V_UPDATE := SQL%ROWCOUNT;

      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRA_TRAMITES_OFERTAS T1
        USING (SELECT GEE.USU_ID, GAC.ACT_ID, ROW_NUMBER() OVER(PARTITION BY GAC.ACT_ID ORDER BY GEE.USU_ID DESC) RN
          FROM REM01.GEE_GESTOR_ENTIDAD GEE
          JOIN REM01.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
          JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''SBACKOFFICEINMLIBER'') T2
        ON (T1.ACT_ID = T2.ACT_ID AND T2.RN = 1)
        WHEN MATCHED THEN UPDATE SET
          T1.SUP_ID = T2.USU_ID
        WHERE T1.SUP_ID IS NULL AND T1.TAP_ID IN (SELECT TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO IN (''T013_DefinicionOferta'',''T013_InstruccionesReserva'',''T013_RespuestaOfertante'',''T013_ResolucionComite'',''T014_DefinicionOferta'',''T013_DocumentosPostVenta'',''T013_PosicionamientoYFirma'',''T013_ObtencionContratoReserva''))';
      V_UPDATE := V_UPDATE + SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (Supervisor comercial). '||V_UPDATE||' Filas.');

        
      --T013_ResultadoPBC --> USU_ID, SUP_ID
      
      V_UPDATE := 0;
      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRA_TRAMITES_OFERTAS T1
        USING (
            SELECT DISTINCT MIG.OFR_ID, GEE.USU_ID, TGE.DD_TGE_CODIGO
            FROM REM01.MIG2_TRA_TRAMITES_OFERTAS MIG
            JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG.TAP_ID AND TAP.TAP_CODIGO = ''T013_ResultadoPBC''
            JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = MIG.OFR_ID
            JOIN REM01.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
            JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID
            JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GFORM'') T2
        ON (T1.OFR_ID = T2.OFR_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.USU_ID = T2.USU_ID';
      V_UPDATE := SQL%ROWCOUNT;

      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRA_TRAMITES_OFERTAS T1
        USING (SELECT GEE.USU_ID, GAC.ACT_ID, ROW_NUMBER() OVER(PARTITION BY GAC.ACT_ID ORDER BY GEE.USU_ID DESC) RN
          FROM REM01.GEE_GESTOR_ENTIDAD GEE
          JOIN REM01.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
          JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''GFORM'') T2
        ON (T1.ACT_ID = T2.ACT_ID AND T2.RN = 1)
        WHEN MATCHED THEN UPDATE SET
          T1.USU_ID = T2.USU_ID
        WHERE T1.USU_ID IS NULL AND T1.TAP_ID = (SELECT TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = (''T013_ResultadoPBC''))';
      V_UPDATE := V_UPDATE + SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (Gestor formalización). '||V_UPDATE||' Filas.');

      V_UPDATE := 0;
      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRA_TRAMITES_OFERTAS T1
        USING (
            SELECT DISTINCT MIG.OFR_ID, GEE.USU_ID
            FROM REM01.MIG2_TRA_TRAMITES_OFERTAS MIG
            JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG.TAP_ID AND TAP.TAP_CODIGO = ''T013_ResultadoPBC''
            JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = MIG.OFR_ID
            JOIN REM01.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
            JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID
            JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''SFORM'') T2
        ON (T1.OFR_ID = T2.OFR_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.SUP_ID = T2.USU_ID';
      V_UPDATE := SQL%ROWCOUNT;

      EXECUTE IMMEDIATE 'MERGE INTO REM01.MIG2_TRA_TRAMITES_OFERTAS T1
        USING (SELECT GEE.USU_ID, GAC.ACT_ID, ROW_NUMBER() OVER(PARTITION BY GAC.ACT_ID ORDER BY GEE.USU_ID DESC) RN
          FROM REM01.GEE_GESTOR_ENTIDAD GEE
          JOIN REM01.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
          JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''SFORM'') T2
        ON (T1.ACT_ID = T2.ACT_ID AND T2.RN = 1)
        WHEN MATCHED THEN UPDATE SET
          T1.SUP_ID = T2.USU_ID
        WHERE T1.SUP_ID IS NULL AND T1.TAP_ID = (SELECT TAP_ID FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = (''T013_ResultadoPBC''))';
      V_UPDATE := V_UPDATE + SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (Supervisor formalización). '||V_UPDATE||' Filas.');
      
      
      
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
                  
                  EXECUTE IMMEDIATE '
                        UPDATE '||V_ESQUEMA||'.MIG2_TRA_TRAMITES_OFERTAS TRA
                        SET TRA.TBJ_ID = '||S_TBJ||'
                              , TRA.TBJ_NUM_TRABAJO = '||S_NUM||'
                              , TRA.TRA_ID = '||S_TRA||'
                        WHERE OFR_ID = '||V_OFR_ID||'
                  '
                  ;
                  
                  
             OPEN CURSOR_TAP;
             
             LOOP
				
				FETCH CURSOR_TAP INTO V_TAP_ID;
                EXIT WHEN CURSOR_TAP%NOTFOUND;
                
					EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL FROM DUAL' INTO S_TAR;
					EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_TEX_TAREA_EXTERNA.NEXTVAL FROM DUAL' INTO S_TEX;
					
					EXECUTE IMMEDIATE '
                             UPDATE '||V_ESQUEMA||'.MIG2_TRA_TRAMITES_OFERTAS TRA
                             SET TRA.TAR_ID = '||S_TAR||'
                             , TRA.TEX_ID = '||S_TEX||'
                             WHERE OFR_ID = '||V_OFR_ID||' AND TAP_ID = '||V_TAP_ID||'
                              '
                              ;
				
				
             END LOOP;
             CLOSE CURSOR_TAP;
                  
      END LOOP;
      
      CLOSE CURSOR_OFERTAS; 
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada.');
      
      ---------------------------------------------------------------------------------------------------------------
      -- UPDATE MIG2_TRA_TRAMITES_OFERTAS (USU_ID, SUP_ID) --
      ---------------------------------------------------------------------------------------------------------------
      
      /*DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO USU_ID Y SUP_ID...');
      
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
                        JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD USU_GEE ON USU_GEE.GEE_ID = GAC.GEE_ID AND USU_GEE.DD_TGE_ID = (SELECT TGE.DD_TGE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''HAYAGBOINM'')
                        GROUP BY TRA.ACT_ID, USU_GEE.USU_ID
                ), SUP_ID AS (
                      SELECT
                            TRA.ACT_ID
                            , MAX(SUP_GEE.USU_ID) AS USU_ID
                      FROM '||V_TABLA||' TRA
                        JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = TRA.ACT_ID
                        JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD SUP_GEE ON SUP_GEE.GEE_ID = GAC.GEE_ID AND SUP_GEE.DD_TGE_ID = (SELECT TGE.DD_TGE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = ''SBACKOFFICEINMLIBER'')
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
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada. '||SQL%ROWCOUNT||' Filas.');*/
      
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
                                THEN (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = ''56'' AND BORRADO = 0)   
                          WHEN ''02''
                                THEN (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = ''55'' AND BORRADO = 0)   
                    END                                                     AS DD_STR_ID 
                  , (SELECT DD_EST_ID
                          FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO
                          WHERE DD_EST_CODIGO = ''04''
                          AND BORRADO = 0
                    )                                                           AS DD_EST_ID 
                  , SYSDATE                                              AS TBJ_FECHA_SOLICITUD
                  , 0                                                          AS VERSION
                  , '''||V_USUARIO||'''                               AS USUARIOCREAR
                  , SYSDATE                                              AS FECHACREAR
                  , 0                                                           AS BORRADO
            FROM '||V_ESQUEMA||'.MIG2_TRA_TRAMITES_OFERTAS MIG2
                  INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = MIG2.OFR_ID
                  INNER JOIN '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA TOF ON TOF.DD_TOF_ID = OFR.DD_TOF_ID 
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TBJ||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
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
                  , '''||V_USUARIO||'''                                                            AS USUARIOCREAR
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
                  , '''||V_USUARIO||'''                                                                       AS USUARIOCREAR
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
                  , '''||V_USUARIO||'''     AS USUARIOCREAR
                  , SYSDATE               AS FECHACREAR
                  , 0                              AS BORRADO
                  , 0                             AS TEX_NUM_AUTOP
                  , ''EXTTareaExterna''     AS DTYPE
            FROM '||V_ESQUEMA||'.'||V_TABLA||' MIG2
                  INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = MIG2.TAP_ID
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TEX||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
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
                  , '''||V_USUARIO||''' AS USUARIOCREAR
                  , SYSDATE           AS FECHACREAR
                  ,0                        AS BORRADO
            FROM UNICO_ACTIVO UA
            WHERE UA.ORDEN = 1
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_TAC||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
     COMMIT;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'',''ACT_TBJ_TRABAJO'',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'',''ACT_TBJ'',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'',''ACT_TRA_TRAMITE'',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'',''TAR_TAREAS_NOTIFICACIONES'',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'',''ETN_EXTAREAS_NOTIFICACIONES'',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'',''TEX_TAREA_EXTERNA'',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'',''TAC_TAREAS_ACTIVOS'',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      
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

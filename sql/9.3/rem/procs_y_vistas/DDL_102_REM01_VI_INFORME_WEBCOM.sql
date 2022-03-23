--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20220323
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-16330
--## PRODUCTO=NO
--## Finalidad: Tabla para almacentar el historico de los informes enviadas a webcom.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2: 20180525 Gustavo Mora. Se filtra borrado = 0 en dis_distribucion de las subconsultas
--##        0.3: 20200610 Juan Beltrán. Optimización Vistas WEBCOM 
--##        0.4: 20200713 Adrián Molina. Aumentar capacidad del campo codPedania
--##	    0.5: 20200826 Juan Bautista Alfonso - - REMVIP-7935 - Modificado fecha posesion para que cargue de la vista V_FECHA_POSESION_ACTIVO
--##        0.6: 20201210 Carlos Santos Vílchez. REMVIP-8448
--##		0.7: 20210202 Carlos Santos Vílchez. REMVIP-8542
--##		0.8: 20210202 Juan José Sanjuan. HREOS-14606 -- GD-1106: Informe Mediador- Enviar siempre ID_INFORME_MEDIADOR_WEBCOM
--##		0.9: 20211118 Ivan Repiso	HREOS-16330 -- Nueva interfaz webcom
--##		1.0: 20211118 Ivan Repiso	HREOS-17215 -- Añadir campos
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_INFORME_WEBCOM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'IWH_INFORME_WEBCOM_HIST'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para almacentar el historico de los informes enviadas a webcom.'; -- Vble. para los comentarios de las tablas

    CUENTA NUMBER;
    
BEGIN
	

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_VISTA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_VISTA||'... Comprobaciones previas');
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe vista '||V_ESQUEMA||'.'||V_TEXT_VISTA||'..');	
	SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER = V_ESQUEMA AND OBJECT_TYPE = 'MATERIALIZED VIEW';
	IF CUENTA>0 THEN
		DBMS_OUTPUT.PUT_LINE('Vista materializada: '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' existe, se procede a eliminarla..');
		EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
		DBMS_OUTPUT.PUT_LINE('Vista materializada borrada OK');
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe vista materializada '||V_ESQUEMA||'.'||V_TEXT_VISTA||'..');
	SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER = V_ESQUEMA AND OBJECT_TYPE = 'VIEW';  
	IF CUENTA>0 THEN
		DBMS_OUTPUT.PUT_LINE('Vista: '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' existe, se procede a eliminarla..');
		EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
		DBMS_OUTPUT.PUT_LINE('Vista borrada OK');
	END IF;
  
  
  	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
  
	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||'..');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';		
	END IF;

	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe secuencia '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'..');
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
	END IF; 

   -- Creamos vista materializada
	DBMS_OUTPUT.PUT_LINE('[INFO] Crear nueva vista materializada : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'..');
  	EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||' 
	AS
		
		WITH ACCION AS (
			SELECT ICO_ID, FECHA_ACCION, ID_USUARIO_REM_ACCION FROM (
			SELECT ICO.ICO_ID,
		        CASE WHEN (ICO.FECHACREAR IS NOT NULL) 
		            THEN CAST(TO_CHAR(ICO.FECHACREAR,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
		            ELSE NULL
		        END FECHA_ACCION,
		        CASE WHEN (ICO.USUARIOMODIFICAR IS NOT NULL) 
		            THEN (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
		            WHERE USU.USU_USERNAME = ICO.USUARIOMODIFICAR)
		            ELSE (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
		            WHERE USU.USU_USERNAME = ICO.USUARIOCREAR) 
		        END ID_USUARIO_REM_ACCION
				FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
			) AUX2
		),
		GPUBL AS (
			SELECT GAC.ACT_ID, GEE.USU_ID,
			USU.USU_NOMBRE || '' '' || USU.USU_APELLIDO1 || '' '' || USU.USU_APELLIDO2 NOMBRE,USU.USU_MAIL
			, ROW_NUMBER() OVER(PARTITION BY GAC.ACT_ID ORDER BY GEE.GEE_ID DESC) RN
			FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC 
			JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID
			JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON (GEE.DD_TGE_ID = TGE.DD_TGE_ID AND DD_TGE_CODIGO = ''GPUBL'' AND  GEE.BORRADO = 0)
			JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_ID = GEE.USU_ID
		),
		FECHA_RECEP_INFO AS (
            SELECT ACT.ACT_ID, HFP.HFP_FECHA_INI AS FECHA_RECEPCION_INFORME, ROW_NUMBER() OVER(PARTITION BY ACT.ACT_ID ORDER BY HFP.HFP_FECHA_INI DESC) AS RN
            FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID AND ACT.BORRADO = 0
            JOIN '||V_ESQUEMA||'.ACT_HFP_HIST_FASES_PUB HFP ON HFP.ACT_ID = ACT.ACT_ID
            JOIN '||V_ESQUEMA||'.DD_FSP_FASE_PUBLICACION FSP ON HFP.DD_FSP_ID = FSP.DD_FSP_ID AND FSP.DD_FSP_CODIGO = ''05''
            JOIN '||V_ESQUEMA||'.DD_SFP_SUBFASE_PUBLICACION SFP ON SFP.DD_SFP_ID = HFP.DD_SFP_ID AND SFP.DD_SFP_CODIGO = ''09''
        )
		SELECT 
			CAST(  NVL(LPAD(ACT.ACT_ID,10,0) , ''00000'')   
				|| NVL(LPAD(ICO.ICO_ID,8,0) , ''00000000'') AS NUMBER(32,0)) AS ID_INFORME_COMERCIAL,
			CAST(ACT.ACT_NUM_ACTIVO AS NUMBER(16,0)) AS ID_ACTIVO_HAYA,
			CAST(ICO.ICO_ID AS NUMBER(16,0)) AS ID_INFORME_MEDIADOR_REM,
			CAST(ICO.ICO_WEBCOM_ID AS NUMBER(16,0)) AS ID_INFORME_MEDIADOR_WEBCOM,
			CAST(PVE.PVE_COD_REM AS NUMBER(16,0)) AS ID_PROVEEDOR_REM,
			CAST(ESI.DD_AIC_CODIGO AS VARCHAR2(20 CHAR)) AS ESTADO_INFORME,
			CAST(ESI.HIC_MOTIVO AS VARCHAR2(500 CHAR)) AS MOTIVO_RECHAZO,
			CASE WHEN (ICO.ICO_FECHA_ENVIO_LLAVES_API IS NOT NULL) 
				THEN CAST(TO_CHAR(ICO.ICO_FECHA_ENVIO_LLAVES_API ,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
				ELSE NULL
			END AS ENVIO_LLAVES_A_API,
			CASE WHEN (ICO.ICO_RECEPCION_INFORME IS NOT NULL)
				THEN CAST(TO_CHAR(ICO.ICO_RECEPCION_INFORME,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
				WHEN (FRI.FECHA_RECEPCION_INFORME IS NOT NULL) 
				THEN CAST(TO_CHAR(FRI.FECHA_RECEPCION_INFORME,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
				ELSE NULL
			END AS FECHA_RECEPCION_INFORME,
			CASE WHEN (ICO.FECHAMODIFICAR IS NOT NULL) 
				THEN CAST(TO_CHAR(ICO.FECHAMODIFICAR ,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
				ELSE NULL
			END AS ULTIMA_MODIFICACION_INFORME,
			CASE WHEN (ICO.USUARIOMODIFICAR IS NOT NULL) 
				THEN (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
		            WHERE USU.USU_USERNAME = ICO.USUARIOMODIFICAR)
				ELSE NULL
			END AS ULTIMA_MODIFICACION_INFORME_POR,
			CAST(DDTPA.DD_TPA_CODIGO AS VARCHAR2(5 CHAR)) AS COD_TIPO_ACTIVO,
			CAST(DDSAC.DD_SAC_CODIGO AS VARCHAR2(5 CHAR)) AS COD_SUBTIPO_INMUEBLE,
			CAST(DDTVI.DD_TVI_CODIGO AS VARCHAR2(5 CHAR)) AS COD_TIPO_VIA,
			CAST(ICO.ICO_NOMBRE_VIA AS VARCHAR2(100 CHAR)) AS NOMBRE_CALLE,
			CAST(ICO.ICO_NUM_VIA AS VARCHAR2(100 CHAR)) AS NUMERO_CALLE,
			CAST(ICO.ICO_ESCALERA AS VARCHAR2(10 CHAR)) AS ESCALERA,
			CAST(ICO.ICO_PLANTA AS VARCHAR2(11 CHAR)) AS PLANTA,
			CAST(ICO.ICO_PUERTA AS VARCHAR2(17 CHAR)) AS PUERTA,
			CAST(DDUPO.DD_UPO_CODIGO AS VARCHAR2(5 CHAR)) AS COD_PEDANIA,
			CAST(DDLOC.DD_LOC_CODIGO AS VARCHAR2(5 CHAR)) AS COD_MUNICIPIO,
			CAST(DDPRV.DD_PRV_CODIGO AS VARCHAR2(5 CHAR)) AS COD_PROVINCIA,
			CAST(ICO.ICO_CODIGO_POSTAL AS VARCHAR2(250 CHAR)) AS CODIGO_POSTAL,
			CAST(ICO.ICO_LATITUD  AS NUMBER(21,15)) AS LAT,
			CAST(ICO.ICO_LONGITUD AS NUMBER(21,15)) AS LNG,
			CASE WHEN (ICO.ICO_FECHA_RECEP_LLAVES IS NOT NULL) 
				THEN CAST(TO_CHAR(ICO.ICO_FECHA_RECEP_LLAVES ,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
				ELSE NULL
			END AS FECHA_RECEPCION_LLAVES_API,
			CAST(DDTVP.DD_TVP_CODIGO  AS VARCHAR2(5 CHAR)) AS COD_REGIMEN_PROTECCION,
			CAST(PAC.PAC_PORC_PROPIEDAD AS NUMBER(16,2)) AS PORCENTAJE_PROPIEDAD,
			CAST(ICO.ICO_ANO_CONSTRUCCION  AS NUMBER(16,0)) AS ANYO_CONSTRUCCION,
			CAST(ICO.ICO_ANO_REHABILITACION AS NUMBER(16,0)) AS ANYO_REHABILITACION,
			CAST(ICO.ICO_SUP_UTIL AS NUMBER(13,2)) AS UTIL_SUPERFICIE,
			CASE ASCE.DD_SIN_CODIGO
				WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
				WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
				ELSE NULL
			END 											AS ASCENSOR,
			CAST(ICO.ICO_NUM_DORMITORIOS  AS NUMBER(16,0)) AS NUMERO_DORMITORIOS,
			CAST(ICO.ICO_NUM_BANYOS  AS NUMBER(16,0)) AS NUMERO_BANYOS,
			CAST(ICO.ICO_NUM_ASEOS  AS NUMBER(16,0)) AS NUMERO_ASEOS,
			CAST(ICO.ICO_NUM_GARAJE  AS NUMBER(16,0)) AS NUMERO_PLAZAS_GARAJE,	
			CASE TER.DD_SIN_CODIGO
				WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
				WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
				ELSE NULL
			END 											AS TERRAZA,
			CASE PAT.DD_SIN_CODIGO
				WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
				WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
				ELSE NULL
			END 											AS PATIO,	
			CAST(DDTCO.DD_TCO_CODIGO AS VARCHAR2(5 CHAR)) AS COD_TIPO_VENTA,
			CAST(DDCRA.DD_CRA_CODIGO AS VARCHAR2(5 CHAR)) AS COD_CARTERA,
			CAST(DDSCR.DD_SCR_CODIGO AS VARCHAR2(5 CHAR)) AS COD_SUB_CARTERA,
			CAST(ACT.ACT_PERIMETRO_MACC AS NUMBER(1,0)) AS PERIMETRO_MACC,
			CAST(GPB.NOMBRE AS VARCHAR2(60 CHAR)) AS NOMBRE_GESTOR_PUBLICACIONES,
			CAST(GPB.USU_MAIL AS VARCHAR2(60 CHAR)) AS EMAIL_GESTOR_PUBLICACIONES,
			CAST(DDESO.DD_ESO_CODIGO AS VARCHAR2(5 CHAR)) AS COD_ESTADO_OCUPACIONAL,
			CASE REHA.DD_SIN_CODIGO
				WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
				WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
				ELSE NULL
			END 											AS REHABILITADO,
			CASE APER.DD_SIN_CODIGO
				WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
				WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
				ELSE NULL
			END 											AS LICENCIA_APERTURA,
			CASE OBRA.DD_SIN_CODIGO
				WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
				WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
				ELSE NULL
			END 											AS LICENCIA_OBRA,
			CAST(NVL(ACC.FECHA_ACCION, 
				TO_CHAR((SELECT SYSDATE FROM DUAL),''YYYY-MM-DD"T"HH24:MM:SS'')) AS VARCHAR2(50 CHAR)) AS FECHA_ACCION,      
			CAST(NVL(ACC.ID_USUARIO_REM_ACCION, 
		    	(SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
		    	WHERE USU.USU_USERNAME = ''REM-USER'')) AS NUMBER(16,0)) AS ID_USUARIO_REM_ACCION,
			CASE VISI.DD_SIN_CODIGO
				WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
				WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
				ELSE NULL
			END 											AS ES_VISITABLE,
            CAST(TO_CHAR(ICO.ICO_FECHA_ULTIMA_VISITA ,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR)) AS FECHA_ULTIMA_VISITA,
			CAST(ICO.ICO_DESCRIPCION AS 	VARCHAR2(4000 CHAR)) DESCRIPCION_COMERCIAL,
			CAST(ECV.DD_ECV_CODIGO AS  VARCHAR2(5 CHAR))  AS COD_ESTADO_CONSERVACION, 
            CASE GAR.DD_SIN_CODIGO
				WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
				WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
				ELSE NULL
			END 											AS ANEJO_GARAJE,
            CASE TRAS.DD_SIN_CODIGO
				WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
				WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
				ELSE NULL
			END 											AS ANEJO_TRASTERO,
            CAST(RAC.DD_RAC_CODIGO AS VARCHAR2(5 CHAR)) AS COCINA_RATING,
            CASE COCI.DD_SIN_CODIGO
				WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
				WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
				ELSE NULL
			END 											AS COCINA_AMUEBLADA,
		    	

           
            CAST(TCL2.DD_TCL_CODIGO AS VARCHAR2(5 CHAR)) AS COD_CALEFACCION,
            CAST(TCA.DD_TCA_CODIGO AS VARCHAR2(5 CHAR)) AS COD_TIPO_CALEFACCION,
            CAST(TCL.DD_TCL_CODIGO AS VARCHAR2(5 CHAR)) AS COD_AIRE_ACONDICIONADO,
            CASE ARM.DD_SIN_CODIGO
				WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
				WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
				ELSE NULL
			END 											AS EXISTEN_ARMARIOS_EMPOTRADOS,
            CAST(ICO.ICO_SUP_TERRAZA AS NUMBER(13,2)) AS SUPERFICIE_TERRAZA,
            CAST(ICO.ICO_SUP_PATIO AS NUMBER(13,2)) AS SUPERFICIE_PATIO,
            CAST(EXI.DD_EXI_CODIGO AS VARCHAR2(5 CHAR)) AS EXTERIOR_INTERIOR,
            CASE ZVER.DD_SIN_CODIGO
				WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
				WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
				ELSE NULL
			END 											AS EXISTEN_ZONAS_VERDES,
            CASE CONJ.DD_SIN_CODIGO
				WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
				WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
				ELSE NULL
			END 											AS EXISTE_CONSERJE_VIGILANCIA,
            CAST(JAR.DD_DIS_CODIGO AS VARCHAR2(5 CHAR)) AS JARDIN,
           CAST(PIS.DD_DIS_CODIGO AS VARCHAR2(5 CHAR)) AS PISCINA,
             CASE INST.DD_SIN_CODIGO
				WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
				WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
				ELSE NULL
			END 											AS EXISTEN_INSTALACIONES_DEPORTIVAS,
            CAST(GYM.DD_DIS_CODIGO AS VARCHAR2(5 CHAR)) AS GIMNASIO,
            CASE MINUSVA.DD_SIN_CODIGO
				WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
				WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
				ELSE NULL
			END 											AS ACCESO_MINUSVALIDOS_OTRAS_CARACTERISTICAS,
            CAST(ESTC.DD_ESC_CODIGO AS VARCHAR2(5 CHAR))     AS COD_ESTADO_CONSERVACION_EDIFICIO,
            CAST(ICO.ICO_NUM_PLANTAS AS NUMBER(11))         AS NUMERO_PLANTAS_EDIFICIO,
            CAST(TPU.DD_TPU_CODIGO AS VARCHAR2(5 CHAR))     AS COD_TIPO_PUERTA_ACCESO,
            CAST(ESM.DD_ESM_CODIGO AS VARCHAR2(5 CHAR))     AS COD_ESTADO_PUERTAS_INTERIORES,
            CAST(ESM2.DD_ESM_CODIGO AS VARCHAR2(5 CHAR))     AS COD_ESTADO_VENTANAS,
            CAST(ESM3.DD_ESM_CODIGO AS VARCHAR2(5 CHAR))     AS COD_ESTADO_PERSIANAS,
            CAST(ESM4.DD_ESM_CODIGO AS VARCHAR2(5 CHAR))     AS COD_ESTADO_PINTURA,
            CAST(ESM5.DD_ESM_CODIGO AS VARCHAR2(5 CHAR))     AS COD_ESTADO_SOLADOS, 
            CASE MASC.DD_SIN_CODIGO
				WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
				WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
				ELSE NULL
			END 											AS COD_ADMITE_MASCOTA,
            CAST(ESM6.DD_ESM_CODIGO AS VARCHAR2(5 CHAR))     AS COD_ESTADO_BANYOS,
            CAST(VUB.DD_VUB_CODIGO AS VARCHAR2(5 CHAR))     AS COD_VALORACION_UBICACION,
            CAST(UAC.DD_UAC_CODIGO AS VARCHAR2(5 CHAR))     AS COD_UBICACION,
            CASE HUMOS.DD_SIN_CODIGO
                    WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
                    WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
                    ELSE NULL
                END 											AS SALIDA_HUMOS_OTRAS_CARACTERISTICAS,
            CASE BRUTO.DD_SIN_CODIGO
                    WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
                    WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
                    ELSE NULL
                END 											AS APTO_USO_EN_BRUTO,

            CAST(AAC.DD_AAC_CODIGO AS VARCHAR2(5 CHAR))     AS ACCESIBILIDAD,  
            CAST(ICO.ICO_EDIFICABILIDAD AS NUMBER(13,2)) AS EDIFICABILIDAD_SUPERFICIE_TECHO,
            CAST(ICO.ICO_SUP_PARCELA AS NUMBER(13,2)) AS PARCELA_SUPERFICIE,
            CAST(ICO.ICO_URBANIZACION_EJEC AS NUMBER(5,2)) AS PORCENTAJE_URBANIZACION_EJECUTADO,
            CAST(CLA.DD_CLA_CODIGO AS VARCHAR2(5 CHAR))     AS CLASIFICACION,
            CAST(USA.DD_USA_CODIGO AS VARCHAR2(5 CHAR))     AS COD_USO,
            CAST(ICO.ICO_MTRS_FACHADA AS NUMBER(6,2)) AS METROS_LINEALES_FACHADA_PRINCIPAL,
            CASE ALM.DD_SIN_CODIGO
                    WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
                    WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
                    ELSE NULL
                END 											AS ALMACEN,
            CAST(ICO.ICO_SUP_ALMACEN AS NUMBER(13,2)) AS ALMACEN_SUPERFICIE,

        
            CASE VENTAEXPO.DD_SIN_CODIGO
                    WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
                    WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
                    ELSE NULL
                END 											AS SUPERFICIE_VENTA_EXPOSICION,
            CAST(ICO.ICO_SUP_VENTA_EXPO AS NUMBER(13,2)) AS SUPERFICIE_VENTA_EXPOSICION_CONSTRUIDO,
            CASE ENTREP.DD_SIN_CODIGO
                    WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
                    WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
                    ELSE NULL
                END 											AS ENTREPLANTA,
            CAST(ICO.ICO_ALTURA_LIBRE AS NUMBER(6,2)) AS ALTURA,
            CAST(ICO.ICO_EDIFICACION_EJEC AS NUMBER(5,2)) AS PORCENTAJE_EDIFICACION_EJECUTADA,
            CASE OCU.DD_SIN_CODIGO
                    WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
                    WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
                    ELSE NULL
                END 											AS OCUPADO,
            CASE VISI.DD_SIN_CODIGO
                    WHEN ''01'' THEN CAST(''1'' AS NUMBER(1,0))
                    WHEN ''02'' THEN CAST(''0'' AS NUMBER(1,0))
                    ELSE NULL
                END 											AS VISITABLE_FECHA_VISITA,

            CAST(ICO.ICO_VALOR_MIN_VENTA AS NUMBER(15,6)) AS VALOR_ESTIMADO_MIN_VENTA,
            CAST(ICO.ICO_VALOR_MAX_VENTA AS NUMBER(15,6)) AS VALOR_ESTIMADO_MAX_VENTA,
            CAST(ICO.ICO_VALOR_ESTIMADO_VENTA AS NUMBER(15,6)) AS VALOR_ESTIMADO_VENTA,
            CAST(ICO.ICO_VALOR_MAX_RENTA AS NUMBER(15,6)) AS VALOR_ESTIMADO_MAX_RENTA,
            CAST(ICO.ICO_VALOR_MIN_RENTA AS NUMBER(15,6)) AS VALOR_ESTIMADO_MIN_RENTA,
            CAST(ICO.ICO_VALOR_ESTIMADO_RENTA AS NUMBER(15,6)) AS VALOR_ESTIMADO_RENTA,
            CAST(ICO.ICO_NUM_SALONES AS NUMBER(11))         AS NUMERO_SALONES,
            CAST(ICO.ICO_NUM_ESTANCIAS AS NUMBER(11))         AS NUMERO_ESTANCIAS,
            CAST(ICO.ICO_NUM_PLANTAS AS NUMBER(11))         AS NUMERO_PLANTAS
	
			FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
			LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID AND ACT.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID AND APU.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION DDTCO ON DDTCO.DD_TCO_ID = APU.DD_TCO_ID AND DDTCO.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA DDCRA ON DDCRA.DD_CRA_ID = ACT.DD_CRA_ID AND DDCRA.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA DDSCR ON DDSCR.DD_SCR_ID = ACT.DD_SCR_ID AND DDSCR.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = ICO.ICO_MEDIADOR_ID AND PVE.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA||'.DD_TVP_TIPO_VPO DDTVP ON DDTVP.DD_TVP_ID = ICO.DD_TVP_ID AND DDTVP.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA DDTVI ON DDTVI.DD_TVI_ID = ICO.DD_TVI_ID AND DDTVI.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA DDPRV ON DDPRV.DD_PRV_ID = ICO.DD_PRV_ID AND DDPRV.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD DDLOC ON DDLOC.DD_LOC_ID = ICO.DD_LOC_ID AND DDLOC.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL DDUPO ON DDUPO.DD_UPO_ID = ICO.DD_UPO_ID AND DDUPO.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO DDTPA ON DDTPA.DD_TPA_ID = ICO.DD_TPA_ID AND DDTPA.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO DDSAC ON DDSAC.DD_SAC_ID = ICO.DD_SAC_ID AND DDSAC.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA||'.DD_ESO_ESTADO_OCUPACIONAL DDESO ON DDESO.DD_ESO_ID = ICO.DD_ESO_ID AND DDESO.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO REHA ON REHA.DD_SIN_ID = ICO.ICO_REHABILITADO AND REHA.BORRADO = 0	
			LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO APER ON APER.DD_SIN_ID = ICO.ICO_LIC_APERTURA AND APER.BORRADO = 0	
			LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO OBRA ON OBRA.DD_SIN_ID = ICO.ICO_LIC_OBRA AND OBRA.BORRADO = 0	
			LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO ASCE ON ASCE.DD_SIN_ID = ICO.ICO_ASCENSOR AND ASCE.BORRADO = 0		
			LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO PAT ON PAT.DD_SIN_ID = ICO.ICO_PATIO AND PAT.BORRADO = 0	
			LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO TER ON TER.DD_SIN_ID = ICO.ICO_TERRAZA AND TER.BORRADO = 0
			LEFT JOIN '||V_ESQUEMA||'.VI_ESTADO_ACTUAL_INFMED ESI ON ESI.ICO_ID = ICO.ICO_ID	
			LEFT JOIN ACCION ACC ON ACC.ICO_ID = ICO.ICO_ID
			LEFT JOIN GPUBL GPB ON GPB.ACT_ID = ACT.ACT_ID AND GPB.RN = 1
			
            LEFT JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND AGA.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION ECV ON ECV.DD_ECV_ID = ICO.DD_ECV_ID
            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO GAR ON GAR.DD_SIN_ID = ICO.ICO_ANEJO_GARAJE AND GAR.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO TRAS ON TRAS.DD_SIN_ID = ICO.ICO_ANEJO_TRASTERO AND TRAS.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO COCI ON COCI.DD_SIN_ID = ICO.ICO_COCINA_AMUEBLADA AND COCI.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_RAC_RATING_COCINA RAC ON RAC.DD_RAC_ID = ICO.DD_RAC_ID AND RAC.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_TCA_TIPO_CALEFACCION TCA ON TCA.DD_TCA_ID = ICO.DD_TCA_ID AND TCA.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_TCL_TIPO_CLIMATIZACION TCL ON TCL.DD_TCL_ID = ICO.DD_TCL_ID AND TCL.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_TCL_TIPO_CLIMATIZACION TCL2 ON TCL2.DD_TCL_ID = ICO.ICO_CALEFACCION AND TCL2.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO ARM ON ARM.DD_SIN_ID = ICO.ICO_ARM_EMPOTRADOS AND ARM.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_EXI_EXTERIOR_INTERIOR EXI ON EXI.DD_EXI_ID = ICO.DD_EXI_ID AND EXI.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO ZVER ON ZVER.DD_SIN_ID = ICO.ICO_ZONAS_VERDES AND ZVER.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO CONJ ON CONJ.DD_SIN_ID = ICO.ICO_CONSERJE AND CONJ.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO INST ON INST.DD_SIN_ID = ICO.ICO_INST_DEPORTIVAS AND INST.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO MINUSVA ON MINUSVA.DD_SIN_ID = ICO.ICO_ACC_MINUSVALIDO AND MINUSVA.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_ORIENTACION TPO ON TPO.DD_TPO_ID = ICO.ICO_ORIENTACION AND TPO.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_TPU_TIPO_PUERTA TPU ON TPU.DD_TPU_ID = ICO.DD_TPU_ID AND TPU.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_DIS_DISPONIBILIDAD JAR ON JAR.DD_DIS_ID = ICO.ICO_JARDIN AND JAR.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_DIS_DISPONIBILIDAD PIS ON PIS.DD_DIS_ID = ICO.ICO_PISCINA AND PIS.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_DIS_DISPONIBILIDAD GYM ON GYM.DD_DIS_ID = ICO.ICO_GIMNASIO AND GYM.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_ESC_ESTADO_CONSERVACION_EDIFICIO ESTC ON ESTC.DD_ESC_ID = ICO.DD_ESC_ID AND ESTC.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO MASC ON MASC.DD_SIN_ID = ICO.ICO_ADMITE_MASCOTAS AND MASC.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_VUB_VALORACION_UBICACION VUB ON VUB.DD_VUB_ID = ICO.DD_VUB_ID AND VUB.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO HUMOS ON HUMOS.DD_SIN_ID = ICO.ICO_SALIDA_HUMOS AND HUMOS.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO BRUTO ON BRUTO.DD_SIN_ID = ICO.ICO_USO_BRUTO AND BRUTO.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_CLA_CLASIFICACION CLA ON CLA.DD_CLA_ID = ICO.DD_CLA_ID AND CLA.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_USA_USO_ACTIVO USA ON USA.DD_USA_ID = ICO.DD_USA_ID AND USA.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO ALM ON ALM.DD_SIN_ID = ICO.ICO_ALMACEN AND ALM.BORRADO = 0

            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO VENTAEXPO ON VENTAEXPO.DD_SIN_ID = ICO.ICO_VENTA_EXPO AND VENTAEXPO.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO ENTREP ON ENTREP.DD_SIN_ID = ICO.ICO_ENTREPLANTA AND ENTREP.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO OCU ON OCU.DD_SIN_ID = ICO.ICO_OCUPADO AND OCU.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO VISI ON VISI.DD_SIN_ID = ICO.ICO_VISITABLE AND VISI.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_UAC_UBICACION_ACTIVO UAC ON UAC.DD_UAC_ID = ICO.DD_UAC_ID AND UAC.BORRADO = 0

            LEFT JOIN '||V_ESQUEMA||'.DD_ESM_ESTADO_MOBILIARIO ESM ON ESM.DD_ESM_ID = ICO.ICO_PUERTAS_INT AND ESM.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_ESM_ESTADO_MOBILIARIO ESM2 ON ESM2.DD_ESM_ID = ICO.ICO_VENTANAS AND ESM2.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_ESM_ESTADO_MOBILIARIO ESM3 ON ESM3.DD_ESM_ID = ICO.ICO_PERSIANAS AND ESM3.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_ESM_ESTADO_MOBILIARIO ESM4 ON ESM4.DD_ESM_ID = ICO.ICO_PINTURA AND ESM4.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_ESM_ESTADO_MOBILIARIO ESM5 ON ESM5.DD_ESM_ID = ICO.ICO_SOLADOS AND ESM5.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_ESM_ESTADO_MOBILIARIO ESM6 ON ESM6.DD_ESM_ID = ICO.ICO_BANYOS AND ESM6.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_AAC_ACTIVO_ACCESIBILIDAD AAC ON AAC.DD_AAC_ID = ICO.DD_AAC_ID AND AAC.BORRADO = 0	
			LEFT JOIN ACCION ACC ON ACC.ICO_ID = ICO.ICO_ID
			LEFT JOIN GPUBL GPB ON GPB.ACT_ID = ACT.ACT_ID
			LEFT JOIN FECHA_RECEP_INFO FRI ON FRI.ACT_ID = ACT.ACT_ID AND FRI.RN = 1';
   	 	
 		DBMS_OUTPUT.PUT_LINE('[INFO] Vista materializada : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... creada');

 		
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_VISTA||'(ID_INFORME_COMERCIAL) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX... Indice creado.');
		
		-- Creamos tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] Crear nueva tabla : '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA ||' a partir de la vista materializada ');
		EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AS  (SELECT 
																					* FROM '||V_ESQUEMA||'.'||V_TEXT_VISTA||')';	
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');	

		-- Creamos indice	
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(ID_INFORME_COMERCIAL) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX... Indice creado.');	
	
		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (ID_INFORME_COMERCIAL) USING INDEX)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');	
	
		-- Creamos comentario	
		V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');	
	
	
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');
	COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(err_msg);

          ROLLBACK;
          RAISE;          

END;
/

EXIT;

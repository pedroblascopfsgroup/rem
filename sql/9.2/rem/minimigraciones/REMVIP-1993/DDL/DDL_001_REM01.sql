--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180926
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-1993
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla 'AUX_MMC_988_ACTIVOS_COOPER'
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

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA_1 VARCHAR2(20 CHAR) := 'REM01';
V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REMMASTER'; --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';
V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := 'REM_IDX';
V_TABLA VARCHAR2(40 CHAR) := 'AUX_MMC_988_ACTIVOS_COOPER';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
		CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
		(
			empresa	VARCHAR2(256 CHAR),
			icc_nombre	VARCHAR2(256 CHAR),
			idcarteracliente	VARCHAR2(256 CHAR),
			num_referencia	VARCHAR2(256 CHAR),
			Bolsa	VARCHAR2(256 CHAR),
			Enriquec VARCHAR2(256 CHAR),
			septiembre	VARCHAR2(256 CHAR),
			ref_cliente_ak	VARCHAR2(256 CHAR),
			ref_historica	VARCHAR2(256 CHAR),
			inmu_dormitorios	VARCHAR2(256 CHAR),
			xtr_tiporesidencia	VARCHAR2(256 CHAR),
			xtr_extint	VARCHAR2(256 CHAR),
			inmu_orientacion	VARCHAR2(256 CHAR),
			idi_vistas	VARCHAR2(256 CHAR),
			inmu_garaje	VARCHAR2(256 CHAR),
			xtr_porterofisico	VARCHAR2(256 CHAR),
			xtr_tieneterraza	VARCHAR2(256 CHAR),
			xtr_numplantas	VARCHAR2(256 CHAR),
			xtr_categoriaedif	VARCHAR2(256 CHAR),
			inmu_anioconst	VARCHAR2(256 CHAR),
			xtr_distplaya	VARCHAR2(256 CHAR),
			inmu_estado	VARCHAR2(256 CHAR),
			xtr_estadoconsext	VARCHAR2(256 CHAR),
			iv_valoracionglobal	VARCHAR2(256 CHAR),
			xtr_puertaprin	VARCHAR2(256 CHAR),
			xtr_puertasint	VARCHAR2(256 CHAR),
			inmu_tipococina	VARCHAR2(256 CHAR),
			idi_estadococina	VARCHAR2(256 CHAR),
			inmu_tipocalef	VARCHAR2(256 CHAR),
			inmu_airea	VARCHAR2(256 CHAR),
			xtr_paredes	VARCHAR2(256 CHAR),
			inmu_suelos	VARCHAR2(256 CHAR),
			inmu_suelosbanios	VARCHAR2(256 CHAR),
			inmu_ventanas	VARCHAR2(256 CHAR),
			inmu_persianas	VARCHAR2(256 CHAR),
			inmu_empotrados	VARCHAR2(256 CHAR),
			inmu_bodega	VARCHAR2(256 CHAR),
			inmu_barbacoa	VARCHAR2(256 CHAR),
			xtr_lavadora	VARCHAR2(256 CHAR),
			xtr_frigorifico	VARCHAR2(256 CHAR),
			xtr_lavavajillas	VARCHAR2(256 CHAR),
			xtr_horno	VARCHAR2(256 CHAR),
			xtr_microondas	VARCHAR2(256 CHAR),
			inmu_banios	VARCHAR2(256 CHAR),
			inmu_aseos	VARCHAR2(256 CHAR),
			xtr_sanirefor	VARCHAR2(256 CHAR),
			xtr_banieras	VARCHAR2(256 CHAR),
			xtr_duchas	VARCHAR2(256 CHAR),
			inmu_banierahidro	VARCHAR2(256 CHAR),
			inmu_duchahidro	VARCHAR2(256 CHAR),
			idi_dormprinm2	VARCHAR2(256 CHAR),
			idi_dorm2m2	VARCHAR2(256 CHAR),
			idi_dorm3m2	VARCHAR2(256 CHAR),
			idi_dorm4m2	VARCHAR2(256 CHAR),
			idi_dorm5m2	VARCHAR2(256 CHAR),
			xtr_saloncomedor	VARCHAR2(256 CHAR),
			xtr_cuartoestar	VARCHAR2(256 CHAR),
			inmu_terraza	VARCHAR2(256 CHAR),
			idi_terraza2m2	VARCHAR2(256 CHAR),
			idi_trasterom2	VARCHAR2(256 CHAR),
			inmu_ascensor	VARCHAR2(256 CHAR),
			xtr_piscina	VARCHAR2(256 CHAR),
			inmu_zdeportivas	VARCHAR2(256 CHAR),
			inmu_zdeportivasobs	VARCHAR2(256 CHAR),
			xtr_parque	VARCHAR2(256 CHAR),
			xtr_zonasverdes	VARCHAR2(256 CHAR),
			xtr_farmacia	VARCHAR2(256 CHAR),
			xtr_hospitalclinica	VARCHAR2(256 CHAR),
			xtr_acccarretera	VARCHAR2(256 CHAR),
			xtr_autobus	VARCHAR2(256 CHAR),
			xtr_metro	VARCHAR2(256 CHAR),
			xtr_aeropuerto	VARCHAR2(256 CHAR),
			xtr_renfe	VARCHAR2(256 CHAR),
			xtr_centrocomercial	VARCHAR2(256 CHAR),
			xtr_supermercado	VARCHAR2(256 CHAR),
			xtr_nivelservicios	VARCHAR2(256 CHAR),
			xtr_colegio	VARCHAR2(256 CHAR),
			xtr_guarderia	VARCHAR2(256 CHAR),
			latitud	VARCHAR2(256 CHAR),
			longitud	VARCHAR2(256 CHAR),
			Cartera	VARCHAR2(256 CHAR),
			Ocupado	VARCHAR2(256 CHAR),
			tipo_inmueble	VARCHAR2(256 CHAR),
			subtipo_inmueble VARCHAR2(256 CHAR)
		)'
;

/*EXECUTE IMMEDIATE '
		CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
		(
			ref_cliente_ak	VARCHAR2(256 CHAR)
		)'
;*/
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;

IF V_ESQUEMA_3 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_3||''); 

END IF;

/*IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN
EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_4||''); 
END IF;*/

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


--/*
--##########################################
--## AUTOR=Josep Ros
--## FECHA_CREACION=20200930
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=HREOS-10463
--## PRODUCTO=SI
--##
--## INSTRUCCIONES: NO Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_SAREB_ACTIVOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
BEGIN	

DBMS_OUTPUT.PUT_LINE('[INICIO] INSERCIÓN DE LOS NUEVOS JUZGADOS');

V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	

IF V_NUM_TABLAS = 1 THEN
DBMS_OUTPUT.PUT_LINE('[INICIO] EXISTE LA TABLA, PROCEDEMOS A INSERTAR...');
	V_MSQL := 'INSERT INTO REM01.ACT_SAREB_ACTIVOS (
			ASA_ID,
			ACT_ID,
			REO_CONTABILIZADO,
			DD_TPA_ID_OE,
			DD_SAC_ID_OE,
			DD_TVI_ID_OE,
			ASA_NOMBRE_VIA,
			ASA_NUMERO_DOMICILIO,
			ASA_ESCALERA,
			ASA_PISO,
			ASA_PUERTA,
			DD_PRV_ID_OE,
			DD_LOC_ID_OE,
			ASA_COD_POST,
			ASA_LATITUD,
			ASA_LONGITUD,
			VERSION,
			USUARIOCREAR,
			FECHACREAR,
			USUARIOMODIFICAR,
			FECHAMODIFICAR,
			USUARIOBORRAR,
			FECHABORRAR,
			BORRADO
			)
			(
			SELECT 
			'||V_ESQUEMA||'.S_ACT_SAREB_ACTIVOS.NEXTVAL -- Identificador único 
			,ACT.ACT_ID -- FK a ACT_ACTIVO
			,NULL -- REO_CONTABILIZADO
			,ACT.DD_TPA_ID -- Tipo Activo OE
			,ACT.DD_SAC_ID --Subtipo Activo OE
			,LOC.DD_TVI_ID -- Tipo de vía OE
			,LOC.BIE_LOC_NOMBRE_VIA -- Nombre de vía OE
			,LOC.BIE_LOC_NUMERO_DOMICILIO -- Nº OE
			,LOC.BIE_LOC_ESCALERA -- Escalera OE
			,LOC.BIE_LOC_PISO -- Planta OE
			,LOC.BIE_LOC_PUERTA -- Puerta OE
			,LOC.DD_PRV_ID -- Provincia OE. No hace falta joinear ya esta la fk directamente aqui.
			,LOC.DD_LOC_ID -- Municipio OE. No hace falta joinear DD_LOC_LOCALIDAD
			,LOC.BIE_LOC_COD_POST -- Código Postal OE
			,ACTLOC.LOC_LATITUD -- Latitud OE
			,ACTLOC.LOC_LONGITUD -- Longitud OE
			,0 -- VERSION
			,''HREOS-10463'' --USUARIOCREAR
			,SYSDATE -- FECHACREAR
			,NULL -- USUARIOMODIFICAR
			,NULL -- FECHAMODIFICAR
			,NULL -- USUARIOBORRAR
			,NULL -- FECHABORRAR
			,0 -- BORRADO

			FROM
			'||V_ESQUEMA||'.ACT_ACTIVO ACT
			JOIN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION ACTLOC ON ACTLOC.ACT_ID = ACT.ACT_ID
			JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION LOC ON LOC.BIE_LOC_ID = ACTLOC.BIE_LOC_ID
			JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
			WHERE CRA.DD_CRA_CODIGO = ''02''
			)';

EXECUTE IMMEDIATE V_MSQL;
END IF;

DBMS_OUTPUT.PUT_LINE('[FIN] INSERCIÓN.');

COMMIT;

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
EXIT;

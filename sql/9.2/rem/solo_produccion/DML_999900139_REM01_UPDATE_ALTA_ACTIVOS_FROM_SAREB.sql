--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20170911
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2744
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza las tablas que afectan al alta de activos para añadir los nuevos campos
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	V_ACT_ID NUMBER(16);
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    CURSOR ACTUALIZACION_ALTA_ACT_SAREB
	IS
		SELECT ACT_ID FROM REM01.ACT_ACTIVO ACT
		WHERE ACT.FECHACREAR >= TO_DATE('12/08/2017', 'DD/MM/YYYY')
		AND ACT.USUARIOCREAR = 'ALT_SAREB' 
		AND ACT.BORRADO = 0;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Se inicia el proceso de actualización de los activos dados de alta por el proceso ''apr_main_actives_from_sareb''.');
	
	OPEN ACTUALIZACION_ALTA_ACT_SAREB;
	FETCH ACTUALIZACION_ALTA_ACT_SAREB into V_ACT_ID;
	WHILE (ACTUALIZACION_ALTA_ACT_SAREB%FOUND) LOOP
	
	DBMS_OUTPUT.PUT_LINE('[INFO] *********************************************************************************');
	DBMS_OUTPUT.PUT_LINE('[INFO] ID del activo a actualizar: '||V_ACT_ID||'.');
	
		--*********************************************************************ACT_ACTIVO**********************************************************************
	DBMS_OUTPUT.PUT_LINE('[INFO] **ACT_ACTIVO**');
	
	--Comprobamos si existe el activo en tabla destino
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_ID = '||V_ACT_ID||' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	--Si existe lo actualizamos
	IF V_NUM_TABLAS > 0 THEN
	
		V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT
				   USING (
				     SELECT 
				     CASE
					   WHEN EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL ADN WHERE ACT1.ACT_ID=ADN.ACT_ID)
						 THEN (SELECT DD_STA.DD_STA_ID FROM '||V_ESQUEMA||'.DD_STA_SUBTIPO_TITULO_ACTIVO DD_STA WHERE DD_STA.DD_STA_CODIGO = ''04'' AND DD_STA.BORRADO = 0)
					   ELSE (SELECT DD_STA.DD_STA_ID FROM '||V_ESQUEMA||'.DD_STA_SUBTIPO_TITULO_ACTIVO DD_STA WHERE DD_STA.DD_STA_CODIGO = ''01'' AND DD_STA.BORRADO = 0)
				     END AS DD_STA_ID,
				     (SELECT DD_SCR.DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA DD_SCR WHERE DD_SCR.DD_SCR_CODIGO = ''04'' AND DD_SCR.BORRADO = 0) AS DD_SCR_ID,
				     (SELECT BIE_REFERENCIA_MUEBLE FROM HAYA01.BIE_BIEN BIE WHERE BIE.BIE_ID = ACT1.ACT_RECOVERY_ID) AS ACT_NUM_ACTIVO_SAREB,
				     TCO.DD_TCO_ID
				     FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT1
				     INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON ACT1.ACT_ID = SPS.ACT_ID
					 INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON DECODE((SPS.SPS_OCUPADO)+(SPS.SPS_CON_TITULO), NULL, ''01'', 0, ''01'', 1, ''01'', 2, ''02'') = TCO.DD_TCO_CODIGO
				     WHERE ACT1.ACT_ID = '||V_ACT_ID||'
				   ) AUX
				   ON (ACT.ACT_ID = '||V_ACT_ID||')
				   WHEN MATCHED THEN UPDATE SET
				   ACT.DD_STA_ID = AUX.DD_STA_ID,
				   ACT.DD_SCR_ID = AUX.DD_SCR_ID,
				   ACT.DD_TCO_ID = AUX.DD_TCO_ID,
				   ACT.ACT_NUM_ACTIVO_SAREB = AUX.ACT_NUM_ACTIVO_SAREB,
				   ACT.USUARIOMODIFICAR = ''HREOS-2744'',
				   ACT.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE	');
	
	ELSE		
		DBMS_OUTPUT.PUT_LINE('[INFO]: No existe el registro '''||V_ACT_ID||''' en la tabla '||V_ESQUEMA||'.ACT_ACTIVO - No se puede actualizar');		
	END IF;
	
	--*********************************************************************ACT_CRG_CARGAS**********************************************************************
	DBMS_OUTPUT.PUT_LINE('[INFO] **ACT_CRG_CARGAS**');
	
	--Comprobamos si existe el activo en tabla destino
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_CRG_CARGAS WHERE ACT_ID = '||V_ACT_ID||' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	--Si existe lo actualizamos
	IF V_NUM_TABLAS > 0 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_CRG_CARGAS
				   SET
				   DD_ODT_ID = (SELECT DD_ODT_ID FROM '||V_ESQUEMA||'.DD_ODT_ORIGEN_DATO WHERE DD_ODT_CODIGO = ''02''),
				   USUARIOMODIFICAR = ''HREOS-2744'',
				   FECHAMODIFICAR = SYSDATE
				   WHERE
				   ACT_ID = '||V_ACT_ID||'';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE	');
	
	ELSE		
		DBMS_OUTPUT.PUT_LINE('[INFO]: No existe el registro '''||V_ACT_ID||''' en la tabla '||V_ESQUEMA||'.ACT_CRG_CARGAS - No se puede actualizar');		
	END IF;
	
	--******************************************************************ACT_PAC_PERIMETRO_ACTIVO*******************************************************************
	DBMS_OUTPUT.PUT_LINE('[INFO] **ACT_PAC_PERIMETRO_ACTIVO**');
	
	--Comprobamos si existe el activo en tabla destino
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO WHERE ACT_ID = '||V_ACT_ID||' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	--Si no existe lo metemos
	IF V_NUM_TABLAS = 0 THEN
	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO (PAC_ID, ACT_ID, PAC_INCLUIDO, PAC_CHECK_GESTIONAR, PAC_FECHA_GESTIONAR, PAC_CHECK_COMERCIALIZAR, PAC_FECHA_COMERCIALIZAR, PAC_CHECK_FORMALIZAR, PAC_FECHA_FORMALIZAR, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
		(SELECT 
		'||V_ESQUEMA||'.S_ACT_PAC_PERIMETRO_ACTIVO.NEXTVAL,	
		'||V_ACT_ID||',	
		1, 
		1, 
		(SELECT FECHACREAR FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_ID = '||V_ACT_ID||'), 
		1, 
		(SELECT FECHACREAR FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_ID = '||V_ACT_ID||'), 
		1, 
		(SELECT FECHACREAR FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_ID = '||V_ACT_ID||'),
		0,  
		''HREOS-2744'', 
		SYSDATE,
		0
		FROM DUAL)';
		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE	');
	
	ELSE		
		DBMS_OUTPUT.PUT_LINE('[INFO]: Ya existe el registro '''||V_ACT_ID||''' en la tabla '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO - No se vuelve a insertar');		
	END IF;
	
	--******************************************************************ACT_ABA_ACTIVO_BANCARIO*******************************************************************
	DBMS_OUTPUT.PUT_LINE('[INFO] **ACT_ABA_ACTIVO_BANCARIO**');
	
	--Comprobamos si existe el activo en tabla destino
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO WHERE ACT_ID = '||V_ACT_ID||' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	--Si no existe lo metemos
	IF V_NUM_TABLAS = 0 THEN
	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO (ABA_ID, ACT_ID, DD_CLA_ID, DD_SCA_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
		(SELECT
		'||V_ESQUEMA||'.S_ACT_ABA_ACTIVO_BANCARIO.NEXTVAL,
		'||V_ACT_ID||',
		(SELECT CLA.DD_CLA_ID FROM '||V_ESQUEMA||'.DD_CLA_CLASE_ACTIVO CLA WHERE CLA.DD_CLA_CODIGO = ''02'' AND CLA.BORRADO = 0),
		(SELECT SCA.DD_SCA_ID FROM '||V_ESQUEMA||'.DD_SCA_SUBCLASE_ACTIVO SCA WHERE SCA.DD_SCA_CODIGO = ''02'' AND SCA.BORRADO = 0),
		0,
		''HREOS-2744'', 
		SYSDATE,
		0
		FROM DUAL)';
		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE	');
	
	ELSE		
		DBMS_OUTPUT.PUT_LINE('[INFO]: Ya existe el registro '''||V_ACT_ID||''' en la tabla '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO - No se vuelve a insertar');		
	END IF;
	
	--******************************************************************ACT_ICO_INFO_COMERCIAL*******************************************************************
	DBMS_OUTPUT.PUT_LINE('[INFO] **ACT_ICO_INFO_COMERCIAL**');
	
	--Comprobamos si existe el activo en tabla destino
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL WHERE ACT_ID = '||V_ACT_ID||' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	--Si no existe lo metemos
	IF V_NUM_TABLAS = 0 THEN
	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL (ICO_ID, ACT_ID, DD_TIC_ID, DD_TPA_ID, DD_SAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
		(SELECT
		'||V_ESQUEMA||'.S_ACT_ICO_INFO_COMERCIAL.NEXTVAL,
		'||V_ACT_ID||',
		CASE 
		  WHEN (SAC.DD_SAC_CODIGO IN (''05'',''06'',''07'',''08'',''09'',''10'',''11'',''12'',''20''))
			THEN (SELECT TIC.DD_TIC_ID FROM '||V_ESQUEMA||'.DD_TIC_TIPO_INFO_COMERCIAL TIC WHERE TIC.DD_TIC_CODIGO = ''01'')
		  WHEN (SAC.DD_SAC_CODIGO IN  (''13'',''14'',''15'',''16''))
			THEN (SELECT TIC.DD_TIC_ID FROM '||V_ESQUEMA||'.DD_TIC_TIPO_INFO_COMERCIAL TIC WHERE TIC.DD_TIC_CODIGO = ''02'')
		  WHEN (SAC.DD_SAC_CODIGO IN  (''19'',''24'',''26''))
			THEN (SELECT TIC.DD_TIC_ID FROM '||V_ESQUEMA||'.DD_TIC_TIPO_INFO_COMERCIAL TIC WHERE TIC.DD_TIC_CODIGO = ''03'')
		  ELSE NULL
		END DD_TIC_ID,
		ACT.DD_TPA_ID,
		ACT.DD_SAC_ID,
		0,
		''HREOS-2744'',
		SYSDATE,
		0
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC  ON SAC.DD_SAC_ID = ACT.DD_SAC_ID
		WHERE ACT.ACT_ID = '||V_ACT_ID||')';
		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE	');
	
	ELSE		
		DBMS_OUTPUT.PUT_LINE('[INFO]: Ya existe el registro '''||V_ACT_ID||''' en la tabla '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL - No se vuelve a insertar');		
	END IF;
	
	--******************************************************************ACT_EDI_EDIFICIO*******************************************************************
	DBMS_OUTPUT.PUT_LINE('[INFO] **ACT_EDI_EDIFICIO**');
	
	--Comprobamos si existe el activo en tabla destino
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_EDI_EDIFICIO EDI 
			  INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ICO_ID = EDI.ICO_ID 
			  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID
			  WHERE ACT.ACT_ID = '||V_ACT_ID||' AND ACT.BORRADO = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	--Si no existe lo metemos
	IF V_NUM_TABLAS = 0 THEN
	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_EDI_EDIFICIO (EDI_ID, ICO_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
		(SELECT
		'||V_ESQUEMA||'.S_ACT_EDI_EDIFICIO.NEXTVAL,
		ICO.ICO_ID,
		0,
		''HREOS-2744'',
		SYSDATE,
		0
		FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
		WHERE ICO.ACT_ID = '||V_ACT_ID||')';
		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE	');
	
	ELSE		
		DBMS_OUTPUT.PUT_LINE('[INFO]: Ya existe el registro '''||V_ACT_ID||''' en la tabla '||V_ESQUEMA||'.ACT_EDI_EDIFICIO - No se vuelve a insertar');		
	END IF;
	
	--******************************************************************ACT_VIV_VIVIENDA*******************************************************************
	DBMS_OUTPUT.PUT_LINE('[INFO] **ACT_VIV_VIVIENDA**');
	
	--Comprobamos si el tipo/subtipo de activo entra en el bloque de vivienda
	V_SQL := 'SELECT COUNT(1)
			  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
			  LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC  ON SAC.DD_SAC_ID = ACT.DD_SAC_ID
			  INNER JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID
			  WHERE NVL(SAC.DD_SAC_CODIGO, DECODE(TPA.DD_TPA_CODIGO, ''02'', ''05'')) IN  (''05'',''06'',''07'',''08'',''09'',''10'',''11'',''12'',''20'') 
			  AND ACT.ACT_ID = '||V_ACT_ID||' AND ACT.BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
	
		--Comprobamos si existe el activo en tabla destino
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_VIV_VIVIENDA VIV 
				  INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ICO_ID = VIV.ICO_ID 
				  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID
				  WHERE ACT.ACT_ID = '||V_ACT_ID||' AND ACT.BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		--Si no existe lo metemos
		IF V_NUM_TABLAS = 0 THEN
		
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_VIV_VIVIENDA (ICO_ID)
			(SELECT
			ICO.ICO_ID
			FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
			INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID
			LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC  ON SAC.DD_SAC_ID = ACT.DD_SAC_ID
			INNER JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID
			WHERE NVL(SAC.DD_SAC_CODIGO, DECODE(TPA.DD_TPA_CODIGO, ''02'', ''05'')) IN  (''05'',''06'',''07'',''08'',''09'',''10'',''11'',''12'',''20'') 
			AND ACT.ACT_ID = '||V_ACT_ID||')';
			
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE	');
		
		ELSE		
			DBMS_OUTPUT.PUT_LINE('[INFO]: Ya existe el registro '''||V_ACT_ID||''' en la tabla '||V_ESQUEMA||'.ACT_VIV_VIVIENDA - No se vuelve a insertar');		
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO]: El registro '''||V_ACT_ID||''' no pertenece a un subtipo de vivienda - No se inserta');
	END IF;	
	
	--******************************************************************ACT_LCO_LOCAL_COMERCIAL*******************************************************************
	DBMS_OUTPUT.PUT_LINE('[INFO] **ACT_LCO_LOCAL_COMERCIAL**');
	
	--Comprobamos si el subtipo de activo entra en el bloque de local comercial
	V_SQL := 'SELECT COUNT(1)
			  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
			  INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC  ON SAC.DD_SAC_ID = ACT.DD_SAC_ID
			  WHERE SAC.DD_SAC_CODIGO IN  (''13'',''14'',''15'',''16'')
			  AND ACT.ACT_ID = '||V_ACT_ID||' AND ACT.BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
	
		--Comprobamos si existe el activo en tabla destino
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL LCO 
				  INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ICO_ID = LCO.ICO_ID 
				  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID
				  WHERE ACT.ACT_ID = '||V_ACT_ID||' AND ACT.BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		--Si no existe lo metemos
		IF V_NUM_TABLAS = 0 THEN
		
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL (ICO_ID)
			(SELECT
			ICO.ICO_ID
			FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
			INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID
			INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC  ON SAC.DD_SAC_ID = ACT.DD_SAC_ID
			WHERE SAC.DD_SAC_CODIGO IN  (''13'',''14'',''15'',''16'')
			AND ACT.ACT_ID = '||V_ACT_ID||')';
			
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE	');
		
		ELSE		
			DBMS_OUTPUT.PUT_LINE('[INFO]: Ya existe el registro '''||V_ACT_ID||''' en la tabla '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL - No se vuelve a insertar');		
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO]: El registro '''||V_ACT_ID||''' no pertenece a un subtipo de local comercial - No se inserta');
	END IF;	
	
	--******************************************************************ACT_APR_PLAZA_APARCAMIENTO*******************************************************************
	DBMS_OUTPUT.PUT_LINE('[INFO] **ACT_APR_PLAZA_APARCAMIENTO**');
	
	--Comprobamos si el subtipo de activo entra en el bloque de plaza de aparcamiento
	V_SQL := 'SELECT COUNT(1)
			  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
			  INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC  ON SAC.DD_SAC_ID = ACT.DD_SAC_ID
			  WHERE SAC.DD_SAC_CODIGO IN  (''19'',''24'',''26'')
			  AND ACT.ACT_ID = '||V_ACT_ID||' AND ACT.BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
	
		--Comprobamos si existe el activo en tabla destino
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_APR_PLAZA_APARCAMIENTO APR 
				  INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ICO_ID = APR.ICO_ID 
				  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID
				  WHERE ACT.ACT_ID = '||V_ACT_ID||' AND ACT.BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		--Si no existe lo metemos
		IF V_NUM_TABLAS = 0 THEN
		
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_APR_PLAZA_APARCAMIENTO (ICO_ID)
			(SELECT
			ICO.ICO_ID
			FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
			INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID
			INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC  ON SAC.DD_SAC_ID = ACT.DD_SAC_ID
			WHERE SAC.DD_SAC_CODIGO IN  (''19'',''24'',''26'')
			AND ACT.ACT_ID = '||V_ACT_ID||')';
			
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE	');
		
		ELSE		
			DBMS_OUTPUT.PUT_LINE('[INFO]: Ya existe el registro '''||V_ACT_ID||''' en la tabla '||V_ESQUEMA||'.ACT_APR_PLAZA_APARCAMIENTO - No se vuelve a insertar');		
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO]: El registro '''||V_ACT_ID||''' no pertenece a un subtipo de plaza de aparcamiento - No se inserta');
	END IF;	
	
	FETCH ACTUALIZACION_ALTA_ACT_SAREB into V_ACT_ID;
	
	END LOOP;	
	
	CLOSE ACTUALIZACION_ALTA_ACT_SAREB;
	

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]:  El proceso de actualización de los activos dados de alta por el proceso ''apr_main_actives_from_sareb'' a finalizado correctamente.');
   

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



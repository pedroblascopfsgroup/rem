--/*
--##########################################
--## AUTOR=Lara Pablo Flores
--## FECHA_CREACION=20210709
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14394
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 HREOS-4933  ADC.ADC_NAME Nombre de la descarga del documento GDPR en la tabla ADC_ADJUNTO_COMPRADOR ADC
--##        0.3 HREOS-5217  CEX.CEX_ID_PERSONA_HAYA,CEX.ADCOM_ID  para el documento GDPR en la tabla ADC_ADJUNTO_COMPRADOR ADC
--##		0.4 HREOS-5927  COM.PROBLEMAS_URSUS añadida
--##		0.5 HREOS-12747 OFR_TIA_TITULARES_ADICIONALES añadir campo FECHA_ACEP_GDPR
--##		0.6 HREOS-13795 Cambiado a left los titulares adicionales.
--##		0.7 HREOS-13840 Cambiado a left los titulares adicionales añadiendo un borrado lógico a 0.
--##        0.8 HREOS-13407 Se añaden 2 campos Estado Contraste y fecha contraste.
--##		0.9 HREOS-14394  Añadir estados bc
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
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

--  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_COMPRADORES_EXP' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  V_MSQL := 'SELECT COUNT(*) FROM ALL_OBJECTS WHERE OBJECT_NAME = ''V_BUSQUEDA_COMPRADORES_EXP'' AND OWNER='''||V_ESQUEMA||''' AND OBJECT_TYPE=''MATERIALIZED VIEW''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_COMPRADORES_EXP...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_COMPRADORES_EXP';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_COMPRADORES_EXP... borrada OK');
  else
     DBMS_OUTPUT.PUT_LINE('No existe como vista materializada');
  END IF;

  V_MSQL := 'SELECT COUNT(*) FROM ALL_OBJECTS WHERE OBJECT_NAME = ''V_BUSQUEDA_COMPRADORES_EXP'' AND OWNER='''||V_ESQUEMA||''' AND OBJECT_TYPE=''VIEW''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
  EXECUTE IMMEDIATE V_MSQL into cuenta;
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_COMPRADORES_EXP...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_COMPRADORES_EXP';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_COMPRADORES_EXP... borrada OK');
  else
     DBMS_OUTPUT.PUT_LINE('No existe como vista');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_COMPRADORES_EXP...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_COMPRADORES_EXP 
	AS
		SELECT
	  		COM.COM_ID,
			CEX.ECO_ID,
			COM.COM_NOMBRE || '' '' || COM.COM_APELLIDOS AS NOMBRE_COMPRADOR,
			COM.COM_DOCUMENTO AS DOC_COMPRADOR,
			CEX.CEX_NOMBRE_RTE || '' '' ||  CEX.CEX_APELLIDOS_RTE AS NOMBRE_REPRESENTANTE,
			CEX.CEX_DOCUMENTO_RTE AS DOC_REPRESENTANTE,
			CEX.CEX_PORCION_COMPRA AS PORCENTAJE_COMPRA,
			COM.COM_TELEFONO1 AS TELEFONO,
			COM.COM_EMAIL,
			CEX.CEX_RELACION_HRE,
			EPB.DD_EPB_CODIGO AS COD_ESTADO_PBC,
			EPB.DD_EPB_DESCRIPCION AS DESC_ESTADO_PBC,
			CEX.CEX_TITULAR_CONTRATACION,
			CEX.CEX_NUM_FACTURA,
			CEX.CEX_FECHA_FACTURA,
			CEX.BORRADO,
			CEX.CEX_FECHA_BAJA,
			TGP.DD_TGP_CODIGO AS COD_GRADO_PROPIEDAD,
			TGP.DD_TGP_DESCRIPCION AS DESC_GRADO_PROPIEDAD,
			ADC.ADC_NAME,
			CEX.CEX_ID_PERSONA_HAYA,
			CEX.ADCOM_ID,
			ADC.ADC_ID_DOCUMENTO_REST,
			CASE COM.PROBLEMAS_URSUS WHEN 1 THEN ''Si''  WHEN 0 THEN ''No'' ELSE NULL END AS PROBLEMAS_URSUS,
			COM.DD_ECV_ID_URSUS,
			COM.DD_REM_ID_URSUS,
			COM.N_URSUS_CONYUGE,
			COM.NOMBRE_CONYUGE_URSUS,
			CEX.CEX_CLI_URSUS_CONYUGE_REM,
			CEX.CEX_NUM_URSUS_CONYUGE_REM,
			CEX.CEX_NUM_URSUS_CONYUGE_BH_REM,
	      	CASE WHEN (TIA.FECHA_ACEP_GDPR IS NOT NULL) 
				  THEN CAST(TO_CHAR(TIA.FECHA_ACEP_GDPR ,
					''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
	        ELSE NULL
	      	END AS FECHA_ACEP_GDPR,
	      	ECL.DD_ECL_CODIGO AS COD_ESTADO_ECL,
	      	ECL.DD_ECL_DESCRIPCION AS DESC_ESTADO_ECL,
	      	CASE WHEN (CEX.ECO_ECL_FECHA IS NOT NULL) 
				THEN CAST(TO_CHAR(CEX.ECO_ECL_FECHA ,
					''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
			ELSE NULL
			END 																				AS ECO_ECL_FECHA,
			CASE WHEN ECC.DD_ECC_CODIGO IN (''03'',''04'') THEN ECC.DD_ECC_CODIGO ELSE EIC.DD_EIC_CODIGO END AS ESTADO_CODIGO,
  			CASE WHEN ECC.DD_ECC_CODIGO IN (''03'', ''04'') THEN ECC.DD_ECC_DESCRIPCION ELSE EIC.DD_EIC_DESCRIPCION END AS ESTADO_DESCRIPCION
		
		FROM '|| V_ESQUEMA ||'.COM_COMPRADOR COM
      	LEFT JOIN '|| V_ESQUEMA ||'.CEX_COMPRADOR_EXPEDIENTE CEX ON CEX.COM_ID = COM.COM_ID
		LEFT JOIN '|| V_ESQUEMA ||'.DD_EPB_ESTADOS_PBC EPB ON CEX.DD_EPB_ID = EPB.DD_EPB_ID
		LEFT JOIN '|| V_ESQUEMA ||'.ADC_ADJUNTO_COMPRADOR ADC ON ADC.ADCOM_ID  = CEX.ADCOM_ID
		LEFT JOIN '|| V_ESQUEMA ||'.DD_TGP_TIPO_GRADO_PROPIEDAD TGP ON CEX.DD_TGP_ID = TGP.DD_TGP_ID
	    JOIN '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO ON CEX.ECO_ID = ECO.ECO_ID
	    JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID
	    LEFT JOIN '|| V_ESQUEMA ||'.OFR_TIA_TITULARES_ADICIONALES TIA ON OFR.OFR_ID = TIA.OFR_ID AND TIA.BORRADO = 0
	    LEFT JOIN '|| V_ESQUEMA ||'.DD_ECL_ESTADO_CONT_LISTAS ECL ON CEX.DD_ECL_ID = ECL.DD_ECL_ID
		LEFT JOIN '|| V_ESQUEMA ||'.IAP_INFO_ADC_PERSONA IAP ON IAP.IAP_ID = COM.IAP_ID
		LEFT JOIN '|| V_ESQUEMA ||'.DD_ECC_ESTADO_COMUNICACION_C4C ECC ON IAP.DD_ECC_ID = ECC.DD_ECC_ID
		LEFT JOIN '|| V_ESQUEMA ||'.DD_EIC_ESTADO_INTERLOCUTOR EIC ON CEX.DD_EIC_ID = EIC.DD_EIC_ID';
		
		

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_COMPRADORES_EXP...Creada OK');
  
  EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;     
  
END;
/

EXIT;

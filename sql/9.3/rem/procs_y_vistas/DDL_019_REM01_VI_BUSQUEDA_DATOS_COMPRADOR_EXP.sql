--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20210622
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=14391
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial  
--##        0.2 Versión - HREOS-5136 - Elisa Occhipinti - 20190111 - Añadir columnas CLC_CESION_DATOS, CLC_COMUNI_TERCEROS, CLC_TRANSF_INTER, ADCOM_ID
--##        0.3 Versión - HREOS-5136 - Elisa Occhipinti - 20190111 - Añadir columnas CLC_CESION_DATOS, CLC_COMUNI_TERCEROS, CLC_TRANSF_INTER, ADCOM_ID
--##		0.4 Versión - HREOS-5927 - Lara Pablo -	20190422 - Añadir problemas Ursus
--##		0.5 Version - HREOS-6450 - José Antonio Gigante - Agregar distinct en la consulta de creacion de la vista
--##		0.6 Version - REMVIP-7170 - Adrián Molina - Añadir columna
--##		0.6.1 Versión - REMVIP-7528 - Guillem Rey - columna id no debe ser null
--##		0.7 Versión - HREOS-14126 	- Lara Pablo - Añadidas columnas CEX_C4C_ID y COM_FECHA_NACIOCONST
--##		0.8 Version - REMVIP-9917 - Adrián Molina - Añadir columna
--##		0.8 Versión - HREOS-14249 	- Lara Pablo - Añadidas columnas COM_FORMA_JURIDICA
--##		0.9 Versión - HREOS-14391 	- Javier Esbri - Añadidas columnas CEX_FECHA_NACIMIENTO_REPR, CEX_LOC_NAC_REPR, DD_PAI_NAC_REPR_ID, CEX_USUFRUCTUARIO, DD_LOC_NAC_ID, COM_PRP, COM_FECHA_NACIMIENTO
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias
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

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_DATOS_COMPRADOR_EXP' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_DATOS_COMPRADOR_EXP...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_DATOS_COMPRADOR_EXP';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_DATOS_COMPRADOR_EXP... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_DATOS_COMPRADOR_EXP' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_DATOS_COMPRADOR_EXP...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_DATOS_COMPRADOR_EXP';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_DATOS_COMPRADOR_EXP... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_DATOS_COMPRADOR_EXP...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_DATOS_COMPRADOR_EXP 
	AS
		SELECT
			DISTINCT
			CAST(NVL2(CEX.ECO_ID,TO_CHAR(COM.COM_ID||CEX.ECO_ID),COM.COM_ID) AS NUMBER(32,0)) AS VCEX_ID,
			COM.COM_ID,
			CEX.ECO_ID,
			TPE.DD_TPE_CODIGO AS COD_TIPO_PERSONA,
			TPE.DD_TPE_DESCRIPCION AS DESC_TIPO_PERSONA,
			CEX.CEX_TITULAR_RESERVA AS TITULAR_RESERVA,
			CEX.CEX_PORCION_COMPRA AS PORCENTAJE_COMPRA,
			CEX.CEX_TITULAR_CONTRATACION AS TITULAR_CONTRATACION,
			TDI.DD_TDI_CODIGO AS COD_TIPO_DOCUMENTO,
			TDI.DD_TDI_DESCRIPCION AS DESC_TIPO_DOCUMENTO,
			COM.COM_DOCUMENTO,
			COM.COM_NOMBRE AS NOMBRE_COMPRADOR,
			COM.COM_DIRECCION,
			LOC.DD_LOC_CODIGO,
			LOC.DD_LOC_DESCRIPCION,
			COM.COM_TELEFONO1,
			PRV.DD_PRV_CODIGO,
			PRV.DD_PRV_DESCRIPCION,
			COM.COM_TELEFONO2,
			COM.COM_CODIGO_POSTAL,
			COM.COM_EMAIL,
			ECV.DD_ECV_CODIGO AS COD_ESTADO_CIVIL,
			ECV.DD_ECV_DESCRIPCION AS DESC_ESTADO_CIVIL,
			--REGIMEN ECONOMICO ¿HAY DICCIONARIO?
			CEX.CEX_DOCUMENTO_CONYUGE,
			CEX.CEX_RESPONSABLE_TRAMITACION,
			CEX.CEX_IMPTE_PROPORCIONAL_OFERTA,
			CEX.CEX_IMPTE_FINANCIADO,
			CEX.CEX_ANTIGUO_DEUDOR,
			CEX.CEX_RELACION_ANT_DEUDOR,
			TDI_RTE.DD_TDI_CODIGO AS COD_TIPO_DOCUMENTO_RTE,
			TDI_RTE.DD_TDI_DESCRIPCION AS DESC_TIPO_DOCUMENTO_RTE,
			CEX.CEX_DOCUMENTO_RTE,
			CEX.CEX_NOMBRE_RTE AS NOMBRE_REPRESENTANTE,
			CEX.CEX_DIRECCION_RTE,
			LOCRTE.DD_LOC_CODIGO AS DD_LOC_CODIGO_RTE,
			LOCRTE.DD_LOC_DESCRIPCION AS DD_LOC_DESCRIPCION_RTE,
			CEX.CEX_TELEFONO1_RTE,
			PRVRTE.DD_PRV_CODIGO AS DD_PRV_CODIGO_RTE,
			PRVRTE.DD_PRV_DESCRIPCION AS DD_PRV_DESCRIPCION_RTE,
			CEX.CEX_TELEFONO2_RTE,
			CEX.CEX_CODIGO_POSTAL_RTE,
			CEX.CEX_EMAIL_RTE,
			EPB.DD_EPB_CODIGO AS COD_ESTADO_PBC,
			EPB.DD_EPB_DESCRIPCION AS DESC_ESTADO_PBC,
			CEX.CEX_RELACION_HRE,
			REG.DD_REM_CODIGO AS COD_REM_CODIGO,
			REG.DD_REM_DESCRIPCION AS DESC_REM_CODIGO,
			COM.COM_APELLIDOS AS APELLIDOS_COMPRADOR,
			CEX.CEX_APELLIDOS_RTE AS APELLIDOS_COMPRADOR_RTE,
			CEX.CEX_FECHA_PETICION,
			CEX.CEX_FECHA_RESOLUCION,
			UAC.DD_UAC_CODIGO AS COD_USO_ACTIVO,
			UAC.DD_UAC_DESCRIPCION AS DESC_USO_ACTIVO,
			COM.ID_COMPRADOR_URSUS,
			COM.ID_COMPRADOR_URSUS_BH,
			TGP.DD_TGP_CODIGO AS COD_GRADO_PROPIEDAD,
			TGP.DD_TGP_DESCRIPCION AS DESC_GRADO_PROPIEDAD,
			PAI.DD_PAI_CODIGO AS COD_PAIS,
			PAI.DD_PAI_DESCRIPCION AS DESC_PAIS,
			PAIRTE.DD_PAI_CODIGO AS COD_PAIS_RTE,
			PAIRTE.DD_PAI_DESCRIPCION AS DESC_PAIS_RTE,
			COM.COM_CESION_DATOS,
			COM.COM_TRANSF_INTER,
			COM.COM_COMUNI_TERCEROS,
			CEX.ADCOM_ID,
			TDI_CONYUGE.DD_TDI_CODIGO AS COD_TIPO_DOCUMENTO_CONYUGE,
			TDI_CONYUGE.DD_TDI_DESCRIPCION AS DESC_TIPO_DOCUMENTO_CONYUGE,
			CASE COM.PROBLEMAS_URSUS WHEN 1 THEN ''Si''  WHEN 0 THEN ''No'' ELSE NULL END AS PROBLEMAS_URSUS,
			COM.DD_ECV_ID_URSUS,
			COM.DD_REM_ID_URSUS,
			COM.N_URSUS_CONYUGE,
			COM.NOMBRE_CONYUGE_URSUS,
			CEX.CEX_CLI_URSUS_CONYUGE_REM,
			CEX.CEX_NUM_URSUS_CONYUGE_REM,
			CEX.CEX_NUM_URSUS_CONYUGE_BH_REM,
			CEX.CEX_C4C_ID,
			COM.COM_FECHA_NACIOCONST,
			ECL.DD_ECL_CODIGO AS COD_ESTADO_CONTRASTE,
			ECL.DD_ECL_DESCRIPCION AS DESC_ESTADO_CONTRASTE,
			COM.COM_FORMA_JURIDICA,
			CEX.CEX_FECHA_NACIMIENTO_REPR,
			LOCREPR.DD_LOC_CODIGO AS DD_LOC_CODIGO_CEX,
			LOCREPR.DD_LOC_DESCRIPCION AS DD_LOC_DESCRIPCION_CEX,
			PAIREPR.DD_PAI_CODIGO AS DD_PAI_CODIGO_CEX,
			PAIREPR.DD_PAI_DESCRIPCION AS DD_PAI_DESCRIPCION_CEX,
			CEX.CEX_USUFRUCTUARIO,
			COM.COM_FECHA_NACIMIENTO,
			LOCCOM.DD_LOC_CODIGO AS DD_LOC_CODIGO_COM,
			LOCCOM.DD_LOC_DESCRIPCION AS DD_LOC_DESCRIPCION_COM,
			COM.COM_PRP

		FROM REM01.COM_COMPRADOR COM
	      	LEFT JOIN '|| V_ESQUEMA ||'.CEX_COMPRADOR_EXPEDIENTE CEX ON CEX.COM_ID = COM.COM_ID
	        LEFT JOIN '|| V_ESQUEMA ||'.DD_TPE_TIPO_PERSONA TPE ON COM.DD_TPE_ID = TPE.DD_TPE_ID
	        LEFT JOIN '|| V_ESQUEMA ||'.DD_TDI_TIPO_DOCUMENTO_ID TDI ON COM.DD_TDI_ID = TDI.DD_TDI_ID
	        LEFT JOIN '|| V_ESQUEMA ||'.DD_ECV_ESTADOS_CIVILES ECV ON CEX.DD_ECV_ID = ECV.DD_ECV_ID
	        LEFT JOIN '|| V_ESQUEMA ||'.DD_TDI_TIPO_DOCUMENTO_ID TDI_RTE ON CEX.DD_TDI_ID_RTE = TDI_RTE.DD_TDI_ID
			LEFT JOIN '|| V_ESQUEMA ||'.DD_EPB_ESTADOS_PBC EPB ON CEX.DD_EPB_ID = EPB.DD_EPB_ID
			LEFT JOIN '|| V_ESQUEMA ||'.DD_REM_REGIMENES_MATRIMONIALES REG ON CEX.DD_REM_ID = REG.DD_REM_ID
			LEFT JOIN '|| V_ESQUEMA ||'.DD_UAC_USOS_ACTIVO UAC ON CEX.DD_UAC_ID = UAC.DD_UAC_ID
			LEFT JOIN '|| V_ESQUEMA_MASTER ||'.DD_PRV_PROVINCIA PRV ON COM.DD_PRV_ID = PRV.DD_PRV_ID
			LEFT JOIN '|| V_ESQUEMA_MASTER ||'.DD_LOC_LOCALIDAD LOC ON COM.DD_LOC_ID = LOC.DD_LOC_ID
			LEFT JOIN '|| V_ESQUEMA_MASTER ||'.DD_PRV_PROVINCIA PRVRTE ON CEX.DD_PRV_ID_RTE = PRVRTE.DD_PRV_ID
			LEFT JOIN '|| V_ESQUEMA_MASTER ||'.DD_LOC_LOCALIDAD LOCRTE ON CEX.DD_LOC_ID_RTE = LOCRTE.DD_LOC_ID
			LEFT JOIN '|| V_ESQUEMA_MASTER ||'.DD_LOC_LOCALIDAD LOCREPR ON CEX.CEX_LOC_NAC_REPR = LOCREPR.DD_LOC_ID
			LEFT JOIN '|| V_ESQUEMA_MASTER ||'.DD_LOC_LOCALIDAD LOCCOM ON COM.DD_LOC_NAC_ID = LOCCOM.DD_LOC_ID
			LEFT JOIN '|| V_ESQUEMA ||'.DD_TGP_TIPO_GRADO_PROPIEDAD TGP ON CEX.DD_TGP_ID = TGP.DD_TGP_ID
			LEFT JOIN '|| V_ESQUEMA ||'.DD_PAI_PAISES PAI ON CEX.DD_PAI_ID = PAI.DD_PAI_ID
			LEFT JOIN '|| V_ESQUEMA ||'.DD_PAI_PAISES PAIRTE ON CEX.DD_PAI_ID_RTE = PAIRTE.DD_PAI_ID
			LEFT JOIN '|| V_ESQUEMA ||'.DD_PAI_PAISES PAIREPR ON CEX.DD_PAI_NAC_REPR_ID = PAIREPR.DD_PAI_ID
            LEFT JOIN '|| V_ESQUEMA ||'.CGD_CLIENTE_GDPR CGD ON CGD.CLC_ID = COM.CLC_ID
            LEFT JOIN '|| V_ESQUEMA ||'.ADC_ADJUNTO_COMPRADOR ADC ON ADC.ADCOM_ID = CGD.ADCOM_ID
			LEFT JOIN '|| V_ESQUEMA ||'.DD_TDI_TIPO_DOCUMENTO_ID TDI_CONYUGE ON CEX.DD_TDI_ID_CONYUGE = TDI_CONYUGE.DD_TDI_ID
			LEFT JOIN '|| V_ESQUEMA ||'.DD_ECL_ESTADO_CONT_LISTAS ECL ON CEX.DD_ECL_ID = ECL.DD_ECL_ID';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_DATOS_COMPRADOR_EXP...Creada OK');
  
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

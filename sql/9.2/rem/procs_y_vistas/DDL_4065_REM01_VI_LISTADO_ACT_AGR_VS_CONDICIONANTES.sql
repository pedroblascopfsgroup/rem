--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20180516
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-4083
--## PRODUCTO=NO
--## Finalidad: DDL nueva vista
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE

    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(32000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

   SELECT COUNT(1) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_LIST_ACT_AGR_VS_COND' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
   
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_LIST_ACT_AGR_VS_COND...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_LIST_ACT_AGR_VS_COND';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_LIST_ACT_AGR_VS_COND... borrada OK');
  END IF;

  SELECT COUNT(1) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_LIST_ACT_AGR_VS_COND' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_LIST_ACT_AGR_VS_COND...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_LIST_ACT_AGR_VS_COND';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_LIST_ACT_AGR_VS_COND... borrada OK');
  END IF;

      V_MSQL := 'CREATE OR REPLACE FORCE VIEW '|| V_ESQUEMA ||'."V_LIST_ACT_AGR_VS_COND" 
		("PRINCIPAL", "DIRECCION", "BIE_LOC_PUERTA", "BIE_DREG_NUM_FINCA", "NUMEROPROPIETARIOS", "PROPIETARIO", "AGA_FECHA_INCLUSION", "ACT_ID", "ACT_NUM_ACTIVO", "ACT_NUM_ACTIVO_REM", "DD_TPA_DESCRIPCION", "DD_SAC_ID", "AGR_ID", "AGA_ID", "BIE_DREG_SUPERFICIE_CONSTRUIDA", "VAL_IMPORTE_APROBADO_VENTA", "VAL_IMPORTE_MINIMO_AUTORIZADO", "VAL_NETO_CONTABLE", "SITUACION_COMERCIAL", "SPS_OCUPADO", "SPS_CON_TITULO", "SDV_NOMBRE", "PUBLICADO", "VAL_IMPORTE_DESCUENTO_PUBLICO"
  
		,"SIN_TOMA_POSESION_INICIAL", "OCUPADO_CONTITULO", "PENDIENTE_INSCRIPCION", "PROINDIVISO", "TAPIADO", "OBRANUEVA_SINDECLARAR", "OBRANUEVA_ENCONSTRUCCION", "DIVHORIZONTAL_NOINSCRITA", "RUINA", "OTRO", "SIN_INFORME_APROBADO", "REVISION", "PROCEDIMIENTO_JUDICIAL", "CON_CARGAS", "OCUPADO_SINTITULO", "ESTADO_PORTAL_EXTERNO", "ES_CONDICIONADO", "EST_DISP_COM_CODIGO", "BORRADO") AS 
		select actagr.PRINCIPAL, actagr.DIRECCION, actagr.BIE_LOC_PUERTA, actagr.BIE_DREG_NUM_FINCA, actagr.NUMEROPROPIETARIOS, actagr.PROPIETARIO, actagr.AGA_FECHA_INCLUSION, actagr.ACT_ID, actagr.ACT_NUM_ACTIVO, actagr.ACT_NUM_ACTIVO_REM, actagr.DD_TPA_DESCRIPCION, actagr.DD_SAC_ID, actagr.AGR_ID, actagr.AGA_ID, actagr.BIE_DREG_SUPERFICIE_CONSTRUIDA, actagr.VAL_IMPORTE_APROBADO_VENTA, actagr.VAL_IMPORTE_MINIMO_AUTORIZADO, actagr.VAL_NETO_CONTABLE, actagr.SITUACION_COMERCIAL, actagr.SPS_OCUPADO, actagr.SPS_CON_TITULO, actagr.SDV_NOMBRE, actagr.PUBLICADO, actagr.VAL_IMPORTE_DESCUENTO_PUBLICO
		, cond.SIN_TOMA_POSESION_INICIAL, cond.OCUPADO_CONTITULO, cond.PENDIENTE_INSCRIPCION, cond.PROINDIVISO, cond.TAPIADO, cond.OBRANUEVA_SINDECLARAR, cond.OBRANUEVA_ENCONSTRUCCION, cond.DIVHORIZONTAL_NOINSCRITA, cond.RUINA, cond.OTRO, cond.SIN_INFORME_APROBADO, cond.REVISION, cond.PROCEDIMIENTO_JUDICIAL, cond.CON_CARGAS, cond.OCUPADO_SINTITULO, cond.ESTADO_PORTAL_EXTERNO, cond.ES_CONDICIONADO, cond.EST_DISP_COM_CODIGO, cond.BORRADO
		from '|| V_ESQUEMA ||'.v_activos_agrupacion actagr,
		'|| V_ESQUEMA ||'.V_COND_DISPONIBILIDAD cond
		where actagr.act_id = cond.act_id (+)
      ';

    EXECUTE IMMEDIATE V_MSQL; 
    
    DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_CAMBIO_ESTADO_PUBLI...Creada OK');
       
END;
/

EXIT;


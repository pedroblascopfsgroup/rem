--/*
--##########################################
--## AUTOR=JINLI HU
--## FECHA_CREACION=20181116
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2475
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 20161006 Versión inicial	
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
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'V_FACTURAS_PROVEEDORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'
	AS SELECT ROWNUM ID_VISTA,SOCIEDAD,VISTA,RANK() OVER (ORDER BY ORDEN ASC) AS ORDEN,CIF,CODIGO,NUM_FRA,FECHA_FRA,FECHA_CONTABLE,DIARIO_CONTB,IMP_BRUTO,TOTAL
,OP_ALQ,D347,TIPO_FRA,SUJ_RECC,DELEGACION,BASE_RETENCION,PORCENTAJE_RETENCION,IMPORTE_RETENCION,APLICAR_RETENCION,BASE_IRPF,PORCENTAJE_IRPF,IMPORTE_IRPF,CLAVE_IRPF,SUBCLAVE_IRPF,CEUTA
,CONCEPTO,CTA_ACREEDORA,SCTA_ACREEDORA,CTA_GARANTIA,SCTA_GARANTIA,CTA_IRPF,SCTA_IRPF,CTA_IVAD,SCTA_IVAD,CONDICIONES,PAGADA,CTA_BANCO,SCTA_BANCO,CTA_EFECTOS,SCTA_EFECTOS,APUNTE,CENTRODESTINO
,TIPO_FRA_SII,CLAVE_RE,CLAVE_RE_AD1,CLAVE_RE_AD2,TIPO_OP_INTRA,DESC_BIENES,DESCRIPCION_OP,SIMPLIFICADA,FRA_SIMPLI_IDEN,DIARIO1,BASE1,IVA1,CUOTA1,DIARIO2,BASE2,IVA2,CUOTA2,PROYECTO,TIPO_INMUEBLE,CLAVE1,CLAVE2,CLAVE3,CLAVE4,ID_ACTIVO
,IMPORTE_GASTO,TIPO_PARTIDA,APARTADO,CAPITULO,PARTIDA,CTA_GASTO,SCTA_GASTO,REPERCUTIR,CONCEPTO_FAC,FECHA_FAC,COD_COEF,CODI_DIAR_IVA_V,PCTJE_IVA_V,NOMBRE,CARACTERISTICA,RUTA,ETAPA

FROM (
	
SELECT     
     CASE	WHEN PROP.PRO_CODIGO_UVEM = ''7043'' THEN ''1000'' 
			WHEN PROP.PRO_CODIGO_UVEM = ''7044'' THEN ''3000''  
			WHEN PROP.PRO_CODIGO_UVEM = ''7045'' THEN ''4000''  
			WHEN PROP.PRO_CODIGO_UVEM = ''7046'' THEN ''3002''  
			WHEN PROP.PRO_CODIGO_UVEM = ''7047'' THEN ''3001''  
     END											AS	SOCIEDAD
    , 1												AS  VISTA         
    , GPV.GPV_NUM_GASTO_HAYA  						AS	ORDEN		  
    , PVE.PVE_DOCIDENTIF							AS  CIF                                                            
    , PVE.PVE_COD_PRINEX							AS  CODIGO                                                          
    , GPV.GPV_REF_EMISOR							AS  NUM_FRA
    , GPV.GPV_FECHA_EMISION							AS  FECHA_FRA
    , SYSDATE     									AS  FECHA_CONTABLE   
    , GPL.GPL_DIARIO_CONTB							AS  DIARIO_CONTB                                              
    , CASE
			WHEN TGA.DD_TGA_CODIGO IN (''01'',''02'',''03'',''04'') THEN AUX.SUMA
			WHEN GPL.GPL_APLICAR_RETENCION = ''A'' THEN COALESCE(GPL.GPL_DIARIO1_BASE,0)  + COALESCE(GPL.GPL_DIARIO2_BASE,0) + COALESCE(GPL.GPL_IMPORTE_RENTE,0)
			ELSE COALESCE(GPL.GPL_DIARIO1_BASE,0)  + COALESCE(GPL.GPL_DIARIO2_BASE,0)	
	  END											AS	IMP_BRUTO                                   
    , CASE
			WHEN TGA.DD_TGA_CODIGO IN (''01'',''02'',''03'',''04'') THEN AUX.SUMA
			WHEN GPL.GPL_APLICAR_RETENCION = ''D'' 
				THEN (COALESCE(GPL.GPL_DIARIO1_BASE,0) + COALESCE(GPL.GPL_DIARIO1_CUOTA,0) +COALESCE(GPL.GPL_DIARIO2_BASE,0) + COALESCE(GPL.GPL_DIARIO2_CUOTA,0)) -
						(COALESCE(GPL.GPL_IMPORTE_IRPF,CASE WHEN GDE.GDE_IRPF_TIPO_IMPOSITIVO  IS NOT NULL THEN GDE.GDE_IRPF_CUOTA ELSE 0 END)) - COALESCE(GPL.GPL_IMPORTE_RENTE,0)
			ELSE (COALESCE(GPL.GPL_DIARIO1_BASE,0) + COALESCE(GPL.GPL_DIARIO1_CUOTA,0) +COALESCE(GPL.GPL_DIARIO2_BASE,0) + COALESCE(GPL.GPL_DIARIO2_CUOTA,0)) -
					COALESCE(GPL.GPL_IMPORTE_IRPF,CASE WHEN GDE.GDE_IRPF_TIPO_IMPOSITIVO  IS NOT NULL THEN GDE.GDE_IRPF_CUOTA ELSE 0 END) 	
	  END											AS  TOTAL                                                        
    , ''N''										    AS  OP_ALQ                                       
    , GPL.GPL_D347                         			AS  D347                                                        
    , CASE 
			WHEN PVE.PVE_IVA_CAJA = 1 AND GDE.DD_TIT_ID IS NOT NULL THEN ''D'' --
			WHEN GDE.DD_TIT_ID IS NOT NULL AND COALESCE(PVE.PVE_IVA_CAJA,0) <> 1  THEN ''F''    
			ELSE ''C''   
	  END											AS  TIPO_FRA                                                                                                 
    , CASE	WHEN PVE.PVE_IVA_CAJA = 1 THEN ''S''
			WHEN PVE.PVE_IVA_CAJA  = 0 THEN ''N''
			ELSE NULL END							AS  SUJ_RECC                                           
    , GPL.GPL_DELEGACION							AS  DELEGACION                                                   
    , GPL.GPL_BASE_RETENCION						AS  BASE_RETENCION                                                
    , GPL.GPL_PROCENTAJE_RETEN						AS  PORCENTAJE_RETENCION                                       
    , GPL.GPL_IMPORTE_RENTE							AS  IMPORTE_RETENCION                                            
    , GPL.GPL_APLICAR_RETENCION						AS  APLICAR_RETENCION    
    , COALESCE(GPL.GPL_BASE_IRPF,
		CASE	WHEN GDE.GDE_IRPF_TIPO_IMPOSITIVO  IS NOT NULL THEN GDE.GDE_PRINCIPAL_SUJETO 
				ELSE NULL	END)					AS  BASE_IRPF                                                    
	, COALESCE(GPL.GPL_PROCENTAJE_IRPF,GDE.GDE_IRPF_TIPO_IMPOSITIVO)      	 AS  PORCENTAJE_IRPF                                                
    , COALESCE(GPL.GPL_IMPORTE_IRPF,
		CASE	WHEN GDE.GDE_IRPF_TIPO_IMPOSITIVO  IS NOT NULL THEN GDE.GDE_IRPF_CUOTA 
				ELSE NULL	END)					AS  IMPORTE_IRPF                                       
    , COALESCE(GPL.GPL_CLAVE_IRPF,
		CASE	WHEN GDE.GDE_IRPF_TIPO_IMPOSITIVO  IS NOT NULL THEN  ''G''  
				ELSE NULL	END)					AS  CLAVE_IRPF                                                
    , COALESCE(GPL.GPL_SUBCLAVE_IRPF,
		CASE	WHEN GDE.GDE_IRPF_TIPO_IMPOSITIVO  IS NOT NULL THEN  ''1'' 
				ELSE NULL	END) 					AS  SUBCLAVE_IRPF                                      
	, GPL.GPL_CEUTA									AS  CEUTA                                                    
    , CONCAT(TO_CHAR(GPV.GPV_NUM_GASTO_HAYA),CONCAT(''-'',GPV.GPV_CONCEPTO))        AS    CONCEPTO                                                    
    , 4100											AS  CTA_ACREEDORA                                           
    , ''0000000''										AS  SCTA_ACREEDORA                                            
    , 4948											AS  CTA_GARANTIA                                            
    , ''0000000''										AS  SCTA_GARANTIA                                            
    , 4751											AS  CTA_IRPF                                                
    , ''0000000''										AS  SCTA_IRPF                                                
    , GPL.GPL_CTA_IVAD								AS  CTA_IVAD                                               
    , GPL.GPL_SCTA_IVAD								AS  SCTA_IVAD                                                
    , GPL.GPL_CONDICIONES							AS  CONDICIONES                                                
    ,  ''N''											AS  PAGADA                                                        
    , GPL.GPL_CTA_BANCO								AS  CTA_BANCO                                                
    , GPL.GPL_SCTA_BANCO							AS  SCTA_BANCO                                                
    , GPL.GPL_CTA_EFECTOS							AS  CTA_EFECTOS                                               
    , GPL.GPL_SCTA_EFECTOS							AS  SCTA_EFECTOS                                            
    , GPL.GPL_APUNTE								AS  APUNTE                                                    
    , GPL.GPL_CENTRODESTINO							AS  CENTRODESTINO
    , GPL.GPL_TIPO_FRA_SII							AS  TIPO_FRA_SII                                            
    , GPL.GPL_CLAVE_RE								AS  CLAVE_RE                                                
    , GPL.GPL_CLAVE_RE_AD1							AS  CLAVE_RE_AD1                                            
    , GPL.GPL_CLAVE_RE_AD2							AS  CLAVE_RE_AD2                                            
    , GPL.GPL_TIPO_OP_INTRA							AS  TIPO_OP_INTRA                                            
    , GPL.GPL_DESC_BIENES							AS  DESC_BIENES                                                
    , GPL.GPL_DESCRIPCION_OP						AS  DESCRIPCION_OP                                                             
    , GPL.GPL_SIMPLIFICADA							AS  SIMPLIFICADA
    , GPL.GPL_FRA_SIMPLI_IDEN						AS  FRA_SIMPLI_IDEN
	, GPL.GPL_DIARIO1								AS  DIARIO1                
	, GPL.GPL_DIARIO1_BASE							AS  BASE1
	, GPL.GPL_DIARIO1_TIPO							AS  IVA1
	, GPL.GPL_DIARIO1_CUOTA							AS  CUOTA1
	, GPL.GPL_DIARIO2								AS  DIARIO2
	, GPL.GPL_DIARIO2_BASE							AS  BASE2
	, GPL.GPL_DIARIO2_TIPO							AS  IVA2
	, GPL.GPL_DIARIO2_CUOTA							AS  CUOTA2         
   , GPL.GPL_PROYECTO                         AS PROYECTO
    , GPL.GPL_TIPO_INMUEBLE							AS  TIPO_INMUEBLE		
    , GPL.GPL_CLAVE_1								AS  CLAVE1           	
    , GPL.GPL_CLAVE_2								AS  CLAVE2           	
    , GPL.GPL_CLAVE_3								AS  CLAVE3           	
    , GPL.GPL_CLAVE_4								AS  CLAVE4				
    , ACT.ACT_NUM_ACTIVO_PRINEX						AS  ID_ACTIVO    
    , GPL.GPL_IMPORTE_GASTO							AS  IMPORTE_GASTO			
    , GPL.GPL_TIPO_PARTIDA							AS  TIPO_PARTIDA                            
    , GPL.GPL_APARTADO								AS  APARTADO                                
    , GPL.GPL_CAPITULO								AS  CAPITULO                                
    , GPL.GPL_PARTIDA								AS  PARTIDA                                    
    , GPL.GPL_CTA_GASTO								AS  CTA_GASTO
    , GPL.GPL_SCTA_GASTO							AS  SCTA_GASTO
    , GPL.GPL_REPERCUTIR							AS  REPERCUTIR
    , COALESCE(GPL.GPL_CONCEPTO_FAC,
		CASE WHEN GDE.GDE_REPERCUTIBLE_INQUILINO = 1 THEN  
			CASE	WHEN STG.DD_STG_CODIGO=''08''       		 THEN ''BAS''
					WHEN STG.DD_STG_CODIGO IN (''48'',''93'')       THEN ''COM''
					WHEN STG.DD_STG_CODIGO=''62''      		 THEN ''ENG''
					WHEN STG.DD_STG_CODIGO IN (''30'',''32'')       THEN ''GTC''
					WHEN STG.DD_STG_CODIGO IN (''01'',''02'')   	 THEN ''IBI''
					WHEN STG.DD_STG_CODIGO IN (''15'',''59'',''60'',''61'',''63'',''69'',''70'',''71'',''79'',''80'',''81
						'',''82'',''86'',''94'',''03'',''04'',''05'',''06'',''07'',''11'',''12'',''13'',''14'',''16'',''17'',''18'',''19'',''20'',''21'',''22'',''23
						'',''24'',''25'',''34'',''38'',''39'',''40'',''41'',''42'',''43'',''44'',''45'',''46'',''47'',''49'',''50'',''51'',''52'',''53'',''54'',''55
						'',''56'',''57'',''58'',''64'',''65'',''66'',''67'',''68'',''72'',''73'',''74'',''75'',''76'',''77'',''78'',''83'',''84'',''85'',''87'',''88
						'',''89'',''90'',''91'',''92'',''95'',''96'',''97'',''98'',''99'')      		 THEN ''OTR''
					WHEN STG.DD_STG_CODIGO IN (''26'',''28'',''31'',''33'') THEN ''RTA''
					WHEN STG.DD_STG_CODIGO IN (''26'',''28'',''31'',''33'') THEN ''RTA''
					WHEN STG.DD_STG_CODIGO IN (''27'',''29'') THEN ''RTE''
					WHEN STG.DD_STG_CODIGO IN (''09'',''10'',''35'',''36'',''37'') THEN ''SUM''
			ELSE NULL END 
         ELSE NULL END   )							AS  CONCEPTO_FAC
    , GPL.GPL_FECHA_FAC								AS 	FECHA_FAC
    , GPL.GPL_COD_COEF								AS  COD_COEF
    , GPL.GPL_CODI_DIAR_IVA_V						AS  CODI_DIAR_IVA_V
    , GPL.GPL_PCTJE_IVA_V							AS  PCTJE_IVA_V
    , NULL											AS  NOMBRE
    , NULL											AS  CARACTERISTICA    
    , CASE	WHEN PROP.PRO_CODIGO_UVEM = ''7043''	THEN ''116''
			WHEN PROP.PRO_CODIGO_UVEM = ''7044''  THEN ''117''
			WHEN PROP.PRO_CODIGO_UVEM = ''7045''  THEN ''120''
			WHEN PROP.PRO_CODIGO_UVEM = ''7046''  THEN ''119''
			WHEN PROP.PRO_CODIGO_UVEM = ''7047''  THEN ''118''   
	  END											AS  RUTA              
    , ''ALTA''										AS  ETAPA     
	, TGA.DD_TGA_CODIGO								AS	TIPO_GASTO
	, STG.DD_STG_CODIGO								AS	SUBTIPO_GASTO
	
FROM 

    REM01.ACT_ACTIVO ACT 

    INNER JOIN REM01.DD_CRA_CARTERA CART
        ON CART.DD_CRA_ID = ACT.DD_CRA_ID   
            AND CART.DD_CRA_CODIGO = ''08'' 

    INNER JOIN REM01.GPV_ACT REL
        ON REL.ACT_ID = ACT.ACT_ID
            AND COALESCE(ACT.BORRADO, 0) = 0

    INNER JOIN REM01.GPV_GASTOS_PROVEEDOR GPV
        ON REL.GPV_ID = GPV.GPV_ID     
            AND COALESCE(GPV.BORRADO, 0) = 0  

	INNER JOIN REM01.GPL_GASTOS_PRINEX_LBK   GPL
		ON GPV.GPV_ID = GPL.GPV_ID   AND ACT.ACT_ID = GPL.ACT_ID
			AND COALESCE(GPL.BORRADO, 0) = 0
	
    INNER JOIN REM01.ACT_PVE_PROVEEDOR PVE    
        ON PVE.PVE_ID = GPV.PVE_ID_EMISOR
			 AND (TO_CHAR(SYSDATE,''YYYYMMDD'') 
                  BETWEEN COALESCE(TO_CHAR(PVE.PVE_FECHA_ALTA,''YYYYMMDD''),''19990101'')
                        AND COALESCE (TO_CHAR(PVE.PVE_FECHA_BAJA,''YYYYMMDD''),''29990101'') )
            AND COALESCE(PVE.BORRADO, 0) = 0
	
    INNER JOIN REM01.DD_EGA_ESTADOS_GASTO EGA
        ON GPV.DD_EGA_ID = EGA.DD_EGA_ID
            AND COALESCE(EGA.BORRADO, 0) = 0
            AND EGA.DD_EGA_CODIGO=''03''

    INNER JOIN REM01.ACT_PRO_PROPIETARIO PROP
        ON GPV.PRO_ID = PROP.PRO_ID            
           AND COALESCE(PROP.BORRADO,0)= 0
	
	INNER JOIN REM01.DD_STG_SUBTIPOS_GASTO STG
        ON GPV.DD_STG_ID = STG.DD_STG_ID
			AND COALESCE(STG.BORRADO, 0) = 0
	
	INNER JOIN REM01.DD_TGA_TIPOS_GASTO	TGA
		ON TGA.DD_TGA_ID = STG.DD_TGA_ID
			AND TGA.DD_TGA_CODIGO NOT IN (''05'',''06'',''07'',''08'') 
			AND COALESCE(TGA.BORRADO,0) = 0

    LEFT JOIN REM01.GDE_GASTOS_DETALLE_ECONOMICO GDE
        ON GPV.GPV_ID = GDE.GPV_ID            
            AND COALESCE(GDE.BORRADO,0)= 0

    LEFT JOIN REM01.GIC_GASTOS_INFO_CONTABILIDAD GIC
        ON GIC.GPV_ID = GPV.GPV_ID
            AND COALESCE(GIC.BORRADO, 0) = 0
            
    LEFT JOIN REM01.ACT_SPS_SIT_POSESORIA SPS
            ON ACT.ACT_ID = SPS.ACT_ID
                AND COALESCE(SPS.BORRADO, 0) = 0 
	
	LEFT JOIN (SELECT GPV_NUM_GASTO_HAYA, sum (a.gpl_importe_gasto) AS SUMA 
				FROM REM01.GPL_GASTOS_PRINEX_LBK a
				left join REM01.GPV_gastos_proveedor b
					on a.GPV_ID = b.GPV_ID
				where COALESCE(a.borrado, 0) = 0 and COALESCE(b.borrado, 0) = 0
				group by GPV_NUM_GASTO_HAYA) AUX
			ON GPV.GPV_NUM_GASTO_HAYA = AUX.GPV_NUM_GASTO_HAYA

		WHERE 1=1
		AND GIC.GIC_FECHA_CONTABILIZACION IS NULL AND TGA.DD_TGA_CODIGO	 IN (''09'',''10'',''11'',''12'',''13'',''14'',''15'',''16'',''17'',''18'')



    UNION
	



	--BLOQUE 2:  GASTOS SIN ACTIVO
   SELECT     
	CASE	WHEN PROP.PRO_CODIGO_UVEM = ''7043'' THEN ''1000''  
			WHEN PROP.PRO_CODIGO_UVEM = ''7044'' THEN ''3000''   
			WHEN PROP.PRO_CODIGO_UVEM = ''7045'' THEN ''4000''   
			WHEN PROP.PRO_CODIGO_UVEM = ''7046'' THEN ''3002''   
			WHEN PROP.PRO_CODIGO_UVEM = ''7047'' THEN ''3001''   
	END												AS  SOCIEDAD
	, 1												AS  VISTA
	, GPV.GPV_NUM_GASTO_HAYA						AS  ORDEN
	, PVE.PVE_DOCIDENTIF							AS  CIF  
	, PVE.PVE_COD_PRINEX							AS  CODIGO
	, GPV.GPV_REF_EMISOR							AS  NUM_FRA
	, GPV.GPV_FECHA_EMISION							AS  FECHA_FRA
	, SYSDATE				 						AS  FECHA_CONTABLE
	, GPL.GPL_DIARIO_CONTB 							AS  DIARIO_CONTB
    , CASE
			WHEN TGA.DD_TGA_CODIGO IN (''01'',''02'',''03'',''04'') THEN AUX.SUMA
			WHEN GPL.GPL_APLICAR_RETENCION = ''A'' THEN COALESCE(GPL.GPL_DIARIO1_BASE,0)  + COALESCE(GPL.GPL_DIARIO2_BASE,0) + COALESCE(GPL.GPL_IMPORTE_RENTE,0)
			ELSE COALESCE(GPL.GPL_DIARIO1_BASE,0)  + COALESCE(GPL.GPL_DIARIO2_BASE,0)	
	  END											AS	IMP_BRUTO                                 
    , CASE
		WHEN TGA.DD_TGA_CODIGO IN (''01'',''02'',''03'',''04'') THEN AUX.SUMA
		WHEN GPL.GPL_APLICAR_RETENCION = ''D'' 
			THEN (COALESCE(GPL.GPL_DIARIO1_BASE,0) + COALESCE(GPL.GPL_DIARIO1_CUOTA,0) +COALESCE(GPL.GPL_DIARIO2_BASE,0) + COALESCE(GPL.GPL_DIARIO2_CUOTA,0)) -
				(COALESCE(GPL.GPL_IMPORTE_IRPF,CASE WHEN GDE.GDE_IRPF_TIPO_IMPOSITIVO  IS NOT NULL THEN GDE.GDE_IRPF_CUOTA ELSE 0 END)) - COALESCE(GPL.GPL_IMPORTE_RENTE,0)
		ELSE (COALESCE(GPL.GPL_DIARIO1_BASE,0) + COALESCE(GPL.GPL_DIARIO1_CUOTA,0) +COALESCE(GPL.GPL_DIARIO2_BASE,0) + COALESCE(GPL.GPL_DIARIO2_CUOTA,0)) -
			  COALESCE(GPL.GPL_IMPORTE_IRPF,CASE WHEN GDE.GDE_IRPF_TIPO_IMPOSITIVO  IS NOT NULL THEN GDE.GDE_IRPF_CUOTA ELSE 0 END) 	
	  END											AS  TOTAL        
	, ''N''	                						AS  OP_ALQ
	, GPL.GPL_D347									AS  D347
	, CASE 
			WHEN PVE.PVE_IVA_CAJA = 1 AND GDE.DD_TIT_ID IS NOT NULL THEN ''D'' --
			WHEN GDE.DD_TIT_ID IS NOT NULL AND COALESCE(PVE.PVE_IVA_CAJA,0) <> 1  THEN ''F''
			ELSE ''C''  
	  END											AS  TIPO_FRA    
	, CASE	WHEN PVE.PVE_IVA_CAJA = 1	THEN ''S''
			WHEN PVE.PVE_IVA_CAJA  = 0	THEN ''N''
			ELSE NULL	END                  		AS  SUJ_RECC
	, GPL.GPL_DELEGACION                            AS  DELEGACION                                                    
	, GPL.GPL_BASE_RETENCION                        AS  BASE_RETENCION                                                
	, GPL.GPL_PROCENTAJE_RETEN	                    AS  PORCENTAJE_RETENCION                                        
	, GPL.GPL_IMPORTE_RENTE                         AS  IMPORTE_RETENCION                                            
	, GPL.GPL_APLICAR_RETENCION                     AS  APLICAR_RETENCION 
	, COALESCE(GPL.GPL_BASE_IRPF,
		CASE WHEN GDE.GDE_IRPF_TIPO_IMPOSITIVO  IS NOT NULL THEN GDE.GDE_PRINCIPAL_SUJETO 
		ELSE NULL	END)							AS  BASE_IRPF                                                    
	, COALESCE(GPL.GPL_PROCENTAJE_IRPF,GDE.GDE_IRPF_TIPO_IMPOSITIVO)      	 AS   PORCENTAJE_IRPF                                                
	, COALESCE(GPL.GPL_IMPORTE_IRPF,
		CASE WHEN GDE.GDE_IRPF_TIPO_IMPOSITIVO  IS NOT NULL THEN GDE.GDE_IRPF_CUOTA 
		ELSE NULL	END)							AS  IMPORTE_IRPF                                       
	, COALESCE(GPL.GPL_CLAVE_IRPF,
		CASE WHEN GDE.GDE_IRPF_TIPO_IMPOSITIVO  IS NOT NULL THEN  ''G''  
		ELSE NULL	END)							AS  CLAVE_IRPF                                                
	, COALESCE(GPL.GPL_SUBCLAVE_IRPF,
		CASE WHEN GDE.GDE_IRPF_TIPO_IMPOSITIVO  IS NOT NULL THEN  ''1'' 
		ELSE NULL	END) 							AS  SUBCLAVE_IRPF                                      
	, GPL.GPL_CEUTA									AS  CEUTA                
	, CONCAT(TO_CHAR(GPV.GPV_NUM_GASTO_HAYA),CONCAT(''-'',GPV.GPV_CONCEPTO))   AS   CONCEPTO
	, 4100											AS  CTA_ACREEDORA
	, ''0000000''										AS  SCTA_ACREEDORA
	, 4948											AS  CTA_GARANTIA
	, ''0000000''										AS  SCTA_GARANTIA
	, 4751											AS  CTA_IRPF
	, ''0000000''										AS  SCTA_IRPF
	, GPL.GPL_CTA_IVAD								AS  CTA_IVAD                                                
	, GPL.GPL_SCTA_IVAD								AS  SCTA_IVAD                                                
	, NULL											AS  CONDICIONES                                         
	,  ''N''											AS  PAGADA                                                        
	, GPL.GPL_CTA_BANCO								AS  CTA_BANCO                                                
	, GPL.GPL_SCTA_BANCO							AS  SCTA_BANCO                                                
	, GPL.GPL_CTA_EFECTOS							AS  CTA_EFECTOS                                                
	, GPL.GPL_SCTA_EFECTOS							AS  SCTA_EFECTOS                                            
	, GPL.GPL_APUNTE								AS  APUNTE                                                    
	, GPL.GPL_CENTRODESTINO							AS  CENTRODESTINO
	, GPL.GPL_TIPO_FRA_SII							AS  TIPO_FRA_SII                                            
	, GPL.GPL_CLAVE_RE								AS  CLAVE_RE                                                
	, GPL.GPL_CLAVE_RE_AD1							AS  CLAVE_RE_AD1                                            
	, GPL.GPL_CLAVE_RE_AD2							AS  CLAVE_RE_AD2                                            
	, GPL.GPL_TIPO_OP_INTRA							AS  TIPO_OP_INTRA                                           
	, GPL.GPL_DESC_BIENES							AS  DESC_BIENES                                                
	, GPL.GPL_DESCRIPCION_OP						AS  DESCRIPCION_OP                                                              
	, GPL.GPL_SIMPLIFICADA							AS  SIMPLIFICADA
	, GPL.GPL_FRA_SIMPLI_IDEN						AS  FRA_SIMPLI_IDEN
   	, GPL.GPL_DIARIO1								AS  DIARIO1
	, GPL.GPL_DIARIO1_BASE							AS  BASE1
	, GPL.GPL_DIARIO1_TIPO							AS  IVA1
	, GPL.GPL_DIARIO1_CUOTA							AS  CUOTA1		
	, GPL.GPL_DIARIO2								AS  DIARIO2
	, GPL.GPL_DIARIO2_BASE							AS  BASE2
	, GPL.GPL_DIARIO2_TIPO							AS  IVA2
	, GPL.GPL_DIARIO2_CUOTA							AS  CUOTA2		
	, GPL.GPL_PROYECTO								AS	PROYECTO
	, NULL											AS  TIPO_INMUEBLE
	, NULL											AS  CLAVE1
	, NULL											AS  CLAVE2
	, NULL											AS  CLAVE3
	, NULL											AS  CLAVE4
	, NULL											AS  ID_ACTIVO	
	, GPL.GPL_IMPORTE_GASTO							AS	IMPORTE_GASTO
	, GPL.GPL_TIPO_PARTIDA							AS  TIPO_PARTIDA                            
	, GPL.GPL_APARTADO								AS  APARTADO                                
	, GPL.GPL_CAPITULO								AS  CAPITULO                                
	, GPL.GPL_PARTIDA								AS  PARTIDA                                    
	, GPL.GPL_CTA_GASTO								AS  CTA_GASTO
	, GPL.GPL_SCTA_GASTO							AS  SCTA_GASTO
	, GPL.GPL_REPERCUTIR							AS  REPERCUTIR		
	, COALESCE(GPL.GPL_CONCEPTO_FAC,
			CASE WHEN GDE.GDE_REPERCUTIBLE_INQUILINO = 1 THEN  
				CASE	WHEN STG.DD_STG_CODIGO=''08''       		 THEN ''BAS ''
						WHEN STG.DD_STG_CODIGO IN (''48'',''93'')    THEN ''COM''
						WHEN STG.DD_STG_CODIGO=''62''      		 THEN ''ENG''
						WHEN STG.DD_STG_CODIGO IN (''30'',''32'')    THEN ''GTC''
						WHEN STG.DD_STG_CODIGO IN (''01'',''02'')    THEN ''IBI''
						WHEN STG.DD_STG_CODIGO IN (''15'',''59'',''60'',''61'',''63'',''69'',''70'',''71'',''79'',''80'',''81
					      '',''82'',''86'',''94'',''03'',''04'',''05'',''06'',''07'',''11'',''12'',''13'',''14'',''16'',''17'',''18'',''19'',''20'',''21'',''22'',''23
					      '',''24'',''25'',''34'',''38'',''39'',''40'',''41'',''42'',''43'',''44'',''45'',''46'',''47'',''49'',''50'',''51'',''52'',''53'',''54'',''55
					      '',''56'',''57'',''58'',''64'',''65'',''66'',''67'',''68'',''72'',''73'',''74'',''75'',''76'',''77'',''78'',''83'',''84'',''85'',''87'',''88
					      '',''89'',''90'',''91'',''92'',''95'',''96'',''97'',''98'',''99'') THEN ''OTR''
					    WHEN STG.DD_STG_CODIGO IN (''26'',''28'',''31'',''33'') THEN ''RTA''
					    WHEN STG.DD_STG_CODIGO IN (''26'',''28'',''31'',''33'') THEN ''RTA''
					    WHEN STG.DD_STG_CODIGO IN (''27'',''29'')			THEN ''RTE''
					    WHEN STG.DD_STG_CODIGO IN (''09'',''10'',''35'',''36'',''37'') THEN ''SUM''
				ELSE NULL END 				
			ELSE NULL	END   )						AS  CONCEPTO_FAC
	, GPL.GPL_FECHA_FAC								AS 	FECHA_FAC
	, GPL.GPL_COD_COEF								AS  COD_COEF
	, GPL.GPL_CODI_DIAR_IVA_V						AS  CODI_DIAR_IVA_V
	, GPL.GPL_PCTJE_IVA_V							AS  PCTJE_IVA_V
	, NULL                     						AS  NOMBRE
	, NULL             								AS  CARACTERISTICA   	
	, CASE	WHEN PROP.PRO_CODIGO_UVEM = ''7043''		THEN ''116''
			WHEN PROP.PRO_CODIGO_UVEM = ''7044''      THEN ''117''
			WHEN PROP.PRO_CODIGO_UVEM = ''7045''      THEN ''120''
			WHEN PROP.PRO_CODIGO_UVEM = ''7046''      THEN ''119''
			WHEN PROP.PRO_CODIGO_UVEM = ''7047''      THEN ''118''   
	  END											AS	RUTA
	, ''ALTA''                                        AS  ETAPA
	, TGA.DD_TGA_CODIGO						        AS  TIPO_GASTO
	, STG.DD_STG_CODIGO						        AS  SUBTIPO_GASTO

	FROM REM01.GPV_GASTOS_PROVEEDOR GPV
	
		INNER JOIN REM01.GPL_GASTOS_PRINEX_LBK   GPL		
			ON GPV.GPV_ID = GPL.GPV_ID  AND GPL.ACT_ID IS NULL  
				AND COALESCE(GPL.BORRADO, 0) = 0
				
		INNER JOIN REM01.ACT_PVE_PROVEEDOR PVE    
			ON PVE.PVE_ID = GPV.PVE_ID_EMISOR
				AND (TO_CHAR(SYSDATE,''YYYYMMDD'') 
                  BETWEEN COALESCE(TO_CHAR(PVE.PVE_FECHA_ALTA,''YYYYMMDD''),''19990101'')
                        AND COALESCE (TO_CHAR(PVE.PVE_FECHA_BAJA,''YYYYMMDD''),''29990101'') )
				AND COALESCE(PVE.BORRADO, 0) = 0 

		INNER JOIN REM01.DD_EGA_ESTADOS_GASTO EGA
			ON GPV.DD_EGA_ID = EGA.DD_EGA_ID
				AND COALESCE(EGA.BORRADO, 0) = 0
				AND EGA.DD_EGA_CODIGO=''03''
	
		INNER JOIN REM01.ACT_PRO_PROPIETARIO PROP
			ON GPV.PRO_ID = PROP.PRO_ID            
			AND COALESCE(PROP.BORRADO,0)= 0
			
		INNER JOIN REM01.DD_STG_SUBTIPOS_GASTO STG
        ON GPV.DD_STG_ID = STG.DD_STG_ID
			AND COALESCE(STG.BORRADO, 0) = 0
	
		INNER JOIN REM01.DD_TGA_TIPOS_GASTO	TGA
		ON TGA.DD_TGA_ID = STG.DD_TGA_ID
			AND TGA.DD_TGA_CODIGO NOT IN (''05'',''06'',''07'',''08'') 
			AND COALESCE(TGA.BORRADO,0) = 0
		
		INNER JOIN REM01.DD_CRA_CARTERA CAR
			ON CAR.DD_CRA_ID= PROP.DD_CRA_ID 
				AND CAR.DD_CRA_CODIGO = ''08'' 	
		
		LEFT JOIN REM01.GDE_GASTOS_DETALLE_ECONOMICO GDE
			ON GPV.GPV_ID = GDE.GPV_ID            
				AND COALESCE(GDE.BORRADO,0)= 0

		 LEFT JOIN REM01.GIC_GASTOS_INFO_CONTABILIDAD GCONT
            ON GPV.GPV_ID = GCONT.GPV_ID
                AND COALESCE(GCONT.BORRADO, 0) = 0 
	
		 LEFT JOIN (SELECT GPV_NUM_GASTO_HAYA, sum (a.gpl_importe_gasto) AS SUMA 
				FROM REM01.GPL_GASTOS_PRINEX_LBK a
				left join REM01.GPV_gastos_proveedor b
					on a.GPV_ID = b.GPV_ID
				where COALESCE(a.borrado, 0) = 0 and COALESCE(b.borrado, 0) = 0
				group by GPV_NUM_GASTO_HAYA) AUX
			ON GPV.GPV_NUM_GASTO_HAYA = AUX.GPV_NUM_GASTO_HAYA


		WHERE 1=1   
		AND GIC_FECHA_CONTABILIZACION IS NULL AND TGA.DD_TGA_CODIGO	 IN (''09'',''10'',''11'',''12'',''13'',''14'',''15'',''16'',''17'',''18'')
      
      ) A';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...Creada OK');
  
END;
/

EXIT;

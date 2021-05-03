--/*
--##########################################
--## AUTOR= Lara Pablo Flores
--## FECHA_CREACION=20210430
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13283
--## PRODUCTO=NO
--## 
--## Finalidad: Crear vista para rellenar el grid de la busqueda de trabajos
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 [HREOS-10172] Versión inicial (Creación de la vista)
--##        0.2 [HREOS-13283] Relanzar la vista para vistaLigth
--##		0.3 Area peticionaria codigo/descripcion
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE    
    ERR_NUM NUMBER; -- Numero de error
    ERR_MSG VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR); 
    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_GRID_BUSQUEDA_TRABAJOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_TRABAJOS...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_TRABAJOS';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_TRABAJOS... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_GRID_BUSQUEDA_TRABAJOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_TRABAJOS...');
    EXECUTE IMMEDIATE 'DROP VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_TRABAJOS';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_TRABAJOS... borrada OK');
  END IF;

    
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_TRABAJOS...');
  EXECUTE IMMEDIATE 'CREATE VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_TRABAJOS 
	AS          
		WITH CARTERA_TRABAJO AS (
		    SELECT DISTINCT TBJ.TBJ_ID, CRA.DD_CRA_ID, SCR.DD_SCR_ID
		    FROM '|| V_ESQUEMA ||'.ACT_TBJ TBJ
		    JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = TBJ.ACT_ID
		    JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
		    JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID
		)
          SELECT
			TBJ.TBJ_ID,
			PVE.PVE_ID,
			TBJ.TBJ_NUM_TRABAJO 							AS NUM_TRABAJO,      
			NVL(TO_CHAR(AGR.AGR_NUM_AGRUP_REM), NVL(TO_CHAR(ACT.ACT_NUM_ACTIVO), ''-''))	AS NUM_ACTIVO_AGRUPACION,
            NVL2 (AGR.AGR_NUM_AGRUP_REM, ''agrupaciones'', NVL2 (TBJ.ACT_ID, ''activo'', ''listado''))	AS TIPO_ENTIDAD,   
			TTR.DD_TTR_CODIGO 								AS TIPO_TRABAJO_CODIGO,
			TTR.DD_TTR_DESCRIPCION 					AS TIPO_TRABAJO_DESCRIPCION,
			STR.DD_STR_CODIGO 									AS SUBTIPO_TRABAJO_CODIGO,
			STR.DD_STR_DESCRIPCION 						AS SUBTIPO_TRABAJO_DESCRIPCION,
          	TBJ.TBJ_FECHA_SOLICITUD 					AS FECHA_SOLICITUD,
			EST.DD_EST_CODIGO 									AS ESTADO_TRABAJO_CODIGO,
			EST.DD_EST_DESCRIPCION 						AS ESTADO_TRABAJO_DESCRIPCION,
			IRE.DD_IRE_CODIGO,	
			IRE.DD_IRE_DESCRIPCION,	
			PVE.PVE_NOMBRE 										AS PROVEEDOR_NOMBRE,
			NVL2 (SOLIC.USU_NOMBRE,
								 INITCAP (SOLIC.USU_NOMBRE) || NVL2 (SOLIC.USU_APELLIDO1, '' '' || INITCAP (SOLIC.USU_APELLIDO1), '''') ||	NVL2 (SOLIC.USU_APELLIDO2, '' '' || INITCAP (SOLIC.USU_APELLIDO2), ''''),
								 INITCAP (PVE2.PVE_NOMBRE)
							) 																AS SOLICITANTE_NOMBRE,
 			BIELOC.BIE_LOC_COD_POST 					AS COD_POSTAL,			
            DDLOC.DD_LOC_DESCRIPCION 				AS LOCALIDAD_DESCRIPCION,
			DDPRV.DD_PRV_CODIGO							AS PROVINCIA_CODIGO,
			DDPRV.DD_PRV_DESCRIPCION 				AS PROVINCIA_DESCRIPCION,
            USU2.USU_USERNAME as TBJ_RESPONSABLE_TRABAJO,
			CRA.DD_CRA_DESCRIPCION AS CARTERA_DESCRIPCION,
			CRA.DD_CRA_CODIGO AS CARTERA_CODIGO,
			SCR.DD_SCR_DESCRIPCION AS SUBCARTERA_DESCRIPCION,
			SCR.DD_SCR_CODIGO AS SUBCARTERA_CODIGO,
			TBJ.TBJ_FECHA_CAMBIO_ESTADO AS TBJ_FECHA_CAMBIO_ESTADO
     	
     	FROM '|| V_ESQUEMA ||'.ACT_TBJ_TRABAJO TBJ			            
            INNER JOIN '|| V_ESQUEMA ||'.DD_TTR_TIPO_TRABAJO TTR							ON TTR.DD_TTR_ID = TBJ.DD_TTR_ID AND TTR.DD_TTR_FILTRAR IS NULL       
			LEFT JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR 								ON AGR.AGR_ID = TBJ.AGR_ID AND AGR.BORRADO = 0               		
            LEFT JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT                           				      		ON ACT.ACT_ID = NVL (TBJ.ACT_ID, AGR.AGR_ACT_PRINCIPAL) AND ACT.BORRADO = 0   
			INNER JOIN CARTERA_TRABAJO CRA_TBJ                            					ON CRA_TBJ.TBJ_ID = TBJ.TBJ_ID
			LEFT JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA						ON CRA.DD_CRA_ID = CRA_TBJ.DD_CRA_ID 
			LEFT JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA SCR						ON SCR.DD_SCR_ID = CRA_TBJ.DD_SCR_ID             
            LEFT JOIN '|| V_ESQUEMA_M ||'.USU_USUARIOS SOLIC 										ON SOLIC.USU_ID = TBJ.USU_ID         
			LEFT JOIN '|| V_ESQUEMA ||'.DD_STR_SUBTIPO_TRABAJO STR						ON STR.DD_STR_ID = TBJ.DD_STR_ID 
			LEFT JOIN '|| V_ESQUEMA ||'.DD_EST_ESTADO_TRABAJO EST 						ON TBJ.DD_EST_ID = EST.DD_EST_ID
			LEFT JOIN '|| V_ESQUEMA ||'.ACT_PVC_PROVEEDOR_CONTACTO PVC 	ON PVC.PVC_ID = TBJ.PVC_ID
			LEFT JOIN '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVE 								ON PVE.PVE_ID = PVC.PVE_ID
			LEFT JOIN '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVE2 								ON PVE2.PVE_ID = TBJ.MEDIADOR_ID   	

			LEFT JOIN '|| V_ESQUEMA ||'.BIE_LOCALIZACION BIELOC 									ON BIELOC.BIE_ID = ACT.BIE_ID 
			LEFT JOIN '|| V_ESQUEMA_M ||'.DD_LOC_LOCALIDAD DDLOC 						ON BIELOC.DD_LOC_ID = DDLOC.DD_LOC_ID  
			LEFT JOIN '|| V_ESQUEMA_M ||'.DD_PRV_PROVINCIA DDPRV 						ON DDLOC.DD_PRV_ID = DDPRV.DD_PRV_ID     
			LEFT JOIN '|| V_ESQUEMA ||'.DD_IRE_IDENTIFICADOR_REAM IRE					ON TBJ.DD_IRE_ID = IRE.DD_IRE_ID
            LEFT JOIN '|| V_ESQUEMA_M ||'.USU_USUARIOS USU2	 							ON USU2.USU_ID = TBJ.TBJ_RESPONSABLE_TRABAJO           
          WHERE TBJ.BORRADO = 0';

        
DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_TRABAJOS...Creada OK');
  
EXCEPTION
    WHEN OTHERS THEN
         ERR_NUM := SQLCODE;
         ERR_MSG := SQLERRM;

         DBMS_OUTPUT.PUT_LINE('KO no modificada');
         DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
         DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
         DBMS_OUTPUT.PUT_LINE(ERR_MSG);

         ROLLBACK;
         RAISE;   
		 
END;
/

EXIT;

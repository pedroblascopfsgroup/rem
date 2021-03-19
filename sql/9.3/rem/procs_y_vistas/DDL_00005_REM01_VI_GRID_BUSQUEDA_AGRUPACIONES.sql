--/*
--##########################################
--## AUTOR=Juan Beltran
--## FECHA_CREACION=20200626
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10514
--## PRODUCTO=NO
--## 
--## Finalidad: Crear vista para rellenar el grid de la busqueda de agrupaciones
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 [HREOS-10514] Versión inicial (Creación de la vista)
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(1); -- Vble. para validar la existencia de las Tablas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);


BEGIN

	SELECT COUNT(*) INTO table_count FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_GRID_BUSQUEDA_AGRUPACIONES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';
	IF table_count > 0 THEN
		DBMS_OUTPUT.PUT('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_AGRUPACIONES...');
		EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW  '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_AGRUPACIONES';
		DBMS_OUTPUT.PUT_LINE('OK'); 
	END IF;

	SELECT COUNT(*) INTO table_count FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_GRID_BUSQUEDA_AGRUPACIONES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';
	IF table_count > 0 THEN
		DBMS_OUTPUT.PUT('DROP VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_AGRUPACIONES...');
		EXECUTE IMMEDIATE 'DROP VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_AGRUPACIONES';
		DBMS_OUTPUT.PUT_LINE('OK');
	END IF;

	DBMS_OUTPUT.PUT('CREATE VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_AGRUPACIONES...');
	EXECUTE IMMEDIATE 'CREATE VIEW '|| V_ESQUEMA ||'.V_GRID_BUSQUEDA_AGRUPACIONES
		AS SELECT		    
			    AGR.AGR_ID                      			    AS AGR_ID,
			    TAG.DD_TAG_CODIGO                	AS TIPO_AGRUPACION_CODIGO,
	            TAG.DD_TAG_DESCRIPCION         	AS TIPO_AGRUPACION_DESCRIPCION,              
			    AGR.AGR_NUM_AGRUP_REM      AS NUM_AGRUP_REM,
			    AGR.AGR_NUM_AGRUP_UVEM   AS NUM_AGRUP_UVEM,
			    AGR.AGR_NOMBRE      	                AS AGR_NOMBRE,
			    AGR.AGR_DESCRIPCION	            AS AGR_DESCRIPCION,
			    AGR.AGR_FECHA_ALTA      	        AS AGR_FECHA_ALTA,
			    AGR.AGR_FECHA_BAJA         	    AS AGR_FECHA_BAJA,
			    AGR.AGR_INI_VIGENCIA                AS AGR_INI_VIGENCIA,
			    AGR.AGR_FIN_VIGENCIA           	AS AGR_FIN_VIGENCIA,
			    AGR.AGR_PUBLICADO                   	AS AGR_PUBLICADO,
			    NVL(AGR_P.ACTIVOS,0)               	AS ACTIVOS,
			    NVL(AGR_P.PUBLICADOS,0)         AS PUBLICADOS,	            
	            BIE_LOC.BIE_LOC_NOMBRE_VIA || '' ''|| BIE_LOC.BIE_LOC_NUMERO_DOMICILIO     AS DIRECCION,   
	            CRA.DD_CRA_CODIGO                   AS CARTERA_CODIGO,
	            CRA.DD_CRA_DESCRIPCION        	AS CARTERA_DESCRIPCION,
	            SCR.DD_SCR_CODIGO 					AS SUBCARTERA_CODIGO,
		        SCR.DD_SCR_DESCRIPCION 			AS SUBCARTERA_DESCRIPCION,
			    AGR.AGR_IS_FORMALIZACION    AS FORMALIZACION,              			
				ALQ.DD_TAL_CODIGO                   	AS TIPO_ALQUILER_CODIGO,
	            ALQ.DD_TAL_DESCRIPCION          AS TIPO_ALQUILER_DESCRIPCION,
	            LOC.DD_LOC_CODIGO					AS LOCALIDAD_CODIGO,
		        LOC.DD_LOC_DESCRIPCION			AS LOCALIDAD_DESCRIPCION,
		        PRV.DD_PRV_CODIGO 					AS PROVINCIA_CODIGO,
		        PRV.DD_PRV_DESCRIPCION 		AS PROVINCIA_DESCRIPCION     
	              
			    FROM '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR
			    JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG   ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0		    
	            LEFT JOIN
			      (SELECT   SUM (CASE WHEN TAGA.DD_TAG_CODIGO = ''16'' AND AGA.AGA_PRINCIPAL = 1 THEN 0 ELSE 1 END) ACTIVOS,
	                        SUM (CASE WHEN (EPA.DD_EPA_CODIGO = ''03'' AND (TAGA.DD_TAG_CODIGO <> ''16'')) 
	                                    OR (EPV.DD_EPV_CODIGO = ''03'' AND (TAGA.DD_TAG_CODIGO <> ''16''))
	                                    OR (EPA.DD_EPA_CODIGO = ''03'' AND (TAGA.DD_TAG_CODIGO = ''16'' AND AGA.AGA_PRINCIPAL = 0)) 
	                                    OR (EPV.DD_EPV_CODIGO = ''03'' AND (TAGA.DD_TAG_CODIGO = ''16'' AND AGA.AGA_PRINCIPAL = 0))
	                                  THEN 1 ELSE 0 END) PUBLICADOS,
	                        AGA.AGR_ID                        
	                FROM '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA
	                  JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGRU                   				 	ON AGRU.AGR_ID = AGA.AGR_ID AND AGRU.BORRADO = 0
	                  JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAGA                				ON TAGA.DD_TAG_ID = AGRU.DD_TAG_ID AND TAGA.BORRADO = 0                
	                  LEFT JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION ACT_APU  	ON ACT_APU.ACT_ID = AGA.ACT_ID AND ACT_APU.BORRADO = 0
	                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER EPA       			ON ACT_APU.DD_EPA_ID = EPA.DD_EPA_ID AND EPA.BORRADO = 0
	                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EPV           			ON ACT_APU.DD_EPV_ID = EPV.DD_EPV_ID AND EPV.BORRADO = 0                  
	                WHERE AGA.BORRADO = 0
	                GROUP BY AGA.AGR_ID) AGR_P   													ON AGR_P.AGR_ID = AGR.AGR_ID	              
	              LEFT JOIN (SELECT MIN(ACT_ID) ACT_ID, AGR_ID 
	                          FROM '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO
	                          WHERE BORRADO = 0
	                          GROUP BY AGR_ID) ACT_AGR 		    		  							ON ACT_AGR.AGR_ID = AGR.AGR_ID
			      LEFT JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT        		          		ON ACT.ACT_ID = ACT_AGR.ACT_ID               
	              LEFT JOIN '|| V_ESQUEMA ||'.BIE_BIEN BIE                     			  		ON BIE.BIE_ID = ACT.BIE_ID
	              LEFT JOIN '|| V_ESQUEMA ||'.BIE_LOCALIZACION BIE_LOC			ON BIE_LOC.BIE_ID = BIE.BIE_ID 
	              LEFT JOIN '|| V_ESQUEMA ||'.DD_TAL_TIPO_ALQUILER ALQ   		ON AGR.DD_TAL_ID = ALQ.DD_TAL_ID              
	              LEFT JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA             		ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
	              LEFT JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA SCR 			ON SCR.DD_SCR_ID = ACT.DD_SCR_ID
	              LEFT JOIN '|| V_ESQUEMA_M ||'.DD_LOC_LOCALIDAD LOC 			ON LOC.DD_LOC_ID = BIE_LOC.DD_LOC_ID		
	              LEFT JOIN '|| V_ESQUEMA_M ||'.DD_PRV_PROVINCIA PRV			ON PRV.DD_PRV_ID = LOC.DD_PRV_ID                          
			    WHERE AGR.BORRADO = 0';

	SELECT COUNT(*) INTO table_count FROM ALL_OBJECTS WHERE OBJECT_NAME = 'ACT_AGA_IDX1' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='INDEX';  
	IF table_count > 0 THEN
		EXECUTE IMMEDIATE 'DROP INDEX '|| V_ESQUEMA ||'.ACT_AGA_IDX1';  
	END IF;

	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX '|| V_ESQUEMA ||'.ACT_AGA_IDX1 ON '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO (AGA_ID, AGR_ID, ACT_ID, BORRADO) LOGGING NOPARALLEL';

	SELECT COUNT(*) INTO table_count FROM ALL_OBJECTS WHERE OBJECT_NAME = 'ACT_ACTIVO_IDX3' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='INDEX';  
	IF table_count > 0 THEN
		EXECUTE IMMEDIATE 'DROP INDEX '|| V_ESQUEMA ||'.ACT_ACTIVO_IDX3';  
	END IF;

	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX '|| V_ESQUEMA ||'.ACT_ACTIVO_IDX3 ON '|| V_ESQUEMA ||'.ACT_ACTIVO (ACT_ID, DD_CRA_ID, DD_EPU_ID, BORRADO) LOGGING NOPARALLEL';

	DBMS_OUTPUT.PUT_LINE('OK');
	
EXCEPTION
  	WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
    DBMS_OUTPUT.PUT_LINE(ERR_MSG);
    ROLLBACK;
    RAISE;  

END;
/
EXIT;

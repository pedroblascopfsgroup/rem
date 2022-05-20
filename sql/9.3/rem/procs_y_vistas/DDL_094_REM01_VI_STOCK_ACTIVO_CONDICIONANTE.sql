--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220426
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-1787, HREOS-2142, REMVIP-205, REMVIP-972, HREOS-8862, REMVIP-7935, HREOS-17721
--## PRODUCTO=NO
--## Finalidad: Vista Materializada exclusiva para Stock que contiene la relación de activos con los condicionantes de venta
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Correcciones para PDVs
--##		0.3 REMVIP-205 - Cambio de la forma de cálculo de el campo "Pendiente de inscripción"
--##		0.4 REMVIP-972 - Se añade código 06 al cruce con EAC 
--##		0.5 HREOS-8862 - Comprobación registros borrados de las tablas joineadas para evitar duplicados.
--##		0.6 Juan Bautista Alfonso - - REMVIP-7935 - Modificado fecha posesion para que cargue de la vista V_FECHA_POSESION_ACTIVO
--##		0.7 Alejandra García - HREOS-17721 - Modificar lógica del cálculo posesión
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_STOCK_ACTIVO_CONDICIONANTE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Vista Materializada exclusiva para Stock que contiene la relación de activos con los condicionantes de venta'; -- Vble. para los comentarios de las tablas
    
    
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
  EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||' 
	AS
  		SELECT ACT_ID,
	    CASE
		  WHEN (OCUPADO_CONTITULO = 1)
	      THEN ''03''	      
	      ELSE
	        CASE
			  WHEN (OTRO IS NOT NULL)
	          THEN ''12''
	          ELSE
	            CASE
				  WHEN (SIN_TOMA_POSESION_INICIAL = 1  and dd_cla_id = 2)
	      		  THEN ''02''	              
	              ELSE
	                CASE
					  WHEN (PROINDIVISO = 1)
	                  THEN ''06''        
	                  ELSE
	                    CASE
	                      WHEN (OCUPADO_SINTITULO = 1)
	              		  THEN ''04''
	                      ELSE
	                        CASE
							  WHEN (SIN_INFORME_APROBADO = 1  and DD_CRA_CODIGO IN (''01'', ''08''))
	                          THEN ''13''                         
	                          ELSE
	                            CASE
								  WHEN (PENDIENTE_INSCRIPCION = 1 and dd_cla_id = 2)
	                  			  THEN ''05''	                              
	                              ELSE
	                                CASE
									  WHEN (CON_CARGAS = 1)
	                                  THEN ''16''	                                  
	                                  ELSE
	                                    CASE
										  WHEN (TAPIADO = 1)
	                          			  THEN ''07''
	                                      ELSE
	                                        CASE
	                                          WHEN (RUINA = 1)
	                                          THEN ''11''
	                                          ELSE
	                                            CASE
	                                              WHEN (DIVHORIZONTAL_NOINSCRITA = 1)
	                                      		  THEN ''10''
	                                              ELSE
	                                                CASE
	                                                  WHEN (OBRANUEVA_SINDECLARAR = 1)
	                              					  THEN ''08''
	                                                  ELSE
	                                                    CASE
														  WHEN (OBRANUEVA_ENCONSTRUCCION = 1)
	                                  					  THEN ''09''
	                                                      ELSE
	                                                        CASE
	                                                          WHEN (REVISION = 1)
	                                                          THEN ''14''
	                                                          ELSE
	                                                            CASE
	                                                              WHEN (PROCEDIMIENTO_JUDICIAL = 1)
	                                                          	  THEN ''15''
	                                                              ELSE ''01''
	                                                            END
	                                                        END
	                                                    END
	                                                END
	                                            END
	                                        END
	                                    END
	                                END
	                            END
	                        END
	                    END
	                END
	            END
	        END
	    END AS ESTADO
	  FROM
	    (SELECT ACT.ACT_ID,CRA.DD_CRA_CODIGO, aba.dd_cla_id, 
		NVL2 (ETP.DD_ETP_ID, 0, NVL2 (FPA.FECHA_POSESION, 0, 1))      AS SIN_TOMA_POSESION_INICIAL,
		DECODE (SPS.SPS_OCUPADO, 1, DECODE (SPS.SPS_CON_TITULO, 1, 1, 0), 0) AS OCUPADO_CONTITULO,
		NVL2 (TIT.TIT_FECHA_INSC_REG, 0, 1)                          AS PENDIENTE_INSCRIPCION,
		NVL2 (NPA.ACT_ID, 1, 0)                                              AS PROINDIVISO,
		DECODE (SPS.SPS_ACC_TAPIADO, 1, 1, 0)                                AS TAPIADO,
		DECODE (EON.DD_EON_CODIGO, ''02'', 1, ''04'', 1, ''05'', 1, 0)       AS OBRANUEVA_SINDECLARAR,
		DECODE (EAC.DD_EAC_CODIGO, ''02'', 1, ''06'', 1, 0)                  AS OBRANUEVA_ENCONSTRUCCION,
		DECODE (REG.REG_DIV_HOR_INSCRITO, 0, 1, 0)                           AS DIVHORIZONTAL_NOINSCRITA,
		DECODE (EAC.DD_EAC_CODIGO, ''05'', 1, 0)                             AS RUINA,
		SPS.SPS_OTRO                                                         AS OTRO,
		DECODE(VEI.DD_AIC_CODIGO ,''02'' ,0 , 1) 							 AS SIN_INFORME_APROBADO,        
		0                                                                    AS REVISION,               --NO EXISTE EN REM
		0                                                                    AS PROCEDIMIENTO_JUDICIAL, --NO EXISTE EN REM
		NVL2(VCG.CON_CARGAS, VCG.CON_CARGAS, 0) 	 						 AS CON_CARGAS,
		DECODE (SPS.SPS_OCUPADO, 1, DECODE (SPS.SPS_CON_TITULO, 0, 1, 0), 0) AS OCUPADO_SINTITULO,
		DECODE (SPS.SPS_ESTADO_PORTAL_EXTERNO, 1, 1, 0)                      AS ESTADO_PORTAL_EXTERNO
	    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
	    LEFT JOIN '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO EAC ON EAC.DD_EAC_ID = ACT.DD_EAC_ID AND EAC.BORRADO = 0
	    LEFT JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID AND SPS.BORRADO = 0
	    LEFT JOIN '||V_ESQUEMA||'.V_FECHA_POSESION_ACTIVO FPA ON FPA.ACT_ID = SPS.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO_CAIXA CAIXA ON CAIXA.ACT_ID = ACT.ACT_ID AND ACT.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA||'.DD_ETP_ESTADO_POSESORIO ETP ON ETP.DD_ETP_ID = CAIXA.DD_ETP_ID AND ETP.INDICA_POSESION = 1 AND ETP.BORRADO = 0
	    LEFT JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO TIT ON TIT.ACT_ID = ACT.ACT_ID AND TIT.BORRADO = 0
	    INNER JOIN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL REG ON REG.ACT_ID = ACT.ACT_ID AND REG.BORRADO = 0
	    LEFT JOIN '||V_ESQUEMA||'.DD_EON_ESTADO_OBRA_NUEVA EON ON EON.DD_EON_ID = REG.DD_EON_ID AND EON.BORRADO = 0
	    LEFT JOIN '||V_ESQUEMA||'.V_NUM_PROPIETARIOSACTIVO NPA ON NPA.ACT_ID = ACT.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.VI_ACTIVOS_CON_CARGAS VCG ON VCG.ACT_ID = ACT.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID AND ICO.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA||'.VI_ESTADO_ACTUAL_INFMED VEI ON VEI.ICO_ID = ICO.ICO_ID
		INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
		left join '||V_ESQUEMA||'.act_aba_activo_bancario aba on aba.act_id = act.act_id AND ABA.BORRADO = 0
		where act.borrado = 0)';

 	 DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...Creada OK');
  
 	--Creamos indice
  	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.VI_STOCK_ACTIVO_COND_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_VISTA||'(ACT_ID) TABLESPACE '||V_TABLESPACE_IDX;		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VI_STOCK_ACTIVO_COND_IDX... Indice creado.');
 	 
	
	-- Creamos primary key
	V_MSQL := 'ALTER MATERIALIZED VIEW '||V_ESQUEMA||'.'||V_TEXT_VISTA||' ADD (CONSTRAINT VI_STOCK_ACTIVO_COND_PK PRIMARY KEY (ACT_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VI_STOCK_ACTIVO_COND_PK... PK creada.');
	
	
    -- Creamos comentario	
	V_MSQL := 'COMMENT ON MATERIALIZED VIEW '||V_ESQUEMA||'.'||V_TEXT_VISTA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_VISTA||'... Comentario creado.');
	
EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/

EXIT;

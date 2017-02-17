--/*
--##########################################
--## AUTOR=RAMON LLINARES
--## FECHA_CREACION=20170217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1592
--## PRODUCTO=NO
--## Finalidad: DDL
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
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Vble. número de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR);

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_ACTIVO_ESTADO_DISPONIBILIDAD' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ACTIVO_ESTADO_DISPONIBILIDAD...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_ACTIVO_ESTADO_DISPONIBILIDAD';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ACTIVO_ESTADO_DISPONIBILIDAD... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVO_ESTADO_DISPONIBILIDAD...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_ACTIVO_ESTADO_DISPONIBILIDAD
	AS
		SELECT 
  DIS.ACT_ID, 
  CASE WHEN (SIN_TOMA_POSESION_INICIAL = 1) 
    THEN ''02''
		ELSE 
            CASE
              WHEN (OCUPADO_CONTITULO = 1) 
                THEN ''03''
                ELSE 
					CASE
                      WHEN (OCUPADO_SINTITULO = 1) 
                        THEN ''04''
                        ELSE 
	                  CASE
	                    WHEN (PENDIENTE_INSCRIPCION = 1) 
	                      THEN ''05''
	                      ELSE 
	                        CASE
	                          WHEN (PROINDIVISO = 1) 
	                            THEN ''06''
	                            ELSE 
	                              CASE
	                                WHEN (TAPIADO = 1) 
	                                  THEN ''07''
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
	                                                  WHEN (DIVHORIZONTAL_NOINSCRITA = 1) 
	                                                    THEN ''10''
	                                                    ELSE
	                                                      CASE
	                                                        WHEN (RUINA = 1) 
	                                                          THEN ''11''
	                                                          ELSE
	                                                            CASE
	                                                              WHEN (OTRO IS NOT NULL) 
	                                                                THEN ''12''
	                                                                ELSE
	                                                                  CASE
	                                                                    WHEN (EN_PRECOMERCIALIZACION = 1) 
	                                                                      THEN ''13''
	                                                                      ELSE
	                                                                        CASE
	                                                                          WHEN (REVISION = 1) 
	                                                                            THEN ''14''
	                                                                            ELSE
	                                                                            CASE
	                                                                              WHEN (PROCEDIMIENTO_JUDICIAL = 1) 
	                                                                                THEN ''15''
	                                                                                ELSE
	                                                                                  CASE
	                                                                                    WHEN (CON_CARGAS = 1) 
	                                                                                      THEN ''16''
	                                                                                      ELSE  
																							CASE
																								WHEN (EPU.DD_EPU_CODIGO = ''01'') 
																									THEN ''01''
																									ELSE NULL
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
              END
	END  as ESTADO
FROM '||V_ESQUEMA||'.V_COND_DISPONIBILIDAD DIS
INNER JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = DIS.ACT_ID
LEFT JOIN DD_EPU_ESTADO_PUBLICACION EPU ON EPU.DD_EPU_ID =ACT.DD_EPU_ID';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVO_ESTADO_DISPONIBILIDAD...Creada OK');
  
END;
/

EXIT;
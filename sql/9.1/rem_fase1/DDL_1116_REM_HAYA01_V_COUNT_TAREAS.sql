--/*
--##########################################
--## AUTOR=DANIEL GUTIÉRREZ
--## FECHA_CREACION=20150229
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
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
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN
	
  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_COUNT_TAREAS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_COUNT_TAREAS...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_COUNT_TAREAS';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_COUNT_TAREAS... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_COUNT_TAREAS...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_COUNT_TAREAS ("USUARIO", "TAREAS", "ALERTAS", "AVISOS") AS
	SELECT   usu_pendientes, SUM (tareas) tareas, SUM (alertas) alertas, SUM (avisos) avisos
		    FROM (SELECT vtar.usu_pendientes, (CASE vtar.tar_codigo
		                                          WHEN ''1''
		                                             THEN 1
		                                          ELSE 0
		                                       END) tareas, 0 alertas, (CASE vtar.tar_codigo
		                                                                   WHEN ''3''
		                                                                      THEN 1
		                                                                   ELSE 0
		                                                                END) avisos
		            FROM '|| V_ESQUEMA ||'.vtar_tarea_vs_usuario vtar
		           WHERE vtar.tar_tarea_finalizada IS NULL OR vtar.tar_tarea_finalizada = 0
		          UNION ALL
		          SELECT vtar.usu_alerta, 0 tareas, (CASE vtar.tar_alerta
		                                                WHEN 1
		                                                   THEN 1
		                                                ELSE 0
		                                             END) alertas, 0 avisos
		            FROM ' || V_ESQUEMA || '.vtar_tarea_vs_usuario vtar
		           WHERE vtar.tar_tarea_finalizada IS NULL OR vtar.tar_tarea_finalizada = 0)
		GROUP BY usu_pendientes';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_COUNT_TAREAS...Creada OK');
  
END;
/

EXIT;
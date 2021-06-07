--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20210607
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-14229
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial para mostrar los campos necesarios para la caixa.
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

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_PRECIOS_VIGENTES_CAIXA' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_PRECIOS_VIGENTES_CAIXA...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_PRECIOS_VIGENTES_CAIXA';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_PRECIOS_VIGENTES_CAIXA... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_PRECIOS_VIGENTES_CAIXA' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_PRECIOS_VIGENTES_CAIXA...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_PRECIOS_VIGENTES_CAIXA';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_PRECIOS_VIGENTES_CAIXA... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_PRECIOS_VIGENTES_CAIXA...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_PRECIOS_VIGENTES_CAIXA 
	AS
		SELECT
			ACT.ACT_ID ||  VAL.VAL_ID  || TPC.DD_TPC_CODIGO AS ID,
	 		VAL.VAL_ID,
			ACT.ACT_ID,
			VAL.DD_TPC_ID,
			TPC.DD_TPC_CODIGO,
			TPC.DD_TPC_DESCRIPCION,
			TPC.DD_TPC_ORDEN,
			VAL.VAL_IMPORTE,
	        VAL.VAL_FECHA_APROBACION,
	        VAL.VAL_FECHA_CARGA,
	        VAL.VAL_FECHA_INICIO,
	        VAL.VAL_FECHA_FIN,
	        CASE WHEN 
                GESTOR.USU_APELLIDO1 IS NOT NULL AND GESTOR.USU_APELLIDO2 IS NOT NULL
            THEN 
                INITCAP(GESTOR.USU_APELLIDO1) || '' '' || INITCAP(GESTOR.USU_APELLIDO2) || '', '' || INITCAP(GESTOR.USU_NOMBRE)
            ELSE 
                CASE WHEN 
                    GESTOR.USU_APELLIDO1 IS NOT NULL
                THEN
                    INITCAP(GESTOR.USU_APELLIDO1) || '', '' || INITCAP(GESTOR.USU_NOMBRE)
                ELSE
                    INITCAP(GESTOR.USU_NOMBRE)
                END
            END AS GESTOR_PRECIOS,
			VAL.VAL_OBSERVACIONES  
		FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC
		CROSS JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
		LEFT JOIN '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND VAL.ACT_ID = ACT.ACT_ID AND VAL.BORRADO=0
		LEFT JOIN ' || V_ESQUEMA_MASTER || '.USU_USUARIOS GESTOR ON GESTOR.USU_ID = VAL.USU_ID
		WHERE DD_TPC_TIPO = ''P'' 
    AND TPC.DD_TPC_CODIGO <> ''04''
    AND TPC.BORRADO = 0
    AND ACT.BORRADO = 0';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_PRECIOS_VIGENTES_CAIXA...Creada OK');
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

EXIT;

--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20170227
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4233
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial DANIEL GUTIERREZ
--## 		0.2 JOSEVI: Vista usada para mostrar PROINDIVISO en vista V_COND_DISPONIBILIDAD.
--##             Nuevas condiciones: Varios propietarios activo o 1 propietario con menos de 100%
--##		0.3 Guillermo : Se añade el campo de borrado sobre la tabla act_pac para que no saque 
--##						campos borrados 
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

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_NUM_PROPIETARIOSACTIVO' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_NUM_PROPIETARIOSACTIVO...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_NUM_PROPIETARIOSACTIVO';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_NUM_PROPIETARIOSACTIVO... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_NUM_PROPIETARIOSACTIVO...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_NUM_PROPIETARIOSACTIVO (ACT_ID, NUM)
	AS
    select PAC.ACT_ID, NPROP.NUM_PROPIETARIOS AS NUM from (  
          select
            PAC1.ACT_ID idactivo,
          COUNT(*) num_propietarios
          FROM '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO PAC1
          WHERE PAC1.BORRADO = 0
          GROUP BY PAC1.ACT_ID
    ) nprop
    INNER JOIN '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO PAC ON NPROP.idactivo = PAC.ACT_ID
    inner join '|| V_ESQUEMA ||'.act_activo act
    on act.act_id = pac.act_id
    WHERE
    act.borrado = 0 
    and (
    NPROP.NUM_PROPIETARIOS > 1
    OR (NPROP.NUM_PROPIETARIOS = 1 AND PAC.PAC_PORC_PROPIEDAD < 100)
    )
    GROUP BY PAC.ACT_ID, NPROP.NUM_PROPIETARIOS';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_NUM_PROPIETARIOSACTIVO...Creada OK');
  
END;
/

EXIT;

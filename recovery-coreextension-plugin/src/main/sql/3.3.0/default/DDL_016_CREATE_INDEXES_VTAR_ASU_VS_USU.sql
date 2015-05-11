--/*
--##########################################
--## Author: Gonzalo
--## Mejora de la búsqueda de tareas pendientes, creación de índices
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  -- CREACION DE INDICES
  DBMS_OUTPUT.PUT_LINE('INICIO CREATE INDEX '|| V_ESQUEMA ||'.IDX_TAR_ASU_VS_USU_ASU...');
  SELECT COUNT(*) INTO CUENTA FROM ALL_INDEXES WHERE INDEX_NAME = 'IDX_TAR_ASU_VS_USU_ASU' AND TABLE_OWNER=V_ESQUEMA AND TABLE_NAME='VTAR_ASU_VS_USU';    
  IF CUENTA=0 THEN
	  EXECUTE IMMEDIATE 'CREATE INDEX '|| V_ESQUEMA ||'.IDX_TAR_ASU_VS_USU_ASU ON '|| V_ESQUEMA ||'.VTAR_ASU_VS_USU(ASU_ID)';  
	  DBMS_OUTPUT.PUT_LINE('CREATE INDEX '|| V_ESQUEMA ||'.IDX_TAR_ASU_VS_USU_ASU...Creado');
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('INICIO CREATE INDEX '|| V_ESQUEMA ||'.IDX_TAR_ASU_VS_USU_USU...');
  SELECT COUNT(*) INTO CUENTA FROM ALL_INDEXES WHERE INDEX_NAME = 'IDX_TAR_ASU_VS_USU_USU' AND TABLE_OWNER=V_ESQUEMA AND TABLE_NAME='VTAR_ASU_VS_USU';    
  IF CUENTA=0 THEN
	  EXECUTE IMMEDIATE 'CREATE INDEX '|| V_ESQUEMA ||'.IDX_TAR_ASU_VS_USU_USU ON '|| V_ESQUEMA ||'.VTAR_ASU_VS_USU(USU_ID)';  
	  DBMS_OUTPUT.PUT_LINE('CREATE INDEX '|| V_ESQUEMA ||'.IDX_TAR_ASU_VS_USU_USU...Creado');
  END IF;

END;
/

EXIT;

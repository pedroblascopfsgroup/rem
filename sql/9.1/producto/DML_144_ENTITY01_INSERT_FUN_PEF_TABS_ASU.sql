--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-671
--## PRODUCTO=NO
--## Finalidad: DML
--## 
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

	-- Se van a insertar los roles creados en DML_143_ENTITY01_INSERT_ROLES_VER_TABS.sql
	-- a todos los perfiles existentes. 

    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en FUN_PEF
    TYPE ROL_ARRAY IS VARRAY(11) OF VARCHAR2(128);
    V_FUNCION_ROL ROL_ARRAY := ROL_ARRAY(
     	'TAB_ASUNTO_TITULOS', 'TAB_ASUNTO_ACUERDOS', 'TAB_ASUNTO_ADJUNTOS',
      	'TAB_ASUNTO_CONVENIOS','TAB_ASUNTO_FASECOMUN', 'TAB_PRC_ADJUNTO',
      	'TAB_PRC_DECISION',  'TAB_PRC_CONTRATO',
      	'TAB_BIEN_PROCEDIMIENTOS', 'TAB_BIEN_DATOSENTIDAD', 'TAB_BIEN_RELACIONES'
    );
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('******** FUN_PEF ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_PEF... Comprobaciones previas'); 

    FOR I IN V_FUNCION_ROL.FIRST .. V_FUNCION_ROL.LAST
      LOOP
   		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||TRIM(V_FUNCION_ROL(I))||''')';

	    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
		-- Se interarán las funciones a todos los perfiles que no los tengan ya asociados, y que no sean el perfil PROCUCAJAMAR
		-- De esta forma, si se crear perfiles futuros, se puede relanzar y seguirán sin meterse en el perfil PROCUCAJAMAR
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
					' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT FUN.FUN_ID, PEF.PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''PROD-671'', SYSDATE, 0' ||
					' FROM '||V_ESQUEMA||'.PEF_PERFILES PEF, '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN' ||
					' WHERE FUN.FUN_DESCRIPCION = '''||TRIM(V_FUNCION_ROL(I))||''' '||
					' AND PEF.PEF_CODIGO <> ''PROCUCAJAMAR'' '||
					' AND PEF.PEF_ID NOT IN (SELECT PEF_ID FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID=(SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||TRIM(V_FUNCION_ROL(I))||'''))';
		EXECUTE IMMEDIATE V_MSQL;
		 DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.FUN_PEF -- FUNCION: '||TRIM(V_FUNCION_ROL(I))||'');

     END LOOP;
    COMMIT;
   

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
    
END;
/
EXIT;

--/*
--##########################################
--## AUTOR=JOSEVI
--## FECHA_CREACION=20151016
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.16-bk
--## INCIDENCIA_LINK=BKREC-943
--## PRODUCTO=SI
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    CUENTA NUMBER(10);  -- Vble. auxiliar para ver si existe un registro

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := 'SELECT 
                (SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.fun_funciones fun1 WHERE fun1.fun_descripcion IN (''MENU-LIST-EXP-ALL-USERS'',''MENU-LIST-EXP-RECOBRO-ALL-USERS''))
                +
                (SELECT COUNT(*) FROM '||V_ESQUEMA||'.pef_perfiles pef1 WHERE pef1.pef_codigo IN (''FPFSRADMIN'',''FPFSRINT'',''FPFSREXT'',''FPFSRSOPORT'',''FPFSRUSUREC'')) AS SUMA
                FROM DUAL';
    EXECUTE IMMEDIATE V_SQL INTO CUENTA;
	

	--/**
    -- * Comprobar que existen las funciones y perfiles necesarios antes de hacer nada
	---- * Eliminar permisos actuales sobre ver MENU > EXPEDIENTES 
    -- * y sobre ver MENU > EXPEDIENTES RECOBRO
	-- **/   
	IF CUENTA < 7 THEN

      DBMS_OUTPUT.PUT_LINE('[ERROR] No se ha podido realizar la operación de dar permisos para visualizar MENU > EXPEDIENTES');
      DBMS_OUTPUT.PUT_LINE('[ERROR] CAUSA: Revise la existencia de las funciones: ''MENU-LIST-EXP-ALL-USERS'',  ''MENU-LIST-EXP-RECOBRO-ALL-USERS'' y los codigos de perfiles: ''FPFSRADMIN'',''FPFSRINT'',''FPFSREXT'',''FPFSRSOPORT'',''FPFSRUSUREC'' ');
  
  ELSE
	

    EXECUTE IMMEDIATE 
        'DELETE '||V_ESQUEMA||'.fun_pef fp
            WHERE fp.fp_id IN
              (SELECT fp1.fp_id
              FROM '||V_ESQUEMA||'.fun_pef fp1
              INNER JOIN '||V_ESQUEMA_M||'.fun_funciones fun1
              ON fp1.fun_id = fun1.fun_id
              INNER JOIN '||V_ESQUEMA||'.pef_perfiles pef1
              ON fp1.pef_id = pef1.pef_id
              WHERE
                fun1.fun_descripcion = ''MENU-LIST-EXP''
              )';
    DBMS_OUTPUT.PUT_LINE('[INFO] Permisos sobre MENU > EXPEDIENTES eliminados.');

    EXECUTE IMMEDIATE 
        'DELETE '||V_ESQUEMA||'.fun_pef fp
            WHERE fp.fp_id IN
              (SELECT fp1.fp_id
              FROM '||V_ESQUEMA||'.fun_pef fp1
              INNER JOIN '||V_ESQUEMA_M||'.fun_funciones fun1
              ON fp1.fun_id = fun1.fun_id
              INNER JOIN '||V_ESQUEMA||'.pef_perfiles pef1
              ON fp1.pef_id = pef1.pef_id
              WHERE
                fun1.fun_descripcion = ''MENU-LIST-EXP-ALL-USERS''
              )';
	  DBMS_OUTPUT.PUT_LINE('[INFO] Permisos sobre MENU > EXPEDIENTES Dinamico, eliminados.');

      EXECUTE IMMEDIATE 
        'DELETE '||V_ESQUEMA||'.fun_pef fp
            WHERE fp.fp_id IN
              (SELECT fp1.fp_id
              FROM '||V_ESQUEMA||'.fun_pef fp1
              INNER JOIN '||V_ESQUEMA_M||'.fun_funciones fun1
              ON fp1.fun_id = fun1.fun_id
              INNER JOIN '||V_ESQUEMA||'.pef_perfiles pef1
              ON fp1.pef_id = pef1.pef_id
              WHERE
                fun1.fun_descripcion = ''MENU-LIST-EXP-RECOBRO-ALL-USERS''
              )';
      DBMS_OUTPUT.PUT_LINE('[INFO] Permisos sobre MENU > EXPEDIENTES RECOBRO eliminados.');



    --/**
    -- * Se restauran los permisos para visualizar MENU > EXPEDIENTES
    -- **/
    EXECUTE IMMEDIATE 
        'INSERT
            INTO '||V_ESQUEMA||'.fun_pef
              (
                fun_id,
                pef_id,
                fp_id,
                version,
                usuariocrear,
                fechacrear
              )
            SELECT
              (SELECT fun1.fun_id
              FROM '||V_ESQUEMA_M||'.fun_funciones fun1
              WHERE fun1.fun_descripcion = ''MENU-LIST-EXP''
              ) AS fun_id ,
              pef.pef_id ,
              ' || V_ESQUEMA || '.S_FUN_PEF.nextval AS FP_ID ,
              ''0''               AS VERSION ,
              ''BKREC-943''       AS USUARIOCREAR ,
              sysdate           AS FECHACREAR
            FROM pef_perfiles pef
            WHERE pef.pef_codigo IN (''FPFSRADMIN'',''FPFSRINT'',''FPFSREXT'',''FPFSRSOPORT'',''FPFSRUSUREC'')';

    DBMS_OUTPUT.PUT_LINE('[INFO] Permisos sobre MENU > EXPEDIENTES Dinamico, creados.');


    --/**
    -- * Se restauran los permisos para visualizar MENU > EXPEDIENTES Dinamico
    -- **/
    EXECUTE IMMEDIATE 
        'INSERT
            INTO '||V_ESQUEMA||'.fun_pef
              (
                fun_id,
                pef_id,
                fp_id,
                version,
                usuariocrear,
                fechacrear
              )
            SELECT
              (SELECT fun1.fun_id
              FROM '||V_ESQUEMA_M||'.fun_funciones fun1
              WHERE fun1.fun_descripcion = ''MENU-LIST-EXP-ALL-USERS''
              ) AS fun_id ,
              pef.pef_id ,
              ' || V_ESQUEMA || '.S_FUN_PEF.nextval AS FP_ID ,
              ''0''               AS VERSION ,
              ''BKREC-943''       AS USUARIOCREAR ,
              sysdate           AS FECHACREAR
            FROM pef_perfiles pef
            WHERE pef.pef_codigo IN (''FPFSRADMIN'',''FPFSRINT'',''FPFSREXT'',''FPFSRSOPORT'',''FPFSRUSUREC'')';

    DBMS_OUTPUT.PUT_LINE('[INFO] Permisos sobre MENU > EXPEDIENTES Dinamico, creados.');

  END IF;


    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[COMMIT]');

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('[ROLLBACK]');
    RAISE;   
END;
/

EXIT;

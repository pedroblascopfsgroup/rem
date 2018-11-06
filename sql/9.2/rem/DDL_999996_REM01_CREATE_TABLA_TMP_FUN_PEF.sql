--/*
--######################################### 
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20181106
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4476
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##      
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 	-- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';	-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para almacenar la sentencia.    
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.

  V_TABLA_TMP VARCHAR2(30 CHAR) := 'TMP_FUN_PEF';  -- Tabla objetivo

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

--    ######################################
--    ########   CREACION TABLA    #########
--    ######################################

    DBMS_OUTPUT.PUT_LINE('  [INFO] '||V_ESQUEMA||'.'||V_TABLA_TMP||'... COMPROBACIONES PREVIAS');   

    -- Verificar si la tabla ya existe
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA_TMP||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
    IF V_NUM_TABLAS = 1 THEN
      DBMS_OUTPUT.PUT_LINE('  [INFO] ' ||V_ESQUEMA|| '.'||V_TABLA_TMP||'... YA EXISTE. SE BORRARÁ.');
      EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA_TMP||' CASCADE CONSTRAINTS';    
    END IF;

    -- Creamos la tabla
    DBMS_OUTPUT.PUT_LINE('  [INFO] CREANDO ' ||V_ESQUEMA|| '.'||V_TABLA_TMP||'...');

    EXECUTE IMMEDIATE  '
      CREATE TABLE ' ||V_ESQUEMA||'.'||V_TABLA_TMP||'
      (
		  FUNCION VARCHAR2(128 CHAR) 
		, HAYAGESTADM VARCHAR2(1 CHAR) 
		, HAYASUPADM VARCHAR2(1 CHAR) 
		, HAYAGESACT VARCHAR2(1 CHAR) 
		, HAYASUPACT VARCHAR2(1 CHAR) 
		, HAYACAL VARCHAR2(1 CHAR) 
		, HAYASUPCAL VARCHAR2(1 CHAR) 
		, HAYAGESTPREC VARCHAR2(1 CHAR) 
		, HAYASUPPREC VARCHAR2(1 CHAR) 
		, HAYAGESTPUBL VARCHAR2(1 CHAR) 
		, HAYASUPPUBL VARCHAR2(1 CHAR) 
		, HAYAFSV VARCHAR2(1 CHAR) 
		, HAYAGBOINM VARCHAR2(1 CHAR) 
		, HAYASBOINM VARCHAR2(1 CHAR) 
		, HAYAGBOFIN VARCHAR2(1 CHAR) 
		, HAYASBOFIN VARCHAR2(1 CHAR) 
		, HAYAGESTCOMRET VARCHAR2(1 CHAR) 
		, HAYASUPCOMRET VARCHAR2(1 CHAR) 
		, HAYAGESTCOMSIN VARCHAR2(1 CHAR) 
		, HAYASUPCOMSIN VARCHAR2(1 CHAR) 
		, HAYAGESTFORM VARCHAR2(1 CHAR) 
		, HAYASUPFORM VARCHAR2(1 CHAR) 
		, HAYAADM VARCHAR2(1 CHAR) 
		, HAYASADM VARCHAR2(1 CHAR) 
		, HAYALLA VARCHAR2(1 CHAR) 
		, HAYASLLA VARCHAR2(1 CHAR) 
		, PERFGCCBANKIA VARCHAR2(1 CHAR) 
		, GESTOADM VARCHAR2(1 CHAR) 
		, GESTIAFORM VARCHAR2(1 CHAR) 
		, HAYAGESTADMT VARCHAR2(1 CHAR) 
		, GESTOCED VARCHAR2(1 CHAR) 
		, GESTOPLUS VARCHAR2(1 CHAR) 
		, GESTOPDV VARCHAR2(1 CHAR) 
		, HAYAPROV VARCHAR2(1 CHAR) 
		, HAYACERTI VARCHAR2(1 CHAR) 
		, HAYACONSU VARCHAR2(1 CHAR) 
		, HAYASUPER VARCHAR2(1 CHAR) 
		, HAYAGESTCOM VARCHAR2(1 CHAR) 
		, HAYASUPCOM VARCHAR2(1 CHAR) 
		, HAYAGOLDTREE VARCHAR2(1 CHAR) 
		, FVDNEGOCIO VARCHAR2(1 CHAR) 
		, FVDBACKOFERTA VARCHAR2(1 CHAR) 
		, FVDBACKVENTA VARCHAR2(1 CHAR) 
		, SUPFVD VARCHAR2(1 CHAR) 
		, GESRES VARCHAR2(1 CHAR) 
		, SUPRES VARCHAR2(1 CHAR) 
		, GESMIN VARCHAR2(1 CHAR) 
		, SUPMIN VARCHAR2(1 CHAR) 
		, GESTSUE VARCHAR2(1 CHAR) 
		, GESTEDI VARCHAR2(1 CHAR) 
		, VALORACIONES VARCHAR2(1 CHAR) 
		, GESPROV VARCHAR2(1 CHAR) 
		, PERFGCCLIBERBANK VARCHAR2(1 CHAR) 
		, PMSVVC VARCHAR2(1 CHAR)
      )
      LOGGING 
      NOCOMPRESS 
      NOCACHE
      NOPARALLEL
      NOMONITORING
    '
    ;

    DBMS_OUTPUT.PUT_LINE('  [INFO] ' ||V_ESQUEMA||'.'||V_TABLA_TMP||'... TABLA CREADA.');

    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(SQLERRM);
    ROLLBACK;
    RAISE;

END;

/

EXIT
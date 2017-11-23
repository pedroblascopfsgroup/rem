--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171123
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-3296
--## PRODUCTO=NO
--## 
--## Finalidad: Tabla para cañonazo
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

  ERR_NUM NUMBER;-- Numero de errores
  ERR_MSG VARCHAR2(2048);-- Mensaje de error
  V_EXISTE NUMBER(2);

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Creación tabla para reasignación de gestores.');
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG2_GEO_GESTORES_OFERTAS_REP'' AND OWNER = ''REM01''' INTO V_EXISTE;
    IF V_EXISTE = 1 THEN
    	DBMS_OUTPUT.PUT_LINE('TABLA YA EXISTENTE');
    	EXECUTE IMMEDIATE 'DROP TABLE REM01.MIG2_GEO_GESTORES_OFERTAS_REP PURGE';
    END IF;

	EXECUTE IMMEDIATE '  
        CREATE TABLE "REM01"."MIG2_GEO_GESTORES_OFERTAS_REP" 
	   ("GEO_COD_OFERTA" NUMBER(16,0) NOT NULL ENABLE, 
		"GEO_GESTOR_ACTIVO" VARCHAR2(20 CHAR) NOT NULL ENABLE, 
		"GEO_TIPO_GESTOR" VARCHAR2(20 CHAR) NOT NULL ENABLE
	   )';
	DBMS_OUTPUT.PUT_LINE('TABLA CREADA');

    DBMS_OUTPUT.PUT_LINE('[INICIO] Tabla creada para reasignación de gestores.');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT
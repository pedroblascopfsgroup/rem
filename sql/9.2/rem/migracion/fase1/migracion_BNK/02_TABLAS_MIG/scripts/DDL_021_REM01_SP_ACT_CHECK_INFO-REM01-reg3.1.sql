--/*
--##########################################
--## AUTOR=CLV
--## FECHA_CREACION=20160907
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: ACT_CHECK_INFO
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

create or replace FUNCTION ACT_CHECK_INFO (P_ACT_ID IN REM01.ACT_ACTIVO.ACT_ID%TYPE) RETURN NUMBER AUTHID CURRENT_USER IS

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'ESQUEMA_MASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_REGS NUMBER(16);
    V_NUM_REGS2 NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    TYPE condCurTyp IS REF CURSOR;
    v_cond_cursor    condCurTyp;
    
    v_stmt_cond   VARCHAR2(4000 CHAR);

	  V_USUARIO VARCHAR2(50 CHAR) := 'HREOS_758';
    V_FECHA    VARCHAR2(50 CHAR) := SYSDATE;
    
    vDD_CIP_TEXTO                       REM01.DD_CIP_CONDIC_IND_PRECIOS.DD_CIP_TEXTO%TYPE;
    Aux_DD_CIP_TEXTO                 VARCHAR2(32000 CHAR);
    nDD_TPP_ID                             REM01.CCP_CARTERA_CONDIC_PRECIOS.DD_TPP_ID%TYPE;
    nDD_CRA_ID                            REM01.ACT_ACTIVO.DD_CRA_ID%TYPE;
    vDD_TPP_CODIGO                    REM01.DD_TPP_TIPO_PROP_PRECIO.DD_TPP_ID%TYPE; 
    vACT_FECHA_IND                     VARCHAR2(50 CHAR);
    nCount                                    NUMBER;
    
BEGIN

  --<Condiciones
  v_stmt_cond := '
      SELECT DD_CIP.DD_CIP_TEXTO
        FROM '||V_ESQUEMA||'.DD_CIP_CONDIC_IND_PRECIOS DD_CIP
      WHERE DD_CIP.BORRADO = 0 
          AND DD_CIP.DD_CIP_TEXTO IS NOT NULL 
          AND DD_CIP.DD_CIP_CODIGO = ''04'' ' /*04 - Checking de información concluido*/
          ;
  --Fin condiciones>

  EXECUTE IMMEDIATE v_stmt_cond INTO  vDD_CIP_TEXTO;

  v_stmt_cond := ' SELECT COUNT(1)  
                             FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT '
                              ||vDD_CIP_TEXTO ||'
                               AND ACT.ACT_ID = '|| P_ACT_ID;

  EXECUTE IMMEDIATE v_stmt_cond INTO nCount;
  
  IF nCount > 0 THEN
     RETURN (1);  
  ELSE
     RETURN (0);  
  END IF;
                          
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(ERR_MSG);
	        RETURN (0);
          ROLLBACK;
          RAISE;
END;
/

EXIT

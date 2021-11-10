--/*
--#########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20211019
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15507
--## PRODUCTO=NO
--## 
--## Finalidad: Update campos estado y estado bc
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
  V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_TABLA VARCHAR2(50 CHAR):= 'DD_EEC_EST_EXP_COMERCIAL';
  V_TABLA_BC VARCHAR2(50 CHAR):= 'DD_EEB_ESTADO_EXPEDIENTE_BC';
  V_COUNT NUMBER(16); -- Vble. para contar.
  V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-15507';

BEGIN

  V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_BC||' SET 
          USUARIOMODIFICAR = '''||V_USUARIO||'''
        , FECHAMODIFICAR = SYSDATE
        , DD_EEB_DESCRIPCION = ''Pte. aprobacion garantías adicionales BC''
		    , DD_EEB_DESCRIPCION_LARGA = ''Pte. aprobacion garantías adicionales BC''
        WHERE DD_EEB_CODIGO = ''038'' 
        AND BORRADO = 0
        ';
        DBMS_OUTPUT.PUT_LINE('Tabla '||V_TABLA_BC||' modificada correctamente');
  EXECUTE IMMEDIATE V_SQL;

  V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
          USUARIOMODIFICAR = '''||V_USUARIO||'''
        , FECHAMODIFICAR = SYSDATE
        , DD_EEC_DESCRIPCION = ''Pendiente garantías adicionales''
		    , DD_EEC_DESCRIPCION_LARGA = ''Pendiente garantías adicionales''
        WHERE DD_EEC_CODIGO = ''50''
        AND BORRADO = 0
        ';
        DBMS_OUTPUT.PUT_LINE('Tabla '||V_TABLA||' modificada correctamente');
  EXECUTE IMMEDIATE V_SQL;
 
    
  COMMIT;    

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
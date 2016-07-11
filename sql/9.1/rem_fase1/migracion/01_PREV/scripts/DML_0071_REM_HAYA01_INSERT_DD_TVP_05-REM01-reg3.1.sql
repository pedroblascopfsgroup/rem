--/*
--######################################### 
--## AUTOR=David González
--## FECHA_CREACION=20160229
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-67B
--## PRODUCTO=NO
--## 
--## Finalidad: Insertar registro en DD_TVP_TIPO_VPO
--##    										
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(20 CHAR) := 'REMMASTER';
DESCRIPCION VARCHAR2(50 CHAR);
V_TABLA VARCHAR2(30 CHAR) := 'DD_TVP_TIPO_VPO';
V_SENTENCIA VARCHAR2(1000 CHAR);
V_NUM NUMBER(10);

BEGIN

  V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_TVP_CODIGO = ''05''';
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_NUM;
  
  IF V_NUM = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL VALOR ''05'' EN LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'. SE PROCEDE A INSERTAR.');
    
    V_SENTENCIA := '
    INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
    DD_TVP_ID,
    DD_TVP_CODIGO,
    DD_TVP_DESCRIPCION,
    DD_TVP_DESCRIPCION_LARGA,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
    ) 
    SELECT
    '||V_ESQUEMA||'.S_DD_TVP_TIPO_VPO.NEXTVAL                    		DD_TVP_ID,
    ''05''                                                          	DD_TVP_CODIGO,
    ''No informado''											DD_TVP_DESCRIPCION,
    ''No informado''											DD_TVP_DESCRIPCION_LARGA,
    ''0''																VERSION,
    ''MIG''																USUARIOCREAR,
    SYSDATE																FECHACREAR,
    0																	BORRADO
    FROM DUAL
    '
    ;
    
    EXECUTE IMMEDIATE V_SENTENCIA;
    
    COMMIT;
    
  V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_TVP_CODIGO = ''05''';
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_NUM;
  
    IF V_NUM = 0 THEN
  
      DBMS_OUTPUT.PUT_LINE('[ERROR] NO SE HA PODIDO REALIZAR LA INSERCIÓN.');
  
    ELSE
  
      DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO INSERTADO CORRECTAMENTE.');
  
    END IF;
  
  ELSE
  
  DBMS_OUTPUT.PUT_LINE('[INFO] EL VALOR ''05'' EN LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTE.');
  
  END IF;
  
  EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;

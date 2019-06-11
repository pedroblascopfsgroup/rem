--/*
--##########################################
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20190125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.4
--## INCIDENCIA_LINK=HREOS-5227
--## PRODUCTO=NO
--##
--## Finalidad: Insert en DD_ENO_ENTIDAD_ORIGEN
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

    --ESQUEMAS
    V_ESQUEMA           VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M         VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	
    --UTILES
    V_MSQL              VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_NUM               NUMBER(16);

    --VALORES
    V_TABLA             VARCHAR2(30 CHAR):= 'DD_ENO_ENTIDAD_ORIGEN';
    CAMPO_CODIGO        VARCHAR2(30 CHAR):= 'DD_ENO_CODIGO';
    VALOR_CODIGO        VARCHAR2(20 CHAR):= '52';
    VALOR_DESCRIPCION   VARCHAR2(100 CHAR):= 'SANTANDER';
    USUARIOCREAR        VARCHAR2(50 CHAR):= 'HREOS-5227';

    --ADICIONALES SEGUN NECESIDAD
    VALOR_ADICIONAL     VARCHAR2(100 CHAR):= 'A39000013';

BEGIN

    EXECUTE IMMEDIATE '
    SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' 
    ' INTO V_NUM;

    IF V_NUM > 0 THEN

      DBMS_OUTPUT.PUT_LINE('[INICIO] Proceso de inserción en '||V_TABLA||'.');

      EXECUTE IMMEDIATE '
      SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE '||CAMPO_CODIGO||' = '''||VALOR_CODIGO||''' AND BORRADO = 0
      ' INTO V_NUM;

      IF V_NUM > 0 THEN

        --YA EXISTE
        DBMS_OUTPUT.PUT_LINE('[INFO] '||VALOR_CODIGO||' YA EXISTE en '||V_TABLA||'.');

      ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO] '||VALOR_CODIGO||' NO EXISTE en '||V_TABLA||' ó bien está borrado.');

        --INSERTAMOS
        --(SUSTITUIR POR LOS CAMPOS DE NUESTRA TABLA, PARA LUEGO INSERTAR EN EL MISMO ORDEN, PARA EL EJEMPLO USAMOS DD_ENO_ENTIDAD_ORIGEN)
        --DD_ENO_ID,DD_ENO_CODIGO,DD_ENO_PADRE_ID,DD_ENO_CIF,DD_ENO_DESCRIPCION,DD_ENO_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO
        EXECUTE IMMEDIATE '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
        SELECT
        '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,
        '''||VALOR_CODIGO||''',
        NULL,
        '''||VALOR_ADICIONAL||''',
        '''||VALOR_DESCRIPCION||''',
        '''||VALOR_DESCRIPCION||''',
        0,
        '''||USUARIOCREAR||''',
        SYSDATE,
        NULL,
        NULL,
        NULL,
        NULL,
        0
        FROM DUAL
        ';

        IF SQL%ROWCOUNT > 0 THEN DBMS_OUTPUT.PUT_LINE('[INFO] '||VALOR_CODIGO||' insertado en '||V_TABLA||'.'); ELSE DBMS_OUTPUT.PUT_LINE('[WARNING] '||VALOR_CODIGO||' NO SE HA PODIDO INSERTAR en '||V_TABLA||'.'); END IF;
        
      END IF;

      COMMIT;

      DBMS_OUTPUT.PUT_LINE('[FIN] Proceso de inserción en '||V_TABLA||' finalizado.');

    ELSE

      DBMS_OUTPUT.PUT_LINE('[ERROR] '||V_TABLA||' NO EXISTE.');

    END IF;

EXCEPTION
     WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(SQLERRM);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

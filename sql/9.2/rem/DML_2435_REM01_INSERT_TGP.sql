--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20190709
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7039
--## PRODUCTO=NO
--## Finalidad: Inserción regisro en TGP_TIPO_GESTOR_PROPIEDAD
--##           
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial 
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
    V_MSQL VARCHAR2(4000 CHAR);
    V_NUM NUMBER(16);

BEGIN
   V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TGP_TIPO_GESTOR_PROPIEDAD
        WHERE DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GPM'')';

    EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    IF V_NUM < 1 THEN
        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TGP_TIPO_GESTOR_PROPIEDAD(TGP_ID, DD_TGE_ID, TGP_CLAVE, TGP_VALOR, USUARIOCREAR, FECHACREAR)
            VALUES('||V_ESQUEMA||'.S_TGP_TIPO_GESTOR_PROPIEDAD.NEXTVAL, (SELECT DD_TGE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GPM''), 
            ''DES_VALIDOS'', ''GPM'', ''HREOS-7039'', SYSDATE);';

        DBMS_OUTPUT.PUT_LINE(' [INFO] INSERTADO '||SQL%ROWCOUNT||' REGISTRO(S) PARA EL TIPO DE GESTOR GPM EN TGP');
    ELSE
        DBMS_OUTPUT.PUT_LINE(' [INFO] YA EXISTE EL REGISTRO QUE SE ESTA INTENTANDO INSERTAR');
    END IF;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion: ' || TO_CHAR(SQLCODE) || CHR(10));
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        ROLLBACK;
        RAISE;
END SP_AGA_ASIGNA_GESTOR_ACTIVO_V3;
/
EXIT;

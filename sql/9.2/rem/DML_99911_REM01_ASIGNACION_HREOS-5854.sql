--/*
--#########################################
--## AUTOR=Mariam Lliso
--## FECHA_CREACION=20190314
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=HREOS-5854
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 HREOS-5854
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_ESQUEMA VARCHAR2(50 CHAR) := '#ESQUEMA#';
    V_USU_USER VARCHAR2(200);
    V_USU_MAIL VARCHAR2(200);
    V_USU_GRUP VARCHAR2(200);
    V_DES_DESP VARCHAR2(200);
    V_COD_TDES VARCHAR2(200);
    V_TDE_DESC VARCHAR2(200);
    V_COD_PERF VARCHAR2(200);
    V_PEF_DESC VARCHAR2(200);
    V_COD_GEST VARCHAR2(200);
    V_GES_DESC VARCHAR2(200);
    V_COD_CART VARCHAR2(200);
    V_CNF_GEST NUMBER;
    PL_OUTPUT VARCHAR2(32000 CHAR);
    SP_OUTPUT VARCHAR2(32000 CHAR);
    TYPE T_LISTA IS TABLE OF VARCHAR2(240 CHAR);
    TYPE T_ARRAY IS TABLE OF T_LISTA;
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-5874';
    V_ARRAY T_ARRAY := T_ARRAY (
        T_LISTA ('gruforadmto', NULL, NULL, 'GFORMADM', 'GFORMADM', 'Gestor formalización-administración', 'HAYAGESTFORMADM' , 'Gestor formalización-administración', 'GFORMADM'  , 'Gestor formalización-administración', NULL, 0),
        T_LISTA ('vmoreno', NULL, NULL, 'GFORMADM', 'GFORMADM', 'Gestor formalización-administración', 'HAYAGESTFORMADM' , 'Gestor formalización-administración', 'GFORMADM'  , 'Gestor formalización-administración', NULL, 0)
    );
    V_TMP_LISTA T_LISTA;

BEGIN






    FOR I IN V_ARRAY.FIRST .. V_ARRAY.LAST
    LOOP
        V_TMP_LISTA := V_ARRAY(I);
        
        V_USU_USER := ''||V_TMP_LISTA(1)||'';
        V_USU_MAIL := ''||V_TMP_LISTA(2)||'';
        V_USU_GRUP := ''||V_TMP_LISTA(3)||'';
        V_DES_DESP := ''||V_TMP_LISTA(4)||'';
        V_COD_TDES := ''||V_TMP_LISTA(5)||'';
        V_TDE_DESC := ''||V_TMP_LISTA(6)||'';
        V_COD_PERF := ''||V_TMP_LISTA(7)||'';
        V_PEF_DESC := ''||V_TMP_LISTA(8)||'';
        V_COD_GEST := ''||V_TMP_LISTA(9)||'';
        V_GES_DESC := ''||V_TMP_LISTA(10)||'';
        V_COD_CART := ''||V_TMP_LISTA(11)||'';
        V_CNF_GEST := V_TMP_LISTA(12);
        
        #ESQUEMA#.SP_UPG_USER_PERFIL_GESTOR(
            V_USUARIO => V_USUARIO,
            V_USU_USER => V_USU_USER,
            V_USU_MAIL => V_USU_MAIL,
            V_USU_GRUP => V_USU_GRUP,
            V_DES_DESP => V_DES_DESP,
            V_COD_TDES => V_COD_TDES,
            V_TDE_DESC => V_TDE_DESC,
            V_COD_PERF => V_COD_PERF,
            V_PEF_DESC => V_PEF_DESC,
            V_COD_GEST => V_COD_GEST,
            V_GES_DESC => V_GES_DESC,
            V_COD_CART => V_COD_CART,
            V_CNF_GEST => V_CNF_GEST,
            PL_OUTPUT => PL_OUTPUT
        );
        
        DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
        
    END LOOP;
    
EXCEPTION
    WHEN OTHERS THEN
        PL_OUTPUT := PL_OUTPUT || '[ERROR] Se ha producido un error en la ejecución: ' || TO_CHAR(SQLCODE) || CHR(10);
        PL_OUTPUT := PL_OUTPUT || '-----------------------------------------------------------' || CHR(10);
        PL_OUTPUT := PL_OUTPUT || SQLERRM || CHR(10);
        DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
        ROLLBACK;
        RAISE;
END;
/
EXIT;
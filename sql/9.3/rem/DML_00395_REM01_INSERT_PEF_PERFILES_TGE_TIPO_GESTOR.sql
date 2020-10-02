--/*
--##########################################
--## AUTOR=Carlos Augusto Zaballos
--## FECHA_CREACION=20200828
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11220
--## PRODUCTO=NO
--##
--## Finalidad: Script para el sp
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
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
    V_SQL VARCHAR2(32000 CHAR);
    V_MSQL VARCHAR2(32000 CHAR);
    MSQL VARCHAR2(32000 CHAR);
    V_CNF_GEST NUMBER;
    PL_OUTPUT VARCHAR2(32000 CHAR);
    SP_OUTPUT VARCHAR2(32000 CHAR);
    TYPE T_LISTA IS TABLE OF VARCHAR2(240 CHAR);
    TYPE T_ARRAY IS TABLE OF T_LISTA;
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-11220';
    V_ARRAY T_ARRAY := T_ARRAY (
        T_LISTA ('gruboarding', NULL, 'gruboarding', 'GBOAR', 'GBOAR', 'Gestor Boarding', 'PERFGBOARDING' , 'Gestor Boarding', 'GBOAR'  , 'Gestor Boarding', NULL, 0)
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
        
        REM01.SP_UPG_USER_PERFIL_GESTOR(
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
        DBMS_OUTPUT.PUT_LINE('[ INFO ]: Se acaba de añadir el Gestor = '''||V_USU_USER||'''. con el siguiente codigo = '''||V_DES_DESP||'''');
    END LOOP;

		V_SQL := 'SELECT count(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USU_USER||''' ';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN

	    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR USU_USUARIOS ' );    

	    V_MSQL := ' 
			UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET USU_NOMBRE = '''||V_TDE_DESC||''', 
			USUARIOMODIFICAR = '''||V_USUARIO||''', 
			FECHAMODIFICAR = SYSDATE 
			WHERE USU_USERNAME = '''||V_USU_USER||''' ';

	       EXECUTE IMMEDIATE V_MSQL;	

	    DBMS_OUTPUT.PUT_LINE('[INFO] ActualizadoS '||SQL%ROWCOUNT||' registros en USU_USUARIOS');  

	ELSE
		DBMS_OUTPUT.PUT_LINE('[ INFO ]: El usuario no existe.');
	END IF;	


	V_SQL := 'SELECT count(1) FROM '||V_ESQUEMA||'.TGP_TIPO_GESTOR_PROPIEDAD WHERE TGP_VALOR = '''||V_COD_GEST||'''' ;
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS_2;

	IF V_NUM_TABLAS_2 = 0 THEN

	    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS REGISTRO EN TGP_TIPO_GESTOR_PROPIEDAD ' );    

	    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TGP_TIPO_GESTOR_PROPIEDAD' ||
							' (TGP_ID, DD_TGE_ID, TGP_CLAVE, TGP_VALOR,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
							' SELECT '||V_ESQUEMA||'.S_TGP_TIPO_GESTOR_PROPIEDAD.NEXTVAL' ||
							',(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||V_COD_GEST||''')' ||
							',''DES_VALIDOS'' ' ||
							', '''||V_COD_GEST||''',0, '''||V_USUARIO||''', SYSDATE, 0 FROM DUAL';
				EXECUTE IMMEDIATE V_MSQL;

				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla TGP_TIPO_GESTOR_PROPIEDAD insertados correctamente.');

	ELSE
		DBMS_OUTPUT.PUT_LINE('[ INFO ]: El TIPO GESTOR PROPIEDAD EXISTE.');
	END IF;	
    
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

--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20221228
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12996
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion registros 
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial  [REMVIP-12996] - Juan Bautista Alfonso
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_TABLA VARCHAR2(100 CHAR) := 'DD_ETG_EQV_TIPO_GASTO'; -- Tabla 
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-12996';
	V_NUM_REGISTROS NUMBER; -- Cuenta registros 
	V_NUM NUMBER;
	V_FLAG_VACIADO NUMBER := 0;
	V_COUNT NUMBER(16); -- Vble. para comprobar
    TYPE T_TABLA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TABLA IS TABLE OF T_TABLA;
	
    M_TABLA T_ARRAY_TABLA := T_ARRAY_TABLA(															
      --DD_ETG_CODIGO  Elemento PEP	CLASE/GRUPO	  TIPO	SUBTIPO	DD_TGA_CODIGO	DD_STG_CODIGO	PRO_SOCIEDAD_PAGADORA  EJE_ANYO

		--BANKIA
		T_TABLA('1125','XXXX-21-2-LEGAL','2','2','56','11','164','null','2021')
    ); 
    V_TMP_TABLA T_TABLA;
	
BEGIN
  V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_TABLA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTROS;

    
  
  	IF V_NUM_REGISTROS > 0 THEN

	FOR I IN M_TABLA.FIRST .. M_TABLA.LAST
    LOOP
	V_TMP_TABLA := M_TABLA(I);

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ETG_EQV_TIPO_GASTO WHERE DD_ETG_CODIGO = '''||TRIM(V_TMP_TABLA(1))||''' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	
	IF V_COUNT = 0 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTANDO '|| V_TABLA);

			V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'(
						DD_ETG_ID
						, DD_TGA_ID
						, DD_STG_ID
						, DD_ETG_CODIGO
						, DD_ETG_DESCRIPCION_POS
						, DD_ETG_DESCRIPCION_LARGA_POS
                        , ELEMENTO_PEP
						, COGRUG_POS
						, COTACA_POS
						, COSBAC_POS
						, DD_ETG_DESCRIPCION_NEG
						, DD_ETG_DESCRIPCION_LARGA_NEG
						, COGRUG_NEG
						, COTACA_NEG
						, COSBAC_NEG
						, VERSION
						, USUARIOCREAR
						, FECHACREAR
						, BORRADO
						, PRO_ID
						, EJE_ID
				) VALUES (
						'||V_ESQUEMA||'.S_DD_ETG_EQV_TIPO_GASTO.NEXTVAL
						, (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||V_TMP_TABLA(6)||''' AND BORRADO = 0 )
						, (SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TABLA(7)||''' AND BORRADO = 0 )
						, '''||V_TMP_TABLA(1)||'''
						, '''||V_TMP_TABLA(2)||'''
						, '''||V_TMP_TABLA(2)||'''
                        , '''||V_TMP_TABLA(2)||'''
						, '''||V_TMP_TABLA(3)||'''
						, '''||V_TMP_TABLA(4)||'''
						, '''||V_TMP_TABLA(5)||'''
						, '''||V_TMP_TABLA(2)||'''
						, '''||V_TMP_TABLA(2)||'''
						, '''||V_TMP_TABLA(3)||''' 
						, '''||V_TMP_TABLA(4)||'''
						, '''||V_TMP_TABLA(5)||'''
						, 0
						,  '''||V_USUARIO||'''
						, SYSDATE
						, 0
						, (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_SOCIEDAD_PAGADORA = '''||V_TMP_TABLA(8)||''' AND BORRADO = 0 ) 
						, (SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||V_TMP_TABLA(9)||''' AND BORRADO = 0 ) 
				)';
				EXECUTE IMMEDIATE V_SQL;	
			
			DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado en la tabla '||V_ESQUEMA||'.'||V_TABLA||' el código '||V_TMP_TABLA(1)||' ');
	ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE EL REGISTRO CON CODIGO '''||TRIM(V_TMP_TABLA(1))||'''');

      -- Si existe se modifica.
      DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO '''|| TRIM(V_TMP_TABLA(1)) ||'''');

      V_SQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' 
                SET 
			    DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||V_TMP_TABLA(6)||''' AND BORRADO = 0 )
			  , DD_STG_ID = (SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TABLA(7)||''' AND BORRADO = 0 )
			  , DD_ETG_DESCRIPCION_POS = '''||V_TMP_TABLA(2)||'''
			  , DD_ETG_DESCRIPCION_LARGA_POS = '''||V_TMP_TABLA(2)||'''
              , ELEMENTO_PEP = '''||V_TMP_TABLA(2)||'''
			  , COGRUG_POS = '''||V_TMP_TABLA(3)||'''
			  , COTACA_POS = '''||V_TMP_TABLA(4)||'''
			  , COSBAC_POS = '''||V_TMP_TABLA(5)||'''
			  , DD_ETG_DESCRIPCION_NEG = '''||V_TMP_TABLA(2)||'''
			  , DD_ETG_DESCRIPCION_LARGA_NEG = '''||V_TMP_TABLA(2)||'''
			  , COGRUG_NEG = '''||V_TMP_TABLA(3)||''' 
			  , COTACA_NEG = '''||V_TMP_TABLA(4)||'''
			  , COSBAC_NEG = '''||V_TMP_TABLA(5)||'''
			  , PRO_ID = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_SOCIEDAD_PAGADORA = '''||V_TMP_TABLA(8)||''' AND BORRADO = 0 ) 
			  , EJE_ID = (SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||V_TMP_TABLA(9)||''' AND BORRADO = 0 ) 
              , USUARIOMODIFICAR = '''||V_USUARIO||''' 
              , FECHAMODIFICAR = SYSDATE 
               WHERE DD_ETG_CODIGO = '''||TRIM(V_TMP_TABLA(1))||'''';
      EXECUTE IMMEDIATE V_SQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');


		END IF;
  	
    END LOOP;	

	END IF;

	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
	commit;


EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||'[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE)||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||'-----------------------------------------------------------'||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||SQLERRM||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||V_SQL||CHR(10);
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
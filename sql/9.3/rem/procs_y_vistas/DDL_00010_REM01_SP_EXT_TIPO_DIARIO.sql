--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200820
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-10902
--## PRODUCTO=NO
--## 
--## Finalidad:  Creación del SP SP_EXT_TIPO_DIARIO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1-PIER GOTTA-Versión inicial HREOS-10902
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE       SP_EXT_TIPO_DIARIO (
    ENT_ID    	      IN NUMBER, --Obligatorio
    TIPO_INMUEBLE     IN VARCHAR2, --Obligatorio
    TIPO_ACTIVO_BDE   IN VARCHAR2,
    TIPO_ENTIDAD      IN VARCHAR2, --Obligatorio
    V_USUARIO	      IN VARCHAR2, --Ogligatorio
    COD_RETORNO      OUT VARCHAR2

) AS


V_SQL VARCHAR2(32000 CHAR); 											-- Sentencia a ejecutar.
V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; 								-- Configuracion Esquema.
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
V_ENT_ID NUMBER( 16 );
V_TIN_ID NUMBER( 16 );
V_TAC_ID NUMBER( 16 );
V_ILB_ID NUMBER( 16 );
V_ILB2_ID NUMBER( 16 );
V_DIA_ID NUMBER( 16 );
V_DIA2_ID NUMBER ( 16 );
V_ATD_ID NUMBER ( 16 );


BEGIN

	-- Existe el tipo de entidad
	IF TIPO_ENTIDAD IS NOT NULL THEN

   	V_SQL := 'SELECT COUNT( 1 ) FROM '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO WHERE DD_ENT_CODIGO = '''|| TIPO_ENTIDAD ||''' AND BORRADO = 0';

	EXECUTE IMMEDIATE V_SQL INTO V_ENT_ID;

		IF ( V_ENT_ID = 0 OR TIPO_ENTIDAD NOT IN ('ACT', 'GEN', 'PRO')) THEN

		 --DBMS_OUTPUT.PUT_LINE('[INFO] No existe el Activo '|| ENT_ID ||' pasado por parámetros. El proceso finalizará.');
		 COD_RETORNO := '[KO] No existe tipo entidad';
		 RETURN;

		END IF;
		
	ELSE

	COD_RETORNO := '[KO] Tipo entidad vacía';
	RETURN;

	END IF;



	-- Comprobacion parámetro ENT_ID
	IF ENT_ID IS NULL THEN

	COD_RETORNO := '[KO] Entidad id vacía';
	RETURN;

	END IF;
    
    
    	-- Comprobacion parámetro V_USUARIO
	IF V_USUARIO IS NULL THEN

	COD_RETORNO := '[KO] Usuario vacío';
	RETURN;

	END IF;



	-- Existe el tipo inmueble
	IF TIPO_INMUEBLE IS NOT NULL THEN

	   	V_SQL := 'SELECT COUNT( 1 ) FROM '||V_ESQUEMA||'.ACT_TDI_TIPO_DIARIO 
			  WHERE TIPO_INMUEBLE = '''|| TIPO_INMUEBLE ||'''
			  AND BORRADO = 0';

		EXECUTE IMMEDIATE V_SQL INTO V_TIN_ID;

		IF ( V_TIN_ID = 0 ) THEN

		 --DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo inmueble '|| TIPO_INMUEBLE ||'. El proceso finalizará.');
		 COD_RETORNO := '[KO] No existe el tipo inmueble';
		 RETURN;

		END IF;

	ELSE 

	COD_RETORNO := '[KO] Tipo inmueble vacío';
	RETURN;

	END IF;


	-- Existe el tipo activo BDE
	IF TIPO_ACTIVO_BDE IS NOT NULL THEN

	   	V_SQL := 'SELECT COUNT( 1 ) FROM '||V_ESQUEMA||'.DD_TBE_TIPO_ACTIVO_BDE 
			  WHERE DD_TBE_CODIGO = '|| TIPO_ACTIVO_BDE ||' 
			  AND BORRADO = 0';

		EXECUTE IMMEDIATE V_SQL INTO V_TAC_ID;

		IF ( V_TAC_ID = 0 ) THEN

		 --DBMS_OUTPUT.PUT_LINE('[INFO] KO si no existe tipo activo BDE '|| TIPO_ACTIVO_BDE ||'. El proceso finalizará.');
		 COD_RETORNO := '[KO] No existe el tipo activo BDE';
		 RETURN;

		END IF;


	-- Existe registro en la ACT_ILB_NFO_LIBERBANK
	ELSIF TIPO_ACTIVO_BDE IS NULL AND TIPO_ENTIDAD = 'ACT' THEN

		V_SQL := 'SELECT COUNT( 1 ) FROM '||V_ESQUEMA||'.ACT_ILB_NFO_LIBERBANK 
			  WHERE ACT_ID = '|| ENT_ID ||' 
			  AND DD_TBE_ID IS NOT NULL';

		EXECUTE IMMEDIATE V_SQL INTO V_ILB_ID;

		IF ( V_ILB_ID = 0 ) THEN

		 --DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo activo BDE en la tabla ACT_ILB_NFO_LIBERBANK. El proceso finalizará.');
		 COD_RETORNO := '[KO] No existe el tipo activo BDE en la tabla ACT_ILB_NFO_LIBERBANK';
		 RETURN;

		ELSE 

		V_SQL := 'SELECT DD_TBE_ID FROM '||V_ESQUEMA||'.ACT_ILB_NFO_LIBERBANK 
			  WHERE ACT_ID = '|| ENT_ID ||' 
			  ';

		EXECUTE IMMEDIATE V_SQL INTO V_ILB2_ID;

		END IF;

	ELSIF TIPO_ACTIVO_BDE IS NULL AND TIPO_ENTIDAD != 'ACT' THEN

		 COD_RETORNO := '[KO] Es necesario el tipo activo BDE';
		 RETURN;
	END IF;


	-- Existe registro en la ACT_ILB_NFO_LIBERBANK

	IF TIPO_ACTIVO_BDE IS NOT NULL THEN

		V_SQL := 'SELECT COUNT( 1 ) FROM '||V_ESQUEMA||'.ACT_TDI_TIPO_DIARIO 
			  WHERE TIPO_INMUEBLE = '''|| TIPO_INMUEBLE ||''' AND DD_TBE_ID = (SELECT DD_TBE_ID FROM '||V_ESQUEMA||'.DD_TBE_TIPO_ACTIVO_BDE WHERE DD_TBE_CODIGO = '''|| TIPO_ACTIVO_BDE ||''')
			  AND BORRADO = 0';

		EXECUTE IMMEDIATE V_SQL INTO V_DIA_ID;

		IF ( V_DIA_ID = 0) THEN

		--DBMS_OUTPUT.PUT_LINE('[INFO] No existe registro en la tabla ACT_TDI_TIPO_DIARIO con ese tipo inmueble y ese tipo activo BDE. El proceso finalizará.');
		COD_RETORNO := '[KO] No existe registro en la tabla ACT_TDI_TIPO_DIARIO con ese tipo inmueble y ese tipo activo BDE';
		RETURN;

		ELSE

		V_SQL := 'SELECT TDI_ID FROM '||V_ESQUEMA||'.ACT_TDI_TIPO_DIARIO 
			  WHERE TIPO_INMUEBLE = '''|| TIPO_INMUEBLE ||''' AND DD_TBE_ID = (SELECT DD_TBE_ID FROM '||V_ESQUEMA||'.DD_TBE_TIPO_ACTIVO_BDE WHERE DD_TBE_CODIGO = '''|| TIPO_ACTIVO_BDE ||''')
			  AND BORRADO = 0';

		EXECUTE IMMEDIATE V_SQL INTO V_DIA_ID;

		END IF;

	ELSIF TIPO_ACTIVO_BDE IS NULL AND TIPO_ENTIDAD = 'ACT' THEN

		V_SQL := 'SELECT COUNT( 1 ) FROM '||V_ESQUEMA||'.ACT_TDI_TIPO_DIARIO 
			  WHERE TIPO_INMUEBLE = '''|| TIPO_INMUEBLE ||''' AND DD_TBE_ID = (SELECT DD_TBE_ID FROM '||V_ESQUEMA||'.DD_TBE_TIPO_ACTIVO_BDE WHERE DD_TBE_CODIGO = '|| V_ILB2_ID ||')
			  AND BORRADO = 0';

		EXECUTE IMMEDIATE V_SQL INTO V_DIA2_ID;

		IF ( V_DIA2_ID = 0) THEN

		-- DBMS_OUTPUT.PUT_LINE('[INFO] No existe registro en la tabla ACT_TDI_TIPO_DIARIO con ese tipo inmueble y ese tipo activo BDE. El proceso finalizará.');
		COD_RETORNO := '[KO] No existe registro en la tabla ACT_TDI_TIPO_DIARIO con ese tipo inmueble y ese tipo activo BDE';
		RETURN;

		ELSE

		V_SQL := 'SELECT TDI_ID FROM '||V_ESQUEMA||'.ACT_TDI_TIPO_DIARIO 
			  WHERE TIPO_INMUEBLE = '''|| TIPO_INMUEBLE ||''' AND DD_TBE_ID = (SELECT DD_TBE_ID FROM '||V_ESQUEMA||'.DD_TBE_TIPO_ACTIVO_BDE WHERE DD_TBE_CODIGO = '|| V_ILB2_ID ||')
			  AND BORRADO = 0';

		EXECUTE IMMEDIATE V_SQL INTO V_DIA2_ID;

		END IF;

	END IF;


	--Insertar o modificar registros en la ACT_ATD_ACT_TDI
	V_SQL := 'SELECT COUNT( 1 ) FROM '||V_ESQUEMA||'.ACT_ETD_ENT_TDI 
		  WHERE ENT_ID = '|| ENT_ID ||' AND DD_ENT_ID = (SELECT DD_ENT_ID FROM '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO WHERE DD_ENT_CODIGO = '''|| TIPO_ENTIDAD ||''') AND BORRADO = 0';

	EXECUTE IMMEDIATE V_SQL INTO V_ATD_ID;

	IF (V_ATD_ID = 0) THEN

   -- Crea el registro en ACT_ATD_ACT_TDI: 
	V_SQL := ' INSERT INTO ' || V_ESQUEMA || '.ACT_ETD_ENT_TDI
               ( 
		ETD_ID,
		ENT_ID,
		TDI_ID,
		DD_ENT_ID,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
                BORRADO
                )
                VALUES
                (
                 S_ACT_ETD_ENT_TDI.NEXTVAL,
		 '|| ENT_ID ||',
                 NVL('''|| V_DIA_ID ||''', '''|| V_DIA2_ID ||'''),
		 (SELECT DD_ENT_ID FROM '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO WHERE DD_ENT_CODIGO = '''|| TIPO_ENTIDAD ||'''),
                 0,
                 ''' || V_USUARIO || ''',
                 SYSDATE,
                 0
                 )';

        EXECUTE IMMEDIATE V_SQL;

        --DBMS_OUTPUT.PUT_LINE('[INFO] - Creado '||SQL%ROWCOUNT||' registro en ACT_ATD_ACT_TDI.');
	COD_RETORNO := '[OK] Se ha insertado correctamente el registro';

	ELSE

	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ETD_ENT_TDI 
                                SET TDI_ID =  NVL('''|| V_DIA_ID ||''', '''|| V_DIA2_ID ||''')
                                    ,USUARIOMODIFICAR = '''||V_USUARIO||'''
                                    ,FECHAMODIFICAR = SYSDATE
                                WHERE ENT_ID = '||ENT_ID||' AND DD_ENT_ID = (SELECT DD_ENT_ID FROM '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO WHERE DD_ENT_CODIGO = '''|| TIPO_ENTIDAD ||''')';

        EXECUTE IMMEDIATE V_SQL;

        --DBMS_OUTPUT.PUT_LINE('[INFO] - Modificado '||SQL%ROWCOUNT||' registro en ACT_ATD_ACT_TDI.');
	COD_RETORNO := '[OK] Se ha modificado correctamente el registro';
	END IF;


   COMMIT;


EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ERR_NUM := SQLCODE;
      RAISE;
END SP_EXT_TIPO_DIARIO;
/
EXIT

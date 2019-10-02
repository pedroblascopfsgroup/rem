--/*
--#########################################
--## AUTOR=ALVARO GARCIA
--## FECHA_CREACION=20191010
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-7803
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-7803';
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GTP_GES_TRANS_PERMITIDAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.


    V_TFP_ID NUMBER(16);
    V_DD_TPR_ID VARCHAR2(20 CHAR);
    V_DD_TGE_ID VARCHAR2(20 CHAR);
	
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
--			DD_TGE_COD	DD_TPR_COD	TFP_ORIGEN	TFP_DESTINO		GTP_TOTAL
		  T_JBV('GPUBL',	NULL,		NULL,		NULL,			1)	--Gestor de publicaciones
		, T_JBV('SPUBL',	NULL,		NULL,		NULL,			1)	--Supervisor de publicaciones
		, T_JBV('SUPEDI',	NULL,		'01',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'03',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'04',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'07',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'08',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'09',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'10',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'11',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'20',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'21',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'22',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'23',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'24',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'23',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'24',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'113',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'114',		'12',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'03',		'04',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'03',		'09',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'04',		'08',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'04',		'09',			0)	--Supervisor de activo edificación
		, T_JBV('SUPEDI',	NULL,		'24',		'20',			0)	--Supervisor de activo edificación
		, T_JBV('GEDI',		NULL,		'01',		'12',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'03',		'12',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'04',		'12',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'07',		'12',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'08',		'12',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'09',		'12',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'10',		'12',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'11',		'12',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'20',		'12',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'21',		'12',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'22',		'12',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'23',		'12',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'24',		'12',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'23',		'12',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'24',		'12',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'03',		'04',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'03',		'09',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'04',		'08',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'04',		'09',			0)	--Gestor de activo edificación
		, T_JBV('GEDI',		NULL,		'24',		'20',			0)	--Gestor de activo edificación
		, T_JBV('GACT',		NULL,		'01',		'12',			0)	--Gestor de mantenimiento
		, T_JBV('GACT',		NULL,		'03',		'12',			0)	--Gestor de mantenimiento
		, T_JBV('GACT',		NULL,		'04',		'12',			0)	--Gestor de mantenimiento
		, T_JBV('GACT',		NULL,		'07',		'12',			0)	--Gestor mantenimiento
		, T_JBV('GACT',		NULL,		'08',		'12',			0)	--Gestor mantenimiento
		, T_JBV('GACT',		NULL,		'09',		'12',			0)	--Gestor mantenimiento
		, T_JBV('GACT',		NULL,		'10',		'12',			0)	--Gestor mantenimiento
		, T_JBV('GACT',		NULL,		'11',		'12',			0)	--Gestor mantenimiento
		, T_JBV('GACT',		NULL,		'20',		'12',			0)	--Gestor mantenimiento
		, T_JBV('GACT',		NULL,		'21',		'12',			0)	--Gestor mantenimiento
		, T_JBV('GACT',		NULL,		'22',		'12',			0)	--Gestor mantenimiento
		, T_JBV('GACT',		NULL,		'23',		'12',			0)	--Gestor mantenimiento
		, T_JBV('GACT',		NULL,		'24',		'12',			0)	--Gestor mantenimiento
		, T_JBV('GACT',		NULL,		'23',		'12',			0)	--Gestor mantenimiento
		, T_JBV('GACT',		NULL,		'24',		'12',			0)	--Gestor mantenimiento
		, T_JBV('GACT',		NULL,		'07',		'08',			0)	--Gestor de mantenimiento
		, T_JBV('GACT',		NULL,		'07',		'09',			0)	--Gestor de mantenimiento
		, T_JBV('GACT',		NULL,		'08',		'07',			0)	--Gestor de mantenimiento
		, T_JBV('GACT',		NULL,		'08',		'09',			0)	--Gestor de mantenimiento
		, T_JBV('GACT',		NULL,		'24',		'20',			0)	--Gestor de mantenimiento
		, T_JBV('SUPACT',	NULL,		'01',		'12',			0)	--Supervisor de mantenimiento
		, T_JBV('SUPACT',	NULL,		'03',		'12',			0)	--Supervisor de mantenimiento
		, T_JBV('SUPACT',	NULL,		'04',		'12',			0)	--Supervisor de mantenimiento
		, T_JBV('SUPACT',	NULL,		'07',		'12',			0)	--Supervisor mantenimiento
		, T_JBV('SUPACT',	NULL,		'08',		'12',			0)	--Supervisor mantenimiento
		, T_JBV('SUPACT',	NULL,		'09',		'12',			0)	--Supervisor mantenimiento
		, T_JBV('SUPACT',	NULL,		'10',		'12',			0)	--Supervisor mantenimiento
		, T_JBV('SUPACT',	NULL,		'11',		'12',			0)	--Supervisor mantenimiento
		, T_JBV('SUPACT',	NULL,		'20',		'12',			0)	--Supervisor mantenimiento
		, T_JBV('SUPACT',	NULL,		'21',		'12',			0)	--Supervisor mantenimiento
		, T_JBV('SUPACT',	NULL,		'22',		'12',			0)	--Supervisor mantenimiento
		, T_JBV('SUPACT',	NULL,		'23',		'12',			0)	--Supervisor mantenimiento
		, T_JBV('SUPACT',	NULL,		'24',		'12',			0)	--Supervisor mantenimiento
		, T_JBV('SUPACT',	NULL,		'23',		'12',			0)	--Supervisor mantenimiento
		, T_JBV('SUPACT',	NULL,		'24',		'12',			0)	--Supervisor mantenimiento
		, T_JBV('SUPACT',	NULL,		'07',		'08',			0)	--Supervisor de mantenimiento
		, T_JBV('SUPACT',	NULL,		'07',		'09',			0)	--Supervisor de mantenimiento
		, T_JBV('SUPACT',	NULL,		'08',		'07',			0)	--Supervisor de mantenimiento
		, T_JBV('SUPACT',	NULL,		'08',		'09',			0)	--Supervisor de mantenimiento
		, T_JBV('SUPACT',	NULL,		'24',		'20',			0)	--Supervisor de mantenimiento
		, T_JBV('GALQ',		NULL,		'01',		'12',			0)	--Gestor de alquiler
		, T_JBV('GALQ',		NULL,		'03',		'12',			0)	--Gestor de alquiler
		, T_JBV('GALQ',		NULL,		'04',		'12',			0)	--Gestor de alquiler
		, T_JBV('GALQ',		NULL,		'07',		'12',			0)	--Gestor alquiler
		, T_JBV('GALQ',		NULL,		'08',		'12',			0)	--Gestor alquiler
		, T_JBV('GALQ',		NULL,		'09',		'12',			0)	--Gestor alquiler
		, T_JBV('GALQ',		NULL,		'10',		'12',			0)	--Gestor alquiler
		, T_JBV('GALQ',		NULL,		'11',		'12',			0)	--Gestor alquiler
		, T_JBV('GALQ',		NULL,		'20',		'12',			0)	--Gestor alquiler
		, T_JBV('GALQ',		NULL,		'21',		'12',			0)	--Gestor alquiler
		, T_JBV('GALQ',		NULL,		'22',		'12',			0)	--Gestor alquiler
		, T_JBV('GALQ',		NULL,		'23',		'12',			0)	--Gestor alquiler
		, T_JBV('GALQ',		NULL,		'24',		'12',			0)	--Gestor alquiler
		, T_JBV('GALQ',		NULL,		'23',		'12',			0)	--Gestor alquiler
		, T_JBV('GALQ',		NULL,		'24',		'12',			0)	--Gestor alquiler
		, T_JBV('GALQ',		NULL,		'07',		'08',			0)	--Gestor de alquiler
		, T_JBV('GALQ',		NULL,		'07',		'09',			0)	--Gestor de alquiler
		, T_JBV('GALQ',		NULL,		'08',		'07',			0)	--Gestor de alquiler
		, T_JBV('GALQ',		NULL,		'08',		'09',			0)	--Gestor de alquiler
		, T_JBV('GALQ',		NULL,		'24',		'20',			0)	--Gestor de alquiler
		, T_JBV('SUALQ',	NULL,		'01',		'12',			0)	--Supervisor de alquiler
		, T_JBV('SUALQ',	NULL,		'03',		'12',			0)	--Supervisor de alquiler
		, T_JBV('SUALQ',	NULL,		'04',		'12',			0)	--Supervisor de alquiler
		, T_JBV('SUALQ',	NULL,		'07',		'12',			0)	--Supervisor alquiler
		, T_JBV('SUALQ',	NULL,		'08',		'12',			0)	--Supervisor alquiler
		, T_JBV('SUALQ',	NULL,		'09',		'12',			0)	--Supervisor alquiler
		, T_JBV('SUALQ',	NULL,		'10',		'12',			0)	--Supervisor alquiler
		, T_JBV('SUALQ',	NULL,		'11',		'12',			0)	--Supervisor alquiler
		, T_JBV('SUALQ',	NULL,		'20',		'12',			0)	--Supervisor alquiler
		, T_JBV('SUALQ',	NULL,		'21',		'12',			0)	--Supervisor alquiler
		, T_JBV('SUALQ',	NULL,		'22',		'12',			0)	--Supervisor alquiler
		, T_JBV('SUALQ',	NULL,		'23',		'12',			0)	--Supervisor alquiler
		, T_JBV('SUALQ',	NULL,		'24',		'12',			0)	--Supervisor alquiler
		, T_JBV('SUALQ',	NULL,		'23',		'12',			0)	--Supervisor alquiler
		, T_JBV('SUALQ',	NULL,		'24',		'12',			0)	--Supervisor alquiler
		, T_JBV('SUALQ',	NULL,		'07',		'08',			0)	--Supervisor de alquiler
		, T_JBV('SUALQ',	NULL,		'07',		'09',			0)	--Supervisor de alquiler
		, T_JBV('SUALQ',	NULL,		'08',		'07',			0)	--Supervisor de alquiler
		, T_JBV('SUALQ',	NULL,		'08',		'09',			0)	--Supervisor de alquiler
		, T_JBV('SUALQ',	NULL,		'24',		'20',			0)	--Supervisor de alquiler
		, T_JBV('GSUE',		NULL,		'01',		'12',			0)	--Gestor de suelos
		, T_JBV('GSUE',		NULL,		'03',		'12',			0)	--Gestor de suelos
		, T_JBV('GSUE',		NULL,		'04',		'12',			0)	--Gestor de suelos
		, T_JBV('GSUE',		NULL,		'07',		'12',			0)	--Gestor suelos
		, T_JBV('GSUE',		NULL,		'08',		'12',			0)	--Gestor suelos
		, T_JBV('GSUE',		NULL,		'09',		'12',			0)	--Gestor suelos
		, T_JBV('GSUE',		NULL,		'10',		'12',			0)	--Gestor suelos
		, T_JBV('GSUE',		NULL,		'11',		'12',			0)	--Gestor suelos
		, T_JBV('GSUE',		NULL,		'20',		'12',			0)	--Gestor suelos
		, T_JBV('GSUE',		NULL,		'21',		'12',			0)	--Gestor suelos
		, T_JBV('GSUE',		NULL,		'22',		'12',			0)	--Gestor suelos
		, T_JBV('GSUE',		NULL,		'23',		'12',			0)	--Gestor suelos
		, T_JBV('GSUE',		NULL,		'24',		'12',			0)	--Gestor suelos
		, T_JBV('GSUE',		NULL,		'23',		'12',			0)	--Gestor suelos
		, T_JBV('GSUE',		NULL,		'24',		'12',			0)	--Gestor suelos
		, T_JBV('GSUE',		NULL,		'07',		'08',			0)	--Gestor de suelos
		, T_JBV('GSUE',		NULL,		'07',		'09',			0)	--Gestor de suelos
		, T_JBV('GSUE',		NULL,		'08',		'07',			0)	--Gestor de suelos
		, T_JBV('GSUE',		NULL,		'08',		'09',			0)	--Gestor de suelos
		, T_JBV('GSUE',		NULL,		'24',		'20',			0)	--Gestor de suelos
		, T_JBV('SUPSUE',	NULL,		'01',		'12',			0)	--Supervisor de suelos
		, T_JBV('SUPSUE',	NULL,		'03',		'12',			0)	--Supervisor de suelos
		, T_JBV('SUPSUE',	NULL,		'04',		'12',			0)	--Supervisor de suelos
		, T_JBV('SUPSUE',	NULL,		'07',		'12',			0)	--Supervisor suelos
		, T_JBV('SUPSUE',	NULL,		'08',		'12',			0)	--Supervisor suelos
		, T_JBV('SUPSUE',	NULL,		'09',		'12',			0)	--Supervisor suelos
		, T_JBV('SUPSUE',	NULL,		'10',		'12',			0)	--Supervisor suelos
		, T_JBV('SUPSUE',	NULL,		'11',		'12',			0)	--Supervisor suelos
		, T_JBV('SUPSUE',	NULL,		'20',		'12',			0)	--Supervisor suelos
		, T_JBV('SUPSUE',	NULL,		'21',		'12',			0)	--Supervisor suelos
		, T_JBV('SUPSUE',	NULL,		'22',		'12',			0)	--Supervisor suelos
		, T_JBV('SUPSUE',	NULL,		'23',		'12',			0)	--Supervisor suelos
		, T_JBV('SUPSUE',	NULL,		'24',		'12',			0)	--Supervisor suelos
		, T_JBV('SUPSUE',	NULL,		'23',		'12',			0)	--Supervisor suelos
		, T_JBV('SUPSUE',	NULL,		'24',		'12',			0)	--Supervisor suelos
		, T_JBV('SUPSUE',	NULL,		'07',		'08',			0)	--Supervisor de suelos
		, T_JBV('SUPSUE',	NULL,		'07',		'09',			0)	--Supervisor de suelos
		, T_JBV('SUPSUE',	NULL,		'08',		'07',			0)	--Supervisor de suelos
		, T_JBV('SUPSUE',	NULL,		'08',		'09',			0)	--Supervisor de suelos
		, T_JBV('SUPSUE',	NULL,		'24',		'20',			0)	--Supervisor de suelos
		, T_JBV(NULL,		'04',		'09',		'114',			0)	--API
		, T_JBV(NULL,		'04',		'113',		'114',			0)	--API

); 
V_TMP_JBV T_JBV;
BEGIN

 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);


	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TFP_TRANSICIONES_FASESP WHERE TFP_ORIGEN = (SELECT DD_SFP_ID FROM DD_SFP_SUBFASE_PUBLICACION WHERE DD_SFP_CODIGO = '''||TRIM(V_TMP_JBV(3))||''') AND TFP_DESTINO= (SELECT DD_SFP_ID FROM DD_SFP_SUBFASE_PUBLICACION WHERE DD_SFP_CODIGO = '''||TRIM(V_TMP_JBV(4))||''')';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT = 0 THEN
	 V_TFP_ID := NULL;
	ELSE	
	V_SQL := 'SELECT TFP_ID  FROM '||V_ESQUEMA||'.ACT_TFP_TRANSICIONES_FASESP WHERE TFP_ORIGEN = (SELECT DD_SFP_ID FROM DD_SFP_SUBFASE_PUBLICACION WHERE DD_SFP_CODIGO = '''||TRIM(V_TMP_JBV(3))||''') AND TFP_DESTINO= (SELECT DD_SFP_ID FROM DD_SFP_SUBFASE_PUBLICACION WHERE DD_SFP_CODIGO = '''||TRIM(V_TMP_JBV(4))||''')';
	EXECUTE IMMEDIATE V_SQL INTO V_TFP_ID;
	END IF;

--	DBMS_OUTPUT.PUT_LINE(' V_TFP_ID cargada con '''||V_TFP_ID||'''');	

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||TRIM(V_TMP_JBV(1))||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT = 0 THEN
	 V_DD_TGE_ID := NULL;
	ELSE	
	V_SQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||TRIM(V_TMP_JBV(1))||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_TGE_ID;
	END IF;

--	DBMS_OUTPUT.PUT_LINE(' V_DD_TGE_ID cargada con '''||V_DD_TGE_ID||'''');

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '''||TRIM(V_TMP_JBV(2))||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT = 0 THEN
	 V_DD_TPR_ID := NULL;
	ELSE	
	V_SQL := 'SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '''||TRIM(V_TMP_JBV(2))||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_DD_TPR_ID;
	END IF;		

--	DBMS_OUTPUT.PUT_LINE(' V_DD_TPR_ID cargada con '''||V_DD_TPR_ID||'''');

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TFP_ID = '''||V_TFP_ID||''' AND DD_TGE_ID='''||V_DD_TGE_ID||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT = 0 THEN						
				V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
				  GTP_ID
				, FECHACREAR
				, USUARIOCREAR
				, TFP_ID
				, DD_TGE_ID
				, DD_TPR_ID
				,GTP_TOTAL
				, VERSION
				, BORRADO
				) VALUES (
				 '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
				, SYSDATE
				, '''||V_USUARIO||'''
				, '''||V_TFP_ID||'''
				, '''||V_DD_TGE_ID||'''
				, '''||V_DD_TPR_ID||'''
				,'''||TRIM(V_TMP_JBV(5))||'''
				, 0
				, 0
				)';

				EXECUTE IMMEDIATE V_SQL;
		
	DBMS_OUTPUT.PUT_LINE('Insertado el registro '''||TRIM(V_TMP_JBV(1))||''' con TFP_ID '''||TRIM(V_TFP_ID)||'''');			
	ELSE
	DBMS_OUTPUT.PUT_LINE('El registro '''||TRIM(V_TMP_JBV(1))||''' ya existe con TFP_ID '''||TRIM(V_TFP_ID)||'''');			
 END IF;		
 END LOOP;			    
    
	COMMIT;

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('--------------------------SQLERRM---------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE('--------------------------QUERY-----------------------------');
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;


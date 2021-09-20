--/*
--#########################################
--## AUTOR=PEDRO BLASCO
--## FECHA_CREACION=20210708
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-0000
--## PRODUCTO=NO
--##
--## FINALIDAD: [Explicación de la existencia de este script]
--##
--## INSTRUCCIONES:
--##	1. Especificar el esquema de la tabla en la variable 'V_TABLE_SCHEME' apuntando a la variables 'V_SCHEME' o 'V_MASTER_SCHEME'.
--##	2. Especificar el nombre de la tabla a crear o modificar en la variable 'V_TABLE_NAME'.
--##	3. Especificar el usuario que quedará registrado en la auditoria para los cambios en la tabla en la variable 'V_AUDIT_USER'.
--##	4. Configurar las columnas que se verán afectadas al crear un nuevo registro en la tabla en la variable 'V_COLUMNS_ARRAY'.
--##	5. Configurar los datos a generar en las columnas indicadas anteriormente de la tabla en la variable 'V_DATA_MATRIX' siguiendo el patrón de diseño.
--##
--##	** No modificar las zonas entre BEGIN -> EXIT, la lógica implementada lleva a cabo las operaciones necesarias con las variables en el DECLARE **
--##	Más información: http://bit.ly/pitertul-api
--##
--## VERSIONES:
--##	0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON
SET DEFINE OFF

DECLARE
    -- Pitertul constants.
    V_SCHEME VARCHAR2(25 CHAR)          := '#ESQUEMA#'; -- Configuración de esquema. Asignada por Pitertul.
	V_MASTER_SCHEME VARCHAR2(25 CHAR)   := '#ESQUEMA_MASTER#'; -- Configuración de esquema master. Asignada por Pitertul.
    V_VERBOSITY_LEVEL NUMBER(1)         := OUTPUT_LEVEL.DEBUG; -- Configuración de nivel de verbosidad en el output log.

    -- User defined variables.
    V_TABLE_SCHEME VARCHAR2(25 CHAR)    := V_SCHEME; -- Indica el esquema de la tabla de referencia.
    V_TABLE_NAME VARCHAR2(125 CHAR)     := 'MPD_MAPEO_PERFIL_DESPACHO'; -- Indica el nombre de la tabla de referencia.
	V_AUDIT_USER VARCHAR2(50 CHAR)		:= 'HREOS-0000'; -- Indica el usuario para registrar en la auditoría con cada cambio.

	V_COLUMNS_ARRAY ARRAY_TABLE 		:= ARRAY_TABLE('MPD_CODIGO_PERFIL', 'MPD_CODIGO_DESPACHO', 'MPD_CODIGO_GRUPO', 'MPD_MANUAL', 'MPD_NOTAS'); 
		-- Indica las columnas en las cuales insertar contenido.

	--	Modificar estructura y contenido acorde con el número y orden de columnas especificadas en 'V_COLUMNS_ARRAY'.
	V_DATA_MATRIX MATRIX_TABLE := MATRIX_TABLE(
ARRAY_TABLE('PERFGBOARDING','GBOAR','gruboarding','0',''),
ARRAY_TABLE('HAYACAL','REMCAL','','0',''),
ARRAY_TABLE('PERFGCCBANKIA','REMGCCBANKIA','','0',''),
ARRAY_TABLE('PERFGCCLIBERBANK','GCCLBK','grucclbk','0',''),
ARRAY_TABLE('PERFGCCLIBERBANK','REMLIBCOINM','grucoinm','1',''),
ARRAY_TABLE('PERFGCCLIBERBANK','REMLIBCOINV','grucoinv','1',''),
ARRAY_TABLE('PERFGCCLIBERBANK','REMLIBINVINM','grulibinvinm','1',''),
ARRAY_TABLE('PERFGCCLIBERBANK','REMLIBRES','grulibres','1',''),
ARRAY_TABLE('PERFGCCLIBERBANK','REMLIBSINTER','grulibsinter','1',''),
ARRAY_TABLE('PERFGCCLIBERBANK','REMLIBCODI','grucodi','1',''),
ARRAY_TABLE('PERFGCV','GCV','grucierreventa','0',''),
ARRAY_TABLE('HAYAGESTCOM','REMGCOM','','0',''),
ARRAY_TABLE('HAYAGBOFIN','REMGBOFIN','','0',''),
ARRAY_TABLE('HAYAGBOINM','REMGBOINM','','0',''),
ARRAY_TABLE('GESTCOMBACKOFFICE','GESTCOMBACKOFF','','0',''),
ARRAY_TABLE('HAYAGESTCOMRET','REMGCOMRET','','0',''),
ARRAY_TABLE('HAYAGESTCOMSIN','REMGCOMSIN','','0',''),
ARRAY_TABLE('PERFGCONTROLLER','GCONT','grucontroller','0',''),
ARRAY_TABLE('HAYAGESACT','REMACT','','0',''),
ARRAY_TABLE('HAYAGESTADM','REMADM','','0',''),
ARRAY_TABLE('GESTALQ','GESTCOMALQ','gestalq','0','Genérico, Para gestores comerciales de alquiler'),
ARRAY_TABLE('GESTALQ','SUPCOMALQ','','1','Para supervisores comerciales de alquiler'),
ARRAY_TABLE('GESTEDI','gestedi','','0',''),
ARRAY_TABLE('HAYAGOLDTREE','REMGTREE','','0',''),
ARRAY_TABLE('HAYAGESTMARK','REMGMARK','','0',''),
ARRAY_TABLE('GESMIN','REMGESMIN','','0',''),
ARRAY_TABLE('HAYAGESTPREC','REMGPREC','','0',''),
ARRAY_TABLE('GESPROV','REMPROV','','0',''),
ARRAY_TABLE('HAYAGESTPUBL','REMGPUBL','usugrupub','0',''),
ARRAY_TABLE('GESRES','REMGESRES','','0',''),
ARRAY_TABLE('GESTSUE','','gestsue','0',''),
ARRAY_TABLE('GFORM','','gestform','0',''),
ARRAY_TABLE('HAYAGESTFORM','REMGFORM','','0',''),
ARRAY_TABLE('HAYAGESTFORMADM','GFORMADM','','0',''),
ARRAY_TABLE('HAYAFSV','REMFSV','','0',''),
ARRAY_TABLE('FVDBACKOFERTA','REMFVDBACKOFR','','0',''),
ARRAY_TABLE('FVDBACKVENTA','REMFVDBACKVNT','','0',''),
ARRAY_TABLE('FVDNEGOCIO','REMFVDNEG','','0',''),
ARRAY_TABLE('HAYAGESTADMT','REMGIAADMT','','0',''),
ARRAY_TABLE('GESTOADM','REMGGADM','','0','Preferido'),
ARRAY_TABLE('GESTRECOVERY','REMGESTREC','','0',''),
ARRAY_TABLE('HAYAGESTPORTMAN','GPM','portfolioman','0',''),
ARRAY_TABLE('HAYASUPER','REMSUPER','','0',''),
ARRAY_TABLE('HAYASUPCAL','REMSUPCAL','','0',''),
ARRAY_TABLE('HAYASUPCOM','REMSUPCOM','','0',''),
ARRAY_TABLE('HAYABACKOFFICE','REMBACKOFFICE','','0',''),
ARRAY_TABLE('HAYASBOFIN','REMSBOFIN','','0',''),
ARRAY_TABLE('HAYASBOINM','REMSBOINM','','0','Preferido'),
ARRAY_TABLE('HAYASUPCOMRET','REMSUPCOMRET','','0',''),
ARRAY_TABLE('HAYASUPCOMSIN','REMSUPCOMSIN','','0',''),
ARRAY_TABLE('HAYASUPACT','REMSUPACT','','0',''),
ARRAY_TABLE('HAYASUPADM','REMSUPADM','','0',''),
ARRAY_TABLE('HAYASUPMARK','REMSUPMARK','','0',''),
ARRAY_TABLE('SUPMIN','REMSUPMIN','','0',''),
ARRAY_TABLE('HAYASUPPREC','REMSUPPREC','','0',''),
ARRAY_TABLE('HAYASUPPUBL','REMSUPPUBL','','0',''),
ARRAY_TABLE('SUPRES','REMSUPRES','','0',''),
ARRAY_TABLE('HAYASUPFORM','REMSUPFORM','','0',''),
ARRAY_TABLE('SUPFVD','REMSUPFVD','','0',''),
ARRAY_TABLE('HAYACERTI','REMCERT','','0',''),
ARRAY_TABLE('HAYAPROV','REMPROV','','0',''),
ARRAY_TABLE('HAYAPROV','REMPTEC','','1','Sólo para Proveedores técnicos (empresas), para que se muestre en el combo de proveedores técnicos.')
	);

	V_SQL VARCHAR2(1000 CHAR) := ''; 

    TYPE T_GES IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_GES IS TABLE OF T_GES;
	V_TIPO_GES T_ARRAY_GES := T_ARRAY_GES(
T_GES('HAYAADM','HAYAADM','','0',''),
T_GES('HAYALLA','HAYALLA','','0',''),
T_GES('GESTOADM','GESTOADM','','1',''),
T_GES('GESTOCED','GESTOCED','','0',''),
T_GES('GESTIAFORM','GESTORIAFORM','','0',''),
T_GES('GESTOPDV','GESTOPDV','','0',''),
T_GES('GESTOPLUS','GESTOPLUS','','0',''),
T_GES('GTOPOSTV','GTOPOSTV','','0',''),
T_GES('HAYASBOINM','HAYASBOINM','','1',''),
T_GES('HAYASADM','HAYASADM','','0',''),
T_GES('HAYASLLA','HAYASLLA','','0',''));
	V_TMP_GES T_GES;

BEGIN
    pitertul.insert_common_table(V_TABLE_SCHEME, V_TABLE_NAME, V_COLUMNS_ARRAY, V_DATA_MATRIX, V_AUDIT_USER, V_VERBOSITY_LEVEL);

    V_SQL := 'INSERT INTO ' || V_TABLE_SCHEME || '.' || V_TABLE_NAME || 
    	' (MPD_ID, MPD_CODIGO_PERFIL, MPD_CODIGO_DESPACHO, MPD_CODIGO_GRUPO, MPD_MANUAL, MPD_NOTAS, USUARIOCREAR, FECHACREAR) ' ||
    	' VALUES (' || V_TABLE_SCHEME || '.S_' || V_TABLE_NAME || '.NEXTVAL, :1, :2, :3, TO_NUMBER(:4), :5, :6, SYSDATE)';

    FOR I IN V_TIPO_GES.FIRST .. V_TIPO_GES.LAST
   	LOOP
   		V_TMP_GES := V_TIPO_GES(I);
   		EXECUTE IMMEDIATE V_SQL USING V_TMP_GES(1), V_TMP_GES(2), V_TMP_GES(3), V_TMP_GES(4), V_TMP_GES(5), V_AUDIT_USER;
	    DBMS_OUTPUT.PUT_LINE(V_TMP_GES(1) || '-' || V_TMP_GES(2) || '-' || V_TMP_GES(3));
   	END LOOP;

   	COMMIT;

EXCEPTION
	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE(SQLERRM);
	ROLLBACK;
	RAISE;
END;
/
EXIT
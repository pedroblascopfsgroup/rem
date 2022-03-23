--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20211118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0
--## INCIDENCIA_LINK=REMVIP-10738
--## PRODUCTO=NO
--##
--## Finalidad: INSERTAR campos de DD_UPO_UNID_POBLACIONAL
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
    /* TABLA: DD_UPO_UNID_POBLACIONAL */
    TYPE T_UPO IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_UPO IS TABLE OF T_UPO;
    V_UPO T_ARRAY_UPO := T_ARRAY_UPO(
    --              DD_UPO_CODIGO     DD_UPO_DESCRIPCION    				DD_UPO_DESCRIPCION_LARGA
		   T_UPO(   '000800'       ,'099'      						,'ORIHUELA COSTA'),
		   T_UPO(   '000501'       ,'101'      						,'RIUCLAR'),
		   T_UPO(   '000103'       ,'089'      						,'BALCONES (LOS)'),
		   T_UPO(   '000305'       ,'009'      		,'HURTADO'),
		   T_UPO(   '002602'       ,'001'      						,'QUINTA (LA)'),
		   T_UPO(   '002603'       ,'001'      					,'TAUCHO'),
		   T_UPO(   '000102'       ,'046'      					,'DROVA (LA)'),
		   T_UPO(   '000102'        ,'211'      			,'MONTE REAL')
		);
    V_TMP_T_UPO T_UPO;
    
    
    
 -- ## FIN DATOS
 -- ########################################################################################
      


BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL... Empezando a insertar datos en la tabla.');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST 
    LOOP
        V_TMP_FUNCION := V_FUNCION(I);
       
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD... Comprobamos que si la localidad existe: ' ||TRIM(V_TMP_FUNCION(2))||'.');
		
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = '''||TRIM(V_TMP_FUNCION(2))||'''';

        EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_LOCALIDAD;

        IF V_EXISTE_LOCALIDAD > 0 THEN 

            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD...Existe la localidad: ' ||TRIM(V_TMP_FUNCION(2))||'.');

            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL... Comprobamos si existe la unidad poblacional ' ||TRIM(V_TMP_FUNCION(1))||'.');
		
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL WHERE DD_UPO_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''';

            EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_UNIDAD;

            IF V_EXISTE_UNIDAD = 0 THEN

                V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL (
                                DD_UPO_ID
                                , DD_LOC_ID
                                , DD_UPO_CODIGO
                                , DD_UPO_DESCRIPCION
                                , DD_UPO_DESCRIPCION_LARGA
                                , VERSION
                                , USUARIOCREAR
                                , FECHACREAR
                                , BORRADO
                            ) VALUES (
                                '||V_ESQUEMA_M||'.S_DD_UPO_UNID_POBLACIONAL.NEXTVAL
                                , (SELECT DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = '''||TRIM(V_TMP_FUNCION(2))||''')
                                , '''||TRIM(V_TMP_FUNCION(1))||'''
                                , '''||TRIM(V_TMP_FUNCION(3))||'''
                                , '''||TRIM(V_TMP_FUNCION(3))||'''
                                , 0
                                , '''||V_ITEM||'''
                                , SYSDATE
                                , 0
                            )';

                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_UPO_UNID_POBLACIONAL... Insertado unidad poblacional: '||TRIM(V_TMP_FUNCION(1))||'.');
            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_UPO_UNID_POBLACIONAL... Ya existe la unidad poblacional: '||TRIM(V_TMP_FUNCION(1))||'.');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_LOC_LOCALIDAD... No existe la localidad: '||TRIM(V_TMP_FUNCION(2))||'.');
        END IF;
        
	END LOOP;
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Actualizado correctamente.');
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

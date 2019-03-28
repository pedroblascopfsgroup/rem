--/*
--##########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20190317
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.5.0
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que crea las relaciones entre documentos y tipo de activo
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
    V_MSQL VARCHAR2(4000 CHAR);

    V_EXISTE_TIPO_DOC NUMBER(16); -- Vble. para almacenar la busqueda del tipo de documento.
    V_EXISTE_TIPO_ACTIVO NUMBER(16); -- Vble. para almacenar la busqueda del tipo de activo.
    V_EXISTE_FUNCION NUMBER(16); -- Vble. para almacenar la busqueda de la función.
    V_EXISTE_RELACION NUMBER(16); -- Vble. para almacenar la busqueda de la relación documento/activo.

    V_FP_ID NUMBER(16); -- Vble. para almacenar el id de la tabla FUN_PEF con la relación perfil/función.
    V_TABLA VARCHAR2(50) := 'ACT_CFD_CONFIG_DOCUMENTO'; -- Vble. para almacenar el nombre de la tabla.

    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    -- EDITAR NÚMERO DE ITEM
    V_ITEM VARCHAR2(20) := 'REMVIP-3695';

    -- EDITAR: FUNCIONES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(

        --         CODIGO_DOCUMENTO                                         CFD_OBLIGATORIO      CFD_APLICA_F_CADUCIDAD      CFD_APLICA_F_ETIQUETA       CFD_APLICA_CALIFICACION    DD_TPA_CODIGO
        T_FUNCION('105' /*Informe 0*/                                       , '0'                , '1'                       ,'null'                     , 'null'                   , '02'),
        T_FUNCION('103' /*Decreto adjudicación*/                            , '1'                , '1'                       ,'null'                     , 'null'                   , '02'),
        T_FUNCION('99'  /*Posesión: acta de lanzamiento*/                   , '1'                , '1'                       ,'null'                     , 'null'                   , '02'),
        T_FUNCION('98'  /*Nota simple sin cargas*/                          , '1'                , '1'                       ,'null'                     , 'null'                   , '02'),
        T_FUNCION('97'  /*Nota simple actualizada*/                         , '0'                , '1'                       ,'null'                     , 'null'                   , '02'),
        T_FUNCION('96'  /*Tasación adjudicación*/                           , '0'                , '1'                       ,'null'                     , 'null'                   , '02'),
        T_FUNCION('95'  /*VPO: Solicitud autorización venta*/               , '0'                , '1'                       ,'null'                     , 'null'                   , '02'),
        T_FUNCION('94'  /*VPO: Notificación adjudicación para tanteo*/      , '0'                , '1'                       ,'1'                        , '1'                      , '02'),
        T_FUNCION('93'  /*VPO: Solicitud importe devolución ayudas*/        , '0'                , '0'                       ,'null'                     , 'null'                   , '02'),
        T_FUNCION('92'  /*CEE (Certificado de eficiencia energética)*/      , '0'                , '1'                       ,'null'                     , 'null'                   , '02'),
        T_FUNCION('91'  /*LPO (Licencia de primera ocupación)*/             , '0'                , '1'                       ,'null'                     , 'null'                   , '02'),
        T_FUNCION('90'  /*Cédula de habitabilidad*/                         , '0'                , '0'                       ,'null'                     , 'null'                   , '02'),
        T_FUNCION('89'  /*CFO (Certificado de final de obra)*/              , '0'                , '0'                       ,'null'                     , 'null'                   , '02'),
        T_FUNCION('88'  /*Boletín agua*/                                    , '0'                , '0'                       ,'null'                     , 'null'                   , '02'),
        T_FUNCION('87'  /*Boletín electricidad*/                            , '0'                , '1'                       ,'null'                     , 'null'                   , '02'),
        T_FUNCION('86'  /*Boletín gas*/                                     , '0'                , '1'                       ,'null'                     , 'null'                   , '02'),
        T_FUNCION('108' /*Presupuesto*/                                     , '0'                , '1'                       ,'null'                     , 'null'                   , '02')
    ); 

    V_TMP_FUNCION T_FUNCION;


BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.'||V_TABLA||'... Empezando a insertar datos en la tabla.');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST 
    LOOP
        V_TMP_FUNCION := V_FUNCION(I);
       
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO ... Comprobamos que existe el tipo de documento ' ||TRIM(V_TMP_FUNCION(1))||'.');
		
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO
                   WHERE DD_TPD_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''';

        EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_TIPO_DOC;

        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO ... Comprobamos que existe el tipo de activo ' ||TRIM(V_TMP_FUNCION(6))||'.');

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO
                   WHERE DD_TPA_CODIGO = '''||TRIM(V_TMP_FUNCION(6))||'''';

        EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_TIPO_ACTIVO;

        IF V_EXISTE_TIPO_DOC > 0 AND V_EXISTE_TIPO_ACTIVO > 0 THEN 

            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobamos relación documento/activo con su confoguración.');
		
            V_MSQL :=  'SELECT COUNT(1) 
                        FROM ACT_CFD_CONFIG_DOCUMENTO CONF
                        INNER JOIN DD_TPD_TIPO_DOCUMENTO TDP ON TDP.DD_TPD_ID = CONF.DD_TPD_ID
                        INNER JOIN DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = CONF.DD_TPA_ID
                        WHERE TDP.DD_TPD_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''
                        AND TPA.DD_TPA_CODIGO = '''||TRIM(V_TMP_FUNCION(6))||'''
                        AND CONF.CFD_OBLIGATORIO = '||TRIM(V_TMP_FUNCION(2))||'
                        AND CONF.CFD_APLICA_F_CADUCIDAD = '||TRIM(V_TMP_FUNCION(3))||'
                        AND CONF.CFD_APLICA_F_ETIQUETA = '||TRIM(V_TMP_FUNCION(4))||'
                        AND CONF.CFD_APLICA_CALIFICACION = '||TRIM(V_TMP_FUNCION(5))||'';

            EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_RELACION;

            IF V_EXISTE_RELACION = 0 THEN
                
                DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Insertando registro.');

                V_MSQL :=  'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
                            (
                                CFD_ID
                                ,DD_TPA_ID
                                ,DD_TPD_ID
                                ,CFD_OBLIGATORIO
                                ,CFD_APLICA_F_CADUCIDAD
                                ,CFD_APLICA_F_ETIQUETA
                                ,CFD_APLICA_CALIFICACION
                                ,VERSION
                                ,USUARIOCREAR
                                ,FECHACREAR
                                ,BORRADO
                            )
                            SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL
                            , (SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO WHERE DD_TPA_CODIGO = '''||TRIM(V_TMP_FUNCION(6))||''')
                            , (SELECT DD_TPd_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||''')
                            , '||TRIM(V_TMP_FUNCION(2))||'
                            , '||TRIM(V_TMP_FUNCION(3))||'
                            , '||TRIM(V_TMP_FUNCION(4))||'
                            , '||TRIM(V_TMP_FUNCION(5))||'
                            , 0
                            , '''||V_ITEM||'''
                            , SYSDATE
                            , 0 FROM DUAL
                ';

                EXECUTE IMMEDIATE V_MSQL;

            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'... Ya existe una relación entre el tipo de documento y el tipo de activo.');
            END IF;

        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'... No se ha encontrado el tipo de documento o el tipo de activo.');
        END IF;
        
	END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] Proceso terminado correctamente.');
    COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(V_MSQL);
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
--/*
--##########################################
--## AUTOR=JULIAN DOLZ 
--## FECHA_CREACION=20191001
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7818
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_GCP_GESTION_CCPP los datos solicitados por cada registro de ACT_CPR_COM_PROPIETARIOS
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


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
        
    V_TEXT_TABLA_DESTINO VARCHAR2(30 CHAR) := 'ACT_GCP_GESTION_CCPP';
    V_TEXT_TABLA_ORIGEN VARCHAR2(30 CHAR) := 'ACT_CPR_COM_PROPIETARIOS';
    V_ENTIDAD_ID NUMBER(16);
    V_USU_ID NUMBER(16);

    
BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] ');

         
    -- LOOP para insertar los valores en ACT_GCP_GESTION_CCPP -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '|| V_TEXT_TABLA_DESTINO ||' ');
    
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_DESTINO||'';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si tiene valores no hacemos nada
        IF V_NUM_TABLAS > 0 THEN                                
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: '||V_ESQUEMA||'.'||V_TEXT_TABLA_DESTINO||' ya tiene valores');
          
       --Si no existe, lo insertamos   
       ELSE

        V_SQL := 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''BATCH_USER'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_USU_ID;

          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EN '||V_ESQUEMA||'.'||V_TEXT_TABLA_DESTINO||'');      
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA_DESTINO ||' (' ||
                      'GCP_ID, CPR_ID, DD_ELO_ID, DD_SEG_ID, USU_ID, GCP_FECHA_INI, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ESQUEMA ||'.S_'|| V_TEXT_TABLA_DESTINO ||'.NEXTVAL AS GCP_ID,
                        CPR_ID,
                        CASE DD_SACT_ID
                            WHEN (SELECT DD_SACT_ID FROM DD_SACT_SITUACION_ACTIVO WHERE DD_SACT_CODIGO = ''1'') THEN (SELECT DD_ELO_ID FROM DD_ELO_ESTADO_LOCALIZACION WHERE DD_ELO_CODIGO = ''PDTE'')
                            WHEN (SELECT DD_SACT_ID FROM DD_SACT_SITUACION_ACTIVO WHERE DD_SACT_CODIGO = ''2'') THEN (SELECT DD_ELO_ID FROM DD_ELO_ESTADO_LOCALIZACION WHERE DD_ELO_CODIGO = ''NOE'')
                            WHEN (SELECT DD_SACT_ID FROM DD_SACT_SITUACION_ACTIVO WHERE DD_SACT_CODIGO = ''3'') THEN (SELECT DD_ELO_ID FROM DD_ELO_ESTADO_LOCALIZACION WHERE DD_ELO_CODIGO = ''NOE'')
                            ELSE NULL
                        END AS DD_ELO_ID,
                        CASE DD_SACT_ID
                            WHEN (SELECT DD_SACT_ID FROM DD_SACT_SITUACION_ACTIVO WHERE DD_SACT_CODIGO = ''1'') THEN (SELECT DD_SEG_ID FROM DD_SEG_SUBESTADO_GESTION WHERE DD_SEG_CODIGO = ''CONT_FALL'')
                            WHEN (SELECT DD_SACT_ID FROM DD_SACT_SITUACION_ACTIVO WHERE DD_SACT_CODIGO = ''2'') THEN (SELECT DD_SEG_ID FROM DD_SEG_SUBESTADO_GESTION WHERE DD_SEG_CODIGO = ''SIN_CONST'')
                            WHEN (SELECT DD_SACT_ID FROM DD_SACT_SITUACION_ACTIVO WHERE DD_SACT_CODIGO = ''3'') THEN (SELECT DD_SEG_ID FROM DD_SEG_SUBESTADO_GESTION WHERE DD_SEG_CODIGO = ''NA'')
                            ELSE NULL
                        END AS DD_SEG_ID,
                        '||V_USU_ID||',
                        SYSDATE,
                        0,
                        ''HREOS-7818'',
                        SYSDATE,
                        0
                        FROM '||V_TEXT_TABLA_ORIGEN||'';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '|| V_TEXT_TABLA_DESTINO ||' ACTUALIZADO CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT



   

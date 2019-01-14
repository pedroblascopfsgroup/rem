--/*
--##########################################
--## AUTOR=MARIA PRESENCIA
--## FECHA_CREACION=20181123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4578
--## PRODUCTO=NO
--##
--## Finalidad: Insertar valores en REVISION_POSESION_ENVIO_MAIL
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLE VARCHAR2(30 CHAR) := 'REVISION_POSESION_ENVIO_MAIL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MAILFROM VARCHAR2(32 CHAR);
    V_MAILTO VARCHAR2(32 CHAR);
    V_MAILCC VARCHAR2(128 CHAR);
    V_MAILBODY VARCHAR2(250 CHAR);
    V_MAILSUBJECT VARCHAR(250 CHAR);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('noreply.rem@pfsgroup.es' , 'jpoyatos@haya.es' , null , 'Se ha recibido la posesión del activo #activo de la cartera #cartera' , 'El activo #activo de la cartera #cartera está marcado en REM como Ocupado ilegal con indicios, se ha recibido la posesión del mismo, por favor revise dicha ocupación ilegal')
    );
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

   EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLE||'';

    
   FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        V_MAILFROM := V_TMP_TIPO_DATA(1); 
        V_MAILTO := V_TMP_TIPO_DATA(2);
        V_MAILCC := V_TMP_TIPO_DATA(3);
        V_MAILBODY := V_TMP_TIPO_DATA(4);
        V_MAILSUBJECT := V_TMP_TIPO_DATA(5);
        
                    
                V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLE||' WHERE DE = '''||V_MAILFROM||''' AND A ='''||V_MAILTO||''' '; 
                
                EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

                IF V_COUNT = 0 THEN
                        V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLE||'(
                          DE
                          ,A
                          ,COPIA
                          ,CUERPO
                          ,ASUNTO
						  ,USUARIOCREAR
						  ,FECHACREAR
                        ) VALUES (
                          '''||V_MAILFROM||'''
                        , '''||V_MAILTO||'''
                        , '''||V_MAILCC||'''
                        , '''||V_MAILBODY||'''
                        , '''||V_MAILSUBJECT||'''
						, ''HREOS-4578''
						, sysdate
                        )
                        ';
                        
                        EXECUTE IMMEDIATE V_SQL;
                        DBMS_OUTPUT.put_line('[INFO] Insertado el registro ');
                ELSE
                        DBMS_OUTPUT.put_line('[INFO] Ya existe el valor el registro.');
                END IF;
      END LOOP;

COMMIT;

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



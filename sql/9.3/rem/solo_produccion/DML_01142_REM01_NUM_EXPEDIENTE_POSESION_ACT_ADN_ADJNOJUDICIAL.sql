--/*
--######################################### 
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11250
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  update decha posesion ACT_ADN_ADJNOJUDICIAL
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_ADN_ADJNOJUDICIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-11250';
    V_NUM_REFERENCIA VARCHAR2(32 CHAR) := '982';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --ID_HAYA_JAGUAR/ID_ACTIVO
    	T_TIPO_DATA('7486231'),
        T_TIPO_DATA('7486285'),
        T_TIPO_DATA('7492102'),
        T_TIPO_DATA('7486391'),
        T_TIPO_DATA('7486467'),
        T_TIPO_DATA('7486498'),
        T_TIPO_DATA('7486499'),
        T_TIPO_DATA('7486575'),
        T_TIPO_DATA('7486577'),
        T_TIPO_DATA('7486592'),
        T_TIPO_DATA('7486631'),
        T_TIPO_DATA('7486711'),
        T_TIPO_DATA('7486754'),
        T_TIPO_DATA('7486783'),
        T_TIPO_DATA('7486786'),
        T_TIPO_DATA('7486790'),
        T_TIPO_DATA('7486919'),
        T_TIPO_DATA('7486947'),
        T_TIPO_DATA('7487008'),
        T_TIPO_DATA('7487109'),
        T_TIPO_DATA('7487127'),
        T_TIPO_DATA('7487151'),
        T_TIPO_DATA('7487206'),
        T_TIPO_DATA('7487219'),
        T_TIPO_DATA('7487239'),
        T_TIPO_DATA('7487243'),
        T_TIPO_DATA('7487244'),
        T_TIPO_DATA('7487257'),
        T_TIPO_DATA('7487303'),
        T_TIPO_DATA('7487320'),
        T_TIPO_DATA('7487365'),
        T_TIPO_DATA('7487395'),
        T_TIPO_DATA('7487443'),
        T_TIPO_DATA('7487474'),
        T_TIPO_DATA('7487499'),
        T_TIPO_DATA('7487512'),
        T_TIPO_DATA('7487557'),
        T_TIPO_DATA('7487598'),
        T_TIPO_DATA('7487636'),
        T_TIPO_DATA('7487639'),
        T_TIPO_DATA('7487643'),
        T_TIPO_DATA('7487698'),
        T_TIPO_DATA('7487741'),
        T_TIPO_DATA('7487765'),
        T_TIPO_DATA('7487768'),
        T_TIPO_DATA('7487810'),
        T_TIPO_DATA('7487833'),
        T_TIPO_DATA('7487923'),
        T_TIPO_DATA('7487956'),
        T_TIPO_DATA('7487958'),
        T_TIPO_DATA('7487963'),
        T_TIPO_DATA('7488060'),
        T_TIPO_DATA('7488063'),
        T_TIPO_DATA('7488064'),
        T_TIPO_DATA('7488074'),
        T_TIPO_DATA('7488109'),
        T_TIPO_DATA('7488136'),
        T_TIPO_DATA('7488195'),
        T_TIPO_DATA('7488206'),
        T_TIPO_DATA('7488314'),
        T_TIPO_DATA('7488354'),
        T_TIPO_DATA('7488396'),
        T_TIPO_DATA('7488489'),
        T_TIPO_DATA('7488505'),
        T_TIPO_DATA('7488577'),
        T_TIPO_DATA('7488626'),
        T_TIPO_DATA('7488659'),
        T_TIPO_DATA('7488809'),
        T_TIPO_DATA('7488816'),
        T_TIPO_DATA('7488819'),
        T_TIPO_DATA('7488833'),
        T_TIPO_DATA('7488852'),
        T_TIPO_DATA('7488874'),
        T_TIPO_DATA('7488877'),
        T_TIPO_DATA('7488886'),
        T_TIPO_DATA('7488908'),
        T_TIPO_DATA('7488928'),
        T_TIPO_DATA('7488945'),
        T_TIPO_DATA('7488976'),
        T_TIPO_DATA('7489018'),
        T_TIPO_DATA('7489071'),
        T_TIPO_DATA('7489218'),
        T_TIPO_DATA('7489229'),
        T_TIPO_DATA('7489241'),
        T_TIPO_DATA('7489288'),
        T_TIPO_DATA('7489347'),
        T_TIPO_DATA('7489353'),
        T_TIPO_DATA('7489368'),
        T_TIPO_DATA('7489369'),
        T_TIPO_DATA('7489375'),
        T_TIPO_DATA('7489377'),
        T_TIPO_DATA('7489412'),
        T_TIPO_DATA('7489426'),
        T_TIPO_DATA('7489465'),
        T_TIPO_DATA('7489488'),
        T_TIPO_DATA('7489524'),
        T_TIPO_DATA('7489529'),
        T_TIPO_DATA('7489563'),
        T_TIPO_DATA('7489582'),
        T_TIPO_DATA('7489598'),
        T_TIPO_DATA('7489623'),
        T_TIPO_DATA('7489628'),
        T_TIPO_DATA('7489631'),
        T_TIPO_DATA('7489640'),
        T_TIPO_DATA('7489668'),
        T_TIPO_DATA('7489673'),
        T_TIPO_DATA('7489726'),
        T_TIPO_DATA('7489728'),
        T_TIPO_DATA('7489736'),
        T_TIPO_DATA('7489767'),
        T_TIPO_DATA('7489768'),
        T_TIPO_DATA('7489896'),
        T_TIPO_DATA('7490327'),
        T_TIPO_DATA('7490554'),
        T_TIPO_DATA('7491035'),
        T_TIPO_DATA('7491518'),
        T_TIPO_DATA('7491541'),
        T_TIPO_DATA('7491556'),
        T_TIPO_DATA('7491558'),
        T_TIPO_DATA('7491598'),
        T_TIPO_DATA('7491607'),
        T_TIPO_DATA('7491624'),
        T_TIPO_DATA('7491629'),
        T_TIPO_DATA('7491630'),
        T_TIPO_DATA('7491631'),
        T_TIPO_DATA('7491632'),
        T_TIPO_DATA('7491647'),
        T_TIPO_DATA('7491648'),
        T_TIPO_DATA('7491650'),
        T_TIPO_DATA('7491651'),
        T_TIPO_DATA('7491655'),
        T_TIPO_DATA('7491656'),
        T_TIPO_DATA('7491658'),
        T_TIPO_DATA('7491795'),
        T_TIPO_DATA('7491923'),
        T_TIPO_DATA('7491945'),
        T_TIPO_DATA('7491948'),
        T_TIPO_DATA('7491952'),
        T_TIPO_DATA('7491980'),
        T_TIPO_DATA('7492007'),
        T_TIPO_DATA('7492041'),
        T_TIPO_DATA('7492043'),
        T_TIPO_DATA('7492052')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a updatear.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO aa
                         WHERE aa.ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(1))||'
                         AND aa.BORRADO= 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        -- Si existe se modifica.
        IF V_NUM_TABLAS > 0 THEN			
                DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO  ACT_NUM '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
                V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                            'SET ADN_NUM_REFERENCIA = '''||V_NUM_REFERENCIA||'''
                                , USUARIOMODIFICAR = '''||V_USUARIO||''' 
                                , FECHAMODIFICAR = SYSDATE '||
                            'WHERE ACT_ID = ( SELECT aa.ACT_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO aa
                                WHERE aa.ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(1))||'
                                AND aa.BORRADO= 0)
                                AND BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

       ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL REGISTRO CON ACT_NUM:  '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
       END IF;
      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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

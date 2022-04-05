--/*
--######################################### 
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=202200307
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11299
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar fechas cédulas de habitabilidad
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
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CRG_CARGAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-11299';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                    --ID_CARGA          
        T_TIPO_DATA('42027583'),
        T_TIPO_DATA('41945585'),
        T_TIPO_DATA('41779299'),
        T_TIPO_DATA('41398031'),
        T_TIPO_DATA('41423689'),
        T_TIPO_DATA('42053498'),
        T_TIPO_DATA('39811715'),
        T_TIPO_DATA('42006769'),
        T_TIPO_DATA('42006765'),
        T_TIPO_DATA('42006716'),
        T_TIPO_DATA('42006761'),
        T_TIPO_DATA('42006756'),
        T_TIPO_DATA('42006752'),
        T_TIPO_DATA('42006710'),
        T_TIPO_DATA('42006747'),
        T_TIPO_DATA('42006744'),
        T_TIPO_DATA('42006739'),
        T_TIPO_DATA('42006705'),
        T_TIPO_DATA('42006733'),
        T_TIPO_DATA('42006701'),
        T_TIPO_DATA('42006730'),
        T_TIPO_DATA('42006725'),
        T_TIPO_DATA('42006696'),
        T_TIPO_DATA('42006721'),
        T_TIPO_DATA('42010009'),
        T_TIPO_DATA('42006687'),
        T_TIPO_DATA('42006683'),
        T_TIPO_DATA('42006680'),
        T_TIPO_DATA('42006677'),
        T_TIPO_DATA('42006674'),
        T_TIPO_DATA('42006671'),
        T_TIPO_DATA('42006666'),
        T_TIPO_DATA('42005586'),
        T_TIPO_DATA('42005583'),
        T_TIPO_DATA('42005580'),
        T_TIPO_DATA('42005577'),
        T_TIPO_DATA('42005574'),
        T_TIPO_DATA('42010006'),
        T_TIPO_DATA('42005571'),
        T_TIPO_DATA('42005568'),
        T_TIPO_DATA('42005559'),
        T_TIPO_DATA('42005556'),
        T_TIPO_DATA('42003377'),
        T_TIPO_DATA('42005553'),
        T_TIPO_DATA('42003426'),
        T_TIPO_DATA('42003422'),
        T_TIPO_DATA('42003423'),
        T_TIPO_DATA('42003420'),
        T_TIPO_DATA('38944210'),
        T_TIPO_DATA('38919392'),
        T_TIPO_DATA('37469659'),
        T_TIPO_DATA('41220440'),
        T_TIPO_DATA('41939080'),
        T_TIPO_DATA('42003419'),
        T_TIPO_DATA('42003418'),
        T_TIPO_DATA('42003417'),
        T_TIPO_DATA('42003416'),
        T_TIPO_DATA('42003415'),
        T_TIPO_DATA('42003414'),
        T_TIPO_DATA('42003413'),
        T_TIPO_DATA('42003412'),
        T_TIPO_DATA('42003411'),
        T_TIPO_DATA('42003410'),
        T_TIPO_DATA('42003409'),
        T_TIPO_DATA('42003408'),
        T_TIPO_DATA('42003407'),
        T_TIPO_DATA('42003406'),
        T_TIPO_DATA('42003405'),
        T_TIPO_DATA('42003404'),
        T_TIPO_DATA('42003403'),
        T_TIPO_DATA('42003402'),
        T_TIPO_DATA('42003401'),
        T_TIPO_DATA('42003397'),
        T_TIPO_DATA('35165985'),
        T_TIPO_DATA('35165982'),
        T_TIPO_DATA('34833889'),
        T_TIPO_DATA('36791453'),
        T_TIPO_DATA('34349102'),
        T_TIPO_DATA('34349097'),
        T_TIPO_DATA('34349092'),
        T_TIPO_DATA('34349087'),
        T_TIPO_DATA('34349082'),
        T_TIPO_DATA('34349078'),
        T_TIPO_DATA('34349072'),
        T_TIPO_DATA('34349068'),
        T_TIPO_DATA('34349062'),
        T_TIPO_DATA('34349057'),
        T_TIPO_DATA('34323133'),
        T_TIPO_DATA('34323128'),
        T_TIPO_DATA('34323122'),
        T_TIPO_DATA('34323117'),
        T_TIPO_DATA('34323112'),
        T_TIPO_DATA('34323107'),
        T_TIPO_DATA('34323101'),
        T_TIPO_DATA('34323093'),
        T_TIPO_DATA('34323088'),
        T_TIPO_DATA('34323084'),
        T_TIPO_DATA('39612640'),
        T_TIPO_DATA('39637580'),
        T_TIPO_DATA('34296698'),
        T_TIPO_DATA('35423447'),
        T_TIPO_DATA('42041822'),
        T_TIPO_DATA('42041819'),
        T_TIPO_DATA('42041826'),
        T_TIPO_DATA('33934537'),
        T_TIPO_DATA('41944526'),
        T_TIPO_DATA('41944528'),
        T_TIPO_DATA('41944520'),
        T_TIPO_DATA('41944524'),
        T_TIPO_DATA('41944522'),
        T_TIPO_DATA('37394116'),
        T_TIPO_DATA('33205922'),
        T_TIPO_DATA('35064501'),
        T_TIPO_DATA('30516493'),
        T_TIPO_DATA('30516494'),
        T_TIPO_DATA('29881986'),
        T_TIPO_DATA('33440780'),
        T_TIPO_DATA('30746166'),
        T_TIPO_DATA('30746171'),
        T_TIPO_DATA('30720414'),
        T_TIPO_DATA('30694685'),
        T_TIPO_DATA('30694683'),
        T_TIPO_DATA('30694688'),
        T_TIPO_DATA('29284542'),
        T_TIPO_DATA('30694677'),
        T_TIPO_DATA('31975688'),
        T_TIPO_DATA('28958740'),
        T_TIPO_DATA('30033768'),
        T_TIPO_DATA('27170519'),
        T_TIPO_DATA('39463839'),
        T_TIPO_DATA('26562627'),
        T_TIPO_DATA('26513713'),
        T_TIPO_DATA('26489442'),
        T_TIPO_DATA('26225415'),
        T_TIPO_DATA('33179646'),
        T_TIPO_DATA('35243601'),
        T_TIPO_DATA('38574020'),
        T_TIPO_DATA('26927073'),
        T_TIPO_DATA('25839415'),
        T_TIPO_DATA('29856637'),
        T_TIPO_DATA('29856636'),
        T_TIPO_DATA('29856633'),
        T_TIPO_DATA('29856632'),
        T_TIPO_DATA('25910449'),
        T_TIPO_DATA('26683555'),
        T_TIPO_DATA('25509052'),
        T_TIPO_DATA('32872457'),
        T_TIPO_DATA('26683548'),
        T_TIPO_DATA('25508992'),
        T_TIPO_DATA('25508990'),
        T_TIPO_DATA('25509011'),
        T_TIPO_DATA('25508973'),
        T_TIPO_DATA('32872455'),
        T_TIPO_DATA('24264727'),
        T_TIPO_DATA('24093730'),
        T_TIPO_DATA('24264724'),
        T_TIPO_DATA('33179656'),
        T_TIPO_DATA('33077389'),
        T_TIPO_DATA('26927070'),
        T_TIPO_DATA('23462096'),
        T_TIPO_DATA('22636938'),
        T_TIPO_DATA('22636937'),
        T_TIPO_DATA('22636933'),
        T_TIPO_DATA('22556104'),
        T_TIPO_DATA('21904583'),
        T_TIPO_DATA('21963156'),
        T_TIPO_DATA('21904588'),
        T_TIPO_DATA('21875428'),
        T_TIPO_DATA('24064083'),
        T_TIPO_DATA('20925962'),
        T_TIPO_DATA('22043771'),
        T_TIPO_DATA('21007347'),
        T_TIPO_DATA('20770885'),
        T_TIPO_DATA('23691882'),
        T_TIPO_DATA('24469653'),
        T_TIPO_DATA('20044440'),
        T_TIPO_DATA('21736717'),
        T_TIPO_DATA('20017610'),
        T_TIPO_DATA('21736714'),
        T_TIPO_DATA('30746179'),
        T_TIPO_DATA('38351973'),
        T_TIPO_DATA('21678283'),
        T_TIPO_DATA('20851855'),
        T_TIPO_DATA('23721426'),
        T_TIPO_DATA('31975690'),
        T_TIPO_DATA('17511973'),
        T_TIPO_DATA('17511970'),
        T_TIPO_DATA('26345414'),
        T_TIPO_DATA('26345409'),
        T_TIPO_DATA('41966657'),
        T_TIPO_DATA('20407122'),
        T_TIPO_DATA('21933860'),
        T_TIPO_DATA('27905847'),
        T_TIPO_DATA('42024984'),
        T_TIPO_DATA('19723300'),
        T_TIPO_DATA('18741556'),
        T_TIPO_DATA('17382780'),
        T_TIPO_DATA('21568466'),
        T_TIPO_DATA('17356954'),
        T_TIPO_DATA('17356970'),
        T_TIPO_DATA('21904680'),
        T_TIPO_DATA('18604561'),
        T_TIPO_DATA('24469666'),
        T_TIPO_DATA('24469664'),
        T_TIPO_DATA('25685389'),
        T_TIPO_DATA('25685391'),
        T_TIPO_DATA('40917157'),
        T_TIPO_DATA('18767745'),
        T_TIPO_DATA('41576015'),
        T_TIPO_DATA('36090701'),
        T_TIPO_DATA('36142781'),
        T_TIPO_DATA('36142779'),
        T_TIPO_DATA('36116763'),
        T_TIPO_DATA('36142775'),
        T_TIPO_DATA('36116759'),
        T_TIPO_DATA('36142783'),
        T_TIPO_DATA('36116740'),
        T_TIPO_DATA('36116777'),
        T_TIPO_DATA('36116761'),
        T_TIPO_DATA('36116749'),
        T_TIPO_DATA('36116773'),
        T_TIPO_DATA('36116771'),
        T_TIPO_DATA('20716915'),
        T_TIPO_DATA('36116745'),
        T_TIPO_DATA('36116791'),
        T_TIPO_DATA('36116730'),
        T_TIPO_DATA('36116732'),
        T_TIPO_DATA('20716913'),
        T_TIPO_DATA('22864890'),
        T_TIPO_DATA('21372054'),
        T_TIPO_DATA('22328702'),
        T_TIPO_DATA('41830649'),
        T_TIPO_DATA('13101844'),
        T_TIPO_DATA('13101846'),
        T_TIPO_DATA('34168831'),
        T_TIPO_DATA('34168832'),
        T_TIPO_DATA('33597204'),
        T_TIPO_DATA('19162737'),
        T_TIPO_DATA('9498916'),
        T_TIPO_DATA('41983421'),
        T_TIPO_DATA('29710523'),
        T_TIPO_DATA('9498852'),
        T_TIPO_DATA('29710519'),
        T_TIPO_DATA('29710527'),
        T_TIPO_DATA('19162772'),
        T_TIPO_DATA('32155286'),
        T_TIPO_DATA('9502487'),
        T_TIPO_DATA('9502486'),
        T_TIPO_DATA('9502485'),
        T_TIPO_DATA('38869907'),
        T_TIPO_DATA('9502484'),
        T_TIPO_DATA('32820657'),
        T_TIPO_DATA('24919023'),
        T_TIPO_DATA('32744877'),
        T_TIPO_DATA('32820662'),
        T_TIPO_DATA('32745010'),
        T_TIPO_DATA('32744870'),
        T_TIPO_DATA('32744900'),
        T_TIPO_DATA('32744899'),
        T_TIPO_DATA('9501430'),
        T_TIPO_DATA('26562649'),
        T_TIPO_DATA('9502488'),
        T_TIPO_DATA('9498706'),
        T_TIPO_DATA('30033737'),
        T_TIPO_DATA('20071336'),
        T_TIPO_DATA('20071338'),
        T_TIPO_DATA('20071337'),
        T_TIPO_DATA('20071334'),
        T_TIPO_DATA('20071335'),
        T_TIPO_DATA('20071339'),
        T_TIPO_DATA('20071333'),
        T_TIPO_DATA('22131361'),
        T_TIPO_DATA('27880617'),
        T_TIPO_DATA('20044439'),
        T_TIPO_DATA('18421422'),
        T_TIPO_DATA('22043791'),
        T_TIPO_DATA('17023181'),
        T_TIPO_DATA('21904575'),
        T_TIPO_DATA('21765853'),
        T_TIPO_DATA('9498333'),
        T_TIPO_DATA('9493362'),
        T_TIPO_DATA('9497612'),
        T_TIPO_DATA('9497841'),
        T_TIPO_DATA('37902086'),
        T_TIPO_DATA('37902085'),
        T_TIPO_DATA('37290777'),
        T_TIPO_DATA('9492519'),
        T_TIPO_DATA('17382705'),
        T_TIPO_DATA('37140941'),
        T_TIPO_DATA('9504143'),
        T_TIPO_DATA('15366056'),
        T_TIPO_DATA('9498726'),
        T_TIPO_DATA('9502520'),
        T_TIPO_DATA('9502416'),
        T_TIPO_DATA('9502532'),
        T_TIPO_DATA('9501961'),
        T_TIPO_DATA('9502481'),
        T_TIPO_DATA('9502482'),
        T_TIPO_DATA('9501963'),
        T_TIPO_DATA('9502483'),
        T_TIPO_DATA('9502277'),
        T_TIPO_DATA('9502265'),
        T_TIPO_DATA('9502234'),
        T_TIPO_DATA('9502232'),
        T_TIPO_DATA('9502043'),
        T_TIPO_DATA('9502250'),
        T_TIPO_DATA('9502230'),
        T_TIPO_DATA('9502002'),
        T_TIPO_DATA('9496240'),
        T_TIPO_DATA('9498625'),
        T_TIPO_DATA('9496239'),
        T_TIPO_DATA('9502524'),
        T_TIPO_DATA('29634490'),
        T_TIPO_DATA('29634486'),
        T_TIPO_DATA('29634487'),
        T_TIPO_DATA('29634489'),
        T_TIPO_DATA('29634488'),
        T_TIPO_DATA('29634491'),
        T_TIPO_DATA('9497971'),
        T_TIPO_DATA('9492459'),
        T_TIPO_DATA('29634485'),
        T_TIPO_DATA('9494248'),
        T_TIPO_DATA('9493550'),
        T_TIPO_DATA('9493546'),
        T_TIPO_DATA('29634492'),
        T_TIPO_DATA('9493548'),
        T_TIPO_DATA('9493538'),
        T_TIPO_DATA('9494206'),
        T_TIPO_DATA('9492075'),
        T_TIPO_DATA('9492213'),
        T_TIPO_DATA('9502470'),
        T_TIPO_DATA('38450869'),
        T_TIPO_DATA('9502468'),
        T_TIPO_DATA('9502426'),
        T_TIPO_DATA('9495630'),
        T_TIPO_DATA('37191244'),
        T_TIPO_DATA('9502471'),
        T_TIPO_DATA('37290742'),
        T_TIPO_DATA('16921672'),
        T_TIPO_DATA('9502454'),
        T_TIPO_DATA('9502414'),
        T_TIPO_DATA('9502413')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a updatear.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' acc
                         WHERE acc.CRG_ID = '||TRIM(V_TMP_TIPO_DATA(1))||'
                         AND acc.BORRADO= 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
        -- Si existe se modifica.
        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO  CRG_ID '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' 
                        SET CRG_CARGAS_PROPIAS = 1
                            , USUARIOMODIFICAR = '''||V_USUARIO||''' 
                            , FECHAMODIFICAR = SYSDATE '||
                        'WHERE CRG_ID = '||TRIM(V_TMP_TIPO_DATA(1))||'
                            AND BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE CRG_CARGAS_PROPIAS A SI');
       ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL REGISTRO CON CRG_ID:  '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
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

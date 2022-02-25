--/*
--######################################### 
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11215
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
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-11215';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('7487320','12/15/2016'),
        T_TIPO_DATA('7488063','7/18/2019'),
        T_TIPO_DATA('7489465','11/16/2011'),
        T_TIPO_DATA('7490327','6/22/2012'),
        T_TIPO_DATA('7489412','12/23/2013'),
        T_TIPO_DATA('7491658','5/29/2018'),
        T_TIPO_DATA('7486919','4/12/2018'),
        T_TIPO_DATA('7487395','11/19/2018'),
        T_TIPO_DATA('7486285','3/26/2019'),
        T_TIPO_DATA('7488816','11/26/2019'),
        T_TIPO_DATA('7488852','12/15/2016'),
        T_TIPO_DATA('7489347','5/26/2014'),
        T_TIPO_DATA('7487698','7/11/2012'),
        T_TIPO_DATA('7488195','12/17/2019'),
        T_TIPO_DATA('7489767','12/11/2015'),
        T_TIPO_DATA('7487474','5/30/2012'),
        T_TIPO_DATA('7489218','8/28/2013'),
        T_TIPO_DATA('7488396','6/10/2009'),
        T_TIPO_DATA('7487151','3/4/2011'),
        T_TIPO_DATA('7491598','11/5/2015'),
        T_TIPO_DATA('7487499','12/15/2016'),
        T_TIPO_DATA('7489229','2/14/2011'),
        T_TIPO_DATA('7488809','11/10/2020'),
        T_TIPO_DATA('7491980','3/25/2021'),
        T_TIPO_DATA('7489736','7/25/2012'),
        T_TIPO_DATA('7489529','9/30/2011'),
        T_TIPO_DATA('7487639','5/31/2012'),
        T_TIPO_DATA('7489241','12/19/2013'),
        T_TIPO_DATA('7487963','11/8/2018'),
        T_TIPO_DATA('7489640','11/23/2018'),
        T_TIPO_DATA('7490554','2/16/2021'),
        T_TIPO_DATA('7491607','7/9/2021'),
        T_TIPO_DATA('7486467','5/22/2019'),
        T_TIPO_DATA('7488109','3/30/2010'),
        T_TIPO_DATA('7489623','9/30/2011'),
        T_TIPO_DATA('7487008','1/10/2022'),
        T_TIPO_DATA('7488064','3/25/2020'),
        T_TIPO_DATA('7487239','7/8/2020'),
        T_TIPO_DATA('7488874','3/27/2018'),
        T_TIPO_DATA('7488577','2/18/2021'),
        T_TIPO_DATA('7488060','12/15/2016'),
        T_TIPO_DATA('7489673','11/7/2011'),
        T_TIPO_DATA('7488074','11/30/2009'),
        T_TIPO_DATA('7488206','5/28/2019'),
        T_TIPO_DATA('7487636','11/9/2021'),
        T_TIPO_DATA('7489631','5/23/2011'),
        T_TIPO_DATA('7489369','12/13/2018'),
        T_TIPO_DATA('7489071','8/28/2013'),
        T_TIPO_DATA('7486231','6/29/2020'),
        T_TIPO_DATA('7489426','6/8/2017'),
        T_TIPO_DATA('7491558','6/6/2018'),
        T_TIPO_DATA('7488886','1/25/2018'),
        T_TIPO_DATA('7487958','9/30/2011'),
        T_TIPO_DATA('7491518','6/21/2016'),
        T_TIPO_DATA('7487365','6/22/2016'),
        T_TIPO_DATA('7487923','9/23/2019'),
        T_TIPO_DATA('7488908','12/19/2013'),
        T_TIPO_DATA('7486631','5/2/2011'),
        T_TIPO_DATA('7487443','10/2/2018'),
        T_TIPO_DATA('7486391','1/23/2017'),
        T_TIPO_DATA('7488945','12/22/2017'),
        T_TIPO_DATA('7488626','5/27/2015'),
        T_TIPO_DATA('7488819','5/31/2012'),
        T_TIPO_DATA('7487768','12/13/2018'),
        T_TIPO_DATA('7492052','5/5/2021'),
        T_TIPO_DATA('7489728','3/16/2017'),
        T_TIPO_DATA('7488505','7/1/2015'),
        T_TIPO_DATA('7489488','12/30/2013'),
        T_TIPO_DATA('7488659','11/22/2019'),
        T_TIPO_DATA('7487643','12/15/2016'),
        T_TIPO_DATA('7489768','12/11/2015'),
        T_TIPO_DATA('7487512','12/15/2016'),
        T_TIPO_DATA('7491556','12/16/2011'),
        T_TIPO_DATA('7487303','5/22/2019'),
        T_TIPO_DATA('7487244','6/27/2012'),
        T_TIPO_DATA('7487810','12/14/2015'),
        T_TIPO_DATA('7487109','12/19/2018'),
        T_TIPO_DATA('7487833','11/17/2021'),
        T_TIPO_DATA('7491948','9/15/2021'),
        T_TIPO_DATA('7486754','12/19/2012'),
        T_TIPO_DATA('7489896','3/22/2017'),
        T_TIPO_DATA('7489628','7/21/2017'),
        T_TIPO_DATA('7488928','9/4/2020'),
        T_TIPO_DATA('7489598','6/12/2018'),
        T_TIPO_DATA('7489288','12/31/1899'),
        T_TIPO_DATA('7488877','5/13/2021'),
        T_TIPO_DATA('7489353','9/30/2011'),
        T_TIPO_DATA('7487257','7/1/2016'),
        T_TIPO_DATA('7487127','6/27/2017'),
        T_TIPO_DATA('7489377','3/17/2011'),
        T_TIPO_DATA('7492041','2/2/2022'),
        T_TIPO_DATA('7488314','2/1/2018'),
        T_TIPO_DATA('7486790','12/31/1899'),
        T_TIPO_DATA('7488833','12/31/1899'),
        T_TIPO_DATA('7488136','4/21/2009'),
        T_TIPO_DATA('7489582','4/16/2019'),
        T_TIPO_DATA('7487243','5/30/2012'),
        T_TIPO_DATA('7489726','7/3/2014'),
        T_TIPO_DATA('7489524','9/30/2011'),
        T_TIPO_DATA('7489668','9/30/2011'),
        T_TIPO_DATA('7488976','11/19/2019'),
        T_TIPO_DATA('7491035','2/16/2021'),
        T_TIPO_DATA('7492007','3/29/2021'),
        
        T_TIPO_DATA('7486592','null'),
        T_TIPO_DATA('7486783','null'),
        T_TIPO_DATA('7491629','null'),
        T_TIPO_DATA('7486577','null'),
        T_TIPO_DATA('7489368','null'),
        T_TIPO_DATA('7491651','null'),
        T_TIPO_DATA('7487956','null'),
        T_TIPO_DATA('7491655','null'),
        T_TIPO_DATA('7491952','null'),
        T_TIPO_DATA('7486499','null'),
        T_TIPO_DATA('7491650','null'),
        T_TIPO_DATA('7488489','null'),
        T_TIPO_DATA('7489375','null'),
        T_TIPO_DATA('7489018','null'),
        T_TIPO_DATA('7491631','null'),
        T_TIPO_DATA('7487219','null'),
        T_TIPO_DATA('7487598','null'),
        T_TIPO_DATA('7491656','null'),
        T_TIPO_DATA('7489563','null'),
        T_TIPO_DATA('7491624','null'),
        T_TIPO_DATA('7491945','null'),
        T_TIPO_DATA('7491632','null'),
        T_TIPO_DATA('7487765','null'),
        T_TIPO_DATA('7486711','null'),
        T_TIPO_DATA('7491541','null'),
        T_TIPO_DATA('7491923','null'),
        T_TIPO_DATA('7486575','null'),
        T_TIPO_DATA('7491648','null'),
        T_TIPO_DATA('7492043','null'),
        T_TIPO_DATA('7488354','null'),
        T_TIPO_DATA('7491795','null'),
        T_TIPO_DATA('7487206','null'),
        T_TIPO_DATA('7486947','null'),
        T_TIPO_DATA('7491647','null'),
        T_TIPO_DATA('7491630','null'),
        T_TIPO_DATA('7486498','null'),
        T_TIPO_DATA('7487741','null'),
        T_TIPO_DATA('7486786','null')
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
                        JOIN '|| V_ESQUEMA ||'.ACT_ADN_ADJNOJUDICIAL adn ON aa.ACT_ID = adn.ACT_ID
                         WHERE aa.ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(1))||'';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        -- Si existe se modifica.
        IF V_NUM_TABLAS > 0 THEN				
            IF V_TMP_TIPO_DATA(2) != 'null' THEN				
                -- Si tiene fecha se actualiza.
                DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO  ACT_NUM '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
                V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                            'SET FECHA_POSESION = TO_DATE('''||TRIM(V_TMP_TIPO_DATA(2))||''',''mm/dd/yyyy'')'||
                                ', USUARIOMODIFICAR = '''||V_USUARIO||''' 
                                , FECHAMODIFICAR = SYSDATE '||
                            'WHERE ACT_ID = ( SELECT aa.ACT_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO aa
                                JOIN '|| V_ESQUEMA ||'.ACT_ADN_ADJNOJUDICIAL adn ON aa.ACT_ID = adn.ACT_ID
                                WHERE aa.ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(1))||')';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

            ELSE
                -- Si no tiene fecha se deja a null.
                DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO  ACT_NUM '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' CON FECHA A NULL ');
                V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                            'SET FECHA_POSESION = null '||
                                ', USUARIOMODIFICAR = '''||V_USUARIO||''' 
                                , FECHAMODIFICAR = SYSDATE '||
                            'WHERE ACT_ID = ( SELECT aa.ACT_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO aa
                                JOIN '|| V_ESQUEMA ||'.ACT_ADN_ADJNOJUDICIAL adn ON aa.ACT_ID = adn.ACT_ID
                                WHERE aa.ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(1))||')';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

            END IF;
       ELSE
       	-- Si no existe se actualiza.
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

--/*
--##########################################
--## AUTOR= Gustavo Mora
--## FECHA_CREACION=20180824
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1631
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_GES_DIST_GESTORES los datos añadidos en T_ARRAY_DATA
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    --TIPO_GESTOR COD_CARTERA COD_ESTADO_ACTIVO COD_TIPO_COMERZIALZACION COD_PROVINCIA COD_MUNICIPIO COD_POSTAL USERNAME NOMBRE_USUARIO VERSION USUARIOCREAR FECHACREAR

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                            -- TGE                 CRA    EAC    TCR    PRV        LOC  POSTAL USERNAME
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'15' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'1' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'33' ,''  ,''    ,'lmarcos'),
               --BALEARES
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'39' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'26' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'35' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'24' ,''  ,''    ,'lmarcos'),
               --LUGO
               -- NAVARRA 
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'32' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'36' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'38' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'44' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'48' ,''  ,''    ,'lmarcos'),
               
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'16' ,''  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'19' ,''  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'28' ,''  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'4' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'5' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'6' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'9' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'10' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'11' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'14' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'18' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'21' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'22' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'23' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'29' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'34' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'37' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'40' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'41' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'42' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'43' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'47' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'49' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'50' ,''  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'2' ,''  ,''    ,'lcarrillo'),


               
               --TOLEDO
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45001'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45002'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45014'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45015'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45016'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45019'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45023'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45025'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45029'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45031'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45032'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45034'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45051'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45052'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45055'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45059'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45060'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45067'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45070'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45076'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45083'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45085'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45088'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45089'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45090'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45092'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45094'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45098'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45102'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45106'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45107'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45109'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45112'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45116'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45119'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45122'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45127'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45133'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45136'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45140'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45141'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45145'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45153'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45154'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45163'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45168'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45169'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45182'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45187'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45188'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45190'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45196'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45199'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45200'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45203'  ,''    ,'prodriguezg'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45205'  ,''    ,'prodriguezg'),
               
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45003'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45004'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45006'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45007'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45009'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45013'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45018'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45021'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45028'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45030'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45036'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45037'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45038'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45040'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45041'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45043'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45045'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45046'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45047'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45056'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45058'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45061'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45062'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45064'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45066'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45069'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45072'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45074'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45077'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45081'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45086'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45091'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45095'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45097'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45099'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45104'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45105'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45110'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45117'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45118'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45125'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45126'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45130'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45132'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45134'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45137'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45138'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45143'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45147'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45151'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45157'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45158'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45901'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45160'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45165'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45171'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45172'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45173'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45176'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45179'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45180'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45181'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45183'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45189'  ,''    ,'lmarcos'),
               T_TIPO_DATA('HAYAGBOINM'  ,'8'  ,'' ,''  ,'45' ,'45201'  ,''    ,'lmarcos'),
               
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45026'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45027'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45050'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45053'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45054'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45071'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45078'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45084'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45087'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45101'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45115'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45121'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45123'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45135'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45142'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45156'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45161'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45166'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45167'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45175'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45186'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45185'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45195'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45197'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45198'  ,''    ,'lcarrillo'),
               T_TIPO_DATA('HAYAGBOINM'  ,'08'  ,'' ,''  ,'45' ,'45202'  ,''    ,'lcarrillo')


                        
    );

    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] Insertar valores en '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.');
         
    -- LOOP para insertar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: Inicio de comprobaciones previas.');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := '
          SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
          WHERE 
            TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' 
            AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' 
            AND COD_ESTADO_ACTIVO IS NULL 
            AND COD_TIPO_COMERZIALZACION IS NULL 
            AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' 
            AND (COD_MUNICIPIO IS NULL OR COD_MUNICIPIO = '''||TRIM(V_TMP_TIPO_DATA(6))||''') 
            AND COD_POSTAL IS NULL 
        ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN                                
          
          V_MSQL := '
            UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' 
            SET 
              USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''',
              NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||'''),
              USUARIOMODIFICAR = ''REMVIP-1631'',
              FECHAMODIFICAR = SYSDATE 
            WHERE 
              TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' 
              AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' 
              AND COD_ESTADO_ACTIVO IS NULL 
              AND COD_TIPO_COMERZIALZACION IS NULL 
              AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' 
              AND (COD_MUNICIPIO IS NULL OR COD_MUNICIPIO = '''||TRIM(V_TMP_TIPO_DATA(6))||''') 
              AND COD_POSTAL IS NULL ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: Registro MODIFICADO para la el COD_CARTERA: '||TRIM(V_TMP_TIPO_DATA(2))||' COD_PROVINCIA '||TRIM(V_TMP_TIPO_DATA(5)));
          
       --Si no existe, lo insertamos   
       ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;   
          
          V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' 
              (ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
            SELECT 
              '|| V_ID ||',
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '||V_TMP_TIPO_DATA(2)||',
              '''||V_TMP_TIPO_DATA(3)||''',
              '''||V_TMP_TIPO_DATA(4)||''',
              '''||V_TMP_TIPO_DATA(5)||''',
              '''||TRIM(V_TMP_TIPO_DATA(6))||''',
              '''||TRIM(V_TMP_TIPO_DATA(7))||''',
              '''||TRIM(V_TMP_TIPO_DATA(8))||''',
              (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||'''),
              0,
              ''REMVIP-1631'',
              SYSDATE,
              0
            FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: Registro INSERTADO para la el COD_CARTERA: '||TRIM(V_TMP_TIPO_DATA(2)));
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TEXT_TABLA||' actualizado corresctamente.');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          COMMIT;
          RAISE;          

END;
/

EXIT;

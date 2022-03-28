--/*
--######################################### 
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220224
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11216
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  update de los  proveedores en expediente comercial y ofertas
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
    PVE_ANTIGUO  NUMBER(16); -- Vble. para validar la existencia de un valor en una tabla. 
    PVE_NUEVO  NUMBER(16); -- Vble. para validar la existencia de un valor en una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := ''; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-11216';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('BK3036','8171'),
        T_TIPO_DATA('BK2466','6148'),
        T_TIPO_DATA('BK9607','7899'),
        T_TIPO_DATA('BK9011','5064'),
        T_TIPO_DATA('BK9896','7691'),
        T_TIPO_DATA('BK3298','7949'),
        T_TIPO_DATA('BK7919','3377'),
        T_TIPO_DATA('BK5790','9102'),
        T_TIPO_DATA('BK5829','7724'),
        T_TIPO_DATA('BK6162','8539'),
        T_TIPO_DATA('BK6498','8381'),
        T_TIPO_DATA('BK3435','3708'),
        T_TIPO_DATA('BK9943','5580'),
        T_TIPO_DATA('BK3074','8331'),
        T_TIPO_DATA('BK9043','7690'),
        T_TIPO_DATA('BK3576','5750'),
        T_TIPO_DATA('BK3037','8196'),
        T_TIPO_DATA('BK5866','3327'),
        T_TIPO_DATA('BK3231','8306'),
        T_TIPO_DATA('BK9145','1464'),
        T_TIPO_DATA('BK9929','7622'),
        T_TIPO_DATA('BK6254','5623'),
        T_TIPO_DATA('BK3693','4692'),
        T_TIPO_DATA('BK8745','7837'),
        T_TIPO_DATA('BK2266','1611'),
        T_TIPO_DATA('BK6019','8707'),
        T_TIPO_DATA('BK3070','8278'),
        T_TIPO_DATA('BK6520','6091'),
        T_TIPO_DATA('BK9619','5216'),
        T_TIPO_DATA('BK2936','8222'),
        T_TIPO_DATA('BK3549','1140'),
        T_TIPO_DATA('BK9942','4971'),
        T_TIPO_DATA('BK3033','8224'),
        T_TIPO_DATA('BK3021','8184'),
        T_TIPO_DATA('BK3020','8182'),
        T_TIPO_DATA('BK1010','2504'),
        T_TIPO_DATA('BK3038','8203'),
        T_TIPO_DATA('BK3014','5919'),
        T_TIPO_DATA('BK3068','8200'),
        T_TIPO_DATA('BK7061','4094'),
        T_TIPO_DATA('BK6688','7460'),
        T_TIPO_DATA('BK3026','8321'),
        T_TIPO_DATA('BK3019','8180'),
        T_TIPO_DATA('BK2417','2004'),
        T_TIPO_DATA('BK7776','3593'),
        T_TIPO_DATA('BK3563','3212'),
        T_TIPO_DATA('BK7507','6804'),
        T_TIPO_DATA('BK3159','8291'),
        T_TIPO_DATA('BK7597','6112'),
        T_TIPO_DATA('BK4702','7921'),
        T_TIPO_DATA('BK7286','3530'),
        T_TIPO_DATA('BK2918','6345'),
        T_TIPO_DATA('BK3669','6885'),
        T_TIPO_DATA('BK7267','7214'),
        T_TIPO_DATA('BK2821','6055'),
        T_TIPO_DATA('BK9919','3365'),
        T_TIPO_DATA('BK3547','3209'),
        T_TIPO_DATA('BK3268','6214'),
        T_TIPO_DATA('BK8923','7878'),
        T_TIPO_DATA('BK9682','5871'),
        T_TIPO_DATA('BK9691','6086')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN TABLAS GEX_GASTOS_EXPEDIENTE y OFR_OFERTAS');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        PVE_ANTIGUO := 0;
        PVE_NUEVO := 0;

        --Comprobar el dato a updatear.
        V_MSQL := 'SELECT pve.PVE_ID FROM '||V_ESQUEMA||'.act_pve_proveedor pve
                        WHERE pve.DD_TPR_ID = 44
                        AND pve.BORRADO = 0
                        AND pve.PVE_COD_API_PROVEEDOR = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO PVE_ANTIGUO;

        V_MSQL := 'SELECT pve.PVE_ID FROM '||V_ESQUEMA||'.act_pve_proveedor pve
                        WHERE pve.DD_TPR_ID = 44
                        AND pve.BORRADO = 0
                        AND pve.PVE_COD_API_PROVEEDOR = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO PVE_NUEVO;
        -- Si existe se modifica.
        IF PVE_ANTIGUO != 0 AND PVE_NUEVO != 0 THEN		
                -- Actualiza GEX_GASTOS_EXPEDIENTE GEX_PROVEEDOR 
                DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO  GEX_PROVEEDOR '''|| PVE_ANTIGUO ||''' A  '''|| PVE_NUEVO ||'''');
                V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.GEX_GASTOS_EXPEDIENTE gex
                            SET gex.GEX_PROVEEDOR = '||PVE_NUEVO||'
                             , USUARIOMODIFICAR = '''||V_USUARIO||''' 
                             , FECHAMODIFICAR = SYSDATE 
                            WHERE gex.GEX_PROVEEDOR  = '||PVE_ANTIGUO||'
                            AND gex.BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO GEX_PROVEEDOR MODIFICADO CORRECTAMENTE');

          

           
                -- Actualiza OFR_OFERTAS PVE_ID_PRESCRIPTOR 
                DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO EN TABLA OFR_OFERTAS PVE_ID_PRESCRIPTOR '''|| PVE_ANTIGUO ||''' A  '''|| PVE_NUEVO ||'''');
                V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.OFR_OFERTAS ofr
                            SET ofr.PVE_ID_PRESCRIPTOR = '||PVE_NUEVO||'
                             , USUARIOMODIFICAR = '''||V_USUARIO||''' 
                             , FECHAMODIFICAR = SYSDATE 
                            WHERE ofr.PVE_ID_PRESCRIPTOR  = '||PVE_ANTIGUO||'
                            AND ofr.BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO PVE_ID_PRESCRIPTOR MODIFICADO CORRECTAMENTE');

            
                -- Actualiza OFR_OFERTAS PVE_ID_CUSTODIO 
                DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO EN TABLA OFR_OFERTAS PVE_ID_CUSTODIO  '''|| PVE_ANTIGUO ||''' A  '''|| PVE_NUEVO ||'''');
                V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.OFR_OFERTAS ofr
                            SET ofr.PVE_ID_CUSTODIO = '||PVE_NUEVO||'
                             , USUARIOMODIFICAR = '''||V_USUARIO||''' 
                             , FECHAMODIFICAR = SYSDATE 
                            WHERE ofr.PVE_ID_CUSTODIO  = '||PVE_ANTIGUO||'
                            AND ofr.BORRADO = 0';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO PVE_ID_CUSTODIO MODIFICADO CORRECTAMENTE');
       ELSE
       	-- Si no existe se actualiza.
          DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL REGISTRO CON PVE_COD_API_PROVEEDOR:  '||TRIM(V_TMP_TIPO_DATA(1))||' O '||TRIM(V_TMP_TIPO_DATA(2))||'');

       END IF;
      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ACTUALIZADO CORRECTAMENTE ');

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

--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210714
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10166
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10166'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ACT_ID NUMBER(16);
    

    --Estos son los activos de la agrupación 1000029143
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                T_TIPO_DATA('137246'),
                T_TIPO_DATA('151375'),
                T_TIPO_DATA('148891'),
                T_TIPO_DATA('98246'),
                T_TIPO_DATA('151683'),
                T_TIPO_DATA('137154'),
                T_TIPO_DATA('97981'),
                T_TIPO_DATA('97749'),
                T_TIPO_DATA('96751'),
                T_TIPO_DATA('148863'),
                T_TIPO_DATA('160422'),
                T_TIPO_DATA('148892'),
                T_TIPO_DATA('137153'),
                T_TIPO_DATA('88680'),
                T_TIPO_DATA('160421'),
                T_TIPO_DATA('97684'),
                T_TIPO_DATA('160469'),
                T_TIPO_DATA('151686'),
                T_TIPO_DATA('88679'),
                T_TIPO_DATA('99418'),
                T_TIPO_DATA('97751'),
                T_TIPO_DATA('98043'),
                T_TIPO_DATA('88621'),
                T_TIPO_DATA('97131'),
                T_TIPO_DATA('89156'),
                T_TIPO_DATA('160468'),
                T_TIPO_DATA('99416'),
                T_TIPO_DATA('97748'),
                T_TIPO_DATA('98249'),
                T_TIPO_DATA('96365'),
                T_TIPO_DATA('151466'),
                T_TIPO_DATA('88763'),
                T_TIPO_DATA('99177'),
                T_TIPO_DATA('89157'),
                T_TIPO_DATA('99417'),
                T_TIPO_DATA('98250'),
                T_TIPO_DATA('96528'),
                T_TIPO_DATA('97130'),
                T_TIPO_DATA('151684'),
                T_TIPO_DATA('99415'),
                T_TIPO_DATA('98833'),
                T_TIPO_DATA('148820'),
                T_TIPO_DATA('96366'),
                T_TIPO_DATA('89155'),
                T_TIPO_DATA('98729'),
                T_TIPO_DATA('97686'),
                T_TIPO_DATA('148821'),
                T_TIPO_DATA('151241'),
                T_TIPO_DATA('98044'),
                T_TIPO_DATA('99179'),
                T_TIPO_DATA('96526'),
                T_TIPO_DATA('88624'),
                T_TIPO_DATA('97685'),
                T_TIPO_DATA('96525'),
                T_TIPO_DATA('97982'),
                T_TIPO_DATA('96364'),
                T_TIPO_DATA('99178'),
                T_TIPO_DATA('160688'),
                T_TIPO_DATA('96748'),
                T_TIPO_DATA('98730'),
                T_TIPO_DATA('88623'),
                T_TIPO_DATA('98832'),
                T_TIPO_DATA('75300'),
                T_TIPO_DATA('137593'),
                T_TIPO_DATA('98247'),
                T_TIPO_DATA('97752'),
                T_TIPO_DATA('96746'),
                T_TIPO_DATA('96747'),
                T_TIPO_DATA('148819'),
                T_TIPO_DATA('151243'),
                T_TIPO_DATA('137244'),
                T_TIPO_DATA('88762'),
                T_TIPO_DATA('98248'),
                T_TIPO_DATA('151685'),
                T_TIPO_DATA('151242'),
                T_TIPO_DATA('88576'),
                T_TIPO_DATA('96527'),
                T_TIPO_DATA('98834'),
                T_TIPO_DATA('136937'),
                T_TIPO_DATA('137245'),
                T_TIPO_DATA('96750'),
                T_TIPO_DATA('88625'),
                T_TIPO_DATA('98728'),
                T_TIPO_DATA('96529'),
                T_TIPO_DATA('148864'),
                T_TIPO_DATA('96749'),
                T_TIPO_DATA('88622'),
                T_TIPO_DATA('97750'),
                T_TIPO_DATA('148822'),
                T_TIPO_DATA('136938')




    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia del activo
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            V_COUNT := 0;

            --Obtenemos el ID del activo
            V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;

            --Actualizamos el dato
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET           
            DD_EAC_ID =(SELECT DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO WHERE DD_EAC_CODIGO = ''04''),               
            USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE               
            WHERE ACT_ID = '||V_ACT_ID||'';
            EXECUTE IMMEDIATE V_MSQL;


            DBMS_OUTPUT.PUT_LINE('[INFO] ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO');
            
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO '''||V_TMP_TIPO_DATA(1)||'''');

        END IF;

    END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

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
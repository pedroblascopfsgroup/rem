--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8838
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar porcentajes gasto
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 


DECLARE


    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8838'; --Vble USUARIOMODIFICAR/USUARIOCREAR

    V_ID NUMBER(16); -- Vble. para el id del activo

    V_ID_PROVEEDOR NUMBER(16); -- Vble. para el id del proveedor

    V_TABLA_GASTO VARCHAR2(50 CHAR):= 'GPV_GASTOS_PROVEEDOR'; 
    V_TABLA_LINEA VARCHAR2(100 CHAR):='GLD_GASTOS_LINEA_DETALLE'; 
    V_TABLA_ENTIDAD VARCHAR2(100 CHAR):='GLD_ENT'; 

	V_COUNT NUMBER(16); -- Vble. para comprobar

    
    --ACT_NUM_ACTIVO        GPV_NUM_GASTO_HAYA      GLD_PARTICIPACION_GASTO
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('7276532','12587405','6,6425'),
            T_TIPO_DATA('7265742','12587405','5,9480'),
            T_TIPO_DATA('7254594','12587405','10,4638'),
            T_TIPO_DATA('7265739','12587405','3,8385'),
            T_TIPO_DATA('7230783','12587405','2,1708'),
            T_TIPO_DATA('7270043','12587405','8,0642'),
            T_TIPO_DATA('7263457','12587405','4,9820'),
            T_TIPO_DATA('7243866','12587405','8,2676'),
            T_TIPO_DATA('7260564','12587405','12,8935'),
            T_TIPO_DATA('7253030','12587405','6,9241'),
            T_TIPO_DATA('7239496','12587405','7,9364'),
            T_TIPO_DATA('7250125','12587405','5,8296'),
            T_TIPO_DATA('7254851','12587405','5,6142'),
            T_TIPO_DATA('7265738','12587405','6,1639'),
            T_TIPO_DATA('7265743','12587405','4,2609'),
            T_TIPO_DATA('7054268','12587406','25,6404'),
            T_TIPO_DATA('7052951','12587406','8,8738'),
            T_TIPO_DATA('7052955','12587406','9,7505'),
            T_TIPO_DATA('7052958','12587406','9,9128'),
            T_TIPO_DATA('7040208','12587406','10,6847'),
            T_TIPO_DATA('7052950','12587406','12,3996'),
            T_TIPO_DATA('7048238','12587406','22,7381'),
            T_TIPO_DATA('7051806','12620581','21,6103'),
            T_TIPO_DATA('7056086','12620581','3,4588'),
            T_TIPO_DATA('7056089','12620581','4,3171'),
            T_TIPO_DATA('7044969','12620581','16,4158'),
            T_TIPO_DATA('7036350','12620581','20,2818'),
            T_TIPO_DATA('7050836','12620581','17,9450'),
            T_TIPO_DATA('7056126','12620581','4,8162'),
            T_TIPO_DATA('7056122','12620581','6,3143'),
            T_TIPO_DATA('7056097','12620581','4,8408'),
            T_TIPO_DATA('7257354','12620580','13,7091'),
            T_TIPO_DATA('7257096','12620580','9,0655'),
            T_TIPO_DATA('7258727','12620580','11,3302'),
            T_TIPO_DATA('7253815','12620580','6,7504'),
            T_TIPO_DATA('7237658','12620580','14,0315'),
            T_TIPO_DATA('7253806','12620580','15,3728'),
            T_TIPO_DATA('7253972','12620580','14,9650'),
            T_TIPO_DATA('7254557','12620580','14,7754'),
            T_TIPO_DATA('7258507','12623290','46,6201'),
            T_TIPO_DATA('7254001','12623290','53,3799'),
            T_TIPO_DATA('7044550','12619672','27,8421'),
            T_TIPO_DATA('7048982','12619672','33,1413'),
            T_TIPO_DATA('7050425','12619672','39,0166'),
            T_TIPO_DATA('7035983','12619663','28,9443'),
            T_TIPO_DATA('7033656','12619663','10,9537'),
            T_TIPO_DATA('7036823','12619663','16,5987'),
            T_TIPO_DATA('7053488','12619663','10,1011'),
            T_TIPO_DATA('7051315','12619663','33,4022'),
            T_TIPO_DATA('7256892','12619664','7,8779'),
            T_TIPO_DATA('7240557','12619664','10,5749'),
            T_TIPO_DATA('7249438','12619664','6,1171'),
            T_TIPO_DATA('7252056','12619664','3,4639'),
            T_TIPO_DATA('7242661','12619664','13,8505'),
            T_TIPO_DATA('7284875','12619664','4,0409'),
            T_TIPO_DATA('7258096','12619664','12,8183'),
            T_TIPO_DATA('7257133','12619664','16,5830'),
            T_TIPO_DATA('7249553','12619664','8,9099'),
            T_TIPO_DATA('7249404','12619664','5,0980'),
            T_TIPO_DATA('7261253','12619664','8,2238'),
            T_TIPO_DATA('7246877','12619664','2,4419'),
            T_TIPO_DATA('7052733','12619671','11,1077'),
            T_TIPO_DATA('7037678','12619671','37,2525'),
            T_TIPO_DATA('7055988','12619671','13,6307'),
            T_TIPO_DATA('7038861','12619671','27,4413'),
            T_TIPO_DATA('7040511','12619671','10,5678'),
            T_TIPO_DATA('7277996','12619670','12,3135'),
            T_TIPO_DATA('7230797','12619670','3,1282'),
            T_TIPO_DATA('7254087','12619670','8,4157'),
            T_TIPO_DATA('7262607','12619670','1,9520'),
            T_TIPO_DATA('7250563','12619670','12,0292'),
            T_TIPO_DATA('7250558','12619670','8,0131'),
            T_TIPO_DATA('7234252','12619670','3,0990'),
            T_TIPO_DATA('7254743','12619670','12,5222'),
            T_TIPO_DATA('7275760','12619670','6,9626'),
            T_TIPO_DATA('7280106','12619670','11,4461'),
            T_TIPO_DATA('7234273','12619670','3,4848'),
            T_TIPO_DATA('7250124','12619670','4,0874'),
            T_TIPO_DATA('7243084','12619670','12,5460'),
            T_TIPO_DATA('7032803','12614011','12,8829'),
            T_TIPO_DATA('7043441','12614011','17,5948'),
            T_TIPO_DATA('7045086','12614011','22,5707'),
            T_TIPO_DATA('7052046','12614011','22,7991'),
            T_TIPO_DATA('7050698','12614011','24,1525'),
            T_TIPO_DATA('7261916','12614365','28,2249'),
            T_TIPO_DATA('7241781','12614365','15,9669'),
            T_TIPO_DATA('7241782','12614365','19,3808'),
            T_TIPO_DATA('7261517','12614365','36,4273'),
            T_TIPO_DATA('7036185','12619666','46,9344'),
            T_TIPO_DATA('7052082','12619666','16,3569'),
            T_TIPO_DATA('7046557','12619666','36,7087'),
            T_TIPO_DATA('7045830','12619667','5,9976'),
            T_TIPO_DATA('7044140','12619667','17,1040'),
            T_TIPO_DATA('7045202','12619667','15,1717'),
            T_TIPO_DATA('7048175','12619667','12,7132'),
            T_TIPO_DATA('7043933','12619667','19,3067'),
            T_TIPO_DATA('7044716','12619667','7,1628'),
            T_TIPO_DATA('7048440','12619667','12,9870'),
            T_TIPO_DATA('7046233','12619667','9,5570'),
            T_TIPO_DATA('7050698','12619669','21,4619'),
            T_TIPO_DATA('7045830','12619669','16,8130'),
            T_TIPO_DATA('7045202','12619669','21,8429'),
            T_TIPO_DATA('7046233','12619669','39,8823'),
            T_TIPO_DATA('7055847','12619640','50,9430'),
            T_TIPO_DATA('7055874','12619640','49,0570'),
            T_TIPO_DATA('7238610','12619641','12,9872'),
            T_TIPO_DATA('7270626','12619641','9,9773'),
            T_TIPO_DATA('7233687','12619641','24,5168'),
            T_TIPO_DATA('7252434','12619641','29,1882'),
            T_TIPO_DATA('7245825','12619641','13,1124'),
            T_TIPO_DATA('7233670','12619641','10,2182')


    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS PROVEEDOR PREFACTURAS');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos que existe el activo, el gasto y que esten asociados a traves de la linea de detalle
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_GASTO||' GPV
                    JOIN '||V_ESQUEMA||'.'||V_TABLA_LINEA||' GLD ON GPV.GPV_ID=GLD.GPV_ID
                    JOIN '||V_ESQUEMA||'.'||V_TABLA_ENTIDAD||' GLENT ON GLENT.GLD_ID=GLD.GLD_ID
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=GLENT.ENT_ID
                    WHERE GPV.GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(2)||''' AND ACT.ACT_NUM_ACTIVO='''||V_TMP_TIPO_DATA(1)||'''
                    AND GPV.BORRADO=0 AND ACT.BORRADO=0 AND GLD.BORRADO=0 AND GLENT.BORRADO=0 ';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

        IF V_COUNT = 1 THEN

            --Obtenemos el id de la entidad

             V_MSQL := 'SELECT GLENT.GLD_ENT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_GASTO||' GPV
                    JOIN '||V_ESQUEMA||'.'||V_TABLA_LINEA||' GLD ON GPV.GPV_ID=GLD.GPV_ID
                    JOIN '||V_ESQUEMA||'.'||V_TABLA_ENTIDAD||' GLENT ON GLENT.GLD_ID=GLD.GLD_ID
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=GLENT.ENT_ID
                    WHERE GPV.GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(2)||''' AND ACT.ACT_NUM_ACTIVO='''||V_TMP_TIPO_DATA(1)||'''
                    AND GPV.BORRADO=0 AND ACT.BORRADO=0 AND GLD.BORRADO=0 AND GLENT.BORRADO=0 ';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;


            --Actualizamos el porcentaje de participacion del activo en el gasto
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_ENTIDAD||' SET
                    GLD_PARTICIPACION_GASTO='''||V_TMP_TIPO_DATA(3)||''',
                    USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE GLD_ENT_ID = '||V_ID||'';

            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: GASTO '''||V_TMP_TIPO_DATA(2)||''' CON ACTIVO '''||V_TMP_TIPO_DATA(2)||'''  ACTUALIZADO CON PORCENTAJE '''||V_TMP_TIPO_DATA(3)||'''');

            
        ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA RELACION ACTIVO:'''||V_TMP_TIPO_DATA(1)||''' GASTO: '''||V_TMP_TIPO_DATA(2)||''' PARTICIPACION: '''||V_TMP_TIPO_DATA(3)||'''');
        END IF;

    END LOOP;
     

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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
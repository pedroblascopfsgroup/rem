--##########################################
--## AUTOR=Enrique Jimenez Diaz
--## FECHA_CREACION=20151115
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-915
--## PRODUCTO=NO
--## 
--## Finalidad: Vincular Localidad y Provincia
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

 TYPE T_MPH IS TABLE OF VARCHAR2(1000);
 TYPE T_ARRAY_MPH IS TABLE OF T_MPH;


--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- '#ESQUEMA_MASTER#';      -- Configuracion Esquema Master 
 TABLADD1 VARCHAR(30) :='DD_PLA_PLAZAS';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR);
 V_MSQL1 VARCHAR2(8500 CHAR);
 V_VALOR VARCHAR (500 CHAR);

 V_MPH T_ARRAY_MPH := T_ARRAY_MPH(
                      T_MPH ( '1','ALAVA')
                    , T_MPH ( '2','ALBACETE')
                    , T_MPH ( '3','ALICANTE')
                    , T_MPH ( '4','ALMERIA')
                    , T_MPH ( '5','AVILA')
                    , T_MPH ( '6','BADAJOZ')
                    , T_MPH ( '7','BALEARES')
                    , T_MPH ( '8','BARCELONA')
                    , T_MPH ( '9','BURGOS')
                    , T_MPH ( '10','CACERES')
                    , T_MPH ( '11','CADIZ')
                    , T_MPH ( '12','CASTELLON DE LA PLANA')
                    , T_MPH ( '13','CIUDAD REAL')
                    , T_MPH ( '14','CORDOBA')
                    , T_MPH ( '15','CORUÑA, LA')
                    , T_MPH ( '16','CUENCA')
                    , T_MPH ( '17','GIRONA')
                    , T_MPH ( '18','GRANADA')
                    , T_MPH ( '19','GUADALAJARA')
                    , T_MPH ( '20','GUIPUZCOA')
                    , T_MPH ( '21','HUELVA')
                    , T_MPH ( '22','HUESCA')
                    , T_MPH ( '23','JAEN')
                    , T_MPH ( '24','LEON')
                    , T_MPH ( '25','LLEIDA')
                    , T_MPH ( '26','LOGROÑO')
                    , T_MPH ( '27','LUGO')
                    , T_MPH ( '28','MADRID')
                    , T_MPH ( '29','MALAGA')
                    , T_MPH ( '30','MURCIA')
                    , T_MPH ( '31','NAVARRA')
                    , T_MPH ( '32','ORENSE')
                    , T_MPH ( '33','OVIEDO')
                    , T_MPH ( '34','PALENCIA')
                    , T_MPH ( '35','LAS PALMAS')
                    , T_MPH ( '36','PONTEVEDRA')
                    , T_MPH ( '37','SALAMANCA')
                    , T_MPH ( '38','SANTA CRUZ DE TENERIFE')
                    , T_MPH ( '39','SANTANDER')
                    , T_MPH ( '40','SEGOVIA')
                    , T_MPH ( '41','SEVILLA')
                    , T_MPH ( '42','SORIA')
                    , T_MPH ( '43','TARRAGONA')
                    , T_MPH ( '44','TERUEL')
                    , T_MPH ( '45','TOLEDO')
                    , T_MPH ( '46','VALENCIA')
                    , T_MPH ( '47','VALLADOLID')
                    , T_MPH ( '48','VIZCAYA')
                    , T_MPH ( '49','ZAMORA')
                    , T_MPH ( '50','ZARAGOZA')
                    , T_MPH ( '51','CEUTA')
                    , T_MPH ( '52','MELILLA')
  );

 V_TMP_MPH T_MPH;

BEGIN
 FOR I IN V_MPH.FIRST .. V_MPH.LAST
 LOOP

   V_TMP_MPH := V_MPH(I);

  --INICIO UPDATE

    DBMS_OUTPUT.PUT_LINE('Vinculando Localidades para: '||V_TMP_MPH(2));   
   
    V_MSQL1 := 'UPDATE '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOCX SET LOCX.DD_PRV_ID = (select prv.dd_prv_id from '||V_ESQUEMA_M||q'[.DD_PRV_PROVINCIA prv where LPAD(prv.DD_PRV_CODIGO,2,'0') = LPAD(']'||V_TMP_MPH(1)||q'[',2,'0')) 
                WHERE LOCX.DD_PRV_ID = 0 
                    AND SUBSTR(LPAD(LOCX.DD_LOC_CODIGO, 5, '0'), 1, 2) = LPAD(']'||V_TMP_MPH(1)||q'[',2,'0')]';

    DBMS_OUTPUT.PUT_LINE ('Query: '||V_MSQL1);

    EXECUTE IMMEDIATE V_MSQL1;
    COMMIT;
   
   END LOOP;
   V_TMP_MPH := NULL;

 COMMIT;

EXCEPTION
WHEN OTHERS THEN
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);

  ROLLBACK;
  RAISE;
  
END;
/
EXIT;

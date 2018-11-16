--/*
--###########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20181106
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2485
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATE PROPIETARIOS DUPLICADOS Y REUNIFICARLOS
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


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
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-2485';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1500);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    ------ 	 		DNI
    T_TIPO_DATA('A12605416'),
    T_TIPO_DATA('A21135025'),
	T_TIPO_DATA('A09342965'),
	T_TIPO_DATA('B96921218'),
	T_TIPO_DATA('B11741402'),
	T_TIPO_DATA('B81786048'),
	T_TIPO_DATA('A96932629'),
	T_TIPO_DATA('B63540074'),
	T_TIPO_DATA('B83553578'),
	T_TIPO_DATA('B14720189'),
	T_TIPO_DATA('B82112517'),
	T_TIPO_DATA('B62994652'),
	T_TIPO_DATA('B26024463'),
	T_TIPO_DATA('A05168646'),
	T_TIPO_DATA('B64534308'),
	T_TIPO_DATA('XXA14010342'),
	T_TIPO_DATA('B53399846'),
	T_TIPO_DATA('B86053394'),
	T_TIPO_DATA('B13397286'),
	T_TIPO_DATA('B58433640'),
	T_TIPO_DATA('V84325927'),
	T_TIPO_DATA('A28964906'),
	T_TIPO_DATA('B02341329'),
	T_TIPO_DATA('V83829614'),
	T_TIPO_DATA('V84776335'),
	T_TIPO_DATA('B80182017'),
    T_TIPO_DATA('V86097979')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para actualizar los valores en ECO_CONDICIONANTES_EXPEDIENTE -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE PROPIETARIOS PARA REUNIFICAR PROPIETARIOS DUPLICADOS');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO where PRO_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
		
        --DBMS_OUTPUT.PUT_LINE(V_SQL);		
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        --DBMS_OUTPUT.PUT_LINE(V_NUM_TABLAS);
			--Si existe realizamos otra comprobacion
			IF V_NUM_TABLAS > 1 THEN	
			
					V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO SET BORRADO = 1 ,
																			  FECHABORRAR = SYSDATE,
																			  USUARIOBORRAR = '''||V_USUARIO||''' 
								WHERE PRO_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND 
									  (PRO_ID NOT IN (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND ROWNUM = 1))
									';
					--DBMS_OUTPUT.PUT_LINE(V_MSQL);
					EXECUTE IMMEDIATE V_MSQL;	
					
					V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO SET PRO_ID = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND ROWNUM = 1),
                                            USUARIOMODIFICAR = '''||V_USUARIO||''',
                                            FECHAMODIFICAR = SYSDATE
								WHERE PRO_ID IN (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(1))||''')';
					--DBMS_OUTPUT.PUT_LINE(V_MSQL);
					EXECUTE IMMEDIATE V_MSQL;
					
			--El propietario no existe
			ELSE
				  DBMS_OUTPUT.PUT_LINE('[ERROR]:  NO EXISTE EL PROPIETARIO CON ID '||TRIM(V_TMP_TIPO_DATA(1))||' ');
			END IF;
		
    END LOOP;
    --ROLLBACK;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]:  LOS PROPIETARIOS HAN SIDO FUSIONADOS ');

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

--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20170116
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3550
--## PRODUCTO=NO
--##
--## Finalidad: Actualizacion de la vigencia de las agrupaciones
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
    TICKET_TRABAJO VARCHAR2(25 CHAR):= 'HREOS-3550';   
    

    -- ARRAY PARA MODIFICAR AGR_ELIMINADO EN AGRUPACIONES REACTIVADAS INCORRECTAMENTE
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--		AGR_NUM_AGRUP_REM 
		T_TIPO_DATA('2201015'),
		T_TIPO_DATA('2672893'),
		T_TIPO_DATA('4384735'),
		T_TIPO_DATA('5179957'),
		T_TIPO_DATA('6138922'),
		T_TIPO_DATA('7014452'),
		T_TIPO_DATA('7307720'),
		T_TIPO_DATA('7308039'),
		T_TIPO_DATA('7396179'),
		T_TIPO_DATA('1971329'),
		T_TIPO_DATA('2728098'),
		T_TIPO_DATA('4790139'),
		T_TIPO_DATA('7354816'),
		T_TIPO_DATA('8380326'),
		T_TIPO_DATA('7354320')		
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    -- ARRAY PARA LA REACTIVACION DE AGRUPACIONES
    TYPE T_TIPO_DATA_2 IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_2 IS TABLE OF T_TIPO_DATA_2;
    V_TIPO_DATA_2 T_ARRAY_DATA_2 := T_ARRAY_DATA_2(
    	--		AGR_NUM_AGRUP_REM	AGR_INI_VIGENCIA 	AGR_FIN_VIGENCIA 
		T_TIPO_DATA_2('2352978','23/11/2017','20/05/2018'),
		T_TIPO_DATA_2('4485787','20/12/2017','28/12/2018'),
		T_TIPO_DATA_2('3246726','18/12/2017','12/01/2019'),
		T_TIPO_DATA_2('6583060','13/12/2017','05/12/2018'),
		T_TIPO_DATA_2('7191672','03/01/2018','29/07/2018')
	); 
    V_TMP_TIPO_DATA_2 T_TIPO_DATA_2;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');


-- LOOP PARA BORRAR AGR_ELIMINADO DE LAS AGRUPACIONES MAL REACTIVADAS-----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN ACT_AGR_AGRUPACION, BORRAR AGR_ELIMINADO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE AGR_NUM_AGRUP_REM ='||TRIM(V_TMP_TIPO_DATA(1))||'';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos realizamos el update
        IF V_NUM_TABLAS > 0 THEN		

			  DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
			  V_MSQL := 'UPDATE REM01.ACT_AGR_AGRUPACION AGR
						SET AGR.AGR_ELIMINADO = 0,
						AGR.USUARIOMODIFICAR = '''||TICKET_TRABAJO||''',
						AGR.FECHAMODIFICAR = SYSDATE
						WHERE AGR.AGR_NUM_AGRUP_REM LIKE '|| TRIM(V_TMP_TIPO_DATA(1)) ||' AND AGR.AGR_ELIMINADO = 1
			  ';
			  EXECUTE IMMEDIATE V_MSQL;
			  DBMS_OUTPUT.PUT_LINE('[INFO]: LA AGRUPACION CON  AGR_NUM_AGRUP_REM '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' HA SIDO MODIFICADA CORRECTAMENTE');  
			
       --La agrupación no existe  
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: LA AGRUPACION CON AGR_NUM_AGRUP_REM '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' NO EXISTE');   
        
       END IF;
    END LOOP;

	 
    -- LOOP-----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN ACT_AGR_AGRUPACION, ACTUALIZAR INICIO VIGENCIA Y FIN VIGENCIA] ');
    FOR I IN V_TIPO_DATA_2.FIRST .. V_TIPO_DATA_2.LAST
      LOOP
      
        V_TMP_TIPO_DATA_2 := V_TIPO_DATA_2(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE AGR_NUM_AGRUP_REM ='||TRIM(V_TMP_TIPO_DATA_2(1))||'';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos realizamos el update
        IF V_NUM_TABLAS > 0 THEN		
				
        	--FECHA BAJA,AGR_ELIMINADO, FECHA INICIO VIGENCIA, FECHA FIN VIGENIA
			  DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA_2(1)) ||''' ');
			  V_MSQL := 'UPDATE REM01.ACT_AGR_AGRUPACION AGR
						SET AGR.AGR_INI_VIGENCIA = TO_DATE('''||TRIM(V_TMP_TIPO_DATA_2(2))||''', ''DD/MM/YYYY''),
						AGR.AGR_FIN_VIGENCIA = TO_DATE('''||TRIM(V_TMP_TIPO_DATA_2(3))||''', ''DD/MM/YYYY''),
						AGR.AGR_FECHA_BAJA= NULL,
						AGR.AGR_ELIMINADO= 0,
						AGR.USUARIOMODIFICAR = '''||TICKET_TRABAJO||''',
						AGR.FECHAMODIFICAR = SYSDATE
						WHERE AGR.AGR_NUM_AGRUP_REM = '|| TRIM(V_TMP_TIPO_DATA_2(1)) ||'
			  ';
			  EXECUTE IMMEDIATE V_MSQL;
			  DBMS_OUTPUT.PUT_LINE('[INFO]: LA AGRUPACION CON  AGR_NUM_AGRUP_REM '''|| TRIM(V_TMP_TIPO_DATA_2(1)) ||''' HA SIDO MODIFICADA CORRECTAMENTE'); 
			  
			  
			 --PACK INCLUIDO Y CHECK COMERCIALZABLE
			 EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC USING(
				  SELECT DISTINCT AGR.AGR_NUM_AGRUP_REM, ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
				    JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID=ACT.ACT_ID
				    JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID=AGR.AGR_ID
				    WHERE AGR.AGR_NUM_AGRUP_REM= '|| TRIM(V_TMP_TIPO_DATA_2(1)) ||'
				  )PDV
				ON(PDV.ACT_ID=PAC.ACT_ID)
				WHEN MATCHED THEN UPDATE
				  SET PAC.PAC_INCLUIDO=1,
				  PAC.PAC_CHECK_COMERCIALIZAR=1,
				  PAC.USUARIOMODIFICAR='''||TICKET_TRABAJO||''',
				  PAC.FECHAMODIFICAR=SYSDATE';
				  
				  
			--ACTIVO COMERCIALIZABLE (OISPONIBLE PARA LA VENTA)	  
			EXECUTE IMMEDIATE 'merge into '||V_ESQUEMA||'.act_activo t1 using(
			  select distinct act.act_num_activo from '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO aga 
			  join '||V_ESQUEMA||'.act_activo act on act.act_id=aga.act_id
			  join '||V_ESQUEMA||'.act_agr_agrupacion agr on agr.agr_id=aga.agr_id
			  join '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL scm on scm.dd_scm_id=act.dd_scm_id
			  WHERE AGR.AGR_NUM_AGRUP_REM= '|| TRIM(V_TMP_TIPO_DATA_2(1)) ||' and scm.dd_scm_id != (select DD_SCM_ID from '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL where DD_SCM_CODIGO = ''05'')
			  )t2
			on (t1.act_num_activo=t2.act_num_activo)
			when matched then update
			  set t1.dd_scm_id= (SELECT DD_SCM_ID FROM DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO=''02''), 
			  t1.usuariomodificar='''||TICKET_TRABAJO||''',
			  t1.fechamodificar=sysdate';
			
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: LA AGRUPACION CON AGR_NUM_AGRUP_REM '''|| TRIM(V_TMP_TIPO_DATA_2(1)) ||''' NO EXISTE');   
        
       END IF;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_AGR_AGRUPACION ACTUALIZADA CORRECTAMENTE ');
   

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
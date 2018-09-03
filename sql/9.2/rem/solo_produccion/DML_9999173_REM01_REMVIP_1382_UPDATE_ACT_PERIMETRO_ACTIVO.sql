--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20180802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1382
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

   PAC_INC NUMBER(32):= 0;
   PAC_CHECK_TRA_ADM NUMBER(32):= 0;
   PAC_CHECK_GEST NUMBER(32):= 0;
   PAC_CHECK_ASIGNAR_MED NUMBER(32):= 0;
   PAC_CHECK_COMERC NUMBER(32):= 0;
   PAC_CHECK_FORM NUMBER(32):= 0;
   PL_OUTPUT VARCHAR2(1024 CHAR);
   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar        
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ACT_ID NUMBER(32);
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   DESCRIPCION VARCHAR2(64 CHAR);
   V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
   V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-1382';

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('5950912'),
		T_TIPO_DATA('6055272'),
		T_TIPO_DATA('5985678'),		
		T_TIPO_DATA('6014229')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: COMIENZA EL PROCESO');
		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
      
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
				
				DBMS_OUTPUT.PUT_LINE('[INFO]: SE INICIA LA DESPUBLICACIÓN DEL ACTIVO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''...');
				
				--Comprobamos si el activo a despublicar existe
				V_SQL := 'SELECT COUNT(1)  
						FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
						WHERE ACT.ACT_NUM_ACTIVO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
						';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
				--Si existe iniciamos la despublicación
				IF V_NUM_TABLAS = 1 THEN				

				V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC SET
							  PAC_INCLUIDO = '||PAC_INC||'
							, PAC_CHECK_TRA_ADMISION = '||PAC_CHECK_TRA_ADM||'
							, PAC_CHECK_GESTIONAR = '||PAC_CHECK_GEST||'
							, PAC_CHECK_ASIGNAR_MEDIADOR = '||PAC_CHECK_ASIGNAR_MED||'
							, PAC_CHECK_COMERCIALIZAR = '||PAC_CHECK_COMERC||'
							, PAC_CHECK_FORMALIZAR = '||PAC_CHECK_FORM||' 
							, USUARIOMODIFICAR  = '''||V_USUARIO||''' 
          						, FECHAMODIFICAR    = SYSDATE 
						WHERE PAC.ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''')';
						 
				EXECUTE IMMEDIATE V_SQL;
	
				PL_OUTPUT := '[INFO] actualizado el perímetro del activo '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' a '||' 
							  PAC_INCLUIDO = '||PAC_INC||'
							, PAC_CHECK_TRA_ADMISION = '||PAC_CHECK_TRA_ADM||'
							, PAC_CHECK_GESTIONAR = '||PAC_CHECK_GEST||'
							, PAC_CHECK_ASIGNAR_MEDIADOR = '||PAC_CHECK_ASIGNAR_MED||'
							, PAC_CHECK_COMERCIALIZAR = '||PAC_CHECK_COMERC||'
							, PAC_CHECK_FORMALIZAR = '||PAC_CHECK_FORM||'';

 				DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

				--Si existe, no hacemos nada   
				ELSE
					DBMS_OUTPUT.PUT_LINE('[INFO]: EL ACTIVO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' NO EXISTE');        
				END IF;			
      END LOOP;


COMMIT;
 DBMS_OUTPUT.PUT_LINE('[FIN]: ACTIVOS SACAR FUERA DEL PERIMETRO HAYA CORRECTAMENTE');   

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END UPDATE_PAC;
/
EXIT;

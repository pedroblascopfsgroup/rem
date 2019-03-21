--/*
--##########################################
--## AUTOR=PIER GOTTA 
--## FECHA_CREACION=20181119
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2567
--## PRODUCTO=NO
--##
--## Finalidad: Insertar todas nuevas gestorias de Bankia
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_INSERT NUMBER(16) := 0;
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'ACT_PVE_PROVEEDOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA2 VARCHAR2(32 CHAR) := 'DD_TPR_TIPO_PROVEEDOR';
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-2567';
	DD_TPR_ID NUMBER(16);
	PVE_COD_API_PROVEEDOR VARCHAR2(32 CHAR);
	PVE_NOMBRE VARCHAR2(128 CHAR);
	PVE_DIRECCION VARCHAR2(128 CHAR);
	PVE_CP VARCHAR2(16 CHAR);
	DD_PRV_ID NUMBER(16);
	DD_LOC_ID NUMBER(16);
	PVE_TELF_CONTACTO_VIS VARCHAR2(16 CHAR);
	PVE_FAX VARCHAR2(16 CHAR);
	
	TYPE T_JBV IS TABLE OF VARCHAR2(32000);
 	TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
  T_JBV('','          GESTORIA MARETRA          ','                              CARLOS MARTIN ALVAREZ                                       0021                  00                              ','28018','0','00000')
, T_JBV('','          GESTORIA QIPERT          	','                              CARLOS MARTIN ALVAREZ                                       0021                  00                              ','28018','0','00000')
, T_JBV('','          GESTORIA MEDITERRANEO          ','                         CARLOS MARTIN ALVAREZ                                       0021                  00                              ','28018','0','00000')
, T_JBV('','          GESTORIA GESTINOVA          ','                            CARLOS MARTIN ALVAREZ                                       0021                  00                              ','28018','0','00000')
, T_JBV('','          GESTORIA EMAIS          ','                                CARLOS MARTIN ALVAREZ                                       0021                  00                              ','28018','0','00000')
, T_JBV('','          GESTORIA F&G          ','                                  CARLOS MARTIN ALVAREZ                                       0021                  00                              ','28018','0','00000'));
V_TMP_JBV T_JBV;
	
    
 BEGIN
 
 DBMS_OUTPUT.PUT_LINE('Se va a proceder a insertar las nuevas gestorias');
 
 EXECUTE IMMEDIATE 'SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.'||V_TABLA2||' WHERE DD_TPR_CODIGO = ''01''' INTO DD_TPR_ID;
 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
 
 V_TMP_JBV := V_JBV(I);
 			  PVE_COD_API_PROVEEDOR	:= TRIM(V_TMP_JBV(1));
 			  PVE_NOMBRE 			:= TRIM(V_TMP_JBV(2));
 			  PVE_DIRECCION 		:= TRIM(V_TMP_JBV(3));
 			  PVE_CP 				:= TRIM(V_TMP_JBV(4));
 			  
 			  EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = '''||TRIM(V_TMP_JBV(5))||'''' INTO V_COUNT;
 			  
 			  IF V_COUNT > 0 THEN
 			 	 V_SQL := 'SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = '''||TRIM(V_TMP_JBV(5))||'''';
             	 EXECUTE IMMEDIATE V_SQL INTO DD_PRV_ID;
              ELSE
              	DD_PRV_ID := NULL;
              END IF;
              
              EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = '''||TRIM(V_TMP_JBV(6))||'''' INTO V_COUNT;
              
              IF V_COUNT > 0 THEN
              	V_SQL := 'SELECT DD_LOC_ID FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = '''||TRIM(V_TMP_JBV(6))||'''';
 			  	EXECUTE IMMEDIATE V_SQL INTO DD_LOC_ID;
 			  ELSE
              	DD_LOC_ID := NULL;
              END IF;

	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' 
						WHERE PVE_COD_API_PROVEEDOR = '''||PVE_COD_API_PROVEEDOR||'''
						AND DD_TPR_ID = '||DD_TPR_ID INTO V_COUNT;
 IF V_COUNT = 0 THEN
   V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
 			  PVE_COD_API_PROVEEDOR
 			, PVE_ID
 			, PVE_COD_REM
 			, PVE_NOMBRE
			, PVE_NOMBRE_COMERCIAL
			, PVE_DIRECCION
			, PVE_CP
			, DD_PRV_ID
			, DD_LOC_ID
			, PVE_TELF_CONTACTO_VIS
			, PVE_FAX
			, DD_TPR_ID
			, DD_TPE_ID
			, DD_EPR_ID
			, PVE_AMBITO
			, PVE_HOMOLOGADO
			, USUARIOCREAR
			, FECHACREAR
 			) VALUES (
 			    '''||PVE_COD_API_PROVEEDOR||'''
 			  , S_'||V_TABLA||'.NEXTVAL
 			  , S_PVE_COD_REM.NEXTVAL
 			  , '''||PVE_NOMBRE||'''
 			  , '''||PVE_NOMBRE||'''
 			  , '''||PVE_DIRECCION||'''
 			  , '''||PVE_CP||'''
 			  , '''||DD_PRV_ID||'''
 			  , '''||DD_LOC_ID||'''
 			  , '''||PVE_TELF_CONTACTO_VIS||'''
 			  , '''||PVE_FAX||'''
 			  , '''||DD_TPR_ID||'''
			  , ''102''
			  , ''4''
			  , ''Nacional''
			  , ''1''
 			  , '''||V_USUARIO||'''
 			  , SYSDATE
 			)
		  ';
		  
		  EXECUTE IMMEDIATE V_SQL;
		  V_COUNT_INSERT := V_COUNT_INSERT + 1;
  END IF;
 END LOOP;
 
  DBMS_OUTPUT.PUT_LINE('Se han insertado '||V_COUNT_INSERT||' registros en la tabla '||V_TABLA);

 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;


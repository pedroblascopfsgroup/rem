--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v2.0.14-rem
--## INCIDENCIA_LINK=HREOS-3705
--## PRODUCTO=NO
--##
--## Finalidad: Nueva tarifa para Bankia, dentro del tipo "cambio de cerradura" y "Toma de posesión":
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
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TABLA_CONFIG VARCHAR2(100 CHAR):= 'ACT_CFT_CONFIG_TARIFA';
    V_TABLA_TARIFA VARCHAR2(100 CHAR):= 'DD_TTF_TIPO_TARIFA';
    V_CODIGO VARCHAR2(32 CHAR) := 'BK-CER16';
    V_HREOS VARCHAR2(100 CHAR):= 'HREOS-3705';
    V_ENTIDAD_ID NUMBER(16);
    V_DD_TTF_ID NUMBER(16);
    DD_TTR_ID NUMBER(16);
    DD_STR_ID_1 NUMBER(16);
    DD_STR_ID_2 NUMBER(16);
    DD_CRA_ID NUMBER(16);

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_TARIFA||' WHERE DD_TTF_CODIGO = '''||V_CODIGO||'''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	
	IF V_COUNT = 0 THEN
	
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TARIFA||' (
		  DD_TTF_ID
		, DD_TTF_CODIGO
		, DD_TTF_DESCRIPCION
		, DD_TTF_DESCRIPCION_LARGA
		, USUARIOCREAR
		, FECHACREAR
		) VALUES 
		(
		  S_'||V_TABLA_TARIFA||'.NEXTVAL
		, '''||V_CODIGO||'''
		, ''FEE''
		, ''FEE''
		, '''||V_HREOS||'''
		, SYSDATE
		)
		';
    
    EXECUTE IMMEDIATE V_SQL;
    
	DBMS_OUTPUT.PUT_LINE('[INFO] La tarifa '||V_CODIGO||' ha sido insertada en la tabla '||V_TABLA_TARIFA||' con éxito');
	
	ELSE
	
	DBMS_OUTPUT.PUT_LINE('[INFO] La tarifa '||V_CODIGO||' ya existia en la tabla '||V_TABLA_TARIFA);
	
	END IF;
    
	--La id que hemos insertado antes en la tabla de tarifa
	V_SQL := 'SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TARIFA||' WHERE DD_TTF_CODIGO = '''||V_CODIGO||'''';
	    
	EXECUTE IMMEDIATE V_SQL INTO V_DD_TTF_ID;
    
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_CONFIG||' WHERE DD_TTF_ID = '||V_DD_TTF_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	
	IF V_COUNT = 0 THEN

	--Tipo trabajo actuación técnica
	V_SQL := 'SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = ''03''';
	
	EXECUTE IMMEDIATE V_SQL INTO DD_TTR_ID;

	--Subtrabajo toma de posesión
	V_SQL := 'SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = ''57''';	

	EXECUTE IMMEDIATE V_SQL INTO DD_STR_ID_1;

	--Subtrabajo cambio de cerradura
	V_SQL := 'SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = ''26''';
	
	EXECUTE IMMEDIATE V_SQL INTO DD_STR_ID_2;
	
	--ID de la cartera
	V_SQL := 'SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''03''';
	
	EXECUTE IMMEDIATE V_SQL INTO DD_CRA_ID;


	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_CONFIG||' (
		  CFT_ID
		, DD_TTF_ID
		, DD_TTR_ID
		, DD_STR_ID
		, DD_CRA_ID
		, CFT_PRECIO_UNITARIO
		, CFT_UNIDAD_MEDIDA
		, USUARIOCREAR
		, FECHACREAR
		) VALUES 
		(
		  S_'||V_TABLA_CONFIG||'.NEXTVAL
		, '||V_DD_TTF_ID||'
		, '||DD_TTR_ID||'
		, '||DD_STR_ID_1||'
		, '||DD_CRA_ID||'
		, 20.00
		, ''€/un''
		, '''||V_HREOS||'''
		, SYSDATE
		)
		';
		
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_CONFIG||' (
		  CFT_ID
		, DD_TTF_ID
		, DD_TTR_ID
		, DD_STR_ID
		, DD_CRA_ID
		, CFT_PRECIO_UNITARIO
		, CFT_UNIDAD_MEDIDA
		, USUARIOCREAR
		, FECHACREAR
		) VALUES 
		(
		  S_'||V_TABLA_CONFIG||'.NEXTVAL
		, '||V_DD_TTF_ID||'
		, '||DD_TTR_ID||'
		, '||DD_STR_ID_2||'
		, '||DD_CRA_ID||'
		, 20.00
		, ''€/un''
		, '''||V_HREOS||'''
		, SYSDATE
		)
		';
        
		
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] La tarifa '||V_CODIGO||' ha sido insertada en la tabla '||V_TABLA_CONFIG||' con éxito');
	
	ELSE
	
	DBMS_OUTPUT.PUT_LINE('[INFO] La tarifa '||V_CODIGO||' ya existia en la tabla '||V_TABLA_CONFIG);
	
	END IF;

COMMIT;	

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

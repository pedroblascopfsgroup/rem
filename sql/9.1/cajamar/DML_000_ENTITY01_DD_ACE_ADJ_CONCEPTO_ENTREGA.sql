--/*
--##########################################
--## AUTOR=Gonzalo E
--## FECHA_CREACION=20150721
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-368
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
BEGIN
	DBMS_OUTPUT.PUT_LINE('******** DD_ACE_ADJ_CONCEPTO_ENTREGA ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''001'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''001'',''Entrega primer reclamado'',''Entrega primer reclamado'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''002'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''002'',''Entrega judicial por devolución de remanentes'',''Entrega judicial por devolución de remanentes'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;
	
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''003'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''003'',''Adjudicación'',''Adjudicación'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;


    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''004'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''004'',''Cesión de crédito'',''Cesión de crédito'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;
	
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''005'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''005'',''Quita/Condonación (acuerdo)'',''Quita/Condonación (acuerdo)'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''006'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''006'',''Quita/Condona./Cancel (Res. jud. o conc.)'',''Quita/condonación/Cancelación (Resolución judicial o concurso)'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;


    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''007'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''007'',''Traspaso a quebrantos (incidencias de gestión)'',''Traspaso a quebrantos (incidencias de gestión)'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;
	
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''008'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''008'',''Preinscripción'',''Preinscripción'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''009'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''009'',''Rehabilitación por obligación legal judicial'',''Rehabilitación por obligación legal judicial'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;
	
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''010'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''010'',''Rehabilitación por obligación legal extrajudicial'',''Rehabilitación por obligación legal extrajudicial'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''011'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''011'',''Rehabilitado por Entidad'',''Rehabilitado por Entidad'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''012'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''012'',''Entrega otros reclamados'',''Entrega otros reclamados'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''013'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''013'',''Reactivación'',''Reactivación'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;
	
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''014'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''014'',''Quita por convenio de acreedores'',''Quita por convenio de acreedores'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''015'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''015'',''Cobro por convenio de acreedores'',''Cobro por convenio de acreedores'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''016'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''016'',''Entrega terceros por cuenta del relcamado'',''Entrega terceros por cuenta del relcamado'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;
	
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''017'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''017'',''Traspaso por depósitos de los reclamados'',''Traspaso por depósitos de los reclamados'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''018'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''018'',''Refinanciación/Reinstrumentación'',''Refinanciación/Reinstrumentación'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;
	
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''019'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''019'',''Dación en pago de deuda'',''Dación en pago de deuda'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;
	
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''020'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''020'',''Entrega judicial por retención de haberes'',''Entrega judicial por retención de haberes'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''021'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''021'',''Cesión de remate'',''Cesión de remate'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA WHERE DD_ACE_CODIGO = ''022'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro en la tabla '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID,DD_ACE_CODIGO,DD_ACE_DESCRIPCION,DD_ACE_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES('||V_ESQUEMA||
		'.S_DD_ACE_ADJ_CONCEPTO_ENTREGA.nextval,''022'',''Entrega judicial por consignación de deuda'',''Entrega judicial por consignación de deuda'', 0, ''DML'', sysdate, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_ACE_ADJ_CONCEPTO_ENTREGA.');
	END IF;
	
    COMMIT;
	
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

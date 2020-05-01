--/*
--###########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200501
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7208
--## PRODUCTO=NO
--## 
--## Finalidad:
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
  V_NUM_ACT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_COUNT1 NUMBER(16);
  V_COUNT2 NUMBER(16);
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIOMODIFICAR VARCHAR2(100 CHAR) := 'REMVIP-7208';
  
  TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
  V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION(6003008),
      T_FUNCION(6012366),
      T_FUNCION(6010310),
      T_FUNCION(6010309),
      T_FUNCION(6012771),
      T_FUNCION(6012817),
      T_FUNCION(6012843)
    ); 
  V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR COMPRADORES EXPEDIENTE ' );
	FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST 
	LOOP
		V_TMP_FUNCION := V_FUNCION(I);
		V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE WHERE COM_ID IN (SELECT COM_ID FROM (SELECT CEX.COM_ID, 
					ROW_NUMBER() OVER (PARTITION BY CEX.ECO_ID ORDER BY CEX.COM_ID DESC) AS RN FROM '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE CEX
					INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = CEX.ECO_ID
					INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
					WHERE OFR.OFR_NUM_OFERTA = '||V_TMP_FUNCION(1)||') WHERE RN <> 1)';

       	EXECUTE IMMEDIATE V_MSQL;	

    	DBMS_OUTPUT.PUT_LINE('[INFO] BORRADOS '||SQL%ROWCOUNT||' registros en CEX_COMPRADOR_EXPEDIENTE');  
	END LOOP;

    DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADOS TODOS LOS CEX_COMPRADOR_EXPEDIENTE ' );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] ');

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

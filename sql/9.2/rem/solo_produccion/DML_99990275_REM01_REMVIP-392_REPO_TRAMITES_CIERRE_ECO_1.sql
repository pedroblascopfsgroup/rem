--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180328
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-392
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-392_2';
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    PL_OUTPUT VARCHAR2(32000 CHAR);

BEGIN
  
    #ESQUEMA#.REPOSICIONAMIENTO_TRAMITE('REMVIP-392_2','100596,
100603,
100606,
100610,
100628,
100643,
100663,
100678,
100682,
100694,
100701,
100704,
100709,
100716,
100733,
100764,
100766,
100000,
100015,
100025,
100160,
100161,
100169,
100177,
100182,
100187,
99949,
100417,
100422,
100437,
100510,
100522,
100545,
100562,
100581,
100587,
100269,
100281,
100379,
100397,
100777,
100783,
100793,
100803,
100816,
100869,
100872,
100877,
100891,
100913,
101135,
100932,
100978,
100991,
100998,
101010,
101014,
101015,
101017,
101022,
101033,
101663,
101732,
101451,
101592,
100598,
100630,
100632,
100646,
100651,
100664,
100665,
100691,
100703,
100707,
100723,
100724,
100740,
100746,
100756,
100938,
99990,
100009,
100019,
100023,
100032,
100036,
100191,
100202,
100210,
100211,
100410,
100419,
100447,
100461,
100467,
100468,
100501,
100532,
100542,
100544,
100563,
100569,
100571,
100430,
100249,
100263,
100274,
100288,
100325,
100334,
100381,
100383,
100773,
100792,
100829,
100834,
100864,
100879,
100895,
100902,
100910,
100924,
100925,
101286,
100926,
100970,
101027,
101065,
101075,
101108,
101651,
101454,
100600,
100620,
100652,
100654,
100672,
100684,
100695,
100708,
100725,
100727,
100729,
100769,
100003,
100033,
100151,
100183,
100188,
100198,
100398,
101125,
100493,
100513,
100551,
100565,
100585,
100257,
100280,
100432,
100308,
100321,
100332,
100354,
100371,
100375,
100377,
100775,
100787,
100797,
100811,
100842,
100847,
100859,
100861,
100868,
100882,
100915,
100918,
100921,
101165,
101173,
101193,
101206','T013_CierreEconomico',null,null,PL_OUTPUT);
    DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

EXCEPTION
    WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;

END;
/
EXIT;

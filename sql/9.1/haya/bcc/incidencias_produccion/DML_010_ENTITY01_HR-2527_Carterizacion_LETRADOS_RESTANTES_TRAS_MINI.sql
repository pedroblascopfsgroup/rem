--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20160513
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HR-2527
--## PRODUCTO=NO
--## 
--## Finalidad: Carga de datos (letrados).
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 20151126 GMN Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

        v_usuario_id HAYAMASTER.USU_USUARIOS.USU_ID%TYPE;
	v_letrado    HAYA02.MIG_PROCEDIMIENTOS_ACTORES.CD_ACTOR%TYPE;

        V_MSQL  VARCHAR2(2500);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'HAYA02';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';

        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
   
        V_EXISTE NUMBER (1):=null;

        
 TYPE T_GAA IS TABLE OF VARCHAR2(2000 CHAR);
 TYPE T_ARRAY_GAA IS TABLE OF T_GAA;
  
  
 V_GAA T_ARRAY_GAA := T_ARRAY_GAA(   
                            T_GAA(300027215,'ABECSLP')
                          , T_GAA(300028491,'ABECSLP')
                          , T_GAA(300023808,'ABECSLP')
                          , T_GAA(300023973,'ABECSLP')
                          , T_GAA(300023906,'ABECSLP')
                          , T_GAA(300024168,'ABECSLP')
                          , T_GAA(300024107,'ABECSLP')
                          , T_GAA(300026689,'ABECSLP')
                          , T_GAA(300024431,'ABECSLP')
                          , T_GAA(300025485,'ABECSLP')
                          , T_GAA(300025492,'ABECSLP')
                          , T_GAA(300039769,'ABECSLP')
                          , T_GAA(300039551,'ABECSLP')
                          , T_GAA(300022669,'ALBECHAVA')
                          , T_GAA(300039734,'ANDRVILAC')
                          , T_GAA(300038791,'ANDRVILAC')
                          , T_GAA(300043612,'ANDRVILAC')
                          , T_GAA(300044011,'ANDRVILAC')
                          , T_GAA(300045681,'ANTOGOMEP')
                          , T_GAA(300027141,'ANTOGOMEP')
                          , T_GAA(300035251,'ASESJURIJ')
                          , T_GAA(300021699,'GUILAOLAO')
                          , T_GAA(300030172,'GUILAOLAO')
                          , T_GAA(300023607,'CARMESTEN')
                          , T_GAA(300029349,'CARMESTEN')
                          , T_GAA(300030143,'CARMESTEN')
                          , T_GAA(300043608,'CARMESTEN')
                          , T_GAA(300030167,'CARMESTEN')
                          , T_GAA(300029515,'CARMESTEN')
                          , T_GAA(300027214,'CARMESTEN')
                          , T_GAA(300041004,'CONSABOGC')
                          , T_GAA(300040637,'CONSABOGC')
                          , T_GAA(300031858,'CONSABOGC')
                          , T_GAA(300038269,'CONSABOGC')
                          , T_GAA(300037957,'CONSABOGC')
                          , T_GAA(300037935,'CONSABOGC')
                          , T_GAA(300044779,'CONSABOGC')
                          , T_GAA(300038455,'CONSABOGC')
                          , T_GAA(300043109,'CONSABOGC')
                          , T_GAA(300044791,'CONSABOGC')
                          , T_GAA(300038573,'CONSABOGC')
                          , T_GAA(300041657,'CRTEXTERN')
                          , T_GAA(300042954,'IBERFORO')
                          , T_GAA(300040161,'IBERFORO')
                          , T_GAA(300040257,'IBERFORO')
                          , T_GAA(300042359,'IBERFORO')
                          , T_GAA(300042565,'IBERFORO')
                          , T_GAA(300040249,'IBERFORO')
                          , T_GAA(300042587,'IBERFORO')
                          , T_GAA(300040345,'IBERFORO')
                          , T_GAA(300040346,'IBERFORO')
                          , T_GAA(300040346,'IBERFORO')
                          , T_GAA(300040479,'IBERFORO')
                          , T_GAA(300040417,'IBERFORO')
                          , T_GAA(300040673,'IBERFORO')
                          , T_GAA(300035552,'ENRIMONTF')
                          , T_GAA(300036041,'ENRIMONTF')
                          , T_GAA(300033582,'ENRIMONTF')
                          , T_GAA(300036042,'ENRIMONTF')
                          , T_GAA(300036199,'ENRIMONTF')
                          , T_GAA(300030741,'ENRIMONTF')
                          , T_GAA(300030744,'ENRIMONTF')
                          , T_GAA(300030517,'ENRIMONTF')
                          , T_GAA(300030436,'ENRIMONTF')
                          , T_GAA(300032376,'ENRIMONTF')
                          , T_GAA(300030670,'ENRIMONTF')
                          , T_GAA(300042456,'ENRIMONTF')
                          , T_GAA(300038741,'FRANBARRB')
                          , T_GAA(300038920,'FRANBARRB')
                          , T_GAA(300039014,'FRANBARRB')
                          , T_GAA(300039739,'FRANBARRB')
                          , T_GAA(300043931,'FRANBARRB')
                          , T_GAA(300043429,'FRANBARRB')
                          , T_GAA(300044014,'FRANBARRB')
                          , T_GAA(300044589,'FRANBARRB')
                          , T_GAA(300023755,'FRANBARRB')
                          , T_GAA(300030364,'FRANBARRB')
                          , T_GAA(300040488,'FRANBARRB')
                          , T_GAA(300040628,'FRANLAOMO')
                          , T_GAA(300031408,'FRANLAOMO')
                          , T_GAA(300042841,'FRANLAOMO')
                          , T_GAA(300042677,'GARCCIVIC')
                          , T_GAA(300036598,'GENECIENA')
                          , T_GAA(300036604,'GENECIENA')
                          , T_GAA(300036606,'GENECIENA')
                          , T_GAA(300035492,'GENECIENA')
                          , T_GAA(300034203,'GENECIENA')
                          , T_GAA(300034244,'GENECIENA')
                          , T_GAA(300031759,'GUILZORND')
                          , T_GAA(300030828,'GUILZORND')
                          , T_GAA(300032573,'GUILZORND')
                          , T_GAA(300030572,'GUILZORND')
                          , T_GAA(300032967,'GUILZORND')
                          , T_GAA(300032590,'GUILZORND')
                          , T_GAA(300043181,'HISPIBERC')
                          , T_GAA(300045364,'IBAFERSLP')
                          , T_GAA(300032489,'IGNALOPEZF')
                          , T_GAA(300033010,'IGNALOPEZF')
                          , T_GAA(300032216,'IGNALOPEZF')
                          , T_GAA(300033105,'IGNALOPEZF')
                          , T_GAA(300032891,'IGNALOPEZF')
                          , T_GAA(300033119,'IGNALOPEZF')
                          , T_GAA(300045820,'IGNALOPEZF')
                          , T_GAA(300045006,'IGNALOPEZF')
                          , T_GAA(300045217,'IGNALOPEZF')
                          , T_GAA(300045008,'IGNALOPEZF')
                          , T_GAA(300045982,'IGNALOPEZF')
                          , T_GAA(300045243,'IGNALOPEZF')
                          , T_GAA(300045999,'IGNALOPEZF')
                          , T_GAA(300045248,'IGNALOPEZF')
                          , T_GAA(300037086,'ISABCRESG')
                          , T_GAA(300041190,'JANIAASOC')
                          , T_GAA(300037341,'JERICANOM')
                          , T_GAA(300044754,'JERICANOM')
                          , T_GAA(300045405,'JERICANOM')
                          , T_GAA(300028008,'JESUALCOL')
                          , T_GAA(300035558,'JESUALCOL')
                          , T_GAA(300044243,'JESUALCOL')
                          , T_GAA(300022765,'JESUALCOL')
                          , T_GAA(300030558,'JESUALCOL')
                          , T_GAA(300028593,'JOAQORTEM')
                          , T_GAA(300025758,'JOAQORTEM')
                          , T_GAA(300025318,'JOAQORTEM')
                          , T_GAA(300033392,'JOAQORTEM')
                          , T_GAA(300032250,'JOAQORTEM')
                          , T_GAA(300032251,'JOAQORTEM')
                          , T_GAA(300030231,'JOAQORTEM')
                          , T_GAA(300039806,'JOAQORTEM')
                          , T_GAA(300033264,'JOAQREMOV')
                          , T_GAA(300032879,'JOAQREMOV')
                          , T_GAA(300045719,'JORGCARDR')
                          , T_GAA(300039289,'JORGCARDR')
                          , T_GAA(300038312,'JORGCARDR')
                          , T_GAA(300045936,'JORGCARDR')
                          , T_GAA(300044212,'JORGCARDR')
                          , T_GAA(300022912,'JORGCARDR')
                          , T_GAA(300023463,'JORGCARDR')
                          , T_GAA(300027015,'JORGCARDR')
                          , T_GAA(300028362,'JOSEBALLC')
                          , T_GAA(300028760,'JOSEBALLC')
                          , T_GAA(300026244,'JOSEBALLC')
                          , T_GAA(300026635,'JOSEBALLC')
                          , T_GAA(300024113,'JOSEBALLC')
                          , T_GAA(300025329,'JOSEBALLC')
                          , T_GAA(300039388,'JOSEBALLC')
                          , T_GAA(300024474,'JOSEALON')
                          , T_GAA(300032225,'JOSEMANUG')
                          , T_GAA(300033232,'JOSEMANUG')
                          , T_GAA(300031248,'JOSELEONF')
                          , T_GAA(300027030,'JOSENINEG')
                          , T_GAA(300027103,'JOSENINEG')
                          , T_GAA(300027104,'JOSENINEG')
                          , T_GAA(300027031,'JOSENINEG')
                          , T_GAA(300027032,'JOSENINEG')
                          , T_GAA(300027033,'JOSENINEG')
                          , T_GAA(300027048,'JOSENINEG')
                          , T_GAA(300029084,'JOSENINEG')
                          , T_GAA(300029104,'JOSENINEG')
                          , T_GAA(300030077,'JOSENINEG')
                          , T_GAA(300027352,'JOSENINEG')
                          , T_GAA(300027483,'JOSENINEG')
                          , T_GAA(300028048,'JOSENINEG')
                          , T_GAA(300025874,'JOSENINEG')
                          , T_GAA(300023938,'JOSENINEG')
                          , T_GAA(300023921,'JOSENINEG')
                          , T_GAA(300025494,'JOSENINEG')
                          , T_GAA(300025055,'JOSENINEG')
                          , T_GAA(300024781,'JOSENINEG')
                          , T_GAA(300036854,'JOSENINEG')
                          , T_GAA(300039451,'JOSENINEG')
                          , T_GAA(300036692,'JOSENINEG')
                          , T_GAA(300036712,'JOSENINEG')
                          , T_GAA(300038919,'JOSENINEG')
                          , T_GAA(300037144,'JOSENINEG')
                          , T_GAA(300041481,'JOSELOPEP')
                          , T_GAA(300037072,'JOSESOLEV')
                          , T_GAA(300030168,'JUANHERNS')
                          , T_GAA(300022800,'LEONRUBIA')
                          , T_GAA(300027656,'LEXEAGOGA')
                          , T_GAA(300026707,'LEXEAGOGA')
                          , T_GAA(300026904,'LEXEAGOGA')
                          , T_GAA(300024652,'LEXEAGOGA')
                          , T_GAA(300035827,'LEXEAGOGA')
                          , T_GAA(300035352,'LEXEAGOGA')
                          , T_GAA(300033601,'LEXEAGOGA')
                          , T_GAA(300036233,'LEXEAGOGA')
                          , T_GAA(300036360,'LEXEAGOGA')
                          , T_GAA(300034138,'LEXEAGOGA')
                          , T_GAA(300035125,'LEXEAGOGA')
                          , T_GAA(300035258,'LEXEAGOGA')
                          , T_GAA(300032639,'LEXEAGOGA')
                          , T_GAA(300032912,'LEXEAGOGA')
                          , T_GAA(300032531,'LEXEAGOGA')
                          , T_GAA(300030799,'LEXEAGOGA')
                          , T_GAA(300032552,'LEXEAGOGA')
                          , T_GAA(300031734,'LEXEAGOGA')
                          , T_GAA(300042225,'LEXEAGOGA')
                          , T_GAA(300039998,'LEXEAGOGA')
                          , T_GAA(300029625,'LEXEAGOGA')
                          , T_GAA(300029783,'LEXEAGOGA')
                          , T_GAA(300028986,'LEXEAGOGA')
                          , T_GAA(300028987,'LEXEAGOGA')
                          , T_GAA(300029002,'LEXEAGOGA')
                          , T_GAA(300029850,'LEXEAGOGA')
                          , T_GAA(300029852,'LEXEAGOGA')
                          , T_GAA(300029853,'LEXEAGOGA')
                          , T_GAA(300029190,'LEXEAGOGA')
                          , T_GAA(300029674,'LEXEAGOGA')
                          , T_GAA(300029063,'LEXEAGOGA')
                          , T_GAA(300027598,'LEXEAGOGA')
                          , T_GAA(300027626,'LEXEAGOGA')
                          , T_GAA(300028712,'LEXEAGOGA')
                          , T_GAA(300026172,'LEXEAGOGA')
                          , T_GAA(300028337,'LEXEAGOGA')
                          , T_GAA(300024021,'LEXEAGOGA')
                          , T_GAA(300026600,'LEXEAGOGA')
                          , T_GAA(300026444,'LEXEAGOGA')
                          , T_GAA(300025859,'LEXEAGOGA')
                          , T_GAA(300026603,'LEXEAGOGA')
                          , T_GAA(300025892,'LEXEAGOGA')
                          , T_GAA(300026821,'LEXEAGOGA')
                          , T_GAA(300026034,'LEXEAGOGA')
                          , T_GAA(300025940,'LEXEAGOGA')
                          , T_GAA(300023905,'LEXEAGOGA')
                          , T_GAA(300024089,'LEXEAGOGA')
                          , T_GAA(300026349,'LEXEAGOGA')
                          , T_GAA(300024192,'LEXEAGOGA')
                          , T_GAA(300026528,'LEXEAGOGA')
                          , T_GAA(300024118,'LEXEAGOGA')
                          , T_GAA(300024204,'LEXEAGOGA')
                          , T_GAA(300024422,'LEXEAGOGA')
                          , T_GAA(300025017,'LEXEAGOGA')
                          , T_GAA(300024424,'LEXEAGOGA')
                          , T_GAA(300024258,'LEXEAGOGA')
                          , T_GAA(300024279,'LEXEAGOGA')
                          , T_GAA(300024452,'LEXEAGOGA')
                          , T_GAA(300025335,'LEXEAGOGA')
                          , T_GAA(300024364,'LEXEAGOGA')
                          , T_GAA(300035618,'LEXEAGOGA')
                          , T_GAA(300039657,'LEXEAGOGA')
                          , T_GAA(300039526,'LEXEAGOGA')
                          , T_GAA(300039693,'LEXEAGOGA')
                          , T_GAA(300038877,'LEXEAGOGA')
                          , T_GAA(300045835,'LEXEAGOGA')
                          , T_GAA(300028707,'LUISGARCA')
                          , T_GAA(300027666,'LUISGARCA')
                          , T_GAA(300028189,'LUISGARCA')
                          , T_GAA(300033750,'LUISGARCA')
                          , T_GAA(300034322,'LUISGARCA')
                          , T_GAA(300030494,'LUISGARCA')
                          , T_GAA(300030941,'LUISGARCA')
                          , T_GAA(300030986,'LUISGARCA')
                          , T_GAA(300032120,'LUISGARCA')
                          , T_GAA(300031205,'LUISGARCA')
                          , T_GAA(300040132,'LUISMIRAG')
                          , T_GAA(300040215,'LUISMIRAG')
                          , T_GAA(300042570,'LUISMIRAG')
                          , T_GAA(300042153,'LUISMIRAG')
                          , T_GAA(300040372,'LUISMIRAG')
                          , T_GAA(300042177,'LUISMIRAG')
                          , T_GAA(300040968,'LUISMIRAG')
                          , T_GAA(300040490,'LUISMIRAG')
                          , T_GAA(300041456,'LUISMIRAG')
                          , T_GAA(300040556,'LUISMIRAG')
                          , T_GAA(300040574,'LUISMIRAG')
                          , T_GAA(300041310,'LUISMIRAG')
                          , T_GAA(300041312,'LUISMIRAG')
                          , T_GAA(300041730,'LUISMIRAG')
                          , T_GAA(300040626,'LUISMIRAG')
                          , T_GAA(300041748,'LUISMIRAG')
                          , T_GAA(300041749,'LUISMIRAG')
                          , T_GAA(300040805,'LUISMIRAG')
                          , T_GAA(300042421,'LUISMIRAG')
                          , T_GAA(300042820,'LUISMIRAG')
                          , T_GAA(300031538,'LUISMIRAG')
                          , T_GAA(300032163,'LUISMIRAG')
                          , T_GAA(300031828,'LUISMIRAG')
                          , T_GAA(300043042,'LUISMIRAG')
                          , T_GAA(300043046,'LUISMIRAG')
                          , T_GAA(300039788,'LUISMIRAG')
                          , T_GAA(300031235,'LUISMIRAG')
                          , T_GAA(300031861,'LUISMIRAG')
                          , T_GAA(300042651,'LUISMIRAG')
                          , T_GAA(300022975,'LUISMIRAG')
                          , T_GAA(300042438,'LUISMIRAG')
                          , T_GAA(300041605,'MANURUIZO')
                          , T_GAA(300041289,'MANURUIZO')
                          , T_GAA(300036169,'MANURUIZO')
                          , T_GAA(300023501,'MANURUIZO')
                          , T_GAA(300040514,'MANURUIZO')
                          , T_GAA(300040738,'MANURUIZO')
                          , T_GAA(300041604,'MANURUIZO')
                          , T_GAA(300022864,'MANURUIZO')
                          , T_GAA(300041607,'MANURUIZO')
                          , T_GAA(300037632,'MARILIROL')
                          , T_GAA(300023151,'MARILIROL')
                          , T_GAA(300043780,'MARILIROL')
                          , T_GAA(300029754,'MARIHAROG')
                          , T_GAA(300029343,'MARIHAROG')
                          , T_GAA(300042139,'MARIPEREA')
                          , T_GAA(300039586,'MARIPEREA')
                          , T_GAA(300043424,'MARIPEREA')
                          , T_GAA(300043945,'MARIPEREA')
                          , T_GAA(300043434,'MARIPEREA')
                          , T_GAA(300040833,'MARIPEREA')
                          , T_GAA(300039054,'MARIPEREA')
                          , T_GAA(300022713,'MARIPEREA')
                          , T_GAA(300023624,'MARIPEREA')
                          , T_GAA(300040832,'MARIPEREA')
                          , T_GAA(300023459,'MARIPEREA')
                          , T_GAA(300042697,'MERCBINIE')
                          , T_GAA(300042341,'MERCBINIE')
                          , T_GAA(300034692,'MIGUMARTN')
                          , T_GAA(300034417,'MIGUMARTN')
                          , T_GAA(300034709,'MIGUMARTN')
                          , T_GAA(300012118,'MORAZAMEN')
                          , T_GAA(300040932,'MORAZAMEN')
                          , T_GAA(300012850,'MORAZAMEN')
                          , T_GAA(300010248,'MORAZAMEN')
                          , T_GAA(300013581,'MORAZAMEN')
                          , T_GAA(300013755,'MORAZAMEN')
                          , T_GAA(300010771,'MORAZAMEN')
                          , T_GAA(300041019,'MORAZAMEN')
                          , T_GAA(300041354,'MORAZAMEN')
                          , T_GAA(300016702,'MORAZAMEN')
                          , T_GAA(300040943,'MORAZAMEN')
                          , T_GAA(300038828,'MORAZAMEN')
                          , T_GAA(300011015,'MORAZAMEN')
                          , T_GAA(300020421,'MORAZAMEN')
                          , T_GAA(300018967,'MORAZAMEN')
                          , T_GAA(300018863,'MORAZAMEN')
                          , T_GAA(300018771,'MORAZAMEN')
                          , T_GAA(300041192,'MORAZAMEN')
                          , T_GAA(300022748,'MORAZAMEN')
                          , T_GAA(300041707,'MORAZAMEN')
                          , T_GAA(300016478,'MORAZAMEN')
                          , T_GAA(300011349,'MORAZAMEN')
                          , T_GAA(300009971,'MORAZAMEN')
                          , T_GAA(300041725,'MORAZAMEN')
                          , T_GAA(300041364,'MORAZAMEN')
                          , T_GAA(300011357,'MORAZAMEN')
                          , T_GAA(300010228,'MORAZAMEN')
                          , T_GAA(300012352,'MORAZAMEN')
                          , T_GAA(300041088,'MORAZAMEN')
                          , T_GAA(300010573,'MORAZAMEN')
                          , T_GAA(300011660,'MORAZAMEN')
                          , T_GAA(300010325,'MORAZAMEN')
                          , T_GAA(300015904,'MORAZAMEN')
                          , T_GAA(300041723,'MORAZAMEN')
                          , T_GAA(300010611,'MORAZAMEN')
                          , T_GAA(300014399,'MORAZAMEN')
                          , T_GAA(300011382,'MORAZAMEN')
                          , T_GAA(300029749,'MORAZAMEN')
                          , T_GAA(300012335,'MORAZAMEN')
                          , T_GAA(300011873,'MORAZAMEN')
                          , T_GAA(300014919,'MORAZAMEN')
                          , T_GAA(300041665,'MORAZAMEN')
                          , T_GAA(300008729,'MORAZAMEN')
                          , T_GAA(300041536,'MORAZAMEN')
                          , T_GAA(300041658,'MORAZAMEN')
                          , T_GAA(300041217,'MORAZAMEN')
                          , T_GAA(300016520,'MORAZAMEN')
                          , T_GAA(300041215,'MORAZAMEN')
                          , T_GAA(300020854,'MORAZAMEN')
                          , T_GAA(300038609,'MORAZAMEN')
                          , T_GAA(300041415,'MORAZAMEN')
                          , T_GAA(300014286,'MORAZAMEN')
                          , T_GAA(300041724,'MORAZAMEN')
                          , T_GAA(300023183,'MORAZAMEN')
                          , T_GAA(300028930,'MORAZAMEN')
                          , T_GAA(300041656,'MORAZAMEN')
                          , T_GAA(300016117,'MORAZAMEN')
                          , T_GAA(300014854,'MORAZAMEN')
                          , T_GAA(300041769,'MORAZAMEN')
                          , T_GAA(300011880,'MORAZAMEN')
                          , T_GAA(300041020,'MORAZAMEN')
                          , T_GAA(300011376,'MORAZAMEN')
                          , T_GAA(300041173,'MORAZAMEN')
                          , T_GAA(300012475,'MORAZAMEN')
                          , T_GAA(300009977,'MORAZAMEN')
                          , T_GAA(300009877,'MORAZAMEN')
                          , T_GAA(300008730,'MORAZAMEN')
                          , T_GAA(300041501,'MORAZAMEN')
                          , T_GAA(300041059,'MORAZAMEN')
                          , T_GAA(300010333,'MORAZAMEN')
                          , T_GAA(300014592,'MORAZAMEN')
                          , T_GAA(300010100,'MORAZAMEN')
                          , T_GAA(300011665,'MORAZAMEN')
                          , T_GAA(300010607,'MORAZAMEN')
                          , T_GAA(300021349,'MORAZAMEN')
                          , T_GAA(300041382,'MORAZAMEN')
                          , T_GAA(300041039,'MORAZAMEN')
                          , T_GAA(300010486,'MORAZAMEN')
                          , T_GAA(300013674,'MORAZAMEN')
                          , T_GAA(300041776,'MORAZAMEN')
                          , T_GAA(300041235,'MORAZAMEN')
                          , T_GAA(300040811,'MORAZAMEN')
                          , T_GAA(300041042,'MORAZAMEN')
                          , T_GAA(300041030,'MORAZAMEN')
                          , T_GAA(300040881,'MORAZAMEN')
                          , T_GAA(300041237,'MORAZAMEN')
                          , T_GAA(300010604,'MORAZAMEN')
                          , T_GAA(300041029,'MORAZAMEN')
                          , T_GAA(300011666,'MORAZAMEN')
                          , T_GAA(300012175,'MORAZAMEN')
                          , T_GAA(300040878,'MORAZAMEN')
                          , T_GAA(300012398,'MORAZAMEN')
                          , T_GAA(300040945,'MORAZAMEN')
                          , T_GAA(300041409,'NAYRDIAZG')
                          , T_GAA(300040952,'NAYRDIAZG')
                          , T_GAA(300025999,'NOVEABOGY')
                          , T_GAA(300028310,'NOVEABOGY')
                          , T_GAA(300025998,'NOVEABOGY')
                          , T_GAA(300028052,'NOVEABOGY')
                          , T_GAA(300024994,'NOVEABOGY')
                          , T_GAA(300023813,'PELLCAUDA')
                          , T_GAA(300029177,'PELLCAUDA')
                          , T_GAA(300028152,'PELLCAUDA')
                          , T_GAA(300024449,'PELLCAUDA')
                          , T_GAA(300029650,'PELLCAUDA')
                          , T_GAA(300025087,'PELLCAUDA')
                          , T_GAA(300026432,'PELLCAUDA')
                          , T_GAA(300025944,'PROYFORMS')
                          , T_GAA(300029439,'PROYFORMS')
                          , T_GAA(300040806,'PROYFORMS')
                          , T_GAA(300026986,'PROYFORMS')
                          , T_GAA(300024151,'PROYFORMS')
                          , T_GAA(300025845,'PROYFORMS')
                          , T_GAA(300032731,'PROYFORMS')
                          , T_GAA(300028752,'PROYFORMS')
                          , T_GAA(300031214,'PROYFORMS')
                          , T_GAA(300026849,'PROYFORMS')
                          , T_GAA(300035350,'PROYFORMS')
                          , T_GAA(300031629,'PROYFORMS')
                          , T_GAA(300038694,'PROYFORMS')
                          , T_GAA(300026879,'PROYFORMS')
                          , T_GAA(300031415,'PROYFORMS')
                          , T_GAA(300031414,'PROYFORMS')
                          , T_GAA(300041027,'ROSARAMIR')
                          , T_GAA(300037982,'RAFACORER')
                          , T_GAA(300040955,'ROSAALVAB')
                          , T_GAA(300045203,'SANCVILAA')
                          , T_GAA(300045372,'SANCVILAA')
                          , T_GAA(300045366,'SANCVILAA')
                          , T_GAA(300046026,'SANCVILAA')
                          , T_GAA(300045036,'SANCVILAA')
                          , T_GAA(300043067,'SANCVILAA')
                          , T_GAA(300045371,'SANCVILAA')
                          , T_GAA(300045048,'SANCVILAA')
                          , T_GAA(300038746,'VICERODRE')
                          , T_GAA(300038348,'VICERODRE')
                          , T_GAA(300036634,'VICERODRE')
                          , T_GAA(300036629,'VICERODRE')
                          , T_GAA(300026469,'VICERODRE')
                          , T_GAA(300039227,'VICERODRE')
                          , T_GAA(300029026,'VICERODRE')
                          , T_GAA(300029000,'VICERODRE')
                          , T_GAA(300038876,'VICERODRE')
                          );
        
         V_TMP_GAA T_GAA;        
  
BEGIN



/**************************************************************************************************/
/**********************************    LETRADOS                        ****************************/
/**************************************************************************************************/

     
   EXECUTE IMMEDIATE('UPDATE HAYA02.DD_LHC_LETR_HAYA_CAJAMAR lhc
          set borrado = 1
          , usuariomodificar = ''HR-2527''
          , fechamodificar = sysdate
       where lhc.dd_lhc_bcc_codigo = ''GUILAOLAO''
       ');
       
       COMMIT;
       

 FOR I IN V_GAA.FIRST .. V_GAA.LAST
 LOOP
   V_TMP_GAA := V_GAA(I);
   V_EXISTE:=0; 
   
   
 -- BORRADO GESTORES ASIGNADOS A ASUNTOS A RECARTERIZAR EN LA GAA_GESTOR_ADICIONAL_ASUNTO
   
    EXECUTE IMMEDIATE('DELETE
                       FROM '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa
                       WHERE gaa.asu_id = '|| V_TMP_GAA(1)||'
                         AND gaa.dd_tge_id = (select dd_tge_id 
                                                  from '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR 
                                                 where dd_tge_codigo = ''GEXT''                                                          
                                                )
                        ');
        
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO BORRADA. Gestores asuntos a recarterizar. Asunto '||V_TMP_GAA(1)||' '||SQL%ROWCOUNT||' Filas.');        

    
   -- BORRADO GESTORES ASIGNADOS A ASUNTOS A RECARTERIZAR EN LA GAH_GESTOR_ADICIONAL_historico
    
    EXECUTE IMMEDIATE('delete from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah
                        where gah.gah_asu_id = '|| V_TMP_GAA(1)||'
                          and gah.gah_tipo_gestor_id = (select dd_tge_id 
                                                          from '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR 
                                                         where dd_tge_codigo = ''GEXT''
                                                        )
                      ');   
    
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO BORRADA. Gestores asuntos a recarterizar. Asunto '||V_TMP_GAA(1)||' '||SQL%ROWCOUNT||' Filas.');        

      
    DBMS_OUTPUT.PUT_LINE('Insertando en GAA_GESTOR_ADICIONAL_ASUNTO el gestor: '||V_TMP_GAA(2));   
   
    
   -- LETRADOS EN LA GAA
    ------------------------------

   V_MSQL:= 'insert into HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select HAYA02.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
           (select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo=''GEXT''), 
           ''HR-2527'', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
          select distinct asu.asu_id, usd.usd_id
          from (SELECT asu_id FROM HAYA02.asu_asuntos WHERE asu_id = '|| V_TMP_GAA(1)||' ) asu  cross join 
               HAYA02.DD_LHC_LETR_HAYA_CAJAMAR    lhc  inner join              
               HAYAMASTER.usu_usuarios            usu  on usu.USU_EXTERNO = 1 and usu_username = lhc.dd_lhc_haya_codigo       inner join
               HAYAMASTER.GRU_GRUPOS_USUARIOS gru on gru.usu_id_usuario = usu.usu_id inner join
               HAYA02.usd_usuarios_despachos      usd  on gru.usu_id_grupo = usd.usu_id 
--Se añade el gestos por defecto para poner al grupo en la carterizacion				
				and usd.USD_GESTOR_DEFECTO = 1 				
          where not exists (select 1 from HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id 
                                                                                           and gaa.dd_tge_id = (select dd_tge_id 
                                                                                                                  from HAYAMASTER.dd_tge_tipo_gestor 
                                                                                                                  where dd_tge_codigo=''GEXT'')
                          )
         and lhc.dd_lhc_bcc_codigo = '''||V_TMP_GAA(2)||'''
         and lhc.borrado = 0
     ) aux';
     
     EXECUTE IMMEDIATE V_MSQL;

     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Letrado '||V_TMP_GAA(2)||' carterizado a asunto '||V_TMP_GAA(1)||'. '||SQL%ROWCOUNT||' Filas.');

  --Insertamos carterizacion de grupos sin gestor particular
  
   V_MSQL:= 'insert into HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select HAYA02.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
           (select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo=''GEXT''), 
           ''HR-2527'', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
 select distinct asu.asu_id, usd.usd_id
          from (SELECT asu_id FROM HAYA02.asu_asuntos WHERE asu_id = '|| V_TMP_GAA(1)||' ) asu  cross join 
               HAYA02.des_despacho_externo   des   inner join 
               HAYA02.usd_usuarios_despachos      usd  on des.des_id= usd.des_id 	 and usd.USD_GESTOR_DEFECTO = 1  inner join 
               HAYAMASTER.usu_usuarios            usu  on usd.usu_id = usu.usu_id and usu.USU_EXTERNO = 1  and usu.usu_grupo = 1
--Se añade el gestos por defecto para poner al grupo en la carterizacion				
          where not exists (select 1 from HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id 
                                                                                           and gaa.dd_tge_id = (select dd_tge_id 
                                                                                                                  from HAYAMASTER.dd_tge_tipo_gestor 
                                                                                                                  where dd_tge_codigo=''GEXT'')
                          )
          and des.des_codigo = '''||V_TMP_GAA(2)||'''                          
     ) aux';    
     
      EXECUTE IMMEDIATE V_MSQL;

     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Grupo sin gestor particular '||V_TMP_GAA(2)||' carterizado a asunto '||V_TMP_GAA(1)||'. '||SQL%ROWCOUNT||' Filas.');

    
    
    -- letrados en GAH
    --------------------------
    
   V_MSQL:= 'insert into HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select HAYA02.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), 
           (select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo=''GEXT''), 
           ''HR-2527'', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
            from (SELECT asu_id FROM HAYA02.asu_asuntos WHERE asu_id = '|| V_TMP_GAA(1)||' ) asu  cross join 
               HAYA02.DD_LHC_LETR_HAYA_CAJAMAR    lhc                                                     inner join              
               HAYAMASTER.usu_usuarios            usu  on usu.USU_EXTERNO = 1 and usu_username = lhc.dd_lhc_haya_codigo       inner join
               HAYAMASTER.GRU_GRUPOS_USUARIOS gru on gru.usu_id_usuario = usu.usu_id inner join
               HAYA02.usd_usuarios_despachos      usd  on gru.usu_id_grupo = usd.usu_id  
--Se añade el gestos por defecto para poner al grupo en la carterizacion				
				and usd.USD_GESTOR_DEFECTO = 1 
          where not exists (select 1 from HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah where gah.gah_asu_id = asu.asu_id 
                                                                                               and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                                                                           from HAYAMASTER.dd_tge_tipo_gestor 
                                                                                                                          where dd_tge_codigo=''GEXT'')
                            )
         and lhc.dd_lhc_bcc_codigo = '''||V_TMP_GAA(2)||'''                            
         and lhc.borrado = 0         
     ) aux';    
 
      EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO cargada. Letrado '||V_TMP_GAA(2)||' carterizado a asunto '||V_TMP_GAA(1)||'. '||SQL%ROWCOUNT||' Filas.');
 
 --Insertamos carterizacion de grupos sin gestor particular
 
   V_MSQL:= 'insert into HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select HAYA02.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), 
           (select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo=''GEXT''), 
           ''HR-2527'', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
          select distinct asu.asu_id, usd.usd_id
            from (SELECT asu_id FROM HAYA02.asu_asuntos WHERE asu_id = '|| V_TMP_GAA(1)||' ) asu  cross join 
               HAYA02.des_despacho_externo   des                                                          inner join 
               HAYA02.usd_usuarios_despachos      usd  on des.des_id= usd.des_id  and usd.USD_GESTOR_DEFECTO = 1  inner join 
               HAYAMASTER.usu_usuarios            usu  on usd.usu_id = usu.usu_id and usu.USU_EXTERNO = 1  and usu.usu_grupo = 1
--Se añade el gestos por defecto para poner al grupo en la carterizacion				
				and usd.USD_GESTOR_DEFECTO = 1 
          where not exists (select 1 from HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah where gah.gah_asu_id = asu.asu_id 
                                                                                               and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                                                                           from HAYAMASTER.dd_tge_tipo_gestor 
                                                                                                                          where dd_tge_codigo=''GEXT'')
                            )
            and des.des_codigo = '''||V_TMP_GAA(2)||'''                             
     ) aux';    
    
      EXECUTE IMMEDIATE V_MSQL;
  
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO cargada. Grupo sin gestor particular '||V_TMP_GAA(2)||' carterizado a asunto '||V_TMP_GAA(1)||'. '||SQL%ROWCOUNT||' Filas.');

  END LOOP; 
 
    COMMIT;
    

    EXECUTE IMMEDIATE('ANALYZE TABLE HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_ASUNTO Analizada');



    EXECUTE IMMEDIATE('ANALYZE TABLE HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO Analizada');
 

 
--/***************************************
--*     FIN LETRADOS  *
--***************************************/

  DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO');

EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_MSQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;


--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210602
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9876
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-9876'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ACT_ID NUMBER(16);
    V_TIT_ID NUMBER(16);
    V_ESP_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('7466593','26/03/2012'),
            T_TIPO_DATA('7466592','26/03/2012'),
            T_TIPO_DATA('7466591','26/03/2012'),
            T_TIPO_DATA('7466590','26/03/2012'),
            T_TIPO_DATA('7466589','26/03/2012'),
            T_TIPO_DATA('7466588','26/03/2012'),
            T_TIPO_DATA('7466587','26/03/2012'),
            T_TIPO_DATA('7466586','26/03/2012'),
            T_TIPO_DATA('7466585','26/03/2012'),
            T_TIPO_DATA('7466584','26/03/2012'),
            T_TIPO_DATA('7466583','26/03/2012'),
            T_TIPO_DATA('7466582','26/03/2012'),
            T_TIPO_DATA('7466581','26/03/2012'),
            T_TIPO_DATA('7466580','26/03/2012'),
            T_TIPO_DATA('7466579','26/03/2012'),
            T_TIPO_DATA('7466578','26/03/2012'),
            T_TIPO_DATA('7466577','26/03/2012'),
            T_TIPO_DATA('7466576','26/03/2012'),
            T_TIPO_DATA('7466575','26/03/2012'),
            T_TIPO_DATA('7466574','26/03/2012'),
            T_TIPO_DATA('7466573','26/03/2012'),
            T_TIPO_DATA('7466572','26/03/2012'),
            T_TIPO_DATA('7466571','26/03/2012'),
            T_TIPO_DATA('7466570','26/03/2012'),
            T_TIPO_DATA('7466569','26/03/2012'),
            T_TIPO_DATA('7466568','26/03/2012'),
            T_TIPO_DATA('7466567','26/03/2012'),
            T_TIPO_DATA('7466566','26/03/2012'),
            T_TIPO_DATA('7466565','26/03/2012'),
            T_TIPO_DATA('7466564','26/03/2012'),
            T_TIPO_DATA('7466563','26/03/2012'),
            T_TIPO_DATA('7466562','26/03/2012'),
            T_TIPO_DATA('7466561','26/03/2012'),
            T_TIPO_DATA('7466560','26/03/2012'),
            T_TIPO_DATA('7466559','26/03/2012'),
            T_TIPO_DATA('7466558','26/03/2012'),
            T_TIPO_DATA('7466557','26/03/2012'),
            T_TIPO_DATA('7466556','26/03/2012'),
            T_TIPO_DATA('7466555','26/03/2012'),
            T_TIPO_DATA('7466553','26/03/2012'),
            T_TIPO_DATA('7466552','26/03/2012'),
            T_TIPO_DATA('7466551','26/03/2012'),
            T_TIPO_DATA('7466550','26/03/2012'),
            T_TIPO_DATA('7466549','26/03/2012'),
            T_TIPO_DATA('7466548','26/03/2012'),
            T_TIPO_DATA('7466547','26/03/2012'),
            T_TIPO_DATA('7466545','26/03/2012'),
            T_TIPO_DATA('7466544','26/03/2012'),
            T_TIPO_DATA('7466543','26/03/2012'),
            T_TIPO_DATA('7466542','26/03/2012'),
            T_TIPO_DATA('7466541','26/03/2012'),
            T_TIPO_DATA('7466540','26/03/2012'),
            T_TIPO_DATA('7466539','26/03/2012'),
            T_TIPO_DATA('7466538','26/03/2012'),
            T_TIPO_DATA('7466537','26/03/2012'),
            T_TIPO_DATA('7466536','26/03/2012'),
            T_TIPO_DATA('7466535','26/03/2012'),
            T_TIPO_DATA('7466534','26/03/2012'),
            T_TIPO_DATA('7466533','26/03/2012'),
            T_TIPO_DATA('7466532','26/03/2012'),
            T_TIPO_DATA('7466531','26/03/2012'),
            T_TIPO_DATA('7466530','26/03/2012'),
            T_TIPO_DATA('7466529','26/03/2012'),
            T_TIPO_DATA('7466528','26/03/2012'),
            T_TIPO_DATA('7466527','26/03/2012'),
            T_TIPO_DATA('7466526','26/03/2012'),
            T_TIPO_DATA('7466525','26/03/2012'),
            T_TIPO_DATA('7466524','26/03/2012'),
            T_TIPO_DATA('7466523','26/03/2012'),
            T_TIPO_DATA('7466522','26/03/2012'),
            T_TIPO_DATA('7466521','26/03/2012'),
            T_TIPO_DATA('7466520','26/03/2012'),
            T_TIPO_DATA('7466519','26/03/2012'),
            T_TIPO_DATA('7466518','26/03/2012'),
            T_TIPO_DATA('7466517','26/03/2012'),
            T_TIPO_DATA('7466516','26/03/2012'),
            T_TIPO_DATA('7466515','26/03/2012'),
            T_TIPO_DATA('7466514','26/03/2012'),
            T_TIPO_DATA('7466513','26/03/2012'),
            T_TIPO_DATA('7466512','26/03/2012'),
            T_TIPO_DATA('7466511','26/03/2012'),
            T_TIPO_DATA('7466510','26/03/2012'),
            T_TIPO_DATA('7466509','26/03/2012'),
            T_TIPO_DATA('7466508','26/03/2012'),
            T_TIPO_DATA('7466507','26/03/2012'),
            T_TIPO_DATA('7466506','26/03/2012'),
            T_TIPO_DATA('7466505','26/03/2012'),
            T_TIPO_DATA('7466504','26/03/2012'),
            T_TIPO_DATA('7466503','26/03/2012'),
            T_TIPO_DATA('7466502','26/03/2012'),
            T_TIPO_DATA('7466501','26/03/2012'),
            T_TIPO_DATA('7466500','26/03/2012'),
            T_TIPO_DATA('7466499','26/03/2012'),
            T_TIPO_DATA('7466498','26/03/2012'),
            T_TIPO_DATA('7466497','26/03/2012'),
            T_TIPO_DATA('7466496','26/03/2012'),
            T_TIPO_DATA('7466495','26/03/2012'),
            T_TIPO_DATA('7466494','26/03/2012'),
            T_TIPO_DATA('7466493','26/03/2012'),
            T_TIPO_DATA('7466492','26/03/2012'),
            T_TIPO_DATA('7466491','26/03/2012'),
            T_TIPO_DATA('7466490','26/03/2012'),
            T_TIPO_DATA('7466489','26/03/2012'),
            T_TIPO_DATA('7466488','26/03/2012'),
            T_TIPO_DATA('7466487','26/03/2012'),
            T_TIPO_DATA('7466485','26/03/2012'),
            T_TIPO_DATA('7466484','26/03/2012'),
            T_TIPO_DATA('7466483','26/03/2012'),
            T_TIPO_DATA('7466482','26/03/2012'),
            T_TIPO_DATA('7466481','26/03/2012'),
            T_TIPO_DATA('7466480','26/03/2012'),
            T_TIPO_DATA('7466479','26/03/2012'),
            T_TIPO_DATA('7466478','26/03/2012'),
            T_TIPO_DATA('7466477','26/03/2012'),
            T_TIPO_DATA('7466476','26/03/2012'),
            T_TIPO_DATA('7466475','26/03/2012'),
            T_TIPO_DATA('7466474','26/03/2012'),
            T_TIPO_DATA('7466473','26/03/2012'),
            T_TIPO_DATA('7466472','26/03/2012'),
            T_TIPO_DATA('7466471','26/03/2012'),
            T_TIPO_DATA('7466441','02/08/2012'),
            T_TIPO_DATA('7466440','02/08/2012'),
            T_TIPO_DATA('7466439','02/08/2012'),
            T_TIPO_DATA('7466438','02/08/2012'),
            T_TIPO_DATA('7466437','02/08/2012'),
            T_TIPO_DATA('7466436','02/08/2012'),
            T_TIPO_DATA('7466435','02/08/2012'),
            T_TIPO_DATA('7466434','02/08/2012'),
            T_TIPO_DATA('7466433','02/08/2012'),
            T_TIPO_DATA('7466432','02/08/2012'),
            T_TIPO_DATA('7466431','02/08/2012'),
            T_TIPO_DATA('7466430','02/08/2012'),
            T_TIPO_DATA('7466429','02/08/2012'),
            T_TIPO_DATA('7466428','15/09/2011'),
            T_TIPO_DATA('7466427','15/09/2011'),
            T_TIPO_DATA('7466426','02/08/2012'),
            T_TIPO_DATA('7466425','15/09/2011'),
            T_TIPO_DATA('7466424','02/08/2012'),
            T_TIPO_DATA('7466423','15/09/2011'),
            T_TIPO_DATA('7466422','02/08/2012'),
            T_TIPO_DATA('7466421','02/08/2012'),
            T_TIPO_DATA('7466420','15/09/2011'),
            T_TIPO_DATA('7466419','15/09/2011'),
            T_TIPO_DATA('7466418','15/09/2011'),
            T_TIPO_DATA('7466417','02/08/2012'),
            T_TIPO_DATA('7466416','02/08/2012'),
            T_TIPO_DATA('7466415','15/09/2011'),
            T_TIPO_DATA('7466414','02/08/2012'),
            T_TIPO_DATA('7466413','02/08/2012'),
            T_TIPO_DATA('7466412','15/09/2011'),
            T_TIPO_DATA('7466411','02/08/2012'),
            T_TIPO_DATA('7466410','02/08/2012'),
            T_TIPO_DATA('7466409','02/08/2012'),
            T_TIPO_DATA('7466408','02/08/2012'),
            T_TIPO_DATA('7466407','02/08/2012'),
            T_TIPO_DATA('7466406','02/08/2012'),
            T_TIPO_DATA('7466405','02/08/2012'),
            T_TIPO_DATA('7466404','02/08/2012'),
            T_TIPO_DATA('7466403','15/09/2011'),
            T_TIPO_DATA('7466402','15/09/2011'),
            T_TIPO_DATA('7466401','15/09/2011'),
            T_TIPO_DATA('7466400','02/08/2012'),
            T_TIPO_DATA('7466399','02/08/2012'),
            T_TIPO_DATA('7466398','02/08/2012'),
            T_TIPO_DATA('7466397','15/09/2011'),
            T_TIPO_DATA('7466396','02/08/2012'),
            T_TIPO_DATA('7466395','02/08/2012'),
            T_TIPO_DATA('7466394','02/08/2012'),
            T_TIPO_DATA('7466393','02/08/2012'),
            T_TIPO_DATA('7466392','02/08/2012'),
            T_TIPO_DATA('7466391','02/08/2012'),
            T_TIPO_DATA('7466390','02/08/2012'),
            T_TIPO_DATA('7466389','02/08/2012'),
            T_TIPO_DATA('7466388','02/08/2012'),
            T_TIPO_DATA('7466387','02/08/2012'),
            T_TIPO_DATA('7466386','02/08/2012'),
            T_TIPO_DATA('7466385','15/09/2011'),
            T_TIPO_DATA('7466384','15/09/2011'),
            T_TIPO_DATA('7466383','15/09/2011'),
            T_TIPO_DATA('7466382','15/09/2011'),
            T_TIPO_DATA('7466381','15/09/2011'),
            T_TIPO_DATA('7466380','15/09/2011'),
            T_TIPO_DATA('7466379','02/08/2012'),
            T_TIPO_DATA('7466378','02/08/2012'),
            T_TIPO_DATA('7466377','15/09/2011'),
            T_TIPO_DATA('7466376','02/08/2012'),
            T_TIPO_DATA('7466375','02/08/2012'),
            T_TIPO_DATA('7466374','02/08/2012'),
            T_TIPO_DATA('7466373','15/09/2011'),
            T_TIPO_DATA('7466372','02/08/2012'),
            T_TIPO_DATA('7466371','15/09/2011'),
            T_TIPO_DATA('7466370','15/09/2011'),
            T_TIPO_DATA('7466369','15/09/2011'),
            T_TIPO_DATA('7466368','02/08/2012'),
            T_TIPO_DATA('7466367','15/09/2011'),
            T_TIPO_DATA('7466366','02/08/2012'),
            T_TIPO_DATA('7466365','15/09/2011'),
            T_TIPO_DATA('7466364','02/08/2012'),
            T_TIPO_DATA('7466363','02/08/2012'),
            T_TIPO_DATA('7466362','02/08/2012'),
            T_TIPO_DATA('7466361','15/09/2011'),
            T_TIPO_DATA('7466360','15/09/2011'),
            T_TIPO_DATA('7466359','02/08/2012'),
            T_TIPO_DATA('7466358','02/08/2012'),
            T_TIPO_DATA('7466357','15/09/2011'),
            T_TIPO_DATA('7466356','02/08/2012'),
            T_TIPO_DATA('7466355','15/09/2011'),
            T_TIPO_DATA('7466354','02/08/2012'),
            T_TIPO_DATA('7466353','15/09/2011'),
            T_TIPO_DATA('7466352','02/08/2012'),
            T_TIPO_DATA('7466351','02/08/2012'),
            T_TIPO_DATA('7466350','15/09/2011'),
            T_TIPO_DATA('7466349','02/08/2012'),
            T_TIPO_DATA('7466348','02/08/2012'),
            T_TIPO_DATA('7466347','02/08/2012'),
            T_TIPO_DATA('7466346','02/08/2012'),
            T_TIPO_DATA('7466345','02/08/2012'),
            T_TIPO_DATA('7466344','15/09/2011'),
            T_TIPO_DATA('7466343','02/08/2012'),
            T_TIPO_DATA('7466342','02/08/2012'),
            T_TIPO_DATA('7466341','15/09/2011'),
            T_TIPO_DATA('7466340','02/08/2012'),
            T_TIPO_DATA('7466339','02/08/2012'),
            T_TIPO_DATA('7466338','02/08/2012'),
            T_TIPO_DATA('7466337','02/08/2012'),
            T_TIPO_DATA('7466336','02/08/2012'),
            T_TIPO_DATA('7466335','02/08/2012'),
            T_TIPO_DATA('7466334','02/08/2012'),
            T_TIPO_DATA('7466333','02/08/2012'),
            T_TIPO_DATA('7466332','02/08/2012'),
            T_TIPO_DATA('7466331','02/08/2012'),
            T_TIPO_DATA('7466330','15/09/2011'),
            T_TIPO_DATA('7466329','15/09/2011'),
            T_TIPO_DATA('7466328','15/09/2011'),
            T_TIPO_DATA('7466327','15/09/2011'),
            T_TIPO_DATA('7466326','02/08/2012'),
            T_TIPO_DATA('7466325','15/09/2011'),
            T_TIPO_DATA('7466324','15/09/2011'),
            T_TIPO_DATA('7466323','02/08/2012'),
            T_TIPO_DATA('7466322','15/09/2011'),
            T_TIPO_DATA('7466321','15/09/2011'),
            T_TIPO_DATA('7466320','15/09/2011'),
            T_TIPO_DATA('7466319','02/08/2012'),
            T_TIPO_DATA('7466318','15/09/2011'),
            T_TIPO_DATA('7466317','02/08/2012'),
            T_TIPO_DATA('7466316','02/08/2012'),
            T_TIPO_DATA('7466315','02/08/2012'),
            T_TIPO_DATA('7466314','15/09/2011'),
            T_TIPO_DATA('7466313','15/09/2011'),
            T_TIPO_DATA('7466312','15/09/2011'),
            T_TIPO_DATA('7466311','02/08/2012'),
            T_TIPO_DATA('7466310','02/08/2012'),
            T_TIPO_DATA('7466309','02/08/2012'),
            T_TIPO_DATA('7466308','02/08/2012'),
            T_TIPO_DATA('7466307','02/08/2012'),
            T_TIPO_DATA('7466306','02/08/2012'),
            T_TIPO_DATA('7466305','02/08/2012'),
            T_TIPO_DATA('7466304','02/08/2012'),
            T_TIPO_DATA('7466303','02/08/2012'),
            T_TIPO_DATA('7466302','02/08/2012'),
            T_TIPO_DATA('7466301','02/08/2012'),
            T_TIPO_DATA('7466300','02/08/2012'),
            T_TIPO_DATA('7466299','15/09/2011'),
            T_TIPO_DATA('7466298','02/08/2012'),
            T_TIPO_DATA('7466297','15/09/2011'),
            T_TIPO_DATA('7466296','15/09/2011'),
            T_TIPO_DATA('7466295','15/09/2011'),
            T_TIPO_DATA('7466294','15/09/2011'),
            T_TIPO_DATA('7466293','15/09/2011'),
            T_TIPO_DATA('7466292','15/09/2011'),
            T_TIPO_DATA('7466291','15/09/2011'),
            T_TIPO_DATA('7466290','15/09/2011'),
            T_TIPO_DATA('7466289','15/09/2011'),
            T_TIPO_DATA('7466288','15/09/2011'),
            T_TIPO_DATA('7466287','15/09/2011'),
            T_TIPO_DATA('7466286','15/09/2011'),
            T_TIPO_DATA('7466115','06/05/2010'),
            T_TIPO_DATA('7466114','06/05/2010'),
            T_TIPO_DATA('7466113','06/05/2010'),
            T_TIPO_DATA('7466112','06/05/2010'),
            T_TIPO_DATA('7466111','06/05/2010'),
            T_TIPO_DATA('7466110','06/05/2010'),
            T_TIPO_DATA('7466109','06/05/2010'),
            T_TIPO_DATA('7466108','06/05/2010'),
            T_TIPO_DATA('7466107','06/05/2010'),
            T_TIPO_DATA('7466106','06/05/2010'),
            T_TIPO_DATA('7466105','06/05/2010'),
            T_TIPO_DATA('7466104','06/05/2010'),
            T_TIPO_DATA('7466103','06/05/2010'),
            T_TIPO_DATA('7466102','06/05/2010'),
            T_TIPO_DATA('7466101','06/05/2010'),
            T_TIPO_DATA('7466100','06/05/2010'),
            T_TIPO_DATA('7466099','06/05/2010'),
            T_TIPO_DATA('7466097','06/05/2010'),
            T_TIPO_DATA('7466096','06/05/2010'),
            T_TIPO_DATA('7466095','06/05/2010'),
            T_TIPO_DATA('7466094','06/05/2010'),
            T_TIPO_DATA('7466093','06/05/2010'),
            T_TIPO_DATA('7466028','17/11/2011'),
            T_TIPO_DATA('7466027','17/11/2011'),
            T_TIPO_DATA('7466026','17/11/2011'),
            T_TIPO_DATA('7466025','17/11/2011'),
            T_TIPO_DATA('7466024','17/11/2011'),
            T_TIPO_DATA('7466023','17/11/2011'),
            T_TIPO_DATA('7466022','17/11/2011'),
            T_TIPO_DATA('7466000','18/05/2015'),
            T_TIPO_DATA('7465998','18/05/2015'),
            T_TIPO_DATA('7465997','18/05/2015'),
            T_TIPO_DATA('7465996','18/05/2015'),
            T_TIPO_DATA('7465995','18/05/2015'),
            T_TIPO_DATA('7465994','18/05/2015'),
            T_TIPO_DATA('7465993','18/05/2015'),
            T_TIPO_DATA('7465992','18/05/2015'),
            T_TIPO_DATA('7465991','18/05/2015'),
            T_TIPO_DATA('7465990','18/05/2015'),
            T_TIPO_DATA('7465989','18/05/2015'),
            T_TIPO_DATA('7465988','18/05/2015'),
            T_TIPO_DATA('7465987','18/05/2015'),
            T_TIPO_DATA('7465986','18/05/2015'),
            T_TIPO_DATA('7465985','18/05/2015'),
            T_TIPO_DATA('7465982','18/05/2015'),
            T_TIPO_DATA('7465981','18/05/2015'),
            T_TIPO_DATA('7465980','18/05/2015'),
            T_TIPO_DATA('7465979','18/05/2015'),
            T_TIPO_DATA('7465975','18/05/2015'),
            T_TIPO_DATA('7465974','18/05/2015'),
            T_TIPO_DATA('7465973','18/05/2015'),
            T_TIPO_DATA('7465971','18/05/2015'),
            T_TIPO_DATA('7465968','18/05/2015'),
            T_TIPO_DATA('7465967','18/05/2015'),
            T_TIPO_DATA('7465966','18/05/2015'),
            T_TIPO_DATA('7465965','18/05/2015'),
            T_TIPO_DATA('7465964','18/05/2015'),
            T_TIPO_DATA('7465962','18/05/2015'),
            T_TIPO_DATA('7465961','18/05/2015'),
            T_TIPO_DATA('7465960','18/05/2015'),
            T_TIPO_DATA('7465954','18/05/2015'),
            T_TIPO_DATA('7465948','18/05/2015'),
            T_TIPO_DATA('7465946','18/05/2015'),
            T_TIPO_DATA('7465945','18/05/2015'),
            T_TIPO_DATA('7465944','18/05/2015'),
            T_TIPO_DATA('7465943','18/05/2015'),
            T_TIPO_DATA('7465942','18/05/2015'),
            T_TIPO_DATA('7465939','18/05/2015'),
            T_TIPO_DATA('7465935','18/05/2015'),
            T_TIPO_DATA('7465934','18/05/2015'),
            T_TIPO_DATA('7465932','18/05/2015'),
            T_TIPO_DATA('7465929','18/05/2015'),
            T_TIPO_DATA('7465928','18/05/2015'),
            T_TIPO_DATA('7465926','18/05/2015'),
            T_TIPO_DATA('7465925','18/05/2015'),
            T_TIPO_DATA('7465924','18/05/2015'),
            T_TIPO_DATA('7465921','18/05/2015'),
            T_TIPO_DATA('7465919','18/05/2015'),
            T_TIPO_DATA('7465918','18/05/2015'),
            T_TIPO_DATA('7465916','18/05/2015'),
            T_TIPO_DATA('7465915','18/05/2015'),
            T_TIPO_DATA('7465913','18/05/2015'),
            T_TIPO_DATA('7465912','18/05/2015'),
            T_TIPO_DATA('7465911','18/05/2015'),
            T_TIPO_DATA('7465909','18/05/2015'),
            T_TIPO_DATA('7465908','18/05/2015'),
            T_TIPO_DATA('7465906','18/05/2015'),
            T_TIPO_DATA('7465905','18/05/2015'),
            T_TIPO_DATA('7465897','18/05/2015'),
            T_TIPO_DATA('7465896','18/05/2015'),
            T_TIPO_DATA('7465895','18/05/2015'),
            T_TIPO_DATA('7465894','18/05/2015'),
            T_TIPO_DATA('7465893','18/05/2015'),
            T_TIPO_DATA('7465892','18/05/2015'),
            T_TIPO_DATA('7465891','18/05/2015'),
            T_TIPO_DATA('7465879','18/05/2015'),
            T_TIPO_DATA('7465878','18/05/2015'),
            T_TIPO_DATA('7465877','18/05/2015'),
            T_TIPO_DATA('7465876','18/05/2015'),
            T_TIPO_DATA('7465875','18/05/2015'),
            T_TIPO_DATA('7465873','18/05/2015'),
            T_TIPO_DATA('7465872','18/05/2015'),
            T_TIPO_DATA('7465871','18/05/2015'),
            T_TIPO_DATA('7465870','18/05/2015'),
            T_TIPO_DATA('7465869','18/05/2015'),
            T_TIPO_DATA('7465868','18/05/2015'),
            T_TIPO_DATA('7465867','18/05/2015'),
            T_TIPO_DATA('7465048','22/03/2012'),
            T_TIPO_DATA('7465044','22/03/2012'),
            T_TIPO_DATA('7465039','22/03/2012'),
            T_TIPO_DATA('7465037','22/03/2012'),
            T_TIPO_DATA('7465036','22/03/2012'),
            T_TIPO_DATA('7465035','22/03/2012'),
            T_TIPO_DATA('7465032','22/03/2012'),
            T_TIPO_DATA('7465029','22/03/2012'),
            T_TIPO_DATA('7465027','22/03/2012'),
            T_TIPO_DATA('7465020','22/03/2012'),
            T_TIPO_DATA('7465017','22/03/2012'),
            T_TIPO_DATA('7465016','22/03/2012')

    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	 FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia del activo
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            V_COUNT := 0;

            --Obtenemos el ID del activo
            V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;

            --Actualizamos el dato
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_TIT_TITULO SET
            TIT_FECHA_INSC_REG = TO_DATE('''||V_TMP_TIPO_DATA(2)||''', ''DD-MM-YYYY''),               
            USUARIOMODIFICAR = '''|| V_USUARIO ||''',
            FECHAMODIFICAR = SYSDATE               
            WHERE ACT_ID = '||V_ACT_ID||'';
            EXECUTE IMMEDIATE V_MSQL;

            --Se selecciona el TIT_ID del activo
            V_MSQL := 'SELECT TIT_ID FROM '||V_ESQUEMA||'.ACT_TIT_TITULO WHERE ACT_ID = '||V_ACT_ID||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_TIT_ID;

            --Se selecciona el DD_ESP_ID
            V_MSQL := 'SELECT DD_ESP_ID FROM '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION WHERE DD_ESP_CODIGO = ''03''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ESP_ID;

            --Se crea registro en el historico
            V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO (AHT_ID, TIT_ID, AHT_FECHA_PRES_REGISTRO, AHT_FECHA_INSCRIPCION, DD_ESP_ID, USUARIOCREAR, FECHACREAR)
            VALUES (
                '||V_ESQUEMA||'.S_ACT_AHT_HIST_TRAM_TITULO.NEXTVAL,
                '||V_TIT_ID||',
                TO_DATE(''02/06/2021'', ''DD-MM-YYYY''), 
                TO_DATE('''||V_TMP_TIPO_DATA(2)||''', ''DD-MM-YYYY''),  
                '||V_ESP_ID||',
                '''||V_USUARIO||''',
                SYSDATE
            )';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO');
            
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO '''||V_TMP_TIPO_DATA(1)||'''');

        END IF;

    END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

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
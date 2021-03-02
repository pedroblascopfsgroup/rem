--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210226
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9050
--## PRODUCTO=NO
--##
--## Finalidad: Script realiza una carga masiva de fases
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
    V_NUM NUMBER(16); -- Vble. auxiliar para almacenar el número de registros
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_HFP_HIST_FASES_PUB'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9050'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_ACT_ID NUMBER(16);
	V_USU_ID NUMBER(16);
	V_COUNT NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1024);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --	ACTIVO | FASE | SUBFASE | COMENTARIO
		T_TIPO_DATA('7042627','03','07','Viene de Fase 0. Sin check técnico'),
		T_TIPO_DATA('7062789','03','07','Viene de Fase 0. Sin check técnico'),
		T_TIPO_DATA('7062831','03','07','Viene de Fase 0. Sin check técnico'),
		T_TIPO_DATA('7062875','03','07','Viene de Fase 0. Sin check técnico'),
		T_TIPO_DATA('7241183','03','07','Viene de Fase 0. Sin check técnico'),
		T_TIPO_DATA('7268718','03','07','Viene de Fase 0. Sin check técnico'),
		T_TIPO_DATA('6952401','10','19','Viene de Fase 0. Activo con cargas'),
		T_TIPO_DATA('7262358','10','19','Calidad comprobada'),
		T_TIPO_DATA('7262364','10','19','Calidad comprobada'),
		T_TIPO_DATA('7275599','10','19','Calidad comprobada'),
		T_TIPO_DATA('7275591','10','19','Calidad comprobada'),
		T_TIPO_DATA('7235130','10','19','Calidad comprobada'),
		T_TIPO_DATA('7275594','10','19','Calidad comprobada'),
		T_TIPO_DATA('7275598','10','19','Calidad comprobada'),
		T_TIPO_DATA('7275600','10','19','Calidad comprobada'),
		T_TIPO_DATA('7275595','10','19','Calidad comprobada'),
		T_TIPO_DATA('7275592','10','19','Calidad comprobada'),
		T_TIPO_DATA('7275596','10','19','Calidad comprobada'),
		T_TIPO_DATA('7275593','10','19','Calidad comprobada'),
		T_TIPO_DATA('7275603','10','19','Calidad comprobada'),
		T_TIPO_DATA('7275597','10','19','Calidad comprobada'),
		T_TIPO_DATA('7275602','10','19','Calidad comprobada'),
		T_TIPO_DATA('7275589','10','19','Calidad comprobada'),
		T_TIPO_DATA('7275601','10','19','Calidad comprobada'),
		T_TIPO_DATA('7275590','10','19','Calidad comprobada'),
		T_TIPO_DATA('6134158','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('6135887','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('6520944','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7101238','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7459412','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7459415','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7302344','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7294884','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7294886','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('6714585','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('6082062','05','09','ocupado pendiente de informe'),
		T_TIPO_DATA('6520159','05','09','ocupado pendiente de informe'),
		T_TIPO_DATA('6080552','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('6080553','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('6084396','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('6084397','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('6837480','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7299666','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7302030','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7302678','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7302679','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7330201','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7330481','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7387082','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7403308','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7423088','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7423092','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7423188','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7423219','03','07','sin ok tecnico de Mantenimiento'),
		T_TIPO_DATA('7292750','09','16','reservado'),
		T_TIPO_DATA('7292755','09','16','reservado'),
		T_TIPO_DATA('7074786','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('7072869','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('7072520','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('7072504','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('7072484','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('7071742','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('7069071','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('7032023','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('7031674','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('7030123','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('7014892','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('7014372','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('7010089','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('7007911','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('7007821','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('7005271','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6979248','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6973107','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6972068','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6966492','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6962394','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6948851','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6948008','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6935686','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6935617','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6884204','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6881861','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6881717','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6877302','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6876929','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6876833','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6876832','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6876288','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6875478','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6874883','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6854774','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6854268','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6853213','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('6848621','03','02','SIN CHECK TECNICO'),
		T_TIPO_DATA('7034767','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034768','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034769','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034770','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034771','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034772','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034773','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034774','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034776','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034777','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034778','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034779','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034780','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034781','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034782','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034783','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034784','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034787','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034788','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034789','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034790','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034792','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034793','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034794','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034795','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034796','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034797','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034798','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034799','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034800','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034802','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034805','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034806','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034807','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034808','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034810','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034811','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034812','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034813','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7038126','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7240079','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7240080','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7240081','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7240221','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7246267','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7246269','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7246270','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7247373','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7247472','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7250331','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7253602','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7257054','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7257212','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7262077','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7266981','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7278073','03','07','Sin OK Técnico'),
		T_TIPO_DATA('7231852','05','09','Con OK técnico. Llaves y Limpieza realizadas.'),
		T_TIPO_DATA('7233054','05','09','Con OK técnico. Llaves y Limpieza realizadas.'),
		T_TIPO_DATA('7233365','05','09','Con OK técnico. Llaves y Limpieza realizadas.'),
		T_TIPO_DATA('7238671','05','09','Con OK técnico. Llaves y Limpieza realizadas.'),
		T_TIPO_DATA('7243417','05','09','Con OK técnico. Llaves y Limpieza realizadas.'),
		T_TIPO_DATA('7251149','05','09','Con OK técnico. Llaves y Limpieza realizadas.'),
		T_TIPO_DATA('7263068','05','09','Con OK técnico. Llaves y Limpieza realizadas.'),
		T_TIPO_DATA('62754','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('63001','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('63020','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('63162','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('63242','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('63317','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('63904','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('64192','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('64531','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('65451','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('65980','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('66080','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('66345','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('67046','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('69759','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('72560','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('72936','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('73074','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('74462','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('78039','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('85317','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('85318','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('87535','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('87641','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('87851','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('87990','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('88040','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('98078','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('109471','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('110193','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('110377','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('114059','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('115769','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('115830','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('117582','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('120749','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('121537','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('122734','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('122885','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('123863','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('125678','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('125803','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('128497','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('128580','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('130355','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('131584','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('131585','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('131911','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('131946','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('131947','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('132368','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('137675','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('137886','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('144391','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('147075','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('147076','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('147403','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('148790','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('148791','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('149501','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('149535','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('153906','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('154968','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('155765','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('155767','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('156181','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('161249','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('161794','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('165729','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('169489','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('173353','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('174898','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('175304','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('175341','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('179274','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('186036','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('187645','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('188598','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('194032','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('194791','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('195300','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('196243','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('198844','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('204479','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('204599','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('940620','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('5877651','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('5877652','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6351588','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6351589','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6351592','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6351601','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6351905','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6705454','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6800990','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6800991','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6800992','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6800993','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6800994','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6800995','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6801022','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6804106','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6937881','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6937883','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6968853','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('7075638','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('62711','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('62807','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('68493','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('68550','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('69621','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('70231','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('74424','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('74787','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('74995','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('81535','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('98643','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('109791','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('141773','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('141780','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('142074','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('142745','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('143431','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('145312','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('147030','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('149469','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('149829','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('151626','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('153952','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('155014','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('155148','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('158570','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('158662','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('164447','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('170265','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('183738','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('185007','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('185361','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('189047','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('194587','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('198777','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('198867','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('200477','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('200989','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('940470','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6355376','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6793523','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6793526','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6793531','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6793535','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6793539','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('6793541','05','09','Campaña locales sin sello'),
		T_TIPO_DATA('69177','09','16','Arras/Reservado'),
		T_TIPO_DATA('70535','09','16','Arras/Reservado'),
		T_TIPO_DATA('71449','09','16','Arras/Reservado'),
		T_TIPO_DATA('72365','09','16','Arras/Reservado'),
		T_TIPO_DATA('74272','09','16','Arras/Reservado'),
		T_TIPO_DATA('79519','09','16','Arras/Reservado'),
		T_TIPO_DATA('80674','09','16','Arras/Reservado'),
		T_TIPO_DATA('81952','09','16','Arras/Reservado'),
		T_TIPO_DATA('84642','09','16','Arras/Reservado'),
		T_TIPO_DATA('85857','09','16','Arras/Reservado'),
		T_TIPO_DATA('87976','09','16','Arras/Reservado'),
		T_TIPO_DATA('90009','09','16','Arras/Reservado'),
		T_TIPO_DATA('90396','09','16','Arras/Reservado'),
		T_TIPO_DATA('90592','09','16','Arras/Reservado'),
		T_TIPO_DATA('94299','09','16','Arras/Reservado'),
		T_TIPO_DATA('95237','09','16','Arras/Reservado'),
		T_TIPO_DATA('97941','09','16','Arras/Reservado'),
		T_TIPO_DATA('98676','09','16','Arras/Reservado'),
		T_TIPO_DATA('99051','09','16','Arras/Reservado'),
		T_TIPO_DATA('100662','09','16','Arras/Reservado'),
		T_TIPO_DATA('102447','09','16','Arras/Reservado'),
		T_TIPO_DATA('102969','09','16','Arras/Reservado'),
		T_TIPO_DATA('108851','09','16','Arras/Reservado'),
		T_TIPO_DATA('109107','09','16','Arras/Reservado'),
		T_TIPO_DATA('116560','09','16','Arras/Reservado'),
		T_TIPO_DATA('117909','09','16','Arras/Reservado'),
		T_TIPO_DATA('125635','09','16','Arras/Reservado'),
		T_TIPO_DATA('129301','09','16','Arras/Reservado'),
		T_TIPO_DATA('130250','09','16','Arras/Reservado'),
		T_TIPO_DATA('131952','09','16','Arras/Reservado'),
		T_TIPO_DATA('132635','09','16','Arras/Reservado'),
		T_TIPO_DATA('132904','09','16','Arras/Reservado'),
		T_TIPO_DATA('133425','09','16','Arras/Reservado'),
		T_TIPO_DATA('135523','09','16','Arras/Reservado'),
		T_TIPO_DATA('136549','09','16','Arras/Reservado'),
		T_TIPO_DATA('141750','09','16','Arras/Reservado'),
		T_TIPO_DATA('142180','09','16','Arras/Reservado'),
		T_TIPO_DATA('143415','09','16','Arras/Reservado'),
		T_TIPO_DATA('144129','09','16','Arras/Reservado'),
		T_TIPO_DATA('144354','09','16','Arras/Reservado'),
		T_TIPO_DATA('145385','09','16','Arras/Reservado'),
		T_TIPO_DATA('145643','09','16','Arras/Reservado'),
		T_TIPO_DATA('145745','09','16','Arras/Reservado'),
		T_TIPO_DATA('147359','09','16','Arras/Reservado'),
		T_TIPO_DATA('147481','09','16','Arras/Reservado'),
		T_TIPO_DATA('147570','09','16','Arras/Reservado'),
		T_TIPO_DATA('151002','09','16','Arras/Reservado'),
		T_TIPO_DATA('153728','09','16','Arras/Reservado'),
		T_TIPO_DATA('154200','09','16','Arras/Reservado'),
		T_TIPO_DATA('154879','09','16','Arras/Reservado'),
		T_TIPO_DATA('155291','09','16','Arras/Reservado'),
		T_TIPO_DATA('155416','09','16','Arras/Reservado'),
		T_TIPO_DATA('156080','09','16','Arras/Reservado'),
		T_TIPO_DATA('164909','09','16','Arras/Reservado'),
		T_TIPO_DATA('170652','09','16','Arras/Reservado'),
		T_TIPO_DATA('175214','09','16','Arras/Reservado'),
		T_TIPO_DATA('176987','09','16','Arras/Reservado'),
		T_TIPO_DATA('177936','09','16','Arras/Reservado'),
		T_TIPO_DATA('180710','09','16','Arras/Reservado'),
		T_TIPO_DATA('182002','09','16','Arras/Reservado'),
		T_TIPO_DATA('186078','09','16','Arras/Reservado'),
		T_TIPO_DATA('186820','09','16','Arras/Reservado'),
		T_TIPO_DATA('189844','09','16','Arras/Reservado'),
		T_TIPO_DATA('191694','09','16','Arras/Reservado'),
		T_TIPO_DATA('193563','09','16','Arras/Reservado'),
		T_TIPO_DATA('197634','09','16','Arras/Reservado'),
		T_TIPO_DATA('202575','09','16','Arras/Reservado'),
		T_TIPO_DATA('202750','09','16','Arras/Reservado'),
		T_TIPO_DATA('203306','09','16','Arras/Reservado'),
		T_TIPO_DATA('203349','09','16','Arras/Reservado'),
		T_TIPO_DATA('203563','09','16','Arras/Reservado'),
		T_TIPO_DATA('204081','09','16','Arras/Reservado'),
		T_TIPO_DATA('204106','09','16','Arras/Reservado'),
		T_TIPO_DATA('943990','09','16','Arras/Reservado'),
		T_TIPO_DATA('6355347','09','16','Arras/Reservado'),
		T_TIPO_DATA('6355360','09','16','Arras/Reservado'),
		T_TIPO_DATA('6705318','09','16','Arras/Reservado'),
		T_TIPO_DATA('6969345','09','16','Arras/Reservado'),
		T_TIPO_DATA('6969346','09','16','Arras/Reservado'),
		T_TIPO_DATA('6969352','09','16','Arras/Reservado'),
		T_TIPO_DATA('6969353','09','16','Arras/Reservado'),
		T_TIPO_DATA('6969357','09','16','Arras/Reservado'),
		T_TIPO_DATA('6969358','09','16','Arras/Reservado'),
		T_TIPO_DATA('6969359','09','16','Arras/Reservado'),
		T_TIPO_DATA('6969360','09','16','Arras/Reservado'),
		T_TIPO_DATA('6969365','09','16','Arras/Reservado'),
		T_TIPO_DATA('6969366','09','16','Arras/Reservado'),
		T_TIPO_DATA('7031532','09','16','Arras/Reservado'),
		T_TIPO_DATA('7073915','09','16','Arras/Reservado'),
		T_TIPO_DATA('63098','10','19','Profesional Suelo'),
		T_TIPO_DATA('68441','10','19','Publicado minorista'),
		T_TIPO_DATA('145440','10','19','Publicado minorista'),
		T_TIPO_DATA('154851','10','19','Publicado minorista'),
		T_TIPO_DATA('155499','10','19','Publicado minorista'),
		T_TIPO_DATA('165231','10','19','Profesional Suelo'),
		T_TIPO_DATA('168760','10','19','Profesional Suelo'),
		T_TIPO_DATA('188264','10','19','Publicado minorista'),
		T_TIPO_DATA('189882','10','19','Publicado minorista'),
		T_TIPO_DATA('202301','10','19','Publicado minorista'),
		T_TIPO_DATA('5877719','10','19','Publicado minorista'),
		T_TIPO_DATA('6128807','10','19','Publicado minorista'),
		T_TIPO_DATA('6130434','10','19','Publicado minorista')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	DBMS_OUTPUT.PUT_LINE('[INFO]: FINALIZAR FASE EN '||V_TEXT_TABLA);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL:='SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT > 0 THEN

			V_MSQL:='SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
			EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;

			V_MSQL:='SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''SUPER''';
			EXECUTE IMMEDIATE V_MSQL INTO V_USU_ID;

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET
			HFP_FECHA_FIN = SYSDATE,
			USUARIOMODIFICAR = '''||V_USU||''',
			FECHAMODIFICAR = SYSDATE
			WHERE
			ACT_ID = '||V_ACT_ID||'
			AND HFP_FECHA_FIN IS NULL';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: FASE FINALIZADA PARA EL ACTIVO: '||V_TMP_TIPO_DATA(1)||'');
				
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (HFP_ID, ACT_ID, DD_FSP_ID, DD_SFP_ID, USU_ID, HFP_FECHA_INI, HFP_COMENTARIO, USUARIOCREAR, FECHACREAR)
			VALUES (
			'||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
			'||V_ACT_ID||',
			(SELECT DD_FSP_ID FROM '||V_ESQUEMA||'.DD_FSP_FASE_PUBLICACION WHERE DD_FSP_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
			(SELECT DD_SFP_ID FROM '||V_ESQUEMA||'.DD_SFP_SUBFASE_PUBLICACION WHERE DD_SFP_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''),
			'||V_USU_ID||',
			SYSDATE,
			'''||V_TMP_TIPO_DATA(4)||''',
			'''||V_USU||''',
			SYSDATE)';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: FASE INSERTADA PARA EL ACTIVO: '||V_TMP_TIPO_DATA(1)||'');
		
		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: EL ACTIVO: '||V_TMP_TIPO_DATA(1)||' NO EXISTE');

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
--###########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200108
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6035
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar fechas en gastos
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
alter session set NLS_NUMERIC_CHARACTERS = '.,';

DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-6035';

  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

T_TIPO_DATA('9','80160', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80161', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80162', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80166', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80167', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80168', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80169', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80180', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80259', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80260', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80261', '20191129', '20191129', '20191129'),
T_TIPO_DATA('9','80262', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80264', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80265', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80266', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80267', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80269', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80270', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80271', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80272', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80273', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80274', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80275', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80276', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80279', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80491', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80498', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80499', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80500', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80501', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80502', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80504', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80505', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80506', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80507', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80508', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80509', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80510', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80511', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80512', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80515', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80516', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80517', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80518', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80519', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80520', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80521', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80522', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80523', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80525', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80526', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80527', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80528', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80529', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80530', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80532', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80533', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80534', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80535', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80537', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80538', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80540', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80541', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80542', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80543', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80545', '20191129', '20191129', '20191129'),
T_TIPO_DATA('9','80546', '20191129', '20191129', '20191129'),
T_TIPO_DATA('9','80547', '20191129', '20191129', '20191129'),
T_TIPO_DATA('9','80548', '20191129', '20191129', '20191129'),
T_TIPO_DATA('9','80549', '20191129', '20191129', '20191129'),
T_TIPO_DATA('9','80551', '20191129', '20191129', '20191129'),
T_TIPO_DATA('9','80552', '20191129', '20191129', '20191129'),
T_TIPO_DATA('9','80553', '20191129', '20191129', '20191129'),
T_TIPO_DATA('9','80555', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80556', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80558', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80559', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80560', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80561', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80562', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80563', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80564', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80565', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80587', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80588', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80589', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80590', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80591', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80592', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80594', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80595', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80601', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80602', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80603', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80604', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80605', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80606', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80607', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80608', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80609', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80610', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80620', '20191129', '20191129', '20191129'),
T_TIPO_DATA('9','80622', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80624', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80625', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80627', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80628', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80629', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80630', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80631', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80632', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80633', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80634', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80635', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80638', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80639', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80640', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80641', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80642', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80643', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80644', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80645', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80646', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80647', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80648', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80651', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80653', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80654', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80655', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80660', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80661', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80663', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80672', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80673', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80674', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80675', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80677', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80678', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80679', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80680', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80681', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80685', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80686', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80687', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80688', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80689', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80690', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80691', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80692', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80693', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80695', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80696', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80697', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80698', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80699', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80703', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80704', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80705', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80706', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80707', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80708', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80710', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80711', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80715', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80732', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80733', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80736', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80737', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80739', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80740', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80741', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80744', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80745', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80746', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80747', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80748', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80749', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80750', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80751', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80752', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80753', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80754', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80756', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80757', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80758', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80760', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80761', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80767', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80768', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80769', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80770', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80771', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80772', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80773', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80774', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80776', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80777', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80781', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80782', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80784', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80785', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80786', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80789', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80790', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80793', '20191126', '20191126', '20191126'),
T_TIPO_DATA('9','80795', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80797', '20181122', '20181122', '20181122'),
T_TIPO_DATA('9','80798', '20181122', '20181122', '20181122'),
T_TIPO_DATA('9','80800', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80801', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80804', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80810', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80816', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80817', '20191125', '20191125', '20191125'),
T_TIPO_DATA('9','80819', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80820', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80821', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80823', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80824', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80825', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80827', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80828', '20191128', '20191128', '20191128'),
T_TIPO_DATA('9','80832', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80839', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80840', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80841', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80842', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80843', '20191122', '20191122', '20191122'),
T_TIPO_DATA('9','80845', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','80846', '20191127', '20191127', '20191127'),
T_TIPO_DATA('9','81378', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','81430', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','81477', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','81487', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','81615', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','81637', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','81791', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','81839', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82110', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82140', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82180', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82257', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82283', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82286', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82293', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82296', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82325', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82381', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82384', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82423', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82448', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82477', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82493', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82519', '20191202', '20191202', '20191202'),
T_TIPO_DATA('9','82602', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82603', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82604', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82605', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82606', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82607', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82608', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82609', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82610', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82611', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82612', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82626', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82627', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82628', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82629', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82630', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82631', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82632', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82633', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82634', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82636', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82643', '20191203', '20191203', '20191203'),
T_TIPO_DATA('9','82693', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82696', '20191021', '20191021', '20191021'),
T_TIPO_DATA('9','82697', '20191021', '20191021', '20191021'),
T_TIPO_DATA('9','82698', '20191021', '20191021', '20191021'),
T_TIPO_DATA('9','82699', '20191021', '20191021', '20191021'),
T_TIPO_DATA('9','82700', '20191021', '20191021', '20191021'),
T_TIPO_DATA('9','82834', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82835', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82837', '20191205', '20191205', '20191205'),
T_TIPO_DATA('9','82838', '20191205', '20191205', '20191205'),
T_TIPO_DATA('9','82839', '20191205', '20191205', '20191205'),
T_TIPO_DATA('9','82840', '20191205', '20191205', '20191205'),
T_TIPO_DATA('9','82841', '20191205', '20191205', '20191205'),
T_TIPO_DATA('9','82842', '20191205', '20191205', '20191205'),
T_TIPO_DATA('9','82843', '20191205', '20191205', '20191205'),
T_TIPO_DATA('9','82844', '20191205', '20191205', '20191205'),
T_TIPO_DATA('9','82845', '20191205', '20191205', '20191205'),
T_TIPO_DATA('9','82847', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82848', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82849', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82850', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82851', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82852', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82853', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82854', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82855', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82856', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82857', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82859', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82860', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82861', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82862', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82863', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82864', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82865', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82866', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82867', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82869', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82870', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82871', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82872', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82874', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82875', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82877', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82878', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82881', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82883', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82884', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82885', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82889', '20191204', '20191204', '20191204'),
T_TIPO_DATA('9','82909', '20191219', '20191210', '20191210'),
T_TIPO_DATA('9','82980', '20191210', '20191210', '20191210'),
T_TIPO_DATA('9','82983', '20191210', '20191210', '20191210'),
T_TIPO_DATA('9','82987', '20191210', '20191210', '20191210'),
T_TIPO_DATA('9','82989', '20191210', '20191210', '20191210'),
T_TIPO_DATA('9','82992', '20191210', '20191210', '20191210'),
T_TIPO_DATA('9','82994', '20191210', '20191210', '20191210'),
T_TIPO_DATA('9','83039', '20191205', '20191205', '20191205'),
T_TIPO_DATA('9','83041', '20191210', '20191210', '20191210'),
T_TIPO_DATA('9','83050', '20191211', '20191211', '20191211'),
T_TIPO_DATA('9','83051', '20191211', '20191211', '20191211'),
T_TIPO_DATA('9','83052', '20191211', '20191211', '20191211'),
T_TIPO_DATA('9','83054', '20191211', '20191211', '20191211'),
T_TIPO_DATA('9','83055', '20191211', '20191211', '20191211'),
T_TIPO_DATA('9','83065', '20191211', '20191211', '20191211'),
T_TIPO_DATA('9','83066', '20191211', '20191211', '20191211'),
T_TIPO_DATA('9','83070', '20191216', '20191216', '20191216'),
T_TIPO_DATA('9','83071', '20191107', '20191107', '20191210'),
T_TIPO_DATA('9','83073', '20191106', '20191106', '20191210'),
T_TIPO_DATA('9','83105', '20191211', '20191211', '20191211'),
T_TIPO_DATA('9','83106', '20191210', '20191210', '20191210'),
T_TIPO_DATA('9','83297', '20191216', '20191216', '20191216'),
T_TIPO_DATA('9','83298', '20191216', '20191216', '20191216'),
T_TIPO_DATA('9','83299', '20191203', '20191203', '20191213'),
T_TIPO_DATA('9','83300', '20191203', '20191203', '20191213'),
T_TIPO_DATA('9','83301', '20191203', '20191203', '20191213'),
T_TIPO_DATA('9','83302', '20191203', '20191203', '20191213'),
T_TIPO_DATA('9','83303', '20191203', '20191203', '20191213'),
T_TIPO_DATA('9','83304', '20191203', '20191203', '20191213'),
T_TIPO_DATA('9','83305', '20201114', '20191114', '20191213'),
T_TIPO_DATA('9','83306', '20191212', '20191212', '20191213'),
T_TIPO_DATA('9','83307', '20191212', '20191212', '20191213'),
T_TIPO_DATA('9','83308', '20191212', '20191212', '20191213'),
T_TIPO_DATA('9','83309', '20191112', '20191112', '20191213'),
T_TIPO_DATA('9','83310', '20191213', '20191213', '20191213'),
T_TIPO_DATA('9','83311', '20191213', '20191213', '20191213'),
T_TIPO_DATA('9','83312', '20191111', '20191111', '20191111'),
T_TIPO_DATA('9','83313', '20191114', '20191114', '20191213'),
T_TIPO_DATA('9','83314', '20191216', '20191216', '20191216'),
T_TIPO_DATA('9','83316', '20191213', '20191213', '20191213'),
T_TIPO_DATA('9','83317', '20191216', '20191216', '20191216'),
T_TIPO_DATA('9','83318', '20191216', '20191216', '20191216'),
T_TIPO_DATA('9','83319', '20191216', '20191216', '20191216'),
T_TIPO_DATA('9','83320', '20191213', '20191213', '20191213'),
T_TIPO_DATA('9','83330', '20191213', '20191213', '20191213'),
T_TIPO_DATA('9','83334', '20191213', '20191213', '20191213'),
T_TIPO_DATA('9','83342', '20191213', '20191213', '20191213'),
T_TIPO_DATA('9','83344', '20191213', '20191213', '20191213'),
T_TIPO_DATA('9','83345', '20191216', '20191216', '20191216'),
T_TIPO_DATA('9','83346', '20191216', '20191216', '20191216'),
T_TIPO_DATA('14','1421276', '20191116', '20191117', '20191118')


	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
    V_NUM_TABLAS := 0;
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('	[INFO]: ACTUALIZAR GASTOS');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
		   SET GPV_FECHA_REC_PROP = TO_DATE('''||TRIM(V_TMP_TIPO_DATA(3))||''',''YYYYMMDD''),
		       GPV_FECHA_REC_GEST = TO_DATE('''||TRIM(V_TMP_TIPO_DATA(4))||''',''YYYYMMDD''),
		       GPV_FECHA_REC_HAYA = TO_DATE('''||TRIM(V_TMP_TIPO_DATA(5))||''',''YYYYMMDD''),
		       USUARIOMODIFICAR = ''REMVIP-6035'',
		       FECHAMODIFICAR = SYSDATE
		   WHERE 1 = 1
		   AND DD_GRF_ID = ( SELECT DD_GRF_ID 
				     FROM '||V_ESQUEMA||'.DD_GRF_GESTORIA_RECEP_FICH 
				     WHERE DD_GRF_CODIGO = ''' || TRIM(V_TMP_TIPO_DATA(1)) || ''' )
		   AND GPV_NUM_GASTO_GESTORIA = ' || TRIM(V_TMP_TIPO_DATA(2)) ;
     
	EXECUTE IMMEDIATE V_MSQL;
        V_NUM_TABLAS := V_NUM_TABLAS + 1;
			    
		
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM_TABLAS||' Gastos actualizados');  

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

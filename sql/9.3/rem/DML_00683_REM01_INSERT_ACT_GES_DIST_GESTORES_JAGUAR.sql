--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20211216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16597
--## PRODUCTO=NO
--##
--## Finalidad:	Añade en la tabla ACT_GES_DIST_GESTORES los datos del array T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial HREOS-16066
--##        0.2  HREOS-16597 añadir mas gestores
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USU VARCHAR2(2400 CHAR) := 'HREOS-16597';
    V_COND1 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND2 VARCHAR2(400 CHAR) := 'IS NULL';
    V_COND3 VARCHAR2(400 CHAR) := 'IS NULL';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (		
    		    -- TGE | CRA | EAC | TCR | PRV | LOC | POSTAL | USERNAME | NOMBRE_APELLIDO | SCRA




    T_TIPO_DATA('GACT','07','','','4','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','11','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','14','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','18','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','21','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','23','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','29','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','41','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','22','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','44','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','50','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','33','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','7','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','35','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','38','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','39','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','5','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','9','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','24','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','34','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','37','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','40','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','42','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','47','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','49','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','2','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','13','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','16','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','19','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','45','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','8','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','17','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','25','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','43','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','51','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','3','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','12','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','46','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','6','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','10','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','15','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','27','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','32','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','36','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','28','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','52','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','30','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','31','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','1','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','20','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','48','','','grupgact','','70'),
    T_TIPO_DATA('GACT','07','','','26','','','grupgact','','70'),
    
    T_TIPO_DATA('GPUBL','07','','','4','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','11','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','14','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','18','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','21','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','23','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','29','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','41','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','22','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','44','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','50','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','33','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','7','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','35','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','38','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','39','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','5','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','9','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','24','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','34','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','37','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','40','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','42','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','47','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','49','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','2','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','13','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','16','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','19','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','45','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','8','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','17','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','25','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','43','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','51','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','3','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','12','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','46','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','6','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','10','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','15','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','27','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','32','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','36','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','28','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','52','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','30','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','31','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','1','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','20','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','48','','','GESTPUBL','','70'),
    T_TIPO_DATA('GPUBL','07','','','26','','','GESTPUBL','','70'),

   

    T_TIPO_DATA('GIAADMT','07','','','4','','','garsa02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','11','','','garsa02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','14','','','garsa02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','18','','','garsa02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','21','','','garsa02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','23','','','garsa02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','29','','','garsa02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','41','','','garsa02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','7','','','garsa02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','51','','','garsa02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','3','','','garsa02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','12','','','garsa02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','46','','','garsa02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','52','','','garsa02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','30','','','garsa02','','70'),

    T_TIPO_DATA('GTOPLUS','07','','','4','','','garsa06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','11','','','garsa06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','14','','','garsa06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','18','','','garsa06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','21','','','garsa06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','23','','','garsa06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','29','','','garsa06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','41','','','garsa06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','7','','','garsa06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','51','','','garsa06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','3','','','garsa06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','12','','','garsa06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','46','','','garsa06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','52','','','garsa06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','30','','','garsa06','','70'),

    T_TIPO_DATA('GTOPOSTV','07','','','4','','','garsa07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','11','','','garsa07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','14','','','garsa07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','18','','','garsa07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','21','','','garsa07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','23','','','garsa07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','29','','','garsa07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','41','','','garsa07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','7','','','garsa07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','51','','','garsa07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','3','','','garsa07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','12','','','garsa07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','46','','','garsa07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','52','','','garsa07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','30','','','garsa07','','70'),


    T_TIPO_DATA('GIAADMT','07','','','2','','','pinos02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','13','','','pinos02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','16','','','pinos02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','19','','','pinos02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','45','','','pinos02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','17','','','pinos02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','25','','','pinos02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','43','','','pinos02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','6','','','pinos02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','10','','','pinos02','','70'),

    T_TIPO_DATA('GTOPLUS','07','','','2','','','pinos06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','13','','','pinos06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','16','','','pinos06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','19','','','pinos06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','45','','','pinos06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','17','','','pinos06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','25','','','pinos06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','43','','','pinos06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','6','','','pinos06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','10','','','pinos06','','70'),

    T_TIPO_DATA('GTOPOSTV','07','','','2','','','pinos07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','13','','','pinos07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','16','','','pinos07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','19','','','pinos07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','45','','','pinos07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','17','','','pinos07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','25','','','pinos07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','43','','','pinos07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','6','','','pinos07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','10','','','pinos07','','70'),


    T_TIPO_DATA('GIAADMT','07','','','22','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','44','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','50','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','33','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','35','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','38','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','39','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','5','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','9','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','24','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','34','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','37','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','40','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','42','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','47','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','49','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','8','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','15','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','27','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','32','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','36','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','28','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','31','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','1','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','20','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','48','','','ogf02','','70'),
    T_TIPO_DATA('GIAADMT','07','','','26','','','ogf02','','70'),

    T_TIPO_DATA('GTOPLUS','07','','','22','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','44','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','50','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','33','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','35','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','38','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','39','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','5','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','9','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','24','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','34','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','37','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','40','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','42','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','47','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','49','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','8','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','15','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','27','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','32','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','36','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','28','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','31','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','1','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','20','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','48','','','ogf06','','70'),
    T_TIPO_DATA('GTOPLUS','07','','','26','','','ogf06','','70'),

    T_TIPO_DATA('GTOPOSTV','07','','','22','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','44','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','50','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','33','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','35','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','38','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','39','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','5','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','9','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','24','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','34','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','37','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','40','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','42','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','47','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','49','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','8','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','15','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','27','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','32','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','36','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','28','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','31','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','1','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','20','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','48','','','ogf07','','70'),
    T_TIPO_DATA('GTOPOSTV','07','','','26','','','ogf07','','70')

         
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    -- LOOP para insertar o modificar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        V_COND1 := 'IS NULL';
	V_COND2 := 'IS NULL';
	V_COND3 := 'IS NULL';

        IF (V_TMP_TIPO_DATA(4) is not null)  THEN
			V_COND1 := '= '''||TRIM(V_TMP_TIPO_DATA(4))||''' ';
        END IF;
        IF (V_TMP_TIPO_DATA(6) is not null) THEN
			V_COND2 := '= '''||TRIM(V_TMP_TIPO_DATA(6))||''' ';
        END IF;
 	IF (V_TMP_TIPO_DATA(10) is not null)  THEN
			V_COND3 := '= '''||TRIM(V_TMP_TIPO_DATA(10))||''' ';
        END IF;
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
        			' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||	
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO IS NULL '||
					' AND COD_TIPO_COMERZIALZACION  '||V_COND1||' '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO '||V_COND2||' '||
					' AND COD_POSTAL IS NULL '||
					' AND COD_SUBCARTERA '||V_COND3||' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    ' SET USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
					' , NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
					' , USUARIOMODIFICAR = '''||V_USU||''' , FECHAMODIFICAR = SYSDATE '||
					' WHERE TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||
					' AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '||
					' AND COD_ESTADO_ACTIVO  IS NULL '||
					' AND COD_TIPO_COMERZIALZACION '||V_COND1||' '||
					' AND COD_PROVINCIA = '''||TRIM(V_TMP_TIPO_DATA(5))||''' '||
					' AND COD_MUNICIPIO '||V_COND2||' '||
					' AND COD_POSTAL IS NULL '||
					' AND COD_SUBCARTERA '||V_COND3||' ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
          
          
       --Si no existe, lo insertamos   
       ELSE
  
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION, COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, COD_SUBCARTERA) ' ||
                      	'SELECT '|| V_ID || ', '''||TRIM(V_TMP_TIPO_DATA(1))||''' ' ||
						', '||V_TMP_TIPO_DATA(2)||','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','||TRIM(V_TMP_TIPO_DATA(5))||' ' ||
						', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', '''||TRIM(V_TMP_TIPO_DATA(8))||''' '||
						', (SELECT USU.USU_NOMBRE ||'' ''|| USU.USU_APELLIDO1 ||'' ''|| USU.USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(8))||''') '||
						', 0, '''||V_USU||''',SYSDATE,0, '''||TRIM(V_TMP_TIPO_DATA(10))||''' FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA COD PROVINCIA: '''|| TRIM(V_TMP_TIPO_DATA(5)) ||'''');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');


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

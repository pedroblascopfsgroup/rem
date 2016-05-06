--/*
--##########################################
--## AUTOR=CARLOS LOPEZ VIDAL
--## FECHA_CREACION=20160425
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.9
--## INCIDENCIA_LINK=HR-2309
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar DD_TBI_TIPO_BIEN
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES: 1
--##           
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
  
 V_ESQUEMA 			     VARCHAR2(25 CHAR):= '#ESQUEMA#'; 				-- Configuracion Esquema
 V_ESQUEMA_MASTER    		     VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 			-- Configuracion Esquema Master
 TABLA                               VARCHAR(100 CHAR);
 SECUENCIA                           VARCHAR(100 CHAR);
 seq_count 			     NUMBER(3); 						-- Vble. para validar la existencia de las Secuencias.
 table_count 		     	     NUMBER(3); 						-- Vble. para validar la existencia de las Tablas.
 v_column_count  	   	     NUMBER(3); 						-- Vble. para validar la existencia de las Columnas.
 v_constraint_count  		     NUMBER(3); 						-- Vble. para validar la existencia de las Constraints.
 err_num  			     NUMBER; 							-- Numero de errores
 err_msg  			     VARCHAR2(2048); 						-- Mensaje de error 
 V_MSQL 			     VARCHAR2(4000 CHAR);
 V_EXIST  			     NUMBER(10);
 V_ENTIDAD_ID  		   	     NUMBER(16); 
 V_ENTIDAD 			     NUMBER(16);
 
 V_COUNT	NUMBER;
 V_USUARIO_CREAR VARCHAR2(10);
 
 BEGIN

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PRB_PRC_BIE PRB WHERE PRB.PRC_ID = ''100218556'' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

IF V_COUNT = 0
THEN
	V_MSQL:='
	update '||V_ESQUEMA||'.EXP_EXPEDIENTES exp
	  set borrado=1
	where exp.exp_id = (select asu.exp_id from '||V_ESQUEMA||'.ASU_ASUNTOS asu
		                         where asu.SYS_GUID is  null
		                         and exp.exp_id = asu.exp_id
		                         and asu.USUARIOCREAR = ''MIGRAHAYA02PCO''
		                         )';
	execute immediate(V_MSQL);

	V_MSQL:='	
	update '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc
	  set borrado=1
	where prc.asu_id = (select asu.asu_id from '||V_ESQUEMA||'.ASU_ASUNTOS asu
		                         where asu.SYS_GUID is  null
		                         and prc.asu_id = asu.asu_id
		                         and asu.USUARIOCREAR = ''MIGRAHAYA02PCO''
		                         )';
	execute immediate(V_MSQL);
		                         
	V_MSQL:='	
	update '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar
	  set borrado=1
	where tar.asu_id = (select asu.asu_id from '||V_ESQUEMA||'.ASU_ASUNTOS asu
		                         where asu.SYS_GUID is  null
		                         and tar.asu_id = asu.asu_id
		                         and asu.USUARIOCREAR = ''MIGRAHAYA02PCO''
		                         )';      
	execute immediate(V_MSQL);                           

	V_MSQL:='	
	update '||V_ESQUEMA||'.ASU_ASUNTOS asu
	  set borrado=1
	 where asu.SYS_GUID is  null
	 and asu.USUARIOCREAR = ''MIGRAHAYA02PCO'' ';
	execute immediate(V_MSQL);


	V_MSQL:='
	update '||V_ESQUEMA||'.PRB_PRC_BIE PRB
	  set PRB.PRC_ID = ''100218556''
	 where PRB.PRC_ID = ''100154818'' ';
	execute immediate(V_MSQL);
	
	V_MSQL:='	 
	update '||V_ESQUEMA||'.PRB_PRC_BIE PRB
	  set PRB.PRC_ID = ''100218893''
	 where PRB.PRC_ID = ''100147130'' ';

        execute immediate(V_MSQL);

  DBMS_OUTPUT.PUT_LINE('Actualizado correctamente');

ELSE
  DBMS_OUTPUT.PUT_LINE('Proceso ya ejecutado, no se vuelve a ejecutar');

END IF;

COMMIT;

 EXCEPTION

 WHEN OTHERS THEN  
   err_num := SQLCODE;
   err_msg := SQLERRM;

   DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
   DBMS_OUTPUT.put_line(err_msg);
  
   ROLLBACK;
   RAISE;
 END;
  /
 EXIT;

--##########################################
--## Author: Roberto
--## Finalidad: DML para cambiar el nombre de los asuntos creados para las pruebas
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    --V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    TOTAL_INSERTS NUMBER(7); -- Variable para controlar el número de inserts realizados
    TOTAL NUMBER(7); -- Variable contador TOTAL
    
    --Nombres de las personas de la base de datos    
	CURSOR cursor_personas is    
		select substr(per_nombre, 0, 20) per_nombre
		from (
				select distinct(per_nombre) per_nombre 
    			from per_personas);
		
	PERSONA cursor_personas%ROWTYPE;
	
		
	--Nombres de los asuntos que hay que actualizar
	CURSOR cursor_asuntos is 
			select a.asu_id asu_id, a.asu_nombre asu_nombre
			from asu_asuntos a
			inner join (
			  select asu_nombre
			  from (
			    select count(1) total, asu_nombre
			    from asu_asuntos
			    where borrado=0
			    group by asu_nombre)
			  where total>1
			) asu_nombre_dupli on asu_nombre_dupli.asu_nombre=a.asu_nombre	
	  	union all  
			select asu_id, asu_nombre 
			from asu_asuntos 
			where asu_nombre like 'ARTELAN RESTAURACION, S.L.%';

BEGIN	 
		
	--Creo una tabla con la copia de los datos que voy a cambiar por si hace falta restaurar sus nombres
	V_MSQL := ' create table asu_asuntos_copiacambionombre as select asu_id, asu_nombre from asu_asuntos ';
			
	--DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	
	TOTAL_INSERTS := 0;
	TOTAL := 0;
	
	DBMS_OUTPUT.PUT_LINE('Empieza el proceso de actualización de nombres de asuntos.');
	
	--Abro el cursor de personas para coger cada vez un nombre y no repetirlo
	OPEN cursor_personas;	
	
	FOR asuntos in cursor_asuntos
	LOOP
	
		--Avanzo el cursor de personas
		FETCH cursor_personas INTO PERSONA;
		EXIT WHEN cursor_personas%NOTFOUND;
		
	
		V_MSQL := ' update asu_asuntos '
				||' set asu_nombre=''EMP. '||PERSONA.per_nombre||' , S.L. '||asuntos.asu_id||''' '
				||' where asu_id='||asuntos.asu_id;
				
		--DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;		

		TOTAL_INSERTS := TOTAL_INSERTS + 1;
		TOTAL := TOTAL + 1; 
		
		if (TOTAL_INSERTS=2000) then		
			commit;				
			DBMS_OUTPUT.PUT_LINE('Actualizados '||TOTAL);
			TOTAL_INSERTS := 0; 
		end if;
	END LOOP;
	
	COMMIT;
	
	--Cierro el cursor de personas
	CLOSE cursor_personas;		

	DBMS_OUTPUT.PUT_LINE('Se han cambiado '||TOTAL||' nombres de asuntos. Proceso finalizado correctamente.');
	
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
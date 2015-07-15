---------------------------------------------------------
-- CARACTERIZACION DE USUARIOS NORMALES
---------------------------------------------------------

--##########################################
--## Author: Josevi
--## Adaptación: Roberto
--## Finalidad: DML para crear usuarios de prueba
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2
--##########################################
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    TOTAL_INSERTS NUMBER(3); -- Variable para controlar el número de inserts realizados
    
    --Asuntos para nuestros usuarios
    /*
	CURSOR todos_los_asuntos is 
		select *
		from (
			select asu_id, rownum fila
			from asu_asuntos
		)
		where fila < 780;
	*/
    
	CURSOR todos_los_asuntos is    
		select * from (
		    
		    --CONCURSALES: T. fase común Haya - HAYA
		    select a.asu_id
		    from asu_asuntos a
		    inner join prc_procedimientos p on p.asu_id=a.asu_id
		    inner join dd_tpo_tipo_procedimiento tp on p.dd_tpo_id=tp.dd_tpo_id
		    left outer join gaa_gestor_adicional_asunto gaa on gaa.asu_id=a.asu_id and gaa.dd_tge_id in (
		        select dd_tge_id 
		        from HAYAMASTER.dd_tge_tipo_gestor
		        where dd_tge_codigo in ('LETR')
		        )
		    where gaa.gaa_id is null
		        and tp.dd_tpo_codigo='H009'
		        and rownum<501
		    
		    UNION ALL
		    
		    --LITIGIOS: T. de aceptacion y decision litigios - HAYA
		    select a.asu_id
		    from asu_asuntos a
		    inner join prc_procedimientos p on p.asu_id=a.asu_id
		    inner join dd_tpo_tipo_procedimiento tp on p.dd_tpo_id=tp.dd_tpo_id
		    left outer join gaa_gestor_adicional_asunto gaa on gaa.asu_id=a.asu_id and gaa.dd_tge_id in (
		        select dd_tge_id 
		        from HAYAMASTER.dd_tge_tipo_gestor
		        where dd_tge_codigo in ('LETR')
		        )
		    where gaa.gaa_id is null
		        and tp.dd_tpo_codigo='P420'
		        and rownum<701
		    
		    UNION ALL
		    
		    --LITIGIOS: P. hipotecario - HAYA
		    select a.asu_id
		    from asu_asuntos a
		    inner join prc_procedimientos p on p.asu_id=a.asu_id
		    inner join dd_tpo_tipo_procedimiento tp on p.dd_tpo_id=tp.dd_tpo_id
		    left outer join gaa_gestor_adicional_asunto gaa on gaa.asu_id=a.asu_id and gaa.dd_tge_id in (
		        select dd_tge_id 
		        from HAYAMASTER.dd_tge_tipo_gestor
		        where dd_tge_codigo in ('LETR')
		        )
		    where gaa.gaa_id is null
		        and tp.dd_tpo_codigo='H001'
		        and rownum<1101
		    
		);    
		
	--Usuarios gestors y supervisores nuestros
	CURSOR todos_los_gestores is 
		select tg.dd_tge_id, ud.usd_id, u.usu_username, u.usu_id
		from HAYAMASTER.dd_tge_tipo_gestor tg
			inner join tgp_tipo_gestor_propiedad tgp on tgp.dd_tge_id=tg.dd_tge_id
			inner join HAYAMASTER.dd_tde_tipo_despacho td on td.dd_tde_codigo=tgp.tgp_valor
			inner join des_despacho_externo de on de.dd_tde_id=td.dd_tde_id
			inner join usd_usuarios_despachos ud on ud.des_id=de.des_id
			inner join HAYAMASTER.usu_usuarios u on u.usu_id=ud.usu_id
			where tg.dd_tge_codigo in (
			      --'GEXT',
			      --'SUP',
			      --'PROC',
			      'GEST',
			      'LETR',
			      'SUCL',
			      'GUCL',
			      'GSUB',
			      'SSUB',
			      'GDEU',
			      'SDEU',
			      'GSDE',
			      'SSDE',
			      'UCON',
			      'SCON',
			      'UFIS',
			      'SFIS',
			      'GAREO',
			      'SAREO',
			      'DUCL',
			      'GGADJ',
            'GGSAN'
			      --, 'SGADJ', 'SGSAN'
			      )
			    and u.usu_username in (
			      'DTOR_UCL',
			      'SUPER_UCL',
			      'GEST_UCL',
			      'GEST_SUB',
			      'SUPER_SUB',
			      'GEST_DEUDA',
			      'SUP_DEUDA',
			      'GEST_SOP',
			      'SUPER_SOP',
			      'GEST_CONT',
			      'SUPER_CONT',
			      'GEST_FISC',
			      'SUPER_FISC',
			      'GEST_ADM',
			      'SUPER_ADM' ,     
			      'LETRADO',
			      'GESTORIA',
			      'GEST_SAN',
			      'GEST_ADJ'
			    );
BEGIN	  
	
	TOTAL_INSERTS := 0;
	
	FOR asuntos in todos_los_asuntos
	LOOP
		--Por cada asuntos inserto el tipo de gestor si no lo tiene ya
		FOR gestores in todos_los_gestores
		LOOP
		
			--Sólo si no tiene el usuario y tipo de gestor ya asignados lo doy de alta
			V_SQL := 'select count(1) from gaa_gestor_adicional_asunto where asu_id='||asuntos.asu_id||' and dd_tge_id='||gestores.dd_tge_id;
            --DBMS_OUTPUT.PUT_LINE(V_SQL);
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS < 1 THEN 
		
			   	--Saco el insert a realizar por cada tipo de gestor que tengo que carterizar	
				V_MSQL := 'insert into gaa_gestor_adicional_asunto (gaa_id, asu_id, usd_id, dd_tge_id, version, usuariocrear, fechacrear, borrado)'
				    		|| ' values ('
				    		
							|| 's_gaa_gestor_adicional_asunto.nextval,'
							|| asuntos.asu_id || ','
							|| gestores.usd_id || ','
							|| gestores.dd_tge_id || ','
							|| '0,'
							|| ' ''GESTOR'','
							|| 'sysdate,'
							|| '0'
							|| ')';
							
				--DBMS_OUTPUT.PUT_LINE(V_MSQL);
				EXECUTE IMMEDIATE V_MSQL;
								
				V_MSQL := 'insert into gah_gestor_adicional_historico'
							|| ' ('
							|| ' gah_id, '
							|| ' gah_gestor_id, '
							|| ' gah_asu_id, '
							|| ' gah_tipo_gestor_id, '
							|| ' gah_fecha_desde, '
							|| ' version, '
							|| ' usuariocrear, '
							|| ' fechacrear, '
							|| ' borrado'
							|| ' )'
							|| ' values '
							|| ' ('
							|| ' S_GAH_GESTOR_ADIC_HISTORICO.nextval,'
							|| gestores.usd_id || ','
							|| asuntos.asu_id || ','
							|| gestores.dd_tge_id || ','
							|| ' sysdate,'
							|| ' 0,'
							|| ' ''GESTOR'','
							|| ' sysdate,'
							|| ' 0'
							|| ' )';
							
				--DBMS_OUTPUT.PUT_LINE(V_MSQL);
				EXECUTE IMMEDIATE V_MSQL;							
				
				TOTAL_INSERTS := TOTAL_INSERTS + 1; 
				
				if (TOTAL_INSERTS=100) then		
					commit;					
					TOTAL_INSERTS := 0; 
				end if;
							
				--DBMS_OUTPUT.PUT_LINE('El usuario '||gestores.usu_username||' ha sido dado de alta como gestor para el asunto con asu_id='||asuntos.asu_id);				
			END IF;

		END LOOP;
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('Usuarios gestores y supervisores de prueba ya asignados.');
	
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('El proceso ha finalizado correctamente.');
	
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
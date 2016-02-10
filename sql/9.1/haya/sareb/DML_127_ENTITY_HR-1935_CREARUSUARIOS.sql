--/*
--##########################################
--## AUTOR=Joaquín Sánchez Valverde
--## FECHA_CREACION=20160210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=HR-1935
--## PRODUCTO=NO
--## Finalidad: DML resolucion peticion HR-1915 del cliente Haya.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO_EJECUTA VARCHAR2(25 CHAR):= 'HR-1935'; -- Usuario que EJECUTA el paquete.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    ERR_BUCLE VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el bucle donde estamos.
	
	V_TABLA VARCHAR2(100 CHAR);--Campo de búsqueda.
	V_CAMPO VARCHAR2(100 CHAR);--Campo de búsqueda.
	V_VALOR VARCHAR2(1000 CHAR);--Valor buscado.

	/*
	1 Ldap, 
	2 entidad, 
	3 clave, 
	4 nombre, 
	5 apellidos1, 
	6 apellidos 2,
	7 correo - mail , 
	8 zona,
	9 pef_codigo
	10 despacho,
	11 grupo,
	12 tipo despacho
  13 externo 
	*/
	--Valores a insertar
    TYPE T_TIPO_DATO IS TABLE OF VARCHAR2(3500);
    TYPE T_ARRAY_DATO IS TABLE OF T_TIPO_DATO;
    V_TIPO_DATO T_ARRAY_DATO := T_ARRAY_DATO(  
      T_TIPO_DATO('let.joliver','HAYA','Haya510','José','Oliver','Mompó','joliver@oliverabogados.com','01','HAYAGESTEXT','OLIVER ABOGADOS Y ECONOMISTAS','GRUPO - OLIVER ABOGADOS Y ECONOMISTAS','1','1'),
      T_TIPO_DATO('let.agarciaj','HAYA','Haya510','Anna','García','Juncà','anna.gjunca@oliveradvocats.com','01','HAYAGESTEXT','OLIVER ABOGADOS Y ECONOMISTAS','GRUPO - OLIVER ABOGADOS Y ECONOMISTAS','1','1'),
      T_TIPO_DATO('let.phernandez','HAYA','Haya510','Pablo','Hernandez','Cebrecos','phernandez@corporatealia.com','01','HAYAGESTEXT','CORPORATE ALIA ABOGADOS S.L.P.','GRUPO - CORPORATE ALIA ABOGADOS S.L.P.','1','1'),
      T_TIPO_DATO('let.jlopez','HAYA','Haya510','Javier','Lopez','Lopez','jlopez@corporatealia.com','01','HAYAGESTEXT','CORPORATE ALIA ABOGADOS S.L.P.','GRUPO - CORPORATE ALIA ABOGADOS S.L.P.','1','1'),
      T_TIPO_DATO('let.svalls','HAYA','Haya510','Silvia','Valls','Guardiola','svalls@corporatealia.com','01','HAYAGESTEXT','CORPORATE ALIA ABOGADOS S.L.P.','GRUPO - CORPORATE ALIA ABOGADOS S.L.P.','1','1'),
      T_TIPO_DATO('mhereza','HAYA','Haya510','María Raquel','Hereza','Amezcua','mhereza@haya.es','01','HAYACONSULTA','','','','0')   
    ); 
    V_TMP_TIPO_DATO T_TIPO_DATO;
	
		
BEGIN

	V_TABLA := 'usu_usuarios';
	V_CAMPO := 'usuariocrear';
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.' || V_TABLA || ' WHERE ' || V_CAMPO || '= '''||V_USUARIO_EJECUTA||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
	IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya se ejecuto el proceso:'''||V_USUARIO_EJECUTA);
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INICIO-PROCEDIMIENTO] -----------' || V_USUARIO_EJECUTA  || '---------- - PROCEDIMIENTO');  
		ERR_BUCLE :='Crear usuarios';
		FOR I IN V_TIPO_DATO.FIRST .. V_TIPO_DATO.LAST LOOP
DBMS_OUTPUT.PUT_LINE('[INICIO] FOR');		
			V_TMP_TIPO_DATO := V_TIPO_DATO(I);
			-- Creamos el fichero adjunto si no existe
			V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.usu_usuarios usu WHERE usu.usu_username = ''' || V_TMP_TIPO_DATO(1) || ''' ';
			DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
      IF V_NUM_TABLAS < 1 THEN
--USUARIO        
        V_MSQL := 'INSERT INTO ' || V_ESQUEMA_M || '.usu_usuarios (usu_id, entidad_id, usu_username,usu_password,usu_nombre,usu_apellido1,usu_apellido2,usu_mail,usuariocrear,fechacrear,usu_externo,usu_grupo) VALUES ('
					|| V_ESQUEMA_M ||'.s_usu_usuarios.nextval,(SELECT ENT.ID FROM ' || V_ESQUEMA_M || '.ENTIDAD  ENT WHERE ENT.DESCRIPCION = ''' || V_TMP_TIPO_DATO(2) || '''),'
					|| '''' || V_TMP_TIPO_DATO(1) || ''','
					|| '''' || V_TMP_TIPO_DATO(3) || ''','
					|| '''' || V_TMP_TIPO_DATO(4) || ''',''' || V_TMP_TIPO_DATO(5) || ''',''' || V_TMP_TIPO_DATO(6) || ''',''' || V_TMP_TIPO_DATO(7) || ''','
					|| '''' || V_USUARIO_EJECUTA  || ''',sysdate,' || V_TMP_TIPO_DATO(13) || ',0)'
				;
				DBMS_OUTPUT.PUT_LINE(V_MSQL);	
        EXECUTE IMMEDIATE V_MSQL;
--zona				
				V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.zon_pef_usu zpu ( zpu.zpu_id,zpu.zon_id, zpu.pef_id,zpu.usu_id,zpu.usuariocrear,zpu.fechacrear ) VALUES ('
					|| V_ESQUEMA ||'.s_zon_pef_usu.nextval, (SELECT MAX(zon_id) FROM ' || V_ESQUEMA || '.zon_zonificacion WHERE zon_cod =''' || V_TMP_TIPO_DATO(8) || '''),'
					|| '(SELECT pef.pef_id FROM ' || V_ESQUEMA || '.pef_perfiles pef WHERE pef.pef_codigo = ''' || V_TMP_TIPO_DATO(9) || ''' ),'
					|| '(SELECT usu.usu_id FROM ' || V_ESQUEMA_M || '.usu_usuarios usu WHERE usu.usu_username = ''' || V_TMP_TIPO_DATO(1) || ''' ) ,'
					|| '''' || V_USUARIO_EJECUTA  || ''',sysdate)'
				;
				DBMS_OUTPUT.PUT_LINE(V_MSQL);	
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('Creado el usuario ' || V_TMP_TIPO_DATO(1) ||' correctamente.');

        IF V_TMP_TIPO_DATO(10) is not null THEN
          V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA ||'.des_despacho_externo des WHERE des.des_despacho = ''' || V_TMP_TIPO_DATO(10) || ''' ';
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
          IF V_NUM_TABLAS < 1 THEN
            --Creamos DESPACHO
            V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.des_despacho_externo des (des_id, des_despacho, dd_tde_id, zon_id, usuariocrear, fechacrear) VALUES ('
              || V_ESQUEMA ||'.s_des_despacho_externo.nextval,''' || V_TMP_TIPO_DATO(10) || ''','
              || '(SELECT dd_tde_id FROM ' || V_ESQUEMA_M || '.dd_tde_tipo_despacho WHERE dd_tde_codigo = ''' || V_TMP_TIPO_DATO(12) || ''' ) ,'
              || '(SELECT MAX(zon_id) FROM ' || V_ESQUEMA || '.zon_zonificacion WHERE zon_cod =''' || V_TMP_TIPO_DATO(8) || '''),'
              || '''' || V_USUARIO_EJECUTA  || ''',sysdate)'
            ;
            DBMS_OUTPUT.PUT_LINE(V_MSQL);	
            EXECUTE IMMEDIATE V_MSQL;
            --Creamos GRUPO
            V_MSQL := 'INSERT INTO ' || V_ESQUEMA_M || '.usu_usuarios (usu_id, entidad_id, usu_username,usu_password,usu_nombre,usu_apellido1,usu_apellido2,usu_mail,usuariocrear,fechacrear,usu_externo,usu_grupo) VALUES ('
              || V_ESQUEMA_M ||'.s_usu_usuarios.nextval,(SELECT ENT.ID FROM ' || V_ESQUEMA_M || '.ENTIDAD  ENT WHERE ENT.DESCRIPCION = ''' || V_TMP_TIPO_DATO(2) || '''),'
              || '''' || V_TMP_TIPO_DATO(11) || ''','
              || '''null'','
              || '''' || V_TMP_TIPO_DATO(11) || ''',''null'',''null'',''null'','
              || '''' || V_USUARIO_EJECUTA  || ''',sysdate, 1,1)'
            ;
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            --Relacionamos DESPACHO y GRUPO
            V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.usd_usuarios_despachos (usd_id,usu_id,des_id,usd_gestor_defecto,usd_supervisor,usuariocrear,fechacrear) VALUES ('
              || V_ESQUEMA ||'.s_usd_usuarios_despachos.nextval,(SELECT usu.usu_id FROM  ' || V_ESQUEMA_M || '.usu_usuarios usu WHERE usu.usu_username = ''' || V_TMP_TIPO_DATO(11) || '''),'
              || '(SELECT des.des_id FROM ' || V_ESQUEMA || '.des_despacho_externo des WHERE des.borrado = 0 AND des.DES_DESPACHO = ''' || V_TMP_TIPO_DATO(10) || ''' ),'
              || '1,0,''' || V_USUARIO_EJECUTA  || ''',sysdate)'
            ;
            DBMS_OUTPUT.PUT_LINE(V_MSQL);	
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('Creado Despacho ' || V_TMP_TIPO_DATO(10));
          ELSE --fichero adjunto ya existe
            DBMS_OUTPUT.PUT_LINE('Despacho existe: '||V_TMP_TIPO_DATO(1)||' NO se creará de nuevo otra vez.');				
          END IF;	 --fin Si no existe el fichero adjunto lo damos de alta
--asignamos a Despacho a usuario
          V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.usd_usuarios_despachos (usd_id,usu_id,des_id,usd_gestor_defecto,usd_supervisor,usuariocrear,fechacrear) VALUES ('
            || V_ESQUEMA ||'.s_usd_usuarios_despachos.nextval,(SELECT usu.usu_id FROM  ' || V_ESQUEMA_M || '.usu_usuarios usu WHERE usu.usu_username = ''' || V_TMP_TIPO_DATO(1) || '''),'
            || '(SELECT des.des_id FROM ' || V_ESQUEMA || '.des_despacho_externo des WHERE des.borrado = 0 AND des.DES_DESPACHO = ''' || V_TMP_TIPO_DATO(10) || ''' ),'
            || '0,0,''' || V_USUARIO_EJECUTA  || ''',sysdate)'
          ;
          DBMS_OUTPUT.PUT_LINE(V_MSQL);	
          EXECUTE IMMEDIATE V_MSQL;
--Asignamos GRUPO A USUARIO
          V_MSQL := 'INSERT INTO ' || V_ESQUEMA_M || '.GRU_GRUPOS_USUARIOS (GRU_ID,USU_ID_USUARIO,USU_ID_GRUPO,USUARIOCREAR,FECHACREAR) VALUES ('
            || V_ESQUEMA_M ||'.S_GRU_GRUPOS_USUARIOS.nextval,(SELECT usu.usu_id FROM  ' || V_ESQUEMA_M || '.usu_usuarios usu WHERE usu.usu_username = ''' || V_TMP_TIPO_DATO(1) || '''),'
            || '(SELECT usugrupo.usu_id FROM ' || V_ESQUEMA || '.usd_usuarios_despachos usdgrupo INNER JOIN ' || V_ESQUEMA_M 
            || '.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1  WHERE usugrupo.borrado  = 0 AND usugrupo.usu_username = ''' || V_TMP_TIPO_DATO(11) || ''' ),'''
            || V_USUARIO_EJECUTA  || ''',sysdate)'
          ;
          DBMS_OUTPUT.PUT_LINE(V_MSQL);	
          EXECUTE IMMEDIATE V_MSQL;
        ELSE
          DBMS_OUTPUT.PUT_LINE('El usuario ' || V_TMP_TIPO_DATO(1) || ' No tiene despacho $-' || V_TMP_TIPO_DATO(10) || '-$');
        END IF;
      ELSE
        DBMS_OUTPUT.PUT_LINE('El usuario ' || V_TMP_TIPO_DATO(1) || ' ya existe. NO se creará de nuevo otra vez.');
      END IF;
      DBMS_OUTPUT.PUT_LINE('[FIN] FOR');
		END LOOP;  
	END IF;	

  COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN PROCEDIMIENTO]******** ' || V_USUARIO_EJECUTA  || ' ********'); 
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
	DBMS_OUTPUT.put_line('[ERROR PROCEDIMIENTO]-----------' || V_USUARIO_EJECUTA  || '-----------');
	DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución del bucle:'||ERR_BUCLE);
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('[FIN PROCEDIMIENTO]-------------' || V_USUARIO_EJECUTA  || '-----------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
    
END;
/

EXIT;

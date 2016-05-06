--/*
--##########################################
--## AUTOR=Joaquín Sánchez Valverde
--## FECHA_CREACION=20160505
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=
--## INCIDENCIA_LINK=CMREC-3065_050516 ZON USUARIO
--## PRODUCTO=NO
--## Finalidad: DML que crea el despacho apoderado y los apoderados, son usuarios sin acceso a recovery
--##           
--## INSTRUCCIONES: solo se debe ejecutar para Cajamar val02
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'CM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; --'CMMASTER';--'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO_EJECUTA VARCHAR2(25 CHAR):= 'CMREC-3065_050516'; -- Usuario que EJECUTA el paquete.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    ERR_BUCLE VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el bucle donde estamos.

	V_TAREA VARCHAR2(1024 CHAR); -- Vble. descripcion de lo que hace el proceso
	V_CLAVE VARCHAR2(50 CHAR):='1234'; -- Vble. clave que se le asigna de inicio
    --Valores a insertar
/*
1.- USU_USERNAME LDAP
2.- ENTIDAD A LA QUE PERTENECE EL USUARIO
3.- NOMBRE
4.- APELLIDO 1
5.-	APELLIDO 2
6.- MAIL
7.- usu_externo
8.- usu_grupo
9.- NUM_CEMTRO
10.-PER_PERFIL
*/
    TYPE T_TIPO_DATO IS TABLE OF VARCHAR2(350);
    TYPE T_ARRAY_DATO IS TABLE OF T_TIPO_DATO;
    V_TIPO_DATO T_ARRAY_DATO := T_ARRAY_DATO(  
		T_TIPO_DATO('aor47049','ANTONIO','OLCINA ','ROCAMORA','aolcina@caixapetrer.es',0,0,'CAJAMAR','03029724104','OFI_OFICINA'),
		T_TIPO_DATO('avv47023','ADELA','VERDU ','VERDU','averdu@caixapetrer.es',0,0,'CAJAMAR','03029724104','OFI_OFICINA'),
		T_TIPO_DATO('bbs47038','BEATRIZ','BAÑON ','SANCHEZ','bbanon@caixapetrer.es',0,0,'CAJAMAR','03029724104','OFI_OFICINA'),
		T_TIPO_DATO('jna47055','JUAN LUIS','NAVARRO ','ANGEL','jlnavarro@caixapetrer.es',0,0,'CAJAMAR','03029724104','OFI_OFICINA'),
		T_TIPO_DATO('msp4514','MATEO','SANCHEZ ','PEREZ','mateosanchez@cajamar.com',0,0,'CAJAMAR','03058042604','OFI_OFICINA'),
		T_TIPO_DATO('emc10433','Emilio','Martinez','Castellon','emartinezcastellon@externos.cajamar.es',0,0,'CAJAMAR','00240024000','CON_CONSULTA'),
		T_TIPO_DATO('vfl21235','VICENTE','FENOLLOSA','LLUESMA','vicentefenollosa@cajamar.com',0,0,'CAJAMAR','03058217704','OFI_OFICINA'),
		T_TIPO_DATO('edb1922','Emilio Jesús','Del Aguila','Berenguel','emilio_aguila@bcc.es',0,0,'CAJAMAR','00240024000','CON_CONSULTA')
    ); 
    V_TMP_TIPO_DATO T_TIPO_DATO;
	
		
BEGIN
	
	V_TAREA :='Zonificamos los usuarios y se crean si no existencia';
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comenzando -----------' || V_TAREA || '----------');  

	DBMS_OUTPUT.PUT_LINE('[INICIO-PROCEDIMIENTO] -----------' || V_USUARIO_EJECUTA || '---------- - PROCEDIMIENTO');  
	ERR_BUCLE :='ZONIFICACION';

	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USUARIOCREAR = ''' || V_USUARIO_EJECUTA || ''' ';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS < 1 THEN
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_PEF_USU ZPU WHERE ZPU.USUARIOCREAR = ''' || V_USUARIO_EJECUTA || ''' ';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS < 1 THEN
			FOR I IN V_TIPO_DATO.FIRST .. V_TIPO_DATO.LAST LOOP	
				V_TMP_TIPO_DATO := V_TIPO_DATO(I);
				DBMS_OUTPUT.PUT_LINE('[INICIO] FOR '||I||'----------------------------------------------------------------- correctamente.');  
				V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME= ''' || V_TMP_TIPO_DATO(1) || ''' ';
				DBMS_OUTPUT.PUT_LINE(V_MSQL);
				EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
				IF V_NUM_TABLAS < 1 THEN				
					DBMS_OUTPUT.PUT_LINE('El usuario :'|| V_TMP_TIPO_DATO(1) ||' no existe lo creamos');
					V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.USU_USUARIOS (USU_ID, ENTIDAD_ID,USU_USERNAME,USU_PASSWORD,USU_NOMBRE,USU_APELLIDO1,USU_APELLIDO2,USU_MAIL,USUARIOCREAR,FECHACREAR,USU_EXTERNO,USU_GRUPO,USU_FECHA_VIGENCIA_PASS) VALUES ('
						|| V_ESQUEMA_M ||'.s_usu_usuarios.nextval, (SELECT ENT.ID FROM '||V_ESQUEMA_M||'.ENTIDAD ENT WHERE ENT.DESCRIPCION = ''' || V_TMP_TIPO_DATO(8) || ''') , ''' || V_TMP_TIPO_DATO(1) || ''', null,'
						|| '''' || V_TMP_TIPO_DATO(3) || ''',''' || V_TMP_TIPO_DATO(4) || ''',''' || V_TMP_TIPO_DATO(5) || ''',''' || V_TMP_TIPO_DATO(6) || ''','
						|| '''' || V_USUARIO_EJECUTA || ''', SYSDATE,'|| V_TMP_TIPO_DATO(6) || ',' || V_TMP_TIPO_DATO(7) || ', SYSDATE + 60 )';
					DBMS_OUTPUT.PUT_LINE(V_MSQL);	
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('Creado el USUARIO adjunto '||V_TMP_TIPO_DATO(1)||' correctamente.');		
				ELSE
				--limpiamos
					V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ZON_PEF_USU ZPU WHERE ZPU.USU_ID = (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = ''' || V_TMP_TIPO_DATO(1) || ''') ';
					DBMS_OUTPUT.PUT_LINE(V_MSQL);
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('Linpiamos la zonificacion de '||V_TMP_TIPO_DATO(1)||' correctamente.');		
				END IF;		
				
				V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_ZONIFICACION ZON WHERE ZON.ZON_NUM_CENTRO = ''' || V_TMP_TIPO_DATO(9) || ''' ';
				DBMS_OUTPUT.PUT_LINE(V_MSQL);
				EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
				IF V_NUM_TABLAS >= 1 THEN				
					DBMS_OUTPUT.PUT_LINE('El usuario :'|| V_TMP_TIPO_DATO(1) ||' a la zona: ' ||V_TMP_TIPO_DATO(9)|| 'con perfil' || V_TMP_TIPO_DATO(10) );
					V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU ZPU (ZPU.ZPU_ID,ZPU.ZON_ID,ZPU.USU_ID,ZPU.PEF_ID,ZPU.USUARIOCREAR,ZPU.FECHACREAR) VALUES ('
						|| V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL,'
						|| '(SELECT MAX(ZON.ZON_ID) FROM '||V_ESQUEMA||'.ZON_ZONIFICACION ZON WHERE ZON.ZON_NUM_CENTRO ='''||V_TMP_TIPO_DATO(9)|| '''),'
						|| '(SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = ''' || V_TMP_TIPO_DATO(1) || '''),'
						|| '(SELECT PEF.PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES PEF WHERE PEF.PEF_CODIGO = UPPER(''' || V_TMP_TIPO_DATO(10) || ''')) ,'
						|| '''' || V_USUARIO_EJECUTA || ''', SYSDATE )';
				
					DBMS_OUTPUT.PUT_LINE(V_MSQL);	
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('Configurado el USUARIO '||V_TMP_TIPO_DATO(1)||' correctamente.');		
				
				ELSE
					DBMS_OUTPUT.PUT_LINE('El  Zona/Oficina ' || V_TMP_TIPO_DATO(9) || ' NO EXISTE.	');
				END IF;		
		
				DBMS_OUTPUT.PUT_LINE('[FIN] FOR '||I||'----------------------------------------------------------------- correctamente.');  
			END LOOP; 
  
			COMMIT;		
			DBMS_OUTPUT.PUT_LINE('[FIN PROCEDIMIENTO]******** ' || V_USUARIO_EJECUTA || ' ********'); 	
		ELSE 
			DBMS_OUTPUT.PUT_LINE('El  Procedimiento ' || V_USUARIO_EJECUTA || ' ya se ejecuto, NO se ejecutara de nuevo otra vez.');				
		END IF;	 			
	ELSE 
		DBMS_OUTPUT.PUT_LINE('El  Procedimiento ' || V_USUARIO_EJECUTA || ' ya se ejecuto, NO se ejecutara de nuevo otra vez.');				
	END IF;	 	
	
	EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
	DBMS_OUTPUT.put_line('[ERROR PROCEDIMIENTO]-----------' || V_USUARIO_EJECUTA || '-----------');
	DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución del bucle:'||ERR_BUCLE);
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('[FIN PROCEDIMIENTO]-------------' || V_USUARIO_EJECUTA || '-----------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
    
END;
/

EXIT;

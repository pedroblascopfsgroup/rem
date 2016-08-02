--/*
--##########################################
--## AUTOR=Rafael Aracil López
--## FECHA_CREACION=20160630
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2.5
--## INCIDENCIA_LINK=RECOVERY-1794
--## PRODUCTO=NO
--## 
--## Finalidad: CAMBIAR PK BIEN_ESTADO_CESION_REMATE
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE

    V_MSQL VARCHAR2(32000 CHAR); /* Sentencia a ejecutar    */
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; /* Configuracion Esquema*/
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; /* Configuracion Esquema Master*/
    V_ESQUEMA_MINIREC VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; /* Configuracion Esquema Master*/
    V_TS_INDEX VARCHAR2(25 CHAR):= '#ESQUEMA#'; /* Configuracion Indice*/
    V_SQL VARCHAR2(4000 CHAR); /* Vble. para consulta que valida la existencia de una tabla.*/
    V_NUM_TABLAS NUMBER(16); /* Vble. para validar la existencia de una tabla.  */
    ERR_NUM NUMBER(25);  /* Vble. auxiliar para registrar errores en el script.*/
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.*/
   V_DDNAME VARCHAR2(50 CHAR):= 'BIEN_ESTADO_CESION_REMATE';
    V_TEXT1 VARCHAR2(2400 CHAR); /* Vble. auxiliar*/
     
    
       --Valores a insertar
    TYPE T_TIPO IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY IS TABLE OF T_TIPO;
    V_TIPO T_ARRAY := T_ARRAY(
      T_TIPO('VERSION', 'NUMBER(38,0)')
     ,T_TIPO('USUARIOCREAR', 'VARCHAR2(10 CHAR)')
     ,T_TIPO('FECHACREAR','TIMESTAMP(6)')
     ,T_TIPO('USUARIOMODIFICAR','VARCHAR2(10 CHAR)')
     ,T_TIPO('FECHAMODIFICAR','TIMESTAMP(6)')
     ,T_TIPO('USUARIOBORRAR','VARCHAR2(10 CHAR)')
     ,T_TIPO('FECHABORRAR','TIMESTAMP(6)')
     ,T_TIPO('BORRADO','NUMBER(1,0)')
    ); 
    
    V_TMP_TIPO T_TIPO;

    V_ENTIDAD_ID NUMBER(16);
    

BEGIN
	
    DBMS_OUTPUT.PUT_LINE('[START] CAMBIAMOS PK EN BIEN_ESTADO_CESION_REMATE');	
	
		SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_constraints WHERE UPPER(constraint_name) = 'PK_BIEN_CESION_REMATE' and UPPER(owner) = '' || V_ESQUEMA_MINIREC || '';
		
		IF V_NUM_TABLAS = 1 THEN
			EXECUTE IMMEDIATE 'ALTER TABLE '|| V_ESQUEMA_MINIREC ||'.BIEN_ESTADO_CESION_REMATE DROP PRIMARY KEY CASCADE';
			EXECUTE IMMEDIATE 'ALTER TABLE '|| V_ESQUEMA_MINIREC ||'.BIEN_ESTADO_CESION_REMATE
      ADD CONSTRAINT PK_BIEN_CESION_REMATE PRIMARY KEY (CODIGO_PROPIETARIO,TIPO_PRODUCTO,NUMERO_CONTRATO,NUMERO_ESPEC,NUMERO_ACTIVO_ADJUDICADO)';
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_MINIREC || '.BIEN_ESTADO_CESION_REMATE modificado: PK CREADA');
      
      ELSE
      
      EXECUTE IMMEDIATE 'ALTER TABLE '|| V_ESQUEMA_MINIREC ||'.BIEN_ESTADO_CESION_REMATE
      ADD CONSTRAINT PK_BIEN_CESION_REMATE PRIMARY KEY (CODIGO_PROPIETARIO,TIPO_PRODUCTO,NUMERO_CONTRATO,NUMERO_ESPEC,NUMERO_ACTIVO_ADJUDICADO)';
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_MINIREC || '.BIEN_ESTADO_CESION_REMATE modificado: PK CREADA');
		END IF;	
    
    V_NUM_TABLAS := 0;
	

  DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_MINIREC||'.' || V_DDNAME ||'... ALTER TABLE');
  FOR I IN V_TIPO.FIRST .. V_TIPO.LAST
   
       LOOP
            V_TMP_TIPO := V_TIPO(I);

 
            DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBAMOS SI EXISTE EL CAMPO '||V_TMP_TIPO(1)||' EN LA TABLA ' || V_DDNAME|| '');
            V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME='''||V_TMP_TIPO(1)||''' AND TABLE_NAME=''' || V_DDNAME|| ''' AND OWNER='''||V_ESQUEMA_MINIREC||'''';   
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            -- Si existe la tabla no hacemos nada
            IF V_NUM_TABLAS = 1 THEN 
            
            DBMS_OUTPUT.PUT_LINE('[INFO] EXISTE EL CAMPO '||V_TMP_TIPO(1)||' , NO HACEMOS NADA');
            
            
            ELSE
            
            DBMS_OUTPUT.PUT_LINE('NO EXISTE EL CAMPO, LO cREAMOS : '||V_TMP_TIPO(1)||'');
            EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA_MINIREC||'.' || V_DDNAME|| ' ADD '||V_TMP_TIPO(1)||' '||V_TMP_TIPO(2)||'';  

            end if;


       END LOOP;



    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');


 EXCEPTION


    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;

END;
/

EXIT;
	

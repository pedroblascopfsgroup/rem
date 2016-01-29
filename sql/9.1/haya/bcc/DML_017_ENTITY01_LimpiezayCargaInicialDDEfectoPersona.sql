--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20150728
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-445
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de Diccionarios de Efectos Persona Cajamar , esquema #ESQUEMA#.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error    
    V_MSQL VARCHAR2(5000);
    V_EXIST NUMBER(10);
    V_ENTIDAD_ID NUMBER(16);    
    

   --Tipo Relación Entre Efecto Y Personas
    TYPE T_TRE IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TRE IS TABLE OF T_TRE;

    V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';    
   
    V_TRE T_ARRAY_TRE := T_ARRAY_TRE(
                                     T_TRE('LIO','LIBRADO','LIBRADO'),
                                     T_TRE('LIB','LIBRADOR','LIBRADOR')                
                                    );
                                    
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/     
   
    V_TMP_TRE T_TRE;

 BEGIN

    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de PERSONA-EFECTO.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_TRE_TIPO_RELACION_EFECTO');
  
  
    DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
    V_ENTIDAD_ID:=0;
    
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_TRE_TIPO_RELACION_EFECTO' and sequence_owner=V_ESQUEMA;
    
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
	      DBMS_OUTPUT.PUT_LINE('Contador 1');
	      EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_TRE_TIPO_RELACION_EFECTO');
    end if;
    
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_TRE_TIPO_RELACION_EFECTO	
                         START WITH 1
	                       MAXVALUE 999999999999999999999999999
                         MINVALUE 1
	                       NOCYCLE
	                       CACHE 20
	                       NOORDER'
                     );	


   DBMS_OUTPUT.PUT_LINE('Creando DD_TRE_TIPO_RELACION_EFECTO......');
   FOR I IN V_TRE.FIRST .. V_TRE.LAST
   LOOP
   	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TRE_TIPO_RELACION_EFECTO.NEXTVAL FROM DUAL';
   	EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TRE := V_TRE(I);
      DBMS_OUTPUT.PUT_LINE('Creando TRE: '||V_TMP_TRE(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TRE_TIPO_RELACION_EFECTO (DD_TRE_ID, DD_TRE_CODIGO, DD_TRE_DESCRIPCION,' ||
		'DD_TRE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TRE(1)||''','''||V_TMP_TRE(2)||''','''
		 ||V_TMP_TRE(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_RELACION_EFECTO_PERSONA
   V_TMP_TRE := NULL;


   COMMIT;
   



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
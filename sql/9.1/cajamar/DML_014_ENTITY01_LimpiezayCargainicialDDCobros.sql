--/*
--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20150724
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-442
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de Diccionarios COBROS Cajamar , esquema CM01.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE

 
   TYPE T_TIPO_COBRO IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_COBRO IS TABLE OF T_TIPO_COBRO;
   
      TYPE T_ORIGEN_COBRO IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_ORIGEN_COBRO IS TABLE OF T_ORIGEN_COBRO;
   
      TYPE T_MOTIVO_COBRO IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_MOTIVO_COBRO IS TABLE OF T_MOTIVO_COBRO;
   

   
   
	
  -- Configuracion Esquemas
   V_ESQUEMA VARCHAR(25) := 'CM01';
   V_ESQUEMA_M VARCHAR(25) := 'CMMASTER';
   V_TipoContrado VARCHAR(50) := 'BNKContrato';

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';
   
   -- Configuracion Entidad
   V_ENTIDAD VARCHAR2(255) := 'CAJAMAR-CDD';
   V_WORKING_CODE VARCHAR2(255) := '3058';

						   
	
	 V_TIPO_INGRESO T_ARRAY_COBRO := T_ARRAY_COBRO(									
												T_TIPO_COBRO('1','ENTREGA PRIMER RECLAMADO                                            ','ENTREGA PRIMER RECLAMADO                                            '),
												T_TIPO_COBRO('2','ENTREGA OTROS RECLAMADOS                                            ','ENTREGA OTROS RECLAMADOS                                            '),
												T_TIPO_COBRO('3','ENTREGA TERCEROS POR CUENTA DEL RECLAMADO                           ','ENTREGA TERCEROS POR CUENTA DEL RECLAMADO                           '),
												T_TIPO_COBRO('4','TRASPASO POR DEPÓSITOS DE LOS RECLAMADOS                            ','TRASPASO POR DEPÓSITOS DE LOS RECLAMADOS                            '),
												T_TIPO_COBRO('5','REFINANCIACIÓN/REINSTRUMENTACIÓN                                    ','REFINANCIACIÓN/REINSTRUMENTACIÓN                                    '),
												T_TIPO_COBRO('6','DACIÓN EN PAGO DE DEUDA                                             ','DACIÓN EN PAGO DE DEUDA                                             '),
												T_TIPO_COBRO('7','ENTREGA JUDICIAL POR RETENCIÓN DE HABERES                           ','ENTREGA JUDICIAL POR RETENCIÓN DE HABERES                           '),
												T_TIPO_COBRO('8','ENTREGA JUDICIAL POR CESIÓN DE REMATE                               ','ENTREGA JUDICIAL POR CESIÓN DE REMATE                               '),
												T_TIPO_COBRO('9','ENTREGA JUDICIAL POR CONSIGNACIÓN DE DEUDA                          ','ENTREGA JUDICIAL POR CONSIGNACIÓN DE DEUDA                          '),
												T_TIPO_COBRO('10','ENTREGA JUDICIAL POR DEVOLUCIÓN DE REMANENTES                       ','ENTREGA JUDICIAL POR DEVOLUCIÓN DE REMANENTES                       '),
												T_TIPO_COBRO('11','ADJUDICACIÓN                                                        ','ADJUDICACIÓN                                                        '),
												T_TIPO_COBRO('12','CESIÓN DE CRÉDITO                                                   ','CESIÓN DE CRÉDITO                                                   '),
												T_TIPO_COBRO('13','QUITA/CONDONACIÓN (ACUERDO)                                         ','QUITA/CONDONACIÓN (ACUERDO)                                         '),
												T_TIPO_COBRO('14','QUITA/CONDONACIÓN/CANCELACIÓN (RESOLUCIÓN JUDICIAL)                 ','QUITA/CONDONACIÓN/CANCELACIÓN (RESOLUCIÓN JUDICIAL)                 '),
												T_TIPO_COBRO('15','TRASPASO A QUEBRANTOS (INCIDENCIAS DE GESTIÓN)                      ','TRASPASO A QUEBRANTOS (INCIDENCIAS DE GESTIÓN)                      '),
												T_TIPO_COBRO('16','PRESCRIPCIÓN                                                        ','PRESCRIPCIÓN                                                        '),
												T_TIPO_COBRO('17','REHABILITACIÓN POR OBLICACIÓN LEGAL (JUDICIAL)                      ','REHABILITACIÓN POR OBLICACIÓN LEGAL (JUDICIAL)                      '),
												T_TIPO_COBRO('18','REHABILITACIÓN POR OBLIGACIÓN LEGAL (EXTRAJUDICIAL)                 ','REHABILITACIÓN POR OBLIGACIÓN LEGAL (EXTRAJUDICIAL)                 '),
												T_TIPO_COBRO('19','REHABILITADO POR LA ENTIDAD                                         ','REHABILITADO POR LA ENTIDAD                                         '),
												T_TIPO_COBRO('20','REACTIVACION                                                        ','REACTIVACION                                                        '),
												T_TIPO_COBRO('21','QUITA POR CONVENIO DE ACREEDORES                                    ','QUITA POR CONVENIO DE ACREEDORES                                    '),
												T_TIPO_COBRO('22','ENTREGA POR CONVENIO DE ACREEDORES                                  ','ENTREGA POR CONVENIO DE ACREEDORES                                  '),
												T_TIPO_COBRO('23','QUITA RD6/12                                                        ','QUITA RD6/12                                                        '),
												T_TIPO_COBRO('24','ENTREGA DE EJECUCIÓN DE AVAL                                        ','ENTREGA DE EJECUCIÓN DE AVAL                                        '),
												T_TIPO_COBRO('25','TRASPASO DEUDA HIPOTECA MÁXIMOS                                     ','TRASPASO DEUDA HIPOTECA MÁXIMOS                                     '),
												T_TIPO_COBRO('26','ENTREGA CLIENTE                                                     ','ENTREGA CLIENTE                                                     '),
												T_TIPO_COBRO('27','ENTREGA TERCEROS                                                    ','ENTREGA TERCEROS                                                    '),
												T_TIPO_COBRO('28','ENTREGA VENTA PROMOCIÓN ASISTIDA                                    ','ENTREGA VENTA PROMOCIÓN ASISTIDA                                    '),
												T_TIPO_COBRO('29','ENTREGA POR SUBVENCIÓN DE OPERACIONES DE ACTIVO                     ','ENTREGA POR SUBVENCIÓN DE OPERACIONES DE ACTIVO                     '),
												T_TIPO_COBRO('30','ENTREGA SGR AVALISTA                                                ','ENTREGA SGR AVALISTA                                                '),
												T_TIPO_COBRO('31','ENTREGA POR CUENTA ICO                                              ','ENTREGA POR CUENTA ICO                                              '),
												T_TIPO_COBRO('32','ENTREGA POR RETROCESIÓN/ANULACIÓN DE CONVENIO ACREEDORES            ','ENTREGA POR RETROCESIÓN/ANULACIÓN DE CONVENIO ACREEDORES            '),
												T_TIPO_COBRO('33','ENTREGA POR SUBROGACIONES                                           ','ENTREGA POR SUBROGACIONES                                           '),
												T_TIPO_COBRO('34','ENTREGA POR RESOLUCION DE LEASING                                   ','ENTREGA POR RESOLUCION DE LEASING                                   '),
												T_TIPO_COBRO('35','LIQUIDACIÓN MANUAL                                                  ','LIQUIDACIÓN MANUAL                                                  '),
												T_TIPO_COBRO('36','CANCELACIÓN CUENTA AHORRO VISTA Y CRÉDITOS                          ','CANCELACIÓN CUENTA AHORRO VISTA Y CRÉDITOS                          '),
												T_TIPO_COBRO('37','DISPOSICIONES SUCESIVAS                                             ','DISPOSICIONES SUCESIVAS                                             '),
												T_TIPO_COBRO('38','LIQUIDACION                                                         ','LIQUIDACION                                                         '),
												T_TIPO_COBRO('39','MOTIVO AUTOMÁTICO APLICADORA (VER CÓDIGO TX EN TABLA MOCO)          ','MOTIVO AUTOMÁTICO APLICADORA (VER CÓDIGO TX EN TABLA MOCO)          '),
												T_TIPO_COBRO('40','ALTA GASTO                                                          ','ALTA GASTO                                                          '),
												T_TIPO_COBRO('41','COBRO POR CONFIRMING                                                ','COBRO POR CONFIRMING                                                '),
												T_TIPO_COBRO('42','VENTA DE CREDITO                                                    ','VENTA DE CREDITO                                                    '),
												T_TIPO_COBRO('43','QUITA/CONDONACIÓN POR ADJUDICACIÓN O DACIÓN                         ','QUITA/CONDONACIÓN POR ADJUDICACIÓN O DACIÓN                         '),
												T_TIPO_COBRO('44','MOTIVO AUTOMÁTICO PARA ENTREGAS                                     ','MOTIVO AUTOMÁTICO PARA ENTREGAS                                     '),
												T_TIPO_COBRO('45','MOTIVO AUTOMÁTICO PARA CANCELACIÓN DE LEASING Y OTRO TIPO DE CUENTAS','MOTIVO AUTOMÁTICO PARA CANCELACIÓN DE LEASING Y OTRO TIPO DE CUENTAS'),
												T_TIPO_COBRO('46','RECLAMACIÓN PÓLIZA MULTIPRODUCTO                                    ','RECLAMACIÓN PÓLIZA MULTIPRODUCTO                                    ')
                                   );
								   
								 
  V_ORIGEN_COBRO T_ARRAY_ORIGEN_COBRO := T_ARRAY_ORIGEN_COBRO(									
												T_ORIGEN_COBRO('000','SIN VALORES','SIN VALORES')
                                   );	

 V_MOTIVO_COBRO T_ARRAY_MOTIVO_COBRO := T_ARRAY_MOTIVO_COBRO(									
												T_MOTIVO_COBRO('01','ENTREGA PRIMER RECLAMADO ','ENTREGA PRIMER RECLAMADO '),
												T_MOTIVO_COBRO('02','ENTREGA OTROS RECLAMADOS ','ENTREGA OTROS RECLAMADOS '),
												T_MOTIVO_COBRO('03','ENTREGA TERCEROS POR CUENTA DEL RECLAMADO ','ENTREGA TERCEROS POR CUENTA DEL RECLAMADO '),
												T_MOTIVO_COBRO('04','TRASPASO POR DEPÓSITOS DE LOS RECLAMADOS ','TRASPASO POR DEPÓSITOS DE LOS RECLAMADOS '),
												T_MOTIVO_COBRO('05','REFINANCIACIÓN/REINSTRUMENTACIÓN ','REFINANCIACIÓN/REINSTRUMENTACIÓN '),
												T_MOTIVO_COBRO('06','DACIÓN/ADJUDICACIÓN EN PAGO DE DEUDA ','DACIÓN/ADJUDICACIÓN EN PAGO DE DEUDA '),
												T_MOTIVO_COBRO('07','ENTREGA JUDICIAL POR RETENCIÓN DE HABERES ','ENTREGA JUDICIAL POR RETENCIÓN DE HABERES '),
												T_MOTIVO_COBRO('08','ENTREGA JUDICIAL POR CESIÓN DE REMATE ','ENTREGA JUDICIAL POR CESIÓN DE REMATE '),
												T_MOTIVO_COBRO('09','ENTREGA JUDICIAL POR CONSIGNACIÓN DE DEUDA ','ENTREGA JUDICIAL POR CONSIGNACIÓN DE DEUDA '),
												T_MOTIVO_COBRO('10','ENTREGA JUDICIAL POR DEVOLUCIÓN DE REMANENTES ','ENTREGA JUDICIAL POR DEVOLUCIÓN DE REMANENTES '),
												T_MOTIVO_COBRO('11','ADJUDICACIÓN ','ADJUDICACIÓN '),
												T_MOTIVO_COBRO('12','CESIÓN DE CRÉDITO ','CESIÓN DE CRÉDITO '),
												T_MOTIVO_COBRO('13','QUITA/CONDONACIÓN (ACUERDO) ','QUITA/CONDONACIÓN (ACUERDO) '),
												T_MOTIVO_COBRO('14','QUITA/CONDONACIÓN/CANCELACIÓN (RESOLUCIÓN JUDICIAL) ','QUITA/CONDONACIÓN/CANCELACIÓN (RESOLUCIÓN JUDICIAL) '),
												T_MOTIVO_COBRO('15','TRASPASO A QUEBRANTOS (INCIDENCIAS DE GESTIÓN) ','TRASPASO A QUEBRANTOS (INCIDENCIAS DE GESTIÓN) '),
												T_MOTIVO_COBRO('16','PRESCRIPCIÓN ','PRESCRIPCIÓN '),
												T_MOTIVO_COBRO('17','REHABILITACIÓN POR OBLICACIÓN LEGAL (JUDICIAL) ','REHABILITACIÓN POR OBLICACIÓN LEGAL (JUDICIAL) '),
												T_MOTIVO_COBRO('18','REHABILITACIÓN POR OBLIGACIÓN LEGAL (EXTRAJUDICIAL) ','REHABILITACIÓN POR OBLIGACIÓN LEGAL (EXTRAJUDICIAL) '),
												T_MOTIVO_COBRO('19','REHABILITADO POR LA ENTIDAD ','REHABILITADO POR LA ENTIDAD '),
												T_MOTIVO_COBRO('20','REACTIVACION ','REACTIVACION '),
												T_MOTIVO_COBRO('21','QUITA POR CONVENIO DE ACREEDORES ','QUITA POR CONVENIO DE ACREEDORES '),
												T_MOTIVO_COBRO('22','ENTREGA POR CONVENIO DE ACREEDORES ','ENTREGA POR CONVENIO DE ACREEDORES '),
												T_MOTIVO_COBRO('23','QUITA RD6/12 ','QUITA RD6/12 '),
												T_MOTIVO_COBRO('24','ENTREGA DE EJECUCIÓN DE AVAL ','ENTREGA DE EJECUCIÓN DE AVAL '),
												T_MOTIVO_COBRO('25','TRASPASO DEUDA HIPOTECA MÁXIMOS ','TRASPASO DEUDA HIPOTECA MÁXIMOS '),
												T_MOTIVO_COBRO('26','ENTREGA CLIENTE ','ENTREGA CLIENTE '),
												T_MOTIVO_COBRO('27','ENTREGA TERCEROS ','ENTREGA TERCEROS '),
												T_MOTIVO_COBRO('28','ENTREGA VENTA PROMOCIÓN ASISTIDA ','ENTREGA VENTA PROMOCIÓN ASISTIDA '),
												T_MOTIVO_COBRO('29','ENTREGA POR SUBVENCIÓN DE OPERACIONES DE ACTIVO ','ENTREGA POR SUBVENCIÓN DE OPERACIONES DE ACTIVO '),
												T_MOTIVO_COBRO('30','ENTREGA SGR AVALISTA ','ENTREGA SGR AVALISTA '),
												T_MOTIVO_COBRO('31','ENTREGA POR CUENTA ICO ','ENTREGA POR CUENTA ICO '),
												T_MOTIVO_COBRO('32','ENTREGA POR RETROCESIÓN/ANULACIÓN DE CONVENIO ACREEDORES ','ENTREGA POR RETROCESIÓN/ANULACIÓN DE CONVENIO ACREEDORES '),
												T_MOTIVO_COBRO('33','ENTREGA POR SUBROGACIONES ','ENTREGA POR SUBROGACIONES '),
												T_MOTIVO_COBRO('34','ENTREGA POR RESOLUCION DE LEASING ','ENTREGA POR RESOLUCION DE LEASING '),
												T_MOTIVO_COBRO('35','LIQUIDACIÓN MANUAL ','LIQUIDACIÓN MANUAL '),
												T_MOTIVO_COBRO('36','CANCELACIÓN CUENTA AHORRO VISTA Y CRÉDITOS ','CANCELACIÓN CUENTA AHORRO VISTA Y CRÉDITOS '),
												T_MOTIVO_COBRO('37','DISPOSICIONES SUCESIVAS ','DISPOSICIONES SUCESIVAS '),
												T_MOTIVO_COBRO('38','LIQUIDACION ','LIQUIDACION '),
												T_MOTIVO_COBRO('39','MOTIVO AUTOMÁTICO APLICADORA (VER CÓDIGO TX EN TABLA MOCO) ','MOTIVO AUTOMÁTICO APLICADORA (VER CÓDIGO TX EN TABLA MOCO) '),
												T_MOTIVO_COBRO('40','ALTA GASTO ','ALTA GASTO '),
												T_MOTIVO_COBRO('41','COBRO POR CONFIRMING ','COBRO POR CONFIRMING '),
												T_MOTIVO_COBRO('42','VENTA DE CREDITO ','VENTA DE CREDITO '),
												T_MOTIVO_COBRO('43','QUITA/CONDONACIÓN POR ADJUDICACIÓN O DACIÓN ','QUITA/CONDONACIÓN POR ADJUDICACIÓN O DACIÓN '),
												T_MOTIVO_COBRO('44','MOTIVO AUTOMÁTICO PARA ENTREGAS ','MOTIVO AUTOMÁTICO PARA ENTREGAS '),
												T_MOTIVO_COBRO('45','MOTIVO AUTOMÁTICO PARA CANCELACIÓN DE LEASING Y OTRO TIPO DE CUENTAS ','MOTIVO AUTOMÁTICO PARA CANCELACIÓN DE LEASING Y OTRO TIPO DE CUENTAS ')
                                   );	
  
								   
								   
								   

--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   
   V_MSQL VARCHAR(5000);
   V_EXIST NUMBER(10);

   V_ENTIDAD_ID NUMBER(16);
   V_PEF_ID NUMBER;
  
   V_TMP_TIPO_COBRO T_TIPO_COBRO; 
   
   V_TMP_ORIGEN_COBRO T_ORIGEN_COBRO; 
   
    V_TMP_MOTIVO_COBRO T_MOTIVO_COBRO; 

   
   err_num NUMBER;
   err_msg VARCHAR2(255);
BEGIN





			DBMS_OUTPUT.PUT_LINE('Se borra DD_TCP_TIPO_COBRO_PAGO - TIPO COBRO');
	    execute immediate('DELETE FROM ' || V_ESQUEMA || '.DD_TCP_TIPO_COBRO_PAGO');
		
			DBMS_OUTPUT.PUT_LINE('Se borra DD_OC_ORIGEN_COBRO - ORIGEN COBRO');
	    execute immediate('DELETE FROM ' || V_ESQUEMA || '.DD_OC_ORIGEN_COBRO');
		
	DBMS_OUTPUT.PUT_LINE('Se borra DD_MC_MOTIVO_COBRO - MOTIVO COBRO');
	    execute immediate('DELETE FROM ' || V_ESQUEMA || '.DD_MC_MOTIVO_COBRO');
		
		
	
		
    
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_TCP_TIPO_COBRO_PAGO' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then    
	    EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_TCP_TIPO_COBRO_PAGO');
	end if;
	
	 SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_OC_ORIGEN_COBRO' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then    
	    EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_OC_ORIGEN_COBRO');
	end if;
	
	 SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_MC_MOTIVO_COBRO' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then    
	    EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_MC_MOTIVO_COBRO');
	end if;

	  EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_TCP_TIPO_COBRO_PAGO
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
	  
	    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_OC_ORIGEN_COBRO
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
	  
	   EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_MC_MOTIVO_COBRO
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
	  
	
	 
   DBMS_OUTPUT.PUT_LINE('Creando DD_TCP_TIPO_COBRO_PAGO......');
   FOR I IN V_TIPO_INGRESO.FIRST .. V_TIPO_INGRESO.LAST
   LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TCP_TIPO_COBRO_PAGO.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TIPO_COBRO := V_TIPO_INGRESO(I);
      DBMS_OUTPUT.PUT_LINE('Creando TIPO COBRO: '||V_TMP_TIPO_COBRO(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TCP_TIPO_COBRO_PAGO (DD_TCP_ID, DD_TCP_CODIGO, DD_TCP_DESCRIPCION,' ||
        'DD_TCP_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TIPO_COBRO(1)||''','''||SUBSTR(V_TMP_TIPO_COBRO(2),1,50)||''','''
         ||RTRIM(V_TMP_TIPO_COBRO(3))||''','
         || '0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP;
    COMMIT;
   V_TMP_TIPO_COBRO:= NULL;
   V_TIPO_INGRESO:= NULL;
  
     DBMS_OUTPUT.PUT_LINE('Creando DD_OC_ORIGEN_COBRO......');
   FOR I IN V_ORIGEN_COBRO.FIRST .. V_ORIGEN_COBRO.LAST
   LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_OC_ORIGEN_COBRO.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_ORIGEN_COBRO := V_ORIGEN_COBRO(I);
      DBMS_OUTPUT.PUT_LINE('Creando ORIGEN COBRO: '||V_TMP_ORIGEN_COBRO(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_OC_ORIGEN_COBRO (DD_OC_ID, DD_OC_CODIGO, DD_OC_DESCRIPCION,' ||
        'DD_OC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_ORIGEN_COBRO(1)||''','''||V_TMP_ORIGEN_COBRO(2)||''','''
         ||V_TMP_ORIGEN_COBRO(3)||''','
         || '0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; 
    COMMIT;
   V_TMP_ORIGEN_COBRO:= NULL;
   V_ORIGEN_COBRO:= NULL;
   
   
      DBMS_OUTPUT.PUT_LINE('Creando DD_MC_MOTIVO_COBRO......');
   FOR I IN V_MOTIVO_COBRO.FIRST .. V_MOTIVO_COBRO.LAST
   LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_MC_MOTIVO_COBRO.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_MOTIVO_COBRO := V_MOTIVO_COBRO(I);
      DBMS_OUTPUT.PUT_LINE('Creando MOTIVO COBRO: '||V_TMP_MOTIVO_COBRO(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_MC_MOTIVO_COBRO (DD_MC_ID, DD_MC_CODIGO, DD_MC_DESCRIPCION,' ||
        'DD_MC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_MOTIVO_COBRO(1)||''','''||SUBSTR(V_TMP_MOTIVO_COBRO(2),1,50)||''','''
         ||V_TMP_MOTIVO_COBRO(3)||''','
         || '0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; 
    COMMIT;
   V_TMP_MOTIVO_COBRO:= NULL;
   V_MOTIVO_COBRO:= NULL;
    


   DBMS_OUTPUT.PUT_LINE('Script ejecutado correctamente'); 

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


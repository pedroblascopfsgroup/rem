--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20150728
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-451
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de ALERTAS, esquema CM01.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
  
   TYPE T_GRC IS TABLE OF VARCHAR2(250);
   TYPE T_ARRAY_GRC IS TABLE OF T_GRC;

   TYPE T_TAL IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_TAL IS TABLE OF T_TAL;

   TYPE T_GAL IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_GAL IS TABLE OF T_GAL;
   
   TYPE T_NGR IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_NGR IS TABLE OF T_NGR;
   
      
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
   V_ESQUEMA          VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquema
   V_ESQUEMA_MASTER   VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquema Master
   seq_count          NUMBER(3); -- Vble. para validar la existencia de las Secuencias.
   table_count        NUMBER(3); -- Vble. para validar la existencia de las Tablas.
   v_column_count     NUMBER(3); -- Vble. para validar la existencia de las Columnas.
   v_constraint_count NUMBER(3); -- Vble. para validar la existencia de las Constraints.
   err_num            NUMBER; -- Numero de errores
   err_msg            VARCHAR2(2048); -- Mensaje de error    
   V_MSQL             VARCHAR2(5000);
   V_EXIST            NUMBER(10);
   V_ENTIDAD_ID       NUMBER(16);   

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';

--Código del grupo de carga   
--Configuracion  GRC_GRUPO_CARGA
                                   
   V_GRC T_ARRAY_GRC := T_ARRAY_GRC(
                                    T_GRC('10101','INCREMENTO DEUDA OTRAS ENTIDADES (Incremento del 25% de la deuda en otras entidades)','INCREMENTO DEUDA OTRAS ENTIDADES (Incremento del 25% de la deuda en otras entidades)'),
                                    T_GRC('10102','INCREMENTO DEUDA OTRAS ENTIDADES (Incremento entre el 25% y el 50% de la deuda en otras entidades)','INCREMENTO DEUDA OTRAS ENTIDADES (Incremento entre el 25% y el 50% de la deuda en otras entidades)'),
                                    T_GRC('10103','INCREMENTO DEUDA OTRAS ENTIDADES (Incremento de la deuda en otras entidades superior al 50%)','INCREMENTO DEUDA OTRAS ENTIDADES (Incremento de la deuda en otras entidades superior al 50%)'),
                                    T_GRC('10106','DUDOSIDAD (Dos o mas meses seguidos en situacion de dudoso en otras entidades)','DUDOSIDAD (Dos o mas meses seguidos en situacion de dudoso en otras entidades)'),
                                    T_GRC('10107','DUDOSIDAD (Primera aparicion de la situacion de dudoso en otras entidades)','DUDOSIDAD (Primera aparicion de la situacion de dudoso en otras entidades)'),
                                    T_GRC('10109','REFORZAMIENTO DE GARANTIAS (Primera aparicion de operaciones con garantia real en otras entidades en menos de un 5% del total de riesgo. Incremento del 10% del riesgo en gar. real en otras entidades)','REFORZAMIENTO DE GARANTIAS (Primera aparicion de operaciones con garantia real en otras entidades en menos de un 5% del total de riesgo. Incremento del 10% del riesgo en gar. real en otras entidades)'),
                                    T_GRC('10110','REFORZAMIENTO DE GARANTIAS (Primera aparicion de oper. con gar. real en otras entidades entre 5% y 15% del total de riesgo. Incremento entre el 10% y el 25% del riesgo en gar. real en otras entidades)','REFORZAMIENTO DE GARANTIAS (Primera aparicion de oper. con gar. real en otras entidades entre 5% y 15% del total de riesgo. Incremento entre el 10% y el 25% del riesgo en gar. real en otras entidades)'),
                                    T_GRC('10111','REFORZAMIENTO DE GARANTIAS (Primera aparicion de operaciones con gar. real en otras entidades superior al 15% del total de riesgo. Incremento superior al 25% del riesgo en gar. real en otras entidades)','REFORZAMIENTO DE GARANTIAS (Primera aparicion de operaciones con gar. real en otras entidades superior al 15% del total de riesgo. Incremento superior al 25% del riesgo en gar. real en otras entidades)'),
                                    T_GRC('10112','TECHO RIESGOS (Limite concedido en la entidad inferior al 50% del total riesgo CIRBE)','TECHO RIESGOS (Limite concedido en la entidad inferior al 50% del total riesgo CIRBE)'),
                                    T_GRC('10113','TECHO RIESGOS (Limite concedido en la entidad entre el 50% y el 75% del total riesgo CIRBE)','TECHO RIESGOS (Limite concedido en la entidad entre el 50% y el 75% del total riesgo CIRBE)'),
                                    T_GRC('10114','TECHO RIESGOS (Limite concedido en la entidad superior al 75% del total riesgo CIRBE)','TECHO RIESGOS (Limite concedido en la entidad superior al 75% del total riesgo CIRBE)'),
                                    T_GRC('40101','RAI (Alta del cliente en el RAI)','RAI (Alta del cliente en el RAI)'),
                                    T_GRC('40102','BADESCUG / ASNEF (Alta del cliente en el ASNEF)','BADESCUG / ASNEF (Alta del cliente en el ASNEF)'),
                                    T_GRC('40103','INCIDENCIAS JUDICIALES (Alta del cliente en Incidencias Judiciales)','INCIDENCIAS JUDICIALES (Alta del cliente en Incidencias Judiciales)'),
                                    T_GRC('40104','SITUACIONES CONCURSALES (Alta del cliente en el Situaciones Concursales)','SITUACIONES CONCURSALES (Alta del cliente en el Situaciones Concursales)'),
                                    T_GRC('40105','TRANSFORMACION DE LA SOCIEDAD','TRANSFORMACION DE LA SOCIEDAD'),
                                    T_GRC('40106','CAMBIO RAZON SOCIAL','CAMBIO RAZON SOCIAL'),
                                    T_GRC('40107','CAMBIO OBJETO SOCIAL','CAMBIO OBJETO SOCIAL'),
                                    T_GRC('40108','CAMBIO DOMICILIO SOCIAL','CAMBIO DOMICILIO SOCIAL'),
                                    T_GRC('40109','NOMBRAMIENTOS','NOMBRAMIENTOS'),
                                    T_GRC('40110','REVOCACIONES','REVOCACIONES'),
                                    T_GRC('40111','FUSION POR ABSORCION','FUSION POR ABSORCION'),
                                    T_GRC('40112','FUSION POR UNION','FUSION POR UNION'),
                                    T_GRC('40113','ESCISION PARCIAL','ESCISION PARCIAL'),
                                    T_GRC('40114','ESCISION TOTAL','ESCISION TOTAL'),
                                    T_GRC('40115','REDUCCION CAPITAL','REDUCCION CAPITAL'),
                                    T_GRC('40116','DISOLUCION','DISOLUCION'),
                                    T_GRC('40117','EXTINCION','EXTINCION'),
                                    T_GRC('40118','SOLIC SUSPENSION PAGOS','SOLIC SUSPENSION PAGOS'),
                                    T_GRC('40119','DECLARACION SUSP.PAGOS','DECLARACION SUSP.PAGOS'),
                                    T_GRC('40120','CONVENIO SUSP.PAGOS','CONVENIO SUSP.PAGOS'),
                                    T_GRC('40121','QUIEBRA','QUIEBRA'),
                                    T_GRC('50101','POLITICA DE SEGUIMIENTO PASA DE NEUTRAL A RESTRICTIVA','POLITICA DE SEGUIMIENTO PASA DE NEUTRAL A RESTRICTIVA'),
                                    T_GRC('50102','POLITICA DE SEGUIMIENTO PASA DE FAVORABLE A NEUTRAL','POLITICA DE SEGUIMIENTO PASA DE FAVORABLE A NEUTRAL'),
                                    T_GRC('60101','EXCESOS LIMITE LINEA COMERCIAL (Excedidos en el limite de descuento inferiores al 15%)','EXCESOS LIMITE LINEA COMERCIAL (Excedidos en el limite de descuento inferiores al 15%)'),
                                    T_GRC('60102','EXCESOS LIMITE LINEA COMERCIAL (Excedidos en el limite de descuento superiores al 15% e inferiores al 30%)','EXCESOS LIMITE LINEA COMERCIAL (Excedidos en el limite de descuento superiores al 15% e inferiores al 30%)'),
                                    T_GRC('60103','EXCESOS LIMITE LINEA COMERCIAL (Excedidos superiores al 30% en el limite de descuento)','EXCESOS LIMITE LINEA COMERCIAL (Excedidos superiores al 30% en el limite de descuento)'),
                                    T_GRC('60104','PORCENTAJE IMPAGOS (Impagados hasta 2% sobre el total vencido)','PORCENTAJE IMPAGOS (Impagados hasta 2% sobre el total vencido)'),
                                    T_GRC('60105','PORCENTAJE IMPAGOS (Impagados superiores al 2% e inferiores al 7% sobre el total vencido)','PORCENTAJE IMPAGOS (Impagados superiores al 2% e inferiores al 7% sobre el total vencido)'),
                                    T_GRC('60106','PORCENTAJE IMPAGOS (Impagados superiores al 7% sobre el total vencido)','PORCENTAJE IMPAGOS (Impagados superiores al 7% sobre el total vencido)'),
                                    T_GRC('60113','DEVOLUCION PAPEL COMERCIAL (Indice de devoluciones hasta 5% sobre el total vencido)','DEVOLUCION PAPEL COMERCIAL (Indice de devoluciones hasta 5% sobre el total vencido)'),
                                    T_GRC('60114','DEVOLUCION PAPEL COMERCIAL (Indice de devoluciones superiores al 5% e inferiores al 15% sobre el total vencido)','DEVOLUCION PAPEL COMERCIAL (Indice de devoluciones superiores al 5% e inferiores al 15% sobre el total vencido)'),
                                    T_GRC('60115','DEVOLUCION PAPEL COMERCIAL (Indice de devoluciones superior al 15% sobre el total vencido)','DEVOLUCION PAPEL COMERCIAL (Indice de devoluciones superior al 15% sobre el total vencido)'),
                                    T_GRC('60116','Concentración en un librado hasta 20% sobre el límite total descontado vivo','Concentración en un librado hasta 20% sobre el límite total descontado vivo'),
                                    T_GRC('60117','Concentración en un librado superior al 20% e inferior al 50% sobre límite de total descontado vivo','Concentración en un librado superior al 20% e inferior al 50% sobre límite de total descontado vivo'),
                                    T_GRC('60118','Concentración en un librado superior al 50% sobre límite de total descontado vivo','Concentración en un librado superior al 50% sobre límite de total descontado vivo'),
                                    T_GRC('60119','Plazos de descuento superiores al plazo autorizado e inferiores a 15 días.','Plazos de descuento superiores al plazo autorizado e inferiores a 15 días.'),
                                    T_GRC('60120','Plazos de descuento superiores en 15 días e inferiores a 30 dias al plazo autorizado.','Plazos de descuento superiores en 15 días e inferiores a 30 dias al plazo autorizado.'),
                                    T_GRC('60121','Plazos de descuento superiores en 30 días e inferiores a 90 dias al plazo autorizado.','Plazos de descuento superiores en 30 días e inferiores a 90 dias al plazo autorizado.'),
                                    T_GRC('60122','Importe descontado entre el 50% y el 70% de las ventas del cliente.','Importe descontado entre el 50% y el 70% de las ventas del cliente.'),
                                    T_GRC('60123','Importe descontado entre el 70% y el 90% de las ventas del cliente.','Importe descontado entre el 70% y el 90% de las ventas del cliente.'),
                                    T_GRC('60124','Importe descontado superiores al 90% de las ventas del cliente.','Importe descontado superiores al 90% de las ventas del cliente.'),
                                    T_GRC('60125','PORCENTAJE DE RECLAMACIONES (Reclamacion de efectos inferior al 5% de los efectos vencidos)','PORCENTAJE DE RECLAMACIONES (Reclamacion de efectos inferior al 5% de los efectos vencidos)'),
                                    T_GRC('60126','PORCENTAJE DE RECLAMACIONES (Reclamacion de efectos superior al 5% e inferior al 15% de los efectos vencidos)','PORCENTAJE DE RECLAMACIONES (Reclamacion de efectos superior al 5% e inferior al 15% de los efectos vencidos)'),
                                    T_GRC('60127','PORCENTAJE DE RECLAMACIONES (Reclamacion de efectos superior al 15% de los efectos vencidos)','PORCENTAJE DE RECLAMACIONES (Reclamacion de efectos superior al 15% de los efectos vencidos)'),
                                    T_GRC('60201','DESCUBIERTOS (Descubiertos superiores a 3.000 euros y 30 días contínuos)','DESCUBIERTOS (Descubiertos superiores a 3.000 euros y 30 días contínuos)'),
                                    T_GRC('60202','DESCUBIERTOS (Descubiertos superiores a 6.000 euros y 30 días contínuos)','DESCUBIERTOS (Descubiertos superiores a 6.000 euros y 30 días contínuos)'),
                                    T_GRC('60203','DESCUBIERTOS (Descubiertos superiores a 12.000 euros y 30 días contínuos)','DESCUBIERTOS (Descubiertos superiores a 12.000 euros y 30 días contínuos)'),
                                    T_GRC('60204','SALDO MEDIO DEUDOR (Saldo medio deudor superior a 3.000 euros)','SALDO MEDIO DEUDOR (Saldo medio deudor superior a 3.000 euros)'),
                                    T_GRC('60205','SALDO MEDIO DEUDOR (Saldo medio deudor superior a 6.000 euros)','SALDO MEDIO DEUDOR (Saldo medio deudor superior a 6.000 euros)'),
                                    T_GRC('60206','SALDO MEDIO DEUDOR (Saldo medio deudor superior a 12.000 euros)','SALDO MEDIO DEUDOR (Saldo medio deudor superior a 12.000 euros)'),
                                    T_GRC('60207','COMPENSACION (Número de cheques compensados devueltos superiores a 5 e inferior a 10)','COMPENSACION (Número de cheques compensados devueltos superiores a 5 e inferior a 10)'),
                                    T_GRC('60208','COMPENSACION (Número de cheques compensados devueltos superiores a 10 e inferior a 20)','COMPENSACION (Número de cheques compensados devueltos superiores a 10 e inferior a 20)'),
                                    T_GRC('60209','COMPENSACION (Más de 2 cheques compensados devueltos)','COMPENSACION (Más de 2 cheques compensados devueltos)'),
                                    T_GRC('60210','CHEQUES (Devolución de más de 3 cheques y menos de 5 por incorrientes (sin fondos))','CHEQUES (Devolución de más de 3 cheques y menos de 5 por incorrientes (sin fondos))'),
                                    T_GRC('60211','CHEQUES (Devolución de más de 10 cheques por incorrientes (sin fondos))','CHEQUES (Devolución de más de 10 cheques por incorrientes (sin fondos))'),
                                    T_GRC('60212','CHEQUES (Devolución de más de 5 cheques y menos de 10 por incorrientes (sin fondos))','CHEQUES (Devolución de más de 5 cheques y menos de 10 por incorrientes (sin fondos))'),
                                    T_GRC('60300','EXCESOS SOBRE LIMITE (EXCEDIDO MENOR O IGUAL AL 15% Y DURANTE 15 DIAS CONTINUOS)','EXCESOS SOBRE LIMITE (EXCEDIDO MENOR O IGUAL AL 15% Y DURANTE 15 DIAS CONTINUOS)'),
                                    T_GRC('60301','EXCESOS SOBRE LIMITE (EXCEDIDOS MAYORES DEL 15% Y MENORES DEL 30% DURANTE 15 DIAS CONTINUOS)','EXCESOS SOBRE LIMITE (EXCEDIDOS MAYORES DEL 15% Y MENORES DEL 30% DURANTE 15 DIAS CONTINUOS)'),
                                    T_GRC('60302','EXCESOS SOBRE LIMITE (EXCEDIDOS SUPERIORES AL 30% Y DURANTE 15 DIAS CONTINUOS)','EXCESOS SOBRE LIMITE (EXCEDIDOS SUPERIORES AL 30% Y DURANTE 15 DIAS CONTINUOS)'),
                                    T_GRC('60303','POLIZAS VENCIDAS (VENCIDO INFERIOR A 7 DIAS)','POLIZAS VENCIDAS (VENCIDO INFERIOR A 7 DIAS)'),
                                    T_GRC('60304','POLIZAS VENCIDAS (VENCIDO MAYOR DE 7 DIAS Y MENOR DE 15 DIAS)','POLIZAS VENCIDAS (VENCIDO MAYOR DE 7 DIAS Y MENOR DE 15 DIAS)'),
                                    T_GRC('60305','POLIZAS VENCIDAS (VENCIDO SUPERIOR A 15 DIAS)','POLIZAS VENCIDAS (VENCIDO SUPERIOR A 15 DIAS)'),
                                    T_GRC('60306','ROTACION POLIZA (INGRESOS SUPERIORES A 1,5 VECES EL LIMITE CONCEDIDO E INFERIOR A 2 VECES EL LIMITE CONCEDIDO)','ROTACION POLIZA (INGRESOS SUPERIORES A 1,5 VECES EL LIMITE CONCEDIDO E INFERIOR A 2 VECES EL LIMITE CONCEDIDO)'),
                                    T_GRC('60307','ROTACION POLIZA (INGRESOS SUPERIORES A 1 VECES EL LIMITE CONCEDIDO INFERIOR A 1,5 VECES EL LIMITE CONCEDIDO)','ROTACION POLIZA (INGRESOS SUPERIORES A 1 VECES EL LIMITE CONCEDIDO INFERIOR A 1,5 VECES EL LIMITE CONCEDIDO)'),
                                    T_GRC('60308','ROTACION POLIZA (INGRESOS INFERIORES A LIMITE CONCEDIDO)','ROTACION POLIZA (INGRESOS INFERIORES A LIMITE CONCEDIDO)'),
                                    T_GRC('60309','Saldo medio dispuesto superior al 90% del límite actual e inferior al límite actual','Saldo medio dispuesto superior al 90% del límite actual e inferior al límite actual'),
                                    T_GRC('60310','Saldo medio dispuesto superior al 100% del límite actual e inferior al 110% del límite actual','Saldo medio dispuesto superior al 100% del límite actual e inferior al 110% del límite actual'),
                                    T_GRC('60311','Saldo medio dispuesto superior al 110% del límite actual','Saldo medio dispuesto superior al 110% del límite actual'),
                                    T_GRC('60401','CUOTAS IMPAGADADAS (Cuotas impagadas hasta 1.200 euros y 15 dias)','CUOTAS IMPAGADADAS (Cuotas impagadas hasta 1.200 euros y 15 dias)'),
                                    T_GRC('60402','CUOTAS IMPAGADADAS (Cuotas impagadas de mas de 2.500 euros y 15 dias)','CUOTAS IMPAGADADAS (Cuotas impagadas de mas de 2.500 euros y 15 dias)'),
                                    T_GRC('60403','CUOTAS IMPAGADADAS (Cuotas impagadas hasta 2.500 euros y 15 dias)','CUOTAS IMPAGADADAS (Cuotas impagadas hasta 2.500 euros y 15 dias)'),
                                    T_GRC('70101','Cambios en: Forma Juridica, actividad, domicilio social, apoderados y administradores','Cambios en: Forma Juridica, actividad, domicilio social, apoderados y administradores'),
                                    T_GRC('70102','Fusiones y absorciones; cambios de accionistas','Fusiones y absorciones; cambios de accionistas'),
                                    T_GRC('70103','Reducciones de capital','Reducciones de capital'),
                                    T_GRC('80101','OPERACION PASA DE RIESGO BAJO A RIESGO MEDIO','OPERACION PASA DE RIESGO BAJO A RIESGO MEDIO'),
                                    T_GRC('80102','OPERACION PASA DE RIESGO MEDIO A RIESGO ALTO','OPERACION PASA DE RIESGO MEDIO A RIESGO ALTO'),
                                    T_GRC('80103','OPERACION PASA DE RIESGO ALTO A RIESGO MUY ALTO','OPERACION PASA DE RIESGO ALTO A RIESGO MUY ALTO'),
                                    T_GRC('90101','Disminución Beneficio entre el 10% y el 25% respecto al año anterior','Disminución Beneficio entre el 10% y el 25% respecto al año anterior'),
                                    T_GRC('90102','Disminución Beneficio igual o superior 25% respecto al año anterior','Disminución Beneficio igual o superior 25% respecto al año anterior'),
                                    T_GRC('90103','Beneficio menor que 0 (Perdidas)','Beneficio menor que 0 (Perdidas)'),
                                    T_GRC('90104','Disminución Margen Neto en 10% respecto al año anterior','Disminución Margen Neto en 10% respecto al año anterior'),
                                    T_GRC('90105','Disminución Margen Neto en 50% respecto al año anterior','Disminución Margen Neto en 50% respecto al año anterior'),
                                    T_GRC('90106','Disminución Margen Neto en 25% respecto al año anterior','Disminución Margen Neto en 25% respecto al año anterior'),
                                    T_GRC('90107','Disminución Margen Bruto en 10% respecto al año anterior','Disminución Margen Bruto en 10% respecto al año anterior'),
                                    T_GRC('90108','Disminución Margen Bruto en 50% respecto al año anterior','Disminución Margen Bruto en 50% respecto al año anterior'),
                                    T_GRC('90109','Disminución Margen Bruto en 25% respecto al año anterior','Disminución Margen Bruto en 25% respecto al año anterior'),
                                    T_GRC('90110','La deuda a Largo Plazo es entre 5 y 7 veces mayor que el Cash Flow. ','La deuda a Largo Plazo es entre 5 y 7 veces mayor que el Cash Flow. '),
                                    T_GRC('90111','La deuda a Largo Plazo es entre 7 y 10 veces mayor que el Cash Flow. ','La deuda a Largo Plazo es entre 7 y 10 veces mayor que el Cash Flow. '),
                                    T_GRC('90112','La deuda a Largo Plazo es mas de 10 veces mayor que el Cash Flow. ','La deuda a Largo Plazo es mas de 10 veces mayor que el Cash Flow. '),
                                    T_GRC('90113','Ratio Margen Explotación Cuenta Resultados < 10%','Ratio Margen Explotación Cuenta Resultados < 10%'),
                                    T_GRC('90114','Ratio Margen Explotación Cuenta Resultados >= 10% y < 25%','Ratio Margen Explotación Cuenta Resultados >= 10% y < 25%'),
                                    T_GRC('90115','Ratio Margen Explotación Cuenta Resultados >= 25% y <= 50%','Ratio Margen Explotación Cuenta Resultados >= 25% y <= 50%'),
                                    T_GRC('90116','Caida de Beneficios.Dism Rdtos antes de impuestos 3 ult ejercicios','Caida de Beneficios.Dism Rdtos antes de impuestos 3 ult ejercicios'),
                                    T_GRC('90117','Perdidas Continuadas.Rtdos antes de imp negat ejerc actual y dos ant','Perdidas Continuadas.Rtdos antes de imp negat ejerc actual y dos ant'),
                                    T_GRC('90118','Ratio PM Cobro > 120 días','Ratio PM Cobro > 120 días'),
                                    T_GRC('90119','Ratio PM Pago < 30 días','Ratio PM Pago < 30 días'),
                                    T_GRC('90201','Disminución del Ratio de Solvencia en un 10% respecto año anterior','Disminución del Ratio de Solvencia en un 10% respecto año anterior'),
                                    T_GRC('90202','Disminución del Ratio de Solvencia en un 30% respecto año anterior','Disminución del Ratio de Solvencia en un 30% respecto año anterior'),
                                    T_GRC('90203','Disminución del Ratio de Solvencia en un 50% respecto año anterior','Disminución del Ratio de Solvencia en un 50% respecto año anterior'),
                                    T_GRC('90204','Valor del Ratio de Solvencia entre 1,75 y 1,4','Valor del Ratio de Solvencia entre 1,75 y 1,4'),
                                    T_GRC('90205','Valor del Ratio de Solvencia entre 1,4 y 1','Valor del Ratio de Solvencia entre 1,4 y 1'),
                                    T_GRC('90206','Valor del Ratio de Solvencia menor o igual a 1','Valor del Ratio de Solvencia menor o igual a 1'),
                                    T_GRC('90207','Disminución del Ratio de Liquidez en un 10% respecto año anterior','Disminución del Ratio de Liquidez en un 10% respecto año anterior'),
                                    T_GRC('90208','Disminución del Ratio de Liquidez en un 30% respecto año anterior','Disminución del Ratio de Liquidez en un 30% respecto año anterior'),
                                    T_GRC('90209','Disminución del Ratio de Liquidez en un 50% respecto año anterior','Disminución del Ratio de Liquidez en un 50% respecto año anterior'),
                                    T_GRC('90210','Valor del Ratio de Liquidez entre 1 y 1,5','Valor del Ratio de Liquidez entre 1 y 1,5'),
                                    T_GRC('90211','Valor del Ratio de Liquidez entre 1,25 y 1','Valor del Ratio de Liquidez entre 1,25 y 1'),
                                    T_GRC('90212','Valor del Ratio de Liquidez menor o igual a 1','Valor del Ratio de Liquidez menor o igual a 1'),
                                    T_GRC('90213','Incremento del Ratio de Endeudamiento en un 10% respecto año anterior','Incremento del Ratio de Endeudamiento en un 10% respecto año anterior'),
                                    T_GRC('90214','Incremento del Ratio de Endeudamiento en un 30% respecto año anterior','Incremento del Ratio de Endeudamiento en un 30% respecto año anterior'),
                                    T_GRC('90215','Incremento del Ratio de Endeudamiento en un 50% respecto año anterior','Incremento del Ratio de Endeudamiento en un 50% respecto año anterior'),
                                    T_GRC('90216','Valor del Ratio de Endeudamiento entre 1,25 y 1,75','Valor del Ratio de Endeudamiento entre 1,25 y 1,75'),
                                    T_GRC('90217','Valor del Ratio de Endeudamiento entre 1,75 y 2,25','Valor del Ratio de Endeudamiento entre 1,75 y 2,25'),
                                    T_GRC('90218','Valor del Ratio de Endeudamiento mayor o igual a 2,25 o es negativo','Valor del Ratio de Endeudamiento mayor o igual a 2,25 o es negativo'),
                                    T_GRC('90219','Incremento del Periodo Medio de Cobro en un 10% respecto año anterior','Incremento del Periodo Medio de Cobro en un 10% respecto año anterior'),
                                    T_GRC('90220','Incremento del Periodo Medio de Cobro en un 30% respecto año anterior','Incremento del Periodo Medio de Cobro en un 30% respecto año anterior'),
                                    T_GRC('90221','Incremento del Periodo Medio de Cobro en un 50% respecto año anterior','Incremento del Periodo Medio de Cobro en un 50% respecto año anterior'),
                                    T_GRC('90301','Ratio Endeudamiento >= 1´25% y <= 1´75%','Ratio Endeudamiento >= 1´25% y <= 1´75%'),
                                    T_GRC('90302','Ratio Endeudamiento > 1´75% y <= 2´25%','Ratio Endeudamiento > 1´75% y <= 2´25%'),
                                    T_GRC('90303','Ratio Endeudamiento > 2´25%','Ratio Endeudamiento > 2´25%'),
                                    T_GRC('90304','Ratio Endeudamiento < 0','Ratio Endeudamiento < 0'),
                                    T_GRC('90305','Ratio de solvencia >= 1,25% y < 1,50%','Ratio de solvencia >= 1,25% y < 1,50%'),
                                    T_GRC('90306','Ratio de solvencia >1% y < 1´25%','Ratio de solvencia >1% y < 1´25%'),
                                    T_GRC('90307','Ratio de solvencia <= 1%','Ratio de solvencia <= 1%'),
                                    T_GRC('90308','Fondos Propios Negativos','Fondos Propios Negativos')
                                    );


--Grupo de Alertas 
--Configuracion  GAL_GRUPO_ALERTA
                                   
   V_GAL T_ARRAY_GAL := T_ARRAY_GAL(
                                    T_GAL('01','CIRBE','CIRBE'),
                                    T_GAL('02','EVOLUCION DE PROMOCIONES','EVOLUCION DE PROMOCIONES'),
                                    T_GAL('03','HIPOTECAS SIN INSCRIBIR','HIPOTECAS SIN INSCRIBIR'),
                                    T_GAL('04','INFORMACION PUBLICA','INFORMACION PUBLICA'),
                                    T_GAL('05','POLITICA DE SEGUIMIENTO','POLITICA DE SEGUIMIENTO'),
                                    T_GAL('06','PRODUCTOS','PRODUCTOS'),
                                    T_GAL('07','REGISTRO MERCANTIL','REGISTRO MERCANTIL'),
                                    T_GAL('08','SCORING','SCORING'),
                                    T_GAL('09','SITUACION ECONOMICO FINANCIERA','SITUACION ECONOMICO FINANCIERA')
                                   );  
                                              

--Tipo de Alerta  
--Configuracion  TAL_TIPO_ALERTA
                                   
   V_TAL T_ARRAY_TAL := T_ARRAY_TAL(
                                    T_TAL('0101','CIRBE','CIRBE'),
                                    T_TAL('0201','EVOLUCION DE OBRA','EVOLUCION DE OBRA'),
                                    T_TAL('0202','EVOLUCION DE VENTAS','EVOLUCION DE VENTAS'),
                                    T_TAL('0203','RIESGO INSTRUM. Y OPER. POST FORMALIZ.','RIESGO INSTRUM. Y OPER. POST FORMALIZ.'),
                                    T_TAL('0301','HIPOTECA SIN INSCRIBIR','HIPOTECA SIN INSCRIBIR'),
                                    T_TAL('0401','INFORMACION PUBLICA','INFORMACION PUBLICA'),
                                    T_TAL('0501','POLITICA DE SEGUIMIENTO','POLITICA DE SEGUIMIENTO'),
                                    T_TAL('0601','CARTERA COMERCIAL','CARTERA COMERCIAL'),
                                    T_TAL('0602','CUENTAS A LA VISTA','CUENTAS A LA VISTA'),
                                    T_TAL('0603','POLIZAS DE CREDITO','POLIZAS DE CREDITO'),
                                    T_TAL('0604','PRESTAMOS/LEASING','PRESTAMOS/LEASING'),
                                    T_TAL('0701','REGISTRO MERCANTIL','REGISTRO MERCANTIL'),
                                    T_TAL('0801','SCORING','SCORING'),
                                    T_TAL('0901','RENTABILIDAD','RENTABILIDAD'),
                                    T_TAL('0902','SITUACION PATRIMONIAL','SITUACION PATRIMONIAL'),
                                    T_TAL('0903','SITUACION PATRIMONIAL-FINANCIERA','SITUACION PATRIMONIAL-FINANCIERA'),
                                    T_TAL('0904','SITUACIÓN PATRIMONIAL-FINANCIERA','SITUACIÓN PATRIMONIAL-FINANCIERA')
                                   );
                                                         
                                   
--Gravedad 
--Configuracion NGR_NIVEL_GRAVEDAD
                                   
   V_NGR T_ARRAY_NGR := T_ARRAY_NGR(
                                    T_NGR('L','LEVE','LEVE'),
                                    T_NGR('G','GRAVE','GRAVE'),
                                    T_NGR('MG','MUY GRAVE','MUY GRAVE')
                                   );                                              
                                   
                                   
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   
   V_TMP_GRC T_GRC;
   V_TMP_TAL T_TAL;
   V_TMP_GAL T_GAL;
   V_TMP_NGR T_NGR;

   
BEGIN

    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de TAL_TIPO_ALERTA.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.TAL_TIPO_ALERTA');
    
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de GRC_GRUPO_CARGA.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.GRC_GRUPO_CARGA');

    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de GAL_GRUPO_ALERTA.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.GAL_GRUPO_ALERTA');
        
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de NGR_NIVEL_GRAVEDAD.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.NGR_NIVEL_GRAVEDAD');
          
    
     
 
    DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
    
    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_GRC_GRUPO_CARGA' and sequence_owner=V_ESQUEMA;
   
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 1');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_GRC_GRUPO_CARGA');
    end if;
   
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_GRC_GRUPO_CARGA
                       START WITH 1
                       MAXVALUE 999999999999999999999999999
                       MINVALUE 1
                       NOCYCLE
                       CACHE 20
                       NOORDER'
                      );    


    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_GAL_GRUPO_ALERTA' and sequence_owner=V_ESQUEMA;
    
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 3');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_GAL_GRUPO_ALERTA');
    end if;
    
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_GAL_GRUPO_ALERTA
                      START WITH 1
                      MAXVALUE 999999999999999999999999999
                      MINVALUE 1
                      NOCYCLE
                      CACHE 20
                      NOORDER'
                     );          
    
    

    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_TAL_TIPO_ALERTA' and sequence_owner=V_ESQUEMA;
    
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 2');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_TAL_TIPO_ALERTA');
    end if;
    
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_TAL_TIPO_ALERTA
                      START WITH 1
                      MAXVALUE 999999999999999999999999999
                      MINVALUE 1
                      NOCYCLE
                      CACHE 20
                      NOORDER'
                     );    


    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_NGR_NIVEL_GRAVEDAD' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 4');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_NGR_NIVEL_GRAVEDAD');
    end if;
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_NGR_NIVEL_GRAVEDAD
                       START WITH 1
                       MAXVALUE 999999999999999999999999999
                       MINVALUE 1
                       NOCYCLE
                       CACHE 20
                       NOORDER'
                      );         


   DBMS_OUTPUT.PUT_LINE('Creando GRC_GRUPO_CARGA......');
   FOR I IN V_GRC.FIRST .. V_GRC.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_GRC_GRUPO_CARGA.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_GRC := V_GRC(I);
      DBMS_OUTPUT.PUT_LINE('Creando GRC: '||V_TMP_GRC(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GRC_GRUPO_CARGA (GRC_ID, GRC_CODIGO, GRC_DESCRIPCION,' ||
        'GRC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_GRC(1)||''','''||SUBSTR(V_TMP_GRC(2),1, 50)||''','''
         ||V_TMP_GRC(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_GRUPO_CLIENTE
   V_TMP_GRC := NULL;


  DBMS_OUTPUT.PUT_LINE('Creando GAL_GRUPO_ALERTA......');
   FOR I IN V_GAL.FIRST .. V_GAL.LAST
   LOOP
   	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_GAL_GRUPO_ALERTA.NEXTVAL FROM DUAL';
   	EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_GAL := V_GAL(I);
      DBMS_OUTPUT.PUT_LINE('Creando GAL: '||V_TMP_GAL(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GAL_GRUPO_ALERTA (GAL_ID, GAL_CODIGO, GAL_DESCRIPCION,' ||
		'GAL_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_GAL(1)||''','''||V_TMP_GAL(2)||''','''
		 ||V_TMP_GAL(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_RELACION_GRUPO
   V_TMP_GAL := NULL;   
   

   /*****************************************************/
   /*** PENDIENTE CORRESPONDENCIA GAL_ID y GRC_ID  ******/
   /*****************************************************/   
   
   DBMS_OUTPUT.PUT_LINE('Creando TAL_TIPO_ALERTA......');
   FOR I IN V_TAL.FIRST .. V_TAL.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TAL_TIPO_ALERTA.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TAL := V_TAL(I);
      DBMS_OUTPUT.PUT_LINE('Creando TAL: '||V_TMP_TAL(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TAL_TIPO_ALERTA (TAL_ID, TAL_CODIGO, GAL_ID, GRC_ID, TAL_DESCRIPCION,' ||
        'TAL_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TAL(1)||''',1,
                 1,'''||V_TMP_TAL(2)||''','''||V_TMP_TAL(3)||''',
                 0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_RELACION_GRUPO
   V_TMP_TAL := NULL;
   
   
  DBMS_OUTPUT.PUT_LINE('Creando NGR_NIVEL_GRAVEDAD......');
  FOR I IN V_NGR.FIRST .. V_NGR.LAST
  LOOP
  	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_NGR_NIVEL_GRAVEDAD.NEXTVAL FROM DUAL';
  	EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
     V_TMP_NGR := V_NGR(I);
     DBMS_OUTPUT.PUT_LINE('Creando NGR: '||V_TMP_NGR(1));   

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.NGR_NIVEL_GRAVEDAD (NGR_ID, NGR_ORDEN, NGR_CODIGO, NGR_DESCRIPCION,' ||
	'NGR_DESCRIPCION_LARGA, NGR_PESO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                ' VALUES ('||  V_ENTIDAD_ID || ','||  V_ENTIDAD_ID || ','''||V_TMP_NGR(1)||''','''||V_TMP_NGR(2)||''','''
	 ||V_TMP_NGR(3)||''','||  V_ENTIDAD_ID || ',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
     EXECUTE IMMEDIATE V_MSQL;
  END LOOP; --LOOP TIPO_RELACION_GRUPO
  V_TMP_NGR := NULL;   
  

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


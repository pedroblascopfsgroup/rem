--/*
--#########################################
--## AUTOR=VICTOR OLIVARES
--## FECHA_CREACION=20190329
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3762
--## PRODUCTO=NO
--## 
--## Finalidad: Insertar la configuración de gastos partidas presupuestarias Cerberus-Apple 2019
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3762';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

	V_TABLA VARCHAR2(30 CHAR) := 'CPP_CONFIG_PTDAS_PREP'; -- Variable para tabla.
    V_DD_CRA_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la cartera.
    V_DD_SCR_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la subcartera.
	V_EJE_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del año.
	
	V_EXISTE_PARTIDA NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.

 	TYPE T_CUENTA IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_CUENTAS IS TABLE OF T_CUENTA;
    V_CUENTAS T_ARRAY_CUENTAS := T_ARRAY_CUENTAS(


        
             --SUPTIPO GASTO												  		--DD_STG_CODIGO  --CARTERA	    --SUBCARTERA		    --PARTIDAPRESUPUESTARIA	  --AÑO --ARRENDAMIENTO --TIPO GASTO  

		-- IMPUESTOS
        T_CUENTA(/*'IBI urbana',*/                                                  	'01',			'07',           '138',    				'G011311',     		2019,      0,			'01'),
		T_CUENTA(/*'IBI rústica',*/                                                 	'02',			'07',           '138',     				'G011311',     		2019,      0,			'01'),
		--PENDIENTE T_CUENTA(/*'Recargos e intereses',*/                                            '92',			'07',           '138',     				'G011379',     		2019,      0,			'01'),
		--NOEXISTE T_CUENTA(/*'Recargo IBI',*/                                            '',			'07',           '138',    				'G011379',     		2019,      0,			'01'),
		T_CUENTA(/*'Plusvalía (IIVTNU) compra',*/                                   	'03',			'07',           '138',    				'G011367',     		2019,      0,			'01'),
		--NOEXISTE T_CUENTA(/*'Recargo plusvalía compra',*/                               '',			'07',           '138',    				'G011379',     		2019,      0,			'01'),
		T_CUENTA(/*'Plusvalía (IIVTNU) venta',*/                                    	'04',			'07',           '138',    				'G011324',     		2019,      0,			'01'),
		--NOEXISTE T_CUENTA(/*'Recargo plusvalía venta',*/                                '',			'07',           '138',    				'G011379',     		2019,      0,			'01'),
		T_CUENTA(/*'IAAEE',*/                                                 			'05',			'07',           '138',    				'G011367',     		2019,      0,			'01'),
		--NOEXISTE T_CUENTA(/*'Recargo IAE',*/                                            '',			'07',           '138',    				'G011379',     		2019,      0,			'01'),
		T_CUENTA(/*'ICIO',*/                                                 			'06',			'07',           '138',    				'G011383',     		2019,      0,			'01'),
		--NOEXISTE T_CUENTA(/*'Recargo ICIO',*/                                           '',			'07',           '138',    				'G011379',     		2019,      0,			'01'),
		T_CUENTA(/*'ITPAJD',*/                                                 			'07',			'07',           '138',    				'G011367',     		2019,      0,			'01'),
		--NOEXISTE T_CUENTA(/*'Recargo ITPAJD',*/                                         '',			'07',           '138',    				'G011379',     		2019,      0,			'01'),
				
		T_CUENTA(/*'IBI urbana',*/                                                  	'01',			'07',           '138',    				'G011311',     		2019,      1,			'01'),
		T_CUENTA(/*'IBI rústica',*/                                                 	'02',			'07',           '138',     				'G011311',     		2019,      1,			'01'),
		--PENDIENTE T_CUENTA(/*'Recargos e intereses',*/                                            '92',			'07',           '138',     				'G011379',     		2019,      1,			'01'),
		--NOEXISTE T_CUENTA(/*'Recargo IBI',*/                                            '',			'07',           '138',    				'G011379',     		2019,      1,			'01'),
		T_CUENTA(/*'Plusvalía (IIVTNU) compra',*/                                   	'03',			'07',           '138',    				'G011367',     		2019,      1,			'01'),
		--NOEXISTE T_CUENTA(/*'Recargo plusvalía compra',*/                               '',			'07',           '138',    				'G011379',     		2019,      1,			'01'),
		T_CUENTA(/*'Plusvalía (IIVTNU) venta',*/                                    	'04',			'07',           '138',    				'G011324',     		2019,      1,			'01'),
		--NOEXISTE T_CUENTA(/*'Recargo plusvalía venta',*/                                '',			'07',           '138',    				'G011379',     		2019,      1,			'01'),
		T_CUENTA(/*'IAAEE',*/                                                 			'05',			'07',           '138',    				'G011367',     		2019,      1,			'01'),
		--NOEXISTE T_CUENTA(/*'Recargo IAE',*/                                            '',			'07',           '138',    				'G011379',     		2019,      1,			'01'),
		T_CUENTA(/*'ICIO',*/                                                 			'06',			'07',           '138',    				'G011383',     		2019,      1,			'01'),
		--NOEXISTE T_CUENTA(/*'Recargo ICIO',*/                                           '',			'07',           '138',    				'G011379',     		2019,      1,			'01'),
		T_CUENTA(/*'ITPAJD',*/                                                 			'07',			'07',           '138',    				'G011367',     		2019,      1,			'01'),
		--NOEXISTE T_CUENTA(/*'Recargo ITPAJD',*/                                         '',			'07',           '138',    				'G011379',     		2019,      1,			'01'),

		-- TASA			
		T_CUENTA(/*'Basura',*/                                                      	'08',			'07',           '138',    				'G011323',     		2019,      0,			'02'),
		T_CUENTA(/*'Alcantarillado',*/                                              	'09',			'07',           '138',    				'G011323',     		2019,      0,			'02'),
		T_CUENTA(/*'Agua',          */                                       			'10',			'07',           '138',    				'G011323',     		2019,      0,			'02'),
		T_CUENTA(/*'Vado',          */                                              	'11',			'07',           '138',    				'G011323',     		2019,      0,			'02'),
		T_CUENTA(/*'Ecotasa',         */                                            	'12',			'07',           '138',    				'G011323',     		2019,      0,			'02'),
		T_CUENTA(/*'Regularización catastral',*/                                    	'13',			'07',           '138',    				'G011383',     		2019,      0,			'02'),
		T_CUENTA(/*'Expedición documentos',  */                                     	'14',			'07',           '138',    				'G011383',     		2019,      0,			'02'),
		T_CUENTA(/*'Obras / Rehabilitación / Mantenimiento',*/                      	'15',			'07',           '138',    				'G011383',     		2019,      0,			'02'),
		T_CUENTA(/*'Judicial',                              */                      	'16',			'07',           '138',    				'G011383',     		2019,      0,			'02'),
		T_CUENTA(/*'Otras tasas ayuntamiento',              */                      	'17',			'07',           '138',    				'G011383',     		2019,      0,			'02'),
		T_CUENTA(/*'Otras tasas',                           */                      	'18',			'07',           '138',    				'G011383',     		2019,      0,			'02'),

		T_CUENTA(/*'Basura',                                 */                     	'08',			'07',           '138',    				'G011323',     		2019,      1,			'02'),
		T_CUENTA(/*'Alcantarillado',                         */                     	'09',			'07',           '138',    				'G011323',     		2019,      1,			'02'),
		T_CUENTA(/*'Agua',                                   */                			'10',			'07',           '138',    				'G011323',     		2019,      1,			'02'),
		T_CUENTA(/*'Vado',                                   */                     	'11',			'07',           '138',    				'G011323',     		2019,      1,			'02'),
		T_CUENTA(/*'Ecotasa',                                */                     	'12',			'07',           '138',    				'G011323',     		2019,      1,			'02'),
		T_CUENTA(/*'Regularización catastral',               */                     	'13',			'07',           '138',    				'G011383',     		2019,      1,			'02'),
		T_CUENTA(/*'Expedición documentos',                  */                     	'14',			'07',           '138',    				'G011383',     		2019,      1,			'02'),
		T_CUENTA(/*'Obras / Rehabilitación / Mantenimiento', */                     	'15',			'07',           '138',    				'G011383',     		2019,      1,			'02'),
		T_CUENTA(/*'Judicial',                               */                     	'16',			'07',           '138',    				'G011383',     		2019,      1,			'02'),
		T_CUENTA(/*'Otras tasas ayuntamiento',               */                     	'17',			'07',           '138',    				'G011383',     		2019,      1,			'02'),
		T_CUENTA(/*'Otras tasas',                            */                     	'18',			'07',           '138',    				'G011383',     		2019,      1,			'02'),

		-- OTROS TRIBUTOS			
		T_CUENTA(/*'Contribución especial',                  */                   		'19',			'07',           '138',    				'G011383',     		2019,      0,			'03'),
		T_CUENTA(/*'Otros',                                  */   						'20',			'07',           '138',    				'G011383',     		2019,      0,			'03'),

		T_CUENTA(/*'Contribución especial',                  */                     	'19',			'07',           '138',    				'G011383',     		2019,      1,			'03'),
		T_CUENTA(/*'Otros',                                  */     					'20',			'07',           '138',    				'G011383',     		2019,      1,			'03'),

		-- SANCION			
		T_CUENTA(/*'Urbanística',                           */                      	'21',			'07',           '138',    				'G011325',     		2019,      0,			'04'),
		T_CUENTA(/*'Tributaria',                            */                      	'22',			'07',           '138',    				'G011325',     		2019,      0,			'04'),
		T_CUENTA(/*'Ruina',                                 */                      	'23',			'07',           '138',    				'G011325',     		2019,      0,			'04'),
		T_CUENTA(/*'Multa coercitiva',                      */                     		'24',		 	'07',           '138',    				'G011325',     		2019,      0,			'04'),
		T_CUENTA(/*'Otros',                                 */              			'25',			'07',           '138',    				'G011325',     		2019,      0,			'04'),

		T_CUENTA(/*'Urbanística',                           */                      	'21',			'07',           '138',    				'G011325',     		2019,      1,			'04'),
		T_CUENTA(/*'Tributaria',                            */                      	'22',			'07',           '138',    				'G011325',     		2019,      1,			'04'),
		T_CUENTA(/*'Ruina',                                 */                      	'23',			'07',           '138',    				'G011325',     		2019,      1,			'04'),
		T_CUENTA(/*'Multa coercitiva',                      */                      	'24',			'07',           '138',    				'G011325',     		2019,      1,			'04'),
		T_CUENTA(/*'Otros',                                 */              			'25',			'07',           '138',    				'G011325',     		2019,      1,			'04'),

		-- COMUNIDAD DE PROPIETARIOS			
		T_CUENTA(/*'Cuota ordinaria',               */                              	'26',			'07',           '138',    				'G011309',     		2019,      0,			'05'),
		T_CUENTA(/*'Cuota extraordinaria (derrama)',*/                              	'27',			'07',           '138',    				'G011309',     		2019,      0,			'05'),
		T_CUENTA(/*'Certificado deuda comunidad',   */                          		'93',			'07',           '138',    				'G011378',     		2019,      0,			'05'),

		T_CUENTA(/*'Cuota ordinaria',               */                              	'26',			'07',           '138',    				'G011309',     		2019,      1,			'05'),
		T_CUENTA(/*'Cuota extraordinaria (derrama)',*/                              	'27',			'07',           '138',    				'G011309',     		2019,      1,			'05'),
		T_CUENTA(/*'Certificado deuda comunidad',   */                          		'93',			'07',           '138',    				'G011378',     		2019,      1,			'05'),

		-- COMPLEJO INMOBILIARIO
		T_CUENTA(/*'Cuota ordinaria',               */                             		'28',		 	'07',           '138',    				'G011309',     		2019,      0,			'06'),
		T_CUENTA(/*'Cuota extraordinaria (derrama)',*/                             		'29',		 	'07',           '138',    				'G011309',     		2019,      0,			'06'),

		T_CUENTA(/*'Cuota ordinaria',               */                              	'28',			'07',           '138',    				'G011309',     		2019,      1,			'06'),
		T_CUENTA(/*'Cuota extraordinaria (derrama)',*/                              	'29',			'07',           '138',    				'G011309',     		2019,      1,			'06'),

		-- JUNTA DE COMPENSACIÓN / EUC			
		T_CUENTA(/*'Gastos generales', */                                           	'30',			'07',           '138',    				'G011313',     		2019,      0,			'07'),
		T_CUENTA(/*'Cuotas y derramas',*/                                          		'31',		 	'07',           '138',    				'G011357',     		2019,      0,			'07'),

		T_CUENTA(/*'Gastos generales', */                                           	'30',			'07',           '138',    				'G011313',     		2019,      1,			'07'),
		T_CUENTA(/*'Cuotas y derramas',*/                                           	'31',			'07',           '138',    				'G011357',     		2019,      1,			'07')

		--OTRAS ENTIDADES
		--VACIOEXCEL T_CUENTA('Gastos generales',                                       '32', 			'07',        	'138',       			0,     		2019,      0,			'08'),
		--VACIOEXCEL T_CUENTA('Cuotas y derramas',                                      '33',    		'07',        	'138',       			0,     		2019,      0,			'08'),
		--VACIOEXCEL T_CUENTA('Otros',                                           		'34',   		'07',        	'138',       			0,     		2019,      0,			'08'),

		--VACIOEXCEL T_CUENTA('Gastos generales',                                       '32',   		'07',        	'138',       			0,     		2019,      1,			'08'),
		--VACIOEXCEL T_CUENTA('Cuotas y derramas',                                      '33',   		'07',        	'138',       			0,     		2019,      1,			'08'),
		--VACIOEXCEL T_CUENTA('Otros',                                           		'34',   		'07',        	'138',       			0,     		2019,      1,			'08'),

		-- SUMINISTRO			
		--DESCARTADO T_CUENTA(/*'Electricidad',*/                                                	'35',			'07',           '138',    				'G011335',     		2019,      0,			'09'),
		--DESCARTADO T_CUENTA(/*'Agua',        */                                                	'36',			'07',           '138',    				'G011336',     		2019,      0,			'09'),
		--DESCARTADO T_CUENTA(/*'Gas',         */                                                	'37',			'07',           '138',    				'G011337',     		2019,      0,			'09'),
		--DESCARTADO T_CUENTA(/*'Otros',       */                                                	'38',			'07',           '138',    				'G011336',     		2019,      0,			'09'),
				
		--DESCARTADO T_CUENTA(/*'Electricidad',*/                                                	'35',			'07',           '138',    				'G011335',     		2019,      1,			'09'),
		--DESCARTADO T_CUENTA(/*'Agua',        */                                                	'36',			'07',           '138',    				'G011336',     		2019,      1,			'09'),
		--DESCARTADO T_CUENTA(/*'Gas',         */                                                	'37',			'07',           '138',    				'G011337',     		2019,      1,			'09'),
		--DESCARTADO T_CUENTA(/*'Otros',       */                                                	'38',			'07',           '138',    				'G011336',     		2019,      1,			'09'),

		-- SEGUROS			
		--DESCARTADO T_CUENTA(/*'Prima TRDM (todo riesgo daño material)',  */                    	'39',			'07',           '138',    				'G011321',     		2019,      0,			'10'),
		--DESCARTADO T_CUENTA(/*'Prima RC (responsabilidad civil)',        */                    	'40',			'07',           '138',    				'G011321',     		2019,      0,			'10'),
		--DESCARTADO T_CUENTA(/*'Parte daños propios',                     */                    	'41',			'07',           '138',    				'G011321',     		2019,      0,			'10'),
		--DESCARTADO T_CUENTA(/*'Parte daños a terceros',                  */                    	'42',			'07',           '138',    				'G011321',     		2019,      0,			'10'),
		--NOEXISTE T_CUENTA(/*'Seguros de rentas',                       */             '',				'07',           '138',    				'G011321',     		2019,      0,			'10'),

		--DESCARTADO T_CUENTA(/*'Prima TRDM (todo riesgo daño material)',*/                      	'39',			'07',           '138',    				'G011321',     		2019,      1,			'10'),
		--DESCARTADO T_CUENTA(/*'Prima RC (responsabilidad civil)',      */                      	'40',			'07',           '138',    				'G011321',     		2019,      1,			'10'),
		--DESCARTADO T_CUENTA(/*'Parte daños propios',                   */                      	'41',			'07',           '138',    				'G011321',     		2019,      1,			'10'),
		--DESCARTADO T_CUENTA(/*'Parte daños a terceros',                */                      	'42',			'07',           '138',    				'G011321',     		2019,      1,			'10'),
		--NOEXISTE T_CUENTA(/*'Seguros de rentas',                     */               '',				'07',           '138',    				'G011321',     		2019,      1,			'10'),

		-- SERVICIOS PROFESIONALES INDEPENDIENTES			
		--DESCARTADO T_CUENTA(/*'Registro',                            */                        	'43',			'07',           '138',    				'G011360',     		2019,      0,			'11'),
		--DESCARTADO T_CUENTA(/*'Notaría',                             */                        	'44',			'07',           '138',    				'G011301',     		2019,      0,			'11'),
		--DESCARTADO T_CUENTA(/*'Abogado (Ocupacional)',               */                			'95',			'07',           '138',    				'G011358',     		2019,      0,			'11'),
		--DESCARTADO T_CUENTA(/*'Abogado (Asuntos generales)',         */                			'96',			'07',           '138',    				'G011358',     		2019,      0,			'11'),
		--DESCARTADO T_CUENTA(/*'Abogado (Asistencia jurídica)',       */                       		'97',			'07',           '138',    				'G011358',     		2019,      0,			'11'),
		--DESCARTADO T_CUENTA(/*'Procurador',                          */                        	'46',			'07',           '138',    				'G011334',     		2019,      0,			'11'),
		--DESCARTADO T_CUENTA(/*'Otros servicios jurídicos',           */                        	'47',			'07',           '138',    				'G011377',     		2019,      0,			'11'),
		--DESCARTADO T_CUENTA(/*'Administrador Comunidad Propietarios',*/                        	'48',			'07',           '138',    				'G011377',     		2019,      0,			'11'),
		--DESCARTADO T_CUENTA(/*'Asesoría',                            */                        	'49',			'07',           '138',    				'G011377',     		2019,      0,			'11'),
		--DESCARTADO T_CUENTA(/*'Técnico',                             */                       		'50',			'07',           '138',    				'G011377',     		2019,      0,			'11'),
		--DESCARTADO T_CUENTA(/*'Tasación',                            */                        	'51',			'07',           '138',    				'G011318',     		2019,      0,			'11'),
		--VACIOEXCEL T_CUENTA('Gestión de suelo',                                       '94',   		'07',       	'138',        			0,     		2019,      0,			'11'),
		--VACIOEXCEL T_CUENTA('Otros',                                                  '52',   		'07',       	'138',        			0,     		2019,      0,			'11'),

		--DESCARTADO T_CUENTA(/*'Registro',                            */                        	'43',			'07',           '138',    				'G011360',     		2019,      1,			'11'),
		--DESCARTADO T_CUENTA(/*'Notaría',                             */                        	'44',			'07',           '138',    				'G011301',     		2019,      1,			'11'),
		--DESCARTADO T_CUENTA(/*'Abogado (Ocupacional)',               */                			'95',			'07',           '138',    				'G011358',     		2019,      1,			'11'),
		--DESCARTADO T_CUENTA(/*'Abogado (Asuntos generales)',         */                			'96',			'07',           '138',    				'G011358',     		2019,      1,			'11'),
		--DESCARTADO T_CUENTA(/*'Abogado (Asistencia jurídica)',       */                       		'97',			'07',           '138',    				'G011358',     		2019,      1,			'11'),
		--DESCARTADO T_CUENTA(/*'Procurador',                          */                        	'46',			'07',           '138',    				'G011334',     		2019,      1,			'11'),
		--DESCARTADO T_CUENTA(/*'Otros servicios jurídicos',           */                        	'47',			'07',           '138',    				'G011377',     		2019,      1,			'11'),
		--DESCARTADO T_CUENTA(/*'Administrador Comunidad Propietarios',*/                        	'48',			'07',           '138',    				'G011377',     		2019,      1,			'11'),
		--DESCARTADO T_CUENTA(/*'Asesoría',                            */                        	'49',			'07',           '138',    				'G011377',     		2019,      1,			'11'),
		--DESCARTADO T_CUENTA(/*'Técnico',                             */                       		'50',			'07',           '138',    				'G011377',     		2019,      1,			'11'),
		--DESCARTADO T_CUENTA(/*'Tasación',                            */                        	'51',			'07',           '138',    				'G011318',     		2019,      1,			'11'),
		--VACIOEXCEL T_CUENTA('Gestión de suelo',                                       '94', 			'07',       	'138',        			0,     		2019,      1,			'11'),
		--VACIOEXCEL T_CUENTA('Otros',                                                  '52',   		'07',       	'138',        			0,     		2019,      1,			'11'),

		-- GESTORIA			
		--NOEXISTE T_CUENTA(/*'Honorarios gestión activos (formalización arrendamientos)',*/   	'¿53?',			'07',           '138',    		'G011361',     		2019,      0,			'12'),
		--NOEXISTE T_CUENTA(/*'Honorarios gestión activos (mantenimiento arrendamientos)',*/   	'¿53?',			'07',           '138',    		'G011361',     		2019,      0,			'12'),
		--DESCARTADO T_CUENTA(/*'Honorarios gestión ventas',   							   */		'54',			'07',           '138',    				'G011328',     		2019,      0,			'12'),

		--NOEXISTE T_CUENTA(/*'Honorarios gestión activos (formalización arrendamientos)',*/   	'¿53?',			'07',           '138',    		'G011361',     		2019,      1,			'12'),
		--NOEXISTE T_CUENTA(/*'Honorarios gestión activos (mantenimiento arrendamientos)',*/   	'¿53?',			'07',           '138',    		'G011361',     		2019,      1,			'12'),
		--DESCARTADO T_CUENTA(/*'Honorarios gestión ventas',   							   */		'54',			'07',           '138',    				'G011328',     		2019,      1,			'12'),

		--COMISIONES
		--DESCARTADO T_CUENTA(/*'Mediador',   				*/										'55',			'07',           '138',    				'G011328',     		2019,      0,			'13'),
		--DESCARTADO T_CUENTA(/*'Fuerza de Venta Directa',   */										'56',			'07',           '138',    				'G011328',     		2019,      0,			'13'),
				
		--DESCARTADO T_CUENTA(/*'Mediador',   					*/									'55',			'07',           '138',    				'G011328',     		2019,      1,			'13'),
		--DESCARTADO T_CUENTA(/*'Fuerza de Venta Directa',   	*/									'56',			'07',           '138',    				'G011328',     		2019,      1,			'13'),

		-- INFORMES TÉCNICOS Y OBTENCIÓN DOCUMENTOS			
		--DESCARTADO T_CUENTA(/*'Informes',                                 */                   	'57',			'07',           '138',    				'G011332',     		2019,      0,			'14'),
		--DESCARTADO T_CUENTA(/*'Certif. eficiencia energética (CEE)',      */                   	'58',			'07',           '138',    				'G011329',     		2019,      0,			'14'),
		--DESCARTADO T_CUENTA(/*'Licencia Primera Ocupación (LPO)',         */                   	'59',			'07',           '138',    				'G011351',     		2019,      0,			'14'),
		--DESCARTADO T_CUENTA(/*'Cédula Habitabilidad',                     */                   	'60',			'07',           '138',    				'G011330',     		2019,      0,			'14'),
		--DESCARTADO T_CUENTA(/*'Certificado Final de Obra (CFO)',          */                   	'61',			'07',           '138',    				'G011333',     		2019,      0,			'14'),
		--DESCARTADO T_CUENTA(/*'Boletín instalaciones y suministros',      */                   	'62',			'07',           '138',    				'G011346',     		2019,      0,			'14'),
		--DESCARTADO T_CUENTA(/*'Obtención certificados y documentación',   */                   	'63',			'07',           '138',    				'G011332',     		2019,      0,			'14'),
		--DESCARTADO T_CUENTA(/*'Nota simple actualizada',                  */                   	'64',			'07',           '138',    				'G011360',     		2019,      0,			'14'),
		--DESCARTADO T_CUENTA(/*'VPO: Solicitud devolución ayudas',         */                   	'65',			'07',           '138',    				'G011376',     		2019,      0,			'14'),
		--DESCARTADO T_CUENTA(/*'VPO: Notificación adjudicación (tanteo)',  */                   	'66',			'07',           '138',    				'G011376',     		2019,      0,			'14'),
		--DESCARTADO T_CUENTA(/*'VPO: Autorización de venta',               */                   	'67',			'07',           '138',    				'G011376',     		2019,      0,			'14'),
		--DESCARTADO T_CUENTA(/*'Inspección técnica de edificios',          */                   	'68',			'07',           '138',    				'G011332',     		2019,      0,			'14'),
		--VACIOEXCEL T_CUENTA('Informe topográfico',                                  	'69',			'07',       	'138',        			0,     		2019,      0,			'14'),

		--DESCARTADO T_CUENTA(/*'Informes',                                   */                 	'57',			'07',           '138',    				'G011332',     		2019,      1,			'14'),
		--DESCARTADO T_CUENTA(/*'Certif. eficiencia energética (CEE)',        */                 	'58',			'07',           '138',    				'G011329',     		2019,      1,			'14'),
		--DESCARTADO T_CUENTA(/*'Licencia Primera Ocupación (LPO)',           */                 	'59',			'07',           '138',    				'G011351',     		2019,      1,			'14'),
		--DESCARTADO T_CUENTA(/*'Cédula Habitabilidad',                       */                 	'60',			'07',           '138',    				'G011330',     		2019,      1,			'14'),
		--DESCARTADO T_CUENTA(/*'Certificado Final de Obra (CFO)',            */                 	'61',			'07',           '138',    				'G011333',     		2019,      1,			'14'),
		--DESCARTADO T_CUENTA(/*'Boletín instalaciones y suministros',        */                 	'62',			'07',           '138',    				'G011346',     		2019,      1,			'14'),
		--DESCARTADO T_CUENTA(/*'Obtención certificados y documentación',     */                 	'63',			'07',           '138',    				'G011332',     		2019,      1,			'14'),
		--DESCARTADO T_CUENTA(/*'Nota simple actualizada',                    */                 	'64',			'07',           '138',    				'G011360',     		2019,      1,			'14'),
		--DESCARTADO T_CUENTA(/*'VPO: Solicitud devolución ayudas',           */                 	'65',			'07',           '138',    				'G011376',     		2019,      1,			'14'),
		--DESCARTADO T_CUENTA(/*'VPO: Notificación adjudicación (tanteo)',    */                 	'66',			'07',           '138',    				'G011376',     		2019,      1,			'14'),
		--DESCARTADO T_CUENTA(/*'VPO: Autorización de venta',                 */                 	'67',			'07',           '138',    				'G011376',     		2019,      1,			'14'),
		--DESCARTADO T_CUENTA(/*'Inspección técnica de edificios',            */                 	'68',			'07',           '138',    				'G011332',     		2019,      1,			'14'),
		--VACIOEXCEL T_CUENTA('Informe topográfico',                                  	'69',			'07',       	'138',        			0,     		2019,      1,			'14'),

		-- ACTUACIÓN TÉCNICA Y MANTENIMIENTO			
		--NOEXISTE T_CUENTA(/*'Cambio de cerradura (Adecuación)',          */                  	'¿70?',			'07',           '138',    		'G011317',     		2019,      0,			'15'),
		--NOEXISTE T_CUENTA(/*'Cambio de cerradura (Mantenimiento)',       */                  	'¿70?',			'07',           '138',    		'G011317',     		2019,      0,			'15'),
		--DESCARTADO T_CUENTA(/*'Tapiado',                                   */                  	'71',			'07',           '138',    				'G011316',     		2019,      0,			'15'),
		--DESCARTADO T_CUENTA(/*'Retirada de enseres',                       */                  	'72',			'07',           '138',    				'G011315',     		2019,      0,			'15'),
		--NOEXISTE T_CUENTA(/*'Limpieza (Adecuación)',                     */                  	'¿73?',			'07',           '138',    		'G011315',     		2019,      0,			'15'),
		--NOEXISTE T_CUENTA(/*'Limpieza (Mantenimiento)',                  */                  	'¿73?',			'07',           '138',    		'G011315',     		2019,      0,			'15'),
		--DESCARTADO T_CUENTA(/*'Limpieza y retirada de enseres',            */                  	'74',			'07',           '138',    				'G011315',     		2019,      0,			'15'),
		--DESCARTADO T_CUENTA(/*'Limpieza, retirada de enseres y descerraje',*/                  	'75',			'07',           '138',    				'G011315',     		2019,      0,			'15'),
		--DESCARTADO T_CUENTA(/*'Limpieza, desinfección… (solares)',         */                 		'76',			'07',           '138',    				'G011316',     		2019,      0,			'15'),
		--NOEXISTE T_CUENTA(/*'Jardinería',                          		*/						'',			'07',           '138',    		'G011315',     		2019,      0,			'15'),
		--NOEXISTE T_CUENTA(/*'Seguridad y Salud (Adecuación)',            */                  	'¿77?',			'07',           '138',    		'G011316',     		2019,      0,			'15'),
		--NOEXISTE T_CUENTA(/*'Seguridad y Salud (Mantenimiento)',         */                  	'¿77?',			'07',           '138',    		'G011316',     		2019,      0,			'15'),
		--DESCARTADO T_CUENTA(/*'Verificación de averías',                   */                  	'78',			'07',           '138',    				'G011316',     		2019,      0,			'15'),
		--NOEXISTE T_CUENTA(/*'Obra menor (Adecuación)',                   */                  	'¿79?',			'07',           '138',    		'G011316',     		2019,      0,			'15'),
		--NOEXISTE T_CUENTA(/*'Obra menor (Mantenimiento)',                */                  	'¿79?',			'07',           '138',    		'G011316',     		2019,      0,			'15'),
		--VACIOEXCEL T_CUENTA('Obra mayor Edificación (certif. de obra)',               '80',   		'07',         	'138',      			'',     		2019,      0,			'15'),
		--DESCARTADO T_CUENTA(/*'Control de actuaciones (dirección técnica)',  */                	'81',			'07',           '138',    				'G011332',     		2019,      0,			'15'),
		--NOEXISTE T_CUENTA(/*'Colocación puerta antiocupa (Adecuación)',    */                	'¿82?',			'07',           '138',    		'G011316',     		2019,      0,			'15'),
		--NOEXISTE T_CUENTA(/*'Colocación puerta antiocupa (Mantenimiento)', */                	'¿82?',			'07',           '138',    		'G011316',     		2019,      0,			'15'),
		--NOEXISTE T_CUENTA(/*'Mobiliario (Adecuación)',                     */                	'¿83?',			'07',           '138',    		'G011316',     		2019,      0,			'15'),
		--NOEXISTE T_CUENTA(/*'Mobiliario (Mantenimiento)',                  */                	'¿83?',			'07',           '138',    		'G011316',     		2019,      0,			'15'),
		--DESCARTADO T_CUENTA(/*'Actuación post-venta',                        */             		'84',			'07',           '138',    				'G011316',     		2019,      0,			'15'),
		--NOEXISTE T_CUENTA(/*'Ascensores',                                  */   					'',			'07',           '138',    		'G011316',     		2019,      0,			'15'),
		--NOEXISTE T_CUENTA(/*'Mantenimiento de instalaciones',              */                	'',			'07',           '138',    			'G011316',     		2019,      0,			'15'),

		--NOEXISTE T_CUENTA(/*'Cambio de cerradura (Adecuación)',            */                	'¿70?',			'07',           '138',    		'G011317',     		2019,      1,			'15'),
		--NOEXISTE T_CUENTA(/*'Cambio de cerradura (Mantenimiento)',         */                	'¿70?',			'07',           '138',    		'G011317',     		2019,      1,			'15'),
		--DESCARTADO T_CUENTA(/*'Tapiado',                                     */                	'71',			'07',           '138',    				'G011316',     		2019,      1,			'15'),
		--DESCARTADO T_CUENTA(/*'Retirada de enseres',                         */                	'72',			'07',           '138',    				'G011315',     		2019,      1,			'15'),
		--NOEXISTE T_CUENTA(/*'Limpieza (Adecuación)',                       */                	'¿73?',			'07',           '138',    		'G011315',     		2019,      1,			'15'),
		--NOEXISTE T_CUENTA(/*'Limpieza (Mantenimiento)',                    */                	'¿73?',			'07',           '138',    		'G011315',     		2019,      1,			'15'),
		--DESCARTADO T_CUENTA(/*'Limpieza y retirada de enseres',              */                	'74',			'07',           '138',    				'G011315',     		2019,      1,			'15'),
		--DESCARTADO T_CUENTA(/*'Limpieza, retirada de enseres y descerraje',  */                	'75',			'07',           '138',    				'G011315',     		2019,      1,			'15'),
		--DESCARTADO T_CUENTA(/*'Limpieza, desinfección… (solares)',           */               		'76',			'07',           '138',    				'G011316',     		2019,      1,			'15'),
		--NOEXISTET_CUENTA(/*'Jardinería',                          		*/						'',			'07',           '138',    		'G011315',     		2019,      1,			'15'),
		--NOEXISTE T_CUENTA(/*'Seguridad y Salud (Adecuación)',            */                  	'¿77?',			'07',           '138',    		'G011316',     		2019,      1,			'15'),
		--NOEXISTE T_CUENTA(/*'Seguridad y Salud (Mantenimiento)',         */                 	'¿77?',			'07',           '138',    		'G011316',     		2019,      1,			'15'),
		--DESCARTADO T_CUENTA(/*'Verificación de averías',                   */                  	'78',			'07',           '138',    				'G011316',     		2019,      1,			'15'),
		--NOEXISTE T_CUENTA(/*'Obra menor (Adecuación)',                   */                	'¿79?',			'07',           '138',    		'G011316',     		2019,      1,			'15'),
		--NOEXISTE T_CUENTA(/*'Obra menor (Mantenimiento)',                  */                	'¿79?',			'07',           '138',    		'G011316',     		2019,      1,			'15'),
		--VACIOEXCEL T_CUENTA('Obra mayor Edificación (certif. de obra)',               '80', 		'07',         	'138',      				'',     		2019,      1,			'15'),
		--DESCARTADO T_CUENTA(/*'Control de actuaciones (dirección técnica)',   */               	'81',			'07',           '138',    				'G011332',     		2019,      1,			'15'),
		--NOEXISTE T_CUENTA(/*'Colocación puerta antiocupa (Adecuación)',     */               	'¿82?',			'07',           '138',    		'G011316',     		2019,      1,			'15'),
		--NOEXISTE T_CUENTA(/*'Colocación puerta antiocupa (Mantenimiento)',  */               	'¿82?',			'07',           '138',    		'G011316',     		2019,      1,			'15'),
		--NOEXISTE T_CUENTA(/*'Mobiliario (Adecuación)',                      */               	'¿83?',			'07',           '138',    		'G011316',     		2019,      1,			'15'),
		--NOEXISTE T_CUENTA(/*'Mobiliario (Mantenimiento)',                   */               	'¿83?',			'07',           '138',    		'G011316',     		2019,      1,			'15'),
		--DESCARTADO T_CUENTA(/*'Actuación post-venta',                         */            		'84',			'07',           '138',    				'G011316',     		2019,      1,			'15'),
		--NOEXISTE T_CUENTA(/*'Ascensores',                                   */  					'',			'07',           '138',    		'G011316',     		2019,      1,			'15'),
		--NOEXISTE T_CUENTA(/*'Mantenimiento de instalaciones',               */               	'',			'07',           '138',    			'G011316',     		2019,      1,			'15'),

		-- VIGILANCIA Y SEGURIDAD			
		--DESCARTADO T_CUENTA(/*'Vigilancia y seguridad',            */                          	'85',			'07',           '138',    				'G011327',     		2019,      0,			'16'),
		--DESCARTADO T_CUENTA(/*'Alarmas',                           */                          	'86',			'07',           '138',    				'G011327',     		2019,      0,			'16'),
		--DESCARTADO T_CUENTA(/*'Servicios auxiliares',              */                          	'87',			'07',           '138',    				'G011327',     		2019,      0,			'16'),
				
		--DESCARTADO T_CUENTA(/*'Vigilancia y seguridad',             */                         	'85',			'07',           '138',    				'G011327',     		2019,      1,			'16'),
		--DESCARTADO T_CUENTA(/*'Alarmas',                            */                         	'86',			'07',           '138',    				'G011327',     		2019,      1,			'16'),
		--DESCARTADO T_CUENTA(/*'Servicios auxiliares',               */                         	'87',			'07',           '138',    				'G011327',     		2019,      1,			'16'),

		--PUBLICIDAD
		--DESCARTADO T_CUENTA(/*'Publicidad',                */                        				'88',			'07',           '138',    				'G011349',     		2019,      0,			'17'),

		--DESCARTADO T_CUENTA(/*'Publicidad',                */                        				'88',			'07',           '138',    				'G011349',     		2019,      1,			'17'),

		-- OTROS GASTOS			
		--DESCARTADO T_CUENTA(/*'Mensajería/correos/copias', */                                  	'89',			'07',           '138',    				'G011349',     		2019,      0,			'18'),
		--DESCARTADO T_CUENTA(/*'Costas judiciales',         */                						'90',			'07',           '138',    				'G011338',     		2019,      0,			'18'),
		--VACIOEXCEL T_CUENTA('Otros',                                   				'91',    		'07',         	'138',      			'',     		2019,      0,			'18'),

		--DESCARTADO T_CUENTA(/*'Mensajería/correos/copias', */                                  	'89',			'07',           '138',    				'G011349',     		2019,      1,			'18'),
		--DESCARTADO T_CUENTA(/*'Costas judiciales',         */                						'90',			'07',           '138',    				'G011338',     		2019,      1,			'18')
		--VACIOEXCEL T_CUENTA('Otros',                                   				'91',    		'07',         	'138',      			'',     		2019,      1,			'18'),

		--ADECUACIONES?
		--NOEXISTE T_CUENTA(/*'Residencial Alquiler',      */                           '',			'07',           '138',    				'G011381',     		2019,      0,			'19'),

		--NOEXISTE T_CUENTA(/*'Residencial Alquiler',      */                           '',			'07',           '138',    				'G011381',     		2019,      1,			'19'),

		--GASTO DE MANTENIMIENTO ALQUILABLE?
		--NOEXISTE T_CUENTA(/*'Residencial Alquiler',      */                           '',			'07',           '138',    				'G011381',     		2019,      0,			'19'),

		--NOEXISTE T_CUENTA(/*'Residencial Alquiler',      */                           '',			'07',           '138',    				'G011381',     		2019,      1,			'19')
    );
    V_TMP_CUENTA T_CUENTA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Haciendo comprobaciones previas... ');

    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id de la cartera, porque es el mismo para todos.');

    V_SQL :=    'SELECT DD_CRA_ID 
                FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
                WHERE DD_CRA_CODIGO = ''07''';
    EXECUTE IMMEDIATE V_SQL INTO V_DD_CRA_ID;

    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id de la subcartera, porque es el mismo para todos.');

    V_SQL :=    'SELECT DD_SCR_ID 
                FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA 
                WHERE DD_SCR_CODIGO = ''138''';
    EXECUTE IMMEDIATE V_SQL INTO V_DD_SCR_ID;

    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id del año, porque es el mismo para todos.');

    V_SQL :=    'SELECT EJE_ID 
                FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO 
                WHERE EJE_ANYO = 2019';
    EXECUTE IMMEDIATE V_SQL INTO V_EJE_ID;

    FOR I IN V_CUENTAS.FIRST .. V_CUENTAS.LAST
    LOOP
        V_TMP_CUENTA := V_CUENTAS(I);

        DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando si existe la partida presupuestaria para el subtipo de gasto con código '||TRIM(V_TMP_CUENTA(1))||', para la cartera de Cerberus subcartera Apple y para el año 2019.');

		V_SQL := 	'SELECT COUNT(*)
					FROM CPP_CONFIG_PTDAS_PREP CPP
					INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CPP.DD_STG_ID
					INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID
					WHERE CPP.DD_STG_ID = (SELECT DD_STG_ID 
										   FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO 
										   WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||''')
					AND TGA.DD_TGA_ID = (SELECT DD_TGA_ID 
										 FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO
										 WHERE DD_TGA_CODIGO = '''||TRIM(V_TMP_CUENTA(6))||''')
					AND CPP.DD_CRA_ID = '||V_DD_CRA_ID||'
					AND EJE_ID = '||V_EJE_ID||'
					AND CPP_ARRENDAMIENTO = '||TRIM(V_TMP_CUENTA(5))||'';

        EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_PARTIDA;

        IF V_EXISTE_PARTIDA = 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] Añadiendo la partida presupuestaria '||TRIM(V_TMP_CUENTA(3))||' para el subtipo '||TRIM(V_TMP_CUENTA(1))||'.');

            V_SQL :=    'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
                        (
                              CPP_ID
                            , EJE_ID
                            , DD_STG_ID
                            , DD_CRA_ID
                            , DD_SCR_ID
                            , CPP_PARTIDA_PRESUPUESTARIA
                            , VERSION
                            , USUARIOCREAR
                            , FECHACREAR
                            , BORRADO
                            , CPP_ARRENDAMIENTO
                        )
                        VALUES
                        (
                            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL
							, '||V_EJE_ID||'
							, (SELECT DD_STG_ID 
								FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG								
								WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||'''
								AND DD_TGA_ID = (SELECT DD_TGA_ID 
												 FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO 
												 WHERE DD_TGA_CODIGO = '''||TRIM(V_TMP_CUENTA(7))||'''))
                            , '||V_DD_CRA_ID||'
                            , '||V_DD_SCR_ID||'
                            , '''||TRIM(V_TMP_CUENTA(4))||'''
                            , 0
                            , '''||V_USUARIO||'''
                            , SYSDATE
                            , 0
                            , '||TRIM(V_TMP_CUENTA(6))||'
                        )';

            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] La partida presupuestaria '||TRIM(V_TMP_CUENTA(4))||' ha sido insertada satisfactoriamente.');

        ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el subgasto '||TRIM(V_TMP_CUENTA(1))||' con la partida presupuestaria '||TRIM(V_TMP_CUENTA(4))||' para el año '||TRIM(V_TMP_CUENTA(5))||'.');
        END IF;

    END LOOP;

	DBMS_OUTPUT.PUT_LINE('[FIN] Finalizado el proceso de inserción de partidas presupuestarias.');
	COMMIT;

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;

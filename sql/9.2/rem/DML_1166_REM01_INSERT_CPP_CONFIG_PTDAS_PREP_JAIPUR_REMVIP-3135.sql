--/*
--#########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20190401
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3135
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir las nuevas partidas presupuestarias para los gastos de Sareb para este 2019
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3135';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

	V_TABLA VARCHAR2(30 CHAR) := 'CPP_CONFIG_PTDAS_PREP'; -- Variable para tabla.
    V_DD_CRA_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la cartera.
	V_EJE_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del año.
	
	V_EXISTE_PARTIDA NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.

    TYPE T_CUENTA IS TABLE OF VARCHAR2(1000);

    TYPE T_ARRAY_CUENTAS IS TABLE OF T_CUENTA;
    V_CUENTAS T_ARRAY_CUENTAS := T_ARRAY_CUENTAS(
        
                --SUPTIPO GASTO												  --CARTERA			 --PARTIDA PRESUP.	      --AÑO	  --ARRENDAMIENTO	-- TIPO GASTO
		-- IMPUESTOS
        T_CUENTA('01',  /*'IBI urbana',*/                                       '07',               'G011311',     			2019,      0,			'01'),
		T_CUENTA('02',  /*'IBI rústica',*/                                      '07',               'G011311',     			2019,      0,			'01'),
		T_CUENTA('03',  /*'Plusvalía (IIVTNU) compra',*/                        '07',               'G011367',     			2019,      0,			'01'),
		T_CUENTA('04',  /*'Plusvalía (IIVTNU) venta',*/                         '07',               'G011324',     			2019,      0,			'01'),
		T_CUENTA('92',  /*'Recargos e intereses',*/                             '07',               'G011379',     			2019,      0,			'01'),

		-- TASA			
		T_CUENTA('08',  /*'Basura',*/                                           '07',               'G011323',     			2019,      0,			'02'),
		T_CUENTA('09',  /*'Alcantarillado',*/                                   '07',               'G011323',     			2019,      0,			'02'),
		T_CUENTA('10',  /*'Agua',*/                                             '07',               'G011323',     			2019,      0,			'02'),
		T_CUENTA('11',  /*'Vado',*/                                             '07',               'G011323',     			2019,      0,			'02'),
		T_CUENTA('12',  /*'Ecotasa',*/                                          '07',               'G011323',     			2019,      0,			'02'),
		T_CUENTA('13',  /*'Regularización catastral',*/                         '07',               'G011383',     			2019,      0,			'02'),
		T_CUENTA('14',  /*'Expedición documentos',*/                            '07',               'G011383',     			2019,      0,			'02'),
		T_CUENTA('16',  /*'Judicial',*/                                         '07',               'G011338',     			2019,      0,			'02'),
		T_CUENTA('17',  /*'Otras tasas ayuntamiento',*/                         '07',               'G011383',     			2019,      0,			'02'),
		T_CUENTA('18',  /*'Otras tasas',*/                                      '07',               'G011383',     			2019,      0,			'02'),

		-- OTROS ATRIBUTOS			
		T_CUENTA('19',	/*'Contribución especial',*/                            '07',               'G011383',     			2019,      0,			'03'),

		-- COMUNIDAD DE PROPIETARIOS			
		T_CUENTA('26', 	/*'Cuota ordinaria',*/                                  '07',               'G011309',     			2019,      0,			'05'),
		T_CUENTA('27', 	/*'Cuota extraordinaria (derrama)',*/                   '07',               'G011309',     			2019,      0,			'05'),
		T_CUENTA('93', 	/*'Certificado deuda comunidad',*/                      '07',               'G011378',     			2019,      0,			'05'),

		-- COMPLEJO INMOBILIARIO
		T_CUENTA('28', 	/*'Cuota ordinaria',*/                                  '07',               'G011309',     			2019,      0,			'06'),
		T_CUENTA('29', 	/*'Cuota extraordinaria (derrama)',*/                   '07',               'G011309',     			2019,      0,			'06'),

		-- JUNTA DE COMPENSACIÓN / EUC			
		T_CUENTA('30',	/*'Gastos generales',*/                                 '07',               'G011313',     			2019,      0,			'07'),
		T_CUENTA('31',	/*'Cuotas y derramas',*/                                '07',               'G011357',     			2019,      0,			'07'),

		-- OTRAS ENTIDADES			
		T_CUENTA('32',	/*'Gastos generales',*/                                 '07',               'G011313',     			2019,      0,			'08'),
		T_CUENTA('33',	/*'Cuotas y derramas',*/                                '07',               'G011357',     			2019,      0,			'08'),

		-- SUMINISTRO			
		T_CUENTA('35',	/*'Electricidad',*/                                     '07',               'G011335',     			2019,      0,			'09'),
		T_CUENTA('36',	/*'Agua',*/                                             '07',               'G011336',     			2019,      0,			'09'),
		T_CUENTA('37',	/*'Gas',*/                                              '07',               'G011337',     			2019,      0,			'09'),
		T_CUENTA('35',	/*'Electricidad',*/                                     '07',               'G011373',     			2019,      1,			'09'), -- ARRENDADO
		T_CUENTA('36',	/*'Agua',*/                                             '07',               'G011374',     			2019,      1,			'09'), -- ARRENDADO	
		T_CUENTA('37',	/*'Gas',*/                                              '07',               'G011375',     			2019,      1,			'09'), -- ARRENDADO

		-- SEGUROS			
		T_CUENTA('39', /*'Prima TRDM (todo riesgo daño material)',*/            '07',               'G011321',     			2019,      0,			'10'),
		T_CUENTA('40', /*'Prima RC (responsabilidad civil)',*/                  '07',               'G011321',     			2019,      0,			'10'),
		T_CUENTA('41', /*'Parte daños propios',*/                               '07',               'G011321',     			2019,      0,			'10'),
		T_CUENTA('42', /*'Parte daños a terceros',*/                            '07',               'G011321',     			2019,      0,			'10'),

		-- SERVICIOS PROFESIONALES INDEPENDIENTES			
		T_CUENTA('43',	/*'Registro',*/                                         '07',               'G011360',	     		2019,      0,			'11'),
		T_CUENTA('44',	/*'Notaría',*/                                          '07',               'G011301',	     		2019,      0,			'11'),
		T_CUENTA('95',	/*'Abogado (Ocupacional)',*/                           	'07',               'G011358',	     		2019,      0,			'11'),
		T_CUENTA('96',	/*'Abogado (Asuntos generales)',*/                      '07',               'G011358',	     		2019,      0,			'11'),
		T_CUENTA('97',	/*'Abogado (Asistencia jurídica)',*/                    '07',               'G011358',	     		2019,      0,			'11'),
		T_CUENTA('46',	/*'Procurador',*/                                       '07',               'G011334',	     		2019,      0,			'11'),
		T_CUENTA('47',	/*'Otros servicios jurídicos',*/                        '07',               'G011377',	     		2019,      0,			'11'),
		T_CUENTA('49',	/*'Asesoría',*/                                         '07',               'G011377',	     		2019,      0,			'11'),
		T_CUENTA('50',	/*'Técnico',*/                                          '07',               'G011332',	     		2019,      0,			'11'),
		T_CUENTA('51',	/*'Tasación',*/                                         '07',               'G011318',	     		2019,      0,			'11'),

		-- GESTORIA			
		T_CUENTA('53', 	/*'Honorarios gestión activos',*/                       '07',               'G011361',	     		2019,      0,			'12'),
		T_CUENTA('54', 	/*'Honorarios gestión ventas',*/                        '07',               'G011328',	     		2019,      0,			'12'),

		-- INFORMES TÉCNICOS Y OBTENCIÓN DOCUMENTOS			
		T_CUENTA('57',	/*'Informes', */                                        '07',               'G011332',	     		2019,      0,			'14'),
		T_CUENTA('58',	/*'Certif. eficiencia energética (CEE)',*/              '07',               'G011329',	     		2019,      0,			'14'),
		T_CUENTA('59',	/*'Licencia Primera Ocupación (LPO)',*/                 '07',               'G011351',	     		2019,      0,			'14'),
		T_CUENTA('60',	/*'Cédula Habitabilidad', */                            '07',               'G011330',	     		2019,      0,			'14'),
		T_CUENTA('61',	/*'Certificado Final de Obra (CFO)',*/                  '07',               'G011333',	     		2019,      0,			'14'),
		T_CUENTA('62',	/*'Boletín instalaciones y suministros', */             '07',               'G011346',	     		2019,      0,			'14'),
		T_CUENTA('63',	/*'Obtención certificados y documentación', */          '07',               'G011332',	     		2019,      0,			'14'),
		T_CUENTA('64',	/*'Nota simple actualizada', */                         '07',               'G011360',	     		2019,      0,			'14'),
		T_CUENTA('65',	/*'VPO: Solicitud devolución ayudas', */                '07',               'G011376',	     		2019,      0,			'14'),
		T_CUENTA('66',	/*'VPO: Notificación adjudicación (tanteo)',*/          '07',               'G011376',	     		2019,      0,			'14'),
		T_CUENTA('67',	/*'VPO: Autorización de venta', */                      '07',               'G011376',	     		2019,      0,			'14'),

		-- ACTUACIÓN TÉCNICA Y MANTENIMIENTO			
		T_CUENTA('70',	/*'Cambio de cerradura',*/                              '07',               'G011317',	     		2019,      0,			'15'),
		T_CUENTA('71',	/*'Tapiado',*/                                          '07',               'G011316',	     		2019,      0,			'15'),
		T_CUENTA('72',	/*'Retirada de enseres',*/                              '07',               'G011315',	     		2019,      0,			'15'),
		T_CUENTA('73',	/*'Limpieza',*/                                         '07',               'G011315',	     		2019,      0,			'15'),
		T_CUENTA('74',	/*'Limpieza y retirada de enseres',*/                   '07',               'G011315',	     		2019,      0,			'15'),
		T_CUENTA('75',	/*'Limpieza, retirada de enseres y descerraje',*/       '07',               'G011315',	     		2019,      0,			'15'),
		T_CUENTA('76',	/*'Limpieza, desinfección… (solares)',*/                '07',               'G011316',	     		2019,      0,			'15'),
		T_CUENTA('77',	/*'Seguridad y Salud (SS)',*/                           '07',               'G011316',	     		2019,      0,			'15'),
		T_CUENTA('78',	/*'Verificación de averías',*/                          '07',               'G011316',	     		2019,      0,			'15'),
		T_CUENTA('79',	/*'Obra menor',*/                                       '07',               'G011316',	     		2019,      0,			'15'),
		T_CUENTA('81',	/*'Control de actuaciones (dirección técnica)',*/       '07',               'G011332',	     		2019,      0,			'15'),
		T_CUENTA('82',	/*'Colocación puerta antiocupa',*/                      '07',               'G011316',	     		2019,      0,			'15'),
		T_CUENTA('83',	/*'Mobiliario',*/                                       '07',               'G011316',	     		2019,      0,			'15'),
		-- NOEXSITE T_CUENTA('Adecuaciones stock residencial- no residencial VENTA/ALQ',    '07',               6222000002,     		2019,      0,			'15'),
        -- NOEXISTE T_CUENTA('Adecuaciones stock residencial- no residencial VENTA/ALQ',    '07',               6222000002,     		2019,      0,			'15'), -- ARRENDADO

		-- VIGILANCIA Y SEGURIDAD			
		T_CUENTA('85',	/*'Vigilancia y seguridad',*/                           '07',               'G011327',	     		2019,      0,			'16'),
		T_CUENTA('86',	/*'Alarmas',*/                                          '07',               'G011327',	     		2019,      0,			'16'),
		T_CUENTA('87',	/*'Servicios auxiliares',*/                             '07',               'G011327',	     		2019,      0,			'16'),

		-- OTROS GASTOS			
		T_CUENTA('89',	/*'Mensajería/correos/copias',*/                        '07',               'G011349',	     		2019,      0,			'18')
    );
    V_TMP_CUENTA T_CUENTA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Haciendo comprobaciones previas... ');

    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id de la cartera, porque es el mismo para todos.');

    V_SQL :=    'SELECT DD_CRA_ID 
                FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
                WHERE DD_CRA_CODIGO = ''07''';
    EXECUTE IMMEDIATE V_SQL INTO V_DD_CRA_ID;

    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id del año, porque es el mismo para todos.');

    V_SQL :=    'SELECT EJE_ID 
                FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO 
                WHERE EJE_ANYO = 2019';
    EXECUTE IMMEDIATE V_SQL INTO V_EJE_ID;

    FOR I IN V_CUENTAS.FIRST .. V_CUENTAS.LAST
    LOOP
        V_TMP_CUENTA := V_CUENTAS(I);

        DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando si existe la partida presupuestaria para el subtipo de gasto '||TRIM(V_TMP_CUENTA(1))||', para la cartera de Tango y para el año de 2019.');

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
												 WHERE DD_TGA_CODIGO = '''||TRIM(V_TMP_CUENTA(6))||'''))
                            , '||V_DD_CRA_ID||'
                            , '''||TRIM(V_TMP_CUENTA(3))||'''
                            , 0
                            , '''||V_USUARIO||'''
                            , SYSDATE
                            , 0
                            , '||TRIM(V_TMP_CUENTA(5))||'
                        )';

            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] La partida presupuestaria '||TRIM(V_TMP_CUENTA(3))||' ha sido insertada satisfactoriamente.');

        ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el subgasto '||TRIM(V_TMP_CUENTA(1))||' con la partida presupuestaria '||TRIM(V_TMP_CUENTA(3))||' para el año '||TRIM(V_TMP_CUENTA(5))||'.');
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

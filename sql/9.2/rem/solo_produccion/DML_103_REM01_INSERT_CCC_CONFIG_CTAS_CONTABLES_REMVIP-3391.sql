--/*
--#########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=201903011
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3391
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar el estado de los siguientes gastos.
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3391';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

	V_TABLA VARCHAR2(30 CHAR) := 'CCC_CONFIG_CTAS_CONTABLES'; -- Variable para tabla.
    V_DD_CRA_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la cartera.
	V_EJE_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del año.
	
	V_EXISTE_CUENTA NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.

    TYPE T_CUENTA IS TABLE OF VARCHAR2(1000);

    TYPE T_ARRAY_CUENTAS IS TABLE OF T_CUENTA;
    V_CUENTAS T_ARRAY_CUENTAS := T_ARRAY_CUENTAS(
        
                --SUPTIPO GASTO												  --CARTERA			 --CUENTACONTABLE	      --AÑO	  --ARRENDAMIENTO	-- TIPO GASTO
		-- IMPUESTOS
        T_CUENTA('IBI urbana',                                                  '02',               6310000000,     		2019,      0,			'01'),
		T_CUENTA('IBI rústica',                                                 '02',               6310000000,     		2019,      0,			'01'),
		T_CUENTA('Plusvalía (IIVTNU) compra',                                   '02',               6320000000,     		2019,      0,			'01'),
		T_CUENTA('Plusvalía (IIVTNU) venta',                                    '02',               6320000000,     		2019,      0,			'01'),
		T_CUENTA('Recargos e intereses',                                        '02',               6780000004,     		2019,      0,			'01'),

		-- TASA			
		T_CUENTA('Basura',                                                      '02',               6310000000,     		2019,      0,			'02'),
		T_CUENTA('Alcantarillado',                                              '02',               6310000000,     		2019,      0,			'02'),
		T_CUENTA('Agua',                                                        '02',               6310000000,     		2019,      0,			'02'),
		T_CUENTA('Vado',                                                        '02',               6310000000,     		2019,      0,			'02'),
		T_CUENTA('Ecotasa',                                                     '02',               6310000000,     		2019,      0,			'02'),
		T_CUENTA('Regularización catastral',                                    '02',               6310000000,     		2019,      0,			'02'),
		T_CUENTA('Expedición documentos',                                       '02',               6310000000,     		2019,      0,			'02'),
		T_CUENTA('Judicial',                                                    '02',               6310000000,     		2019,      0,			'02'),
		T_CUENTA('Otras tasas ayuntamiento',                                    '02',               6310000000,     		2019,      0,			'02'),
		T_CUENTA('Otras tasas',                                                 '02',               6310000000,     		2019,      0,			'02'),

		-- OTROS ATRIBUTOS			
		T_CUENTA('Contribución especial',                                       '02',               6310000000,     		2019,      0,			'03'),

		-- SANCION			
		T_CUENTA('Urbanística',                                                 '02',               6780000004,     		2019,      0,			'04'),
		T_CUENTA('Tributaria',                                                  '02',               6780000004,     		2019,      0,			'04'),
		T_CUENTA('Ruina',                                                       '02',               6780000004,     		2019,      0,			'04'),
		T_CUENTA('Multa coercitiva',                                            '02',               6780000004,     		2019,      0,			'04'),
		T_CUENTA('Otros',                                                       '02',               6780000004,     		2019,      0,			'04'),

		-- COMUNIDAD DE PROPIETARIOS			
		T_CUENTA('Cuota ordinaria',                                             '02',               6220000000,     		2019,      0,			'05'),
		T_CUENTA('Cuota extraordinaria (derrama)',                              '02',               6220000000,     		2019,      0,			'05'),
        T_CUENTA('Cuota ordinaria',                                             '02',               6210400000,     		2019,      1,			'05'), -- ARRENDADO
		T_CUENTA('Cuota extraordinaria (derrama)',                              '02',               6210400000,     		2019,      1,			'05'), -- ARRENDADO
		T_CUENTA('Certificado deuda comunidad',                             	'02',               6220000000,     		2019,      0,			'05'),

		-- JUNTA DE COMPENSACIÓN / EUC			
		T_CUENTA('Gastos generales',                                            '02',               6210500000,     		2019,      0,			'07'),
		T_CUENTA('Cuotas y derramas',                                           '02',               6220000000,     		2019,      0,			'07'),

		-- SUMINISTRO			
		T_CUENTA('Electricidad',                                                '02',               6280200000,     		2019,      0,			'09'),
		T_CUENTA('Agua',                                                        '02',               6280100000,     		2019,      0,			'09'),
		T_CUENTA('Gas',                                                         '02',               6280500000,     		2019,      0,			'09'),

		-- SEGUROS			
		T_CUENTA('Prima TRDM (todo riesgo daño material)',                      '02',               6250000000,     		2019,      0,			'10'),
		T_CUENTA('Prima RC (responsabilidad civil)',                            '02',               6250000000,     		2019,      0,			'10'),
		T_CUENTA('Parte daños propios',                                         '02',               6250000000,     		2019,      0,			'10'),
		T_CUENTA('Parte daños a terceros',                                      '02',               6250000000,     		2019,      0,			'10'),

		-- SERVICIOS PROFESIONALES INDEPENDIENTES			
		T_CUENTA('Registro',                                                    '02',               6230600000,     		2019,      0,			'11'),
		T_CUENTA('Notaría',                                                     '02',               6230600000,     		2019,      0,			'11'),
		T_CUENTA('Abogado (Ocupacional)',                               		'02',               6230600000,     		2019,      0,			'11'),
		T_CUENTA('Abogado (Asuntos generales)',                         		'02',               6230600000,     		2019,      0,			'11'),
		T_CUENTA('Abogado (Asistencia jurídica)',                              '02',               6230600000,     		2019,      0,			'11'),
		T_CUENTA('Procurador',                                                  '02',               6230600000,     		2019,      0,			'11'),
		T_CUENTA('Otros servicios jurídicos',                                   '02',               6230600000,     		2019,      0,			'11'),
		T_CUENTA('Asesoría',                                                    '02',               6230600000,     		2019,      0,			'11'),
		T_CUENTA('Tasación',                                                    '02',               6230000001,     		2019,      0,			'11'),

		-- GESTORIA			
		T_CUENTA('Honorarios gestión activos',                                  '02',               6230100000,     		2019,      0,			'12'),
		T_CUENTA('Honorarios gestión ventas',                                   '02',               6230100000,     		2019,      0,			'12'),

		-- INFORMES TÉCNICOS Y OBTENCIÓN DOCUMENTOS			
		T_CUENTA('Informes',                                                    '02',               6230700000,     		2019,      0,			'14'),
		T_CUENTA('Certif. eficiencia energética (CEE)',                         '02',               6230700000,     		2019,      0,			'14'),
		T_CUENTA('Licencia Primera Ocupación (LPO)',                            '02',               6230700000,     		2019,      0,			'14'),
		T_CUENTA('Cédula Habitabilidad',                                        '02',               6230700000,     		2019,      0,			'14'),
		T_CUENTA('Certificado Final de Obra (CFO)',                             '02',               6230700000,     		2019,      0,			'14'),
		T_CUENTA('Boletín instalaciones y suministros',                         '02',               6230700000,     		2019,      0,			'14'),
		T_CUENTA('Obtención certificados y documentación',                      '02',               6230700000,     		2019,      0,			'14'),
		T_CUENTA('Nota simple actualizada',                                     '02',               6230600000,     		2019,      0,			'14'),
		T_CUENTA('VPO: Solicitud devolución ayudas',                            '02',               6230700000,     		2019,      0,			'14'),
		T_CUENTA('VPO: Notificación adjudicación (tanteo)',                     '02',               6230700000,     		2019,      0,			'14'),
		T_CUENTA('VPO: Autorización de venta',                                  '02',               6230700000,     		2019,      0,			'14'),

		-- ACTUACIÓN TÉCNICA Y MANTENIMIENTO			
		T_CUENTA('Cambio de cerradura',                                         '02',               6222000002,     		2019,      0,			'15'),
		T_CUENTA('Tapiado',                                                     '02',               6222000002,     		2019,      0,			'15'),
		T_CUENTA('Retirada de enseres',                                         '02',               6222000002,     		2019,      0,			'15'),
		T_CUENTA('Limpieza',                                                    '02',               6222000002,     		2019,      0,			'15'),
		T_CUENTA('Limpieza y retirada de enseres',                              '02',               6222000002,     		2019,      0,			'15'),
		T_CUENTA('Limpieza, retirada de enseres y descerraje',                  '02',               6222000002,     		2019,      0,			'15'),
		T_CUENTA('Limpieza, desinfección… (solares)',                          '02',               6222000002,     		2019,      0,			'15'),
		T_CUENTA('Seguridad y Salud (SS)',                                      '02',               6222000002,     		2019,      0,			'15'),
		T_CUENTA('Verificación de averías',                                     '02',               6222000002,     		2019,      0,			'15'),
		T_CUENTA('Obra menor',                                                  '02',               6222000002,     		2019,      0,			'15'),
		T_CUENTA('Control de actuaciones (dirección técnica)',                  '02',               6230700000,     		2019,      0,			'15'),
		T_CUENTA('Colocación puerta antiocupa',                                 '02',               6222000002,     		2019,      0,			'15'),
		T_CUENTA('Mobiliario',                                                  '02',               6222000002,     		2019,      0,			'15'),
		-- NOEXSITE T_CUENTA('Adecuaciones stock residencial- no residencial VENTA/ALQ',    '02',               6222000002,     		2019,      0,			'15'),
        -- NOEXISTE T_CUENTA('Adecuaciones stock residencial- no residencial VENTA/ALQ',    '02',               6222000002,     		2019,      0,			'15'), -- ARRENDADO

		-- VIGILANCIA Y SEGURIDAD			
		T_CUENTA('Vigilancia y seguridad',                                      '02',               6291100000,     		2019,      0,			'16'),
		T_CUENTA('Alarmas',                                                     '02',               6291100000,     		2019,      0,			'16'),
		T_CUENTA('Servicios auxiliares',                                        '02',               6291100000,     		2019,      0,			'16'),

		-- OTROS GASTOS			
		T_CUENTA('Mensajería/correos/copias',                                   '02',               6292000000,     		2019,      0,			'18')
    );
    V_TMP_CUENTA T_CUENTA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Haciendo comprobaciones previas... ');

    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id de la cartera, porque es el mismo para todos.');

    V_SQL :=    'SELECT DD_CRA_ID 
                FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
                WHERE DD_CRA_CODIGO = ''02''';
    EXECUTE IMMEDIATE V_SQL INTO V_DD_CRA_ID;

    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id del año, porque es el mismo para todos.');

    V_SQL :=    'SELECT EJE_ID 
                FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO 
                WHERE EJE_ANYO = 2019';
    EXECUTE IMMEDIATE V_SQL INTO V_EJE_ID;

    FOR I IN V_CUENTAS.FIRST .. V_CUENTAS.LAST
    LOOP
        V_TMP_CUENTA := V_CUENTAS(I);

        DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando si existe el subtipo de gasto '||TRIM(V_TMP_CUENTA(1))||' para la cartera de Sareb y para el año de 2019.');

        V_SQL :=   'SELECT COUNT(1)
                    FROM '||V_ESQUEMA||'.'||V_TABLA||' 
                    WHERE DD_STG_ID = (SELECT DD_STG_ID 
										FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO 
										WHERE DD_STG_DESCRIPCION = '''||TRIM(V_TMP_CUENTA(1))||'''
										AND DD_TGA_ID = (SELECT DD_TGA_ID 
															FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO 
															WHERE DD_TGA_CODIGO = '''||TRIM(V_TMP_CUENTA(6))||'''))
                    AND DD_CRA_ID = '||V_DD_CRA_ID||'
                    AND CCC_CUENTA_CONTABLE = '||TRIM(V_TMP_CUENTA(3))||'
                    AND EJE_ID = '||V_EJE_ID||'
                    AND CCC_ARRENDAMIENTO = '||TRIM(V_TMP_CUENTA(5))||'';

        EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_CUENTA;

        IF V_EXISTE_CUENTA = 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el gasto '||TRIM(V_TMP_CUENTA(1))||' con el nuevo estado "Pendiente autorizar".');

            V_SQL :=    'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
                        (
                              CCC_ID
                            , DD_STG_ID
                            , DD_CRA_ID
                            , VERSION
                            , USUARIOCREAR
                            , FECHACREAR
                            , BORRADO
                            , CCC_CUENTA_CONTABLE
                            , EJE_ID
                            , CCC_ARRENDAMIENTO
                        )
                        VALUES
                        (
                            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL
                            , (SELECT DD_STG_ID 
								FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO 
								WHERE DD_STG_DESCRIPCION = '''||TRIM(V_TMP_CUENTA(1))||''' 
								AND DD_TGA_ID = (SELECT DD_TGA_ID 
												FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO 
												WHERE DD_TGA_CODIGO = '''||TRIM(V_TMP_CUENTA(6))||'''))
                            , '||V_DD_CRA_ID||'
                            , 0
                            , '''||V_USUARIO||'''
                            , SYSDATE
                            , 0
                            , '||TRIM(V_TMP_CUENTA(3))||'
                            , '||V_EJE_ID||'
                            , '||TRIM(V_TMP_CUENTA(5))||'
                        )';

            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] El subtipo de gasto '||TRIM(V_TMP_CUENTA(1))||' ha sido insertado satisfactoriamente.');

        ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el subgasto '||TRIM(V_TMP_CUENTA(1))||' con la cuenta contable '||TRIM(V_TMP_CUENTA(3))||' para el año '||TRIM(V_TMP_CUENTA(5))||'.');
        END IF;

    END LOOP;

	DBMS_OUTPUT.PUT_LINE('[FIN] Finalizado el proceso de inserción de gastos.');
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

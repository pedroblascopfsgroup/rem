--/*
--##########################################
--## AUTOR=Guillermo Llidó
--## FECHA_CREACION=20180717
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1076
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE #ESQUEMA#.SP_CAMBIAR_EST_EXP_RES_OFR
        (  
		  V_NUM_EXPEDIENTE IN VARCHAR2
        , V_ESTADO_EXPEDIENTE IN VARCHAR2
        , V_ESTADO_OFERTA IN VARCHAR2
        , V_ESTADO_RESERVA IN VARCHAR2 
		, V_USUARIO_MODIFICAR IN VARCHAR2
		, V_F_VENTA IN VARCHAR2 
		, V_F_ING_CHEQUE IN VARCHAR2 
		, V_F_FIR_RES IN VARCHAR2 
        , PL_OUTPUT OUT VARCHAR2
    )

   AS

   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_NUM_TABLAS NUMBER(16); -- Variable auxiliar
   USUARIO_CONSULTA_REM VARCHAR2(50 CHAR):= 'REM_QUERY';
   V_AUX NUMBER(16);
   EST_ANT_EXP_COD VARCHAR2(2 CHAR);
   EST_ANT_RES_COD VARCHAR2(2 CHAR);
   EST_ANT_OFR_COD VARCHAR2(2 CHAR);
   FEC_ANT_VENTA DATE;
   FEC_ANT_ING_CHEQUE DATE;
   FEC_ANT_FIR_RES DATE;
   
   ESTADO_EXPEDIENTE VARCHAR2(2 CHAR);
   ESTADO_OFERTA VARCHAR2(2 CHAR);
   ESTADO_RESERVA VARCHAR2(2 CHAR);
   
   VAR_F_VENTA VARCHAR2(50 CHAR);
   VAR_F_ING_CHEQUE VARCHAR2(50 CHAR);
   VAR_F_FIR_RES VARCHAR2(50 CHAR); 
   
   VAR_FEC_ANT_VENTA VARCHAR2(50 CHAR);
   VAR_FEC_ANT_ING_CHEQUE VARCHAR2(50 CHAR);
   VAR_FEC_ANT_FIR_RES VARCHAR2(50 CHAR);
   
   
   
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] '|| CHR(10));

        --Comprobamos que la tansición a realizar es posible.

        IF V_ESTADO_RESERVA = '' THEN
            ESTADO_RESERVA := NULL ;
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TRANS_EST_EXP_OFR_RES TRA
						WHERE DD_EEC_COD = '''||V_ESTADO_EXPEDIENTE||'''
						  AND DD_EOF_COD = '''||V_ESTADO_OFERTA||'''
						  AND DD_ERE_COD = '||ESTADO_RESERVA||'';                        

            PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha modificado la variabla vacia por NULL '|| CHR(10) ;

        ELSE
            ESTADO_RESERVA := V_ESTADO_RESERVA;
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TRANS_EST_EXP_OFR_RES TRA
						WHERE DD_EEC_COD = '''||V_ESTADO_EXPEDIENTE||'''
						  AND DD_EOF_COD = '''||V_ESTADO_OFERTA||'''
						  AND DD_ERE_COD = '''||ESTADO_RESERVA||'''';
        END IF;

        IF V_F_VENTA IS NULL THEN

            VAR_F_VENTA := 'NULL';

        ELSE

            VAR_F_VENTA := 'TO_DATE('''||V_F_VENTA||''',''DD/MM/RR'')';

        END IF;

        IF V_F_ING_CHEQUE IS NULL THEN

            VAR_F_ING_CHEQUE := 'NULL';

        ELSE

            VAR_F_ING_CHEQUE := 'TO_DATE('''||V_F_ING_CHEQUE||''',''DD/MM/RR'')';

        END IF;

        IF V_F_FIR_RES IS NULL THEN

            VAR_F_FIR_RES := 'NULL';

        ELSE

            VAR_F_FIR_RES := 'TO_DATE('''||V_F_FIR_RES||''',''DD/MM/RR'')';

        END IF;

        --                            DBMS_OUTPUT.PUT_LINE(V_SQL);

		EXECUTE IMMEDIATE V_SQL INTO V_AUX;

		IF V_AUX = 1 THEN

			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';

			IF V_AUX = 1 THEN

				-- Estado anterior EXPEDIENTE
				V_SQL := 'SELECT EEC.DD_EEC_CODIGO FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
							INNER JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON ECO.DD_EEC_ID = EEC.DD_EEC_ID AND EEC.BORRADO = 0
							WHERE ECO.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';
--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
				EXECUTE IMMEDIATE V_SQL INTO EST_ANT_EXP_COD;
				-- Estado anterior RESERVA
				V_SQL := 'SELECT NVL2(ERE.DD_ERE_CODIGO,ERE.DD_ERE_CODIGO,NULL) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
							INNER JOIN '||V_ESQUEMA||'.RES_RESERVAS RES ON ECO.ECO_ID = RES.ECO_ID AND RES.BORRADO = 0
							LEFT JOIN '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ERE ON ERE.DD_ERE_ID = RES.DD_ERE_ID AND ERE.BORRADO = 0
							WHERE ECO.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';
--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL INTO EST_ANT_RES_COD;
				-- Estado anterior OFERTA
				V_SQL := 'SELECT EOF.DD_EOF_CODIGO  FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
							INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID AND OFR.BORRADO = 0
							INNER JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID AND EOF.BORRADO = 0
							WHERE ECO.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';
--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL INTO EST_ANT_OFR_COD;
				-- FECHA VENTA anterior
				V_SQL := 'SELECT NVL2(ECO.ECO_FECHA_VENTA,ECO.ECO_FECHA_VENTA, NULL)  FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO WHERE ECO.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';
--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL INTO FEC_ANT_VENTA;

                IF FEC_ANT_VENTA IS NULL THEN
                    VAR_FEC_ANT_VENTA := 'NULL';
                ELSE
                    VAR_FEC_ANT_VENTA := 'TO_DATE('''||FEC_ANT_VENTA||''',''DD/MM/RR'')';
                END IF;

            	-- FECHA INGRESO CHEQUE anterior
				V_SQL := 'SELECT NVL2(ECO.ECO_FECHA_CONT_PROPIETARIO,ECO.ECO_FECHA_CONT_PROPIETARIO, NULL) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO WHERE ECO.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';
--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL INTO FEC_ANT_ING_CHEQUE;

                IF FEC_ANT_ING_CHEQUE IS NULL THEN
                    VAR_FEC_ANT_ING_CHEQUE := 'NULL';
                ELSE
                    VAR_FEC_ANT_ING_CHEQUE := 'TO_DATE('''||FEC_ANT_ING_CHEQUE||''',''DD/MM/RR'')';
                END IF;

                -- FECHA FIRMA DE LA RESERVA anterior
				V_SQL := 'SELECT NVL2(RES.RES_FECHA_FIRMA,TO_DATE(RES.RES_FECHA_FIRMA,''DD/MM/RR''), NULL) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
							INNER JOIN '||V_ESQUEMA||'.RES_RESERVAS RES ON RES.ECO_ID = ECO.ECO_ID AND RES.BORRADO = 0
							WHERE ECO.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';
--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL INTO FEC_ANT_FIR_RES;

                IF FEC_ANT_FIR_RES IS NULL THEN
                    VAR_FEC_ANT_FIR_RES := 'NULL';
                ELSE
                    VAR_FEC_ANT_FIR_RES := 'TO_DATE('''||FEC_ANT_FIR_RES||''',''DD/MM/RR'')';
                END IF;

	-- Aqui va el insert a la tabla de históricos para evitar fallos por parte del usuario.

				V_SQL := 'INSERT INTO '||V_ESQUEMA||'.H_TRANS_EST_EOR (
							  H_TRANS_EST_EOR_ID
							, ECO_NUM_EXPEDIENTE
							, DD_EOF_COD_ANT
							, DD_EOF_DES_ANT
							, DD_EEC_COD_ANT
							, DD_EEC_DES_ANT
							, DD_ERE_COD_ANT
							, DD_ERE_DES_ANT
							, DD_EOF_COD_POST
							, DD_EOF_DES_POST
							, DD_EEC_COD_POST
							, DD_EEC_DES_POST
							, DD_ERE_COD_POST
							, DD_ERE_DES_POST
							, FECHA_VENTA_ANT
							, FECHA_VENTA_POST
							, FECHA_ING_CHEQUE_ANT
							, FECHA_ING_CHEQUE_POST
							, FECHA_FIR_RES_ANT
							, FECHA_FIR_RES_POST
							, VERSION
							, USUARIOCREAR
							, FECHACREAR
							, BORRADO
							) VALUES (
							  S_H_TRANS_EST_EOR.NEXTVAL
							, '||V_NUM_EXPEDIENTE||'
							, '''||EST_ANT_OFR_COD||'''
							, (SELECT DD_EOF_DESCRIPCION FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO ='''||EST_ANT_OFR_COD||''')
							, '''||EST_ANT_EXP_COD||'''
							, (SELECT DD_EEC_DESCRIPCION FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = '''||EST_ANT_EXP_COD||''')
							, '''||EST_ANT_RES_COD||'''
							, (SELECT DD_ERE_DESCRIPCION FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = '''||EST_ANT_RES_COD||''')
							, '''||V_ESTADO_OFERTA||'''
							, (SELECT DD_EOF_DESCRIPCION FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '''||V_ESTADO_OFERTA||''')
							, '''||V_ESTADO_EXPEDIENTE||'''
							, (SELECT DD_EEC_DESCRIPCION FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = '''||V_ESTADO_EXPEDIENTE||''')
							, '''||V_ESTADO_RESERVA||'''
							, (SELECT DD_ERE_DESCRIPCION FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = '''||V_ESTADO_RESERVA||''')
							, '||VAR_FEC_ANT_VENTA||'
							, '||VAR_F_VENTA||'
							, '||VAR_FEC_ANT_ING_CHEQUE||'
							, '||VAR_F_ING_CHEQUE||'
							, '||VAR_FEC_ANT_FIR_RES||'
							, '||VAR_F_FIR_RES||'
							, 0
							,'''||V_USUARIO_MODIFICAR||'''
							, SYSDATE
							, 0
							)';
--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL;

				CASE

				-- 1 Si se intenta cambiar el estado de la reserva en un expediente anulado.
				WHEN EST_ANT_EXP_COD = '02' AND  V_ESTADO_EXPEDIENTE = '02' AND (V_ESTADO_RESERVA = '06' OR V_ESTADO_RESERVA = '07' OR V_ESTADO_RESERVA = '08') THEN


					IF V_F_FIR_RES IS NOT NULL THEN

						-- Actualizar estado expediente
						V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
									SET ECO.DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = '''||V_ESTADO_EXPEDIENTE||''')
									   ,ECO.ECO_FECHA_VENTA = NULL
									   ,ECO.ECO_FECHA_CONT_PROPIETARIO = NULL
									   ,ECO.USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,ECO.FECHAMODIFICAR = SYSDATE
									WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
						EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado del EXPEDIENTE '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado oferta
						V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS OFR
									SET DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = '''||V_ESTADO_OFERTA||''')
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE OFR.OFR_ID = (
												SELECT OFR.OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
													INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
													WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
						EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la OFERTA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado reserva
						V_SQL := 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS RES
									SET RES.DD_ERE_ID = (SELECT ERE.DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ERE WHERE ERE.DD_ERE_CODIGO = '''||V_ESTADO_RESERVA||''')
									   ,RES_FECHA_FIRMA = TRIM(TO_DATE('''||V_F_FIR_RES||''',''DD/MM/RR''))
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE RES.RES_ID = (SELECT RES.RES_ID FROM '||V_ESQUEMA||'.RES_RESERVAS RES
															INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = RES.ECO_ID AND ECO.BORRADO = 0
															WHERE RES.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la RESERVA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

					ELSE IF FEC_ANT_FIR_RES IS NOT NULL AND V_F_FIR_RES IS NULL THEN

						-- Actualizar estado expediente
						V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
									SET ECO.DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = '''||V_ESTADO_EXPEDIENTE||''')
									   ,ECO.ECO_FECHA_VENTA = NULL
									   ,ECO.ECO_FECHA_CONT_PROPIETARIO = NULL
									   ,ECO.USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,ECO.FECHAMODIFICAR = SYSDATE
									WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado del EXPEDIENTE '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado oferta
						V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS OFR
									SET DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = '''||V_ESTADO_OFERTA||''')
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE OFR.OFR_ID = (
												SELECT OFR.OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
													INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
													WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la OFERTA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado reserva
						V_SQL := 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS RES
									SET RES.DD_ERE_ID = (SELECT ERE.DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ERE WHERE ERE.DD_ERE_CODIGO = '''||V_ESTADO_RESERVA||''')
									   ,RES_FECHA_FIRMA = TRIM(TO_DATE('''||FEC_ANT_FIR_RES||''',''DD/MM/RR''))
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE RES.RES_ID = (SELECT RES.RES_ID FROM '||V_ESQUEMA||'.RES_RESERVAS RES
															INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = RES.ECO_ID AND ECO.BORRADO = 0
															WHERE RES.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la RESERVA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

					ELSE

						PL_OUTPUT := PL_OUTPUT ||'[ERROR] No se puede pasar a este estado sin FECHA FIRMA DE LA RESERVA '|| CHR(10);

					END IF;
					END IF;

				-- Pasar Estado expediente a "Firmado" - "Bloqueo Adm." - "Reservado" - "En devolución"
				WHEN EST_ANT_EXP_COD != '02' AND (V_ESTADO_EXPEDIENTE = '03' OR V_ESTADO_EXPEDIENTE = '05' OR V_ESTADO_EXPEDIENTE = '06' OR V_ESTADO_EXPEDIENTE = '16')
					 AND (V_F_FIR_RES IS NOT NULL OR FEC_ANT_FIR_RES IS NOT NULL) THEN

					IF V_F_FIR_RES IS NOT NULL THEN

						-- Actualizar estado expediente
						V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
									SET DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = '''||V_ESTADO_EXPEDIENTE||''')
									   ,ECO.ECO_FECHA_VENTA = NULL
									   ,ECO.ECO_FECHA_CONT_PROPIETARIO = NULL
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado del EXPEDIENTE '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado oferta
						V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS OFR
									SET DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = '''||V_ESTADO_OFERTA||''')
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE OFR.OFR_ID = (
												SELECT OFR.OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
													INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
													WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la OFERTA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado reserva
						V_SQL := 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS RES
									SET RES.DD_ERE_ID = (SELECT ERE.DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ERE WHERE ERE.DD_ERE_CODIGO = '''||V_ESTADO_RESERVA||''')
									   ,RES_FECHA_FIRMA = TRIM(TO_DATE('''||V_F_FIR_RES||''',''DD/MM/RR''))
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE RES.RES_ID = (SELECT RES.RES_ID FROM '||V_ESQUEMA||'.RES_RESERVAS RES
															INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = RES.ECO_ID AND ECO.BORRADO = 0
															WHERE RES.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la RESERVA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

					ELSE IF FEC_ANT_FIR_RES IS NOT NULL AND V_F_FIR_RES IS NULL THEN

						-- Actualizar estado expediente
						V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
									SET DD_EEC_ID =  '''||V_ESTADO_EXPEDIENTE||'''
									   ,ECO.ECO_FECHA_VENTA = NULL
									   ,ECO.ECO_FECHA_CONT_PROPIETARIO = NULL
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado del EXPEDIENTE '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado oferta
						V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS OFR
									SET DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = '''||V_ESTADO_OFERTA||''')
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE OFR.OFR_ID = (
												SELECT OFR.OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
													INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
													WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la OFERTA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado reserva
						V_SQL := 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS RES
									SET RES.DD_ERE_ID = (SELECT ERE.DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ERE WHERE ERE.DD_ERE_CODIGO = '''||V_ESTADO_RESERVA||''')
									   ,RES_FECHA_FIRMA = TRIM(TO_DATE('''||FEC_ANT_FIR_RES||''',''DD/MM/RR''))
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE RES.RES_ID = (SELECT RES.RES_ID FROM '||V_ESQUEMA||'.RES_RESERVAS RES
															INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = RES.ECO_ID AND ECO.BORRADO = 0
															WHERE RES.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
						EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la RESERVA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;


					ELSE

						PL_OUTPUT := PL_OUTPUT ||'[ERROR] No se puede pasar a este estado sin FECHA FIRMA DE LA RESERVA '|| CHR(10);

					END IF;
					END IF;

				-- Pasar Estado expediente a "En tramitación" - "Contraofertado" - "Pte. Sanción" - "Aprobado"
				WHEN EST_ANT_EXP_COD != '02' AND (V_ESTADO_EXPEDIENTE = '01' OR V_ESTADO_EXPEDIENTE = '04' OR V_ESTADO_EXPEDIENTE = '10' OR V_ESTADO_EXPEDIENTE = '11') THEN

					IF V_ESTADO_RESERVA IS NOT NULL THEN

					-- Actualizar estado expediente
						V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
									SET DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = '''||V_ESTADO_EXPEDIENTE||''')
									   ,ECO.ECO_FECHA_VENTA = NULL
									   ,ECO.ECO_FECHA_CONT_PROPIETARIO = NULL
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado del EXPEDIENTE '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado oferta
						V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS OFR
									SET DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = '''||V_ESTADO_OFERTA||''')
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE OFR.OFR_ID = (
												SELECT OFR.OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
													INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
													WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'

                                                        )';
--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la OFERTA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado reserva
						V_SQL := 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS RES
									SET RES.DD_ERE_ID = (SELECT ERE.DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ERE WHERE ERE.DD_ERE_CODIGO = '''||V_ESTADO_RESERVA||''')
									   ,RES_FECHA_FIRMA = NULL
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE RES.RES_ID = (SELECT RES.RES_ID FROM '||V_ESQUEMA||'.RES_RESERVAS RES
															INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = RES.ECO_ID AND ECO.BORRADO = 0
															WHERE RES.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la RESERVA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

					ELSE

						-- Actualizar estado expediente
						V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
									SET DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = '''||V_ESTADO_EXPEDIENTE||''')
									   ,ECO.ECO_FECHA_VENTA = NULL
									   ,ECO.ECO_FECHA_CONT_PROPIETARIO = NULL
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado del EXPEDIENTE '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado oferta
						V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS OFR
									SET DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = '''||V_ESTADO_OFERTA||''')
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE OFR.OFR_ID = (
												SELECT OFR.OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
													INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
													WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la OFERTA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado reserva
						V_SQL := 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS RES
									SET RES.DD_ERE_ID = NULL
									   ,RES_FECHA_FIRMA = NULL
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE RES.RES_ID = (SELECT RES.RES_ID FROM '||V_ESQUEMA||'.RES_RESERVAS RES
															INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = RES.ECO_ID AND ECO.BORRADO = 0
															WHERE RES.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la RESERVA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

                    END IF;

				-- Estado expediente a "Vendido"
				WHEN EST_ANT_EXP_COD != '02' AND V_ESTADO_EXPEDIENTE = '08' AND (V_F_ING_CHEQUE IS NOT NULL OR FEC_ANT_ING_CHEQUE IS NOT NULL) AND (V_F_VENTA IS NOT NULL OR FEC_ANT_VENTA IS NOT NULL)THEN

					IF V_F_FIR_RES IS NOT NULL AND V_ESTADO_RESERVA IS NOT NULL THEN

						-- Actualizar estado expediente
						V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
									SET DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = '''||V_ESTADO_EXPEDIENTE||''')
									   ,ECO.ECO_FECHA_VENTA = TRIM(TO_DATE('''||V_F_VENTA||''',''DD/MM/RR''))
									   ,ECO.ECO_FECHA_CONT_PROPIETARIO = TRIM(TO_DATE('''||V_F_ING_CHEQUE||''',''DD/MM/RR''))
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado del EXPEDIENTE '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado oferta
						V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS OFR
									SET DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = '''||V_ESTADO_OFERTA||''')
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE OFR.OFR_ID = (
												SELECT OFR.OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
													INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
													WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la OFERTA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado reserva
						V_SQL := 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS RES
									SET RES.DD_ERE_ID = (SELECT ERE.DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ERE WHERE ERE.DD_ERE_CODIGO = '''||V_ESTADO_RESERVA||''')
									   ,RES_FECHA_FIRMA = TRIM(TO_DATE('''||V_F_FIR_RES||''',''DD/MM/RR''))
									   ,USUARIOMODIFICAR = TRIM(TO_DATE('''||V_USUARIO_MODIFICAR||''',''DD/MM/RR''))
									   ,FECHAMODIFICAR = SYSDATE
									WHERE RES.RES_ID = (SELECT RES.RES_ID FROM '||V_ESQUEMA||'.RES_RESERVAS RES
															INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = RES.ECO_ID AND ECO.BORRADO = 0
															WHERE RES.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la RESERVA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

					ELSE IF V_F_FIR_RES IS NULL AND FEC_ANT_FIR_RES IS NOT NULL AND V_ESTADO_RESERVA IS NOT NULL THEN

						-- Actualizar estado expediente
						V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
									SET DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = '''||V_ESTADO_EXPEDIENTE||''')
									   ,ECO.ECO_FECHA_VENTA = TRIM(TO_DATE('''||V_F_VENTA||''',''DD/MM/RR''))
									   ,ECO.ECO_FECHA_CONT_PROPIETARIO = TRIM(TO_DATE('''||V_F_ING_CHEQUE||''',''DD/MM/RR''))
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado del EXPEDIENTE '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado oferta
						V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS OFR
									SET DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = '''||V_ESTADO_OFERTA||''')
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE OFR.OFR_ID = (
												SELECT OFR.OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
													INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
													WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la OFERTA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado reserva
						V_SQL := 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS RES
									SET RES.DD_ERE_ID = (SELECT ERE.DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ERE WHERE ERE.DD_ERE_CODIGO = '''||V_ESTADO_RESERVA||''')
									   ,RES_FECHA_FIRMA = TRIM(TO_DATE('''||FEC_ANT_FIR_RES||''',''DD/MM/RR''))
									   ,USUARIOMODIFICAR = TRIM(TO_DATE('''||V_USUARIO_MODIFICAR||''',''DD/MM/RR''))
									   ,FECHAMODIFICAR = SYSDATE
									WHERE RES.RES_ID = (SELECT RES.RES_ID FROM '||V_ESQUEMA||'.RES_RESERVAS RES
															INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = RES.ECO_ID AND ECO.BORRADO = 0
															WHERE RES.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la RESERVA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

					ELSE IF V_F_FIR_RES IS NOT NULL AND V_ESTADO_RESERVA IS NULL THEN

						-- Actualizar estado expediente
						V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
									SET DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = '''||V_ESTADO_EXPEDIENTE||''')
									   ,ECO.ECO_FECHA_VENTA = TRIM(TO_DATE('''||V_F_VENTA||''',''DD/MM/RR''))
									   ,ECO.ECO_FECHA_CONT_PROPIETARIO = TRIM(TO_DATE('''||V_F_ING_CHEQUE||''',''DD/MM/RR''))
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado del EXPEDIENTE '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado oferta
						V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS OFR
									SET DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = '''||V_ESTADO_OFERTA||''')
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE OFR.OFR_ID = (
												SELECT OFR.OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
													INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
													WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la OFERTA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado reserva
						V_SQL := 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS RES
									SET RES.DD_ERE_ID = NULL
									   ,RES_FECHA_FIRMA = TRIM(TO_DATE('''||V_F_FIR_RES||''',''DD/MM/RR''))
									   ,USUARIOMODIFICAR = TRIM(TO_DATE('''||V_USUARIO_MODIFICAR||''',''DD/MM/RR''))
									   ,FECHAMODIFICAR = SYSDATE
									WHERE RES.RES_ID = (SELECT RES.RES_ID FROM '||V_ESQUEMA||'.RES_RESERVAS RES
															INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = RES.ECO_ID AND ECO.BORRADO = 0
															WHERE RES.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la RESERVA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

					ELSE IF V_F_FIR_RES IS NULL AND FEC_ANT_FIR_RES IS NOT NULL AND V_ESTADO_RESERVA IS NULL THEN

						-- Actualizar estado expediente
						V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
									SET DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = '''||V_ESTADO_EXPEDIENTE||''')
									   ,ECO.ECO_FECHA_VENTA = TRIM(TO_DATE('''||V_F_VENTA||''',''DD/MM/RR''))
									   ,ECO.ECO_FECHA_CONT_PROPIETARIO = TRIM(TO_DATE('''||V_F_ING_CHEQUE||''',''DD/MM/RR''))
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado del EXPEDIENTE '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado oferta
						V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS OFR
									SET DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = '''||V_ESTADO_OFERTA||''')
									   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
									   ,FECHAMODIFICAR = SYSDATE
									WHERE OFR.OFR_ID = (
												SELECT OFR.OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
													INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
													WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la OFERTA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

						-- Actualizar estado reserva
						V_SQL := 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS RES
									SET RES.DD_ERE_ID = NULL
									   ,RES_FECHA_FIRMA = TRIM(TO_DATE('''||FEC_ANT_FIR_RES||''',''DD/MM/RR''))
									   ,USUARIOMODIFICAR = TRIM(TO_DATE('''||V_USUARIO_MODIFICAR||''',''DD/MM/RR''))
									   ,FECHAMODIFICAR = SYSDATE
									WHERE RES.RES_ID = (SELECT RES.RES_ID FROM '||V_ESQUEMA||'.RES_RESERVAS RES
															INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = RES.ECO_ID AND ECO.BORRADO = 0
															WHERE RES.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
														)';

--                            DBMS_OUTPUT.PUT_LINE(V_SQL);
                        EXECUTE IMMEDIATE V_SQL;

						PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la RESERVA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;


					ELSE

						PL_OUTPUT := PL_OUTPUT ||'[ERROR] No se puede pasar a vendido porque falta algún parámetro '|| CHR(10);

					END IF;
					END IF;
                    END IF;
                    END IF;

				ELSE

					PL_OUTPUT := PL_OUTPUT ||'[ERROR] No se puede revivir un expediente Anulado '|| CHR(10);

				END CASE;

			ELSE

				PL_OUTPUT := PL_OUTPUT ||'[ERROR] El expediente '||V_NUM_EXPEDIENTE||' no existe '|| CHR(10);

			END IF;

		ELSE

			PL_OUTPUT := PL_OUTPUT ||'[ERROR] La Transición no ha sido posible porque no existe el registro en la tabla TRANS_EST_EXP_OFR_RES'|| CHR(10);

		END IF;

    COMMIT;

    PL_OUTPUT := PL_OUTPUT ||'[FIN] Ha finalizado el proceso relacionado con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END SP_CAMBIAR_EST_EXP_RES_OFR;
/
EXIT


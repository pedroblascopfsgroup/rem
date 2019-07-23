--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190715
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3831
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir a los gestores que se pueden agregar a los activos/expedientes/agrupaciones por carga masiva.
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3831';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

	
	V_EXISTE_REGISTRO NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.

    TYPE T_GESTOR IS TABLE OF VARCHAR2(1000);

    TYPE T_ARRAY_GESTOR IS TABLE OF T_GESTOR;
    V_GESTOR T_ARRAY_GESTOR := T_ARRAY_GESTOR(
        
	-- Andalucía:
        T_GESTOR( '4', 'gsantos', 'GFORM' ),
        T_GESTOR( '4', 'jcarbonellm', 'GFORM' ),
        T_GESTOR( '4', 'garsa03', 'GIAFORM' ),

        T_GESTOR( '11', 'gsantos', 'GFORM'),
        T_GESTOR( '11', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '11', 'garsa03', 'GIAFORM'),

        T_GESTOR( '14', 'gsantos', 'GFORM'),
        T_GESTOR( '14', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '14', 'garsa03', 'GIAFORM'),

        T_GESTOR( '18', 'gsantos', 'GFORM'),
        T_GESTOR( '18', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '18', 'garsa03', 'GIAFORM'),

        T_GESTOR( '21', 'gsantos', 'GFORM'),
        T_GESTOR( '21', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '21', 'garsa03', 'GIAFORM'),

        T_GESTOR( '23', 'gsantos', 'GFORM'),
        T_GESTOR( '23', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '23', 'garsa03', 'GIAFORM'),

        T_GESTOR( '29', 'gsantos', 'GFORM'),
        T_GESTOR( '29', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '29', 'garsa03', 'GIAFORM'),

        T_GESTOR( '41', 'gsantos', 'GFORM'),
        T_GESTOR( '41', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '41', 'garsa03', 'GIAFORM'),

	-- Aragón
        T_GESTOR( '22', 'nrivilla', 'GFORM'),
        T_GESTOR( '22', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '22', 'garsa03', 'GIAFORM'),

        T_GESTOR( '44', 'nrivilla', 'GFORM'),
        T_GESTOR( '44', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '44', 'garsa03', 'GIAFORM'),

        T_GESTOR( '50', 'nrivilla', 'GFORM'),
        T_GESTOR( '50', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '50', 'garsa03', 'GIAFORM'),

	-- Asturias
        T_GESTOR( '33', 'gsantos', 'GFORM'),
        T_GESTOR( '33', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '33', 'garsa03', 'GIAFORM'),

	-- Canarias
        T_GESTOR( '35', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '35', 'garsa03', 'GIAFORM'),

        T_GESTOR( '38', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '38', 'garsa03', 'GIAFORM'),

	-- Cantabria
        T_GESTOR( '39', 'cmartinez', 'GFORM'),
        T_GESTOR( '39', 'nrivilla', 'GFORM'),
        T_GESTOR( '39', 'garsa03', 'GIAFORM'),


	-- Castilla La Mancha
        T_GESTOR( '45', 'cmartinez', 'GFORM'),
        T_GESTOR( '45', 'alopezf', 'GFORM'),
        T_GESTOR( '45', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '45', 'nrivilla', 'GFORM'),
        T_GESTOR( '45', 'gsantos', 'GFORM'),
        T_GESTOR( '45', 'garsa03', 'GIAFORM'),

        T_GESTOR( '2', 'cmartinez', 'GFORM'),
        T_GESTOR( '2', 'alopezf', 'GFORM'),
        T_GESTOR( '2', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '2', 'nrivilla', 'GFORM'),
        T_GESTOR( '2', 'gsantos', 'GFORM'),
        T_GESTOR( '2', 'garsa03', 'GIAFORM'),

        T_GESTOR( '13', 'cmartinez', 'GFORM'),
        T_GESTOR( '13', 'alopezf', 'GFORM'),
        T_GESTOR( '13', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '13', 'nrivilla', 'GFORM'),
        T_GESTOR( '13', 'gsantos', 'GFORM'),
        T_GESTOR( '13', 'pinos03', 'GIAFORM'),

        T_GESTOR( '16', 'cmartinez', 'GFORM'),
        T_GESTOR( '16', 'alopezf', 'GFORM'),
        T_GESTOR( '16', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '16', 'nrivilla', 'GFORM'),
        T_GESTOR( '16', 'gsantos', 'GFORM'),
        T_GESTOR( '16', 'garsa03', 'GIAFORM'),

        T_GESTOR( '19', 'cmartinez', 'GFORM'),
        T_GESTOR( '19', 'alopezf', 'GFORM'),
        T_GESTOR( '19', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '19', 'nrivilla', 'GFORM'),
        T_GESTOR( '19', 'gsantos', 'GFORM'),
        T_GESTOR( '19', 'pinos03', 'GIAFORM'),

	-- Castilla León
        T_GESTOR( '5', 'gsantos', 'GFORM'),
        T_GESTOR( '5', 'alopezf', 'GFORM'),
        T_GESTOR( '5', 'garsa03', 'GIAFORM'),

        T_GESTOR( '9', 'gsantos', 'GFORM'),
        T_GESTOR( '9', 'alopezf', 'GFORM'),
        T_GESTOR( '9', 'garsa03', 'GIAFORM'),

        T_GESTOR( '24', 'gsantos', 'GFORM'),
        T_GESTOR( '24', 'alopezf', 'GFORM'),
        T_GESTOR( '24', 'garsa03', 'GIAFORM'),

        T_GESTOR( '34', 'gsantos', 'GFORM'),
        T_GESTOR( '34', 'alopezf', 'GFORM'),
        T_GESTOR( '34', 'garsa03', 'GIAFORM'),

        T_GESTOR( '37', 'gsantos', 'GFORM'),
        T_GESTOR( '37', 'alopezf', 'GFORM'),
        T_GESTOR( '37', 'garsa03', 'GIAFORM'),

        T_GESTOR( '47', 'gsantos', 'GFORM'),
        T_GESTOR( '47', 'alopezf', 'GFORM'),
        T_GESTOR( '47', 'garsa03', 'GIAFORM'),

        T_GESTOR( '49', 'gsantos', 'GFORM'),
        T_GESTOR( '49', 'alopezf', 'GFORM'),
        T_GESTOR( '49', 'garsa03', 'GIAFORM'),

	--Cataluña
        T_GESTOR( '8', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '8', 'nrivilla', 'GFORM'),
        T_GESTOR( '8', 'garsa03', 'GIAFORM'),

        T_GESTOR( '17', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '17', 'nrivilla', 'GFORM'),
        T_GESTOR( '17', 'garsa03', 'GIAFORM'),

        T_GESTOR( '25', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '25', 'nrivilla', 'GFORM'),
        T_GESTOR( '25', 'garsa03', 'GIAFORM'),

        T_GESTOR( '43', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '43', 'nrivilla', 'GFORM'),
        T_GESTOR( '43', 'garsa03', 'GIAFORM'),

	--Comunidad Valenciana
        T_GESTOR( '3', 'cmartinez', 'GFORM'),
        T_GESTOR( '3', 'alopezf', 'GFORM'),
        T_GESTOR( '3', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '3', 'nrivilla', 'GFORM'),
        T_GESTOR( '3', 'garsa03', 'GIAFORM'),

        T_GESTOR( '12', 'cmartinez', 'GFORM'),
        T_GESTOR( '12', 'alopezf', 'GFORM'),
        T_GESTOR( '12', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '12', 'nrivilla', 'GFORM'),
        T_GESTOR( '12', 'garsa03', 'GIAFORM'),

        T_GESTOR( '46', 'cmartinez', 'GFORM'),
        T_GESTOR( '46', 'alopezf', 'GFORM'),
        T_GESTOR( '46', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '46', 'nrivilla', 'GFORM'),
        T_GESTOR( '46', 'garsa03', 'GIAFORM'),

	-- Extremadura
        T_GESTOR( '6', 'cmartinez', 'GFORM'),
        T_GESTOR( '6', 'gsantos', 'GFORM'),
        T_GESTOR( '6', 'garsa03', 'GIAFORM'),

        T_GESTOR( '10', 'cmartinez', 'GFORM'),
        T_GESTOR( '10', 'gsantos', 'GFORM'),
        T_GESTOR( '10', 'garsa03', 'GIAFORM'),

	--Galícia
        T_GESTOR( '15', 'gsantos', 'GFORM'),
        T_GESTOR( '15', 'garsa03', 'GIAFORM'),

        T_GESTOR( '27', 'gsantos', 'GFORM'),
        T_GESTOR( '27', 'garsa03', 'GIAFORM'),

        T_GESTOR( '32', 'gsantos', 'GFORM'),
        T_GESTOR( '32', 'garsa03', 'GIAFORM'),

        T_GESTOR( '36', 'gsantos', 'GFORM'),
        T_GESTOR( '36', 'garsa03', 'GIAFORM'),

	--Comunidad Madrid
        T_GESTOR( '28', 'cmartinez', 'GFORM'),
        T_GESTOR( '28', 'alopezf', 'GFORM'),
        T_GESTOR( '28', 'pinos03', 'GIAFORM'),

	--Murcia
        T_GESTOR( '30', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '30', 'gsantos', 'GFORM'),
        T_GESTOR( '30', 'pinos03', 'GIAFORM'),

	--Pais Vasco
        T_GESTOR( '1', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '1', 'garsa03', 'GIAFORM'),

        T_GESTOR( '48', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '48', 'garsa03', 'GIAFORM'),

	--La Rioja
        T_GESTOR( '26', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '26', 'garsa03', 'GIAFORM'),

	--Baleares
        T_GESTOR( '7', 'nrivilla', 'GFORM'),
        T_GESTOR( '7', 'garsa03', 'GIAFORM'),

	--Navarra
        T_GESTOR( '31', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '31', 'garsa03', 'GIAFORM'),

	--Ceuta
        T_GESTOR( '51', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '51', 'garsa03', 'GIAFORM'),

	--Melilla
        T_GESTOR( '52', 'jcarbonellm', 'GFORM'),
        T_GESTOR( '52', 'garsa03', 'GIAFORM')

    );
    V_TMP_GESTOR T_GESTOR;

BEGIN

   	
    DBMS_OUTPUT.PUT_LINE('[INICIO] Haciendo comprobaciones previas... ');
    V_SQL := ' DELETE FROM '||V_ESQUEMA||'.AUX_REMVIP_4803 '; 	
    EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se inserta en tabla auxiliar la configuración de gestores');
    FOR I IN V_GESTOR.FIRST .. V_GESTOR.LAST
    LOOP
        V_TMP_GESTOR := V_GESTOR(I);

		V_SQL :=   ' INSERT INTO '||V_ESQUEMA||'.AUX_REMVIP_4803
			     ( COD_PROVINCIA, TIPO_GESTOR, USERNAME )
			     VALUES
			     ( '   || V_TMP_GESTOR( 1 ) || ',
			       ''' || V_TMP_GESTOR( 3 ) || ''',		 	
			       ''' || V_TMP_GESTOR( 2 ) || '''		 	
			     ) ';	
  
	EXECUTE IMMEDIATE V_SQL;



    END LOOP;        

    DBMS_OUTPUT.PUT_LINE('[INFO] Registros insertados en tabla auxiliar');

    DBMS_OUTPUT.PUT_LINE('[INFO] Se borran los gestores incorrectos');
    V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES GES
	       SET BORRADO = 1,
		   USUARIOBORRAR = ''REMVIP-4803'',
		   FECHABORRAR   = SYSDATE 	
	       WHERE BORRADO = 0
	       AND COD_CARTERA = 8	
	       AND TIPO_GESTOR IN ( ''GFORM'', ''GIAFORM'' )
	       AND NOT EXISTS ( SELECT 1
				FROM '||V_ESQUEMA||'.AUX_REMVIP_4803 AUX
				WHERE 1 = 1
				AND AUX.COD_PROVINCIA = GES.COD_PROVINCIA
				AND AUX.TIPO_GESTOR = GES.TIPO_GESTOR
				AND AUX.USERNAME = GES.USERNAME
			      )				      		
	     '	;

        EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Realizado borrado lógico de  '||SQL%ROWCOUNT||' gestores incorrectos');


    V_SQL := ' MERGE INTO '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES GES
		USING (
			SELECT COD_PROVINCIA, TIPO_GESTOR, USERNAME
			FROM '||V_ESQUEMA||'.AUX_REMVIP_4803
		      ) AUX
		ON (     AUX.COD_PROVINCIA = GES.COD_PROVINCIA
		     AND AUX.TIPO_GESTOR = GES.TIPO_GESTOR
		     AND AUX.USERNAME = GES.USERNAME 
		     AND GES.COD_CARTERA = 8 ) 	
		WHEN NOT MATCHED THEN 
		INSERT ( ID,
			 TIPO_GESTOR,
			 COD_CARTERA,
			 COD_PROVINCIA,
			 USERNAME,
			 NOMBRE_USUARIO,
			 VERSION,
			 USUARIOCREAR,
			 FECHACREAR,
			 BORRADO )
		 VALUES
			( S_ACT_GES_DIST_GESTORES.NEXTVAL,
			  AUX.TIPO_GESTOR,
			  8,
			  AUX.COD_PROVINCIA,
			  AUX.USERNAME,
			  ( SELECT USU_NOMBRE FROM REMMASTER.USU_USUARIOS WHERE USU_USERNAME = AUX.USERNAME ),
			  0,
			  ''REMVIP-4803'',
			  SYSDATE,
			  0 )
	     '	;

        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[FIN] Finalizado el proceso de configuración de gestores');
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

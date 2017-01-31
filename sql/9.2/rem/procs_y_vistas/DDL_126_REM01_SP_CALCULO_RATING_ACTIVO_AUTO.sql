--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20170124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1333
--## PRODUCTO=NO
--## Finalidad: Actualiza el rating del activo (pasado por parametro) o activos (si no se pasa ninguno por parametro)
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
create or replace PROCEDURE CALCULO_RATING_ACTIVO_AUTO (
   p_act_id       	IN #ESQUEMA#.act_activo.act_id%TYPE,
   p_username     	IN #ESQUEMA#.act_activo.usuariomodificar%TYPE
)
AUTHID CURRENT_USER IS
       
	-- Definición de cursores
	-- Recupera el codigo y el valor de los criterios de puntuación
   	CURSOR crs_criterios_puntuacion
   	IS
      	SELECT cpu.cpu_codigo, cpu.cpu_valor
        	FROM #ESQUEMA#.cpu_criterio_puntuacion_act cpu;
    
	-- Recupera los datos de rating que tiene el activo para calcular la puntuacion
	CURSOR crs_datos_rating_activo(p_act_id #ESQUEMA#.act_activo.act_id%TYPE)
	IS
		SELECT v.*
			FROM #ESQUEMA#.v_datos_rating_activos v
			WHERE act_id = p_act_id;
	
	-- Recupera el valor mínimo por tramo y su id rating correspondiente
	CURSOR crs_tramos_rating
	IS
		SELECT tpr_valor_desde, dd_rtg_id
			FROM #ESQUEMA#.tpr_tramo_puntuacion_rating
			ORDER BY tpr_valor_desde DESC;

	
	-- Declaración de variables
   	v_dd_rtg_id                  	#ESQUEMA#.dd_rtg_rating_activo.dd_rtg_id%TYPE;
   	v_tramos_puntuacion				crs_tramos_rating%ROWTYPE;		
	v_total_entorno      			NUMBER;
	v_total_edificio				NUMBER;
	v_total_interior				NUMBER;
	v_total							NUMBER;
	v_act_id 						NUMBER(16);
	v_username						#ESQUEMA#.act_activo.usuariomodificar%TYPE;
   	
   	TYPE criterio_valor_map IS TABLE OF NUMBER INDEX BY VARCHAR2(30);
	criterio_valor criterio_valor_map;
	TYPE ACTIVOS_REF IS REF CURSOR;
	crs_activos ACTIVOS_REF;
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	-- Si no viene informado el username, asignamos el de este procedure
	v_username := p_username;
	IF(p_username IS NULL) THEN
		v_username := 'SP_CALCULO_RATING';
	END IF;
	
   -- Guardamos en una colección el criterio y su valor de las puntuaciones
 	FOR row IN crs_criterios_puntuacion
      LOOP
         criterio_valor(row.cpu_codigo) := row.cpu_valor;
      END LOOP;
    
    -- Abriremos un cursor u otro, dependiendo si el parametro de entrada p_act_id viene informado
	IF(p_act_id IS NULL) THEN
		OPEN crs_activos FOR        			
   		 SELECT DISTINCT act.act_id
			FROM #ESQUEMA#.act_activo act 
			INNER JOIN #ESQUEMA#.act_ico_info_comercial ico on act.act_id = ico.act_id;
	ELSE
		OPEN crs_activos FOR        			
   		 SELECT p_act_id from dual;
	END IF;

	
	-- Calcula la puntuación y el rating correspondiente por activo
	FETCH crs_activos INTO v_act_id;
	WHILE (crs_activos%FOUND) LOOP
	
		FOR row IN crs_datos_rating_activo(v_act_id)
	      LOOP
	      	-- Suma puntuacion por datos ENTORNO
	      	 v_total_entorno := 0;
	      
	         v_total_entorno := v_total_entorno + criterio_valor(row.DD_TPR_CODIGO);
	         v_total_entorno := v_total_entorno + criterio_valor('04')*row.INF_HOTELES;
	         v_total_entorno := v_total_entorno + criterio_valor('05')*row.INF_TEATROS;
	         v_total_entorno := v_total_entorno + criterio_valor('06')*row.INF_SALAS_CINE;
	         v_total_entorno := v_total_entorno + criterio_valor('07')*row.INF_INST_DEPORT;
	         v_total_entorno := v_total_entorno + criterio_valor('08')*row.INF_CENTROS_COMERC;
	         v_total_entorno := v_total_entorno + criterio_valor('09')*row.INF_CENTROS_EDU;
	         v_total_entorno := v_total_entorno + criterio_valor('10')*row.INF_CENTROS_SANIT;
	         v_total_entorno := v_total_entorno + criterio_valor('11')*row.INF_PARKING_SUP_SUF;
	         v_total_entorno := v_total_entorno + criterio_valor('12')*row.INF_FACIL_ACCESO;
	         v_total_entorno := v_total_entorno + criterio_valor('13')*row.INF_LINEAS_BUS;
	         v_total_entorno := v_total_entorno + criterio_valor('14')*row.INF_METRO;
	         v_total_entorno := v_total_entorno + criterio_valor('15')*row.INF_EST_TREN;
	         
	         IF criterio_valor('ENT') IS NOT NULL AND v_total_entorno > criterio_valor('ENT') THEN
	         	v_total_entorno := criterio_valor('ENT');
	         END IF;

	         
	         -- Suma puntuacion por datos EDIFICIO
	         v_total_edificio := 0;
	         
	         v_total_edificio := v_total_edificio + criterio_valor('16')*row.EDI_PREVISIBLE_REHAB;
	         v_total_edificio := v_total_edificio + criterio_valor('17')*row.EDI_BUEN_ESTADO;
	         v_total_edificio := v_total_edificio + criterio_valor('18')*row.EDI_BAJO;
	         v_total_edificio := v_total_edificio + criterio_valor('19')*row.EDI_ASCENSOR;
	         v_total_edificio := v_total_edificio + criterio_valor('20')*row.EDI_VIVIENDA_UNIFAMILIAR;
	         v_total_edificio := v_total_edificio + criterio_valor('21')*row.ZCO_JARDINES;
	         v_total_edificio := v_total_edificio + criterio_valor('22')*row.ZCO_PISCINA;
	         v_total_edificio := v_total_edificio + criterio_valor('23')*row.ZCO_INST_DEP;
	         v_total_edificio := v_total_edificio + criterio_valor('24')*row.ZCO_ZONA_INFANTIL;
	         v_total_edificio := v_total_edificio + criterio_valor('25')*row.ZCO_CONSERJE_VIGILANCIA;
	         v_total_edificio := v_total_edificio + criterio_valor('26')*row.ZCO_GIMNASIO;
	         
	         IF criterio_valor('EDI') IS NOT NULL AND v_total_edificio > criterio_valor('EDI') THEN
	         	v_total_edificio := criterio_valor('EDI');
	         END IF;

	         
	         -- Suma puntuación por datos INTERIOR
	         v_total_interior := 0;
	         
	         v_total_interior := v_total_interior + criterio_valor('27')*row.CRI_PTA_ENT_BLINDADA;
	         v_total_interior := v_total_interior + criterio_valor('28')*row.CRI_PTA_ENT_ACORAZADA;
	         v_total_interior := v_total_interior + criterio_valor('29')*row.CRI_PTA_PASO_MACIZAS;
	         v_total_interior := v_total_interior + criterio_valor('30')*row.CRI_PTA_PASO_HUECAS;
	         v_total_interior := v_total_interior + criterio_valor('31')*row.CRI_ARMARIOS_ACABADO_ALTO;
	         v_total_interior := v_total_interior + criterio_valor('32')*row.CRI_ARMARIOS_ACABADO_BAJO;
	         v_total_interior := v_total_interior + criterio_valor('33')*row.CRE_VTNAS_ALU_ANODIZADO;
	         v_total_interior := v_total_interior + criterio_valor('34')*row.CRE_VTNAS_ALU_LACADO;
	         v_total_interior := v_total_interior + criterio_valor('35')*row.CRE_PERS_ALU;
	         v_total_interior := v_total_interior + criterio_valor('36')*row.CRE_VTNAS_CORREDERAS;
	         v_total_interior := v_total_interior + criterio_valor('37')*row.CRE_VTNAS_ABATIBLES;
	         v_total_interior := v_total_interior + criterio_valor('38')*row.CRE_VTNAS_OSCILOBAT;
	         v_total_interior := v_total_interior + criterio_valor('39')*row.CRE_DOBLE_CRISTAL;
	         v_total_interior := v_total_interior + criterio_valor('40')*row.PRV_HUMEDAD_PARED;
	         v_total_interior := v_total_interior + criterio_valor('41')*row.PRV_HUMEDAD_TECHO;
	         v_total_interior := v_total_interior + criterio_valor('42')*row.PRV_GOTELE;
	         v_total_interior := v_total_interior + criterio_valor('43')*row.PRV_PLASTICA_LISA;
	         v_total_interior := v_total_interior + criterio_valor('44')*row.PRV_PAPEL_PINTADO;
	         v_total_interior := v_total_interior + criterio_valor('45')*row.PRV_PINTURA_LISA_TECHO;
	         v_total_interior := v_total_interior + criterio_valor('46')*row.PRV_MOLDURA_ESCAYOLA;
	         v_total_interior := v_total_interior + criterio_valor('47')*row.SOL_TARIMA_FLOTANTE;
	         v_total_interior := v_total_interior + criterio_valor('48')*row.SOL_PARQUE;
	         v_total_interior := v_total_interior + criterio_valor('49')*row.SOL_MARMOL;
	         v_total_interior := v_total_interior + criterio_valor('50')*row.SOL_PLAQUETA;
	         v_total_interior := v_total_interior + criterio_valor('51')*row.COC_AMUEBLADA;
	         v_total_interior := v_total_interior + criterio_valor('52')*row.COC_ENCI_GRANITO;
	         v_total_interior := v_total_interior + criterio_valor('53')*row.COC_ENCI_MARMOL;
	         v_total_interior := v_total_interior + criterio_valor('54')*row.COC_ENCI_OTRO_MATERIAL;
	         v_total_interior := v_total_interior + criterio_valor('55')*row.COC_VITRO;
	         v_total_interior := v_total_interior + criterio_valor('56')*row.COC_LAVADORA;
	         v_total_interior := v_total_interior + criterio_valor('57')*row.COC_FRIGORIFICO;
	         v_total_interior := v_total_interior + criterio_valor('58')*row.COC_LAVAVAJILLAS;
	         v_total_interior := v_total_interior + criterio_valor('59')*row.COC_MICROONDAS;
	         v_total_interior := v_total_interior + criterio_valor('60')*row.COC_HORNO;
	         v_total_interior := v_total_interior + criterio_valor('61')*row.COC_AZULEJOS_EST;
	         v_total_interior := v_total_interior + criterio_valor('62')*row.COC_SUELOS;
	         v_total_interior := v_total_interior + criterio_valor('63')*row.COC_GRIFOS_MONOMANDO;
	         v_total_interior := v_total_interior + criterio_valor('64')*row.BNY_BANYERA_HIDROMASAJE;
	         v_total_interior := v_total_interior + criterio_valor('65')*row.BNY_COLUMNA_HIDROMASAJE;
	         v_total_interior := v_total_interior + criterio_valor('66')*row.BNY_ALICATADO_MARMOL;
	         v_total_interior := v_total_interior + criterio_valor('67')*row.BNY_ALICATADO_GRANITO;
	         v_total_interior := v_total_interior + criterio_valor('68')*row.BNY_ALICATADO_AZULEJO;
	         v_total_interior := v_total_interior + criterio_valor('69')*row.BNY_GRANITO;
	         v_total_interior := v_total_interior + criterio_valor('70')*row.BNY_MARMOL;
	         v_total_interior := v_total_interior + criterio_valor('71')*row.BNY_OTRO_MATERIAL;
	         v_total_interior := v_total_interior + criterio_valor('72')*row.BNY_SANITARIOS_EST;
	         v_total_interior := v_total_interior + criterio_valor('73')*row.BNY_SUELOS;
	         v_total_interior := v_total_interior + criterio_valor('74')*row.BNY_GRIFO_MONOMANDO;
	         v_total_interior := v_total_interior + criterio_valor('75')*row.INS_ELECTR_BUEN_ESTADO;
	         v_total_interior := v_total_interior + criterio_valor('76')*row.INS_ELECTR_DEFECTUOSA_ANTIGUA;
	         v_total_interior := v_total_interior + criterio_valor('77')*row.INS_CALEF_CENTRAL;
	         v_total_interior := v_total_interior + criterio_valor('78')*row.INS_CALEF_GAS_NATURAL;
	         v_total_interior := v_total_interior + criterio_valor('79')*row.INS_CALEF_RADIADORES_ALU;
	         v_total_interior := v_total_interior + criterio_valor('80')*row.INS_AGUA_CALIENTE_CENTRAL;
	         v_total_interior := v_total_interior + criterio_valor('81')*row.INS_AIRE_PREINSTALACION;
	         v_total_interior := v_total_interior + criterio_valor('82')*row.INS_AIRE_INSTALACION;
	         
	         IF criterio_valor('INT') IS NOT NULL AND v_total_interior > criterio_valor('INT') THEN
	         	v_total_interior := criterio_valor('INT');
	         END IF;

	         
	         -- Suma de totales
	         v_total := v_total_entorno + v_total_edificio + v_total_interior;
	      END LOOP;
	      
      	-- Lista con los tramos de puntuación de rating
		FOR tramo IN crs_tramos_rating
          LOOP
        	IF v_total >= tramo.tpr_valor_desde THEN
        		v_dd_rtg_id := tramo.dd_rtg_id;
        		UPDATE #ESQUEMA#.ACT_ACTIVO act
        			SET act.DD_RTG_ID = v_dd_rtg_id, act.USUARIOMODIFICAR = v_username, act.FECHAMODIFICAR = SYSDATE
        			WHERE act.ACT_ID = v_act_id;
        		EXIT;
        	END IF;
          END LOOP;
          
        FETCH crs_activos INTO v_act_id;
	  END LOOP;
		  
	CLOSE crs_activos;
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[Rating actualizado correctamente] - idRating asignado: ');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || TO_CHAR (SQLCODE));
      DBMS_OUTPUT.put_line (SQLERRM);
      ROLLBACK;
      RAISE;
END CALCULO_RATING_ACTIVO_AUTO;
/
EXIT;

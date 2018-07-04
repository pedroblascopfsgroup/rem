--/*
--##########################################
--## AUTOR=ISIDRO SOTOCA
--## FECHA_CREACION=20180704
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4208
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_GES_DIST_GESTORES los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    --TIPO_GESTOR COD_CARTERA COD_ESTADO_ACTIVO COD_TIPO_COMERZIALZACION COD_PROVINCIA COD_MUNICIPIO COD_POSTAL USERNAME NOMBRE_USUARIO VERSION USUARIOCREAR FECHACREAR

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    			-- TIPO_GESTOR		CODIGO_CARTERA		COD_ESTADO_ACTIVO		USERNAME	  	NOMBRE_USUARIO
    			
    	------------------------------------------------------------------------------------------------------------------
    	-- Gestor de Alquileres
    	------------------------------------------------------------------------------------------------------------------
		--T_TIPO_DATA('GALQ',		'01',				'gestalq',		'Gestor de Alquileres'),
		------------------------------------------------------------------------------------------------------------------
    	-- Supervisor de Alquileres
    	------------------------------------------------------------------------------------------------------------------
	    --T_TIPO_DATA('SUALQ',		'01',				'supalq',		'Supervisor de Alquileres'),
	    
    	------------------------------------------------------------------------------------------------------------------
    	-- Gestor de Edificaciones
    	------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('GEDI',			'01',				'09',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'02',				'09',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'03',				'09',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'04',				'09',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'05',				'09',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'06',				'09',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'07',				'09',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'08',				'09',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'09',				'09',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'10',				'09',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'11',				'09',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'12',				'09',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'13',				'09',					'gestedi',		'Gestor de Edificaciones'),
	    ------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('GEDI',			'01',				'02',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'02',				'02',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'03',				'02',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'04',				'02',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'05',				'02',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'06',				'02',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'07',				'02',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'08',				'02',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'09',				'02',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'10',				'02',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'11',				'02',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'12',				'02',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'13',				'02',					'gestedi',		'Gestor de Edificaciones'),
	    ------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('GEDI',			'01',				'06',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'02',				'06',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'03',				'06',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'04',				'06',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'05',				'06',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'06',				'06',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'07',				'06',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'08',				'06',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'09',				'06',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'10',				'06',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'11',				'06',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'12',				'06',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'13',				'06',					'gestedi',		'Gestor de Edificaciones'),
	    ------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('GEDI',			'01',				'11',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'02',				'11',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'03',				'11',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'04',				'11',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'05',				'11',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'06',				'11',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'07',				'11',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'08',				'11',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'09',				'11',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'10',				'11',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'11',				'11',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'12',				'11',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'13',				'11',					'gestedi',		'Gestor de Edificaciones'),
	    ------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('GEDI',			'01',				'10',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'02',				'10',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'03',				'10',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'04',				'10',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'05',				'10',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'06',				'10',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'07',				'10',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'08',				'10',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'09',				'10',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'10',				'10',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'11',				'10',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'12',				'10',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'13',				'10',					'gestedi',		'Gestor de Edificaciones'),
	    ------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('GEDI',			'01',				'05',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'02',				'05',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'03',				'05',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'04',				'05',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'05',				'05',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'06',				'05',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'07',				'05',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'08',				'05',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'09',				'05',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'10',				'05',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'11',				'05',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'12',				'05',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'13',				'05',					'gestedi',		'Gestor de Edificaciones'),
	    ------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('GEDI',			'01',				'08',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'02',				'08',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'03',				'08',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'04',				'08',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'05',				'08',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'06',				'08',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'07',				'08',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'08',				'08',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'09',				'08',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'10',				'08',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'11',				'08',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'12',				'08',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'13',				'08',					'gestedi',		'Gestor de Edificaciones'),
	    ------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('GEDI',			'01',				'07',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'02',				'07',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'03',				'07',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'04',				'07',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'05',				'07',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'06',				'07',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'07',				'07',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'08',				'07',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'09',				'07',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'10',				'07',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'11',				'07',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'12',				'07',					'gestedi',		'Gestor de Edificaciones'),
	    T_TIPO_DATA('GEDI',			'13',				'07',					'gestedi',		'Gestor de Edificaciones'),
	    
	    
	    ------------------------------------------------------------------------------------------------------------------
    	-- Supervisor de Edificaciones
    	------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('SUPEDI',		'01',				'09',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'02',				'09',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'03',				'09',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'04',				'09',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'05',				'09',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'06',				'09',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'07',				'09',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'08',				'09',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'09',				'09',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'10',				'09',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'11',				'09',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'12',				'09',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'13',				'09',					'supedi',		'Supervisor de Edificaciones'),
	    ------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('SUPEDI',		'01',				'02',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'02',				'02',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'03',				'02',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'04',				'02',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'05',				'02',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'06',				'02',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'07',				'02',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'08',				'02',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'09',				'02',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'10',				'02',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'11',				'02',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'12',				'02',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'13',				'02',					'supedi',		'Supervisor de Edificaciones'),
	    ------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('SUPEDI',		'01',				'06',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'02',				'06',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'03',				'06',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'04',				'06',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'05',				'06',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'06',				'06',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'07',				'06',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'08',				'06',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'09',				'06',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'10',				'06',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'11',				'06',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'12',				'06',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'13',				'06',					'supedi',		'Supervisor de Edificaciones'),
	    ------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('SUPEDI',		'01',				'11',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'02',				'11',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'03',				'11',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'04',				'11',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'05',				'11',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'06',				'11',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'07',				'11',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'08',				'11',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'09',				'11',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'10',				'11',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'11',				'11',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'12',				'11',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'13',				'11',					'supedi',		'Supervisor de Edificaciones'),
	    ------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('SUPEDI',		'01',				'10',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'02',				'10',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'03',				'10',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'04',				'10',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'05',				'10',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'06',				'10',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'07',				'10',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'08',				'10',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'09',				'10',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'10',				'10',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'11',				'10',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'12',				'10',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'13',				'10',					'supedi',		'Supervisor de Edificaciones'),
	    ------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('SUPEDI',		'01',				'05',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'02',				'05',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'03',				'05',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'04',				'05',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'05',				'05',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'06',				'05',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'07',				'05',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'08',				'05',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'09',				'05',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'10',				'05',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'11',				'05',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'12',				'05',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'13',				'05',					'supedi',		'Supervisor de Edificaciones'),
	    ------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('SUPEDI',		'01',				'08',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'02',				'08',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'03',				'08',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'04',				'08',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'05',				'08',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'06',				'08',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'07',				'08',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'08',				'08',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'09',				'08',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'10',				'08',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'11',				'08',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'12',				'08',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'13',				'08',					'supedi',		'Supervisor de Edificaciones'),
	    ------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('SUPEDI',		'01',				'07',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'02',				'07',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'03',				'07',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'04',				'07',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'05',				'07',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'06',				'07',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'07',				'07',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'08',				'07',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'09',				'07',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'10',				'07',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'11',				'07',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'12',				'07',					'supedi',		'Supervisor de Edificaciones'),
	    T_TIPO_DATA('SUPEDI',		'13',				'07',					'supedi',		'Supervisor de Edificaciones'),
	    
	    
	    ------------------------------------------------------------------------------------------------------------------
    	-- Gestor de Suelos
    	------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('GSUE',			'01',				'01',					'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'02',				'01',					'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'03',				'01',					'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'04',				'01',					'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'05',				'01',					'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'06',				'01',					'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'07',				'01',					'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'08',				'01',					'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'09',				'01',					'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'10',				'01',					'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'11',				'01',					'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'12',				'01',					'gestsue',		'Gestor de Suelos'),
	    T_TIPO_DATA('GSUE',			'13',				'01',					'gestsue',		'Gestor de Suelos'),
	    
	    ------------------------------------------------------------------------------------------------------------------
    	-- Gestor de Suelos
    	------------------------------------------------------------------------------------------------------------------
	    T_TIPO_DATA('SUPSUE',		'01',				'01',					'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'02',				'01',					'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'03',				'01',					'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'04',				'01',					'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'05',				'01',					'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'06',				'01',					'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'07',				'01',					'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'08',				'01',					'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'09',				'01',					'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'10',				'01',					'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'11',				'01',					'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'12',				'01',					'supsue',		'Supervisor de Suelos'),
	    T_TIPO_DATA('SUPSUE',		'13',				'01',					'supsue',		'Supervisor de Suelos')
    );

    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Insertar valores en '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.');
	
	-- Se borraran los registros de este gestor si no tienen asignado un COD_ESTADO_ACTIVO
	V_MSQL := '
            DELETE FROM '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' 
            WHERE 
              TIPO_GESTOR IN (''GEDI'', ''SUPEDI'', ''GSUE'', ''SUPSUE'')
              AND COD_CARTERA IS NOT NULL 
              AND COD_ESTADO_ACTIVO IS NULL';
	EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: Se han eliminado todos los registros con estos gestores que no tenian asignado un COD_ESTADO_ACTIVO');
	 
    -- LOOP para insertar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: Inicio de comprobaciones previas.');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := '
          SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
          WHERE 
            TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' 
            AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' 
            AND COD_ESTADO_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(3))||''' 
            AND COD_TIPO_COMERZIALZACION IS NULL 
            AND COD_PROVINCIA IS NULL
            AND COD_MUNICIPIO IS NULL 
            AND COD_POSTAL IS NULL 
        ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
       	  V_MSQL := '
            UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' 
            SET 
              USERNAME = '''||TRIM(V_TMP_TIPO_DATA(4))||''',
              NOMBRE_USUARIO =  '''||TRIM(V_TMP_TIPO_DATA(5))||''',
              USUARIOMODIFICAR = ''HREOS-4208'',
              FECHAMODIFICAR = SYSDATE 
            WHERE 
              TIPO_GESTOR = '''||TRIM(V_TMP_TIPO_DATA(1))||''' 
              AND COD_CARTERA = '''||TRIM(V_TMP_TIPO_DATA(2))||''' 
              AND COD_ESTADO_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''  
              AND COD_TIPO_COMERZIALZACION IS NULL 
              AND COD_PROVINCIA IS NULL 
              AND COD_MUNICIPIO IS NULL 
              AND COD_POSTAL IS NULL ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: '||TRIM(V_TMP_TIPO_DATA(1))||' actualizado correctamente');
          
       --Si no existe, lo insertamos   
       ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (
				ID, 
				TIPO_GESTOR, 
				COD_CARTERA,
				COD_ESTADO_ACTIVO,
				USERNAME, 
				NOMBRE_USUARIO, 
				VERSION, 
				USUARIOCREAR, 
				FECHACREAR, 
				BORRADO
			) 
            SELECT 
              	'|| V_ID ||',
              	'''||TRIM(V_TMP_TIPO_DATA(1))||''',
				'''||TRIM(V_TMP_TIPO_DATA(2))||''',
              	'''||TRIM(V_TMP_TIPO_DATA(3))||''',
          		'''||TRIM(V_TMP_TIPO_DATA(4))||''',
				'''||TRIM(V_TMP_TIPO_DATA(5))||''',
				0,
				''HREOS-4208'',
				SYSDATE,
				0
			FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: '||TRIM(V_TMP_TIPO_DATA(1))||' insertado correctamente');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TEXT_TABLA||' actualizado corresctamente.');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/

EXIT

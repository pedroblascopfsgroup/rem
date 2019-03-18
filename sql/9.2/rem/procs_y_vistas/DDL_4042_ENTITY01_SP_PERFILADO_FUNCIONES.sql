--/*
--######################################### 
--## AUTOR=Talent XII
--## FECHA_CREACION=20181217
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4917
--## PRODUCTO=NO
--## 
--## Finalidad: Procedimiento encargado de perfilar las funciones.
--##      
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Resolución conflictos
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE SP_PERFILADO_FUNCIONES (
  V_USUARIO   VARCHAR2 DEFAULT 'SP_PEF_FUN'
)
AS

  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 	-- 'REM01'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';	-- 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para almacenar la sentencia.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.

  V_TABLA VARCHAR2(30 CHAR) := 'FUN_PEF';  -- Tabla objetivo
  V_TABLA_TMP VARCHAR2(30 CHAR) := 'TMP_FUN_PEF';  -- Tabla objetivo

  --Array que contiene los registros que se van a actualizar
  TYPE T_VAR is table of VARCHAR2(250);
  TYPE T_ARRAY IS TABLE OF T_VAR;
  V_FUN T_ARRAY := T_ARRAY(

    ------    FUNCION   --------------------------------------  1- -2---3---4---5---6---7---8---9--10--11--12--13--14--15--16--17--18--19--20--21--22--23--24--25--26--27--28--29--31--31--32--33--34--35--36--37--38--39--40--41--42--43--44--45--46--47--48--49--50--51--
T_VAR( 'TAB_BUSQUEDA_ACTIVOS','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),

T_VAR( 'TAB_ACTIVO_DATOS_GENERALES','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_ACTIVO_ACTUACIONES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_ACTIVO_GESTORES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'MOSTRAR_COMBO_GESTORES','N','S','N','S','N','S','N','S','N','S','N','N','S','N','S','N','S','N','S','N','S','N','S','N','S','N','N','N','N','N','N','N','N','N','N','N','S','N','S','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_ACTIVO_OBSERVACIONES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','S','S','S','S','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'ACTIVO_OBSERVACIONES_ADD','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','S','S','S','S','S','S','N','N','S','S','S','S','S','S','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','S'),
T_VAR( 'EDITAR_TAB_ACTIVO_FOTOS','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_ACTIVO_FOTOS','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_ACTIVO_DOCUMENTOS','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','S'),
T_VAR( 'TAB_ACTIVO_DOCUMENTOS','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'ACTIVO_DOCUMENTOS_ADD','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','N','N','N','N','S','S','S','S','S','S','N','N','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','S'),
T_VAR( 'TAB_ACTIVO_AGRUPACIONES','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_ACTIVO_ADMISION','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_ACTIVO_GESTION','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_ACTIVO_PRECIOS','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','S','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_ACTIVO_PUBLICACION','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','S','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_ACTIVO_COMERCIAL','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','S','S','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_ACTIVO_COMERCIAL','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','S'),
T_VAR( 'TAB_ACTIVO_ADMINISTRACION','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_DATOS_BASICOS_ACTIVO','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_DATOS_BASICOS_ACTIVO','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TITULO_INFO_REGISTRAL_ACTIVO','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_ACTIVO_TITULO_INFO_REGISTRAL','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_INFO_ADMINISTRATIVA_ACTIVO','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_ACTIVO_INFO_ADMINISTRATIVA','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_ACTIVO_CARGAS','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_ACTIVO_CARGAS','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','S','S','S','S','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_SITU_POSESORIA_ACTIVO','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_ACTIVO_SITU_POSESORIA','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_ACTIVO_INFO_COMERCIAL','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'EDITAR_DATOS_COMUNIDAD_ACTIVO','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','S','S','S','S','S','S','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'TAB_ACTIVO_DATOS_COMUNIDAD','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_GRID_LISTADO_FICHA_COMUNIDAD_ENTIDADES','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','S'),
T_VAR( 'EDITAR_TAB_FOTOS_ACTIVO_WEB','N','N','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_FOTOS_ACTIVO_WEB','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_FOTOS_ACTIVO_TECNICAS','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_FOTOS_ACTIVO_TECNICAS','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_CHECKING_INFO_ADMISION','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'EDITAR_SELLO_CALIDAD','N','N','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_CHECKING_INFO_ADMISION','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_CHECKING_DOC_ADMISION','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_CHECKING_DOC_ADMISION','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_HIST_PETICIONES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_PRESUPUESTO_ASIGNADO_ACTIVO','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_VALORACIONES_PRECIOS','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','S','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_VALORACIONES_PRECIOS','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','S','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_GRID_PRECIOS_VIGENTES','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','S'),
T_VAR( 'EDITAR_TAB_TASACIONES','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_TASACIONES','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_PROPUESTAS_PRECIO','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_INFO_COMERCIAL_PUBLICACION','N','N','N','N','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_INFO_COMERCIAL_PUBLICACION','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','S','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_GRID_PUBLICACION_HISTORICO_MEDIADORES','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','S'),
T_VAR( 'EDITAR_TAB_DATOS_PUBLICACION','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_DATOS_PUBLICACION','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_GRID_PUBLICACION_CONDICIONES_ESPECIFICAS','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','S'),
T_VAR( 'TAB_COMERCIAL_VISITAS','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','S','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_COMERCIAL_OFERTAS','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','S','S','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_LIST_OFERTAS_ACTIVO','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','S','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'BOTON_CREAR_TRABAJO','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),

T_VAR( 'TAB_DATOS_GENERALES_TRAMITE','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_TAREAS_TRAMITE','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_HISTORICO_TAREAS_TRAMITE','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_ACTIVOS_TRAMITE','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'BOTON_RESOLUCION_EXPEDIENTE','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'BOTON_ANULAR_TRAMITE','N','N','N','N','N','N','S','S','S','S','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N'),

T_VAR( 'EDITAR_LIST_AGRUPACIONES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N'),
T_VAR( 'EDITAR_AGRUPACION','S','S','S','S','N','N','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'TAB_AGRUPACION','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_LISTA_ACTIVOS_AGRUPACION','S','S','S','S','N','N','N','N','S','S','N','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'TAB_LISTA_ACTIVOS_AGRUPACION','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_PUBLICACION_LISTA_ACTIVOS_AGRUPACION','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_FOTOS_AGRUPACION','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_FOTOS_AGRUPACION','N','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','S','N','N','S','N','N','N'),
T_VAR( 'EDITAR_TAB_OBSERVACIONES_AGRUPACION','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','S','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','S'),
T_VAR( 'TAB_OBSERVACIONES_AGRUPACION','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_SUBDIVISIONES_AGRUPACION','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'ROLE_PUEDE_VER_BOTON_APROBAR_INFORME','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'EDITAR_FOTOS_SUBDIVISION','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','','','','','N','N','N','N','N','N','N','N','S','S','S','S','N','S','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'EDITAR_TAB_COMERCIAL_AGRUPACION','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'TAB_COMERCIAL_AGRUPACION','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','S','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),

T_VAR( 'EDITAR_FICHA_TRABAJO','S','S','S','S','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','S','S','N','S','S','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_FICHA_TRABAJO','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_ACTIVOS_TRABAJO','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_TRAMITES_TRABAJO','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_DIARIO_GESTIONES_TRABAJO','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','N','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','S'),
T_VAR( 'TAB_DIARIO_GESTIONES_TRABAJO','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TRABAJO_DIARIO_ADD','S','S','S','S','N','N','S','S','S','S','N','N','N','N','N','','','','','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','S','N','N','S','N','N','N'),
T_VAR( 'TAB_FOTOS_TRABAJO','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_FOTOS_SOLICITANTE_TRABAJO','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_FOTOS_SOLICITANTE_TRABAJO','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_FOTOS_PROVEEDOR_TRABAJO','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_FOTOS_PROVEEDOR_TRABAJO','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','S','S','N','S','S','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'EDITAR_TAB_DOCUMENTOS_TRABAJO','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_DOCUMENTOS_TRABAJO','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TRABAJO_DOCUMENTOS_ADD','S','S','S','S','N','N','S','S','S','S','N','S','S','S','S','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_GESTION_ECONOMICA_TRABAJO','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','S','S','N','S','S','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_GESTION_ECONOMICA_TRABAJO','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),

T_VAR( 'TAB_GENERACION_PROPUESTAS_PRECIO','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_INCLUSION_AUTOMATICA_PRECIOS','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_SELECCION_MANUAL_PRECIOS','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_CONFIGURACION_PROPUESTA_PRECIO','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_HISTORICO_PROPUESTA_PRECIOS','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),

T_VAR( 'TAB_PUBLICACION_ACTIVOS','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','S','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_CONFIGURACION_PUBLICACION','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','S','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_CONFIGURACION_PUBLICACION','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),

T_VAR( 'TAB_VISITAS_COMERCIAL','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','S','N','N','N','N','N','N','S','S','S','S','N','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_OFERTAS_COMERCIAL','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','S','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),

T_VAR( 'TAB_DATOS_BASICOS_EXPEDIENTES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','N','S','N','N','S','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_DATOS_BASICOS_EXPEDIENTES','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','S'),
T_VAR( 'TAB_OFERTA_EXPEDIENTES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','N','S','N','N','S','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N',''),
T_VAR( 'EDITAR_TAB_DATOS_BASICOS_OFERTA_EXPEDIENTES','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'TAB_DATOS_BASICOS_OFERTA_EXPEDIENTES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','N','S','N','N','S','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_GRID_TEXTOS_OFERTA_EXPEDIENTE','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','S'),
T_VAR( 'EDITAR_TAB_TANTEO_RETRACTO_OFERTA_EXPEDIENTES','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','S'),
T_VAR( 'TAB_TANTEO_RETRACTO_OFERTA_EXPEDIENTES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','N','S','N','N','S','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N',''),
T_VAR( 'EDITAR_TAB_CONDICIONES_EXPEDIENTES','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','S'),
T_VAR( 'TAB_CONDICIONES_EXPEDIENTES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','N','S','N','N','S','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N',''),
T_VAR( 'EDITAR_GRID_LISTADO_ACTIVOS_EXPEDIENTE','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','S'),
T_VAR( 'TAB_ACTIVOS_COMERCIALIZABLES_EXPEDIENTES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','N','S','N','N','S','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N',''),
T_VAR( 'ECO_LISTADO_ACTIVOS_TANTEO','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'ECO_LISTADO_ACTIVOS_CONDICIONES','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'ECO_LISTADO_ACTIVOS_BLOQUEOS','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','S'),
T_VAR( 'TAB_RESERVA_EXPEDIENTES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','N','S','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_RESERVA_EXPEDIENTES','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','S'),
T_VAR( 'TAB_COMPRADORES_EXPEDIENTES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','N','S','N','N','S','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_COMPRADORES_EXP_DETALLES_COMPRADOR','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','N','S','N','S','S','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','S','S','N','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','S'),
T_VAR( 'MODIFICAR_TAB_COMPRADORES_EXPEDIENTES','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','S','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'MODIFICAR_TAB_COMPRADORES_EXPEDIENTES_RESERVA','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'EDITAR_TAB_COMPRADORES_EXPEDIENTES','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N'),
T_VAR( 'TAB_DIARIO_GESTIONES_EXPEDIENTES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','N','S','N','N','S','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_DIARIO_GESTIONES_EXPEDIENTES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','S','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','S'),
T_VAR( 'TAB_TRÁMITES_EXPEDIENTES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','N','S','N','N','S','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_DOCUMENTOS_EXPEDIENTES','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','S','N','S','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','S'),
T_VAR( 'TAB_DOCUMENTOS_EXPEDIENTES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','N','S','N','N','S','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_FORMALIZACION_EXPEDIENTES','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','S'),
T_VAR( 'TAB_FORMALIZACION_EXPEDIENTES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','N','S','N','N','S','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_GRID_POS_FIRMA_FORMALIZACION_EXPEDIENTE','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','S'),
T_VAR( 'EDITAR_TAB_GESTION_ECONOMICA_EXPEDIENTES','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','S'),
T_VAR( 'TAB_GESTION_ECONOMICA_EXPEDIENTES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','N','S','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_GRID_GESTION_ECONOMICA_EXPEDIENTE','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','S'),
T_VAR( 'MOSTRAR_COMBO_GESTORES_EXPEDIENTES','N','N','N','N','N','N','N','N','N','N','N','N','S','N','S','N','S','N','S','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','S','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'TAB_GESTORES_EXPEDIENTES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','N','S','N','N','S','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),

T_VAR( 'TAB_GASTOS_ADMINISTRACION','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_GESTION_GASTOS_ADMINISTRACION','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'CREAR_GASTO','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','S','S','S','S','S','S','S','S','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'OPERAR_GASTO','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'TAB_GESTION_PROVISIONES_ADMINISTRACION','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','S','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'OPERAR_GASTO_AGRUPACION','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','S','N','S','N','N','S','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'EDITAR_BTN_EXPORT_FACTURAS_TASAS_IMPUESTOS','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N'),

T_VAR( 'EDITAR_TAB_DATOS_GENERALES_GASTOS','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','S','S','S','S','S','S','S','S','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'TAB_DATOS_GENERALES_GASTOS','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_DETALLE_ECONOMICO_GASTOS','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','S','S','S','S','S','S','S','S','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'TAB_DETALLE_ECONOMICO_GASTOS','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_ACTIVOS_AFECTADOS_GASTOS','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_ACTIVOS_AFECTADOS_GASTOS','N','N','S','S','','N','N','N','N','N','N','N','N','N','N','','','','','N','N','S','S','N','N','N','N','S','S','S','S','S','S','S','S','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'TAB_CONTABILIDAD_GASTOS','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_CONTABILIDAD_GASTOS','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','S','S','S','S','S','S','S','S','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'TAB_GESTION_GASTOS','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_GESTION_GASTOS','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'TAB_IMPUGNACION_GASTOS','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_IMPUGNACION_GASTOS','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','S','S','S','S','S','S','S','S','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'TAB_DOCUMENTOS','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_DOCUMENTOS','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','S','S','S','S','S','S','S','S','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),

T_VAR( 'TAB_ADMINISTRACION_CONFIGURACION','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_PROVEEDORES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'TAB_MEDIADORES','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),

T_VAR( 'TAB_DATOS_PROVEEDORES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_DATOS_PROVEEDORES','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N'),
T_VAR( 'TAB_DOCUMENTOS_PROVEEDORES','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'EDITAR_TAB_DOCUMENTOS_PROVEEDORES','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N'),
T_VAR( 'ADD_QUITAR_PROVEEDORES','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N'),

T_VAR( 'MASIVO_DESDESPUBLICAR_FORZADO','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'ACTUALIZAR_PUBLICAR','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'ACTUALIZAR_OCULTARACTIVO','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'ACTUALIZAR_DESOCULTARACTIVO','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'ACTUALIZAR_OCULTARPRECIO','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'ACTUALIZAR_DESOCULTARPRECIO','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'ACTUALIZAR_DESPUBLICAR','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MASIVO_DESPUBLICAR_FORZADO','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'PRECIOS_ACTUALIZAR','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'PRECIOS_BLOQUEAR','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'PRECIOS_DESBLOQUEAR','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'VALORES_FSV_ACTUALIZAR','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N'),
T_VAR( 'MASIVO_PROPUESTA_PRECIOS','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MASIVO_PROPUESTA_PRECIOS','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MASIVO_PROPUESTA_PRECIOS','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MASIVO_PROPUESTA_PRECIOS','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'ALTA_ACTIVOS_FINAN','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'ALTA_ACTIVOS_THIRD_PARTY','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'ASISTIDAPDV_CARGA','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MASIVO_LOTE_COMERCIAL','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N'),


T_VAR( 'MASIVO_PROYECTO','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','S','S','N','S','N','N','N'),
T_VAR( 'SUBIR_LISTA_ACTIVOS_IBI','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','S','S','S','S','S','S','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),

T_VAR( 'CARGA_ACTIVOS_GASTOS_PORCENTAJE','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'MASIVO_PRINEX_LBK','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'MASIVO_PUBLICACION_VENTA','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MASIVO_PUBLICACION_ALQUILER','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MASIVO_OCULTACION_VENTA','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MASIVO_OCULTACION_ALQUILER','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MASIVO_OK_TECNICO','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'VENTA_DE_CARTERA','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N'),
T_VAR( 'MASIVO_PUBLICACION_VENTA_RESTRINGIDO','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MASIVO_PUBLICACION_ALQUILER_RESTRINGIDO','N','N','N','N','N','N','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MASIVO_PLUSVALIA','S','S','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MASIVO_DESOCULTAR_ACTIVOS_VENTA','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MASIVO_DESOCULTAR_ACTIVOS_ALQUILER','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MASIVO_INDICADOR_ACTIVO','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MASIVO_RECLAMACIONES','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S'),
T_VAR( 'MASIVO_ADECUACION','N','N','N','N','N','N','N','N','S','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MASIVO_EXCLUIR_ACTIVOS_DWH','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','S','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),

T_VAR( 'MENU_DASHBOARD','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'),
T_VAR( 'MENU_AGENDA','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','S'),
T_VAR( 'MENU_AGRUPACIONES','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'MENU_TRABAJOS','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'MENU_PRECIOS','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'MENU_PUBLICACION','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'MENU_COMERCIAL','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','S','N','N','N','N','N','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'MENU_ADMINISTRACION','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'MENU_MASIVO','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','N','N','N','N','N','S','N','N','S','S','S','S','N','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'MENU_CONFIGURACION','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'MENU_ACTIVOS','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'MENU_TOP_ALERTAS','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'MENU_TOP_TAREAS','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'MENU_TOP_AVISOS','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S'),
T_VAR( 'OPTIMIZACION_BUZON_TAREAS','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','S','N','N','S','N','N','S')

);

V_TMP_VAR T_VAR;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    --######################################
    --########   INSERTAR VALORES  #########
    --######################################

    -- Verificar si la tabla existe
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA_TMP||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN

      DBMS_OUTPUT.PUT_LINE('  [INFO] TRUNCANDO TABLA '||V_ESQUEMA||'.'||V_TABLA_TMP||'...');

      V_SQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA_TMP||'';
      EXECUTE IMMEDIATE V_SQL;

      FOR I IN V_FUN.FIRST .. V_FUN.LAST
        LOOP
        V_TMP_VAR := V_FUN(I);

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' WHERE FUNCION = '''||V_TMP_VAR(1)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 0 THEN

          DBMS_OUTPUT.PUT_LINE('    [INFO] INSERTANDO PERFILADO PARA LA FUNCION '||V_TMP_VAR(1)||'...');

          V_SQL := '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TMP||' (
			FUNCION
			,HAYAGESTADM
			,HAYASUPADM
			,HAYAGESACT
			,HAYASUPACT
			,HAYACAL
			,HAYASUPCAL
			,HAYAGESTPREC
			,HAYASUPPREC
			,HAYAGESTPUBL
			,HAYASUPPUBL
			,HAYAFSV
			,HAYAGBOINM
			,HAYASBOINM
			,HAYAGBOFIN
			,HAYASBOFIN
			,HAYAGESTCOMRET
			,HAYASUPCOMRET
			,HAYAGESTCOMSIN
			,HAYASUPCOMSIN
			,HAYAGESTFORM
			,HAYASUPFORM
			,HAYAADM
			,HAYASADM
			,HAYALLA
			,HAYASLLA
			,PERFGCCBANKIA
			,PERFGCCLIBERBANK
			,GESTOADM
			,GESTIAFORM
			,HAYAGESTADMT
			,GESTOCED
			,GESTOPLUS
			,GESTOPDV
			,HAYAPROV
			,HAYACERTI
			,HAYACONSU
			,HAYASUPER
			,HAYAGESTCOM
			,HAYASUPCOM
            ,HAYAGOLDTREE
			,FVDNEGOCIO
			,FVDBACKOFERTA
			,FVDBACKVENTA
			,SUPFVD
			,GESRES
			,SUPRES
			,GESMIN
			,SUPMIN
			,GESPROV
			,GESTSUE
			,GESTEDI
			,VALORACIONES
			,PMSVVC
            )
            SELECT
              '''||V_TMP_VAR(1)||'''
              , '''||V_TMP_VAR(2)||'''
              , '''||V_TMP_VAR(3)||'''
              , '''||V_TMP_VAR(4)||'''
              , '''||V_TMP_VAR(5)||'''
              , '''||V_TMP_VAR(6)||'''
              , '''||V_TMP_VAR(7)||'''
              , '''||V_TMP_VAR(8)||'''
              , '''||V_TMP_VAR(9)||'''
              , '''||V_TMP_VAR(10)||'''
              , '''||V_TMP_VAR(11)||'''
              , '''||V_TMP_VAR(12)||'''
              , '''||V_TMP_VAR(13)||'''
              , '''||V_TMP_VAR(14)||'''
              , '''||V_TMP_VAR(15)||'''
              , '''||V_TMP_VAR(16)||'''
              , '''||V_TMP_VAR(17)||'''
              , '''||V_TMP_VAR(18)||'''
              , '''||V_TMP_VAR(19)||'''
              , '''||V_TMP_VAR(20)||'''
              , '''||V_TMP_VAR(21)||'''
              , '''||V_TMP_VAR(22)||'''
              , '''||V_TMP_VAR(23)||'''
              , '''||V_TMP_VAR(24)||'''
              , '''||V_TMP_VAR(25)||'''
              , '''||V_TMP_VAR(26)||'''
              , '''||V_TMP_VAR(27)||'''
              , '''||V_TMP_VAR(28)||'''
              , '''||V_TMP_VAR(29)||'''
              , '''||V_TMP_VAR(30)||'''
              , '''||V_TMP_VAR(31)||'''
              , '''||V_TMP_VAR(32)||'''
              , '''||V_TMP_VAR(33)||'''
              , '''||V_TMP_VAR(34)||'''
              , '''||V_TMP_VAR(35)||'''
              , '''||V_TMP_VAR(36)||'''
              , '''||V_TMP_VAR(37)||'''
              , '''||V_TMP_VAR(38)||'''
              , '''||V_TMP_VAR(39)||'''
              , '''||V_TMP_VAR(40)||'''
              , '''||V_TMP_VAR(41)||'''
			  , '''||V_TMP_VAR(42)||'''
			  , '''||V_TMP_VAR(43)||'''
			  , '''||V_TMP_VAR(44)||'''
			  , '''||V_TMP_VAR(45)||'''
			  , '''||V_TMP_VAR(46)||'''
			  , '''||V_TMP_VAR(47)||'''
        	  , '''||V_TMP_VAR(48)||'''
        	  , '''||V_TMP_VAR(49)||'''
        	  , '''||V_TMP_VAR(50)||'''
        	  , '''||V_TMP_VAR(51)||'''
			  , '''||V_TMP_VAR(52)||'''
              , '''||V_TMP_VAR(53)||'''
              , '''||V_TMP_VAR(54)||'''
            FROM DUAL
          '
          ;
          EXECUTE IMMEDIATE V_SQL;

        ELSE
          DBMS_OUTPUT.PUT_LINE('    [INFO] LA FUNCION '||V_TMP_VAR(1)||' YA TIENE PERFILADO.');
        END IF;

      END LOOP;

      --######################################
      --########   BAJA TABLA FUN_PEF   ######
      --######################################

      DBMS_OUTPUT.PUT_LINE('  [INFO] DANDO DE BAJA PERFILADOS EN LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'...');

      V_SQL := '
        DELETE FROM '||V_ESQUEMA||'.FUN_PEF
        WHERE (FUN_ID, PEF_ID)
        IN (
          SELECT FUN_ID, PEF_ID
          FROM (
            WITH PERFILES AS (
              SELECT
                FUNCION,
                PERFIL,
                VALUE AS INCLUIR
              FROM '||V_ESQUEMA||'.TMP_FUN_PEF
              UNPIVOT
              EXCLUDE NULLS (
                VALUE
                FOR
                PERFIL
                IN (
<<<<<<< HEAD
                    HAYAGESTADM
                    ,HAYASUPADM
                    ,HAYAGESACT
                    ,HAYASUPACT
                    ,HAYACAL
                    ,HAYASUPCAL
                    ,HAYAGESTPREC
                    ,HAYASUPPREC
                    ,HAYAGESTPUBL
                    ,HAYASUPPUBL
                    ,HAYAFSV
                    ,HAYAGBOINM
                    ,HAYASBOINM
                    ,HAYAGBOFIN
                    ,HAYASBOFIN
                    ,HAYAGESTCOMRET
                    ,HAYASUPCOMRET
                    ,HAYAGESTCOMSIN
                    ,HAYASUPCOMSIN
                    ,HAYAGESTFORM
                    ,HAYASUPFORM
                    ,HAYAADM
                    ,HAYASADM
                    ,HAYALLA
                    ,HAYASLLA
                    ,PERFGCCBANKIA
                    ,PERFGCCLIBERBANK
                    ,GESTOADM
                    ,GESTIAFORM
                    ,HAYAGESTADMT
                    ,GESTOCED
                    ,GESTOPLUS
                    ,GESTOPDV
                    ,HAYAPROV
                    ,HAYACERTI
                    ,HAYACONSU
                    ,HAYASUPER
                    ,HAYAGESTCOM
                    ,HAYASUPCOM
                    ,HAYAGOLDTREE
                    ,FVDNEGOCIO
                    ,FVDBACKOFERTA
                    ,FVDBACKVENTA
                    ,SUPFVD
                    ,GESRES
                    ,SUPRES
                    ,GESMIN
                    ,SUPMIN
                    ,GESPROV
                    ,GESTSUE
                    ,GESTEDI
                    ,VALORACIONES
                    ,PMSVVC
                    ,FTI
                    ,HAYAGESTFORMADM
		    ,APROBCERB
                    ,SUPERFORM
                    ,SUPERGESTACT
                    ,SUPERADMIN
                    ,SUPERPUBLI
                    ,SUPERMIDDLE
                    ,SUPERFRONT
                    ,SUPERPLANIF
                    ,GTOPOSTV
=======
             HAYAGESTADM
			,HAYASUPADM
			,HAYAGESACT
			,HAYASUPACT
			,HAYACAL
			,HAYASUPCAL
			,HAYAGESTPREC
			,HAYASUPPREC
			,HAYAGESTPUBL
			,HAYASUPPUBL
			,HAYAFSV
			,HAYAGBOINM
			,HAYASBOINM
			,HAYAGBOFIN
			,HAYASBOFIN
			,HAYAGESTCOMRET
			,HAYASUPCOMRET
			,HAYAGESTCOMSIN
			,HAYASUPCOMSIN
			,HAYAGESTFORM
			,HAYASUPFORM
			,HAYAADM
			,HAYASADM
			,HAYALLA
			,HAYASLLA
			,PERFGCCBANKIA
			,PERFGCCLIBERBANK
			,GESTOADM
			,GESTIAFORM
			,HAYAGESTADMT
			,GESTOCED
			,GESTOPLUS
			,GESTOPDV
			,HAYAPROV
			,HAYACERTI
			,HAYACONSU
			,HAYASUPER
			,HAYAGESTCOM
			,HAYASUPCOM
            ,HAYAGOLDTREE
			,FVDNEGOCIO
			,FVDBACKOFERTA
			,FVDBACKVENTA
			,SUPFVD
			,GESRES
			,SUPRES
			,GESMIN
			,SUPMIN
            ,GESPROV
			,GESTSUE
			,GESTEDI
            ,VALORACIONES
			,PMSVVC
>>>>>>> parent of 9b3ebdf... HREOS-5530 - Nueva Gestoría GTOPOSTV en SP_PERFILADO y TMP_FUN_PEF
                )
              )
            )
            SELECT FUN.FUN_ID, PEF.PEF_ID
            FROM PERFILES
            JOIN '||V_ESQUEMA||'.PEF_PERFILES PEF ON PEF.PEF_CODIGO = PERFIL
            JOIN '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN ON FUN.FUN_DESCRIPCION = FUNCION
            WHERE INCLUIR = ''N''
            INTERSECT
            SELECT FUN_ID, PEF_ID FROM '||V_ESQUEMA||'.FUN_PEF
          )
        )
      '
      ;
      EXECUTE IMMEDIATE V_SQL;

      DBMS_OUTPUT.PUT_LINE('  [INFO] PERFILADOS DADOS DE BAJA - '||SQL%ROWCOUNT||'');

      --######################################
      --########   ALTA TABLA FUN_PEF   ######
      --######################################

      DBMS_OUTPUT.PUT_LINE('  [INFO] DANDO DE ALTA NUEVOS PERFILADOS EN LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'...');

      V_SQL := '
        INSERT INTO FUN_PEF (FP_ID, FUN_ID, PEF_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
        SELECT
          '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL
          , FUN_ID
          , PEF_ID
          , 0
          , '''||V_USUARIO||'''
          , SYSDATE
          , 0
        FROM (
            WITH PERFILES AS (
            SELECT
               FUNCION,
               PERFIL,
               VALUE AS INCLUIR
            FROM '||V_ESQUEMA||'.TMP_FUN_PEF
            UNPIVOT
            EXCLUDE NULLS
            (
               VALUE
               FOR
                  PERFIL
               IN
               (
<<<<<<< HEAD
                HAYAGESTADM
                ,HAYASUPADM
                ,HAYAGESACT
                ,HAYASUPACT
                ,HAYACAL
                ,HAYASUPCAL
                ,HAYAGESTPREC
                ,HAYASUPPREC
                ,HAYAGESTPUBL
                ,HAYASUPPUBL
                ,HAYAFSV
                ,HAYAGBOINM
                ,HAYASBOINM
                ,HAYAGBOFIN
                ,HAYASBOFIN
                ,HAYAGESTCOMRET
                ,HAYASUPCOMRET
                ,HAYAGESTCOMSIN
                ,HAYASUPCOMSIN
                ,HAYAGESTFORM
                ,HAYASUPFORM
                ,HAYAADM
                ,HAYASADM
                ,HAYALLA
                ,HAYASLLA
                ,PERFGCCBANKIA
                ,PERFGCCLIBERBANK
                ,GESTOADM
                ,GESTIAFORM
                ,HAYAGESTADMT
                ,GESTOCED
                ,GESTOPLUS
                ,GESTOPDV
                ,HAYAPROV
                ,HAYACERTI
                ,HAYACONSU
                ,HAYASUPER
                ,HAYAGESTCOM
                ,HAYASUPCOM
                ,HAYAGOLDTREE
                ,FVDNEGOCIO
                ,FVDBACKOFERTA
                ,FVDBACKVENTA
                ,SUPFVD
                ,GESRES
                ,SUPRES
                ,GESMIN
                ,SUPMIN
                ,GESPROV
                ,GESTSUE
                ,GESTEDI
                ,VALORACIONES
                ,PMSVVC
                ,FTI
                ,HAYAGESTFORMADM
		,APROBCERB
                ,SUPERFORM
                ,SUPERGESTACT
                ,SUPERADMIN
                ,SUPERPUBLI
                ,SUPERMIDDLE
                ,SUPERFRONT
                ,SUPERPLANIF
                ,GTOPOSTV
=======
             HAYAGESTADM
			,HAYASUPADM
			,HAYAGESACT
			,HAYASUPACT
			,HAYACAL
			,HAYASUPCAL
			,HAYAGESTPREC
			,HAYASUPPREC
			,HAYAGESTPUBL
			,HAYASUPPUBL
			,HAYAFSV
			,HAYAGBOINM
			,HAYASBOINM
			,HAYAGBOFIN
			,HAYASBOFIN
			,HAYAGESTCOMRET
			,HAYASUPCOMRET
			,HAYAGESTCOMSIN
			,HAYASUPCOMSIN
			,HAYAGESTFORM
			,HAYASUPFORM
			,HAYAADM
			,HAYASADM
			,HAYALLA
			,HAYASLLA
			,PERFGCCBANKIA
			,PERFGCCLIBERBANK
			,GESTOADM
			,GESTIAFORM
			,HAYAGESTADMT
			,GESTOCED
			,GESTOPLUS
			,GESTOPDV
			,HAYAPROV
			,HAYACERTI
			,HAYACONSU
			,HAYASUPER
			,HAYAGESTCOM
			,HAYASUPCOM
            ,HAYAGOLDTREE
			,FVDNEGOCIO
			,FVDBACKOFERTA
			,FVDBACKVENTA
			,SUPFVD
			,GESRES
			,SUPRES
			,GESMIN
			,SUPMIN
            ,GESPROV
			,GESTSUE
			,GESTEDI
            ,VALORACIONES
			,PMSVVC
>>>>>>> parent of 9b3ebdf... HREOS-5530 - Nueva Gestoría GTOPOSTV en SP_PERFILADO y TMP_FUN_PEF
               )
            )
          )
          SELECT FUN.FUN_ID, PEF.PEF_ID
          FROM PERFILES
          JOIN '||V_ESQUEMA||'.PEF_PERFILES PEF ON PEF.PEF_CODIGO = PERFIL
          JOIN '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN ON FUN.FUN_DESCRIPCION = FUNCION
          WHERE INCLUIR = ''S''
          MINUS
          SELECT FUN_ID, PEF_ID FROM '||V_ESQUEMA||'.FUN_PEF
        )
      '
      ;
      EXECUTE IMMEDIATE V_SQL;

      DBMS_OUTPUT.PUT_LINE('  [INFO] PERFILADOS DADOS DE ALTA - '||SQL%ROWCOUNT||'');

    ELSE
      DBMS_OUTPUT.PUT_LINE('  [INFO] LA TABLA '||V_ESQUEMA|| '.'||V_TABLA_TMP||'... NO EXISTE.');
    END IF;

   COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(SQLERRM);
    ROLLBACK;
    RAISE;

END;

/

EXIT


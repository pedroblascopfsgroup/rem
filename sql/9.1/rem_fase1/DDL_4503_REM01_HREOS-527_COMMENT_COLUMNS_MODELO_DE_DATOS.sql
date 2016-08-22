--/*
--#########################################
--## AUTOR=Pablo Meseguer 
--## FECHA_CREACION=20160526
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-527
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir descripciones a los campos de todas las tablas del modelo de datos.
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.    
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	

   DBMS_OUTPUT.PUT_LINE('[INICIO]');
   
   -- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_ACTIVO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_ACTIVO');
          
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_NUM_ACTIVO IS ''Código identificador único del activo en HAYA.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_NUM_ACTIVO_REM IS ''Código identificador único del activo en REM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_NUM_ACTIVO_UVEM IS ''Código identificador único del activo en UVEM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_NUM_ACTIVO_SAREB IS ''Código identificador único del activo en SAREB.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_NUM_ACTIVO_PRINEX IS ''Código identificador único del activo en PRINEX.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_RECOVERY_ID IS ''Codigo identificador unico del bien en RECOVERY.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.BIE_ID IS ''Codigo identificador unico del bien en REM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_DESCRIPCION IS ''Descripción del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.DD_RTG_ID IS ''Valoración del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.DD_TPA_ID IS ''Tipo de activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.DD_SAC_ID IS ''Subtipo activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.DD_EAC_ID IS ''Estado del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.DD_TUD_ID IS ''Uso (destino) del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.DD_TTA_ID IS ''Catalogación del tipo de título del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.DD_STA_ID IS ''Catalogación del subtipo de título del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.DD_CRA_ID IS ''Entidad / Cartera.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.DD_ENO_ID IS ''Entidad origen de la operación financiera.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.DD_ENO_ORIGEN_ANT_ID IS ''Entidad origen anterior de la operación financiera.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.DD_SCM_ID IS ''Situación comercial del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_DIVISION_HORIZONTAL IS ''Indicador de si el activo está en división horizontal.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_FECHA_REV_CARGAS IS ''Última fecha de revisión de las cargas del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_CON_CARGAS IS ''Indicador de si el activo tiene cargas.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_GESTION_HRE IS ''Indicador control de gestión por Haya.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_VPO IS ''Indicador de si el activo es de vpo o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_LLAVES_NECESARIAS IS ''Indicador de si son necesarias las llaves o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_LLAVES_HRE IS ''Indicador de si las llaves están en poder de HRE o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_LLAVES_FECHA_RECEP IS ''Fecha de recepción de las llaves.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_LLAVES_NUM_JUEGOS IS ''Número total de juegos que se dispone de la llave.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_ADMISION IS ''Estado de admisión departamento de Admisión.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_GESTION IS ''Estado de gestión departamento de Gestión.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.ACT_SELLO_CALIDAD IS ''Indicador estado calidad.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.SDV_ID IS ''Código identificador único de SUBDIVISION.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.CPR_ID IS ''Código identificador único de COMUNIDAD DE PROPIETARIOS.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ACTIVO.BORRADO IS ''Indicador de borrado.''';

	DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_ACTIVO');
	       
	------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_ICO_INFO_COMERCIAL       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_ICO_INFO_COMERCIAL');
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.ICO_ID IS ''Código identificador único de la información comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.DD_UAC_ID IS ''Tipo de ubicación del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.DD_ECT_ID IS ''Estado de construcción del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.DD_ECV_ID IS ''Estado de conservación del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.DD_TIC_ID IS ''Tipo Información Comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.ICO_MEDIADOR_ID IS ''Código mediador (proveedor de tipo mediador) único.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.ICO_DESCRIPCION IS ''Descripción comercial del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.ICO_ANO_CONSTRUCCION IS ''Año de construcción del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.ICO_ANO_REHABILITACION IS ''Año de rehabilitación del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.ICO_APTO_PUBLICIDAD IS ''Indicador de si es apto para valla publicitaria o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.ICO_ACTIVOS_VINC IS ''Descripción de los números de activos vinculados al activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.ICO_FECHA_EMISION_INFORME IS ''Fecha emisión del informe comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.ICO_FECHA_ULTIMA_VISITA IS ''Fecha última visita al activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.ICO_FECHA_ACEPTACION IS ''Fecha aceptación del informe del mediador.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.ICO_FECHA_RECHAZO IS ''Fecha rechazo del informe del mediador.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.ICO_CONDICIONES_LEGALES IS ''Descipción de las condiciones legales del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL.BORRADO IS ''Indicador de borrado.''';
  
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_ICO_INFO_COMERCIAL');   
         
         
	------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_EDI_EDIFICIO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_EDI_EDIFICIO');     
	   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_ID IS ''Código identificador único del edificio.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.ICO_ID IS ''Código identificador único de la información comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.DD_ECV_ID IS ''Estado de conservación del edificio del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.DD_TPF_ID IS ''Tipo de fachada del edificio del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_ANO_REHABILITACION IS ''Año de rehabilitación del edificio del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_NUM_PLANTAS IS ''Número de plantas del edificio del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_ASCENSOR IS ''Indicador de si el edificio tiene ascensor o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_NUM_ASCENSORES IS ''Número de ascensores del edificio del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_REFORMA_FACHADA IS ''Indicador de si el edificio requiere reforma en la fachada o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_REFORMA_ESCALERA IS ''Indicador de si el edificio requiere reforma en la escalera o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_REFORMA_PORTAL IS ''Indicador de si el edificio requiere reforma en el portal o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_REFORMA_ASCENSOR IS ''Indicador de si el edificio requiere reforma del ascensor o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_REFORMA_CUBIERTA IS ''Indicador de si el edificio requiere reforma en  la cubierta o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_REFORMA_OTRA_ZONA IS ''Indicador de si el edificio requiere reforma en otras zonas comunes o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_REFORMA_OTRO IS ''Indicador de si el edificio requiere otro tipo de reforma o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_REFORMA_OTRO_DESC IS ''Descripción de otro tipo de reforma que requiera el edificio del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_DESCRIPCION IS ''Descripción del edificio.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_ENTORNO_INFRAESTRUCTURA IS ''Descripción del entorno de infraestructuras.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_ENTORNO_COMUNICACION IS ''Descripción del entorno de comunicación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.BORRADO IS ''Indicador de borrado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO.EDI_REFORMA_OTRO_ZONA_COM_DES IS ''Descripción de otro tipo de reforma que requiera la zona comun del edificio del activo.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_EDI_EDIFICIO');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_VIV_VIVIENDA       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_VIV_VIVIENDA');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.ICO_ID IS ''Código identificador único de la información comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.DD_TPV_ID IS ''Catalogación del tipo de vivienda del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.DD_TPO_ID IS ''Catalogación del tipo de orientación del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.DD_TPR_ID IS ''Catalogación del tipo de renta del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.VIV_ULTIMA_PLANTA IS ''Indicador de si la vivienda está en la última planta o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.VIV_NUM_PLANTAS_INTERIOR IS ''Número de plantas interiores de la vivienda.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.VIV_REFORMA_CARP_INT IS ''Indicador de si la vivienda requiere reforma de carpintería interior o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.VIV_REFORMA_CARP_EXT IS ''Indicador de si la vivienda requiere reforma de carpintería exterior o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.VIV_REFORMA_COCINA IS ''Indicador de si la vivienda requiere reforma de la cocina o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.VIV_REFORMA_BANYO IS ''Indicador de si la vivienda requiere reforma de la cocina o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.VIV_REFORMA_SUELO IS ''Indicador de si la vivienda requiere reforma del suelo o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.VIV_REFORMA_PINTURA IS ''Indicador de si la vivienda requiere reforma de pintura o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.VIV_REFORMA_INTEGRAL IS ''Indicador de si la vivienda requiere reforma integral o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.VIV_REFORMA_OTRO IS ''Indicador de si la vivienda requiere otro tipo de reforma o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.VIV_REFORMA_OTRO_DESC IS ''Descripción de otro tipo de reforma que requiera el activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.VIV_REFORMA_PRESUPUESTO IS ''Presupuesto total estimado de las reformas de la vivienda.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA.VIV_DISTRIBUCION_TXT IS ''Descripción para la web de la distribución interior de la vivienda.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_VIV_VIVIENDA'); 
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_DIS_DISTRIBUCION       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_DIS_DISTRIBUCION');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION.DIS_ID IS ''Código identificador único de la distribución.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION.ICO_ID IS ''Código identificador único de la información comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION.DIS_NUM_PLANTA IS ''Número de planta del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION.DD_TPH_ID IS ''Catalogación del tipo de habitáculo (estancia) de la planta del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION.DIS_CANTIDAD IS ''Cantidad de habitáculos (estancias) de un tipo en la planta del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION.DIS_SUPERFICIE IS ''Superficie en metros de cada habitáculo (estancia) en cada planta del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_DIS_DISTRIBUCION');  
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_LCO_LOCAL_COMERCIAL       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_LCO_LOCAL_COMERCIAL');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL.ICO_ID IS ''Código identificador único de la información comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL.LCO_MTS_FACHADA_PPAL IS ''Longitud en metros de la fachada a calle principal del local comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL.LCO_MTS_FACHADA_LAT IS ''Longitud en metros de la fachada a calles laterales del local comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL.LCO_MTS_LUZ_LIBRE IS ''Longitud en metros de la luz libre entre pilares del local comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL.LCO_MTS_ALTURA_LIBRE IS ''Longitud en metros de altura libre del local comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL.LCO_MTS_LINEALES_PROF IS ''Longitud en metros de profundidad del local comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL.LCO_DIAFANO IS ''Indicador de si el local comercial es diáfano o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL.LCO_USO_IDONEO IS ''Descripción del uso idóneo del local comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL.LCO_USO_ANTERIOR IS ''Descripción del uso anterior del local comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL.LCO_OBSERVACIONES IS ''Descripción del local comercial.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_LCO_LOCAL_COMERCIAL');  
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_APR_PLAZA_APARCAMIENTO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_APR_PLAZA_APARCAMIENTO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_APR_PLAZA_APARCAMIENTO.ICO_ID IS ''Código identificador único de la información comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_APR_PLAZA_APARCAMIENTO.APR_DESTINO_COCHE IS ''Indicador de si se trata de una plaza de aparcamiento para coche o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_APR_PLAZA_APARCAMIENTO.APR_DESTINO_MOTO IS ''Indicador de si se trata de una plaza de aparcamiento para motos o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_APR_PLAZA_APARCAMIENTO.APR_DESTINO_DOBLE IS ''Indicador de si se trata de una plaza de aparcamiento doble o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_APR_PLAZA_APARCAMIENTO.DD_TUA_ID IS ''Catalogación del tipo de ubicación del aparcamiento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_APR_PLAZA_APARCAMIENTO.DD_TCA_ID IS ''Catalogación del tipo de calidad del aparcamiento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_APR_PLAZA_APARCAMIENTO.APR_ANCHURA IS ''Longitud en metros de la anchura del aparcamiento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_APR_PLAZA_APARCAMIENTO.APR_PROFUNDIDAD IS ''Longitud en metros de la profundidad del aparcamiento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_APR_PLAZA_APARCAMIENTO.APR_FORMA_IRREGULAR IS ''Indicador de si el aparcamiento tiene forma irregular o no.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_APR_PLAZA_APARCAMIENTO');  
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_CRI_CARPINTERIA_INT       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_CRI_CARPINTERIA_INT');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.CRI_ID IS ''Código identificador único de la carpintería interior.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.ICO_ID IS ''Código identificador único de la información comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.DD_ACR_ID IS ''Nivel de acabado interior.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.CRI_PTA_ENT_NORMAL IS ''Indicador del estado de la puerta de la entrada normal.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.CRI_PTA_ENT_BLINDADA IS ''Indicador del estado de la puerta de la entrada blindada.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.CRI_PTA_ENT_ACORAZADA IS ''Indicador del estado de la puerta de la entrada acorazada.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.CRI_PTA_PASO_MACIZAS IS ''Indicador del estado de las puertas de paso macizas.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.CRI_PTA_PASO_HUECAS IS ''Indicador del estado de las puertas de paso huecas.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.CRI_PTA_PASO_LACADAS IS ''Indicador del estado de las puertas de paso lacadas.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.CRI_ARMARIOS_EMPOTRADOS IS ''Indicador  si existen armarios empotrados.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.CRI_CRP_INT_OTROS IS ''Descripción de otro tipo de calidad relacionado con la carpintería interior.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRI_CARPINTERIA_INT.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_CRI_CARPINTERIA_INT');  
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_CRE_CARPINTERIA_EXT       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_CRE_CARPINTERIA_EXT');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.CRE_ID IS ''Código identificador único de la carpintería exterior.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.ICO_ID IS ''Código identificador único de la información comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.CRE_VTNAS_HIERRO IS ''Indicador del estado de las ventanas de hierro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.CRE_VTNAS_ALU_ANODIZADO IS ''Indicador del estado de las ventanas de aluminio anodizado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.CRE_VTNAS_ALU_LACADO IS ''Indicador del estado de las ventanas de aluminio lacado en blanco.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.CRE_VTNAS_PVC IS ''Indicador del estado de las ventanas de PVC.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.CRE_VTNAS_MADERA IS ''Indicador del estado de las ventanas de madera.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.CRE_PERS_PLASTICO IS ''Indicador del estado de las persianas de plástico.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.CRE_PERS_ALU IS ''Indicador del estado de las persianas de aluminio.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.CRE_VTNAS_CORREDERAS IS ''Indicador del estado de las ventanas correderas.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.CRE_VTNAS_ABATIBLES IS ''Indicador del estado de las ventanas abatibles.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.CRE_VTNAS_OSCILOBAT IS ''Indicador del estado de las ventanas oscilobatientes.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.CRE_DOBLE_CRISTAL IS ''Ventanas de doble acristalamiento o climalit.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.CRE_EST_DOBLE_CRISTAL IS ''Indicador del estado de las ventanas de doble acristalamiento o climalit.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.CRE_CRP_EXT_OTROS IS ''Descripción de otro tipo de calidad relacionado con la carpintería exterior.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRE_CARPINTERIA_EXT.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_CRE_CARPINTERIA_EXT');  
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_PRV_PARAMENTO_VERTICAL       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_PRV_PARAMENTO_VERTICAL');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.PRV_ID IS ''Código identificador único del paramento vertical.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.ICO_ID IS ''Código identificador único de la información comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.PRV_HUMEDAD_PARED IS ''Indicador de si el activo tiene humedades en las paredes.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.PRV_HUMEDAD_TECHO IS ''Indicador de si el activo tiene humedades en el techo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.PRV_GRIETA_PARED IS ''Indicador de si el activo tiene grietas en las paredes.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.PRV_GRIETA_TECHO IS ''Indicador de si el activo tiene grietas en el techo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.PRV_GOTELE IS ''Indicador del estado de la pintura de tipo gotelet en pared.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.PRV_PLASTICA_LISA IS ''Indicador del estado de la pintura de tipo plástica liso en pared.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.PRV_PAPEL_PINTADO IS ''Indicador del estado de la pintura de tipo papel pintado en pared.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.PRV_PINTURA_LISA_TECHO IS ''Indicador de si el activo dispone de pintura lisa en el techo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.PRV_PINTURA_LISA_TECHO_EST IS ''Indicador del estado de la pintura lisa en techos.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.PRV_MOLDURA_ESCAYOLA IS ''Indicador de si el activo dispone moldura de escayola en el techo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.PRV_MOLDURA_ESCAYOLA_EST IS ''Indicador del estado de la moldura de escayola.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.PRV_PARAMENTOS_OTROS IS ''Descripción de otro tipo de calidad relacionado con los paramentos verticales.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRV_PARAMENTO_VERTICAL.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_PRV_PARAMENTO_VERTICAL');  
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_SOL_SOLADO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_SOL_SOLADO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SOL_SOLADO.SOL_ID IS ''Código identificador único de solado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SOL_SOLADO.ICO_ID IS ''Código identificador único de la información comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SOL_SOLADO.SOL_TARIMA_FLOTANTE IS ''Indicador del estado del suelo de tarima flotante.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SOL_SOLADO.SOL_PARQUE IS ''Indicador del estado del suelo de parquet.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SOL_SOLADO.SOL_MARMOL IS ''Indicador del estado del suelo de mármol.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SOL_SOLADO.SOL_PLAQUETA IS ''Indicador del estado del suelo de plaqueta.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SOL_SOLADO.SOL_SOLADO_OTROS IS ''Descripción de otro tipo de calidad relacionado con los suelos.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SOL_SOLADO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SOL_SOLADO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SOL_SOLADO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SOL_SOLADO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SOL_SOLADO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SOL_SOLADO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SOL_SOLADO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SOL_SOLADO.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_SOL_SOLADO');  
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_INF_INFRAESTRUCTURA       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_INF_INFRAESTRUCTURA');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_ID IS ''Código identificador único de infraestructura.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.ICO_ID IS ''Código identificador único de la información comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_OCIO IS ''Indicador de si el activo dispone de centros de ocio cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_HOTELES IS ''Indicador de si el activo dispone de hoteles cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_HOTELES_DESC IS ''Descripción de los hoteles que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_TEATROS IS ''Indicador de si el activo dispone de teatros cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_TEATROS_DESC IS ''Descripción de los teatros que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_SALAS_CINE IS ''Indicador de si el activo dispone de salas de cine cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_SALAS_CINE_DESC IS ''Descripción de las salas de cine que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_INST_DEPORT IS ''Indicador de si el activo dispone de instalaciones deportivas cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_INST_DEPORT_DESC IS ''Descripción de las instalaciones deportivas que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_CENTROS_COMERC IS ''Indicador de si el activo dispone de centros comerciales cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_CENTROS_COMERC_DESC IS ''Descripción de los centros comerciales que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_OCIO_OTROS IS ''Descripción de otros centros de ocio cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_CENTROS_EDU IS ''Indicador de si el activo dispone de centros educativos cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_ESCUELAS_INF IS ''Indicador de si el activo dispone de escuelas infantiles cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_ESCUELAS_INF_DESC IS ''Descripción de las escuelas infantiles que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_COLEGIOS IS ''Indicador de si el activo dispone de colegios cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_COLEGIOS_DESC IS ''Descripción de los colegios que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_INSTITUTOS IS ''Indicador de si el activo dispone de institutos cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_INSTITUTOS_DESC IS ''Descripción de los institutos que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_UNIVERSIDADES IS ''Indicador de si el activo dispone de universidades cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_UNIVERSIDADES_DESC IS ''Descripción de las universidades que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_CENTROS_EDU_OTROS IS ''Descripción de otros centros educativos que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_CENTROS_SANIT IS ''Indicador de si el activo dispone de centros sanitarios cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_CENTROS_SALUD IS ''Indicador de si el activo dispone de centros de salud cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_CENTROS_SALUD_DESC IS ''Descripción de los centros de salud que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_CLINICAS IS ''Indicador de si el activo dispone de clínicas cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_CLINICAS_DESC IS ''Descripción de las clínicas que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_HOSPITALES IS ''Indicador de si el activo dispone de hospitales cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_HOSPITALES_DESC IS ''Descripción de los hospitales que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_CENTROS_SANIT_OTROS IS ''Descripción de los centros sanitarios que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_PARKING_SUP_SUF IS ''Indicador de si el activo dispone de parking en superficie suficiente.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_COMUNICACIONES IS ''Indicador de si el activo está bien comunicado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_FACIL_ACCESO IS ''Indicador de si el activo dispone de fácil acceso por carretera.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_FACIL_ACCESO_DESC IS ''Descripción de los hoteles que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_LINEAS_BUS IS ''Indicador de si el activo dispone de líneas de autobuses cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_LINEAS_BUS_DESC IS ''Descripción de las líneas de autobús que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_METRO IS ''Indicador de si el activo dispone de líneas de metro cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_METRO_DESC IS ''Descripción de las paradas de metro que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_EST_TREN IS ''Indicador de si el activo dispone de estaciones de tren cerca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_EST_TREN_DESC IS ''Descripción de las estaciones de tren que se encuentran cerca del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.INF_COMUNICACIONES_OTRO IS ''Descripción de otras comunicaciones que dispone el activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INF_INFRAESTRUCTURA.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_INF_INFRAESTRUCTURA');  
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_ZCO_ZONA_COMUN       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_ZCO_ZONA_COMUN');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.ZCO_ID IS ''Código identificador único de la zona común.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.ICO_ID IS ''Código identificador único de la información comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.ZCO_ZONAS_COMUNES IS ''Indicador de si el activo dispone de zonas comunes.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.ZCO_JARDINES IS ''Indicador de si el activo dispone de jardines o zonas verdes.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.ZCO_PISCINA IS ''Indicador de si el activo dispone de piscina.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.ZCO_INST_DEP IS ''Indicador de si el activo dispone de instalaciones deportivas.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.ZCO_PADEL IS ''Indicador de si el activo dispone de pista de padel.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.ZCO_TENIS IS ''Indicador de si el activo dispone de pista de tenis.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.ZCO_PISTA_POLIDEP IS ''Indicador de si el activo dispone de pista polideportiva.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.ZCO_OTROS IS ''Descripción de otras instalaciones deportivas que dispone el activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.ZCO_ZONA_INFANTIL IS ''Indicador de si el activo dispone de zona infantil o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.ZCO_CONSERJE_VIGILANCIA IS ''Indicador de si el activo dispone de conserje de vigilancia o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.ZCO_GIMNASIO IS ''Indicador de si el activo dispone de gimnasio o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.ZCO_ZONA_COMUN_OTROS IS ''Descripción de otras zonas comunes que dispone el activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_ZCO_ZONA_COMUN');  
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_INS_INSTALACION       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_INS_INSTALACION');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_ID IS ''Código identificador único de la instalación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.ICO_ID IS ''Código identificador único de la información comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_ELECTR IS ''Indicador de si el activo dispone de instalación eléctrica.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_ELECTR_CON_CONTADOR IS ''Indicador de si el activo dispone de instalación eléctrica con contador.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_ELECTR_BUEN_ESTADO IS ''Indicador de si el activo dispone de instalación eléctrica en buen estado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_ELECTR_DEFECTUOSA_ANTIGUA IS ''Indicador de si el activo dispone de instalación eléctrica defectuosa o muy antiguas.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_AGUA IS ''Indicador de si el activo dispone de instalación de agua.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_AGUA_CON_CONTADOR IS ''Indicador de si el activo dispone de instalación de agua con contador.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_AGUA_BUEN_ESTADO IS ''Indicador de si el activo dispone de instalación de agua en buen estado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_AGUA_DEFECTUOSA_ANTIGUA IS ''Indicador de si el activo dispone de instalación de agua defectuosa o antigua.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_AGUA_CALIENTE_CENTRAL IS ''Indicador de si el activo dispone de instalación de agua caliente central.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_AGUA_CALIENTE_GAS_NATURAL IS ''Indicador de si el activo dispone de instalación de agua caliente con gas natural.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_GAS IS ''Indicador de si el activo dispone de instalación de gas.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_GAS_CON_CONTADOR IS ''Indicador de si el activo dispone de instalación de gas con contador.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_GAS_INST_BUEN_ESTADO IS ''Indicador de si el activo dispone de instalación de gas en buen estado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_GAS_DEFECTUOSA_ANTIGUA IS ''Indicador de si el activo dispone de instalación de gas defectuosa o antigua.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_CALEF IS ''Indicador de si el activo dispone de instalación de calefacción.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_CALEF_CENTRAL IS ''Indicador de si el activo dispone de instalación de calefacción central.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_CALEF_GAS_NATURAL IS ''Indicador de si el activo dispone de instalación de calefacción de gas natural.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_CALEF_RADIADORES_ALU IS ''Indicador de si el activo dispone de instalación de calefacción con radiadores de aluminio.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_CALEF_PREINSTALACION IS ''Indicador de si el activo dispone de preinstalación de calefacción.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_AIRE IS ''Indicador de si el activo dispone de instalación de aire acondicionado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_AIRE_PREINSTALACION IS ''Indicador de si el activo dispone de preinstalación de aire acondicionado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_AIRE_INSTALACION IS ''Indicador de si el activo dispone de instalación de aire acondicionado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_AIRE_FRIO_CALOR IS ''Indicador de si el activo dispone de instalación de aire acondicionado de frio/calor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.INS_INST_OTROS IS ''Descripción de otras instalaciones que dispone el activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_INS_INSTALACION.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_INS_INSTALACION');  
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_BNY_BANYO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_BNY_BANYO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_ID IS ''Código identificador único del baño.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.ICO_ID IS ''Código identificador único de la información comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_DUCHA_BANYERA IS ''Indicador de si el activo dispone de ducha o bañera.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_DUCHA IS ''Indicador del estado de la ducha del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_BANYERA IS ''Indicador del estado de la bañera del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_BANYERA_HIDROMASAJE IS ''Indicador del estado de la bañera de hidromasaje del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_COLUMNA_HIDROMASAJE IS ''Indicador del estado de la columna de hidromasaje del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_ALICATADO_MARMOL IS ''Indicador del estado del alicatado en mármol del baño del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_ALICATADO_GRANITO IS ''Indicador del estado del alicatado en granito del baño del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_ALICATADO_AZULEJO IS ''Indicador del estado del alicatado en azulejo del baño del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_ENCIMERA IS ''Indicador de si el activo dispone encimera en el baño.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_MARMOL IS ''Indicador del estado de la encimera de mármol del baño del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_GRANITO IS ''Indicador del estado de la encimera de granito del baño del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_OTRO_MATERIAL IS ''Indicador del estado de la encimera de otro material del baño del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_SANITARIOS IS ''Indicador de si el activo dispone sanitarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_SANITARIOS_EST IS ''Indicador del estado de los sanitarios del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_SUELOS IS ''Indicador del estado del suelo de los baños del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_GRIFO_MONOMANDO IS ''Indicador de si el activo dispone de grifo monomando.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_GRIFO_MONOMANDO_EST IS ''Indicador del estado de la grifería con monomando del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BNY_BANYO_OTROS IS ''Descripción de otras calidades asociadas a los baños del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_BNY_BANYO.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_BNY_BANYO');  
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_COC_COCINA       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_COC_COCINA');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_ID IS ''Código identificador único de cocina.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.ICO_ID IS ''Código identificador único de la información comercial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_AMUEBLADA IS ''Indicador de si el activo dispone de cocina amueblada.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_AMUEBLADA_EST IS ''Indicador del estado de la cocina amueblada del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_ENCIMERA IS ''Indicador de si el activo dispone de encimera en la cocina.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_ENCI_GRANITO IS ''Indicador del estado de la encimera de granito de la cocina del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_ENCI_MARMOL IS ''Indicador del estado de la encimera de mármol de la cocina del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_ENCI_OTRO_MATERIAL IS ''Indicador del estado de la encimera de otro material de la cocina del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_VITRO IS ''Indicador del estado de la vitrocerámica de la cocina del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_LAVADORA IS ''Indicador del estado de la lavadora del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_FRIGORIFICO IS ''Indicador del estado del frigorífico del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_LAVAVAJILLAS IS ''Indicador del estado del lavavajillas del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_MICROONDAS IS ''Indicador del estado del microondas del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_HORNO IS ''Indicador del estado del horno del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_SUELOS IS ''Indicador del estado del suelo de la cocina del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_AZULEJOS IS ''Indicador de si el activo dispone de azulejos en la cocina.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_AZULEJOS_EST IS ''Indicador del estado de los azulejos de la cocina del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_GRIFOS_MONOMANDO IS ''Indicador de si el activo dispone de grifos monomando en la cocina.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_GRIFOS_MONOMANDO_EST IS ''Indicador del estado de los grifos monomando de la cocina del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.COC_COCINA_OTROS IS ''Descripción de otras calidades asociadas a la cocina.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_COC_COCINA.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_COC_COCINA');  
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_AOB_ACTIVO_OBS       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_AOB_ACTIVO_OBS');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AOB_ACTIVO_OBS.AOB_ID IS ''Código identificador único de la observación del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AOB_ACTIVO_OBS.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AOB_ACTIVO_OBS.USU_ID IS ''Identificador único del usuario de recovery que será gestor del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AOB_ACTIVO_OBS.AOB_OBSERVACION IS ''Descripción de la observación del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AOB_ACTIVO_OBS.AOB_FECHA IS ''Fecha de creación de la observación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AOB_ACTIVO_OBS.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AOB_ACTIVO_OBS.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AOB_ACTIVO_OBS.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AOB_ACTIVO_OBS.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AOB_ACTIVO_OBS.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AOB_ACTIVO_OBS.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AOB_ACTIVO_OBS.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AOB_ACTIVO_OBS.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_AOB_ACTIVO_OBS');  
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_AGR_AGRUPACION       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_AGR_AGRUPACION');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.AGR_ID IS ''Código identificador único de la agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.DD_TAG_ID IS ''Tipo de agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.AGR_NOMBRE IS ''Nombre descriptivo de la agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.AGR_DESCRIPCION IS ''Descripción breve de la agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.AGR_NUM_AGRUP_REM IS ''Código identificador único de la agrupacion en REM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.AGR_NUM_AGRUP_UVEM IS ''Código identificador único de la agrupacion en UVEM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.AGR_FECHA_ALTA IS ''Fecha de creación de la agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.AGR_ELIMINADO IS ''Indicador de si la agrupación ha sido dada de baja o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.AGR_FECHA_BAJA IS ''Fecha de baja de la agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.AGR_URL IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.AGR_PUBLICADO IS ''Indicador de si la agrupación ha sido publicada en la web o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.AGR_SEG_VISITAS IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.AGR_TEXTO_WEB IS ''Texto descriptivo para la web.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.AGR_ACT_PRINCIPAL IS ''Código identificador único del activo principal en UVEM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.AGR_GESTOR_ID IS ''Código gestor de la agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.AGR_MEDIADOR_ID IS ''Código mediador de la agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_AGR_AGRUPACION');  
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_RES_RESTRINGIDA       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_RES_RESTRINGIDA');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_RES_RESTRINGIDA.AGR_ID IS ''Código identificador único de la agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_RES_RESTRINGIDA.DD_PRV_ID IS ''Provincia de la agrupación de lote restringido.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_RES_RESTRINGIDA.DD_LOC_ID IS ''Localidad (municipio)  de la agrupación de lote restringido.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_RES_RESTRINGIDA.RES_DIRECCION IS ''Dirección de la agrupación de lote restringido.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_RES_RESTRINGIDA.RES_CP IS ''Código postal de la agrupación de lote restringido.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_RES_RESTRINGIDA.RES_ACREEDOR_PDV IS ''Acreedor de la agrupación de lote restringido.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_RES_RESTRINGIDA');  
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_ONV_OBRA_NUEVA       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_ONV_OBRA_NUEVA');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ONV_OBRA_NUEVA.AGR_ID IS ''Código identificador único de la agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ONV_OBRA_NUEVA.DD_PRV_ID IS ''Provincia de la agrupación de obra nueva.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ONV_OBRA_NUEVA.DD_LOC_ID IS ''Localidad (municipio) de la agrupación de obra nueva.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ONV_OBRA_NUEVA.DD_EON_ID IS ''Estado de la agrupación de obra nueva.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ONV_OBRA_NUEVA.ONV_DIRECCION IS ''Dirección de la agrupación de obra nueva.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ONV_OBRA_NUEVA.ONV_CP IS ''Código postal de la agrupación de obra nueva.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ONV_OBRA_NUEVA.ONV_ACREEDOR_PDV IS ''Acreedor de la agrupación de obra nueva.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_ONV_OBRA_NUEVA');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_AGO_AGRUPACION_OBS       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_AGO_AGRUPACION_OBS');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGO_AGRUPACION_OBS.AGO_ID IS ''Código identificador único de las observaciones agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGO_AGRUPACION_OBS.AGR_ID IS ''Código identificador único de la agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGO_AGRUPACION_OBS.USU_ID IS ''Identificador único del usuario de recovery que será gestor del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGO_AGRUPACION_OBS.AGO_OBSERVACION IS ''Descripción de la observación de la agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGO_AGRUPACION_OBS.AGO_FECHA IS ''Fecha de creación de la observación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGO_AGRUPACION_OBS.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGO_AGRUPACION_OBS.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGO_AGRUPACION_OBS.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGO_AGRUPACION_OBS.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGO_AGRUPACION_OBS.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGO_AGRUPACION_OBS.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGO_AGRUPACION_OBS.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGO_AGRUPACION_OBS.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_AGO_AGRUPACION_OBS');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_AGA_AGRUPACION_ACTIVO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_AGA_AGRUPACION_ACTIVO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO.AGA_ID IS ''Código identificador único del activo agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO.AGR_ID IS ''Código identificador único de la agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO.AGA_FECHA_INCLUSION IS ''Fecha inclusión en la agrupación del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO.AGA_PRINCIPAL IS ''Indicador del activo principal dentro de la agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_AGA_AGRUPACION_ACTIVO');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_ADO_ADMISION_DOCUMENTO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_ADO_ADMISION_DOCUMENTO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.ADO_ID IS ''Código identificador único de admisión documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.CFD_ID IS ''Código identificador unico de config documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.DD_EDC_ID IS ''Estado de documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.ADO_APLICA IS ''Indicador si aplica o no obligatoriedad al documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.ADO_NUM_DOC IS ''Número del documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.ADO_FECHA_VERIFICADO IS ''Fecha verificación  del documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.ADO_FECHA_SOLICITUD IS ''Fecha solicitud del documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.ADO_FECHA_EMISION IS ''Fecha emisión del documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.ADO_FECHA_OBTENCION IS ''Fecha obtención del documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.ADO_FECHA_CADUCIDAD IS ''Fecha caducidad del documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.ADO_FECHA_ETIQUETA IS ''Fecha etiqueta del documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.ADO_FECHA_CALIFICACION IS ''Fecha calificación energética del documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.DD_TCE_ID IS ''Calificación energética documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_ADO_ADMISION_DOCUMENTO');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_ADA_ADJUNTO_ACTIVO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_ADA_ADJUNTO_ACTIVO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.ADA_ID IS ''Código identificador único de adjunto activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.DD_TPD_ID IS ''Tipo de documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.ADJ_ID IS ''Localizador/clave/ruta del documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.ADA_NOMBRE IS ''Nombre descriptivo del documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.ADA_CONTENT_TYPE IS ''Tipo de contenido del documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.ADA_LENGTH IS ''Tamaño en bytes del documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.ADA_DESCRIPCION IS ''Descripción breve del documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.ADA_FECHA_DOCUMENTO IS ''Fecha de subida del documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.BORRADO IS ''Indicador de borrado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO.ADA_ID_DOCUMENTO_REST IS ''''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_ADA_ADJUNTO_ACTIVO');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_FOT_FOTO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_FOT_FOTO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.FOT_ID IS ''Código identificador único de la foto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.AGR_ID IS ''Código identificador único de agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.SDV_ID IS ''Código identificador único de subdivisión activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.ADJ_ID IS ''Código identificador único de adjunto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.DD_TFO_ID IS ''Tipo de foto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.FOT_NOMBRE IS ''Nombre descriptivo de la foto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.FOT_CONTENT_TYPE IS ''Tipo de contenido del documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.FOT_LENGTH IS ''Tamaño en bytes de la foto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.FOT_DESCRIPCION IS ''Descripción breve de la foto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.FOT_FECHA_DOCUMENTO IS ''Fecha de subida de la foto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.FOT_PRINCIPAL IS ''Indicador de si la foto es principal o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.FOT_INT_EXT IS ''Indicador de si la foto es de interior o de exterior.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.FOT_VIDEO IS ''Indicador de si la foto es video o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.FOT_PLANO IS ''Indicador de si la foto es un plano o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.FOT_ORDEN IS ''Número indicador del orden de visualización de la foto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_FOT_FOTO.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_FOT_FOTO');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_TBJ_TRABAJO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_TBJ_TRABAJO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_ID IS ''Código identificador único de trabajo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.ACT_ID IS ''Código identificador único de activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.AGR_ID IS ''Código identificador único de agrupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_NUM_TRABAJO IS ''Numero Trabajo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.PVC_ID IS ''Código identificador único de proveedor contacto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.USU_ID IS ''Código identificador único de usuario.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.DD_TTR_ID IS ''Tipo de trabajo solicitado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.DD_STR_ID IS ''Subtipo de trabajo solicitado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.DD_EST_ID IS ''Estado trabajo solicitado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_DESCRIPCION IS ''Descripción del trabajo solicitado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_FECHA_SOLICITUD IS ''Fecha solicitud del trabajo solicitado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_FECHA_APROBACION IS ''Fecha aprobación del trabajo solicitado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_FECHA_INICIO IS ''Fecha real de inicio del trabajo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_FECHA_FIN IS ''Fecha real de finalización del trabajo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_CONTINUO_OBSERVACIONES IS ''Observaciones trabajo continuo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_FECHA_FIN_COMPROMISO IS ''Fecha compromiso del trabajo solicitado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_FECHA_TOPE IS ''Fecha tope del trabajo solicitado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_FECHA_HORA_CONCRETA IS ''Fecha con hora concreta de finalización del trabajo solicitado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_URGENTE IS ''Indicador si el trabajo es urgente  o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_CON_RIESGO_TERCEROS IS ''Indicador si el trabajo es con riesgo a terceros o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_CUBRE_SEGURO IS ''Indicador si el trabajo lo cubre el seguro o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_CIA_ASEGURADORA IS ''Compañía aseguradora.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.DD_TCA_ID IS ''Tipo de calidad del trabajo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_TERCERO_NOMBRE IS ''Nombre trabajo a terceros.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_TERCERO_EMAIL IS ''Email trabajo a terceros.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_TERCERO_DIRECCION IS ''Dirección trabajo a terceros.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_TERCERO_CONTACTO IS ''Contacto trabajo a terceros.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_TERCERO_TEL1 IS ''Teléfono 1 trabajo a terceros.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_TERCERO_TEL2 IS ''Teléfono 2 trabajo a terceros.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_IMPORTE_PENAL_DIARIO IS ''Importe penalización diario.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_OBSERVACIONES IS ''Observaciones.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_IMPORTE_TOTAL IS ''Importe total del trabajo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_TARIFICADO IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_FECHA_RECHAZO IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_MOTIVO_RECHAZO IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_FECHA_ELECCION_PROVEEDOR IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_FECHA_EJECUTADO IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_FECHA_ANULACION IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_FECHA_VALIDACION IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_FECHA_CIERRE_ECONOMICO IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.TBJ_FECHA_PAGO IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_TBJ_TRABAJO');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_EJE_EJERCICIO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_EJE_EJERCICIO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO.EJE_ID IS ''Código identificador único del ejercicio.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO.EJE_ANYO IS ''Año del ejercicio del presupuesto (YYYY).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO.EJE_FECHAINI IS ''Fecha inicio del ejercicio del presupuesto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO.EJE_FECHAFIN IS ''Fecha fin del ejercicio del presupuesto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO.EJE_DESCRIPCION IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_EJE_EJERCICIO');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_PTO_PRESUPUESTO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_PTO_PRESUPUESTO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO.PTO_ID IS ''Código identificador único del presupuesto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO.EJE_ID IS ''Código identificador único del ejercicio.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO.PTO_IMPORTE_INICIAL IS ''Importe del presupuesto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO.PTO_FECHA_ASIGNACION IS ''Fecha asignación del presupuesto al ejercicio.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_PTO_PRESUPUESTO');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_PRT_PRESUPUESTO_TRABAJO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_PRT_PRESUPUESTO_TRABAJO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.PRT_ID IS ''Código identificador único del presupuesto trabajo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.TBJ_ID IS ''Código identificador único del trabajo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.PVE_ID IS ''Código identificador único del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.DD_ESP_ID IS ''Estado presupuesto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.PRT_IMPORTE IS ''Importe presupuesto trabajo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.PRT_FECHA IS ''Fecha presupuesto trabajo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.PRT_REPARTIR_PROPORCIONAL IS ''Indicador si el el reparto es proporcional.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.PRT_COMENTARIOS IS ''Comentarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.BORRADO IS ''Indicador de borrado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO.PRT_REF_PRESUPUESTO_PROVEEDOR IS ''''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_PRT_PRESUPUESTO_TRABAJO');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_PVE_PROVEEDOR       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_PVE_PROVEEDOR');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.PVE_ID IS ''Código identificador único del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.DD_TPR_ID IS ''Tipo de proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.PVE_COD_UVEM IS ''Código proveedor único UVEM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.PVE_NOMBRE IS ''Nombre proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.PVE_NOMBRE_COMERCIAL IS ''Nombre comercial del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.DD_TDI_ID IS ''Tipo documento del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.PVE_DOCIDENTIF IS ''Número de documento identificativo del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.DD_ZNG_ID IS ''Zona geográfica proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.DD_PRV_ID IS ''Provincia del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.DD_LOC_ID IS ''Localidad (municipio)  del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.PVE_CP IS ''Codigo postal del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.PVE_DIRECCION IS ''Dirección del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.PVE_TELF1 IS ''Número de teléfono 1 del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.PVE_TELF2 IS ''Número de teléfono 2 del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.PVE_FAX IS ''Fax del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.PVE_EMAIL IS ''Email del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.PVE_PAGINA_WEB IS ''WEB del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.PVE_FRANQUICIA IS ''Indicador si el proveedor es franquicia o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.PVE_IVA_CAJA IS ''Indicador si el proveedor tiene IVA con criterio en caja o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.PVE_NUM_CUENTA IS ''Datos domiciliación bancaria.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_PVE_PROVEEDOR');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_PVC_PROVEEDOR_CONTACTO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_PVC_PROVEEDOR_CONTACTO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.PVC_ID IS ''Código identificador único del proveedor contacto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.PVE_ID IS ''Código identificador único del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.DD_PRV_ID IS ''Provincia del contacto del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.USU_ID IS ''Código identificador único del usuario.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.DD_TDI_ID IS ''Tipo documento del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.PVC_DOCIDENTIF IS ''Número de documento identificativo del contacto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.PVC_NOMBRE IS ''Nombre contacto proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.PVC_APELLID01 IS ''Apellido 1 del contacto del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.PVC_APELLID02 IS ''Apellido 2 del contacto del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.PVC_CP IS ''Codigo postal del contacto del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.PVC_DIRECCION IS ''Dirección del contacto del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.PVC_TELF1 IS ''Número de teléfono 1 del contacto del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.PVC_TELF2 IS ''Número de teléfono 2 del contacto del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.PVC_FAX IS ''Fax del contacto del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.PVC_EMAIL IS ''Email del contacto del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_PVC_PROVEEDOR_CONTACTO');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_ETP_ENTIDAD_PROVEEDOR       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_ETP_ENTIDAD_PROVEEDOR');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR.ETP_ID IS ''Código identificador único de la entidad proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR.DD_CRA_ID IS ''Entidad / Cartera del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR.PVE_ID IS ''Código identificador único del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR.DD_TCL_ID IS ''Tipo colaboración del proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR.ETP_FECHA_CONTRATO IS ''Fecha contrato con proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR.ETP_FECHA_INICIO IS ''Fecha desde.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR.ETP_FECHA_FIN IS ''Fecha hasta.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR.ETP_ESTADO IS ''Estado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_ETP_ENTIDAD_PROVEEDOR');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_PAC_PROPIETARIO_ACTIVO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_PAC_PROPIETARIO_ACTIVO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO.PAC_ID IS ''Código identificador único del propietario activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO.PRO_ID IS ''Código identificador único del propietario.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO.DD_TGP_ID IS ''Tipo grado propiedad.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO.PAC_PORC_PROPIEDAD IS ''Porcentaje de propiedad del propietario.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_PAC_PROPIETARIO_ACTIVO');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_PRO_PROPIETARIO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_PRO_PROPIETARIO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_ID IS ''Código identificador único del propietario.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.DD_LOC_ID IS ''Localidad del propietario.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.DD_PRV_ID IS ''Provincia del propietario.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_CODIGO_UVEM IS ''Identificador único del propietario en UVEM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.DD_TPE_ID IS ''Tipo de propietario.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_NOMBRE IS ''Nombre del propietario del activo o denominación social.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_APELLIDO1 IS ''Apellido 1 del propietario del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_APELLIDO2 IS ''Apellido 2 del propietario del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.DD_TDI_ID IS ''Tipo documento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_DOCIDENTIF IS ''Número de documento identificativo del propietario.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_DIR IS ''Dirección del propietario.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_TELF IS ''Teléfono del propietario.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_EMAIL IS ''Dirección de correo electrónico del propietario.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_CP IS ''Código postal del propietario.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.DD_LOC_ID_CONT IS ''Localidad de la persona de contacto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.DD_PRV_ID_CONT IS ''Provincia de la persona de contacto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_CONTACTO_NOM IS ''Nombre de la persona de contacto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_CONTACTO_TELF1 IS ''Teléfono 1 de la persona de contacto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_CONTACTO_TELF2 IS ''Teléfono 2 de la persona de contacto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_CONTACTO_EMAIL IS ''Dirección de correo electrónico de la persona de contacto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_CONTACTO_DIR IS ''Dirección de la persona de contacto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_CONTACTO_CP IS ''Código postal de la persona de contacto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_OBSERVACIONES IS ''Observaciones referentes al propietario del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.PRO_PAGA_EJECUTANTE IS ''Indicador de si el pagador es el ejecutante.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO.BORRADO IS ''Indicador de borrado.''';


   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_PRO_PROPIETARIO');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_PSU_PROVISION_SUPLIDO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_PSU_PROVISION_SUPLIDO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO.PSU_ID IS ''Código identificador único de provisión suplido.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO.TBJ_ID IS ''Código identificador único del trabajo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO.DD_TAD_ID IS ''Tipo Adelanto trabajo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO.PSU_CONCEPTO IS ''Concepto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO.PSU_IMPORTE IS ''Importe presupuesto trabajo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO.PSU_FECHA IS ''Fecha presupuesto trabajo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_PSU_PROVISION_SUPLIDO');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_TRA_TRAMITE       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_TRA_TRAMITE');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.TRA_ID IS ''Código identificador único del trámite.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.TBJ_ID IS ''Código identificador único del trabajo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.DD_TPO_ID IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.DD_EPR_ID IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.TRA_TRA_ID IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.TRA_DECIDIDO IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.TRA_PROCESS_BPM IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.TRA_PARALIZADO IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.TRA_PLAZO_PARALIZ_MILS IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.TRA_FECHA_PARALIZADO IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.TRA_FECHA_INICIO IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.TRA_FECHA_FIN IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.BORRADO IS ''Indicador de borrado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TRA_TRAMITE.DD_TAC_ID IS ''Tipo Actuación.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_TRA_TRAMITE');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE TAC_TAREAS_ACTIVOS       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE TAC_TAREAS_ACTIVOS');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS.TAR_ID IS ''Código identificador único de la tarea.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS.TRA_ID IS ''Código identificador único del trámite.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS.USU_ID IS ''Código identificador único del usuario.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS.SUP_ID IS ''Código identificador único del supervisor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE TAC_TAREAS_ACTIVOS');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_LLV_LLAVE       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_LLV_LLAVE');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.LLV_ID IS ''Código identificador único de la llave.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.LLV_COD_CENTRO IS ''Código del centro de llaves donde se ubica el manojo de llaves del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.LLV_NOMBRE_CENTRO IS ''Nombre del centro de llaves donde se ubica el manojo de llaves del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.LLV_ARCHIVO1 IS ''Código o número de la posición 1 en la que se encuentra el manojo de las llaves del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.LLV_ARCHIVO2 IS ''Código o número de la posición 2 en la que se encuentra el manojo de las llaves del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.LLV_ARCHIVO3 IS ''Código o número de la posición 3 en la que se encuentra el manojo de las llaves del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.LLV_COMPLETO IS ''Indicador manojo completo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.LLV_MOTIVO_INCOMPLETO IS ''Indicar motivo por el que el manojo no está completo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LLV_LLAVE.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_LLV_LLAVE');  
   
   
   ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_MLV_MOVIMIENTO_LLAVE       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_MLV_MOVIMIENTO_LLAVE');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE.MLV_ID IS ''Código identificador único del movimiento llave.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE.LLV_ID IS ''Código identificador único de la llave.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE.DD_TTE_ID IS ''Tipo Tenedor del manojo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE.MLV_COD_TENEDOR IS ''Código Tenedor del manojo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE.MLV_NOM_TENEDOR IS ''Nombre del tenedor de la llave del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE.MLV_FECHA_ENTREGA IS ''Fecha entrega  del manojo de llaves.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE.MLV_FECHA_DEVOLUCION IS ''Fecha devolución del manojo de llaves.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_MLV_MOVIMIENTO_LLAVE');  
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_SPS_SIT_POSESORIA       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_SPS_SIT_POSESORIA');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.SPS_ID IS ''Código identificador único de la situación posesoria.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.DD_TPO_ID IS ''Tipo de título posesorio.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.SPS_FECHA_REVISION_ESTADO IS ''Última fecha de revisión del estado posesorio del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.SPS_FECHA_TOMA_POSESION IS ''Fecha de toma de posesión del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.SPS_OCUPADO IS ''Indicador de si el activo está ocupado o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.SPS_CON_TITULO IS ''Indicador de si el activo dispone de título.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.SPS_RIESGO_OCUPACION IS ''Indicador de si el activo tiene riesgo de ocupación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.SPS_FECHA_TITULO IS ''Fecha del título posesorio.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.SPS_FECHA_VENC_TITULO IS ''Fecha de vencimiento del título posesorio.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.SPS_RENTA_MENSUAL IS ''Importe de renta mensual del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.SPS_FECHA_SOL_DESAHUCIO IS ''Fecha de solicitud de desahucio.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.SPS_FECHA_LANZAMIENTO IS ''Fecha de señalamiento de lanzamiento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.SPS_FECHA_LANZAMIENTO_EFECTIVO IS ''Fecha de lanzamiento efectuado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.SPS_ACC_TAPIADO IS ''Indicador acceso al activo está tapiado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.SPS_FECHA_ACC_TAPIADO IS ''Fecha acceso al activo está tapiado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.SPS_ACC_ANTIOCUPA IS ''Indicador acceso al activo está con puerta antiocupa.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.SPS_FECHA_ACC_ANTIOCUPA IS ''Fecha acceso al activo está con puerta antiocupa.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_SPS_SIT_POSESORIA'); 
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_OLE_OCUPANTE_LEGAL       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_OLE_OCUPANTE_LEGAL');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL.OLE_ID IS ''Código identificador único del ocupante legal.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL.SPS_ID IS ''Código identificador único de la situación posesoria.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL.OLE_NOMBRE IS ''Nombre y apellidos del ocupante legal del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL.OLE_NIF IS ''Nif del ocupante legal del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL.OLE_EMAIL IS ''Email del ocupante legal del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL.OLE_TELF IS ''Teléfono del ocupante legal del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL.OLE_OBS IS ''Observaciones sobre la cuota de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_OLE_OCUPANTE_LEGAL'); 
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_CAT_CATASTRO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_CAT_CATASTRO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.CAT_ID IS ''Código identificador único del catastro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.CAT_REF_CATASTRAL IS ''Referencia catastral del activo en UVEM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.CAT_POLIGONO IS ''Código del polígono del catastro de rústica antiguo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.CAT_PARCELA IS ''Código de la parcela del catastro de rústica antiguo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.CAT_TITULAR_CATASTRAL IS ''Nombre del titular de la referencia catastral.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.CAT_SUPERFICIE_CONSTRUIDA IS ''Superficie construida en metros cuadrados.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.CAT_SUPERFICIE_UTIL IS ''Superficie útil en metros cuadrados.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.CAT_SUPERFICIE_REPER_COMUN IS ''Superficie con repercusión en elementos comunes en metros cuadrados.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.CAT_SUPERFICIE_PARCELA IS ''Superficie parcela en metros cuadrados.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.CAT_SUPERFICIE_SUELO IS ''Superficie suelo en metros cuadrados.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.CAT_VALOR_CATASTRAL_CONST IS ''Valor catastral de construcción.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.CAT_VALOR_CATASTRAL_SUELO IS ''Valor catastral de suelo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.CAT_FECHA_REV_VALOR_CATASTRAL IS ''Fecha revisión valor catastral.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CAT_CATASTRO.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_CAT_CATASTRO'); 
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_ADM_INF_ADMINISTRATIVA       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_ADM_INF_ADMINISTRATIVA');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ADM_ID IS ''Código identificador único de la información administrativa.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.DD_TVP_ID IS ''Tipo de vpo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ADM_SUELO_VPO IS ''Indicador de si el activo puede ser vpo o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ADM_PROMOCION_VPO IS ''Indicador de si el activo puede ser promocionado a vpo o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ADM_NUM_EXPEDIENTE IS ''Número de expediente/vpo/vpt.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ADM_FECHA_CALIFICACION IS ''Fecha de calificación vpo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ADM_OBLIGATORIO_SOL_DEV_AYUDA IS ''Indicador de si el activo requiere que se realice solicitud para la devolución de ayudas o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ADM_OBLIG_AUT_ADM_VENTA IS ''Indicador de si el activo requiere una autorización administrativa para la venta o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ADM_DESCALIFICADO IS ''Indicador de si el activo esta descalificado o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ADM_MAX_PRECIO_VENTA IS ''Precio máximo de venta vpo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ADM_OBSERVACIONES IS ''Observaciones sobre la información administrativa.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ADM_SUJETO_A_EXPEDIENTE IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ADM_ORGANISMO_EXPROPIANTE IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ADM_FECHA_INI_EXPEDIENTE IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ADM_REF_EXPDTE_ADMIN IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ADM_REF_EXPDTE_INTERNO IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.ADM_OBS_EXPROPIACION IS ''''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_ADM_INF_ADMINISTRATIVA'); 
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_CCP_CUOTA_COM_PROP       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_CCP_CUOTA_COM_PROP');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CCP_CUOTA_COM_PROP.CCP_ID IS ''Código identificador único de la cuota de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CCP_CUOTA_COM_PROP.CPR_ID IS ''Código identificador único de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CCP_CUOTA_COM_PROP.CCP_COD_CUOTA_UVEM IS ''Código de la cuota de la comunidad de propietarios en UVEM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CCP_CUOTA_COM_PROP.DD_TPC_ID IS ''Tipo de cuota de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CCP_CUOTA_COM_PROP.CCP_CONCEPTO_CUOTA IS ''Concepto de la cuota.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CCP_CUOTA_COM_PROP.CCP_FECHA_EMISION IS ''Fecha de emisión de la cuota de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CCP_CUOTA_COM_PROP.CCP_PAGADA IS ''Indicador de si la cuota está pagada o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CCP_CUOTA_COM_PROP.CCP_OBSERVACIONES IS ''Observaciones sobre la cuota de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CCP_CUOTA_COM_PROP.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CCP_CUOTA_COM_PROP.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CCP_CUOTA_COM_PROP.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CCP_CUOTA_COM_PROP.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CCP_CUOTA_COM_PROP.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CCP_CUOTA_COM_PROP.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CCP_CUOTA_COM_PROP.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CCP_CUOTA_COM_PROP.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_CCP_CUOTA_COM_PROP'); 
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_CPR_COM_PROPIETARIOS       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_CPR_COM_PROPIETARIOS');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_ID IS ''Código identificador único de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_COD_COM_PROP_UVEM IS ''Código identificador único de la comunidad de propietarios en UVEM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_CONSTITUIDA IS ''Indicador de si la comunidad de propietarios está constituida o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_NOMBRE IS ''Nombre de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_NIF IS ''Documento identificativo de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_DIRECCION IS ''Dirección de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_NUM_CUENTA IS ''Número de cuenta completo de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_PRESIDENTE_NOMBRE IS ''Nombre del presidente de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_PRESIDENTE_TELF IS ''Número de teléfono del presidente de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_PRESIDENTE_TELF2 IS ''Número de teléfono 2 del presidente de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_PRESIDENTE_EMAIL IS ''Email del presidente de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_PRESIDENTE_DIR IS ''Dirección del presidente de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_PRESIDENTE_FECHA_INI IS ''Fecha inicio de presidencia de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_PRESIDENTE_FECHA_FIN IS ''Fecha fin de presidencia de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_ADMINISTRADOR_NOMBRE IS ''Nombre del administrador de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_ADMINISTRADOR_TELF IS ''Número de teléfono del administrador de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_ADMINISTRADOR_TELF2 IS ''Número de teléfono 2 del administrador de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_ADMINISTRADOR_DIR IS ''Dirección del administrador de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_ADMINISTRADOR_EMAIL IS ''Email del administrador de la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_IMPORTEMEDIO IS ''Importe medio de cuota a aportar a la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_ESTATUTOS IS ''Indicador de si la comunidad de propietarios dispone o no de la documentación asociada a los estatutos.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_LIBRO_EDIFICIO IS ''Indicador de si la comunidad de propietarios dispone o no de la documentación asociada al libro del edificio.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_CERTIFICADO_ITE IS ''Indicador de si la comunidad de propietarios dispone o no de la documentación asociada al certificado de Inspección Técnica del Edificio.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.CPR_OBSERVACIONES IS ''Observaciones sobre la comunidad de propietarios.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_CPR_COM_PROPIETARIOS'); 
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_ADN_ADJNOJUDICIAL       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_ADN_ADJNOJUDICIAL');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.ADN_ID IS ''Código identificador único de adjudicación no judicial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.DD_EEJ_ID IS ''Entidad ejecutante de la hipoteca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.ADN_FECHA_TITULO IS ''Fecha del título.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.ADN_FECHA_FIRMA_TITULO IS ''Fecha de firma del título.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.ADN_VALOR_ADQUISICION IS ''Valor de adquisición (no adjudicado) del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.ADN_TRAMITADOR_TITULO IS ''Nombre del tramitador del título.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.ADN_NUM_REFERENCIA IS ''Protocolo, autos o número de expediente.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_ADN_ADJNOJUDICIAL'); 
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_AJD_ADJJUDICIAL       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_AJD_ADJJUDICIAL');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.AJD_ID IS ''Código identificador único de adjudicación judicial.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.BIE_ADJ_ID IS ''Código identificador único del bien asociado al activo REM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.DD_JUZ_ID IS ''Juzgado que adjudicó el activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.DD_PLA_ID IS ''Plaza del juzgado que adjudicó el activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.DD_EDJ_ID IS ''Estado de adjudicación el activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.DD_EEJ_ID IS ''Entidad ejecutante de la hipoteca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.AJD_FECHA_ADJUDICACION IS ''Fecha de adjudicación del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.AJD_NUM_AUTO IS ''Número de auto en el que se adjudicó el activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.AJD_PROCURADOR IS ''Nombre del procurador que intervino en el proceso de adjudicación del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.AJD_LETRADO IS ''Nombre del letrado que intervino en el proceso de adjudicación del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.AJD_ID_ASUNTO IS ''Código identificador único del asunto en recovery.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_AJD_ADJJUDICIAL'); 
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_PDV_PLAN_DIN_VENTAS       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_PDV_PLAN_DIN_VENTAS');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS.PDV_ID IS ''Código identificador único de plan din ventas.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS.PDV_ACREEDOR_NOMBRE IS ''Nombre del acreedor del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS.PDV_ACREEDOR_CODIGO IS ''Código del acreedor del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS.PDV_ACREEDOR_NIF IS ''Nif del acreedor del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS.PDV_ACREEDOR_DIR IS ''Dirección del acreedor del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS.PDV_IMPORTE_DEUDA IS ''Importe deuda.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_PDV_PLAN_DIN_VENTAS.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_PDV_PLAN_DIN_VENTAS'); 
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_TIT_TITULO       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_TIT_TITULO');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.TIT_ID IS ''Código identificador único del título.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.DD_ETI_ID IS ''Estado del título de activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.TIT_FECHA_ENTREGA_GESTORIA IS ''Fecha de entrega del título en gestoría.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.TIT_FECHA_PRESENT_HACIENDA IS ''Fecha presentación del título en hacienda.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.TIT_FECHA_ENVIO_AUTO IS ''Fecha de envío del auto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.TIT_FECHA_PRESENT1_REG IS ''Fecha primera presentación del título en registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.TIT_FECHA_PRESENT2_REG IS ''Fecha segunda presentación del título en registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.TIT_FECHA_INSC_REG IS ''Fecha inscripción del título en registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.TIT_FECHA_RETIRADA_REG IS ''Fecha retirada del título en registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.TIT_FECHA_NOTA_SIMPLE IS ''Fecha de nota simple.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TIT_TITULO.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_TIT_TITULO'); 
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_VAL_VALORACIONES       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_VAL_VALORACIONES');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES.VAL_ID IS ''Código identificador único de la valoración.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES.DD_TPC_ID IS ''Tipo de precio.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES.VAL_IMPORTE IS ''Importe  valoración.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES.VAL_FECHA_INICIO IS ''Fecha inicio valoración.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES.VAL_FECHA_FIN IS ''Fecha fin valoración.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_VAL_VALORACIONES'); 
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_REG_INFO_REGISTRAL       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_REG_INFO_REGISTRAL');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.REG_ID IS ''Código identificador único de la información registral.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.BIE_DREG_ID IS ''Código identificador único del bien asociado al activo REM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.REG_IDUFIR IS ''Código idufir del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.REG_NUM_DEPARTAMENTO IS ''Número de departamento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.REG_HAN_CAMBIADO IS ''Indicador de si han cambiado los datos registrales del activo o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.DD_LOC_ID_ANTERIOR IS ''Municipio de registro anterior del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.REG_NUM_ANTERIOR IS ''Número de registro anterior del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.REG_NUM_FINCA_ANTERIOR IS ''Número de finca anterior del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.REG_SUPERFICIE_UTIL IS ''Superficie útil del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.REG_SUPERFICIE_ELEM_COMUN IS ''Superficie con repercusión de elementos comunes del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.REG_SUPERFICIE_PARCELA IS ''Superficie parcela del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.REG_SUPERFICIE_BAJO_RASANTE IS ''Superficie bajo rasante del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.REG_SUPERFICIE_SOBRE_RASANTE IS ''Superficie sobre rasante del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.REG_DIV_HOR_INSCRITO IS ''Indicador de si el activo está inscrito en división horizontal o no.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.DD_EDH_ID IS ''Estado de la división horizontal del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.DD_EON_ID IS ''Estado de obra nueva del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.REG_FECHA_CFO IS ''Fecha de obtención certificado final de obra.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_REG_INFO_REGISTRAL'); 
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_LOC_LOCALIZACION       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_LOC_LOCALIZACION');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION.LOC_ID IS ''Código identificador único de la localización.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION.BIE_LOC_ID IS ''Código identificador único del bien asociado al activo REM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION.DD_TUB_ID IS ''Tipo de ubicación del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION.LOC_LONGITUD IS ''Coordenada de longitud en decimal de la ubicación del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION.LOC_LATITUD IS ''Coordenada de latitud en decimal de la ubicación del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION.LOC_DIST_PLAYA IS ''Distancia a la playa (en m).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_LOC_LOCALIZACION'); 
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_CRG_CARGAS       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_CRG_CARGAS');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.CRG_ID IS ''Código identificador único de la carga.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.BIE_CAR_ID IS ''Código identificador único del bien asociado al activo REM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.DD_TCA_ID IS ''Tipo de carga del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.DD_STC_ID IS ''Subtipo de carga del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.CRG_DESCRIPCION IS ''Descripción corta de la carga.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.CRG_ORDEN IS ''Número identificador del orden de la carga.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.CRG_FECHA_CANCEL_REGISTRAL IS ''Fecha cancelación registral.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_CRG_CARGAS'); 
   
   
    ------------------------------------------------------------------------------
	
	-- AÑADIMOS COMENTARIOS A LOS CAMPOS DE ACT_TAS_TASACION       
   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DE ACT_TAS_TASACION');     
   
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_ID IS ''Código identificador único de la tasación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.BIE_VAL_ID IS ''Código identificador único del bien asociado al activo REM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.DD_TTS_ID IS ''Tipo de tasación del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_FECHA_INI_TASACION IS ''Fecha de inicio de la tasación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_FECHA_RECEPCION_TASACION IS ''Fecha de recepción de la tasación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_CODIGO_FIRMA IS ''Código de la firma tasadora.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_NOMBRE_TASADOR IS ''Nombre del tasador.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_IMPORTE_TAS_FIN IS ''Importe tasación finalizado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_COSTE_REPO_NETO_ACTUAL IS ''Coste reposición neto actual.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_COSTE_REPO_NETO_FINALIZADO IS ''Coste reposición neto finalizado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_COEF_MERCADO_ESTADO IS ''Coeficiente de mercado estado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_COEF_POND_VALOR_ANYADIDO IS ''Coeficiente ponderación valor añadido.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_VALOR_REPER_SUELO_CONST IS ''Valor repercusión suelo construido.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_COSTE_CONST_CONST IS ''Coste construcción construido.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_INDICE_DEPRE_FISICA IS ''Índice depreciación física.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_INDICE_DEPRE_FUNCIONAL IS ''Índice depreciación funcional.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_INDICE_TOTAL_DEPRE IS ''Índice total depreciación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_COSTE_CONST_DEPRE IS ''Coste construcción depreciada.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_COSTE_UNI_REPO_NETO IS ''Coste unitario reposición neto.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_COSTE_REPOSICION IS ''Coste reposición.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_PORCENTAJE_OBRA IS ''Porcentaje de obra.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_IMPORTE_VALOR_TER IS ''Importe valor terminado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_ID_TEXTO_ASOCIADO IS ''Identificador de texto asociado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_IMPORTE_VAL_LEGAL_FINCA IS ''Importe valor legal finca.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_IMPORTE_VAL_SOLAR IS ''Importe valor solar.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.TAS_OBSERVACIONES IS ''Observaciones referentes a la tasación.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.VERSION IS ''Indica la version del registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_TAS_TASACION.BORRADO IS ''Indicador de borrado.''';

   
   DBMS_OUTPUT.PUT_LINE('[INFO] FIN DEL PROCESO, DE ACTUALIZACION DE ACT_TAS_TASACION'); 
    
   COMMIT;
   
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

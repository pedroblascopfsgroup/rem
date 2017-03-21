package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.factory.AltaActivoFactoryApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoAltaActivoFinanciero;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.service.AltaActivoService;
import es.pfsgroup.plugin.rem.service.TabActivoService;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

@Component
public class MSVAltaActivosProcesar implements MSVLiberator {

    protected final Log logger = LogFactory.getLog(getClass());
    
	@Autowired
	private ApiProxyFactory proxyFactory;
		
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private AltaActivoFactoryApi altaActivoFactoryApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private UpdaterStateApi updaterState;
	
	//Posicion fija de Columnas excel, para cualquier referencia por posicion
	public static final class COL_NUM {
		static final int DATOS_PRIMERA_FILA				= 4;
		
		static final int NUM_ACTIVO_HAYA 				= 0;
		static final int COD_CARTERA 					= 1;
		static final int NUM_ACTIVO_CARTERA				= 2;  //(UVEM, PRINEX, SAREB)
		static final int NUM_BIEN_RECOVERY				= 3;
		static final int ID_ASUNTO_RECOVERY				= 4;
		static final int TIPO_ACTIVO					= 5;
		static final int SUBTIPO_ACTIVO					= 6;
		static final int ESTADO_FISICO					= 7;
		static final int USO_DOMINANTE					= 8;
		static final int DESC_ACTIVO					= 9;

		static final int TIPO_VIA						= 10;
		static final int NOMBRE_VIA						= 11;
		static final int NUM_VIA 						= 12;
		static final int ESCALERA 						= 13;
		static final int PLANTA 						= 14;
		static final int PUERTA 						= 15;
		static final int PROVINCIA 						= 16;
		static final int MUNICIPIO 						= 17;
		static final int UNIDAD_MUNICIPIO 				= 18;
		static final int CODPOSTAL 						= 19;

 		static final int TIPO_COMER 					= 20;
 		static final int DESTINO_COMER 					= 21;
 		static final int TIPO_ALQUILER 					= 22;

 		static final int NUM_EXP_RIESGO_ASOCIADO		= 23;
 		static final int ESTADO_EXP_RIESGO 				= 24;
 		static final int TIPO_PRODUCTO					= 25;
 		static final int NIF_SOCIEDAD_ACREEDORA			= 26;
 		static final int NOMBRE_SOCIEDAD_ACREEDORA		= 27;
 		static final int NUM_SOCIEDAD_ACREEDORA			= 28;
 		static final int IMPORTE_DEUDA 					= 29;

 		static final int PROV_REGISTRO 					= 30;
 		static final int POBL_REGISTRO 					= 31;
 		static final int NUM_REGISTRO 					= 32;
 		static final int TOMO 							= 33;
 		static final int LIBRO 							= 34;
 		static final int FOLIO 							= 35;
 		static final int FINCA 							= 36;
 		static final int IDUFIR_CRU 					= 37;
 		static final int SUPERFICIE_CONSTRUIDA_M2 		= 38;
 		static final int SUPERFICIE_UTIL_M2 			= 39;
 		static final int SUPERFICIE_REPERCUSION_EE_CC 	= 40;
 		static final int PARCELA 						= 41; // (INCLUIDA OCUPADA EDIFICACIÓN)
 		static final int ES_INTEGRADO_DIV_HORIZONTAL	= 42;

 		static final int NIF_PROPIETARIO 				= 43;
 		static final int NOMBRE_PROPIETARIO 			= 44;
 		static final int GRADO_PROPIEDAD 				= 45;
 		static final int PERCENT_PROPIEDAD 				= 46;

 		static final int REF_CATASTRAL 					= 47;
 		static final int VPO 							= 48;

 		static final int VIVIENDA_NUM_PLANTAS 			= 49;
 		static final int VIVIENDA_NUM_BANYOS 			= 50;
 		static final int VIVIENDA_NUM_ASEOS 			= 51;
 		static final int VIVIENDA_NUM_DORMITORIOS 		= 52;
		static final int ES_LOCAL_CON_GARAJE_TRASTERO 	= 53;
	};
	
	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PERIMETRO_ACTIVO.equals(tipoOperacion.getCodigo())){
				return true;
			}else {
				return false;
			}
		}else{
			return false;
		}
	}
	
	@Override
	public Boolean liberaFichero(MSVDocumentoMasivo file) throws IllegalArgumentException, IOException {
			
		processAdapter.setStateProcessing(file.getProcesoMasivo().getId());
		MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(file);
		DtoAltaActivoFinanciero dtoAAF = new DtoAltaActivoFinanciero();
		
		try{
			// Recorre y procesa todas las filas de datos del fichero excel
			for (int fila = COL_NUM.DATOS_PRIMERA_FILA; fila < exc.getNumeroFilas(); fila++) {

				// Carga los datos de activo de la Fila excel al DTO
				dtoAAF = filaExcelToDtoAltaActivoFinanciero(exc, dtoAAF, fila);
				
				// Factoria de alta de activos -------------------------------------------------
				
				// FINANCIEROS
				AltaActivoService altaActivoService = altaActivoFactoryApi.getService(AltaActivoService.CODIGO_ALTA_ACTIVO_FINANCIERO);
				altaActivoService.procesarAlta(dtoAAF);

				
			} //Fin for
			
			return true;
			
		} catch (Exception e){
			
			logger.error(e.getMessage());
			e.printStackTrace();
			return false;
		}

	}
	
	private DtoAltaActivoFinanciero filaExcelToDtoAltaActivoFinanciero(MSVHojaExcel exc, DtoAltaActivoFinanciero dtoAAF, int fila) throws IllegalArgumentException, IOException, ParseException{
	
		// Setters DTO
		dtoAAF.setCarteraCodigo(exc.dameCelda(fila, COL_NUM.COD_CARTERA));
		
		return dtoAAF;
	}

}

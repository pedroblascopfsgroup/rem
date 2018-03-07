package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelValidator;

@Component
public class MSVExcelValidatorFactoryImpl {
	
//	public static final Long CODE_BULKUPLOAD_ID_AGRUPATION_RESTRICTED = new Long(121);
//	public static final Long CODE_BULKUPLOAD_ID_NEW_BUILDING = new Long(122);

	@Autowired
	private MSVAgrupacionRestringidoExcelValidator agrupacionRestringidoExcelValidator;
	
	@Autowired
	private MSVAgrupacionObraNuevaExcelValidator agrupacionObraNuevaExcelValidator;

	@Autowired
	private MSVAgrupacionAsistidaPDVExcelValidator agrupacionAsistidaExcelValidator;
	
	@Autowired
	private MSVAgrupacionLoteComercialExcelValidator agrupacionLoteComercialExcelValidator;
	
	@Autowired
	private MSVListadoActivosExcelValidator listadoActivosExcelValidator;
	
	@Autowired
	private MSVActualizarEstadoPublicacion actualizarEstadoPublicacion;
	
	@Autowired
	private MSVActualizarPropuestaPreciosActivo actualizarPropuestaPrecioActivo;
	
	@Autowired
	private MSVActualizarPropuestaPreciosActivoEntidad01 actualizarPropuestaPrecioActivoEntidad01;
	
	@Autowired
	private MSVActualizarPropuestaPreciosActivoEntidad02 actualizarPropuestaPrecioActivoEntidad02;
	
	@Autowired
	private MSVActualizarPropuestaPreciosActivoEntidad03 actualizarPropuestaPrecioActivoEntidad03;
	
	@Autowired
	private MSVActualizarPreciosActivoImporte actualizarPrecioActivo;
	
	@Autowired
	private MSVActualizarPreciosFSVActivoImporte actualizarPrecioFSVActivo;
	
	@Autowired
	private MSVAltaActivosExcelValidator altaActvos;
	
	@Autowired
	private MSVAltaActivosTPExcelValidator altaActivosTP;
	
	@Autowired
	private MSVActualizarPreciosActivoBloqueo actualizarBloqueoPrecioActivo;

	@Autowired
	private MSVActualizarPreciosActivoBloqueo actualizarDesbloqueoPrecioActivo;

	@Autowired
	private MSVActualizarPerimetroActivo actualizarPerimetroActivo;
	
	@Autowired
	private MSVActualizarIbiExentoActivo actualizarIbiExentoActivo;
	
	@Autowired
	private MSVAsociarActivosGasto asociarActivosGasto;
	
	@Autowired
	private MSVActualizarGestores actualizarGestores;
	
	
	public MSVExcelValidator getForTipoValidador(String codTipoOperacion) {
		
		if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPATION_RESTRICTED.equals(codTipoOperacion)) {
			return agrupacionRestringidoExcelValidator;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_NEW_BUILDING.equals(codTipoOperacion)) {
			return agrupacionObraNuevaExcelValidator;
			} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPACION_ASISTIDA.equals(codTipoOperacion)) {
				return agrupacionAsistidaExcelValidator;
			} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPACION_LOTE_COMERCIAL.equals(codTipoOperacion)) {
				return agrupacionLoteComercialExcelValidator;
			}else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ALTA_ACTIVOS_FINANCIEROS.equals(codTipoOperacion)) {
				return altaActvos;
			} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_LISTAACTIVOS.equals(codTipoOperacion)) {
				return listadoActivosExcelValidator;
			} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO.equals(codTipoOperacion)) {
				return actualizarPropuestaPrecioActivo;
			} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO_ENTIDAD01.equals(codTipoOperacion)) {
				return actualizarPropuestaPrecioActivoEntidad01;
			} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO_ENTIDAD02.equals(codTipoOperacion)) {
				return actualizarPropuestaPrecioActivoEntidad02;
			} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO_ENTIDAD03.equals(codTipoOperacion)) {
				return actualizarPropuestaPrecioActivoEntidad03;
			} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_ACTIVO_IMPORTE.equals(codTipoOperacion)) {
				return actualizarPrecioActivo;
			} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_FSV_ACTIVO_IMPORTE.equals(codTipoOperacion)) {
				return actualizarPrecioFSVActivo;
			} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_ACTIVO_BLOQUEO.equals(codTipoOperacion)) {
				return actualizarBloqueoPrecioActivo;				
			} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_ACTIVO_DESBLOQUEO.equals(codTipoOperacion)) {
				return actualizarDesbloqueoPrecioActivo;
			} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PUBLICAR_ORDINARIA.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PUBLICAR.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_OCULTARACTIVO.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESOCULTARACTIVO.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_OCULTARPRECIO.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESOCULTARPRECIO.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESPUBLICAR.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESMARCAR_PUBLICAR_FORZADO.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESMARCAR_DESPUBLICAR_FORZADO.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_AUTORIZAREDICION.equals(codTipoOperacion)){
				return actualizarEstadoPublicacion;
			} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PERIMETRO_ACTIVO.equals(codTipoOperacion)) {
				return actualizarPerimetroActivo;
			}
			else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_MARCAR_IBI_EXENTO_ACTIVO.equals(codTipoOperacion) || 
					MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_DESMARCAR_IBI_EXENTO_ACTIVO.equals(codTipoOperacion)){
				return actualizarIbiExentoActivo;
			}
			else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ASOCIAR_ACTIVOS_GASTO.equals(codTipoOperacion)){
				return asociarActivosGasto;
			}
			else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_GESTORES.equals(codTipoOperacion)){
				return actualizarGestores;
			}
			else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ALTA_ACTIVOS_THIRD_PARTY.equals(codTipoOperacion)){
				return altaActivosTP;
			}
		return null;
	}

}
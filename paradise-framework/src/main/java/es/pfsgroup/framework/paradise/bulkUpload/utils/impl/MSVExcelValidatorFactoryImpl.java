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
	private MSVListadoActivosExcelValidator listadoActivosExcelValidator;
	
	@Autowired
	private MSVActualizarEstadoPublicacion actualizarEstadoPublicacion;
	
	@Autowired
	private MSVActualizarPreciosActivoImporte actualizarPrecioActivo;
	
	@Autowired
	private MSVActualizarPreciosActivoBloqueo actualizarBloqueoPrecioActivo;

	@Autowired
	private MSVActualizarPreciosActivoBloqueo actualizarDesbloqueoPrecioActivo;

	@Autowired
	private MSVActualizarPerimetroActivo actualizarPerimetroActivo;
	
	
	public MSVExcelValidator getForTipoValidador(String codTipoOperacion) {
		
		if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPATION_RESTRICTED.equals(codTipoOperacion)) {
			return agrupacionRestringidoExcelValidator;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_NEW_BUILDING.equals(codTipoOperacion)) {
			return agrupacionObraNuevaExcelValidator;
			} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_LISTAACTIVOS.equals(codTipoOperacion)) {
				return listadoActivosExcelValidator;
			} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_ACTIVO_IMPORTE.equals(codTipoOperacion)) {
				return actualizarPrecioActivo;
			} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_ACTIVO_BLOQUEO.equals(codTipoOperacion)) {
				return actualizarBloqueoPrecioActivo;				
			} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_ACTIVO_DESBLOQUEO.equals(codTipoOperacion)) {
				return actualizarDesbloqueoPrecioActivo;
			} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PUBLICAR.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_OCULTARACTIVO.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESOCULTARACTIVO.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_OCULTARPRECIO.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESOCULTARPRECIO.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESPUBLICAR.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_AUTORIZAREDICION.equals(codTipoOperacion)){
				return actualizarEstadoPublicacion;
			} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PERIMETRO_ACTIVO.equals(codTipoOperacion)) {
				return actualizarPerimetroActivo;
			}
		return null;
	}

}

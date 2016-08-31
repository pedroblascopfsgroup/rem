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

	
	public MSVExcelValidator getForTipoValidador(String codTipoOperacion) {
		
		if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPATION_RESTRICTED.equals(codTipoOperacion)) {
			return agrupacionRestringidoExcelValidator;
		} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_NEW_BUILDING.equals(codTipoOperacion)) {
			return agrupacionObraNuevaExcelValidator;
			} else if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_LISTAACTIVOS.equals(codTipoOperacion)) {
				return listadoActivosExcelValidator;
			} else if(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PUBLICAR.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_OCULTARACTIVO.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESOCULTARACTIVO.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_OCULTARPRECIO.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESOCULTARPRECIO.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESPUBLICAR.equals(codTipoOperacion) ||
					  MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_AUTORIZAREDICION.equals(codTipoOperacion))
				return actualizarEstadoPublicacion;
		
		return null;
	}

}

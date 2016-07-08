package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelValidator;

@Component
public class MSVExcelValidatorFactoryImpl {
	
	public static final Long CODE_BULKUPLOAD_ID_AGRUPATION_RESTRICTED = new Long(121);
	public static final Long CODE_BULKUPLOAD_ID_NEW_BUILDING = new Long(122);

	@Autowired
	private MSVAgrupacionRestringidoExcelValidator agrupacionRestringidoExcelValidator;
	
	@Autowired
	private MSVAgrupacionObraNuevaExcelValidator agrupacionObraNuevaExcelValidator; 

	
	
	public MSVExcelValidator getForTipoValidador(Long idTipoOperacion) {
		
		if (CODE_BULKUPLOAD_ID_AGRUPATION_RESTRICTED.equals(idTipoOperacion)) {
			return agrupacionRestringidoExcelValidator;
		} else if (CODE_BULKUPLOAD_ID_NEW_BUILDING.equals(idTipoOperacion)) {
			return agrupacionObraNuevaExcelValidator;
		}
		
		return null;
	}

}

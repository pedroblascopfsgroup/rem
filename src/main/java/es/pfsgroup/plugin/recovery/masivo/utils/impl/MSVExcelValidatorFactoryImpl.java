package es.pfsgroup.plugin.recovery.masivo.utils.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.recovery.masivo.utils.MSVExcelValidator;

@Component
public class MSVExcelValidatorFactoryImpl {
	
	@Autowired
	private MSVValidacionPruebas validadorPruebas; 
	
	@Autowired
	private MSVAltaContratoExcelValidator altaContratosValidator;

	public MSVExcelValidator getForTipoValidador(Long idTipoOperacion) {
		if (idTipoOperacion==-10){
			return validadorPruebas;
		}else{
			return altaContratosValidator;
		}	
	}

}

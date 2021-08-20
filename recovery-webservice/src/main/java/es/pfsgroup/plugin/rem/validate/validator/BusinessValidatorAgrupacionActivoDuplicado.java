package es.pfsgroup.plugin.rem.validate.validator;

import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.validate.BusinessValidators;
import es.pfsgroup.plugin.rem.validate.impl.BusinessCommonValidatorsImpl;

@Component
public class BusinessValidatorAgrupacionActivoDuplicado extends BusinessCommonValidatorsImpl implements BusinessValidators {
    
	@Override
	public String getCodigoTipoOperacion() {
		return null;
	}
	
	@Override
	public Boolean usarValidator(String codigoTipoAgrupacion) {
		return DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA.equals(codigoTipoAgrupacion) 
				|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(codigoTipoAgrupacion)
				|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER .equals(codigoTipoAgrupacion)
				|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER.equals(codigoTipoAgrupacion);
	}

	@Override
	public String getValidationError(Activo activo, ActivoAgrupacion agrupacion) {
		
		//Este activo ya esta dentro de esta agrupación
		if (this.existsActiveInAgrupation(activo, agrupacion)) {
			return ERROR_ACTIVE_DUPLICATED;
		}
		
		return "";
	}
	


}

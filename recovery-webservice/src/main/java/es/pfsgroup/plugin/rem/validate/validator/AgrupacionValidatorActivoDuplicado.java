package es.pfsgroup.plugin.rem.validate.validator;

import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidator;
import es.pfsgroup.plugin.rem.validate.impl.AgrupacionValidatorCommonImpl;

@Component
public class AgrupacionValidatorActivoDuplicado extends AgrupacionValidatorCommonImpl implements AgrupacionValidator {
    
	
	@Override
	public String getValidationError(Activo activo, ActivoAgrupacion agrupacion) {
		
		//Este activo ya esta dentro de esta agrupación
		if (this.existsActiveInAgrupation(activo, agrupacion)) {
			return ERROR_ACTIVE_DUPLICATED;
		}
		
		return "";
	}

	@Override
	public String[] getKeys() {
		// TODO Auto-generated method stub
		return this.getCodigoTipoAgrupacion();
	}

	@Override
	public String[] getCodigoTipoAgrupacion() {
		// TODO Auto-generated method stub
		return new String[]{DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA, DDTipoAgrupacion.AGRUPACION_RESTRINGIDA, DDTipoAgrupacion.AGRUPACION_ASISTIDA, DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL, DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER, DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER, DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM};
	}
	


}

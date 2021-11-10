package es.pfsgroup.plugin.rem.validate.validator;

import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidator;
import es.pfsgroup.plugin.rem.validate.impl.AgrupacionValidatorCommonImpl;

@Component
public class AgrupacionValidatorActivoDuplicadoOtras extends AgrupacionValidatorCommonImpl implements AgrupacionValidator {
    

	@Override
	public String[] getKeys() {
		// TODO Auto-generated method stub
		return this.getCodigoTipoAgrupacion();
	}

	@Override
	public String[] getCodigoTipoAgrupacion() {
		return new String[]{DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA, DDTipoAgrupacion.AGRUPACION_RESTRINGIDA, DDTipoAgrupacion.AGRUPACION_ASISTIDA, DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL, DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_ALQUILER, DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER, DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM};
	}

	@Override
	public String getValidationError(Activo activo, ActivoAgrupacion activoAgrupacion) {
		
		//Un activo solamente puede estar en una agrupación dada de alta y de su tipo
		if (! this.isUniqueAgrupacionActivo(activo, activoAgrupacion)) {
			return ERROR_ACTIVE_DUPLICATED_OTHER_GROUP;
		}
		
		return "";
	}

}
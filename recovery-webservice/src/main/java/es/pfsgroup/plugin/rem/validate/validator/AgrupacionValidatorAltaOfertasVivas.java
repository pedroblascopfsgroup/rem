package es.pfsgroup.plugin.rem.validate.validator;

import org.springframework.stereotype.Component;

import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidator;
import es.pfsgroup.plugin.rem.validate.impl.AgrupacionValidatorCommonImpl;

@Component
public class AgrupacionValidatorAltaOfertasVivas extends AgrupacionValidatorCommonImpl implements AgrupacionValidator {
    
	
	@Override
	public String getValidationError(Activo activo, ActivoAgrupacion agrupacion) {
		
		//Este activo tiene ofertas vivas
		if (DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_OFERTA.equals(activo.getSituacionComercial().getCodigo()) || DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_RESERVA.equals(activo.getSituacionComercial().getCodigo())) {
			return ERROR_ACTIVE_LIVE_OFFERS;
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
		return new String[]{DDTipoAgrupacion.AGRUPACION_RESTRINGIDA};
	}
	


}

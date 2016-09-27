package es.pfsgroup.plugin.rem.validate.validator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBLocalizacionesBienInfo;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoAsistida;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidator;
import es.pfsgroup.plugin.rem.validate.impl.AgrupacionValidatorCommonImpl;

@Component
public class AgrupacionValidatorAsistida extends AgrupacionValidatorCommonImpl implements AgrupacionValidator  {

    @Autowired 
    private ActivoAgrupacionApi activoAgrupacionApi;
    
    @Autowired 
    private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;
    
    @Autowired 
    private ActivoApi activoApi;
    

	@Override
	public String[] getKeys() {
		return this.getCodigoTipoAgrupacion();

	}

	@Override
	public String[] getCodigoTipoAgrupacion() {		
		return new String[]{DDTipoAgrupacion.AGRUPACION_ASISTIDA};
	}
	
	@Override
	public String getValidationError(Activo activo, ActivoAgrupacion agrupacion) {
		


		ActivoAgrupacionActivo primerActivoAgrupacion = activoAgrupacionActivoApi.primerActivoPorActivoAgrupacion(agrupacion.getId());
		if (primerActivoAgrupacion == null) return "";
		Activo primerActivo = primerActivoAgrupacion.getActivo();
		if (primerActivo == null) return "";

		ActivoAsistida asistida = (ActivoAsistida) agrupacion;
		NMBLocalizacionesBienInfo pobl = activo.getLocalizacionActual();
		
		if (Checks.esNulo(asistida.getCodigoPostal())) {
			return ERROR_CP_NULL;
		} else if (!asistida.getCodigoPostal().equals(pobl.getCodPostal())) {
			return ERROR_CP_NOT_EQUAL;
		}

		if (Checks.esNulo(asistida.getProvincia())) {
			return ERROR_PROV_NULL;
		} else if (!asistida.getProvincia().equals(pobl.getProvincia())) {
			return ERROR_PROV_NOT_EQUAL;
		}
				
		if (Checks.esNulo(asistida.getLocalidad())) {
			return ERROR_LOC_NULL;
		} else if (!asistida.getLocalidad().equals(pobl.getLocalidad())) {
			return ERROR_LOC_NOT_EQUAL;
		}
		
		if (Checks.esNulo(activo.getCartera())) {
			return ERROR_CARTERA_NULL;
		} else if (!activo.getCartera().equals(primerActivo.getCartera())) {
			return ERROR_CARTERA_NOT_EQUAL;
		}		
		
		if(!Checks.esNulo(activo.getSubcartera())){
			if(!DDSubcartera.CODIGO_CAJ_ASISTIDA.equals(activo.getSubcartera().getCodigo())
					|| !DDSubcartera.CODIGO_SAR_ASISTIDA.equals(activo.getSubcartera().getCodigo())
					|| !DDSubcartera.CODIGO_BAN_ASISTIDA.equals(activo.getSubcartera().getCodigo()))
						return ERROR_NOT_ASISTIDA;
		}else{
			return ERROR_NOT_ASISTIDA;
		}
				

		
		return "";
	}
}

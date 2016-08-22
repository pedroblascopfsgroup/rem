package es.pfsgroup.plugin.rem.validate.validator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.rem.validate.impl.AgrupacionValidatorCommonImpl;
import es.pfsgroup.plugin.rem.validate.impl.BusinessCommonValidatorsImpl;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBLocalizacionesBienInfo;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoObraNueva;
import es.pfsgroup.plugin.rem.model.ActivoRestringida;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidator;
import es.pfsgroup.plugin.rem.validate.BusinessValidators;

@Component
public class AgrupacionValidatorObraNueva extends AgrupacionValidatorCommonImpl implements AgrupacionValidator  {

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
		return new String[]{DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA};
	}
	
	
	// TODO refactorizar este validador, creando validadores independientes hasta que se pueda eliminar 
	@Override
	public String getValidationError(Activo activo, ActivoAgrupacion agrupacion) {
		
		// Aplicado en AgrupacionValidatorActivoDuplicado
		//Este activo ya esta dentro de esta agrupación
		/*if (this.existsActiveInAgrupation(activo, agrupacion)) {
			return ERROR_ACTIVE_DUPLICATED;
		}*/		
		
		
		// Aplicado en AgrupacionValidatorActivoDuplicadoOtras
		//Este activo ya esta incluido dentro de otra agrupacion de OBRA NUEVA
		//(omitir cuando la agrupación esté en alguna agrupación dada de baja)
		/*if (!activoAgrupacionActivoApi.isUniqueNewBuildingActive(activo) && !activoAgrupacionActivoApi.estaAgrupacionActivoConFechaBaja(activo)) {
			return ERROR_ACTIVE_DUPLICATED_OTHER_GROUP;
		}*/

		ActivoAgrupacionActivo primerActivoAgrupacion = activoAgrupacionActivoApi.primerActivoPorActivoAgrupacion(agrupacion.getId());
		if (primerActivoAgrupacion == null) return "";
		Activo primerActivo = primerActivoAgrupacion.getActivo();
		if (primerActivo == null) return "";

		ActivoObraNueva obraNueva = (ActivoObraNueva) agrupacion;
		NMBLocalizacionesBienInfo pobl = activo.getLocalizacionActual();
		
		if (Checks.esNulo(obraNueva.getCodigoPostal())) {
			return ERROR_CP_NULL;
		} else if (!obraNueva.getCodigoPostal().equals(pobl.getCodPostal())) {
			return ERROR_CP_NOT_EQUAL;
		}

		if (Checks.esNulo(obraNueva.getProvincia())) {
			return ERROR_PROV_NULL;
		} else if (!obraNueva.getProvincia().equals(pobl.getProvincia())) {
			return ERROR_PROV_NOT_EQUAL;
		}
				
		if (Checks.esNulo(obraNueva.getLocalidad())) {
			return ERROR_LOC_NULL;
		} else if (!obraNueva.getLocalidad().equals(pobl.getLocalidad())) {
			return ERROR_LOC_NOT_EQUAL;
		}
		
		if (Checks.esNulo(activo.getCartera())) {
			return ERROR_CARTERA_NULL;
		} else if (!activo.getCartera().equals(primerActivo.getCartera())) {
			return ERROR_CARTERA_NOT_EQUAL;
		}		
		
		return "";
	}
}

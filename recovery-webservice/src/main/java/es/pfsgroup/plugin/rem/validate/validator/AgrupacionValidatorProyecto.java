package es.pfsgroup.plugin.rem.validate.validator;

import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.plugin.rem.validate.impl.AgrupacionValidatorCommonImpl;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBLocalizacionesBienInfo;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoProyecto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidator;

public class AgrupacionValidatorProyecto extends AgrupacionValidatorCommonImpl implements AgrupacionValidator {

	@Autowired 
    private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTipoAgrupacion();

	}

	@Override
	public String[] getCodigoTipoAgrupacion() {		
		return new String[]{DDTipoAgrupacion.AGRUPACION_PROYECTO};
	}
	
	
	// TODO refactorizar este validador, creando validadores independientes hasta que se pueda eliminar 
	@Override
	public String getValidationError(Activo activo, ActivoAgrupacion agrupacion) {

		ActivoAgrupacionActivo primerActivoAgrupacion = activoAgrupacionActivoApi.primerActivoPorActivoAgrupacion(agrupacion.getId());
		if (primerActivoAgrupacion == null) return "";
		Activo primerActivo = primerActivoAgrupacion.getActivo();
		if (primerActivo == null) return "";
		
		Filter filtroActivoAgrupacion = genericDao.createFilter(FilterType.EQUALS, "id", agrupacion.getId());
		ActivoAgrupacion activoAgrupacion = (ActivoAgrupacion) genericDao.get(ActivoAgrupacion.class, filtroActivoAgrupacion);
		
		Filter filtroActivoProyecto = genericDao.createFilter(FilterType.EQUALS, "agrupacion", activoAgrupacion);
		ActivoProyecto proyecto = genericDao.get(ActivoProyecto.class, filtroActivoProyecto);	
		
		NMBLocalizacionesBienInfo pobl = activo.getLocalizacionActual();
		
		if (Checks.esNulo(proyecto.getCodigoPostal())) {
			return ERROR_CP_NULL;
		} else if (!proyecto.getCodigoPostal().equals(pobl.getCodPostal())) {
			return ERROR_CP_NOT_EQUAL;
		}

		if (Checks.esNulo(proyecto.getProvincia())) {
			return ERROR_PROV_NULL;
		} else if (!proyecto.getProvincia().equals(pobl.getProvincia())) {
			return ERROR_PROV_NOT_EQUAL;
		}
				
		if (Checks.esNulo(proyecto.getLocalidad())) {
			return ERROR_LOC_NULL;
		} else if (!proyecto.getLocalidad().equals(pobl.getLocalidad())) {
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

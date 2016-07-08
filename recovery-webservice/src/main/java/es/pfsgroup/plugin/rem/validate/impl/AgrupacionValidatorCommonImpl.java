package es.pfsgroup.plugin.rem.validate.impl;

import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidatorCommon;

public class AgrupacionValidatorCommonImpl implements AgrupacionValidatorCommon {
    
    @Autowired 
    private ActivoAgrupacionActivoApi agrupacionActivoApi;
	
	@Override
	public boolean existsActiveInAgrupation(Activo activo,ActivoAgrupacion agrupacion ) {
		ActivoAgrupacionActivo agrupacionActivo = agrupacionActivoApi.getByIdActivoAndIdAgrupacion(activo.getId(), agrupacion.getId());
		return (agrupacionActivo != null);
	}
	
	@Override
	public boolean isUniqueAgrupacionActivo(Activo activo, ActivoAgrupacion activoAgrupacion) {
		
		return agrupacionActivoApi.isUniqueAgrupacionActivo(activo, activoAgrupacion);
		
	}
	
	@Override
	public boolean estaAgrupacionActivoConFechaBaja(Activo activo) {		
		return agrupacionActivoApi.estaAgrupacionActivoConFechaBaja(activo);		
	}

}

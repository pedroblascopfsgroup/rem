package es.pfsgroup.plugin.rem.validate;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;

public interface BusinessCommonValidators {

	public boolean existsActiveInAgrupation (Activo activo, ActivoAgrupacion agrupacion);
	
	public boolean isUniqueAgrupacionActivo(Activo activo, ActivoAgrupacion activoAgrupacion);
	
	public boolean estaAgrupacionActivoConFechaBaja(Activo activo);
	
}

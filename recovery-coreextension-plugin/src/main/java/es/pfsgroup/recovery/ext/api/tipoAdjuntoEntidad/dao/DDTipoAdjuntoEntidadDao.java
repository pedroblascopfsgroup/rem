package es.pfsgroup.recovery.ext.api.tipoAdjuntoEntidad.dao;

import java.util.List;

import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjuntoEntidad.DDTipoAdjuntoEntidad;

public interface DDTipoAdjuntoEntidadDao {

	public List<DDTipoAdjuntoEntidad> obtenerTiposAdjuntosPorEntidad(String codigoEntidad);
	
}

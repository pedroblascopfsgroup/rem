package es.pfsgroup.recovery.ext.api.tipoAdjuntoEntidad.dao;

import java.util.List;

import es.capgemini.pfs.tipoFicheroAdjuntoEntidad.DDTipoAdjuntoEntidad;

public interface DDTipoAdjuntoEntidadDao {

	public List<DDTipoAdjuntoEntidad> obtenerTiposAdjuntosPorEntidad(String codigoEntidad);
	
}

package es.pfsgroup.plugin.rem.activo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;

public interface ActivoAgrupacionActivoDao extends AbstractDao<ActivoAgrupacionActivo, Long>{
	
	/* Nombre que le damos al Agrupacion buscado en la HQL */
	public static final String NAME_OF_ENTITY_ACT = "act";

	public ActivoAgrupacionActivo getActivoAgrupacionActivoByIdActivoAndIdAgrupacion(long idActivo, long idAgrupacion);

	public void deleteById (Long id);
	
	public int numActivosPorActivoAgrupacion(long idAgrupacion);
	
	public ActivoAgrupacionActivo getByIdActivoAndIdAgrupacion(long idActivo, long idAgrupacion);
	
	public ActivoAgrupacionActivo primerActivoPorActivoAgrupacion(long idAgrupacion);

	public boolean isUniqueRestrictedActive(Activo activo); 
	
	public boolean isUniqueNewBuildingActive(Activo activo);
	
	public boolean isUniqueAgrupacionActivo(Long idActivo, String codigoTipoAgrupacion);
	
	public boolean estaAgrupacionActivoConFechaBaja(Activo activo);
}

package es.pfsgroup.plugin.rem.trabajo.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoGestionEconomicaTrabajo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoTrabajoFilter;

public interface TrabajoDao extends AbstractDao<Trabajo, Long>{
	
	/* Nombre que le damos al trabajo buscado en la HQL */
	public static final String NAME_OF_ENTITY = "tbj";
	
	Page findAll(DtoTrabajoFilter dtoTrabajoFiltro);
	
	Long getNextNumTrabajo();

	Page getListActivosTrabajo(DtoActivosTrabajoFilter dto);

	Page getObservaciones(DtoTrabajoFilter dto);
	
	Page getListActivosAgrupacion(DtoAgrupacionFilter dto, Usuario usuLogado);
	
	Integer getMaxOrdenFotoById(Long id);

	Page getSeleccionTarifasTrabajo(DtoGestionEconomicaTrabajo filtro,	Usuario usuarioLogado);
	
	Page getTarifasTrabajo(DtoGestionEconomicaTrabajo filtro,	Usuario usuarioLogado);
	
	Page getPresupuestosTrabajo(DtoGestionEconomicaTrabajo filtro,	Usuario usuarioLogado);
	
	Boolean existsTrabajo(DtoTrabajoFilter dtoTrabajoFiltro);

}

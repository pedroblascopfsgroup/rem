package es.pfsgroup.plugin.rem.activo.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.AgrupacionesVigencias;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionGridFilter;
import es.pfsgroup.plugin.rem.model.DtoSubdivisiones;
import es.pfsgroup.plugin.rem.model.DtoVigenciaAgrupacion;

public interface ActivoAgrupacionDao extends AbstractDao<ActivoAgrupacion, Long>{
	
	/* Nombre que le damos al Agrupacion buscado en la HQL */
	public static final String NAME_OF_ENTITY_ACT = "act";
	
	Page getListAgrupaciones(DtoAgrupacionFilter dto, Usuario usuLogado);

	Page getListActivosAgrupacionById(DtoAgrupacionFilter dto, Usuario usuLogado,Boolean little);
	
	Long getNextNumAgrupacionRemManual();
	
	Long getAgrupacionIdByNumAgrupRem(Long numAgrupRem);

	Long haveActivoPrincipal(Long id);

	Long haveActivoRestringidaAndObraNueva(Long id);
	
	List<ActivoFoto> getFotosActivosAgrupacionById(Long id);

	Page getListSubdivisionesAgrupacionById(DtoAgrupacionFilter agrupacionFilter);

	Page getListActivosSubdivisionById(DtoSubdivisiones subdivision);

	List<ActivoFoto> getFotosSubdivision(DtoSubdivisiones subdivision);

	List<ActivoFoto> getFotosAgrupacionById(Long id);
	
	List<AgrupacionesVigencias> getHistoricoVigenciasAgrupacionById(DtoVigenciaAgrupacion agrupacionFilter);
	 
	Boolean estaActivoEnOtraAgrupacionVigente(ActivoAgrupacion agrupacion,Activo activo);

	Long getIdSubdivisionByIdActivo(Long idActivo);
	
	List<Long> getListIdActivoByIdSubdivisionAndIdsAgrupacion(Long idSubdivision, String idsAgrupacion);
	
	Double getPorcentajeParticipacionUATotalDeUnAMById(Long id);
	
	ActivoAgrupacion getAgrupacionById(Long idAgrupacion);

	Page getBusquedaAgrupacionesGrid(DtoAgrupacionGridFilter dto);
	
	Long getIdByNumAgrupacion(Long numAgrupacion);

}

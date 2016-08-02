package es.pfsgroup.plugin.rem.activo.dao;

import java.math.BigDecimal;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoActivosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPreciosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;

public interface ActivoDao extends AbstractDao<Activo, Long>{
	
	/* Nombre que le damos al Activo buscado en la HQL */
	public static final String NAME_OF_ENTITY_ACT = "act";
	
	public Page getListActivos(DtoActivoFilter dtoActivoFiltro, Usuario usuLogado);
	
	public List<Activo> getListActivosLista(DtoActivoFilter dto, Usuario usuLogado);
	
	public Integer isIntegradoAgrupacionRestringida(Long id, Usuario usuLogado);
	
	public List<DDUnidadPoblacional> getComboInferiorMunicipio(String codigoMunicipio);
	
	public Integer isIntegradoAgrupacionObraNueva(Long id, Usuario usuLogado);

	public Integer getMaxOrdenFotoById(Long id);

	public Page getListHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dto, Usuario usuLogado);

	public Long getUltimoPresupuesto(Long id);

	public Integer getMaxOrdenFotoByIdSubdivision(Long idEntidad, BigDecimal hashSdv);
	
	public Page getListActivosPrecios(DtoActivoFilter dto);

	public Page getHistoricoValoresPrecios(DtoHistoricoPreciosFilter dto);

	public void deleteValoracionById(Long id);

	public ActivoCondicionEspecifica getUltimaCondicion(Long idActivo);

	public Page getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro);

	public Page getActivosPublicacion(DtoActivosPublicacion dtoActivosPublicacion);

	public ActivoHistoricoEstadoPublicacion getUltimoHistoricoEstadoPublicacion(Long activoID);
}

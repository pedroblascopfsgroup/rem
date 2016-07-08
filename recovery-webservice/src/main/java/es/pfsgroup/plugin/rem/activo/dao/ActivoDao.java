package es.pfsgroup.plugin.rem.activo.dao;

import java.math.BigDecimal;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPreciosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;

public interface ActivoDao extends AbstractDao<Activo, Long>{
	
	/* Nombre que le damos al Activo buscado en la HQL */
	public static final String NAME_OF_ENTITY_ACT = "act";
	
	Page getListActivos(DtoActivoFilter dtoActivoFiltro, Usuario usuLogado);
	
	List<Activo> getListActivosLista(DtoActivoFilter dto, Usuario usuLogado);
	
	Integer isIntegradoAgrupacionRestringida(Long id, Usuario usuLogado);
	
	List<DDUnidadPoblacional> getComboInferiorMunicipio(String codigoMunicipio);
	
	Integer isIntegradoAgrupacionObraNueva(Long id, Usuario usuLogado);

	Integer getMaxOrdenFotoById(Long id);

	Page getListHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dto, Usuario usuLogado);

	Long getUltimoPresupuesto(Long id);

	Integer getMaxOrdenFotoByIdSubdivision(Long idEntidad, BigDecimal hashSdv);
	
	Page getListActivosPrecios(DtoActivoFilter dto);

	Page getHistoricoValoresPrecios(DtoHistoricoPreciosFilter dto);


	void deleteValoracionById(Long id);

	ActivoCondicionEspecifica getUltimaCondicion(Long idActivo);
	
}

package es.pfsgroup.plugin.rem.configuracion.api;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import org.springframework.dao.DataIntegrityViolationException;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ConfiguracionReam;
import es.pfsgroup.plugin.rem.model.DtoMantenimientoFilter;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface ConfiguracionApi {

	public List<DtoMantenimientoFilter> getListMantenimiento(DtoMantenimientoFilter dto);

	@BusinessOperationDefinition("configuracionManager.getPropietariosByCartera")
	public List<ActivoPropietario> getPropietariosByCartera(String codCartera);

	@BusinessOperationDefinition("configuracionManager.getSubcarteraFilterByCartera")
	public List<DDSubcartera> getSubcarteraFilterByCartera(String codCartera);

	public Boolean deleteMantenimiento(Long idMantenimiento);

	public Boolean createMantenimiento(DtoMantenimientoFilter dtoMantenimientoFilter) throws DataIntegrityViolationException, IllegalAccessException, InvocationTargetException;
}

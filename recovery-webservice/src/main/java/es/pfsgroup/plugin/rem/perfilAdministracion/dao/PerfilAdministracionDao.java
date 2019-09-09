package es.pfsgroup.plugin.rem.perfilAdministracion.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.VBusquedaPerfiles;
import es.pfsgroup.plugin.rem.perfilAdministracion.dto.DtoPerfilAdministracionFilter;

public interface PerfilAdministracionDao extends AbstractDao<VBusquedaPerfiles, Long> {

	List<DtoPerfilAdministracionFilter> getPerfiles(DtoPerfilAdministracionFilter dto);
	
	VBusquedaPerfiles getPerfilById(Long id);
	
	List<DtoPerfilAdministracionFilter> getFuncionesByPerfilId(Long id, DtoPerfilAdministracionFilter dto);
	
}

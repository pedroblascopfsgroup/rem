package es.pfsgroup.plugin.rem.perfilAdministracion;

import java.lang.reflect.InvocationTargetException;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.PerfilApi;
import es.pfsgroup.plugin.rem.funciones.dto.DtoFunciones;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.EntidadProveedor;
import es.pfsgroup.plugin.rem.model.ProveedorTerritorial;
import es.pfsgroup.plugin.rem.model.VBusquedaPerfiles;
import es.pfsgroup.plugin.rem.perfilAdministracion.dao.PerfilAdministracionDao;
import es.pfsgroup.plugin.rem.perfilAdministracion.dto.DtoPerfilAdministracionFilter;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

@Service("perfilAdministracionManager")
public class PerfilAdministracionManager extends BusinessOperationOverrider<PerfilApi> implements PerfilApi {

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	protected static final Log logger = LogFactory.getLog(PerfilAdministracionManager.class);

	@Autowired
	private PerfilAdministracionDao perfilDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;

	@Override
	public String managerName() {
		return "perfilAdministracionManager";
	}
	
	@Override
	public List<DtoPerfilAdministracionFilter> getPerfiles(DtoPerfilAdministracionFilter dtoPerfilFiltro) {				
		return perfilDao.getPerfiles(dtoPerfilFiltro);
	}

	@Override
	public DtoPerfilAdministracionFilter getPerfilById(Long id) {
		DtoPerfilAdministracionFilter dto = new DtoPerfilAdministracionFilter();
		
		VBusquedaPerfiles perfil = perfilDao.getPerfilById(id);
		
		if(!Checks.esNulo(perfil)) {
			try {
				beanUtilNotNull.copyProperty(dto, "pefId", perfil.getPefId());
				beanUtilNotNull.copyProperty(dto, "perfilDescripcion", perfil.getPerfilDescripcion());
				beanUtilNotNull.copyProperty(dto, "perfilDescripcionLarga", perfil.getPerfilDescripcionLarga());
				beanUtilNotNull.copyProperty(dto, "perfilCodigo", perfil.getPerfilCodigo());
				beanUtilNotNull.copyProperty(dto, "funcionDescripcion", perfil.getFuncionDescripcion());
				beanUtilNotNull.copyProperty(dto, "funcionDescripcionLarga", perfil.getFuncionDescripcionLarga());
			} catch (IllegalAccessException e) {
				logger.error(e.getMessage());
			} catch (InvocationTargetException e) {
				logger.error(e.getMessage());
			}		
		}
		
		return dto;
	}
	
	@Override
	public List<DtoPerfilAdministracionFilter> getFuncionesByPerfilId(Long id, DtoPerfilAdministracionFilter dto) {				
		return perfilDao.getFuncionesByPerfilId(id, dto);
	}
	
	@Override
	public boolean usuarioHasPerfil(String codPerfil, String userName) {
		
		if( codPerfil == null || userName == null) {
			return false;
		}
		Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.username", userName);
		Filter filtroPerfil = genericDao.createFilter(FilterType.EQUALS, "perfil.codigo", codPerfil);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroUsuarioBorrado = genericDao.createFilter(FilterType.EQUALS, "usuario.auditoria.borrado", false);
		Filter filtroPerfilBorrado = genericDao.createFilter(FilterType.EQUALS, "perfil.auditoria.borrado", false);
		List<ZonaUsuarioPerfil> zonaUsuPefList = genericDao.getList(ZonaUsuarioPerfil.class, filtroUsuario, filtroPerfil,filtroBorrado, filtroUsuarioBorrado, filtroPerfilBorrado);
		
		if(zonaUsuPefList == null || zonaUsuPefList.isEmpty()) {
			return false;
		}
		
		return true;
	}
	
	@Override
	public List<DtoAdjunto> devolverAdjuntosPorPerfil(List<DtoAdjunto> adjuntos){
		Usuario usuario = genericAdapter.getUsuarioLogado();
		if(this.usuarioHasPerfil(PERFIL_TASADORA, usuario.getUsername())) {
			adjuntos = this.filtrarAdjuntos(adjuntos, MATRICULAS_TASADORA);
		}
		return adjuntos;
	}
	
	private List<DtoAdjunto> filtrarAdjuntos(List<DtoAdjunto> adjuntos, List<String> matriculas){
		for(int i = 0; i < adjuntos.size();i++) {
			DtoAdjunto adjunto = adjuntos.get(i);
			if(!matriculas.contains(adjunto.getMatricula())) {
				adjuntos.remove(adjunto);
				i--;
			}
		}
		return adjuntos;
	}
}


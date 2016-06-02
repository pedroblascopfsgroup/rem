package es.pfsgroup.plugin.recovery.procuradores.configuracion.api.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.despachoExterno.dao.DespachoExternoDao;
//import es.capgemini.pfs.despachoExterno.dao.DespachoExternoDao;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.dao.ZonaDao;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategorizacionApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categorizacion;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.api.ConfiguracionDespachoExternoApi;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.dao.ConfiguracionDespachoExternoDao;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.dto.ConfiguracionDespachoExternoDto;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.model.ConfiguracionDespachoExterno;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dao.RelacionProcuradorProcedimientoDao;
import es.pfsgroup.recovery.api.DespachoExternoApi;


@Service
@Transactional(readOnly = false)
public class ConfiguracionDespachoExternoManager implements ConfiguracionDespachoExternoApi {

	@Autowired
	ConfiguracionDespachoExternoDao configuracionDespachoExternoDao;
	
	@Autowired
	CategorizacionApi categorizacionApi;
	
	@Autowired
	DespachoExternoApi despachoExternoApi;
	
	@Autowired
	GenericABMDao genericDao;
	
	@Autowired
	DespachoExternoDao despachoDao;
    
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private RelacionProcuradorProcedimientoDao relacionProcuradorProcedimientoDao;
	
	@Override
	@BusinessOperation(ConfiguracionDespachoExternoApi.PLUGIN_PROCURADORES_GET_CATEGORIZACION_TAREAS)
	public Categorizacion getCategorizacionTareas(Long idDespacho) {
		if (idDespacho == null) return null;
		ConfiguracionDespachoExterno configuracionDespachoExterno = this.getConfiguracion(idDespacho);
		if (configuracionDespachoExterno != null){
			return configuracionDespachoExterno.getCategorizacionTareas();
		}
		return null;
	}

	@Override
	@BusinessOperation(ConfiguracionDespachoExternoApi.PLUGIN_PROCURADORES_GET_CATEGORIZACION_RESOLUCIONES)
	public Categorizacion getCategorizacionResoluciones(Long idDespacho) {
		if (idDespacho == null) return null;
		ConfiguracionDespachoExterno configuracionDespachoExterno = this.getConfiguracion(idDespacho);
		if (configuracionDespachoExterno != null){
			return configuracionDespachoExterno.getCategorizacionResoluciones();
		}
		return null;
	}

	@Override
	@BusinessOperation(ConfiguracionDespachoExternoApi.PLUGIN_PROCURADORES_IS_DESPACHO_INTEGRAL)
	public Boolean isDespachoIntegral(Long idDespacho) {
		if (idDespacho == null) return null;
		ConfiguracionDespachoExterno configuracionDespachoExterno = this.getConfiguracion(idDespacho);
		if (configuracionDespachoExterno != null){
			return configuracionDespachoExterno.getDespachoIntegal();
		}
		return false;
	}

	@Override
	@BusinessOperation(ConfiguracionDespachoExternoApi.PLUGIN_PROCURADORES_GET_CONFIGURACION_DESPACHO_EXTERNO)
	public ConfiguracionDespachoExterno getConfiguracion(Long idDespacho) {
		if (idDespacho == null) return null;
		return configuracionDespachoExternoDao.getConfiguracionDespachoExterno(idDespacho);
	}
	
    /* (non-Javadoc)
     * @see es.pfsgroup.plugin.recovery.procuradores.configuracion.api.ConfiguracionDespachoExternoApi#buscaDespachosPorUsuarioYTipo(java.lang.Long, java.lang.String)
     */
    @BusinessOperation(ConfiguracionDespachoExternoApi.PLUGIN_PROCURADORES_BUSCA_DESPACHOS_POR_USUARIO)
    public List<GestorDespacho> buscaDespachosPorUsuarioYTipo(Long idUsuario, String ddTipoDespachoExterno) {
		Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.id", idUsuario);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		//Filter filtroTipoDespacho = genericDao.createFilter(FilterType.EQUALS, "despachoExterno.tipoDespacho.codigo", ddTipoDespachoExterno);
		return genericDao.getList(GestorDespacho.class, filtroUsuario, filtroBorrado);
    	
    	//return despachoExternoDao.buscaDespachosPorUsuarioYTipo(idUsuario, ddTipoDespachoExterno);
    }	

	@Override
	@BusinessOperation(ConfiguracionDespachoExternoApi.PLUGIN_PROCURADORES_GUARDAR_CONFIGURACION_DESPACHO_EXTERNO)
	public ConfiguracionDespachoExterno guardarConfiguracion(ConfiguracionDespachoExternoDto configuracionDespachoExternoDto) {
		
		if (configuracionDespachoExternoDto == null) return null;
		
		ConfiguracionDespachoExterno configuracionDespachoExterno;
		
		if (configuracionDespachoExternoDto.getId() != null){
			configuracionDespachoExterno = configuracionDespachoExternoDao.get(configuracionDespachoExternoDto.getId());
		}else{
			configuracionDespachoExterno = new ConfiguracionDespachoExterno();
		}
		
		this.populateEntity(configuracionDespachoExterno, configuracionDespachoExternoDto);
		configuracionDespachoExternoDao.saveOrUpdate(configuracionDespachoExterno);
				
		return configuracionDespachoExterno;
	}

	private void populateEntity(ConfiguracionDespachoExterno configuracionDespachoExterno, 
				ConfiguracionDespachoExternoDto configuracionDespachoExternoDto) {
		if (configuracionDespachoExternoDto.getDespachoIntegral() != null){
			configuracionDespachoExterno.setDespachoIntegal(configuracionDespachoExternoDto.getDespachoIntegral());
		}
		
		if (configuracionDespachoExternoDto.getAvisos() != null){
			configuracionDespachoExterno.setAvisos(configuracionDespachoExternoDto.getAvisos());
		}
		
		if (configuracionDespachoExternoDto.getPausados() != null){
			configuracionDespachoExterno.setPausados(configuracionDespachoExternoDto.getPausados());
		}

		if (configuracionDespachoExternoDto.getIdCategorizacionResoluciones() != null){
			Categorizacion categorizacionResoluciones = categorizacionApi.getCategorizacion(configuracionDespachoExternoDto.getIdCategorizacionResoluciones());
			configuracionDespachoExterno.setCategorizacionResoluciones(categorizacionResoluciones);
		}

		if (configuracionDespachoExternoDto.getIdCategorizacionTareas() != null){
			Categorizacion categorizacionTareas = categorizacionApi.getCategorizacion(configuracionDespachoExternoDto.getIdCategorizacionTareas());
			configuracionDespachoExterno.setCategorizacionTareas(categorizacionTareas);
		}

		if (configuracionDespachoExternoDto.getIdDespacho() != null){
			DespachoExterno despachoExterno = genericDao.get(DespachoExterno.class, genericDao.createFilter(
					FilterType.EQUALS, "id", configuracionDespachoExternoDto.getIdDespacho())); 
			configuracionDespachoExterno.setDespachoExterno(despachoExterno);
		}

	}

	@Override
	@BusinessOperation(ConfiguracionDespachoExternoApi.PLUGIN_PROCURADORES_ACTIVO_DESPACHO_INTEGRAL)
	public Boolean activoDespachoIntegral() {
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		Long idUsuario = usuarioLogado.getId();
		
		if(!Checks.esNulo(idUsuario)){
			List<GestorDespacho> gestorDespacho = this.buscaDespachosPorUsuarioYTipo(idUsuario, DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO);
			if((!Checks.esNulo(gestorDespacho) && gestorDespacho.size()>0)){
				DespachoExterno despacho = gestorDespacho.get(0).getDespachoExterno();
				if (this.isDespachoIntegral(despacho.getId()) )
				{
					return true;
				}
			}	
		}
		return false;
	}

	@Override
	@BusinessOperation(ConfiguracionDespachoExternoApi.PLUGIN_PROCURADORES_ACTIVO_CATEGORIZACION)
	public Long activoCategorizacion() {
	Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
	Long idUsuario = usuarioLogado.getId();
	if(!Checks.esNulo(idUsuario)){
			List<GestorDespacho> gestorDespacho = this.buscaDespachosPorUsuarioYTipo(idUsuario, DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO);
			if((!Checks.esNulo(gestorDespacho) && gestorDespacho.size()>0)){
				DespachoExterno despacho = gestorDespacho.get(0).getDespachoExterno();
				Categorizacion categorizacion = this.getCategorizacionResoluciones(despacho.getId());
				if(!Checks.esNulo(categorizacion))
					return categorizacion.getId();
			}
		}
	return null;
	}
	
}

package es.pfsgroup.plugin.recovery.mejoras.cliente;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.devon.web.DynamicElementManager;
import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.model.DDSituacConcursal;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.ObjetoResultado;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;
import es.pfsgroup.plugin.recovery.mejoras.cliente.dao.MEJClienteDao;
import es.pfsgroup.plugin.recovery.mejoras.cliente.dto.MEJBuscarClientesDto;
import es.pfsgroup.recovery.ext.api.contrato.dto.EXTBusquedaContratosDto;
import es.pfsgroup.recovery.ext.api.tareas.EXTOpcionesBusquedaTareas;
import es.pfsgroup.recovery.ext.api.tareas.EXTOpcionesBusquedaTareasApi;

@Component
public class MEJClienteManager implements MEJClienteApi {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private DynamicElementManager tabManager;
	
	@Autowired
	private FuncionManager funcionManager;

	@Autowired
	GenericABMDao genericDao;
	
	@Autowired
    private Executor executor;
	
	@Autowired
	MEJClienteDao mejClienteDao;

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_CLIENTE_BUTTONS_LEFT)
	public List<DynamicElement> getButtonsConsultaClienteLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.mejoras.web.clientes.consulta.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_CLIENTE_BUTTONS_RIGHT)
	public List<DynamicElement> getButtonsConsultaClienteRight() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.mejoras.web.clientes.consulta.buttons.right",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_MGR_CLIENTES_TABS_FAST)
	public List<DynamicElement> getTabsFast() {
		return tabManager.getDynamicElements("tabs.cliente.fast", null);
	}

	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_CLIENTE_BUTTONS_LEFT_FAST)
	public List<DynamicElement> getButtonsConsultaClienteLeftFast() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements("entidad.cliente.buttons.left.fast", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation(PluginMejorasBOConstants.MEJ_BO_CLIENTE_BUTTONS_RIGHT_FAST)
	public List<DynamicElement> getButtonsConsultaClienteRightFast() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements("entidad.cliente.buttons.right.fast", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation(PluginMejorasBOConstants.GET_LIST_TIPO_CONCURSO)
	public List<DDSituacConcursal> getListTipoConcursoData() {

		List<DDSituacConcursal> listado = genericDao
				.getList(DDSituacConcursal.class);

		listado.add(new DDSituacConcursal());

		return listado;
	}
	
	@Override
    @BusinessOperation(PluginMejorasBOConstants.MEJ_BUSQUEDA_CLIENTES_EXCEL_DELEGATOR)
	public List<Persona> findClientesExcelDelegator(MEJBuscarClientesDto clientes) {
		Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		if (proxyFactory.proxy(EXTOpcionesBusquedaTareasApi.class).tieneOpcion(EXTOpcionesBusquedaTareas.getBusquedaCarterizadaTareas(), usuario) && clientes.getIsBusquedaGV()!=null && clientes.getIsBusquedaGV().booleanValue()){
			return proxyFactory.proxy(MEJClienteApi.class).findClientesExcelCarterizado(clientes);
		}else{
			return proxyFactory.proxy(MEJClienteApi.class).findClientesExcel(clientes);
		}
	}

	@Override
    @BusinessOperation(PluginMejorasBOConstants.BO_PER_MGR_FIND_CLIENTES_EXCEL_CARTERIZADO)
    public List<Persona> findClientesExcelCarterizado(MEJBuscarClientesDto clientes) {
		clientes.setCodigoZonas(getCodigosDeZona(clientes));
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        if (clientes.getIsBusquedaGV() != null && clientes.getIsBusquedaGV().booleanValue()) {
        	clientes.setPerfiles(usuario.getPerfiles());
        }
        return mejClienteDao.findClientesExcel(clientes, usuario, true);
    }
	
	@Override
    @BusinessOperation(PluginMejorasBOConstants.BO_PER_MGR_FIND_CLIENTES_EXCEL)
    public List<Persona> findClientesExcel(MEJBuscarClientesDto clientes) {
		clientes.setCodigoZonas(getCodigosDeZona(clientes));
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        if (clientes.getIsBusquedaGV() != null && clientes.getIsBusquedaGV().booleanValue()) {
        	clientes.setPerfiles(usuario.getPerfiles());
        }
        return mejClienteDao.findClientesExcel(clientes, usuario, false);
    }
	
	/**
     * Verifica si no se supera el límite tolerado de resultados para el export a XLS de
     * la búsqueda de clientes. También verifica que el resultado no sea vacío.
     * @param clientes contiene los filtros de la búsqueda.
     * @return lista de objetoResultado
     */
    @BusinessOperation(PluginMejorasBOConstants.BO_CNT_MGR_SUPERAR_LIMITE_EXPORT_CLIENTES)
    public List<ObjetoResultado> superaLimiteExport(MEJBuscarClientesDto clientes) {
    	final Usuario usuLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
    	
    	
        //Seteamos las zonas del formulario o por defecto las zonas del usuario logado
        ObjetoResultado result = new ObjetoResultado();

        clientes.setCodigoZonas(getCodigosDeZona(clientes));
        Parametrizacion param = (Parametrizacion) executor.execute(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
                Parametrizacion.LIMITE_EXPORT_EXCEL_BUSCADOR_CLIENTES);
        int limit = Integer.parseInt(param.getValor());
        clientes.setLimit(0); // No queremos que el DAO pagine para hacer el count
        int cant = mejClienteDao.buscarClientesPaginadosCount(clientes, usuLogado, false);
        result.setResultados(new Long(cant));

        if (cant > limit) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            String mensaje = ms.getMessage("export.contratos.error.resultadoSuperaLimite", new Object[] { new Long(limit) },
                    MessageUtils.DEFAULT_LOCALE);

            result.setCodigoResultado(ObjetoResultado.RESULTADO_ERROR);
            result.setMensajeError(mensaje);

        } else if (cant == 0) {

            AbstractMessageSource ms = MessageUtils.getMessageSource();
            String mensaje = ms.getMessage("export.contratos.error.resultadoVacio", new Object[] {}, MessageUtils.DEFAULT_LOCALE);

            result.setCodigoResultado(ObjetoResultado.RESULTADO_ERROR);
            result.setMensajeError(mensaje);
        } else {
            result.setCodigoResultado(ObjetoResultado.RESULTADO_OK);
        }

        List<ObjetoResultado> l = new ArrayList<ObjetoResultado>(1);
        l.add(result);

        return l;
    }
	
	
	
	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BUSQUEDA_CLIENTES_DELEGATOR)
	public Page findClientesPageDelegator(MEJBuscarClientesDto clientes) {
		Usuario u = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		if (proxyFactory.proxy(EXTOpcionesBusquedaTareasApi.class).tieneOpcion(EXTOpcionesBusquedaTareas.getBusquedaCarterizadaTareas(), u)){
			return proxyFactory.proxy(MEJClienteApi.class).findClientesPageCarterizado(clientes);
		}else if(clientes.getFiltroClientesCarterizados() != null && clientes.getFiltroClientesCarterizados()){
			return proxyFactory.proxy(MEJClienteApi.class).findClientesPageCarterizado(clientes);
		}else{
			return proxyFactory.proxy(MEJClienteApi.class).findClientesPage(clientes);
		}
	}

	@Override
	@BusinessOperation(PluginMejorasBOConstants.MEJ_BUSQUEDA_CLIENTES_CARTERIZADO)
	public Page findClientesPageCarterizado(
			MEJBuscarClientesDto clientes) {
		clientes.setCodigoZonas(getCodigosDeZona(clientes));
		Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		boolean conCaracterizacion = false;
		if (clientes.getIsBusquedaGV() != null
				&& clientes.getIsBusquedaGV().booleanValue()) {

			clientes.setPerfiles(usuario.getPerfiles());
			conCaracterizacion = true;
		}else if (clientes.getFiltroClientesCarterizados()){
			conCaracterizacion = true;
		}else{
			if(proxyFactory.proxy(EXTOpcionesBusquedaTareasApi.class).tieneOpcion(EXTOpcionesBusquedaTareas.getBusquedaCarterizadaClientes(), usuario))
				conCaracterizacion = true;
			else
				conCaracterizacion = false;
		}
		return mejClienteDao.findClientesPage(clientes, usuario, conCaracterizacion);
	}
	

	@BusinessOperation(PluginMejorasBOConstants.MEJ_BUSQUEDA_CLIENTES)
	public Page findClientesPage(MEJBuscarClientesDto clientes) {
		clientes.setCodigoZonas(getCodigosDeZona(clientes));
		Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		if (clientes.getIsBusquedaGV() != null
				&& clientes.getIsBusquedaGV().booleanValue()) {

			clientes.setPerfiles(usuario.getPerfiles());
		}
		return mejClienteDao.findClientesPage(clientes, usuario, false);
	}
	
	
	private Set<String> getCodigosDeZona(DtoBuscarClientes clientes) {
        Set<String> zonas;
        if (clientes.getCodigoZona() != null && clientes.getCodigoZona().trim().length() > 0) {
            List<String> list = Arrays.asList((clientes.getCodigoZona().split(",")));
            zonas = new HashSet<String>(list);
        } else {
            Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
            zonas = usuario.getCodigoZonas();
        }
        return zonas;
    }

}

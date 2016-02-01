package es.pfsgroup.plugin.recovery.busquedaProcedimientos.procedimiento;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.busquedaProcedimientos.PluginBusquedaProcedimientosBusinessOperations;
import es.pfsgroup.plugin.recovery.busquedaProcedimientos.procedimiento.dao.BPRProcedimientoDao;
import es.pfsgroup.plugin.recovery.busquedaProcedimientos.procedimiento.dto.BPRDtoBusquedaProcedimientos;
import es.pfsgroup.plugin.recovery.busquedaProcedimientos.procedimiento.dto.BPRDtoGestorAUsuario;

@Service("BPRProcedimientoManager")
public class BPRProcedimientoManager  implements BPRProcedimientoApi {

	@Autowired
	private Executor executor;

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	BPRProcedimientoDao procedimientoDao;

	@Autowired
	ApiProxyFactory proxyFactory;
	
	@Resource
    private MessageService messageService;

	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_LISTATIPOSPROC)
	public List<TipoProcedimiento> listaProcedimientos() {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		return genericDao.getList(TipoProcedimiento.class, f1);
	}

	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_LISTATIPOSACTUAC)
	public List<DDTipoActuacion> listaTiposActuacion() {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		return genericDao.getList(DDTipoActuacion.class, f1);
	}

	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_LISTAESTADOSPROC)
	public List<DDEstadoProcedimiento> listaEstadosProcedimiento() {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		return genericDao.getList(DDEstadoProcedimiento.class, f1);
	}

	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_TIPOSRECLAMACION)
	public List<DDTipoReclamacion> listaTiposReclamacion() {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		return genericDao.getList(DDTipoReclamacion.class, f1);
	}

	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_BUSCAJUZGADOSPLAZA)
	public List<TipoJuzgado> buscaJuzgadosPlaza(String codigo) {
		Filter filtroPlaza = genericDao.createFilter(FilterType.EQUALS,
				"plaza.codigo", codigo);
		List<TipoJuzgado> juzgados = genericDao.getList(TipoJuzgado.class,
				filtroPlaza);
		return juzgados;
	}

	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_BUSCAPROCEDIMIENTOS)
	public Page buscaProcedimientos(BPRDtoBusquedaProcedimientos dto) {
		EventFactory.onMethodStart(this.getClass());
		return procedimientoDao.findProcedimientos(proxyFactory.proxy(
				UsuarioApi.class).getUsuarioLogado(), dto);
	}

	@SuppressWarnings("unchecked")
	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_BUSCAPROCEDIMIENTOS_EXCEL)
	@Transactional
	public List<Procedimiento> buscaProcedimientosParaExcel(
			BPRDtoBusquedaProcedimientos dto) {
		EventFactory.onMethodStart(this.getClass());
		Parametrizacion param = (Parametrizacion) executor.execute(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
                Parametrizacion.LIMITE_EXPORT_EXCEL_BUSCADOR_PROCEDIMIENTOS);
		int limit = Integer.parseInt(param.getValor());
        dto.setLimit(limit);
		List<Procedimiento> listaRetorno = new ArrayList<Procedimiento>();
		PageHibernate page = (PageHibernate) procedimientoDao.findProcedimientos(proxyFactory.proxy(
				UsuarioApi.class).getUsuarioLogado(), dto);
		
		if(page.getTotalCount()>limit){
			throw new UserException(messageService.getMessage("plugin.coreextension.asuntos.exportarExcel.limiteSuperado1") +limit+" "+ messageService.getMessage("plugin.coreextension.asuntos.exportarExcel.limiteSuperado2"));
		}
		
		listaRetorno.addAll((List<Procedimiento>) page.getResults());
		listaRetorno.remove(null);
		EventFactory.onMethodStop(this.getClass());
		return listaRetorno;
	}

	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_LISTADESPACHOS)
	public List<DespachoExterno> listaDespachos() {
		Order orderTipoDespacho = new Order(OrderType.ASC,"despacho");
		return genericDao.getListOrdered(DespachoExterno.class,orderTipoDespacho);
	}

	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_LISTAGESTORESEXTERNOS)
	public List<BPRDtoGestorAUsuario> listaGestores() {
		Filter filtroGestor = genericDao.createFilter(FilterType.EQUALS,
				"supervisor", false);
		Filter filtroDespachoExterno = genericDao.createFilter(
				FilterType.EQUALS, "despachoExterno.tipoDespacho.codigo", "1");
		List<GestorDespacho> listaGestores = genericDao.getList(
				GestorDespacho.class, filtroGestor, filtroDespachoExterno);
		List<BPRDtoGestorAUsuario> usuarios = new ArrayList<BPRDtoGestorAUsuario>();
		for (GestorDespacho gd : listaGestores) {
			BPRDtoGestorAUsuario dto = new BPRDtoGestorAUsuario();
			dto.setId(gd.getId());
			dto.setUsuario(gd.getUsuario().getApellidoNombre());
			usuarios.add(dto);
		}
		return usuarios;
	}

	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_LISTASUPERVISORESASUNTO)
	public List<BPRDtoGestorAUsuario> listaSupervisores() {
		EventFactory.onMethodStart(this.getClass());
		Filter filtroSupervisor = genericDao.createFilter(FilterType.EQUALS,
				"supervisor", true);
		List<GestorDespacho> listaSupervisores = genericDao.getList(
				GestorDespacho.class, filtroSupervisor);
		List<BPRDtoGestorAUsuario> usuarios = new ArrayList<BPRDtoGestorAUsuario>();
		for (GestorDespacho gd : listaSupervisores) {
			BPRDtoGestorAUsuario dto = new BPRDtoGestorAUsuario();
			dto.setId(gd.getId());
			dto.setUsuario(gd.getUsuario().getApellidoNombre());
			usuarios.add(dto);
		}

		EventFactory.onMethodStop(this.getClass());
		return usuarios;
	}

	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_LISTAPROCURADORES)
	public List<BPRDtoGestorAUsuario> listaProcuradores() {
		Filter filtroGestor = genericDao.createFilter(FilterType.EQUALS,
				"supervisor", false);
		Filter filtroDespachoProcurador = genericDao.createFilter(
				FilterType.EQUALS, "despachoExterno.tipoDespacho.codigo", "2");
		List<GestorDespacho> listaProcuradores = genericDao.getList(
				GestorDespacho.class, filtroGestor, filtroDespachoProcurador);
		List<BPRDtoGestorAUsuario> usuarios = new ArrayList<BPRDtoGestorAUsuario>();
		for (GestorDespacho gd : listaProcuradores) {
			BPRDtoGestorAUsuario dto = new BPRDtoGestorAUsuario();
			dto.setId(gd.getId());
			dto.setUsuario(gd.getUsuario().getApellidoNombre());
			usuarios.add(dto);
		}
		return usuarios;
	}

	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_LISTACOMITES)
	public List<Comite> listaComites() {
		return genericDao.getList(Comite.class);
	}

	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_LISTAESTADOSASUNTO)
	public List<DDEstadoAsunto> listaEstadosAsunto() {
		return genericDao.getList(DDEstadoAsunto.class);
	}

	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_LISTAPROCPORACTUACION)
	public List<TipoProcedimiento> listaProcPorTipoActuacion(Long id) {
		Filter fborrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroActuacion = genericDao.createFilter(FilterType.EQUALS,
				"tipoActuacion.id", id);
		return genericDao.getList(TipoProcedimiento.class, fborrado, filtroActuacion);
	}

	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_LISTA_DESP_EXTERNOS)
	public List<DespachoExterno> listaDespachosExternos() {
		Filter filtroTipoDespacho = genericDao.createFilter(FilterType.EQUALS,
				"tipoDespacho.codigo",
				DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO);
		
		Order orderTipoDespacho = new Order(OrderType.ASC,"despacho");
		return genericDao.getListOrdered(DespachoExterno.class,orderTipoDespacho, filtroTipoDespacho);

	}

	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_BUTTONS_LEFT)
	List<DynamicElement> getButtonBusquedaProcedimientosLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.busquedaProcedimientos.web.buttons.left", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation(PluginBusquedaProcedimientosBusinessOperations.BPR_MGR_BUTTONS_RIGHT)
	List<DynamicElement> getButtonsBusquedaProcedimientosRight() {
		List<DynamicElement> l = proxyFactory
				.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.busquedaProcedimientos.web.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@Override
	@BusinessOperation(BPR_GET_DEMANDADOS)
	public Collection<? extends Persona> getDemandadosInstant(String query) {
		
		return procedimientoDao.getDemandadosInstant(query, proxyFactory.proxy(
				UsuarioApi.class).getUsuarioLogado());
	}
}

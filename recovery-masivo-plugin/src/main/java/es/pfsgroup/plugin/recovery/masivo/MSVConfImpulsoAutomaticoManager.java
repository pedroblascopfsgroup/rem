package es.pfsgroup.plugin.recovery.masivo;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PaginationParams;
import es.capgemini.devon.pagination.PaginationParamsImpl;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.masivo.api.MSVConfImpulsoAutomaticoApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVConfImpulsoAutomaticoDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVConfImpulsoAutomaticoBusquedaDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVConfImpulsoAutomaticoDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVConfImpulsoAutomatico;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoJuicio;

@Component
@Transactional(readOnly = false)
public class MSVConfImpulsoAutomaticoManager implements
		MSVConfImpulsoAutomaticoApi {

	public static final String CODIGO_TRAMITE = "TR";
	public static final String VALOR_CON_PROCURADOR = "SI";
	public static final String VALOR_SIN_PROCURADOR = "NO";

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private MSVConfImpulsoAutomaticoDao msvConfImpulsoAutomaticoDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation(PLUGIN_MASIVO_CONF_IMPULSO_BUSCA_CONFIMP)
	public Page buscaConfImpulsos(MSVConfImpulsoAutomaticoBusquedaDto dtoBusqueda) {
		try {
			EventFactory.onMethodStart(this.getClass());
			List<MSVConfImpulsoAutomatico> listaRetorno = new ArrayList<MSVConfImpulsoAutomatico>();
			PaginationParams dto = new PaginationParamsImpl();
			dto.setSort(" tipoJuicio.descripcion ");
			dto.setDir("DESC");
			dto.setStart(0);
			dto.setLimit(50);

			List<Filter> listaFiltros = new ArrayList<GenericABMDao.Filter>();
			if (dtoBusqueda.getId() != null) {
				listaFiltros.add(genericDao.createFilter(FilterType.EQUALS, "id", dtoBusqueda.getId()));
			} else {
				Long filtroTipoJuicio = dtoBusqueda.getFiltroTipoJuicio();
				if (filtroTipoJuicio != null) {
					listaFiltros.add(genericDao.createFilter(FilterType.EQUALS, "tipoJuicio.id", filtroTipoJuicio));
				}
				Long filtroTareaProcedimiento = dtoBusqueda.getFiltroTareaProcedimiento();
				if (filtroTareaProcedimiento != null) {
					listaFiltros.add(genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.id", filtroTareaProcedimiento));
				}
				String filtroConProcurador = dtoBusqueda.getFiltroConProcurador();
				if (filtroConProcurador != null) {
					if (VALOR_CON_PROCURADOR.equals(dtoBusqueda.getFiltroConProcurador())) {
						listaFiltros.add(genericDao.createFilter(FilterType.EQUALS, "conProcurador", true));
					} else if (VALOR_SIN_PROCURADOR.equals(dtoBusqueda.getFiltroConProcurador())) {
						listaFiltros.add(genericDao.createFilter(FilterType.EQUALS, "conProcurador", false));
					}
				}
				if (dtoBusqueda.getFiltroDespacho() != null) {
					listaFiltros.add(genericDao.createFilter(FilterType.EQUALS, "despacho.id", dtoBusqueda.getFiltroDespacho()));
				}
				if (dtoBusqueda.getFiltroCartera() != null && dtoBusqueda.getFiltroCartera().length()>0 ) {
					listaFiltros.add(genericDao.createFilter(FilterType.EQUALS, "cartera", dtoBusqueda.getFiltroCartera()));
				}
			}
			
			Filter[] filtros = new Filter[listaFiltros.size()];
			for (int i=0; i<filtros.length; i++) {
				filtros[i] = listaFiltros.get(i);
			}
			
			PageHibernate page = (PageHibernate) genericDao.getPage(MSVConfImpulsoAutomatico.class, dto, filtros);
			if (page != null) {
				listaRetorno.addAll((List<MSVConfImpulsoAutomatico>) page.getResults());
				page.setResults(listaRetorno);
			}

			EventFactory.onMethodStop(this.getClass());
			return page;
		} catch (Throwable t) {
			return null;
		}
	}

	@Override
	@BusinessOperation(PLUGIN_MASIVO_CONF_IMPULSO_GET_CONFIMP_POR_ID)
	public MSVConfImpulsoAutomatico getConfImpulsoPorId(Long id) {
		Filter f = genericDao.createFilter(FilterType.EQUALS, "id", id);
		return genericDao.get(MSVConfImpulsoAutomatico.class, f);
	}

	@Override
	@BusinessOperation(PLUGIN_MASIVO_CONF_IMPULSO_GET_CONFIMP_POR_DTO)
	public MSVConfImpulsoAutomatico getConfImpulsoPorDto(
			MSVConfImpulsoAutomaticoBusquedaDto dtoBusqueda) {
		Page page = buscaConfImpulsos(dtoBusqueda);
		if (page.getTotalCount() < 1) {
			return null;
		} else {
			return (MSVConfImpulsoAutomatico) page.getResults().get(0);
		}
	}

	@Override
	@BusinessOperation(PLUGIN_MASIVO_CONF_IMPULSO_GUARDAR_CONFIMP)
	public MSVConfImpulsoAutomatico guardarConfImpulso(
			MSVConfImpulsoAutomaticoDto dto) throws Exception {

		MSVConfImpulsoAutomatico confImpulso = null;
		if (Checks.esNulo(dto.getId())) {
			if (!Checks.esNulo(dto.getIdTipoJuicio()) && 
					!Checks.esNulo(dto.getIdTarea()) && 
					!Checks.esNulo(dto.getConProcurador()) && 
					!Checks.esNulo(dto.getIdDespachoExterno()) && 
					!Checks.esNulo(dto.getCartera()) ) {
				MSVConfImpulsoAutomaticoBusquedaDto dtoBusqueda = 
					new MSVConfImpulsoAutomaticoBusquedaDto(
						dto.getIdTipoJuicio(), dto.getIdTarea(),
						dto.getConProcurador(), dto.getIdDespachoExterno(),
						dto.getCartera());
				confImpulso = getConfImpulsoPorDto(dtoBusqueda);
			}
			if (confImpulso == null) {
				confImpulso = new MSVConfImpulsoAutomatico();
			}
		} else {
			confImpulso = getConfImpulsoPorId(dto.getId());
		}

		populateConfImpulso(confImpulso, dto);
		genericDao.save(MSVConfImpulsoAutomatico.class, confImpulso);

		return confImpulso;
	}

	private void populateConfImpulso(MSVConfImpulsoAutomatico confImpulso,
			MSVConfImpulsoAutomaticoDto dto) {
		if (confImpulso.getId() == null) {
			confImpulso.setId(dto.getId());
			if (dto.getIdTipoJuicio() != null) {
				MSVDDTipoJuicio tipoJuicio = genericDao.get(
						MSVDDTipoJuicio.class,
						genericDao.createFilter(FilterType.EQUALS, "id",
								dto.getIdTipoJuicio()));
				confImpulso.setTipoJuicio(tipoJuicio);
			}
			if (dto.getIdTarea() != null) {
				TareaProcedimiento tareaProcedimiento = genericDao.get(
						TareaProcedimiento.class,
						genericDao.createFilter(FilterType.EQUALS, "id",
								dto.getIdTarea()));
				confImpulso.setTareaProcedimiento(tareaProcedimiento);
			}
			if (!Checks.esNulo(dto.getConProcurador())) {
				confImpulso.setConProcurador(VALOR_CON_PROCURADOR.equals(dto.getConProcurador()));
			}
			if (dto.getIdDespachoExterno() != null) {
				DespachoExterno despacho = genericDao.get(
					DespachoExterno.class,
					genericDao.createFilter(FilterType.EQUALS, "id",
							dto.getIdDespachoExterno()));
				confImpulso.setDespacho(despacho);
			}
			if (dto.getCartera() != null) {
				confImpulso.setCartera(dto.getCartera());
			}
		}
		confImpulso.setOperUltimaResol(dto.getOperUltimaResol());
		confImpulso.setNumDiasUltimaResol(dto.getNumDiasUltimaResol());
		confImpulso.setOperUltimoImpulso(dto.getOperUltimoImpulso());
		confImpulso.setNumDiasUltimoImpulso(dto.getNumDiasUltimoImpulso());
	}

	@Override
	@BusinessOperation(PLUGIN_MASIVO_CONF_IMPULSO_BORRAR_CONFIMP)
	public void borrarConfImpulso(Long id) throws Exception {
		
		genericDao.deleteById(MSVConfImpulsoAutomatico.class, id);

	}

	@Override
	@BusinessOperation(PLUGIN_MASIVO_CONF_IMPULSO_BUSCA_TIPO_JUICIOS)
	public List<MSVDDTipoJuicio> buscaTipoJuicios() {
		
		Order order = new Order(OrderType.ASC, "descripcion");
		List <MSVDDTipoJuicio> listaTiposJuicios = genericDao.getListOrdered(MSVDDTipoJuicio.class, order);
		
		//Excluimos los tipos de juicios que son trámites
		List <MSVDDTipoJuicio> listaTiposJuiciosResultado = new ArrayList<MSVDDTipoJuicio>();
		for (MSVDDTipoJuicio msvddTipoJuicio : listaTiposJuicios) {
			if (!msvddTipoJuicio.getTipoProcedimiento().getTipoActuacion().getCodigo().equals(CODIGO_TRAMITE)) {
				listaTiposJuiciosResultado.add(msvddTipoJuicio);
			}
		}
		return listaTiposJuiciosResultado;

	}

	@Override
	@BusinessOperation(PLUGIN_MASIVO_CONF_IMPULSO_BUSCA_TAREAS_PROCEDIMIENTO)
	public List<TareaProcedimiento> buscaTareasProcedimiento(Long idTipoJuicio) {

		List<TareaProcedimiento> listaTareasProcedimientos = new ArrayList<TareaProcedimiento>();
		MSVDDTipoJuicio tipoJuicio = genericDao.get(MSVDDTipoJuicio.class,
				genericDao.createFilter(FilterType.EQUALS, "id", idTipoJuicio));

		if (!Checks.esNulo(tipoJuicio)
				&& !Checks.esNulo(tipoJuicio.getTipoProcedimiento())
				&& !Checks.esNulo(tipoJuicio.getTipoProcedimiento().getId())) {
			Order order = new Order(OrderType.ASC, "descripcion");
			Filter filtro = genericDao.createFilter(FilterType.EQUALS,
					"tipoProcedimiento.id", tipoJuicio.getTipoProcedimiento()
							.getId());
			listaTareasProcedimientos = genericDao.getListOrdered(
					TareaProcedimiento.class, order, filtro);
		}
		return listaTareasProcedimientos;
		
	}

	@Override
	@BusinessOperation(PLUGIN_MASIVO_CONF_IMPULSO_BUSCA_DESPACHOS)
	public List<DespachoExterno> buscaDespachos() {

		Order order = new Order(OrderType.ASC, "despacho");
		List <DespachoExterno> listaDespachos = genericDao.getListOrdered(DespachoExterno.class, order);
		return listaDespachos;

	}

	@Override
	@BusinessOperation(PLUGIN_MASIVO_CONF_IMPULSO_BUSCA_CARTERAS)
	public List<String> buscaCarteras() {

		List <String> listaCarteras = msvConfImpulsoAutomaticoDao.obtenerListaCarteras();
		return listaCarteras;

	}

}

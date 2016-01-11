package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.impl;

import java.lang.reflect.Method;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang.ObjectUtils;
import org.hibernate.Criteria;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.ProjectionList;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.ProcedimientoPCODao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import org.apache.commons.lang.StringUtils;

@Repository
public class ProcedimientoPCODaoImpl extends AbstractEntityDao<ProcedimientoPCO, Long> implements ProcedimientoPCODao {

	@SuppressWarnings("unchecked")
	@Override
	public ProcedimientoPCO getProcedimientoPcoPorIdProcedimiento(Long idProcedimiento) {

		Criteria query = getSession().createCriteria(ProcedimientoPCO.class);

		query.createCriteria("procedimiento", "procedimiento");
		query.add(Restrictions.eq("procedimiento.id", idProcedimiento));
		query.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
		List<ProcedimientoPCO> procedimientosPco = query.list();

		ProcedimientoPCO procedimientoPco = null;
		if (procedimientosPco.size() >= 1) {
			procedimientoPco = procedimientosPco.get(0);
		}

		return procedimientoPco;
	}

	@Override
	public Integer countBusquedaProcedimientosPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		Criteria query = queryBusquedaPorFiltro(filtro);

		query.setProjection(Projections.countDistinct("procedimiento.id"));

		return (Integer) query.uniqueResult();
	}

	@Override
	public Integer countBusquedaElementosPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		Criteria query = queryBusquedaPorFiltro(filtro);
		query.setProjection(Projections.rowCount());
		
		return (Integer) query.uniqueResult();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<HashMap<String, Object>> busquedaProcedimientosPcoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		ProjectionList select = Projections.projectionList();

		// Distinct por procedimiento id

		select.add(Projections.property("id").as("id"));
		select.add(Projections.property("procedimientoPco.procedimiento").as("procedimiento"));
		select.add(Projections.property("procedimiento.id").as("prcId"));
		select.add(Projections.property("procedimiento.id").as("codigo"));
		select.add(Projections.property("procedimientoPco.nombreExpJudicial").as("nombreExpJudicial"));
		select.add(Projections.property("procedimientoPco.estadoActual").as("estadoActualProcedimiento"));
		select.add(Projections.property("procedimientoPco.fechaEstadoActual").as("fechaEstadoProcedimiento"));
		select.add(Projections.property("procedimientoPco.diasEnGestion").as("diasEnGestion"));
		select.add(Projections.property("tipoProcPropuesto.descripcion").as("tipoProcPropuesto"));
		select.add(Projections.property("tipoPreparacion.descripcion").as("tipoPreparacion"));
		select.add(Projections.property("procedimientoPco.fechaInicioPreparacion").as("fechaInicioPreparacion"));
		select.add(Projections.property("procedimientoPco.totalLiquidacion").as("totalLiquidacion"));
		select.add(Projections.property("procedimientoPco.fechaEnvioLetrado").as("fechaEnvioLetrado"));
		select.add(Projections.property("procedimientoPco.aceptadoLetrado").as("aceptadoLetrado"));
		select.add(Projections.property("procedimientoPco.todosDocumentos").as("todosDocumentos"));
		select.add(Projections.property("procedimientoPco.todasLiquidaciones").as("todasLiquidaciones"));
		select.add(Projections.property("procedimientoPco.todosBurofaxes").as("todosBurofaxes"));
		select.add(Projections.property("procedimientoPco.importe").as("importe"));
		select.add(Projections.property("procedimientoPco.fechaFinalizado").as("fechaFinalizado"));
		select.add(Projections.property("procedimientoPco.fechaCancelado").as("fechaCancelado"));


		Criteria query = queryBusquedaPorFiltro(filtro);
		query.setProjection(select);

		addPaginationToQuery(filtro, query);
		
		query.setResultTransformer(CriteriaSpecification.ALIAS_TO_ENTITY_MAP);

		// Rellenar datos post-Query
		List<HashMap<String, Object>> list = completarDatosCalculados(query);

		return list;
	}

	/**
	 * Obtener datos calulados del grid de expedientes judiciales.
	 * @param query
	 * @return
	 */
	private List<HashMap<String, Object>> completarDatosCalculados(Criteria query) {
		List<HashMap<String, Object>> list = query.list();

		for (HashMap<String, Object> hashMap : list) {
			Long idProcedimientoPco = Long.valueOf(ObjectUtils.toString(hashMap.get("id")));
			Date fechaCancelado = (Date) hashMap.get("fechaCancelado");
			Date fechaFinalizado = (Date) hashMap.get("fechaFinalizado");

			Integer diasEnPreparacion = obtenerDiasEnPreparacion(idProcedimientoPco, fechaCancelado, fechaFinalizado);

			hashMap.put("diasEnPreparacion", diasEnPreparacion);
		}

		return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<HashMap<String, Object>> busquedaDocumentosPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		ProjectionList select = Projections.projectionList();

		select.add(Projections.distinct(Projections.property("documento.id").as("id")));
		select.add(Projections.property("estadoDocumento.descripcion").as("estado"));
		select.add(Projections.property("resultadoSolicitud.descripcion").as("ultimaRespuesta"));
		select.add(Projections.property("solicitud.actor").as("ultimoActor"));
		select.add(Projections.property("solicitud.fechaResultado").as("fechaResultado"));
		select.add(Projections.property("solicitud.fechaResultado").as("fechaResultado"));
		select.add(Projections.property("solicitud.fechaEnvio").as("fechaEnvio"));
		select.add(Projections.property("solicitud.fechaRecepcion").as("fechaRecepcion"));
		select.add(Projections.property("solicitud.fechaSolicitud").as("fechaSolicitud"));
		
		addDefaultProcedimientoProjection(select);

		Criteria query = queryBusquedaPorFiltro(filtro);
		query.setProjection(select);

		addPaginationToQuery(filtro, query);

		query.setResultTransformer(CriteriaSpecification.ALIAS_TO_ENTITY_MAP);

		return query.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<HashMap<String, Object>> busquedaLiquidacionesPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		ProjectionList select = Projections.projectionList();

		select.add(Projections.distinct(Projections.property("liquidacion.id").as("id")));
		select.add(Projections.property("estadoLiquidacion.descripcion").as("estado"));
		select.add(Projections.property("liqcontrato.nroContrato").as("contrato"));
		select.add(Projections.property("liquidacion.fechaConfirmacion").as("fechaConfirmacion"));
		select.add(Projections.property("liquidacion.fechaCierre").as("fechaCierre"));
		select.add(Projections.property("liquidacion.fechaRecepcion").as("fechaRecepcion"));
		select.add(Projections.property("liquidacion.total").as("total"));

		addDefaultProcedimientoProjection(select);

		Criteria query = queryBusquedaPorFiltro(filtro);
		query.setProjection(select);
		query.createAlias("liquidacion.contrato", "liqcontrato");

		addPaginationToQuery(filtro, query);

		query.setResultTransformer(CriteriaSpecification.ALIAS_TO_ENTITY_MAP);

		return query.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<HashMap<String, Object>> busquedaBurofaxPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		ProjectionList select = Projections.projectionList();

		select.add(Projections.distinct(Projections.property("burofax.id").as("id")));
		select.add(Projections.property("estadoBurofax.descripcion").as("estado"));
		select.add(Projections.property("burofax.demandado").as("demandado"));
		select.add(Projections.property("enviosBurofax.fechaSolicitud").as("fechaSolicitud"));
		select.add(Projections.property("enviosBurofax.fechaEnvio").as("fechaEnvio"));
		select.add(Projections.property("enviosBurofax.fechaAcuse").as("fechaAcuse"));
		select.add(Projections.property("resultadoBurofax.descripcion").as("resultado"));

		addDefaultProcedimientoProjection(select);

		Criteria query = queryBusquedaPorFiltro(filtro);
		query.setProjection(select);
		query.createAlias("burofax.estadoBurofax", "estadoBurofax");

		addPaginationToQuery(filtro, query);

		query.setResultTransformer(CriteriaSpecification.ALIAS_TO_ENTITY_MAP);

		return query.list();
	}

	/**
	 * Añade paginacion a una query
	 */
	private void addPaginationToQuery(WebDto filtro, Criteria query) {
		// Pagination
		query.setMaxResults(filtro.getLimit());
		query.setFirstResult(filtro.getStart());
	}

	/**
	 * Añade a la proyeccion los campos comunes de procedimiento a las busquedas por elemento (documento - liquidacion - burofax)
	 * @param select
	 */
	private void addDefaultProcedimientoProjection(ProjectionList select) {
		
		select.add(Projections.property("procedimientoPco.procedimiento").as("procedimiento"));
		select.add(Projections.property("procedimiento.id").as("prcId"));
		select.add(Projections.property("procedimiento.id").as("codigo"));
		select.add(Projections.property("procedimientoPco.nombreExpJudicial").as("nombreExpJudicial"));
		select.add(Projections.property("procedimientoPco.estadoActual").as("estadoActualProcedimiento"));
		select.add(Projections.property("procedimientoPco.importe").as("importe"));
		select.add(Projections.property("procedimientoPco.fechaEstadoActual").as("fechaEstadoProcedimiento"));
		select.add(Projections.property("tipoProcPropuesto.descripcion").as("tipoProcPropuesto"));
		select.add(Projections.property("tipoPreparacion.descripcion").as("tipoPreparacion"));
	}

	/**
	 * Genera un Criteria con todos los alias y todas las restricciones pasadas por el filtro.
	 * @param filtro
	 * @return 
	 */
	private Criteria queryBusquedaPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		Criteria query = getSession().createCriteria(ProcedimientoPCO.class, "procedimientoPco");

		// From
		query.createCriteria("procedimiento", "procedimiento");
		query.createAlias("procedimiento.asunto", "asunto");
		query.createCriteria("tipoPreparacion", "tipoPreparacion", CriteriaSpecification.LEFT_JOIN);
		query.createCriteria("tipoProcPropuesto", "tipoProcPropuesto", CriteriaSpecification.LEFT_JOIN);

		// Where
		List<Criterion> where = new ArrayList<Criterion>();

		where.addAll(restriccionesDatosProcedimiento(filtro, query));
		where.addAll(restriccionesDatosActores(filtro, query));
		where.addAll(restriccionesDatosPersonas(filtro, query));
		where.addAll(restriccionesDatosContratos(filtro, query));
		where.addAll(restriccionesDatosDocumentos(filtro, query));
		where.addAll(restriccionesDatosLiquidaciones(filtro, query));
		where.addAll(restriccionesDatosBurofax(filtro, query));

		// Añadir filtros a la consulta
		for (Criterion condicion : where) {
			query.add(condicion);
		}
		
		if(filtro.getSort() != null) {
			try {
				Method method = Order.class.getMethod(filtro.getDir().toLowerCase(), filtro.getSort().getClass());
				query.addOrder((Order) method.invoke(null, filtro.getSort()));
			}
			catch(Exception e) {
				logger.error("Error en el método queryBusquedaPorFiltro: " + e.getMessage());
			}
		}

		//query.addOrder(Order.asc("id")); // workaround

		return query;
	}

	/**
	 * Metodo de ayuda
	 * @param filtro
	 * @param query objeto que contiene la consulta, se utiliza para añadir nuevas relaciones con tablas
	 * @return devuelve las restricciones aplicar a la consulta
	 */
	private List<Criterion> restriccionesDatosProcedimiento(FiltroBusquedaProcedimientoPcoDTO filtro, Criteria query) {
		List<Criterion> where = new ArrayList<Criterion>();

		if (!StringUtils.isBlank(filtro.getProNombre())) {
			where.add(Restrictions.like("procedimientoPco.nombreExpJudicial", filtro.getProNombre(), MatchMode.ANYWHERE).ignoreCase());
		}

		if (!StringUtils.isBlank(filtro.getProCodigo())) {
			where.add(Restrictions.eq("procedimiento.id", Long.valueOf(filtro.getProCodigo())));
		}

		if (!StringUtils.isBlank(filtro.getProTipoPreparacion())) {
			where.add(Restrictions.eq("tipoPreparacion.codigo", filtro.getProTipoPreparacion()));
		}

		if (!StringUtils.isBlank(filtro.getProTipoProcedimiento())) {
			where.add(Restrictions.eq("tipoProcPropuesto.codigo", filtro.getProTipoProcedimiento()));
		}

		if (!StringUtils.isBlank(filtro.getProDisponibleDocumentos())) {
			where.add(Restrictions.eq("procedimientoPco.todosDocumentos", "01".equals(filtro.getProDisponibleDocumentos())));
		}

		if (!StringUtils.isBlank(filtro.getProDisponibleLiquidaciones())) {
			where.add(Restrictions.eq("procedimientoPco.todasLiquidaciones", "01".equals(filtro.getProDisponibleLiquidaciones())));
		}

		if (!StringUtils.isBlank(filtro.getProDisponibleBurofaxes())) {
			where.add(Restrictions.eq("procedimientoPco.todosBurofaxes", "01".equals(filtro.getProDisponibleBurofaxes())));
		}

		if (!StringUtils.isBlank(filtro.getProDiasGestion())) {
			where.add(Restrictions.ge("procedimientoPco.diasEnGestion", Integer.valueOf(filtro.getProDiasGestion())));
		}

		if (!StringUtils.isBlank(filtro.getProCodigosEstado())) {
			query.createCriteria("estadosPreparacionProc", "estadosPreparacionProc");
			query.createCriteria("estadosPreparacionProc.estadoPreparacion", "estadoPreparacion");

			where.add(Restrictions.in("estadoPreparacion.codigo", filtro.getProCodigosEstado().split(",")));
			where.add(Restrictions.isNull("estadosPreparacionProc.fechaFin"));
		}
		
		where.addAll(dateRangeFilter("procedimientoPco.fechaInicioPreparacion", filtro.getProFechaInicioPreparacionDesde(), filtro.getProFechaInicioPreparacionHasta()));
		where.addAll(dateRangeFilter("procedimientoPco.fechaEnvioLetrado", filtro.getProFechaEnviadoLetradoDesde(), filtro.getProFechaEnviadoLetradoHasta()));
		where.addAll(dateRangeFilter("procedimientoPco.fechaPreparado", filtro.getProFechaPreparadoDesde(), filtro.getProFechaPreparadoHasta()));
		where.addAll(dateRangeFilter("procedimientoPco.fechaFinalizado", filtro.getProFechaFinalizadoDesde(), filtro.getProFechaFinalizadoHasta()));
		where.addAll(dateRangeFilter("procedimientoPco.fechaUltimaSubsanacion", filtro.getProFechaUltimaSubsanacionDesde(), filtro.getProFechaUltimaSubsanacionHasta()));
		where.addAll(dateRangeFilter("procedimientoPco.fechaCancelado", filtro.getProFechaCanceladoDesde(), filtro.getProFechaCanceladoHasta()));
		
		where.addAll(floatRangeFilter("procedimientoPco.importe", filtro.getImporteDesde(), filtro.getImporteHasta()));

		return where;
	}

	/**
	 * Metodo de ayuda
	 * @param filtro
	 * @param query objeto que contiene la consulta, se utiliza para añadir nuevas relaciones con tablas
	 * @return devuelve las restricciones aplicar a la consulta
	 */
	private List<Criterion> restriccionesDatosActores(FiltroBusquedaProcedimientoPcoDTO filtro, Criteria query) {	
		List<Criterion> where = new ArrayList<Criterion>();

		if (!filtro.filtroGestorInformado()) {
			return where;
		}

		query.createAlias("asunto.gestoresAsunto", "gaa");
		query.createAlias("gaa.tipoGestor", "gaaTipoGestor");
		query.createAlias("gaa.gestor", "gaaGestor");
		query.createAlias("gaaGestor.usuario", "gaaUsuario");
		query.createAlias("gaaGestor.despachoExterno", "gaaDespachoExterno");

		where.add(Restrictions.eq("gaaTipoGestor.id", Long.valueOf(filtro.getProTipoGestor())));
		where.add(Restrictions.eq("gaaDespachoExterno.id", Long.valueOf(filtro.getProDespacho())));
		where.add(Restrictions.in("gaaUsuario.id", getListLongFromStringCsv(filtro.getProGestor())));

		return where;
	}
	
	/**
	 * Metodo de ayuda
	 * @param filtro
	 * @param query objeto que contiene la consulta, se utiliza para añadir nuevas relaciones con tablas
	 * @return devuelve las restricciones aplicar a la consulta
	 */
	private List<Criterion> restriccionesDatosPersonas(FiltroBusquedaProcedimientoPcoDTO filtro, Criteria query) {	
		List<Criterion> where = new ArrayList<Criterion>();

		if (!filtro.filtroPersonaInformado()) {
			return where;
		}

		query.createAlias("procedimiento.personasAfectadas", "persona");

		if (!StringUtils.isBlank(filtro.getConNombre())) {
			where.add(Restrictions.like("persona.nombre", filtro.getConNombre(), MatchMode.ANYWHERE).ignoreCase());
		}

		if (!StringUtils.isBlank(filtro.getConNif())) {
			where.add(Restrictions.like("persona.docId", filtro.getConNif(), MatchMode.ANYWHERE).ignoreCase());
		}

		if (!StringUtils.isBlank(filtro.getConApellidos())) {
			String[] apellidos = filtro.getConApellidos().split(" ");

			// Distingue entre apellido1 espacio apellido2 y solo un apellido, el cual podria ser el primero o el segundo.
			if (apellidos.length >= 2) {
				where.add(Restrictions.like("persona.apellido1", apellidos[0], MatchMode.ANYWHERE).ignoreCase());
				where.add(Restrictions.like("persona.apellido2", apellidos[1], MatchMode.ANYWHERE).ignoreCase());
			} else if (apellidos.length == 1) {
				where.add(
						Restrictions.or(
								Restrictions.like("persona.apellido1", apellidos[0], MatchMode.ANYWHERE).ignoreCase(), 
								Restrictions.like("persona.apellido2", apellidos[0], MatchMode.ANYWHERE).ignoreCase()));
			}
		}

		return where;
	}

	/**
	 * Metodo de ayuda
	 * @param filtro
	 * @param query objeto que contiene la consulta, se utiliza para añadir nuevas relaciones con tablas
	 * @return devuelve las restricciones aplicar a la consulta
	 */
	private List<Criterion> restriccionesDatosContratos(FiltroBusquedaProcedimientoPcoDTO filtro, Criteria query) {	
		List<Criterion> where = new ArrayList<Criterion>();

		if (!filtro.filtroContratoInformado()) {
			return where;
		}

		query.createAlias("asunto.expediente", "expediente");
		query.createAlias("expediente.contratos", "expcontrato");
		query.createAlias("expcontrato.contrato", "contrato");

		if (!StringUtils.isBlank(filtro.getConCodigo())) {
			where.add(Restrictions.like("contrato.nroContrato", filtro.getConCodigo(), MatchMode.ANYWHERE));
		}

		if (!StringUtils.isBlank(filtro.getConTiposProducto())) {
			query.createAlias("contrato.tipoProductoEntidad", "tipoProductoEntidad");
			where.add(Restrictions.in("tipoProductoEntidad.codigo", filtro.getConTiposProducto().split(",")));
		}

		if (!StringUtils.isBlank(filtro.getProCentroContable())) {
			query.createAlias("contrato.oficinaContable", "oficinaContable");
			query.createAlias("oficinaContable.zona", "oficinaContableZona");

			where.add(Restrictions.in("oficinaContableZona.codigo", filtro.getProCentroContable().split(",")));
		}

		return where;
	}

	/**
	 * Metodo de ayuda
	 * @param filtro
	 * @param query objeto que contiene la consulta, se utiliza para añadir nuevas relaciones con tablas
	 * @return devuelve las restricciones aplicar a la consulta
	 */
	private List<Criterion> restriccionesDatosDocumentos(FiltroBusquedaProcedimientoPcoDTO filtro, Criteria query) {
		Boolean esBusquedaPorDocumento = FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_DOCUMENTO.equals(filtro.getTipoBusqueda());

		List<Criterion> where = new ArrayList<Criterion>();

		// Si no hay ningun filtro informado de documento y ningun filtro de solicitud y no se trata de una busqueda de tipo documento, no se aplica ninguna restriccion
		if (!filtro.filtroDocumentoInformado() && !filtro.filtroSolicitudInformado() && !esBusquedaPorDocumento) {
			return where;
		}

		query.createAlias("procedimientoPco.documentos", "documento");
		query.createAlias("documentos.estadoDocumento", "estadoDocumento", CriteriaSpecification.LEFT_JOIN);

		if (!StringUtils.isBlank(filtro.getDocTiposDocumento())) {
			query.createAlias("documentos.tipoDocumento", "tipoDocumento");
			where.add(Restrictions.in("tipoDocumento.codigo", filtro.getDocTiposDocumento().split(",")));
		}

		if (!StringUtils.isBlank(filtro.getDocEstados())) {
			where.add(Restrictions.in("estadoDocumento.codigo", filtro.getDocEstados().split(",")));
		}

		if (!StringUtils.isBlank(filtro.getDocAdjunto())) {
			where.add(Restrictions.eq("documento.adjuntado", "01".equals(filtro.getDocAdjunto())));
		}

		if (!StringUtils.isBlank(filtro.getDocSolicitudPrevia())) {
			where.add(Restrictions.eq("documento.solicitudPrevia", "01".equals(filtro.getDocSolicitudPrevia())));
		}

		if (filtro.filtroSolicitudInformado() || esBusquedaPorDocumento) {

			// si se está realizando una busqueda por documentos deberán salir aquellos documentos los cuales aun no tienen ninguna solicitud
			if (esBusquedaPorDocumento) {
				query.createAlias("documentos.solicitudes", "solicitud", CriteriaSpecification.LEFT_JOIN);
			} else {
				query.createAlias("documentos.solicitudes", "solicitud");
			}

			query.createAlias("solicitud.resultadoSolicitud", "resultadoSolicitud", CriteriaSpecification.LEFT_JOIN);

			if (!StringUtils.isBlank(filtro.getDocUltimaRespuesta())) {
				where.add(Restrictions.in("resultadoSolicitud.codigo", filtro.getDocUltimaRespuesta().split(",")));
			}

			if (!StringUtils.isBlank(filtro.getDocDiasGestion())) {
				where.add(Restrictions.ge("solicitud.diasEnGestion", Integer.valueOf(filtro.getDocDiasGestion())));
			}

			if (!StringUtils.isBlank(filtro.getDocDespacho()) && !StringUtils.isBlank(filtro.getDocGestor())) {
				query.createAlias("solicitud.actor", "actor");
				query.createAlias("actor.despachoExterno", "actorDespacho");
				query.createAlias("actor.usuario", "actorUsuario");

				where.add(Restrictions.eq("actorDespacho.id", Long.valueOf(filtro.getDocDespacho())));
				where.add(Restrictions.in("actorUsuario.id", getListLongFromStringCsv(filtro.getDocGestor())));
			}

			where.addAll(dateRangeFilter("solicitud.fechaSolicitud", filtro.getLiqFechaSolicitudDesde(), filtro.getDocFechaSolicitudHasta()));
			where.addAll(dateRangeFilter("solicitud.fechaEnvio", filtro.getDocFechaEnvioDesde(), filtro.getDocFechaEnvioHasta()));
			where.addAll(dateRangeFilter("solicitud.fechaResultado", filtro.getDocFechaResultadoDesde(), filtro.getDocFechaResultadoHasta()));
			where.addAll(dateRangeFilter("solicitud.fechaRecepcion", filtro.getDocFechaRecepcionDesde(), filtro.getDocFechaRecepcionHasta()));
		}

		return where;
	}

	/**
	 * Metodo de ayuda
	 * @param filtro
	 * @param query objeto que contiene la consulta, se utiliza para añadir nuevas relaciones con tablas
	 * @return devuelve las restricciones aplicar a la consulta
	 */
	private List<Criterion> restriccionesDatosLiquidaciones(FiltroBusquedaProcedimientoPcoDTO filtro, Criteria query) {
		Boolean esBusquedaPorLiquidacion = FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_LIQUIDACION.equals(filtro.getTipoBusqueda());

		List<Criterion> where = new ArrayList<Criterion>();

		if (!filtro.filtroLiquidacionInformado() && !esBusquedaPorLiquidacion) {
			return where;
		}

		query.createAlias("procedimientoPco.liquidaciones", "liquidacion");
		query.createAlias("liquidacion.estadoLiquidacion", "estadoLiquidacion", CriteriaSpecification.LEFT_JOIN);

		if (!Checks.esNulo(filtro.getLiqEstados())) {
			where.add(Restrictions.in("estadoLiquidacion.codigo", filtro.getLiqEstados().split(",")));
		}

		if (!Checks.esNulo(filtro.getLiqDiasGestion())) {
			where.add(Restrictions.ge("liquidacion.diasEnGestion", Integer.valueOf(filtro.getLiqDiasGestion())));
		}

		where.addAll(floatRangeFilter("liquidacion.total", filtro.getLiqTotalDesde(), filtro.getLiqTotalHasta()));
		where.addAll(dateRangeFilter("liquidacion.fechaSolicitud", filtro.getLiqFechaSolicitudDesde(), filtro.getLiqFechaSolicitudHasta()));
		where.addAll(dateRangeFilter("liquidacion.fechaConfirmacion", filtro.getLiqFechaConfirmacionDesde(), filtro.getLiqFechaConfirmacionHasta()));
		where.addAll(dateRangeFilter("liquidacion.fechaCierre", filtro.getLiqFechaCierreDesde(), filtro.getLiqFechaCierreHasta()));
		where.addAll(dateRangeFilter("liquidacion.fechaRecepcion", filtro.getLiqFechaRecepcionDesde(), filtro.getLiqFechaRecepcionHasta()));

		return where;
	}

	/**
	 * Metodo de ayuda
	 * @param filtro datos que vienen de la web
	 * @param query objeto que contiene la consulta, se utiliza para añadir nuevas relaciones con tablas
	 * @return devuelve las restricciones aplicar a la consulta
	 */
	private List<Criterion> restriccionesDatosBurofax(FiltroBusquedaProcedimientoPcoDTO filtro, Criteria query) {
		List<Criterion> where = new ArrayList<Criterion>();

		Boolean esBusquedaPorBurofax = FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_BUROFAX.equals(filtro.getTipoBusqueda());

		if (!filtro.filtroBurofaxInformado() && !esBusquedaPorBurofax) {
			return where;
		}

		query.createAlias("procedimientoPco.burofaxes", "burofax");
		query.createAlias("enviosBurofax.resultadoBurofax", "resultadoBurofax", CriteriaSpecification.LEFT_JOIN);

		// Si se realiza una busqueda por burofaxes deberán salir aquellos burofaxes que aun no tengan ningun envio.
		if (esBusquedaPorBurofax) {
			query.createAlias("burofax.enviosBurofax", "enviosBurofax", CriteriaSpecification.LEFT_JOIN);
		} else {
			query.createAlias("burofax.enviosBurofax", "enviosBurofax");
		}

		if (!StringUtils.isBlank(filtro.getBurResultadoEnvio())) {
			where.add(Restrictions.in("resultadoBurofax.codigo", filtro.getBurResultadoEnvio().split(",")));
		}

		where.addAll(dateRangeFilter("enviosBurofax.fechaSolicitud", filtro.getBurFechaSolicitudDesde(), filtro.getBurFechaSolicitudHasta()));
		where.addAll(dateRangeFilter("enviosBurofax.fechaEnvio", filtro.getBurFechaEnvioDesde(), filtro.getBurFechaEnvioHasta()));
		where.addAll(dateRangeFilter("enviosBurofax.fechaAcuse", filtro.getBurFechaAcuseDesde(), filtro.getBurFechaAcuseHasta()));

		return where;
	}

	private List<Criterion> dateRangeFilter(String field, String dateFrom, String dateTo) {
		List<Criterion> where = new ArrayList<Criterion>();

		SimpleDateFormat formatoFechaFiltroWeb = new SimpleDateFormat("yyyy-MM-dd");

		try {

			if (!StringUtils.isBlank(dateFrom)) {
				where.add(Restrictions.ge(field, formatoFechaFiltroWeb.parse(dateFrom)));
			}
	
			if (!StringUtils.isBlank(dateTo)) {
				where.add(Restrictions.le(field, formatoFechaFiltroWeb.parse(dateTo)));
			}

		} catch (ParseException e) {
			logger.error(e.getLocalizedMessage());
			return where;
		}

		return where;
	}

	private List<Criterion> floatRangeFilter(String field, String from, String to) {
		List<Criterion> where = new ArrayList<Criterion>();

		if (!StringUtils.isBlank(from)) {
			where.add(Restrictions.ge(field, Float.parseFloat(from)));
		}

		if (!StringUtils.isBlank(to)) {
			where.add(Restrictions.le(field, Float.parseFloat(to)));
		}

		return where;
	}

	private List<Long> getListLongFromStringCsv(String stringCsv) {
		List<Long> idLongs = new ArrayList<Long>();

		for (String s : stringCsv.split(",")) {
			idLongs.add(Long.valueOf(s));
		}

		return idLongs;
	}

	@SuppressWarnings("unchecked")
	public List<String> getTiposGestoresAsunto(Long idAsunto) {
		
		List<String> resultado = new ArrayList<String>();
		
		Criteria query = getSession().createCriteria(EXTGestorAdicionalAsunto.class);

		query.createCriteria("asunto", "asunto");
		query.add(Restrictions.eq("asunto.id", idAsunto));
		query.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
		List<EXTGestorAdicionalAsunto> listaTiposGestores = query.list();

		for (EXTGestorAdicionalAsunto gaa : listaTiposGestores) {
			resultado.add(gaa.getTipoGestor().getCodigo());
		}

		return resultado;
		
	}

	@Override
	public List<TareaExterna> getTareasPrecedentes(Long idProcedimiento,List<TareaProcedimiento> precedentes,String order) {
		
		Criteria query = getSession().createCriteria(TareaExterna.class);

		query.createCriteria("tareaProcedimiento", "tareaProcedimiento");
		query.createCriteria("tareaPadre", "tareaPadre");
		query.createCriteria("auditoria", "auditoria");
		
		query.add(Restrictions.eq("tareaPadre.procedimiento.id", idProcedimiento));
		query.add(Restrictions.in("tareaProcedimiento", precedentes));
		
		query.add(Restrictions.eq("auditoria.borrado", false));
		
		
		if(order.toUpperCase().equals("ASC")){
			query.addOrder(Order.asc("id"));
		}else{
			query.addOrder(Order.desc("id"));
		}
		
		return query.list();
	}

	/**
	 * Funcional: Días trascurrido desde En estudio hasta Finalizado o Cancelado en caso de haber llegado, si no se ha llegado todavía, hasta fecha actual
	 * 
	 * @param idProcedimientoPco
	 * @param fechaCancelado
	 * @param fechaFinalizado
	 * @return
	 */
	private Integer obtenerDiasEnPreparacion(Long idProcedimientoPco, Date fechaCancelado, Date fechaFinalizado) {

		// Obtener Fecha inicio estado en Estudio
		Criteria query = getSession().createCriteria(ProcedimientoPCO.class);

		query.setProjection(Projections.property("estadosPreparacionProc.fechaInicio"));

		query.createAlias("estadosPreparacionProc", "estadosPreparacionProc");
		query.createAlias("estadosPreparacionProc.estadoPreparacion", "estadoPreparacion");

		query.add(Restrictions.eq("id", idProcedimientoPco));
		query.add(Restrictions.eq("estadoPreparacion.codigo", DDEstadoPreparacionPCO.EN_ESTUDIO));

		query.addOrder(Order.desc("estadosPreparacionProc.fechaInicio"));

		List<Date> fechasEnEstadoEstudio = query.list();

		if (fechasEnEstadoEstudio.isEmpty()) {
			return null;
		}

		Date fechaEstudioMasAntigua = fechasEnEstadoEstudio.get(0);

		Long diferenciaEnDias = null;

		if (fechaFinalizado != null) {
			diferenciaEnDias = fechaFinalizado.getTime() - fechaEstudioMasAntigua.getTime();
		} else if (fechaCancelado != null) {
			diferenciaEnDias = fechaCancelado.getTime() - fechaEstudioMasAntigua.getTime();
		} else {
			diferenciaEnDias = Calendar.getInstance().getTimeInMillis() - fechaEstudioMasAntigua.getTime();
		}

		diferenciaEnDias = diferenciaEnDias  / (24 * 60 * 60 * 1000);
		return Integer.valueOf(diferenciaEnDias.toString());
	}
}

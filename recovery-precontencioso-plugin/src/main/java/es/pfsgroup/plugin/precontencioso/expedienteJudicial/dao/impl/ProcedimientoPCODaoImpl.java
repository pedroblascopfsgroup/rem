package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.ProjectionList;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.ProcedimientoPCODao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.recovery.ext.impl.utils.StringUtils;

@Repository
public class ProcedimientoPCODaoImpl extends AbstractEntityDao<ProcedimientoPCO, Long> implements ProcedimientoPCODao {

	@Override
	public ProcedimientoPCO getProcedimientoPcoPorIdProcedimiento(Long idProcedimiento) {
		Criteria query = getSession().createCriteria(ProcedimientoPCO.class);

		query.createCriteria("procedimiento", "procedimiento");
		query.add(Restrictions.eq("procedimiento.id", idProcedimiento));

		List<ProcedimientoPCO> procedimientosPco = query.list();

		ProcedimientoPCO procedimientoPco = null;
		if (procedimientosPco.size() == 1) {
			procedimientoPco = procedimientosPco.get(0);
		}

		return procedimientoPco;
	}

	@Override
	public List<SolicitudDocumentoPCO> getSolicitudesDocumentoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		Criteria query = getSession().createCriteria(DocumentoPCO.class, "documento");

		// From
		query.createCriteria("procedimientoPCO", "procedimientoPCO");
		query.createCriteria("procedimientoPCO.procedimiento", "procedimiento");
		query.createCriteria("solicitudes", "solicitudes", CriteriaSpecification.LEFT_JOIN);

		// Where
		List<Criterion> where = new ArrayList<Criterion>();
		
		if (!StringUtils.emtpyString(filtro.getDocTiposDocumento())) {
			query.createAlias("documentos.tipoDocumento", "tipoDocumento", CriteriaSpecification.LEFT_JOIN);
			where.add(Restrictions.in("tipoDocumento.codigo", filtro.getDocTiposDocumento().split(",")));
		}

		if (!StringUtils.emtpyString(filtro.getDocEstados())) {
			query.createAlias("documentos.estadoDocumento", "estadoDocumento", CriteriaSpecification.LEFT_JOIN);
			where.add(Restrictions.in("estadoDocumento.codigo", filtro.getDocEstados().split(",")));
		}

		if (!StringUtils.emtpyString(filtro.getDocUltimaRespuesta())) {
			query.createAlias("solicitud.resultadoSolicitud", "resultadoSolicitud", CriteriaSpecification.LEFT_JOIN);
			where.add(Restrictions.in("resultadoSolicitud.codigo", filtro.getDocUltimaRespuesta().split(",")));
		}

		if (!StringUtils.emtpyString(filtro.getDocAdjunto())) {
			where.add(Restrictions.eq("documento.adjuntado", "01".equals(filtro.getDocAdjunto())));
		}

		where.addAll(dateRangeFilter("solicitud.fechaSolicitud", filtro.getLiqFechaSolicitudDesde(), filtro.getDocFechaSolicitudHasta()));
		where.addAll(dateRangeFilter("solicitud.fechaEnvio", filtro.getDocFechaEnvioDesde(), filtro.getDocFechaEnvioHasta()));
		where.addAll(dateRangeFilter("solicitud.fechaResultado", filtro.getDocFechaResultadoDesde(), filtro.getDocFechaResultadoHasta()));
		where.addAll(dateRangeFilter("solicitud.fechaRecepcion", filtro.getDocFechaRecepcionDesde(), filtro.getDocFechaRecepcionHasta()));

		// Añadir filtros a la consulta
		for (Criterion condicion : where) {
			query.add(condicion);
		}

		query.addOrder(Order.asc("id")); // workaround
		query.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
		return query.list();
	}

	@Override
	public List<LiquidacionPCO> getLiquidacionesPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		ProjectionList select = Projections.projectionList();
		// Distinct
		select.add(Projections.distinct(Projections.property("liquidacion.id").as("id")));
		select.add(Projections.property("liquidacion.procedimientoPCO").as("procedimientoPCO"));
		select.add(Projections.property("liquidacion.estadoLiquidacion").as("estadoLiquidacion"));
		select.add(Projections.property("liquidacion.contrato").as("contrato"));
		select.add(Projections.property("liquidacion.fechaSolicitud").as("fechaSolicitud"));
		select.add(Projections.property("liquidacion.fechaRecepcion").as("fechaRecepcion"));
		select.add(Projections.property("liquidacion.fechaConfirmacion").as("fechaConfirmacion"));
		select.add(Projections.property("liquidacion.fechaCierre").as("fechaCierre"));
		select.add(Projections.property("liquidacion.capitalVencido").as("capitalVencido"));
		select.add(Projections.property("liquidacion.capitalNoVencido").as("capitalNoVencido"));
		select.add(Projections.property("liquidacion.interesesDemora").as("interesesDemora"));
		select.add(Projections.property("liquidacion.interesesOrdinarios").as("interesesOrdinarios"));
		select.add(Projections.property("liquidacion.total").as("total"));
		select.add(Projections.property("liquidacion.capitalVencidoOriginal").as("capitalVencidoOriginal"));
		select.add(Projections.property("liquidacion.capitalNoVencidoOriginal").as("capitalNoVencidoOriginal"));
		select.add(Projections.property("liquidacion.interesesDemoraOriginal").as("interesesDemoraOriginal"));
		select.add(Projections.property("liquidacion.interesesOrdinariosOriginal").as("interesesOrdinariosOriginal"));
		select.add(Projections.property("liquidacion.totalOriginal").as("totalOriginal"));
		select.add(Projections.property("liquidacion.apoderado").as("apoderado"));
		select.add(Projections.property("liquidacion.sysGuid").as("sysGuid"));

		Criteria query = queryBusquedaPorFiltro(filtro);
		query.setProjection(select);
		query.setResultTransformer(new AliasToBeanResultTransformer(LiquidacionPCO.class));

		return query.list();
	}

	@Override
	public List<EnvioBurofaxPCO> getEnviosBurofaxPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		ProjectionList select = Projections.projectionList();
		// Distinct
		select.add(Projections.distinct(Projections.property("enviosBurofax.id").as("id")));
		select.add(Projections.property("enviosBurofax.burofax").as("burofax"));
		select.add(Projections.property("enviosBurofax.direccion").as("direccion"));
		select.add(Projections.property("enviosBurofax.tipoBurofax").as("tipoBurofax"));
		select.add(Projections.property("enviosBurofax.resultadoBurofax").as("resultadoBurofax"));
		select.add(Projections.property("enviosBurofax.fechaSolicitud").as("fechaSolicitud"));
		select.add(Projections.property("enviosBurofax.fechaEnvio").as("fechaEnvio"));
		select.add(Projections.property("enviosBurofax.fechaAcuse").as("fechaAcuse"));
		select.add(Projections.property("enviosBurofax.contenidoBurofax").as("contenidoBurofax"));
		select.add(Projections.property("enviosBurofax.sysGuid").as("sysGuid"));

		Criteria query = queryBusquedaPorFiltro(filtro);
		query.setProjection(select);
		query.setResultTransformer(new AliasToBeanResultTransformer(EnvioBurofaxPCO.class));

		return query.list();
	}

	@Override
	public List<ProcedimientoPCO> getProcedimientosPcoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {
		Criteria query = queryBusquedaPorFiltro(filtro);

		// Distinct, objetos duplicados debido a los joins
		query.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);

		return query.list();
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
		query.createCriteria("tipoPreparacion", "tipoPreparacion", CriteriaSpecification.LEFT_JOIN);
		query.createCriteria("tipoProcPropuesto", "tipoProcPropuesto", CriteriaSpecification.LEFT_JOIN);

		// Where
		List<Criterion> where = new ArrayList<Criterion>();

		where.addAll(restriccionesDatosProcedimiento(filtro, query));
		where.addAll(restriccionesDatosPersonas(filtro, query));
		where.addAll(restriccionesDatosContratos(filtro, query));
		where.addAll(restriccionesDatosDocumentos(filtro, query));
		where.addAll(restriccionesDatosLiquidaciones(filtro, query));
		where.addAll(restriccionesDatosBurofax(filtro, query));

		// Añadir filtros a la consulta
		for (Criterion condicion : where) {
			query.add(condicion);
		}

		query.addOrder(Order.asc("id")); // workaround
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

		if (!StringUtils.emtpyString(filtro.getProNombre())) {
			where.add(Restrictions.eq("procedimientoPco.nombreExpJudicial", filtro.getProNombre()));
		}

		if (!StringUtils.emtpyString(filtro.getProCodigo())) {
			where.add(Restrictions.eq("procedimiento.id", filtro.getProCodigo()));
		}

		if (!StringUtils.emtpyString(filtro.getProTipoPreparacion())) {
			where.add(Restrictions.eq("tipoPreparacion.codigo", filtro.getProTipoPreparacion()));
		}

		if (!StringUtils.emtpyString(filtro.getProTipoProcedimiento())) {
			where.add(Restrictions.eq("tipoProcPropuesto.codigo", filtro.getProTipoProcedimiento()));
		}

		if (!StringUtils.emtpyString(filtro.getProCodigosEstado())) {
			query.createCriteria("estadosPreparacionProc", "estadosPreparacionProc");
			query.createCriteria("estadosPreparacionProc.estadoPreparacion", "estadoPreparacion");

			where.add(Restrictions.in("estadoPreparacion.codigo", filtro.getProCodigosEstado().split(",")));
			where.add(Restrictions.isNull("estadosPreparacionProc.fechaFin"));
		}

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

		Boolean filtroPersonaInformado = Boolean.valueOf((!StringUtils.emtpyString(filtro.getConNombre()) 
				|| !StringUtils.emtpyString(filtro.getConApellidos()) 
				|| !StringUtils.emtpyString(filtro.getConNif())));

		if (!filtroPersonaInformado) {
			return where;
		}

		// FROM
		query.createAlias("procedimiento.personasAfectadas", "persona", CriteriaSpecification.LEFT_JOIN);

		if (!StringUtils.emtpyString(filtro.getConNombre())) {
			where.add(Restrictions.like("persona.nombre", filtro.getConNombre(), MatchMode.ANYWHERE).ignoreCase());
		}

		if (!StringUtils.emtpyString(filtro.getConNif())) {
			where.add(Restrictions.like("persona.docId", filtro.getConNif(), MatchMode.ANYWHERE).ignoreCase());
		}

		if (!StringUtils.emtpyString(filtro.getConApellidos())) {
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

		Boolean filtroContratoInformado = Boolean.valueOf(!StringUtils.emtpyString(filtro.getConCodigo()) 
				|| !StringUtils.emtpyString(filtro.getConTiposProducto()));

		if (!filtroContratoInformado) {
			return where;
		}

		// FROM
		query.createAlias("procedimiento.asunto", "asunto", CriteriaSpecification.LEFT_JOIN);
		query.createAlias("asunto.expediente", "expediente", CriteriaSpecification.LEFT_JOIN);
		query.createAlias("expediente.contratos", "expcontrato");
		query.createAlias("expcontrato.contrato", "contrato");

		if (!StringUtils.emtpyString(filtro.getConCodigo())) {
			where.add(Restrictions.like("contrato.nroContrato", filtro.getConCodigo(), MatchMode.ANYWHERE));
		}

		if (!StringUtils.emtpyString(filtro.getConTiposProducto())) {
			query.createAlias("contrato.tipoProductoEntidad", "tipoProductoEntidad");
			where.add(Restrictions.in("tipoProductoEntidad.codigo", filtro.getConTiposProducto().split(",")));
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
		List<Criterion> where = new ArrayList<Criterion>();
		
		if (!filtroDocumentoInformado(filtro)) {
			return where;
		}

		query.createAlias("procedimientoPco.documentos", "documento");
		query.createAlias("documentos.solicitudes", "solicitud");

		if (!StringUtils.emtpyString(filtro.getDocTiposDocumento())) {
			query.createAlias("documentos.tipoDocumento", "tipoDocumento", CriteriaSpecification.LEFT_JOIN);
			where.add(Restrictions.in("tipoDocumento.codigo", filtro.getDocTiposDocumento().split(",")));
		}

		if (!StringUtils.emtpyString(filtro.getDocEstados())) {
			query.createAlias("documentos.estadoDocumento", "estadoDocumento", CriteriaSpecification.LEFT_JOIN);
			where.add(Restrictions.in("estadoDocumento.codigo", filtro.getDocEstados().split(",")));
		}

		if (!StringUtils.emtpyString(filtro.getDocUltimaRespuesta())) {
			query.createAlias("solicitud.resultadoSolicitud", "resultadoSolicitud", CriteriaSpecification.LEFT_JOIN);
			where.add(Restrictions.in("resultadoSolicitud.codigo", filtro.getDocUltimaRespuesta().split(",")));
		}

		if (!StringUtils.emtpyString(filtro.getDocAdjunto())) {
			where.add(Restrictions.eq("documento.adjuntado", "01".equals(filtro.getDocAdjunto())));
		}

		where.addAll(dateRangeFilter("solicitud.fechaSolicitud", filtro.getLiqFechaSolicitudDesde(), filtro.getDocFechaSolicitudHasta()));
		where.addAll(dateRangeFilter("solicitud.fechaEnvio", filtro.getDocFechaEnvioDesde(), filtro.getDocFechaEnvioHasta()));
		where.addAll(dateRangeFilter("solicitud.fechaResultado", filtro.getDocFechaResultadoDesde(), filtro.getDocFechaResultadoHasta()));
		where.addAll(dateRangeFilter("solicitud.fechaRecepcion", filtro.getDocFechaRecepcionDesde(), filtro.getDocFechaRecepcionHasta()));

		return where;
	}

	/**
	 * Metodo de ayuda
	 * @param filtro
	 * @param query objeto que contiene la consulta, se utiliza para añadir nuevas relaciones con tablas
	 * @return devuelve las restricciones aplicar a la consulta
	 */
	private List<Criterion> restriccionesDatosLiquidaciones(FiltroBusquedaProcedimientoPcoDTO filtro, Criteria query) {	
		List<Criterion> where = new ArrayList<Criterion>();

		if (!filtroLiquidacionInformado(filtro)) {
			return where;
		}

		query.createAlias("procedimientoPco.liquidaciones", "liquidacion");

		if (!StringUtils.emtpyString(filtro.getLiqEstados())) {
			query.createAlias("liquidacion.estadoLiquidacion", "estadoLiquidacion");
			where.add(Restrictions.in("estadoLiquidacion.codigo", filtro.getLiqEstados().split(",")));
		}

		if (!StringUtils.emtpyString(filtro.getLiqTotalDesde())) {
			where.add(Restrictions.ge("liquidacion.total", Float.parseFloat(filtro.getLiqTotalDesde())));
		}

		if (!StringUtils.emtpyString(filtro.getLiqTotalHasta())) {
			where.add(Restrictions.le("liquidacion.total", Float.parseFloat(filtro.getLiqTotalHasta())));
		}

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

		if (!filtroBurofaxInformado(filtro)) {
			return where;
		}

		query.createAlias("procedimientoPco.burofaxes", "burofax");
		query.createAlias("burofax.enviosBurofax", "enviosBurofax");

		if (!StringUtils.emtpyString(filtro.getBurResultadoEnvio())) {
			query.createAlias("enviosBurofax.resultadoBurofax", "resultadoBurofax");
			where.add(Restrictions.in("resultadoBurofax.codigo", filtro.getBurResultadoEnvio().split(",")));
		}

		where.addAll(dateRangeFilter("enviosBurofax.fechaSolicitud", filtro.getBurFechaSolicitudDesde(), filtro.getBurFechaSolicitudHasta()));
		where.addAll(dateRangeFilter("enviosBurofax.fechaEnvio", filtro.getBurFechaEnvioDesde(), filtro.getBurFechaEnvioHasta()));
		where.addAll(dateRangeFilter("enviosBurofax.fechaAcuse", filtro.getBurFechaAcuseDesde(), filtro.getBurFechaAcuseHasta()));

		return where;
	}

	/**
	 * Comprueba si está informado el filtro de documento
	 */
	private Boolean filtroDocumentoInformado(FiltroBusquedaProcedimientoPcoDTO filtro) {
		Boolean filtroDocumentoInformado = Boolean.valueOf(
			!StringUtils.emtpyString(filtro.getDocTiposDocumento())
			|| !StringUtils.emtpyString(filtro.getDocEstados())
			|| !StringUtils.emtpyString(filtro.getDocUltimaRespuesta())
			|| !StringUtils.emtpyString(filtro.getDocFechaSolicitudDesde())
			|| !StringUtils.emtpyString(filtro.getDocFechaSolicitudHasta())
			|| !StringUtils.emtpyString(filtro.getDocFechaResultadoDesde())
			|| !StringUtils.emtpyString(filtro.getDocFechaResultadoHasta())
			|| !StringUtils.emtpyString(filtro.getDocFechaEnvioDesde())
			|| !StringUtils.emtpyString(filtro.getDocFechaEnvioHasta())
			|| !StringUtils.emtpyString(filtro.getDocFechaRecepcionDesde())
			|| !StringUtils.emtpyString(filtro.getDocFechaRecepcionHasta())
			|| !StringUtils.emtpyString(filtro.getDocAdjunto())
			|| !StringUtils.emtpyString(filtro.getDocSolicitudPrevia())
			|| !StringUtils.emtpyString(filtro.getDocDiasGestion()));
		return filtroDocumentoInformado;
	}

	/**
	 * Comprueba si está informado el filtro de liquidacion
	 */
	private Boolean filtroLiquidacionInformado(FiltroBusquedaProcedimientoPcoDTO filtro) {
		Boolean filtroLiquidacionInformado = Boolean.valueOf(
			!StringUtils.emtpyString(filtro.getLiqEstados())
			|| !StringUtils.emtpyString(filtro.getLiqFechaSolicitudDesde())
			|| !StringUtils.emtpyString(filtro.getLiqFechaSolicitudHasta())
			|| !StringUtils.emtpyString(filtro.getLiqFechaRecepcionDesde())
			|| !StringUtils.emtpyString(filtro.getLiqFechaRecepcionHasta())
			|| !StringUtils.emtpyString(filtro.getLiqFechaConfirmacionDesde())
			|| !StringUtils.emtpyString(filtro.getLiqFechaConfirmacionHasta())
			|| !StringUtils.emtpyString(filtro.getLiqFechaCierreDesde())
			|| !StringUtils.emtpyString(filtro.getLiqFechaCierreHasta())
			|| !StringUtils.emtpyString(filtro.getLiqTotalDesde())
			|| !StringUtils.emtpyString(filtro.getLiqTotalHasta())
			|| !StringUtils.emtpyString(filtro.getLiqDiasGestion()));
		return filtroLiquidacionInformado;
	}

	/**
	 * Comprueba si está informado el filtro de burofaxes
	 */
	private Boolean filtroBurofaxInformado(FiltroBusquedaProcedimientoPcoDTO filtro) {
		Boolean filtroBurofaxInformado = Boolean.valueOf(
			!StringUtils.emtpyString(filtro.getBurNotificado())
			|| !StringUtils.emtpyString(filtro.getBurResultadoEnvio())
			|| !StringUtils.emtpyString(filtro.getBurFechaSolicitudDesde())
			|| !StringUtils.emtpyString(filtro.getBurFechaSolicitudHasta())
			|| !StringUtils.emtpyString(filtro.getBurFechaAcuseDesde())
			|| !StringUtils.emtpyString(filtro.getBurFechaAcuseHasta())
			|| !StringUtils.emtpyString(filtro.getBurFechaEnvioDesde())
			|| !StringUtils.emtpyString(filtro.getBurFechaEnvioHasta()));
		return filtroBurofaxInformado;
	}

	private List<Criterion> dateRangeFilter(String field, String dateFrom, String dateTo) {
		List<Criterion> where = new ArrayList<Criterion>();

		SimpleDateFormat formatoFechaFiltroWeb = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

		try {

			if (!StringUtils.emtpyString(dateFrom)) {
				where.add(Restrictions.ge(field, formatoFechaFiltroWeb.parse(dateFrom)));
			}
	
			if (!StringUtils.emtpyString(dateTo)) {
				where.add(Restrictions.le(field, formatoFechaFiltroWeb.parse(dateTo)));
			}

		} catch (ParseException e) {
			logger.error(e.getLocalizedMessage());
			return where;
		}

		return where;
	}
}

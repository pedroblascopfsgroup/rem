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
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.ProcedimientoPCODao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
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
	public List<ProcedimientoPCO> getProcedimientosPcoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro) {

		Criteria query = getSession().createCriteria(ProcedimientoPCO.class, "procedimientoPco");

		// From
		query.createCriteria("procedimiento", "procedimiento");
		query.createCriteria("tipoPreparacion", "tipoPreparacion", CriteriaSpecification.LEFT_JOIN);
		query.createCriteria("tipoProcPropuesto", "tipoProcPropuesto", CriteriaSpecification.LEFT_JOIN);
		query.createCriteria("estadosPreparacionProc", "estadosPreparacionProc");
		query.createCriteria("estadosPreparacionProc.estadoPreparacion", "estadoPreparacion");

		// Where
		List<Criterion> where = new ArrayList<Criterion>();

		where.addAll(restriccionesDatosProcedimiento(filtro));
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
		query.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
		
		return query.list();
	}

	/**
	 * Metodo de ayuda
	 * @param filtro datos que vienen de la web
	 * @param query objeto que contiene la consulta, se utiliza para añadir nuevas relaciones con tablas
	 * @return devuelve las restricciones aplicar a la consulta
	 */
	private List<Criterion> restriccionesDatosProcedimiento(FiltroBusquedaProcedimientoPcoDTO filtro) {
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
			where.add(Restrictions.in("estadoPreparacion.codigo", filtro.getProCodigosEstado().split(",")));
			where.add(Restrictions.isNull("estadosPreparacionProc.fechaFin"));
		}

		return where;
	}

	/**
	 * Metodo de ayuda
	 * @param filtro datos que vienen de la web
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
	 * @param filtro datos que vienen de la web
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
	 * @param filtro datos que vienen de la web
	 * @param query objeto que contiene la consulta, se utiliza para añadir nuevas relaciones con tablas
	 * @return devuelve las restricciones aplicar a la consulta
	 */
	private List<Criterion> restriccionesDatosDocumentos(FiltroBusquedaProcedimientoPcoDTO filtro, Criteria query) {	
		List<Criterion> where = new ArrayList<Criterion>();

		if (filtro.getDocDiasGestion() == null) {
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
	 * @param filtro datos que vienen de la web
	 * @param query objeto que contiene la consulta, se utiliza para añadir nuevas relaciones con tablas
	 * @return devuelve las restricciones aplicar a la consulta
	 */
	private List<Criterion> restriccionesDatosLiquidaciones(FiltroBusquedaProcedimientoPcoDTO filtro, Criteria query) {	
		List<Criterion> where = new ArrayList<Criterion>();

		if (filtro.getLiqDiasGestion() == null) {
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

		if (filtro.getBurNotificado() == null) {
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

package es.pfsgroup.listadoPreProyectado.dao;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Disjunction;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.DDTipoExpediente;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.listadoPreProyectado.api.VListadoPreProyectadoCntDao;
import es.pfsgroup.listadoPreProyectado.api.VListadoPreProyectadoExpDao;
import es.pfsgroup.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.listadoPreProyectado.model.VListadoPreProyectadoCnt;
import es.pfsgroup.listadoPreProyectado.model.VListadoPreProyectadoExp;
import es.pfsgroup.listadoPreProyectado.model.VListadoPreProyectadoExtCalc;

@Repository("VListadoPreProyectadoExpDao")
public class VListadoPreProyectadoExpDaoImpl extends AbstractEntityDao<VListadoPreProyectadoExp, Long> implements VListadoPreProyectadoExpDao {

	@Autowired
	VListadoPreProyectadoCntDao vListadoPreProyectadoCntDao;

	@SuppressWarnings("unchecked")
	@Override
	public List<VListadoPreProyectadoExp> getListadoPreProyectadoExp(ListadoPreProyectadoDTO filtro) {
		Criteria query = queryBusquedaPreProyectadoPorFiltro(filtro);

		query.setProjection(Projections.distinct(Projections.property("expediente.id").as("expId")));

		// Pagination
		query.setMaxResults(filtro.getLimit());
		query.setFirstResult(filtro.getStart());

		List<Long> expIds = query.list();

		if (expIds.isEmpty()) {
			return new ArrayList<VListadoPreProyectadoExp>();
		}

		// Recuperar Expedientes
		Criteria queryGetExpedientes = getSession().createCriteria(VListadoPreProyectadoExp.class, "e");
		queryGetExpedientes.add(Restrictions.in("e.expId", expIds));

		List<VListadoPreProyectadoExp> listadoExpedientes = queryGetExpedientes.list();

		// Recuperar Contratos
		List<VListadoPreProyectadoCnt> listContratosExpedientes = vListadoPreProyectadoCntDao.getListadoPreProyectadoCntExp(expIds);

		for (VListadoPreProyectadoExp expediente : listadoExpedientes) {
			List<VListadoPreProyectadoCnt> contratos = new ArrayList<VListadoPreProyectadoCnt>();

			for (VListadoPreProyectadoCnt contratoExpediente : listContratosExpedientes) {
				if (expediente.getExpId().equals(contratoExpediente.getExpId())) {
					contratos.add(contratoExpediente);
				}
			}
			expediente.setContratos(contratos);
		}

		return listadoExpedientes;
	}

	@Override
	public Integer getListadoPreProyectadoExpCount(ListadoPreProyectadoDTO dto) {
		Criteria query = queryBusquedaPreProyectadoPorFiltro(dto);

		query.setProjection(Projections.countDistinct("expediente.id"));

		return (Integer) query.uniqueResult();
	}

	private Criteria queryBusquedaPreProyectadoPorFiltro(ListadoPreProyectadoDTO filtro) {
		Criteria query = getSession().createCriteria(VListadoPreProyectadoExtCalc.class, "vListadoPreProyectadoExtCalc");

		// expediente joins
		query.createAlias("vListadoPreProyectadoExtCalc.expediente", "expediente");
		query.createAlias("expediente.contratos", "expcontrato");
		query.createAlias("expediente.estadoExpediente", "estadoExpediente");

		// contrato joins
		query.createAlias("expcontrato.contrato", "contrato");
		query.createAlias("contrato.estadoContrato", "estadoContrato");

		List<Criterion> where = new ArrayList<Criterion>();

		where.addAll(restriccionesNegocio(query));
		where.addAll(restriccionesDatosGenerales(filtro, query));
		where.addAll(restriccionesContrato(filtro, query));
		where.addAll(restriccionesExpediente(filtro, query));

		// Añadir filtros a la consulta
		for (Criterion condicion : where) {
			query.add(condicion);
		}

		return query;
	}

	/**
	 * Helper - method
	 * Genera las restricciones expediente y añade los joins necesarios a la query
	 */
	private List<Criterion> restriccionesExpediente(ListadoPreProyectadoDTO filtro, Criteria query) {
		List<Criterion> where = new ArrayList<Criterion>();

		// filtro cod. expediente
		if (!Checks.esNulo(filtro.getCodExpediente())) {
			where.add(Restrictions.eq("expediente.id", Long.valueOf(filtro.getCodExpediente())));
		}

		// filtro fase itinerario
		if (!Checks.esNulo(filtro.getItinerarios())) {
			query.createAlias("expediente.estadoItinerario", "estadoItinerario");

			where.add(Restrictions.in("estadoItinerario.codigo", filtro.getItinerarios().split(",")));
		}

		// filtro zonas exp
		if (!Checks.esNulo(filtro.getZonasExp()) || !Checks.esNulo(filtro.getUsuarioLogado())) {
			query.createAlias("expediente.oficina", "oficinaExp");
			query.createAlias("oficinaExp.zona", "zonaExp");

			// filtrado visibilidad por zonas Usuario
			if (!Checks.esNulo(filtro.getUsuarioLogado())) {
				if (filtro.getUsuarioLogado().getZonas().size() > 0) {
					Disjunction zonasUsuarioLogado = Restrictions.disjunction();
					for (DDZona zona : filtro.getUsuarioLogado().getZonas()) {
						zonasUsuarioLogado.add(Restrictions.like("zonaExp.codigo", zona.getCodigo(), MatchMode.START));
					}

					where.add(zonasUsuarioLogado);
				}
			}

			if (!Checks.esNulo(filtro.getZonasExp())) {
				Disjunction zonasExpediente = Restrictions.disjunction();

				for (String codigoZona : filtro.getZonasExp().split(",")) {
					zonasExpediente.add(Restrictions.like("zonaExp.codigo", codigoZona, MatchMode.START));
				}

				where.add(zonasExpediente);
			}
		}

		return where;
	}

	/**
	 * Helper-method
	 * Genera las restricciones contrato y añade los joins necesarios a la query
	 */
	private List<Criterion> restriccionesContrato(ListadoPreProyectadoDTO filtro, Criteria query) {
		List<Criterion> where = new ArrayList<Criterion>();

		// filtro codigo contrato
		if (!Checks.esNulo(filtro.getCodContrato())) {
			where.add(Restrictions.like("contrato.nroContrato", filtro.getCodContrato(), MatchMode.ANYWHERE).ignoreCase());
		}

		// filtro zonas Contrato
		if (!Checks.esNulo(filtro.getZonasCto())) {
			query.createAlias("contrato.oficina", "oficinaCnt");
			query.createAlias("oficinaCnt.zona", "zonaCnt");

			Disjunction zonasContrato = Restrictions.disjunction();

			for (String codigoZona : filtro.getZonasCto().split(",")) {
				zonasContrato.add(Restrictions.like("zonaCnt.codigo", codigoZona, MatchMode.START));
			}

			where.add(zonasContrato);
		}

		// fitlro nif
		if (!Checks.esNulo(filtro.getNif())) {
			where.add(Restrictions.like("vListadoPreProyectadoExtCalc.titularDocId", filtro.getNif(), MatchMode.ANYWHERE).ignoreCase());
		}

		// filtro nombre completo
		if (!Checks.esNulo(filtro.getNombreCompleto())) {
			where.add(Restrictions.like("vListadoPreProyectadoExtCalc.titularNombreCompleto", filtro.getNombreCompleto(), MatchMode.ANYWHERE).ignoreCase());
		}

		return where;
	}

	/**
	 * Helper-method
	 * Genera las restricciones generales y añade los joins necesarios a la query
	 */
	private List<Criterion> restriccionesDatosGenerales(ListadoPreProyectadoDTO dto, Criteria query) {
		List<Criterion> where = new ArrayList<Criterion>();

		// filtro tramos
		if (!Checks.esNulo(dto.getTramos())) {
			where.add(Restrictions.in("vListadoPreProyectadoExtCalc.codTramo", dto.getTramos().split(",")));
		}

		// filtro dias vencidos
		where.addAll(floatRangeFilter("vListadoPreProyectadoExtCalc.diasVencidos", dto.getMinDiasVencidos(), dto.getMaxDiasVencidos())); 

		// filtro riesgo total 
		where.addAll(bigDecimalRangeFilter("vListadoPreProyectadoExtCalc.riesgoTotalExp", dto.getMinRiesgoTotal(), dto.getMaxRiesgoTotal()));

		// filtro deuda irregular
		where.addAll(bigDecimalRangeFilter("vListadoPreProyectadoExtCalc.deudaIrregularExp", dto.getMinDeudaIrregular(), dto.getMaxDeudaIrregular()));

		// filtro fecha prev Regularizacion
		where.addAll(dateRangeFilter("vListadoPreProyectadoExtCalc.fechaPrevReguCnt", dto.getFechaPrevRegularizacion(), dto.getFechaPrevRegularizacionHasta()));

		// filtro fecha pase mora
		where.addAll(dateRangeFilter("vListadoPreProyectadoExtCalc.fechaPaseAMoraExp", dto.getPaseMoraDesde(), dto.getPaseMoraHasta()));

		// Filtro estado gestión y tipo acuerdo/propuesta
		if (!Checks.esNulo(dto.getCodEstadoGestion()) || !Checks.esNulo(dto.getPropuestas())) {

			if (!Checks.esNulo(dto.getPropuestas())) {
				if (dto.getPropuestas().contains(DDTipoAcuerdo.SIN_PROPUESTA)) {
					query.createAlias("expediente.acuerdos", "acuerdo", CriteriaSpecification.LEFT_JOIN);
					query.createAlias("acuerdo.terminos", "terminos", CriteriaSpecification.LEFT_JOIN);
					query.createAlias("terminos.tipoAcuerdo", "tipoAcuerdo", CriteriaSpecification.LEFT_JOIN);
					
					String codPropuestas = dto.getPropuestas().replace(DDTipoAcuerdo.SIN_PROPUESTA, "");

					where.add(
							Restrictions.or(
									Restrictions.in("tipoAcuerdo.codigo", codPropuestas.split(",")), Restrictions.isNull("terminos.tipoAcuerdo")));
				} else {
					query.createAlias("expediente.acuerdos", "acuerdo");
					query.createAlias("acuerdo.terminos", "terminos");
					query.createAlias("terminos.tipoAcuerdo", "tipoAcuerdo");

					where.add(Restrictions.in("tipoAcuerdo.codigo", dto.getPropuestas().split(",")));
				}				
			} else {
				query.createAlias("expediente.acuerdos", "acuerdo");
				query.createAlias("acuerdo.terminos", "terminos");
			}

			if (!Checks.esNulo(dto.getCodEstadoGestion())) {
				query.createAlias("terminos.estadoGestion", "estadoGestion");

				where.add(Restrictions.eq("estadoGestion.codigo", dto.getCodEstadoGestion()));
			}
		}

		return where;
	}

	/**
	 * Helper-method
	 * 
	 * Añade requisitos de negocio a la busqueda de preproyectado 
	 */
	private List<Criterion> restriccionesNegocio(Criteria query) {
		List<Criterion> where = new ArrayList<Criterion>();

		// solo contratos activos
		where.add(Restrictions.eq("estadoContrato.codigo", DDEstadoContrato.ESTADO_CONTRATO_ACTIVO));

		// expedientes que no se encuentren en estado cancelado
		where.add(
				Restrictions.not(
						Restrictions.in("estadoExpediente.codigo", new String[]{DDEstadoExpediente.ESTADO_EXPEDIENTE_CANCELADO})));

		// solo expedientes de recuperacion
		query.createAlias("expediente.tipoExpediente", "tipoExpediente");
		where.add(Restrictions.eq("tipoExpediente.codigo", DDTipoExpediente.TIPO_EXPEDIENTE_RECUPERACION));
		
		// Sólo se muestran los expedientes con menos de 120 días vencidos
		where.add(Restrictions.between("vListadoPreProyectadoExtCalc.diasVencidos", 1l, 120l));

		return where;
	}

	private List<Criterion> bigDecimalRangeFilter(String field, BigDecimal from, BigDecimal to) {
		List<Criterion> where = new ArrayList<Criterion>();

		if (!Checks.esNulo(from)) {
			where.add(Restrictions.ge(field, from));
		}

		if (!Checks.esNulo(to)) {
			where.add(Restrictions.le(field, to));
		}

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

	private List<Criterion> floatRangeFilter(String field, Long from, Long to) {
		List<Criterion> where = new ArrayList<Criterion>();

		if (!Checks.esNulo(from)) {
			where.add(Restrictions.ge(field, from));
		}

		if (!Checks.esNulo(to)) {
			where.add(Restrictions.le(field, to));
		}

		return where;
	}
}

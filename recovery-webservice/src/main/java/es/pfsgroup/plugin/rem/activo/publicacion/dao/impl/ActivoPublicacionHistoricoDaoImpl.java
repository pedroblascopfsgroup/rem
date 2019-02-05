package es.pfsgroup.plugin.rem.activo.publicacion.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Criteria;
import org.hibernate.Hibernate;
import org.hibernate.criterion.Conjunction;
import org.hibernate.criterion.Disjunction;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.type.Type;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activo.publicacion.dao.ActivoPublicacionHistoricoDao;
import es.pfsgroup.plugin.rem.model.ActivoPublicacionHistorico;
import es.pfsgroup.plugin.rem.model.DtoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoPaginadoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionVenta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;

@Repository("ActivoPublicacionHistoricoDao")
public class ActivoPublicacionHistoricoDaoImpl extends AbstractEntityDao<ActivoPublicacionHistorico, Long> implements ActivoPublicacionHistoricoDao {

	private static final String SEPARADOR_VACIO = "-";
	private static final Log mLogger = LogFactory.getLog(ActivoPublicacionHistoricoDaoImpl.class);
	private static final Integer MILLISECONDS = 1000;
	private static final Integer SECONDS = 60;
	private static final Integer MINUTES = 60;
	private static final Integer HOURS = 24;
	private SimpleDateFormat sdfFecha = new SimpleDateFormat("dd-MM-yyyy");

	@Override
	public DtoPaginadoHistoricoEstadoPublicacion getListadoPaginadoHistoricoEstadosPublicacionVentaByIdActivo(DtoPaginadoHistoricoEstadoPublicacion dto) {
		Criteria criteria = getSession().createCriteria(ActivoPublicacionHistorico.class);
		Disjunction andFechas = Restrictions.disjunction();
		criteria.add(Restrictions.eq("activo.id", dto.getIdActivo())).createCriteria("tipoComercializacion").add(Restrictions.in("codigo", DDTipoComercializacion.CODIGOS_VENTA))
				.setMaxResults(dto.getLimit()).setFirstResult(dto.getStart());
		andFechas.add(Restrictions.isNotNull("fechaInicioVenta"));
		andFechas.add(Restrictions.isNotNull("fechaFinVenta"));
		criteria.add(andFechas);
		criteria.addOrder(Order.desc("auditoria.fechaCrear"));
		List<ActivoPublicacionHistorico> listadoEntidades = HibernateUtils.castList(ActivoPublicacionHistorico.class, criteria.list());

		List<DtoHistoricoEstadoPublicacion> listaDto = new ArrayList<DtoHistoricoEstadoPublicacion>();
		for (ActivoPublicacionHistorico historicoPublicacion : listadoEntidades) {
			listaDto.add(this.convertirEntidadTipoVentaToDto(historicoPublicacion));
		}

		Criteria criteriaCount = getSession().createCriteria(ActivoPublicacionHistorico.class);
		criteriaCount.setProjection(Projections.rowCount());
		criteriaCount.add(Restrictions.eq("activo.id", dto.getIdActivo())).createCriteria("tipoComercializacion").add(Restrictions.in("codigo", DDTipoComercializacion.CODIGOS_VENTA));
		Integer totalCount = HibernateUtils.castObject(Integer.class, criteriaCount.uniqueResult());

		DtoPaginadoHistoricoEstadoPublicacion dtoPaginado = new DtoPaginadoHistoricoEstadoPublicacion();
		dtoPaginado.setIdActivo(dto.getIdActivo());
		dtoPaginado.setListado(listaDto);
		dtoPaginado.setTotalCount(totalCount);
		return dtoPaginado;
	}

	@Override
	public DtoPaginadoHistoricoEstadoPublicacion getListadoHistoricoEstadosPublicacionAlquilerByIdActivo(DtoPaginadoHistoricoEstadoPublicacion dto) {
		Criteria criteria = getSession().createCriteria(ActivoPublicacionHistorico.class);
		Disjunction andFechas = Restrictions.disjunction();
		criteria.add(Restrictions.eq("activo.id", dto.getIdActivo())).createCriteria("tipoComercializacion").add(Restrictions.in("codigo", DDTipoComercializacion.CODIGOS_ALQUILER))
				.setMaxResults(dto.getLimit()).setFirstResult(dto.getStart());
		andFechas.add(Restrictions.isNotNull("fechaInicioAlquiler"));
		andFechas.add(Restrictions.isNotNull("fechaFinAlquiler"));
		criteria.add(andFechas);
		criteria.addOrder(Order.desc("auditoria.fechaCrear"));
		List<ActivoPublicacionHistorico> listadoEntidades = HibernateUtils.castList(ActivoPublicacionHistorico.class, criteria.list());

		List<DtoHistoricoEstadoPublicacion> listaDto = new ArrayList<DtoHistoricoEstadoPublicacion>();
		for (ActivoPublicacionHistorico historicoPublicacion : listadoEntidades) {
			listaDto.add(this.convertirEntidadTipoAlquilerToDto(historicoPublicacion));
		}

		Criteria criteriaCount = getSession().createCriteria(ActivoPublicacionHistorico.class);
		criteriaCount.setProjection(Projections.rowCount());
		criteriaCount.add(Restrictions.eq("activo.id", dto.getIdActivo())).createCriteria("tipoComercializacion").add(Restrictions.in("codigo", DDTipoComercializacion.CODIGOS_ALQUILER));
		Integer totalCount = HibernateUtils.castObject(Integer.class, criteriaCount.uniqueResult());

		DtoPaginadoHistoricoEstadoPublicacion dtoPaginado = new DtoPaginadoHistoricoEstadoPublicacion();
		dtoPaginado.setIdActivo(dto.getIdActivo());
		dtoPaginado.setListado(listaDto);
		dtoPaginado.setTotalCount(totalCount);
		return dtoPaginado;
	}

	/**
	 * Este método convierte una entidad HistoricoEstadoPublicacion de tipo venta a un pojo.
	 *
	 * @param entidad: entidad a convertir en un objeto plano.
	 * @return Devuelve un objeto DtoHistoricoEstadoPublicacion relleno con la información de la entidad.
	 */
	private DtoHistoricoEstadoPublicacion convertirEntidadTipoVentaToDto(ActivoPublicacionHistorico entidad) {
		DtoHistoricoEstadoPublicacion dto = new DtoHistoricoEstadoPublicacion();
		if (Checks.esNulo(entidad)) {
			return dto;
		}

		if (!Checks.esNulo(entidad.getActivo())) {
			dto.setIdActivo(entidad.getActivo().getId());
		}
		
		dto.setFechaDesde(entidad.getFechaInicioVenta());
		dto.setFechaHasta(entidad.getFechaFinVenta());
		dto.setOculto(entidad.getCheckOcultarVenta());
		if (!Checks.esNulo(entidad.getTipoPublicacionVenta())) {
			dto.setTipoPublicacion(entidad.getTipoPublicacionVenta().getDescripcion());
		} else {
			dto.setTipoPublicacion(SEPARADOR_VACIO);
		}
		if (!Checks.esNulo(entidad.getMotivoOcultacionVenta())) {
			dto.setMotivo(entidad.getMotivoOcultacionVenta().getDescripcion());
		}
		if (!Checks.esNulo(entidad.getAuditoria())) {
			dto.setUsuario(entidad.getAuditoria().getUsuarioCrear());
		}
		if (!Checks.esNulo(entidad.getEstadoPublicacionVenta())) {
			dto.setEstadoPublicacion(entidad.getEstadoPublicacionVenta().getDescripcion());
		}
		try {
			dto.setDiasPeriodo(this.obtenerDiasPorEstadoPublicacionVentaActivo(entidad));
		} catch (ParseException e) {
			mLogger.error("Error en ActivoPublicacionHistoricoDaoImpl al obtener días periodo", e);
		}

		return dto;
	}

	/**
	 * Este método convierte una entidad HistoricoEstadoPublicacion de tipo alquiler a un pojo.
	 *
	 * @param entidad: entidad a convertir en un objeto plano.
	 * @return Devuelve un obeto DtoHistoricoEstadoPublicacion relleno con la información de la entidad.
	 */
	private DtoHistoricoEstadoPublicacion convertirEntidadTipoAlquilerToDto(ActivoPublicacionHistorico entidad) {
		DtoHistoricoEstadoPublicacion dto = new DtoHistoricoEstadoPublicacion();
		if (Checks.esNulo(entidad)) {
			return dto;
		}

		if (!Checks.esNulo(entidad.getActivo())) {
			dto.setIdActivo(entidad.getActivo().getId());
		}
		
		dto.setFechaDesde(entidad.getFechaInicioAlquiler());
		dto.setFechaHasta(entidad.getFechaFinAlquiler());
		dto.setOculto(entidad.getCheckOcultarAlquiler());
		if (!Checks.esNulo(entidad.getTipoPublicacionAlquiler())) {
			dto.setTipoPublicacion(entidad.getTipoPublicacionAlquiler().getDescripcion());
		} else {
			dto.setTipoPublicacion(SEPARADOR_VACIO);
		}
		if (!Checks.esNulo(entidad.getMotivoOcultacionAlquiler())) {
			dto.setMotivo(entidad.getMotivoOcultacionAlquiler().getDescripcion());
		}
		if (!Checks.esNulo(entidad.getAuditoria())) {
			dto.setUsuario(entidad.getAuditoria().getUsuarioCrear());
		}
		if (!Checks.esNulo(entidad.getEstadoPublicacionAlquiler())) {
			dto.setEstadoPublicacion(entidad.getEstadoPublicacionAlquiler().getDescripcion());
		}
		try {
			dto.setDiasPeriodo(this.obtenerDiasPorEstadoPublicacionAlquilerActivo(entidad));
		} catch (ParseException e) {
			logger.error("Error en ActivoPublicacionHistoricoDaoImpl al obtener días periodo", e);
		}

		return dto;
	}

	@Override
	public Integer getTotalDeDiasEnEstadoPublicadoVentaPorIdActivo(Long idActivo) {
		Criteria criteria = getSession().createCriteria(ActivoPublicacionHistorico.class);
		criteria.setProjection(Projections.sqlProjection("NVL(sum(round({alias}.AHP_FECHA_FIN_VENTA - {alias}.AHP_FECHA_INI_VENTA)), 0) as totalDias", new String[]{ "totalDias" }, new Type[]{
				Hibernate.INTEGER }));
		criteria.add(Restrictions.eq("activo.id", idActivo)).createCriteria("estadoPublicacionVenta").add(Restrictions.eq("codigo", DDEstadoPublicacionVenta.CODIGO_PUBLICADO_VENTA));

		return HibernateUtils.castObject(Integer.class, criteria.uniqueResult());
	}

	@Override
	public Integer getTotalDeDiasEnEstadoPublicadoAlquilerPorIdActivo(Long idActivo) {
		Criteria criteria = getSession().createCriteria(ActivoPublicacionHistorico.class);
		criteria.setProjection(Projections.sqlProjection("NVL(sum(round({alias}.AHP_FECHA_FIN_ALQUILER - {alias}.AHP_FECHA_INI_ALQUILER)), 0) as totalDias", new String[]{ "totalDias" }, new Type[]{
				Hibernate.INTEGER }));
		criteria.add(Restrictions.eq("activo.id", idActivo)).createCriteria("estadoPublicacionVenta").add(Restrictions.eq("codigo", DDEstadoPublicacionAlquiler.CODIGO_PUBLICADO_ALQUILER));

		return HibernateUtils.castObject(Integer.class, criteria.uniqueResult());
	}

	@Override
	public Long obtenerDiasPorEstadoPublicacionVentaActivo(ActivoPublicacionHistorico estadoActivo) throws ParseException {
		Long dias = 0L;

		if (!Checks.esNulo(estadoActivo.getFechaInicioVenta())) {
			Date fechaDesdeSinTiempo = this.sdfFecha.parse(this.sdfFecha.format(estadoActivo.getFechaInicioVenta()));
			Date fechaHastaSinTiempo = new Date();
			if (!Checks.esNulo(estadoActivo.getFechaFinVenta())) {
				fechaHastaSinTiempo = this.sdfFecha.parse(this.sdfFecha.format(estadoActivo.getFechaFinVenta()));
			}
			Long diferenciaMilis = fechaHastaSinTiempo.getTime() - fechaDesdeSinTiempo.getTime();
			dias = diferenciaMilis / (MILLISECONDS * SECONDS * MINUTES * HOURS);
		}

		return dias;
	}

	@Override
	public Long obtenerDiasPorEstadoPublicacionAlquilerActivo(ActivoPublicacionHistorico estadoActivo) throws ParseException {
		Long dias = 0L;

		if (!Checks.esNulo(estadoActivo.getFechaInicioAlquiler())) {
			Date fechaDesdeSinTiempo = this.sdfFecha.parse(this.sdfFecha.format(estadoActivo.getFechaInicioAlquiler()));
			Date fechaHastaSinTiempo = new Date();
			if (!Checks.esNulo(estadoActivo.getFechaFinAlquiler())) {
				fechaHastaSinTiempo = this.sdfFecha.parse(this.sdfFecha.format(estadoActivo.getFechaFinAlquiler()));
			}
			Long diferenciaMilis = fechaHastaSinTiempo.getTime() - fechaDesdeSinTiempo.getTime();
			dias = diferenciaMilis / (MILLISECONDS * SECONDS * MINUTES * HOURS);
		}

		return dias;
	}
	
	public ActivoPublicacionHistorico getActivoPublicacionHistoricoActual(Long idActivo) {
		Criteria criteria = getSession().createCriteria(ActivoPublicacionHistorico.class);
		criteria.add(Restrictions.eq("activo.id", idActivo));
		criteria.add(Restrictions.isNull("fechaFinVenta"));
		criteria.add(Restrictions.isNull("fechaFinAlquiler"));
		criteria.add(Restrictions.isNotNull("fechaInicioAlquiler"));
		criteria.add(Restrictions.isNotNull("fechaInicioVenta"));
		criteria.add(Restrictions.eq("auditoria.borrado", false));
		criteria.addOrder(Order.desc("auditoria.fechaCrear"));

		List<ActivoPublicacionHistorico> historicos = HibernateUtils.castList(ActivoPublicacionHistorico.class, criteria.list());
		
		if(!Checks.esNulo(historicos) && !historicos.isEmpty())
			return historicos.get(0);
		else
			return null;
	}
}
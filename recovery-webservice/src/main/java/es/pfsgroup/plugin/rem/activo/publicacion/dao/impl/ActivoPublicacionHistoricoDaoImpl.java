package es.pfsgroup.plugin.rem.activo.publicacion.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Repository;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activo.publicacion.dao.ActivoPublicacionHistoricoDao;
import es.pfsgroup.plugin.rem.model.ActivoPublicacionHistorico;
import es.pfsgroup.plugin.rem.model.DtoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionVenta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;

@Repository("ActivoPublicacionHistoricoDao")
public class ActivoPublicacionHistoricoDaoImpl extends AbstractEntityDao<ActivoPublicacionHistorico, Long> implements ActivoPublicacionHistoricoDao {

	private static final String SEPARADOR_VACIO = "-";
	protected static final Log mLogger = LogFactory.getLog(ActivoPublicacionHistoricoDaoImpl.class);
	private SimpleDateFormat sdfFecha = new SimpleDateFormat("dd-MM-yyyy");

	@Override
	public List<ActivoPublicacionHistorico> getListadoHistoricoEstadosPublicacionVentaByIdActivo(DtoHistoricoEstadoPublicacion dto) {
		HQLBuilder hql = new HQLBuilder("from ActivoPublicacionHistorico");
		HQLBuilder.addFiltroIgualQue(hql, "activo.id", dto.getIdActivo());
		HQLBuilder.addFiltroWhereInSiNotNull(hql, "tipoComercializacion.codigo", Arrays.asList(DDTipoComercializacion.CODIGOS_VENTA));
		hql.orderBy("id", HQLBuilder.ORDER_DESC);
		Page p = HibernateQueryUtils.page(this, hql, dto);

		return HibernateUtils.castList(ActivoPublicacionHistorico.class, p.getResults());

	}

	@Override
	public List<ActivoPublicacionHistorico> getListadoHistoricoEstadosPublicacionAlquilerByIdActivo(DtoHistoricoEstadoPublicacion dto) {
		HQLBuilder hql = new HQLBuilder("from ActivoPublicacionHistorico");
		HQLBuilder.addFiltroIgualQue(hql, "activo.id", dto.getIdActivo());
		HQLBuilder.addFiltroWhereInSiNotNull(hql, "tipoComercializacion.codigo", Arrays.asList(DDTipoComercializacion.CODIGOS_ALQUILER));
		hql.orderBy("id", HQLBuilder.ORDER_DESC);
		Page p = HibernateQueryUtils.page(this, hql, dto);

		return HibernateUtils.castList(ActivoPublicacionHistorico.class, p.getResults());
	}

	@Override
	public DtoHistoricoEstadoPublicacion convertirEntidadTipoVentaToDto(ActivoPublicacionHistorico entidad) {
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
		if (!Checks.esNulo(entidad.getTipoPublicacion())) {
			dto.setTipoPublicacion(entidad.getTipoPublicacion().getDescripcion());
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

	@Override
	public DtoHistoricoEstadoPublicacion convertirEntidadTipoAlquilerToDto(ActivoPublicacionHistorico entidad) {
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
		if (!Checks.esNulo(entidad.getTipoPublicacion())) {
			dto.setTipoPublicacion(entidad.getTipoPublicacion().getDescripcion());
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

	/**
	 * Este método obtiene el conteo de días que se pasa un activo en un mismo estado de publicacion
	 * para el tipo destino comercial venta. Se limita al estado de 'Publicado'. Para el resto de
	 * estados devuelve 0.
	 * 
	 * @param estadoActivo: estado del activo del cual calcular sus días.
	 * @return Devuelve el número de días que ha estado un activo en un mismo estado.
	 * @throws ParseException
	 */
	private Long obtenerDiasPorEstadoPublicacionVentaActivo(ActivoPublicacionHistorico estadoActivo) throws ParseException {
		Long dias = 0L;

		if (DDEstadoPublicacionVenta.CODIGO_PUBLICADO_VENTA.equals(estadoActivo.getEstadoPublicacionVenta().getCodigo()) && !Checks.esNulo(estadoActivo.getFechaInicioVenta())) {
			Date fechaDesdeSinTiempo = this.sdfFecha.parse(this.sdfFecha.format(estadoActivo.getFechaInicioVenta()));
			Date fechaHastaSinTiempo = new Date();
			if (!Checks.esNulo(estadoActivo.getFechaFinVenta())) {
				fechaHastaSinTiempo = this.sdfFecha.parse(this.sdfFecha.format(estadoActivo.getFechaFinVenta()));
			}
			Long diferenciaMilis = fechaHastaSinTiempo.getTime() - fechaDesdeSinTiempo.getTime();
			dias = diferenciaMilis / (1000 * 60 * 60 * 24);
		}

		return dias;
	}

	/**
	 * Este método obtiene el conteo de días que se pasa un activo en un mismo estado de publicacion
	 * para el tipo destino comercial alquiler. Se limita al estado de 'Publicado'. Para el resto de
	 * estados devuelve 0.
	 * 
	 * @param estadoActivo: estado del activo del cual calcular sus días.
	 * @return Devuelve el número de días que ha estado un activo en un mismo estado.
	 * @throws ParseException
	 */
	private Long obtenerDiasPorEstadoPublicacionAlquilerActivo(ActivoPublicacionHistorico estadoActivo) throws ParseException {
		Long dias = 0L;

		if (DDEstadoPublicacionAlquiler.CODIGO_PUBLICADO_ALQUILER.equals(estadoActivo.getEstadoPublicacionAlquiler().getCodigo()) && !Checks.esNulo(estadoActivo.getFechaInicioAlquiler())) {
			Date fechaDesdeSinTiempo = this.sdfFecha.parse(this.sdfFecha.format(estadoActivo.getFechaInicioAlquiler()));
			Date fechaHastaSinTiempo = new Date();
			if (!Checks.esNulo(estadoActivo.getFechaFinAlquiler())) {
				fechaHastaSinTiempo = this.sdfFecha.parse(this.sdfFecha.format(estadoActivo.getFechaFinAlquiler()));
			}
			Long diferenciaMilis = fechaHastaSinTiempo.getTime() - fechaDesdeSinTiempo.getTime();
			dias = diferenciaMilis / (1000 * 60 * 60 * 24);
		}

		return dias;
	}
}
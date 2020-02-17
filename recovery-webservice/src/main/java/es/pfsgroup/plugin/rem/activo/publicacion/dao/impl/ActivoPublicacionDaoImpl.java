package es.pfsgroup.plugin.rem.activo.publicacion.dao.impl;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.publicacion.dao.ActivoPublicacionDao;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionActivo;
import es.pfsgroup.plugin.rem.model.HistoricoFasePublicacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionVenta;
import org.hibernate.Criteria;
import org.hibernate.Hibernate;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.type.Type;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.Date;

@Repository("ActivoPublicacionDao")
public class ActivoPublicacionDaoImpl extends AbstractEntityDao<ActivoPublicacion, Long> implements ActivoPublicacionDao {
	
	@Autowired
	private ActivoDao activoDao;

	@Override
	public DtoDatosPublicacionActivo convertirEntidadTipoToDto(ActivoPublicacion entidad) {
		DtoDatosPublicacionActivo dto = new DtoDatosPublicacionActivo();
		if (Checks.esNulo(entidad)) {
			return dto;
		}
		
		dto.setIdActivo(entidad.getActivo().getId());
		if(!Checks.esNulo(entidad.getActivo().getId())) {
			dto.setIsMatriz(activoDao.isActivoMatriz(entidad.getActivo().getId()));
			
		}
		if (!Checks.esNulo(entidad.getEstadoPublicacionVenta())) {
			dto.setEstadoPublicacionVenta(entidad.getEstadoPublicacionVenta().getDescripcion());
		}
		
		if (!Checks.esNulo(entidad.getEstadoPublicacionAlquiler())) {
			dto.setEstadoPublicacionAlquiler(entidad.getEstadoPublicacionAlquiler().getDescripcion());
			dto.setEstadoPublicacionAlquilerCodigo(entidad.getEstadoPublicacionAlquiler().getCodigo());
		}
		
		dto.setPublicarVenta(entidad.getCheckPublicarVenta());
		dto.setOcultarVenta(entidad.getCheckOcultarVenta());
		dto.setMotivoPublicacion(entidad.getMotivoPublicacion());
		dto.setMotivoPublicacionAlquiler(entidad.getMotivoPublicacionAlquiler());
		dto.setPublicarSinPrecioVenta(entidad.getCheckSinPrecioVenta());
		dto.setNoMostrarPrecioVenta(entidad.getCheckOcultarPrecioVenta());
		
		if (!Checks.esNulo(entidad.getMotivoOcultacionVenta())) {
			dto.setMotivoOcultacionVentaCodigo(entidad.getMotivoOcultacionVenta().getCodigo());
		}
		
		if(!Checks.esNulo(entidad.getFechaRevisionPublicacionesVenta())) {
			dto.setFechaRevisionPublicacionesVenta(entidad.getFechaRevisionPublicacionesVenta());
		}
		
		if(!Checks.esNulo(entidad.getFechaRevisionPublicacionesAlquiler())) {
			dto.setFechaRevisionPublicacionesAlquiler(entidad.getFechaRevisionPublicacionesAlquiler());
		}
		
		dto.setMotivoOcultacionManualVenta(entidad.getMotivoOcultacionManualVenta());
		dto.setPublicarAlquiler(entidad.getCheckPublicarAlquiler());
		dto.setOcultarAlquiler(entidad.getCheckOcultarAlquiler());
		dto.setPublicarSinPrecioAlquiler(entidad.getCheckSinPrecioAlquiler());
		dto.setNoMostrarPrecioAlquiler(entidad.getCheckOcultarPrecioAlquiler());
		
		if (!Checks.esNulo(entidad.getMotivoOcultacionAlquiler())) {
			dto.setMotivoOcultacionAlquilerCodigo(entidad.getMotivoOcultacionAlquiler().getCodigo());
		}
		
		dto.setMotivoOcultacionManualAlquiler(entidad.getMotivoOcultacionManualAlquiler());
		dto.setFechaInicioEstadoVenta(entidad.getFechaInicioVenta());
		dto.setFechaInicioEstadoAlquiler(entidad.getFechaInicioAlquiler());
		if(DDCartera.CODIGO_CARTERA_BANKIA.equals(entidad.getActivo().getCartera().getCodigo())){
			
			if(!Checks.esNulo(entidad.getFechaCambioPubAlq())) {
				Date fechaInicial=entidad.getFechaCambioPubAlq();
				Date fechaFinal=new Date();
				Integer dias=(int) (((long)fechaFinal.getTime()-(long)fechaInicial.getTime())/86400000);
				dto.setDiasCambioPublicacionAlquiler(dias);
			}
			

			if(!Checks.esNulo(entidad.getFechaCambioPubVenta())){
				Date fechaInicialVenta=entidad.getFechaCambioPubVenta();
				Date fechaFinalVenta=new Date();
				Integer dias=(int) (((long)fechaFinalVenta.getTime()-(long)fechaInicialVenta.getTime())/86400000);
				dto.setDiasCambioPublicacionVenta(dias);
			}
			
		}
		
		
		if(!Checks.esNulo(entidad.getTipoPublicacionVenta())) {
			dto.setTipoPublicacionVentaCodigo(entidad.getTipoPublicacionVenta().getCodigo());
			dto.setTipoPublicacionVentaDescripcion(entidad.getTipoPublicacionVenta().getDescripcion());
		}
		if(!Checks.esNulo(entidad.getTipoPublicacionAlquiler())) {
			dto.setTipoPublicacionAlquilerCodigo(entidad.getTipoPublicacionAlquiler().getCodigo());
			dto.setTipoPublicacionAlquilerDescripcion(entidad.getTipoPublicacionAlquiler().getDescripcion());
		}
		if ( entidad.getPortal() != null) {
			dto.setCanalDePublicacion(entidad.getPortal().getCodigo());
		}

		return dto;
	}

	@Override
	public Integer getDiasEnEstadoActualPublicadoVentaPorIdActivo(Long idActivo) {
		Criteria criteria = this.getSessionFactory().getCurrentSession().createCriteria(ActivoPublicacion.class);
		criteria.setProjection(Projections.sqlProjection("NVL(sum(round(sysdate - {alias}.APU_FECHA_INI_VENTA)), 0) as totalDias", new String[]{ "totalDias" }, new Type[]{ Hibernate.INTEGER }));
		criteria.add(Restrictions.eq("activo.id", idActivo)).createCriteria("estadoPublicacionVenta").add(Restrictions.eq("codigo", DDEstadoPublicacionVenta.CODIGO_PUBLICADO_VENTA));

		return HibernateUtils.castObject(Integer.class, criteria.uniqueResult());
	}

	@Override
	public Integer getDiasEnEstadoActualPublicadoAlquilerPorIdActivo(Long idActivo) {
		Criteria criteria = this.getSessionFactory().getCurrentSession().createCriteria(ActivoPublicacion.class);
		criteria.setProjection(Projections.sqlProjection("NVL(sum(round(sysdate - {alias}.APU_FECHA_INI_ALQUILER)), 0) as totalDias", new String[]{ "totalDias" }, new Type[]{ Hibernate.INTEGER }));
		criteria.add(Restrictions.eq("activo.id", idActivo)).createCriteria("estadoPublicacionAlquiler").add(Restrictions.eq("codigo", DDEstadoPublicacionAlquiler.CODIGO_PUBLICADO_ALQUILER));

		return HibernateUtils.castObject(Integer.class, criteria.uniqueResult());
	}

	@Override
	public ActivoPublicacion getActivoPublicacionPorIdActivo(Long idActivo) {
		Criteria criteria = this.getSessionFactory().getCurrentSession().createCriteria(ActivoPublicacion.class);
		criteria.add(Restrictions.eq("activo.id", idActivo));

		return HibernateUtils.castObject(ActivoPublicacion.class, criteria.uniqueResult());
	}

	@Override
	public Boolean getCheckSinPrecioVentaPorIdActivo(Long idActivo) {
		Criteria criteria = this.getSessionFactory().getCurrentSession().createCriteria(ActivoPublicacion.class);
		criteria.setProjection(Projections.property("checkSinPrecioVenta"));
		criteria.add(Restrictions.eq("activo.id", idActivo));

		return HibernateUtils.castObject(Boolean.class, criteria.uniqueResult());
	}

	@Override
	public Boolean getCheckSinPrecioAlquilerPorIdActivo(Long idActivo) {
		Criteria criteria = this.getSessionFactory().getCurrentSession().createCriteria(ActivoPublicacion.class);
		criteria.setProjection(Projections.property("checkSinPrecioAlquiler"));
		criteria.add(Restrictions.eq("activo.id", idActivo));

		return HibernateUtils.castObject(Boolean.class, criteria.uniqueResult());
	}

	@Override
	public Date getFechaInicioEstadoActualPublicacionVenta(Long idActivo) {
		Criteria criteria = this.getSessionFactory().getCurrentSession().createCriteria(ActivoPublicacion.class);
		criteria.setProjection(Projections.property("fechaInicioVenta"));
		criteria.add(Restrictions.eq("activo.id", idActivo)).createCriteria("estadoPublicacionVenta")
				.add(Restrictions.in("codigo", new String[] {DDEstadoPublicacionVenta.CODIGO_PUBLICADO_VENTA, DDEstadoPublicacionVenta.CODIGO_OCULTO_VENTA}));

		return HibernateUtils.castObject(Date.class, criteria.uniqueResult());
	}
	
	@Override
	public HistoricoFasePublicacionActivo getFasePublicacionVigentePorIdActivo(Long idActivo) {
		Criteria criteria = this.getSessionFactory().getCurrentSession().createCriteria(HistoricoFasePublicacionActivo.class);
		criteria.add(Restrictions.eq("activo.id", idActivo));
		criteria.add(Restrictions.isNull("fechaFin"));
		return HibernateUtils.castObject(HistoricoFasePublicacionActivo.class, criteria.uniqueResult());
	}
}
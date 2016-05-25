package es.pfsgroup.plugin.recovery.config.delegaciones.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.ProjectionList;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.dao.impl.PageSql;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.config.delegaciones.dao.DelegacionDao;
import es.pfsgroup.plugin.recovery.config.delegaciones.dto.DelegacionBusquedaDto;
import es.pfsgroup.plugin.recovery.config.delegaciones.dto.DelegacionFiltrosBusquedaDto;
import es.pfsgroup.plugin.recovery.config.delegaciones.model.Delegacion;

@Repository
public class DelegacionDaoImpl extends AbstractEntityDao<Delegacion, Long> implements DelegacionDao {

	@SuppressWarnings("unchecked")
	@Override
	public Page getDelegaciones(DelegacionFiltrosBusquedaDto dto) {
		
		Criteria query = getCriteriaQueryDelegaciones(dto);
		
		ProjectionList select = Projections.projectionList();
		
		select.add(Projections.property("delegacion.id").as("id"));
		select.add(Projections.property("delegacion.fechaIniVigencia").as("fechaIniVigencia"));
		select.add(Projections.property("delegacion.fechaFinVigencia").as("fechaFinVigencia"));
		select.add(Projections.property("delegacion.estado").as("estado"));
		select.add(Projections.property("delegacion.usuarioOrigen").as("usuarioOrigen"));
		select.add(Projections.property("delegacion.usuarioDestino").as("usuarioDestino"));
		select.add(Projections.property("delegacion.auditoria.fechaCrear").as("fechaCrear"));
		select.add(Projections.property("delegacion.auditoria.usuarioCrear").as("usuarioCrear"));
		
		query.setProjection(select);
		
		query.addOrder(Order.asc("delegacion.fechaIniVigencia"));
		
		query.setFirstResult(dto.getStart());
		query.setMaxResults(dto.getLimit());
		
		query.setResultTransformer(Transformers.aliasToBean(DelegacionBusquedaDto.class));

		List<Delegacion> lista = query.list();

		PageSql page = new PageSql();
		
		page.setResults(lista);
		page.setTotalCount(getCountDelegaciones(dto));

		return page;
	}
	
	
	private int getCountDelegaciones(DelegacionFiltrosBusquedaDto dto){
		
		Criteria query = getCriteriaQueryDelegaciones(dto);

		query.setProjection(Projections.rowCount());
		
		return (Integer) query.uniqueResult();
		
	}
	
	
	private Criteria getCriteriaQueryDelegaciones(DelegacionFiltrosBusquedaDto dto){
		
		SimpleDateFormat frmt = new SimpleDateFormat("dd/MM/yyyy");

		Criteria query = getSession().createCriteria(Delegacion.class, "delegacion");
		
		query.createAlias("usuarioOrigen", "usuarioOrigen", CriteriaSpecification.LEFT_JOIN);
		query.createAlias("usuarioDestino", "usuarioDestino", CriteriaSpecification.LEFT_JOIN);
		query.createAlias("auditoria", "auditoria", CriteriaSpecification.LEFT_JOIN);
		query.createAlias("estado", "estadoDelegacion");
		
		if(!Checks.esNulo(dto.getUsuarioOrigen())){
			query.add(Restrictions.eq("usuarioOrigen.id", dto.getUsuarioOrigen()));
		}
		
		if(!Checks.esNulo(dto.getUsuarioDestino())){
			query.add(Restrictions.eq("usuarioDestino.id", dto.getUsuarioDestino()));
		}
		
		if(!Checks.esNulo(dto.getFechaDesdeIniVigencia())){
			try {
				query.add(Restrictions.ge("delegacion.fechaIniVigencia", frmt.parse(dto.getFechaDesdeIniVigencia())));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		
		if(!Checks.esNulo(dto.getFechaHastaIniVigencia())){
			try {
				query.add(Restrictions.le("delegacion.fechaIniVigencia", frmt.parse(dto.getFechaHastaIniVigencia())));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		
		if(!Checks.esNulo(dto.getFechaDesdeFinVigencia())){
			try {
				query.add(Restrictions.ge("delegacion.fechaFinVigencia", frmt.parse(dto.getFechaDesdeFinVigencia())));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		
		if(!Checks.esNulo(dto.getFechaHastaFinVigencia())){
			try {
				query.add(Restrictions.le("delegacion.fechaFinVigencia", frmt.parse(dto.getFechaHastaFinVigencia())));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		
		if(!Checks.esNulo(dto.getEstado())){
			query.add(Restrictions.eq("estadoDelegacion.codigo", dto.getEstado()));
		}
		
		return query;
		
	}
	
	
}

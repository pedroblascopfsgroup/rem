package es.pfsgroup.framework.paradise.gestorEntidad.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.cfg.HbmBinder;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.GestorEntidadHistoricoDao;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;

public class GestorEntidadHistoricoDaoImpl extends AbstractEntityDao<GestorEntidadHistorico, Long> implements GestorEntidadHistoricoDao {
	
	@SuppressWarnings("unchecked")
	public List<GestorEntidadHistorico> getListGestorActivoOrderedByEntidad(GestorEntidadDto dto) {

		HQLBuilder hqlBuilder = new HQLBuilder("from GestorEntidadHistorico geh");
		resuelveTipoEntidadconParam(dto.getTipoEntidad(), dto.getIdEntidad(), hqlBuilder);
		HQLBuilder.addFiltroIsNull(hqlBuilder, "geh.fechaHasta");
		hqlBuilder.orderByMultiple("geh.tipoGestor.descripcion asc, geh.fechaDesde desc");

		return HibernateQueryUtils.list(this, hqlBuilder);
		
	}

	@SuppressWarnings("unchecked")
	public List<GestorEntidadHistorico> getListOrderedByEntidad(GestorEntidadDto dto) {

		HQLBuilder hqlBuilder = new HQLBuilder("from GestorEntidadHistorico geh");
		resuelveTipoEntidadconParam(dto.getTipoEntidad(), dto.getIdEntidad(), hqlBuilder);
		hqlBuilder.orderByMultiple("geh.tipoGestor.descripcion asc, geh.fechaDesde desc");

		return HibernateQueryUtils.list(this, hqlBuilder);
		
	}

	private String resuelveTipoEntidad(String tipoEntidad, Long idEntidad) {
		String where = "";
		
		if (GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad)) {
			where = " where geh.expediente.id = '"+idEntidad+"'";
		}

		if (GestorEntidadDto.TIPO_ENTIDAD_ASUNTO.equals(tipoEntidad)) {
			where = " where geh.asunto.id = '"+idEntidad+"'";
		}
		
		if (GestorEntidadDto.TIPO_ENTIDAD_ACTIVO.equals(tipoEntidad)) {
			where = " where geh.activo.id = '"+idEntidad+"'";
		}
		
		if (GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL.equals(tipoEntidad)) {
			where = " where geh.expedienteComercial.id = '"+idEntidad+"'";
		}

		return where;
	}

	public void actualizarFechaHasta(Long idEntidad, Long idTipoGestor, String tipoEntidad) {
		
		StringBuilder hqlUpdate = new StringBuilder("update GestorEntidadHistorico geh set geh.fechaHasta = sysdate ");
		
		if(GestorEntidadDto.TIPO_ENTIDAD_ASUNTO.equals(tipoEntidad)){		
        	hqlUpdate.append(" where geh.asunto.id ='"+idEntidad+"'");
		}
		else if(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad)){		
        	hqlUpdate.append(" where geh.expediente.id = '"+idEntidad+"'");
		}
		else if(GestorEntidadDto.TIPO_ENTIDAD_ACTIVO.equals(tipoEntidad)){
			hqlUpdate.append(" where geh.activo.id = '"+idEntidad+"'");
		}
		else if(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL.equals(tipoEntidad)){
			hqlUpdate.append(" where geh.expedienteComercial.id = '"+idEntidad+"'");
		}
		
        hqlUpdate.append(" and gah.tipoGestor.id = :idGestor and gah.fechaHasta is null");
        
        Query queryUpdate = this.getSessionFactory().getCurrentSession().createQuery(hqlUpdate.toString());

        queryUpdate.setParameter("idGestor", idTipoGestor);
        
        queryUpdate.executeUpdate();

	}
	
	private void resuelveTipoEntidadconParam(String tipoEntidad, Long idEntidad,HQLBuilder hq) {
		
		if (GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad)) {
			HQLBuilder.addFiltroIgualQue(hq, "geh.expediente.id", idEntidad);
		}

		if (GestorEntidadDto.TIPO_ENTIDAD_ASUNTO.equals(tipoEntidad)) {
			HQLBuilder.addFiltroIgualQue(hq, "geh.asunto.id", idEntidad);
		}
		
		if (GestorEntidadDto.TIPO_ENTIDAD_ACTIVO.equals(tipoEntidad)) {
			HQLBuilder.addFiltroIgualQue(hq, "geh.activo.id", idEntidad);
		}
		
		if (GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL.equals(tipoEntidad)) {
			HQLBuilder.addFiltroIgualQue(hq, "geh.expedienteComercial.id", idEntidad);
		}
	}

}

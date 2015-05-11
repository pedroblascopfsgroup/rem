package es.pfsgroup.plugin.recovery.expediente.gestorEntidad.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.expediente.gestorEntidad.dao.GestorEntidadHistoricoDao;
import es.pfsgroup.plugin.recovery.expediente.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.recovery.expediente.gestorEntidad.model.GestorEntidadHistorico;

@Repository("GestorEntidadHistoricoDao")
public class GestorEntidadHistoricoDaoImpl extends AbstractEntityDao<GestorEntidadHistorico, Long> implements GestorEntidadHistoricoDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<GestorEntidadHistorico> getListOrderedByEntidad(GestorEntidadDto dto) {

		StringBuilder hqlList = new StringBuilder(" from GestorEntidadHistorico geh ");
		hqlList.append(resuelveTipoEntidad(dto.getTipoEntidad(), dto.getIdEntidad()));
		hqlList.append(" order by geh.tipoGestor.descripcion asc, geh.fechaDesde desc");
		Query queryList = this.getSession().createQuery(hqlList.toString());

		
		return queryList.list();
	}

	private String resuelveTipoEntidad(String tipoEntidad, Long idEntidad) {
		String where = "";
		
		if (GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad)) {
			where = " where geh.expediente.id = '"+idEntidad+"'";
		}

		if (GestorEntidadDto.TIPO_ENTIDAD_ASUNTO.equals(tipoEntidad)) {
			where = " where geh.asunto.id = '"+idEntidad+"'";
		}

		return where;
	}

	@Override
	public void actualizarFechaHasta(Long idEntidad, Long idTipoGestor, String tipoEntidad) {
		
		StringBuilder hqlUpdate = new StringBuilder("update GestorEntidadHistorico geh set geh.fechaHasta = sysdate ");
		
		if(GestorEntidadDto.TIPO_ENTIDAD_ASUNTO.equals(tipoEntidad)){		
        	hqlUpdate.append(" where geh.asunto.id ='"+idEntidad+"'");
		}
		else if(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad)){		
        	hqlUpdate.append(" where geh.expediente.id = '"+idEntidad+"'");
		}
		
        hqlUpdate.append(" and gah.tipoGestor.id = :idGestor and gah.fechaHasta is null");
        
        Query queryUpdate = this.getSession().createQuery(hqlUpdate.toString());

        queryUpdate.setParameter("idGestor", idTipoGestor);
        
        queryUpdate.executeUpdate();

	}

}

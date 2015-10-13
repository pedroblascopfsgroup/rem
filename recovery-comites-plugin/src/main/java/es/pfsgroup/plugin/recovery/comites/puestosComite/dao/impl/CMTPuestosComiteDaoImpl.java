package es.pfsgroup.plugin.recovery.comites.puestosComite.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.comite.model.PuestosComite;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.comites.puestosComite.dao.CMTPuestosComiteDao;

@Repository("CMTPuestosComiteDao")
public class CMTPuestosComiteDaoImpl extends AbstractEntityDao<PuestosComite, Long> implements CMTPuestosComiteDao {

	@Override
	public List<PuestosComite> getPuestosComite(Long idComite) {
		HQLBuilder hb = new HQLBuilder("from PuestosComite pc");
		hb.appendWhere("pc.auditoria.borrado=0");
		
		HQLBuilder.addFiltroIgualQue(hb, "pc.comite.id", idComite);
		
		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public PuestosComite createNewPuestoComite() {
		PuestosComite puesto = new PuestosComite();
		//puesto.setId(getLastId()+1);
		// si no existe ningun puesto en la bbdd el id devuelve nulo por tanto por defecto se pone 1
		Long lastId = getLastId();
		if(lastId != null){
			puesto.setId(lastId +1);
		}else{
			puesto.setId(1L);
		}
		return puesto;
		
	}

	private Long getLastId() {
		HQLBuilder b = new HQLBuilder("select max(id) from PuestosComite");
		return  (Long) getSession().createQuery(b.toString()).uniqueResult();
	}

}

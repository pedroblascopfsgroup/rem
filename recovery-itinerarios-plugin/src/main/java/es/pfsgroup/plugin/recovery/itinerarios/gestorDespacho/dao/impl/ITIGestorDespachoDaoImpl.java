package es.pfsgroup.plugin.recovery.itinerarios.gestorDespacho.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.itinerarios.gestorDespacho.dao.ITIGestorDespachoDao;

@Repository("ITIGestorDespachoDao")
public class ITIGestorDespachoDaoImpl extends AbstractEntityDao<GestorDespacho, Long>
	implements ITIGestorDespachoDao{

	
	@Override
	public List<GestorDespacho> getGestores() {
		HQLBuilder b = new HQLBuilder("from GestorDespacho gd");
		b.appendWhere("gd.auditoria.borrado=0");
		
		HQLBuilder.addFiltroIgualQue(b, "gd.supervisor", false);
		
		return HibernateQueryUtils.list(this, b);
		
		
	}
	
	public List<GestorDespacho> getSupervisores(){
		HQLBuilder b = new HQLBuilder("from GestorDespacho gd");
		b.appendWhere("gd.auditoria.borrado=0");
		
		HQLBuilder.addFiltroIgualQue(b, "gd.supervisor", true);
		
		return HibernateQueryUtils.list(this, b);
		
	}

}

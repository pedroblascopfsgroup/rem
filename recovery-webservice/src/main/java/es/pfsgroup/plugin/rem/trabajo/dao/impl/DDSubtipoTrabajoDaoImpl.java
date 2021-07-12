package es.pfsgroup.plugin.rem.trabajo.dao.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.trabajo.dao.DDSubtipoTrabajoDao;

@Repository("SubtipoTrabajoDao")
public class DDSubtipoTrabajoDaoImpl extends AbstractEntityDao<DDSubtipoTrabajo, Long> implements DDSubtipoTrabajoDao{
	
	
	@Autowired
	GenericABMDao genericDao;

	@SuppressWarnings("unchecked")
	@Override
	public List<DDSubtipoTrabajo> getSubtipoTrabajoconTarifaPlana(Long idCarteraActivo, Long idTipoTrabajo, Date fechaSolicitud) {

 		String hql= "select sbtr from DDSubtipoTrabajo sbtr,HistoricoTarifaPlana htp ";
		
		HQLBuilder hb = new HQLBuilder(hql);
		
		hb.appendWhere("sbtr.id = htp.subtipoTrabajo.id and htp.esTarifaPlana = 1 and htp.fechaInicioTarifaPlana <= TO_DATE(SYSDATE,'DD/MM/YY')  and (htp.fechaFinTarifaPlana >=TO_DATE(SYSDATE,'DD/MM/YY') or htp.fechaFinTarifaPlana is null)");
		HQLBuilder.addFiltroIgualQue(hb, "sbtr.tipoTrabajo.id", idTipoTrabajo);
		HQLBuilder.addFiltroIgualQue(hb, "htp.carteraTP.id", idCarteraActivo);
		
		return HibernateQueryUtils.list(this,hb);
	
	
	}

}

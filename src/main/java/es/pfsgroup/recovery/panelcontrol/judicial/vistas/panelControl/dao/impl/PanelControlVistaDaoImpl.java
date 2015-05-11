package es.pfsgroup.recovery.panelcontrol.judicial.vistas.panelControl.dao.impl;


import org.hibernate.Query;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.panelcontrol.judicial.dto.DtoPanelControl;
import es.pfsgroup.recovery.panelcontrol.judicial.vistas.panelControl.dao.PanelControlVistaDao;
import es.pfsgroup.recovery.panelcontrol.judicial.vistas.panelControl.model.PanelControlVista;

@Repository
public class PanelControlVistaDaoImpl  extends AbstractEntityDao<PanelControlVista, Long> implements PanelControlVistaDao{

	
	
	@Override
	public DtoPanelControl getDatosZona(String nivel, String cod) {
		
		StringBuffer query = new StringBuffer();
		query.append(" select sum(pcv.clientes) as clientes, sum(pcv.contratosTotal) as contratosTotal, sum(pcv.contratosIrregulares) as contratosIrregulares, ");
		query.append(" sum(pcv.saldoVencido) as saldoVencido, sum(pcv.saldoNoVencido) as saldoNoVencido, sum(pcv.saldoNoVencidoDanyado) as saldoNoVencidoDanyado ");
	    query.append(", sum(tareasPendientesVencidas) as tareasPendientesVencidas, sum(tareasPendientesHoy) as tareasPendientesHoy, sum(tareasPendientesMes) as tareasPendientesMes, sum(tareasPendientesSemana) as tareasPendientesSemana");
		query.append(" from PanelControlVista pcv  ");
		query.append(" where pcv.cod like '"+cod+"%'");
		
		Query q = getHibernateTemplate().getSessionFactory().getCurrentSession().createQuery(query.toString());
		q.setResultTransformer(Transformers.aliasToBean(DtoPanelControl.class));
		return (DtoPanelControl)q.uniqueResult();
	}

}

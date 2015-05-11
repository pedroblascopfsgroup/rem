package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dao;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dao.RecoveryAgendaMultifuncionContratosDao;

@Repository("RecoveryAgendaMultifuncionContratosDao")
public class RecoveryAgendaMultifuncionContratosDaoImpl extends AbstractEntityDao implements RecoveryAgendaMultifuncionContratosDao{

	final static String CNT_EXTRA_CODIGO_LITIGIO = "char_extra2";
	
	@Override
	public String getCccLitigio(Long idContrato) {
		Query q = getSession().createQuery(	" select iac.value FROM EXTInfoAdicionalContrato iac where iac.contrato.id =:contratoId " + 
											" and iac.tipoInfoContrato.codigo =:codigo ");

		q.setParameter("contratoId", idContrato);
		q.setParameter("codigo", CNT_EXTRA_CODIGO_LITIGIO);
		return (String) q.uniqueResult();
	}

	
}

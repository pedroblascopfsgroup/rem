package es.pfsgroup.recovery.ext.impl.contrato.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.ext.impl.contrato.dao.EXTInfoAdicionalContratoDao;
import es.pfsgroup.recovery.ext.impl.contrato.model.EXTInfoAdicionalContrato;

@Repository("EXTInfoAdicionalContratoDaoImpl")
public class EXTInfoAdicionalContratoDaoImpl extends AbstractEntityDao<EXTInfoAdicionalContrato, Long> implements EXTInfoAdicionalContratoDao{

	@Override
	public List<EXTInfoAdicionalContrato> getListadoEXTInfoAdicionalContratoByCNTID(Long idContrato) {
		HQLBuilder hb = new HQLBuilder("from EXTInfoAdicionalContrato iac");
		hb.appendWhere("iac.contrato.id = " + idContrato + " and iac.auditoria.borrado = 0 "); // ID de asunto y borrado.

		return HibernateQueryUtils.list(this, hb);
	}
	
	@Override
	public EXTInfoAdicionalContrato getEXTInfoAdicionalContratoByID(Long id){
		HQLBuilder hb = new HQLBuilder("from EXTInfoAdicionalContrato iac");
		hb.appendWhere("iac.id = " + id); // ID de Contabilidad Cobro.

		return HibernateQueryUtils.uniqueResult(this, hb);
	}


	@Override
	public String getEstadoBloqueoByCNTID(Long idContrato) {
		HQLBuilder hb = new HQLBuilder("from EXTInfoAdicionalContrato iac");
		hb.appendWhere("iac.contrato.id = "+ idContrato + " and iac.auditoria.borrado = 0 " + // ID de contrato y borrado.
		"and iac.tipoInfoContrato.codigo = 'MARCADO_CUENTAS' "); // Contratos con un bloqueo de tipo MARCADO_CUENTAS.

		//Preparado para mas de un registro para el mismo contrato.
		List<EXTInfoAdicionalContrato> iacList = HibernateQueryUtils.list(this, hb);
		if(!Checks.estaVacio(iacList)){
			EXTInfoAdicionalContrato iac  = iacList.get(0);
			return iac.getValue();
		}else{
			return null;
		}
	}
	
}

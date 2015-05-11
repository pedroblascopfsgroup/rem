package es.pfsgroup.recovery.ext.impl.procedimiento.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;


//import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.ext.impl.procedimiento.dao.EXTProcedimientoDao;

@Repository
public class EXTProcedimientoDaoImpl extends
		AbstractEntityDao<Procedimiento, Long> implements EXTProcedimientoDao {

	@Override
	public List<? extends Procedimiento> buscaProcedimientoConContrato(
			Long idContrato, String[] estados) {
		HQLBuilder b = new HQLBuilder("select p from Procedimiento p");
		b
				.appendWhere("p.id in (select pce.procedimiento from ProcedimientoContratoExpediente pce where pce.expedienteContrato in ("
						+ "select cex.id form ExpedienteContrato cex where (cex.auditoria.borrado = false)"
						+ " and (cex.contrato.id = " + idContrato + ")))");
		if ((estados != null) && (estados.length > 0)) {
			b.appendWhere("p.estadoProcedimiento.codigo in ("
					+ stringEstados(estados) + ")");
		}
		
		return HibernateQueryUtils.list(this, b);
	}
	private String stringEstados(String[] estados) {
		if ((estados == null) || (estados.length == 0)) return "";
		StringBuilder sb = new StringBuilder("\"" + estados[0] + "\"");
		for (int i = 1; i < estados.length; i++) {
			sb.append(",\"" + estados[i] + "\"");
		}
		return sb.toString();
	}
	@Override
	public Procedimiento getPersonaProcedimiento(Long idPrc, Long idPersona) {
		HQLBuilder b = new HQLBuilder("select p from Procedimiento p, ProcedimientoPersona pp");		
		b.appendWhere("p.id = " + idPrc + " and pp.persona.id = " +  idPersona);
		
		return HibernateQueryUtils.uniqueResult(this, b);	}
}

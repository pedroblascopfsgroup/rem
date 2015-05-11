package es.pfsgroup.plugin.recovery.mejoras.revisionProcedimiento.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.mejoras.revisionProcedimiento.dao.RevisionProcedimientoDao;

@Repository
public class RevisionProcedimientoDaoImpl extends AbstractEntityDao<Procedimiento, Long> implements RevisionProcedimientoDao {

	public static final String ESTADO_PROCEDIMIENTO_PARALIZADO_PENDIENTE = "00";
    public static final String ESTADO_PROCEDIMIENTO_PENDIENTE_REORGANIZACION = "08";
    public static final String ESTADO_PROCEDIMIENTO_REORGANIZADO = "09";
	
	@Override
	public List<Procedimiento> getListaProcedimientosRevisar(Long idAsunto) {

		HQLBuilder hb = new HQLBuilder(generaHQLlistaPersonas(idAsunto));

		return HibernateQueryUtils.list(this, hb);
	}

	private String generaHQLlistaPersonas(Long idAsunto) {
		
		return "SELECT PRC FROM Procedimiento PRC " +
				"where PRC.auditoria.borrado = false and PRC.estadoProcedimiento.codigo not in ('" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO + "','"
				+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO + "','" + ESTADO_PROCEDIMIENTO_PENDIENTE_REORGANIZACION +  "','" + ESTADO_PROCEDIMIENTO_REORGANIZADO + "','" +
						ESTADO_PROCEDIMIENTO_PARALIZADO_PENDIENTE + "') and PRC.asunto.id="+idAsunto +" and PRC.id not in (SELECT procedimiento.id FROM Recurso rec WHERE rec.fechaResolucion is null )";
	}
	
}

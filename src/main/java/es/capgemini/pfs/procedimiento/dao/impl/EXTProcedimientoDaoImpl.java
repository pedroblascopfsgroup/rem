package es.capgemini.pfs.procedimiento.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procedimiento.dao.EXTProcedimientoDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;

@Repository("EXTProcedimientoDao")
public class EXTProcedimientoDaoImpl extends AbstractEntityDao<Procedimiento, Long> implements EXTProcedimientoDao{

	@Override
	public List<Procedimiento> getProcedimientosOrigenOrdenados(Long idAsunto) {
		HQLBuilder hb = new HQLBuilder("from Procedimiento p");
		//hb.appendWhere("p.auditoria.borrado = false");
		
		
		HQLBuilder.addFiltroIgualQue(hb, "p.asunto.id", idAsunto);
		hb.appendWhere("p.procedimientoPadre = null");
		//HQLBuilder.addFiltroIgualQueSiNotNull(hb, "p.procedimientoDerivado", null);
		
		hb.orderBy("id", HQLBuilder.ORDER_ASC );
		
		
		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public List<Procedimiento> buscaHijosProcedimiento(Long idProcedimiento) {
		HQLBuilder hb = new HQLBuilder("from Procedimiento p");
		//hb.appendWhere("p.auditoria.borrado = false");
		
		
		HQLBuilder.addFiltroIgualQue(hb, "p.procedimientoPadre.id", idProcedimiento);
		
		hb.orderBy("auditoria.fechaCrear", HQLBuilder.ORDER_ASC );
		
		
		return HibernateQueryUtils.list(this, hb);
	}

}

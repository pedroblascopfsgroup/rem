package es.pfsgroup.plugin.recovery.mejoras.tareaProcedimiento.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.mejoras.tareaProcedimiento.dao.MEJTareaProcedimientoDao;

@Repository
public class MEJTareaProcedimientoDaoImpl extends AbstractEntityDao<TareaProcedimiento, Long> implements MEJTareaProcedimientoDao {


	@Override
	public List<TareaProcedimiento> getListaTareaProcedimientos(Long idTipoPro) {
		HQLBuilder hb = new HQLBuilder(generaHQLlistaPersonas(idTipoPro));
		return HibernateQueryUtils.list(this, hb);
	}

	private String generaHQLlistaPersonas(Long idTipoPro) {		
		return "SELECT TAP FROM TareaProcedimiento TAP WHERE TAP.tipoProcedimiento.id = " + idTipoPro +
				" AND TAP.auditoria.borrado = false AND TAP.tipoProcedimientoBPMHijo is null" +
				" and (TAP.evitarReorganizacion is null or TAP.evitarReorganizacion = false)";
	}
	
}

package es.pfsgroup.plugin.recovery.instruccionesExterna.instruccionesTareasExterna.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.instruccionesExterna.instruccionesTareasExterna.dao.INSInstruccionesTareasExternaDao;
import es.pfsgroup.plugin.recovery.instruccionesExterna.instruccionesTareasExterna.dto.INSDtoBusquedaInstrucciones;
import es.pfsgroup.plugin.recovery.instruccionesExterna.instruccionesTareasExterna.model.INSInstruccionesTareasExterna;

@Repository("INSInstruccionesTareasExternaDao")
public class INSInstruccionesTareasExternaDaoImpl extends AbstractEntityDao<INSInstruccionesTareasExterna, Long>
	implements INSInstruccionesTareasExternaDao{

	@Override
	public Page findInstruciones(INSDtoBusquedaInstrucciones dto) {
		HQLBuilder hb = new HQLBuilder("from INSInstruccionesTareasExterna ins");
		hb.appendWhere("ins.auditoria.borrado=0");
		hb.appendWhere("ins.tareaProcedimiento.auditoria.borrado=0");
		hb.appendWhere("ins.tareaProcedimiento.tipoProcedimiento.auditoria.borrado=0");
		
		HQLBuilder.addFiltroIgualQue(hb, "ins.type", "label");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ins.tareaProcedimiento.tipoProcedimiento.id", dto.getTipoProcedimiento());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ins.tareaProcedimiento.id", dto.getTareaProcedimiento());
	
		return HibernateQueryUtils.page(this, hb, dto);
	}

}

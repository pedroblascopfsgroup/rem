package es.pfsgroup.plugin.recovery.itinerarios.tipoProcedimiento.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.plugin.recovery.itinerarios.tipoProcedimiento.dao.ITITipoProcedimientoDao;

@Repository("ITITipoProcedimientoDao")
public class ITITipoProcedimientoDaoImpl extends AbstractEntityDao<TipoProcedimiento, Long>
	implements ITITipoProcedimientoDao{

}

package es.pfsgroup.plugin.recovery.coreextension.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.plugin.recovery.coreextension.dao.EXTTipoProcedimientoDao;

@Repository("EXTTipoProcedimientoDao")
public class EXTTipoProcedimientoDaoImpl extends AbstractEntityDao<TipoProcedimiento, Long> implements EXTTipoProcedimientoDao{

	@Override
	public List<TipoProcedimiento> getListTipoProcedimientosPorTipoActuacion(String codigoActuacion) {
        String hql = "from TipoProcedimiento where tipoActuacion.codigo = ? and auditoria.borrado=false";
        List<TipoProcedimiento> lista = (List<TipoProcedimiento>) getHibernateTemplate().find(hql, new Object[] { codigoActuacion });
        return lista;
    }	
	
	@Override
	public List<TipoProcedimiento> getListTipoProcedimientosMenosTipoActuacion(String codigoActuacion) {
        String hql = "from TipoProcedimiento where tipoActuacion.codigo != ? and auditoria.borrado=false";
        List<TipoProcedimiento> lista = (List<TipoProcedimiento>) getHibernateTemplate().find(hql, new Object[] { codigoActuacion });
        return lista;
    }	

}

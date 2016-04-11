package es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.ext.api.tipoFicheroAdjunto.dao.DDTipoFicheroAdjuntoDao;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@Repository
public class DDTipoFicheroAdjuntoDaoImpl extends AbstractEntityDao<DDTipoFicheroAdjunto, Long> implements DDTipoFicheroAdjuntoDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<DDTipoFicheroAdjunto> getListaPorTipoDeActuacion(
			List<DDTipoActuacion> actuaciones) {
		
		String codigoTipoOtros ="OT";
		ArrayList<String> codigosActuacion = new ArrayList<String>();
		StringBuffer hql = new StringBuffer();
		hql.append(" Select tf from DDTipoFicheroAdjunto tf left join tf.tipoActuacion tac where tf.auditoria.borrado = false and  ( tf.codigo = '"+codigoTipoOtros+"' or tac.codigo in (");
		for(DDTipoActuacion actuacion:actuaciones){
			
			if(!codigosActuacion.contains(actuacion.getCodigo())){
				hql.append("'").append(actuacion.getCodigo()).append("',");	
			}
			codigosActuacion.add(actuacion.getCodigo());
		}
		hql.delete(hql.length()-1, hql.length());
		hql.append(" )) order by tf.descripcion asc");
		return getSession().createQuery(hql.toString()).list();
	}

	

}

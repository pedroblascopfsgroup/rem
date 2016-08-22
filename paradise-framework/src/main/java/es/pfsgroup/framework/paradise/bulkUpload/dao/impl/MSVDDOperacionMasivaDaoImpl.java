package es.pfsgroup.framework.paradise.bulkUpload.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVDDOperacionMasivaDao;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;

@Repository("DDOperacionMasivaDao")
public class MSVDDOperacionMasivaDaoImpl extends AbstractEntityDao<MSVDDOperacionMasiva	, Long>  implements MSVDDOperacionMasivaDao{

	@Override
	public List<MSVDDOperacionMasiva> dameListaOperacionesDeUsuario(Usuario usu) {
		
		HQLBuilder hb= new HQLBuilder("select tipo from MSVDDOperacionMasiva tipo");
		
		hb.appendWhere("tipo.auditoria.borrado=0");
		hb.orderBy("descripcion", HQLBuilder.ORDER_ASC);
		
		List<Long> listaidfunciones=new ArrayList<Long>();
		
		for (Perfil p : usu.getPerfiles()){
			for (Funcion f : p.getFunciones() ){
				listaidfunciones.add(f.getId());
			}
		}
		
		HQLBuilder.addFiltroWhereInSiNotNull(hb, "tipo.funcion.id", listaidfunciones);
		
		
		return HibernateQueryUtils.list(this, hb);
		
	}

}

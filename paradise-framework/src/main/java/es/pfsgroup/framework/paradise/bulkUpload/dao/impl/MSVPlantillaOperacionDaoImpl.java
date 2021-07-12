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
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVPlantillaOperacionDao;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVPlantillaOperacion;

@Repository("MSVPlantillaOperacionDao")
public class MSVPlantillaOperacionDaoImpl extends AbstractEntityDao<MSVPlantillaOperacion, Long> implements MSVPlantillaOperacionDao {

	@Override
	public List<MSVPlantillaOperacion> dameListaPlantillasUsuario(Usuario usu) {
		
		HQLBuilder hb= new HQLBuilder("select p from MSVPlantillaOperacion p join p.tipoOperacion tipo");
		
		List<Long> listaidfunciones=new ArrayList<Long>();
		
		for (Perfil p : usu.getPerfiles()){
			for (Funcion f : p.getFunciones() ){
				listaidfunciones.add(f.getId());
			}
		}

		HQLBuilder.addFiltroIgualQue(hb, "p.auditoria.borrado", 0);
		HQLBuilder.addFiltroWhereInSiNotNull(hb, "tipo.funcion.id", listaidfunciones);
		
		
		return HibernateQueryUtils.list(this, hb);
		
	}

	@Override
	public MSVPlantillaOperacion obtenerRutaExcel(Long id) {
		
		MSVPlantillaOperacion msvPlantillaOperacion = this.get(id);
		
		return msvPlantillaOperacion;
	}
	
	@Override
	public MSVPlantillaOperacion obtenerRutaExcelByTipoOperacion(Long idTipoOperacion) {
		
		if (idTipoOperacion == null){
			return null;
		}
		HQLBuilder hb= new HQLBuilder("select p from MSVPlantillaOperacion p ");
	
		
		HQLBuilder.addFiltroIgualQue(hb, "p.auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQue(hb, "p.tipoOperacion.id", idTipoOperacion);
		
		MSVPlantillaOperacion msvPlantillaOperacion = HibernateQueryUtils.uniqueResult(this, hb);
		
		return msvPlantillaOperacion;
	}

}

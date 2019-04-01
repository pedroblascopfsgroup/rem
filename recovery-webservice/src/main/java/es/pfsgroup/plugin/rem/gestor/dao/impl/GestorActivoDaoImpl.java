package es.pfsgroup.plugin.rem.gestor.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.impl.GestorEntidadDaoImpl;
import es.pfsgroup.plugin.rem.gestor.dao.GestorActivoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.Directorusuario;

@Repository("GestorActivoDao")
public class GestorActivoDaoImpl extends GestorEntidadDaoImpl implements GestorActivoDao{
	
	@Autowired
	private MSVRawSQLDao rawDao;
	
	@Autowired
	private GenericABMDao genericDao;

	@SuppressWarnings("unchecked")
	@Override
	public List<Usuario> getListUsuariosGestoresActivoByTipoYActivo(Long idTipoGestor, Activo activo) {
		
		HQLBuilder hb = new HQLBuilder("select distinct(gee.usuario) from GestorActivo gee");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gee.auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gee.activo.id", activo.getId());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gee.tipoGestor.id", idTipoGestor);
		
		Query query = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
		HQLBuilder.parametrizaQuery(query, hb);
		List<Usuario> listado = query.list();
		
		return listado;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Usuario> getListUsuariosGestoresActivoBycodigoTipoYActivo(String codigoTipoGestor, Activo activo){
		
		HQLBuilder hb = new HQLBuilder("select distinct(gee.usuario) from GestorActivo gee");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gee.auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb,  "gee.activo.id", activo.getId());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gee.tipoGestor.codigo", codigoTipoGestor);
		
		Query query = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
		HQLBuilder.parametrizaQuery(query, hb);
		List<Usuario> listado = query.list();
		
		return listado;
	}
	
	@Override
	public Boolean isUsuarioGestorExterno(Long idUsuario) {
		
		String resultado = rawDao.getExecuteSQL("SELECT count(1) FROM ZON_PEF_USU zpu "
				+ "	JOIN PEF_PERFILEs pef ON zpu.pef_id = pef.pef_id "
				+ " WHERE zpu.usu_id = " + idUsuario
				+ " AND pef.pef_codigo IN ('HAYAFSV','PERFGCCBANKIA','GESTOADM','GESTIAFORM','HAYAGESTADMT','GESTOCED','GESTOPLUS','GTOPOSTV','GESTOPDV','HAYAPROV','HAYACERTI','HAYACONSU')");
		
		if("0".equals(resultado)) {
			return false;
		} else {
			return true;
		}
	}
	
	@Override
	public Boolean isUsuarioGestorExternoProveedor(Long idUsuario) {
		
		String resultado = rawDao.getExecuteSQL("select count(1) from  " + 
				"remmaster.usu_usuarios usu " + 
				"join ACT_PVC_PROVEEDOR_CONTACTO pvc on usu.usu_id=pvc.usu_id " + 
				"join ACT_PVE_PROVEEDOR pve on pve.pve_id=pvc.pve_id " + 
				"join DD_TPR_TIPO_PROVEEDOR tpr on TPR.DD_TPR_ID=PVE.DD_TPR_ID " + 
				"join zon_pef_usu zpu on zpu.usu_id=USU.USU_ID " + 
				"join PEF_PERFILES pef on pef.pef_id=ZPU.PEF_ID " + 
				"WHERE pef.pef_codigo IN ('GESTOADM','GESTIAFORM','GESTOCED', 'HAYAGESTADMT', 'GESTOPLUS','GTOPOSTV','GESTOPDV','HAYAPROV','HAYACERTI') " + //tecnotramit y ogf
				"and usu.usu_id = " + idUsuario +
				"AND PVE.PVE_DOCIDENTIF not in ('B65737322', 'B82802075')");
		
		if("0".equals(resultado)) {
			return false;
		} else {
			return true;
		}
	}

	@Override
	public Usuario getDirectorEquipoByGestor(Usuario gestor) {
		
			Usuario director = null;
			
			Filter filterDirector = genericDao.createFilter(FilterType.EQUALS, "gestor.id", gestor.getId());
			Directorusuario directorUsuario = genericDao.get(Directorusuario.class, filterDirector);
			
			if (!Checks.esNulo(directorUsuario)){
				director = directorUsuario.getDirectorEquipo();
			}
		
		return director;
	}

}

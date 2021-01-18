package es.pfsgroup.plugin.rem.trabajo.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.plugin.rem.model.DerivacionEstadoTrabajo;
import es.pfsgroup.plugin.rem.trabajo.dao.DerivacionEstadoTrabajoDao;


@Repository("DerivacionEstadoTrabajoDao")
public class DerivacionEstadoTrabajoDaoImpl extends AbstractEntityDao<DerivacionEstadoTrabajo, Long> implements DerivacionEstadoTrabajoDao {
	
	@Autowired
	private MSVRawSQLDao rawDao;
	
	@SuppressWarnings("unchecked")
	@Override
	public List<String> getListOfPerfilesValidosForDerivacionEstadoTrabajo() {
		List<String> perfilesValidos = new ArrayList<String>();
		
		String result = rawDao.getExecuteSQL("SELECT LISTAGG(pef.pef_codigo, ',') within group (order by pef.pef_codigo) "
											 +"FROM " 
											 +"	( SELECT perfil.pef_codigo " 
											 +"   FROM tbj_tpe_trans_pef_estado   transestado " 
											 +"   INNER JOIN pef_perfiles perfil ON transestado.pef_id = perfil.pef_id "
											 +"   GROUP BY perfil.pef_codigo "
											 +") pef");
		
		if ( result != null) {
			perfilesValidos = Arrays.asList(result.split(","));
		}
		return perfilesValidos;
	}

	@Override
	public List<String> getPosiblesEstados(String estadoActual, List<String> clauseInPerfiles) {
		List<String> posibleEstadoCode = new ArrayList<String>(); 
		HQLBuilder hb = new HQLBuilder("from DerivacionEstadoTrabajo estados");  
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "estadoInicial.codigo", estadoActual);
		HQLBuilder.addFiltroWhereInSiNotNullForceString(hb, "perfil.codigo", clauseInPerfiles);			
   		
   		List<DerivacionEstadoTrabajo> derivacionEstadoTrabajoList =  HibernateQueryUtils.list(this, hb);
   		
   		if ( !derivacionEstadoTrabajoList.isEmpty()) {
   			for ( int i = 0; i < derivacionEstadoTrabajoList.size(); i++) {
   				DerivacionEstadoTrabajo derivacionEstadoTrabajo = derivacionEstadoTrabajoList.get(i);
   				if ( derivacionEstadoTrabajo.getEstadoFinal() != null ) {
   					posibleEstadoCode.add(derivacionEstadoTrabajo.getEstadoFinal().getCodigo());
   				}
   			}
   		}
   		
		return posibleEstadoCode;
	}
}

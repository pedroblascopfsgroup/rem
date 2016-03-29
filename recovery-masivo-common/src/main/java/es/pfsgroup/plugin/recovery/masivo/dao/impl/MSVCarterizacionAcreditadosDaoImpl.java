package es.pfsgroup.plugin.recovery.masivo.dao.impl;

import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVCarterizacionAcreditadosDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVCarterizarAcreditadosDto;

@Repository("MSVCarterizacionAcreditadosDao")
public class MSVCarterizacionAcreditadosDaoImpl extends AbstractEntityDao implements
		MSVCarterizacionAcreditadosDao{

	@Override
	public boolean insertarRegistroOPMCarterizacion(MSVCarterizarAcreditadosDto dto) {
		
		boolean resultado = false;
		String sqlSecuence = "S_POC_PETICION_OPM_CARTERIZAR.NEXTVAL";
		
	    String	hql = "insert into POC_PETICION_OPM_CARTERIZAR (POC_ID, POC_ACREDITADO_DOC_ID, POC_GESTOR_USERNAME ,PRM_ID, version, usuariocrear,fechacrear,borrado) "
	    			+ "select "+sqlSecuence+", '"+dto.getAcreditadoCif()+"', '"+dto.getGestorUsername()+"', "+dto.getProcesoMasivoId()+", "+0+", '"+dto.getUsuariocrear()+"', TRUNC(sysdate),"+0+" from dual";
	    try {
		    int numeroInserciones = getSession().createSQLQuery(hql).executeUpdate();
	    	if(numeroInserciones > 0)
	    		resultado = true;
	    	
	    } catch (DataAccessResourceFailureException e) {
			logger.error("[MSVCarterizacionAcreditadosDaoImpl:insertarRegistroOPMCarterizacion]: DataAccessResourceFailureException: " + e.getLocalizedMessage() );
		}
	    
		return resultado;
	}
}

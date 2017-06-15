package es.pfsgroup.plugin.rem.expedienteComercial.avisos;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteAvisadorApi;
import es.pfsgroup.plugin.rem.model.BloqueoActivoFormalizacion;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;


@Service("expedienteAvisoBloqueoFormalizacion")
public class ExpedienteAvisoBloqueoFormalizacion implements ExpedienteAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(ExpedienteAvisoBloqueoFormalizacion.class);
	
	@Autowired
	private GenericABMDao genericDao;
	

	@Override
	public DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();
		
		List<BloqueoActivoFormalizacion> bloqueos = null;
		
		bloqueos = genericDao.getList(BloqueoActivoFormalizacion.class, 
				genericDao.createFilter(FilterType.EQUALS, "expediente.id", Long.valueOf(expediente.getId())));
		
		if(!Checks.estaVacio(bloqueos))
			for (BloqueoActivoFormalizacion bloqueo : bloqueos){
				if(Checks.esNulo(bloqueo.getAuditoria().getUsuarioBorrar())){
					dtoAviso.setDescripcion("Existencia de bloqueos en informe jurídico");
					dtoAviso.setId(String.valueOf(expediente.getId()));
					
					return dtoAviso;
				}
			}

		return dtoAviso;
		
	}
		
}

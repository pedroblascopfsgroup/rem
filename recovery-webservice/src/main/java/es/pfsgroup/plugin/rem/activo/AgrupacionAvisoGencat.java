package es.pfsgroup.plugin.rem.activo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.AgrupacionAvisadorApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAviso;

@Service("AgrupacionAvisoGencat")
public class AgrupacionAvisoGencat implements AgrupacionAvisadorApi {

	@Autowired
	private ActivoDao activoDao;
	
	protected static final Log logger = LogFactory.getLog(AgrupacionAvisoGencat.class);
	
	@Override
	public DtoAviso getAviso(ActivoAgrupacion agrupacion, Usuario usuarioLogado) {
		DtoAviso dtoAviso = new DtoAviso();

			if (activoDao.countActivosAfectoGENCAT(agrupacion.getId()) > 0) {
				dtoAviso.setDescripcion("Agrupación con activos afectos GENCAT");
				dtoAviso.setId(String.valueOf(agrupacion.getId()));
			}
			
		return dtoAviso;
	}
	
}

package es.pfsgroup.plugin.rem.activo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.AgrupacionAvisadorApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAviso;


@Service("agrupacionVentaSobrePlano")
public class AgrupacionAvisoVentaSobrePlano implements AgrupacionAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(AgrupacionAvisoVentaSobrePlano.class);
	
	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;

	@Override
	public DtoAviso getAviso(ActivoAgrupacion agrupacion, Usuario usuarioLogado) {
		
		DtoAviso dtoAviso = new DtoAviso();
		
		Long numAgrupacionONDnd = activoAgrupacionApi.numAgrupacionONDnd(agrupacion);
		if(!Checks.esNulo(numAgrupacionONDnd)){
			dtoAviso.setDescripcion("Venta sobre plano ".concat(numAgrupacionONDnd.toString()));
			dtoAviso.setId(String.valueOf(agrupacion.getId()));
		}

		return dtoAviso;
		
	}
}
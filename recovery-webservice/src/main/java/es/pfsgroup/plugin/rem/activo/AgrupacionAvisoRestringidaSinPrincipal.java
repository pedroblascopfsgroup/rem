package es.pfsgroup.plugin.rem.activo;

import java.text.SimpleDateFormat;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.AgrupacionAvisadorApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;


@Service("agrupacionAvisoRestringidaSinPrincipal")
public class AgrupacionAvisoRestringidaSinPrincipal implements AgrupacionAvisadorApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	
	protected static final Log logger = LogFactory.getLog(AgrupacionAvisoRestringidaSinPrincipal.class);

	@Override
	public DtoAviso getAviso(ActivoAgrupacion agrupacion, Usuario usuarioLogado) {
		
		
		DtoAviso dtoAviso = new DtoAviso();
		
		if (agrupacion.getTipoAgrupacion() != null && (DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())
				|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())
				|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM.equals(agrupacion.getTipoAgrupacion().getCodigo()))) {
			
			//Long principal = agrupacionApi.haveActivoPrincipal(agrupacion.getId());
			
			if (agrupacion.getActivoPrincipal() == null) {
				dtoAviso.setDescripcion("Agrupación restringida sin activo principal");
				dtoAviso.setId(String.valueOf(agrupacion.getId()));
			}
		}

		return dtoAviso;
		
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
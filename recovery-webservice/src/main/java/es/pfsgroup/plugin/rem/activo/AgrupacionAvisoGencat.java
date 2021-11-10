package es.pfsgroup.plugin.rem.activo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.AgrupacionAvisadorApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

@Service("AgrupacionAvisoGencat")
public class AgrupacionAvisoGencat implements AgrupacionAvisadorApi {

	@Autowired
	private ActivoAgrupacionApi activoAgrupacioApi;
	
	protected static final Log logger = LogFactory.getLog(AgrupacionAvisoGencat.class);
	
	@Override
	public DtoAviso getAviso(ActivoAgrupacion agrupacion, Usuario usuarioLogado) {
		DtoAviso dtoAviso = new DtoAviso();
			
			if (activoAgrupacioApi.countActivosAfectoGENCAT(agrupacion) > 0 
					&& (DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())
							|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())
							|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM.equals(agrupacion.getTipoAgrupacion().getCodigo())
							|| DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(agrupacion.getTipoAgrupacion().getCodigo()))) {
				
				dtoAviso.setDescripcion("Agrupación con activos afectos GENCAT");
				dtoAviso.setId(String.valueOf(agrupacion.getId()));
				
			}
			
		return dtoAviso;
	}
	
}

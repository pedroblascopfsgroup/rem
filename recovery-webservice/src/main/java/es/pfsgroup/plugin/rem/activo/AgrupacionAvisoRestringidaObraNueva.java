package es.pfsgroup.plugin.rem.activo;

import java.text.SimpleDateFormat;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.AgrupacionAvisadorApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;


@Service("agrupacionAvisoRestringidaObraNueva")
public class AgrupacionAvisoRestringidaObraNueva implements AgrupacionAvisadorApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	
	protected static final Log logger = LogFactory.getLog(AgrupacionAvisoRestringidaObraNueva.class);

	@Override
	public DtoAviso getAviso(ActivoAgrupacion agrupacion, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();
		boolean continuar = true;
		if (!Checks.esNulo(agrupacion.getTipoAgrupacion()) 
				&& (DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())
						|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())
						|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM.equals(agrupacion.getTipoAgrupacion().getCodigo()))) {

			// Obtener los activos de la agrupación restringida.
			for(ActivoAgrupacionActivo activoAgrupacion : agrupacion.getActivos()) {
				// Por cada activo obtener las agrupaciones a las que pertenezca.
				for(ActivoAgrupacionActivo agr : activoAgrupacion.getActivo().getAgrupaciones()) {
					// Comprobar si alguna (primera coincidencia) es de tipo obra nueva.
					if(!Checks.esNulo(agr.getAgrupacion().getTipoAgrupacion()) && DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA.equals(agr.getAgrupacion().getTipoAgrupacion().getCodigo())) {
						dtoAviso.setDescripcion("Agrupación restringida integrada en obra nueva");
						dtoAviso.setId(String.valueOf(agrupacion.getId()));
						continuar = false;
						break;
					}
				}
				if(!continuar) {
					break;
				}
			}
		}

		return dtoAviso;		
	}
	
}
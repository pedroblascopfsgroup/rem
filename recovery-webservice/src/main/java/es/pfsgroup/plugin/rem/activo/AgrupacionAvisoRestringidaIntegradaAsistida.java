package es.pfsgroup.plugin.rem.activo;

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

@Service("agrupacionAvisoRestringidaIntegradaAsistida")
public class AgrupacionAvisoRestringidaIntegradaAsistida implements AgrupacionAvisadorApi {

	protected static final Log logger = LogFactory.getLog(AgrupacionAvisoRestringidaIntegradaAsistida.class);

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
					// Comprobar si alguna (primera coincidencia) es de tipo asistida.
					if(!Checks.esNulo(agr.getAgrupacion().getTipoAgrupacion()) && DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(agr.getAgrupacion().getTipoAgrupacion().getCodigo())) {
						dtoAviso.setDescripcion("Agrupación restringida integrada en asistida");
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
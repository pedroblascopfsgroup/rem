package es.pfsgroup.plugin.rem.activo;

import java.util.Date;

import org.apache.commons.lang.time.DateUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.AgrupacionAvisadorApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

@Service("agrupacionAvisoAsistidaPDVVigente")
public class AgrupacionAvisoAsistidaPDVVigente implements AgrupacionAvisadorApi {
	
	protected static final Log logger = LogFactory.getLog(AgrupacionAvisoAsistidaPDVVigente.class);
	
	@Override
	public DtoAviso getAviso(ActivoAgrupacion agrupacion, Usuario usuarioLogado) {

		DtoAviso dtoAviso = new DtoAviso();
		
		if (!Checks.esNulo(agrupacion.getTipoAgrupacion()) && DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(agrupacion.getTipoAgrupacion().getCodigo()) && 
				this.isAgrupacionEnFechaVigente(agrupacion.getFechaInicioVigencia(), agrupacion.getFechaFinVigencia()) ) 
		{
			dtoAviso.setDescripcion("Asistida/PDV vigente");
			dtoAviso.setId(String.valueOf(agrupacion.getId()));
			
		}

		return dtoAviso;
		
	}
	
	private Boolean isAgrupacionEnFechaVigente(Date fechaInicio, Date fechaFin) {
		
		Date fechaHoy = new Date();
		
		if(!Checks.esNulo(fechaInicio) && (fechaInicio.before(fechaHoy) || DateUtils.isSameDay(fechaInicio,fechaHoy)) &&
			!Checks.esNulo(fechaFin) && (fechaFin.after(fechaHoy) || DateUtils.isSameDay(fechaFin,fechaHoy))) 
		{
			return true;
		}
		
		return false;
	}


}

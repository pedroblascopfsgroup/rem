package es.pfsgroup.recovery.api;

import java.util.Date;

/**
 * Datos de un Evento de Recovery
 * @author bruno
 *
 */
public interface EventoDto {
	public interface AuditoriaInfo{
		Boolean isBorrado();
	}
	
	public interface CausaProrrogaInfo{
		String getDescripcion();
	}
	
	public interface ProrrogaInfo{
		CausaProrrogaInfo getCausaProrroga();
		Date getFechaPropuesta();
	}
	
	public interface TipoEntidadInfo{
		String getCodigo();
	}
	
	public interface TipoTareaInfo{
		String getCodigoTarea();
	}
	
	public interface SubtipoTareaInfo{
		String getCodigoSubtarea();
		TipoTareaInfo getTipoTarea();
	}
	
	public interface TareaInfo {
		Long getId();
		Date getFechaInicio();
		Date getFechaFin();
		String getTipoSolicitud();
		Date getFechaVenc();
		Boolean isAlerta();
		AuditoriaInfo getAuditoria();
		String getEmisor();
		SubtipoTareaInfo getSubtipoTarea();
		Long getIdEntidad();
		TipoEntidadInfo getTipoEntidad();
		String getDescripcionTarea();
		String getDescripcionEntidad();
		String getFechaCreacionEntidadFormateada();
		String getSituacionEntidad();
		Long getIdEntidadPersona();
		ProrrogaInfo getProrroga();
	}

	
	String getDescripcion();
	
	TareaInfo getTarea();
	
}

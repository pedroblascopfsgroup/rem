package es.pfsgroup.plugin.recovery.config.delegaciones.api;

import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.plugin.recovery.config.delegaciones.dto.DelegacionDto;
import es.pfsgroup.plugin.recovery.config.delegaciones.model.Delegacion;


public interface DelegacionApi {


	/**
	 * Convierte un Dto a la entidad
	 * @param DelegacionDto
	 * @return Delegacion
	 */
	public Delegacion convertDelegacionDtoTODelegacion(DelegacionDto dto);
	
	
	/**
	 * Guarda una nueva liquidacion
	 * @param DelegacionDto
	 */
	@Transactional(readOnly = false)
	public void saveDelegacion(DelegacionDto dto);
	
}

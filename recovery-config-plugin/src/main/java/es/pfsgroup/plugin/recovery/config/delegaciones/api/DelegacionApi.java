package es.pfsgroup.plugin.recovery.config.delegaciones.api;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.recovery.config.delegaciones.dto.DelegacionDto;
import es.pfsgroup.plugin.recovery.config.delegaciones.dto.DelegacionFiltrosBusquedaDto;
import es.pfsgroup.plugin.recovery.config.delegaciones.model.Delegacion;


public interface DelegacionApi {


	/**
	 * Convierte un Dto a la entidad
	 * @param DelegacionDto
	 * @return Delegacion
	 */
	public Delegacion convertDelegacionDtoTODelegacion(DelegacionDto dto);
	
	
	/**
	 * Guarda una nueva delegacion
	 * @param DelegacionDto
	 */
	@Transactional(readOnly = false)
	public void saveOrUpdateDelegacion(DelegacionDto dto);
	
	/**
	 * Obtiene una lista que cumplen las condiciones del dto
	 * @param DelegacionDto
	 * @return Delegacion
	 */
	public Page getListDelegaciones(DelegacionFiltrosBusquedaDto dto);
	
	
	/**
	 * Guarda una nueva liquidacion
	 * @param Long idDelegacion
	 */
	@Transactional(readOnly = false)
	public void borrarDelegacion(Long idDelegacion);
	
	
	/**
	 * Convierte la entidad a Dto
	 * @param Delegacion
	 * @return DelegacionDto
	 */
	public DelegacionDto convertDelegacionTODelegacionDto(Delegacion delegacion);
	
}

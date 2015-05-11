package es.pfsgroup.recovery.recobroCommon.persona.dao.api;

import java.util.Date;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.persona.dto.CicloRecobroPersonaDto;
import es.pfsgroup.recovery.recobroCommon.persona.model.CicloRecobroPersona;

/**
 * Interfaz de métodos para la persistencia de los ciclos de recobro de personas
 * @author Diana
 *
 */
public interface CicloRecobroPersonaDao extends AbstractDao<CicloRecobroPersona, Long> {

	/**
	 * Obtener los ciclos de recobro de personas por expediente y persona
	 * @param idExpediente
	 * @param idPersona
	 * @return
	 */
	public List<CicloRecobroPersona> getCiclosRecobroPersonaExpediente(
			Long idExpediente, Long idPersona);

	/**
	 * Obtiene una página de ciclos de recobro de personas a partir de unos parámetros de entrada  
	 * @param dto
	 * @return
	 */
	public Page getPage(CicloRecobroPersonaDto dto);

	/**
	 * Obtener los ciclos de recobro de personas por subcartera, agencia, fecha de inicio y fecha de fin
	 * @param idSubcartera
	 * @param idAgencia
	 * @param fechaInicio
	 * @param fechaFin
	 * @return
	 */
	public List<CicloRecobroPersona> getCiclosRecobroPersonaPorAgenciaSubcarteraIntervaloFechas(
			Long idSubcartera, Long idAgencia, Date fechaInicio, Date fechaFin);

	/**
	 * Devuelve una lista de todos los ciclos de recobro que ha realizado la agencia que actualmente
	 * gestiona ese expediente sobre el expediente, pero no muestra los ciclos que ha realizado otra agencia 
	 * sobre el mismo expediente
	 * @param idExpediente
	 * @param idPersona
	 * @param idAgencia
	 * @return
	 */
	public List<CicloRecobroPersona> getCiclosRecobroPersonaExpAgenciaActual(
			Long idExpediente, Long idPersona, Long idAgencia);
	
}

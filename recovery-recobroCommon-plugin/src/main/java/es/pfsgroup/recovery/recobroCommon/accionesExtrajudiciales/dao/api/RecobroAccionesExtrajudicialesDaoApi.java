package es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dao.api;

import java.util.Date;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto.RecobroAccionesExtrajudicialesDto;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto.RecobroAccionesExtrajudicialesExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroAccionesExtrajudiciales;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroDDResultadoGestionTelefonica;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;

/**
 * Interfaz de métodos para el DAO de las Acciones Extrajudiciales de las Agencias de Recobro
 * @author Guillem
 *
 */
public interface RecobroAccionesExtrajudicialesDaoApi  extends AbstractDao<RecobroAccionesExtrajudiciales, Long>  {

	/**
	 * Obtiene las acciones extrajudiciales por agencia, según el resultado obtenido y a partir de una determinada fecha de gestión 
	 * @param agencia
	 * @param fechaGestion
	 * @param resultadoGestionTelefonica
	 * @return
	 */
	public List<RecobroAccionesExtrajudiciales> getAccionesPorAgenciaResultadoFechaGestion(RecobroAgencia agencia, 
			Date fechaGestion, RecobroDDResultadoGestionTelefonica resultadoGestionTelefonica);
	
	/**
	 * Obtiene las acciones extrajudiciales por agencia, contrato, según el resultado obtenido y a partir de una determinada fecha de gestión 
	 * @param agencia
	 * @param contrato
	 * @param fechaGestion
	 * @param resultadoGestionTelefonica
	 * @return
	 */
	public List<RecobroAccionesExtrajudiciales> getAccionesPorAgenciaContratoResultadoFechaGestion(RecobroAgencia agencia, 
			Contrato contrato, Date fechaGestion, RecobroDDResultadoGestionTelefonica resultadoGestionTelefonica);

	/**
	 * Obtiene las acciones extrajudiciales por agencia, contrato y durante un intervalo de tiempo de fecha de gestión 
	 * @param agencia
	 * @param contrato
	 * @param fechaGestionInicial
	 * @param fechaGestionFinal
	 * @return
	 */
	public List<RecobroAccionesExtrajudiciales> getAccionesPorAgenciaContratoIntervaloFechaGestion(RecobroAgencia agencia, 
			Contrato contrato, Date fechaGestionInicial, Date fechaGestionFinal);
	
	/**
	 * Obtiene las acciones extrajudiciales por agencia, contrato, intervalo de tiempo de fecha de gestión y resultados de gestión telefonica 
	 * @param agencia
	 * @param contrato
	 * @param fechaGestionInicial
	 * @param fechaGestionFinal
	 * @param codigosResultadosGestionTelefonica
	 * @return
	 */
	public List<RecobroAccionesExtrajudiciales> getAccionesPorAgenciaContratoIntervaloFechaGestionResultados(RecobroAgencia agencia, 
			Contrato contrato, Date fechaGestionInicial, Date fechaGestionFinal, List<String> codigosResultadosGestionTelefonica);

	
	/**
	 * Obtiene las acciones extrajudiciales por agencia, persona, intervalo de tiempo de fecha de gestión y resultados de gestión telefonica 
	 * @param agencia
	 * @param persona
	 * @param fechaGestionInicial
	 * @param fechaGestionFinal
	 * @param codigosResultadosGestionTelefonica
	 * @return
	 */
	public List<RecobroAccionesExtrajudiciales> getAccionesPorAgenciaPersonaIntervaloFechaGestionResultados(RecobroAgencia agencia, 
			Persona persona, Date fechaGestionInicial, Date fechaGestionFinal, List<String> codigosResultadosGestionTelefonica);
	
	/**
	 * Obtiene las acciones extrajudiciales que se han realizado sobre un ciclo de recobro del contrato
	 * @param dto
	 * @return
	 */
	public Page getPageAccionesCicloRecobroContrato(RecobroAccionesExtrajudicialesDto dto);
	
	
	/**
	 * Obtiene las acciones extrajudiciales que se han realizado sobre un ciclo de recobro de la persona
	 * @param dto
	 * @return
	 */
	public Page getPageAccionesCicloRecobroPersona(RecobroAccionesExtrajudicialesDto dto);
	

	/**
	 * Obtiene las acciones extrajudiciales de un expediente
	 * @param dto
	 * @return
	 */
	public Page getPageAccionesRecobroExpediente(RecobroAccionesExtrajudicialesExpedienteDto dto);

}

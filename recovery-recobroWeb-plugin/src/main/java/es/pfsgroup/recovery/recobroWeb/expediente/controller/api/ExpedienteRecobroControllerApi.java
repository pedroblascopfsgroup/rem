package es.pfsgroup.recovery.recobroWeb.expediente.controller.api;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.recovery.recobroCommon.contrato.dto.CicloRecobroContratoDto;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.AcuerdoExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.expediente.dto.CicloRecobroExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.persona.dto.CicloRecobroPersonaDto;

public interface ExpedienteRecobroControllerApi {
			
	/**
	 * Devuelve datos adicionales del expediente para completar la pestaña cabecera del expediente de recobro
	 * @param id
	 * @param map
	 * @return
	 */
	String getCabeceraExpedienteRecobro(@RequestParam(value = "id", required = true) Long id, ModelMap map);
	
	/**
	 * Devuelve una lista de carteras para la busqueda de expedientes recobro
	 * @param map
	 * @return
	 */
	String getListCarteras(Long idEsquema, ModelMap map);
	
	/**
	 * Devuelve una lista de subcarteras para la busqueda de expedientes recobro
	 * @param map
	 * @return
	 */
	String getListSubCarteras(Long idEsquema, Long idCartera, ModelMap map);
	
	String getListEsquemas(ModelMap map);
	
	String getTipoIncidencia(ModelMap map);
	
	String getSituacionIncidencia(ModelMap map);
	
	String getTipoAcuerdo(ModelMap map);
	
	String getSolicitante(ModelMap map);
	
	String getEstadoAcuerdo(ModelMap map);
	
	String getListMotivosBaja(ModelMap map);
	
	String getListAgencias(ModelMap map);
	
	String getListSupervisores(ModelMap map);
	
	/**
	 * Devuelve los supervisores de la agencia pasada por parametro
	 * @param idAgencia
	 * @param map
	 * @return
	 */
	String getListSupervisoresAgencia(@RequestParam(value = "idAgencia", required = true) Long idAgencia, ModelMap map);
	
	/**
	 * Abre la ventana de alta de acuerdo para expediente de recobro
	 * @param idExpediente
	 * @param map
	 * @return
	 */
	String abreAltaAcuerdo(@RequestParam(value = "idExpediente", required = true) Long idExpediente, ModelMap map);
	
	/**
	 * Lista todos los acuerdos del expediente
	 * @param idExpediente
	 * @param map
	 * @return
	 */
	String getAcuerdosExpediente(@RequestParam(value = "idExpediente", required = true) Long idExpediente, ModelMap map);
	
	/**
	 * Crea un nuevo acuerdo del expediente o modifica uno ya existente
	 * @param dto
	 * @param map
	 * @return
	 */
	String guardarAcuerdoExpediente(AcuerdoExpedienteDto dto, ModelMap map);
	
	/**
	 * Cambia el estado de un acuerdo a propuesto
	 * @param idAcuerdo
	 * @param map
	 * @return
	 */
	String proponerAcuerdo (@RequestParam(value = "idAcuerdo", required = true) Long idAcuerdo, ModelMap map);
	
	/**
	 * Cambia el estado de un acuerdo a cancelado
	 * @param idAcuerdo
	 * @param map
	 * @return
	 */
	String cancelarAcuerdo(@RequestParam(value = "idAcuerdo", required = true) Long idAcuerdo, ModelMap map);
	
	/**
	 * Abre la ventana de alta de acuerdo pero con el acuerdo seleccionado ya cargado
	 * @param idExpediente
	 * @param idAcuerdo
	 * @param map
	 * @return
	 */
	String abreEdicionAcuerdo(@RequestParam(value = "idExpediente", required = true) Long idExpediente, @RequestParam(value = "idAcuerdo", required = true) Long idAcuerdo,ModelMap map);

	

	
}

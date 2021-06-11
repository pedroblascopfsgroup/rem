package es.pfsgroup.plugin.rem.api;

import java.util.HashMap;
import java.util.List;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankiaDto;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;

public interface ResolucionComiteApi {

	public static final String NOTIF_RESOL_COMITE_TITEL_MSG = "Resolución comité CaixaBank sobre la oferta número ";
	public static final String NOTIF_ANUL_RESOL_COMITE_TITEL_MSG = "Anulación resolución comité CaixaBank sobre la oferta número ";
	public static final String NOTIF_RESOL_COMITE_BODY_INITMSG = "El comité decisor de CaixaBank, ha tomado una resolución sobre una oferta de un activo.";
	public static final String NOTIF_ANUL_RESOL_COMITE_BODY_INITMSG = "El comité decisor de CaixaBank, ha anulado una resolución sobre una oferta de un activo.";
	public static final String NOTIF_RESOL_COMITE_BODY_ENDMSG = "Por favor, acceda a la agenda para finalizar la tarea pendiente. Gracias";
	public static final String NOTIF_ANUL_RESOL_COMITE_BODY_ENDMSG = "Por favor, anule el expediente comercial. Gracias";

	/**
	 * Devuelve una lista de errores encontrados en los parámetros de entrada de
	 * las peticiones POST.
	 * 
	 * @param ResolucionComiteBankiaDto
	 *            con los parametros de entrada
	 * @param jsonFields
	 *            estructura de parámetros para validar campos en caso de venir
	 *            informados
	 * @return HashMap<String, String>
	 */
	public HashMap<String, String> validateResolucionPostRequestData(ResolucionComiteDto resolucionComiteDto,
			Object jsonFields) throws Exception;

	/**
	 * Convierte un ResolucionComiteDto a un objeto ResolucionComiteBankia
	 * 
	 * @param resolucionComiteDto
	 *            con los parametros de entrada
	 * @return ResolucionComiteBankiaDto dto con los objetos obtenidos a partir
	 *         de ResolucionComiteDto
	 */
	public ResolucionComiteBankiaDto getResolucionComiteBankiaDtoFromResolucionComiteDto(
			ResolucionComiteDto resolucionComiteDto) throws Exception;

	/**
	 * Devuelve una lista de ResolucionComite por expediente comercial y tipo de
	 * resolución
	 * 
	 * @param resolucionComiteDto
	 *            con la información para filtrar
	 * @return List<ResolucionComiteBankia>
	 */
	public List<ResolucionComiteBankia> getResolucionesComiteByExpedienteTipoRes(ResolucionComiteBankiaDto resolDto)
			throws Exception;

	/**
	 * Metodo para dar de alta las resoluciones del comite de bankia. Si ya
	 * existe una resolución para el expediente y tipo de resolución pasados por
	 * parámetro, se marca la anterior resolución como borrada y se inserta la
	 * nueva resolución.
	 * 
	 * @param resolucionComiteDto
	 *            con la información de la resolucion a dar de alta
	 * @return ResolucionComiteBankia
	 */
	public ResolucionComiteBankia saveOrUpdateResolucionComite(ResolucionComiteDto resolucionComiteDto)
			throws Exception;

	/**
	 * Crea una nueva ResolucionComite a partir de la información pasada por
	 * parámetro.
	 * 
	 * @param resolDto
	 *            con la información de la resolucion a dar de alta
	 * @return ResolucionComiteBankia
	 */
	public ResolucionComiteBankia saveResolucionComite(ResolucionComiteBankiaDto resolDto, Long numOferta)
			throws Exception;

	/**
	 * Notifica una resolucion 
	 * 
	 * @param resol
	 * @param usu
	 * @param eco
	 * @param mensajeDevolucion
	 * @param devolucion
	 * @throws Exception
	 */
	public Notificacion notificarResolucion(ResolucionComiteBankia resol, Usuario usu, ExpedienteComercial eco,
			String mensajeDevolucion, String devolucion) throws Exception;
	
	/**
 	 * Notifica la anulación de una resolución

	 * @param resol
	 * @param usu
	 * @param eco
	 * @return
	 * @throws Exception
	 */
	public Notificacion notificarAnulacionResolucion(ResolucionComiteBankia resol,Usuario usu, ExpedienteComercial eco) throws Exception;
}

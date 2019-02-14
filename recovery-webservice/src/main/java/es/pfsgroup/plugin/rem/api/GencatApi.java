package es.pfsgroup.plugin.rem.api;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoGencat;
import es.pfsgroup.plugin.rem.model.DtoGencatSave;
import es.pfsgroup.plugin.rem.model.DtoHistoricoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoNotificacionActivo;
import es.pfsgroup.plugin.rem.model.DtoOfertasAsociadasActivo;
import es.pfsgroup.plugin.rem.model.DtoReclamacionActivo;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;

public interface GencatApi {

	/**
	 * Devuelve la información de GENCAT de una comunicacion de un activo.
	 * 
	 * @param id del activo al que pertenece la comunicación
	 * @return DtoGencat
	 */
	public DtoGencat getDetalleGencatByIdActivo(Long idActivo);
	
	/**
	 * Devuelve las ofertas de la comunicación de un activo.
	 * 
	 * @param id del activo al que pertenece la comunicación
	 * @return DtoOfertasAsociadasActivo
	 */
	public List<DtoOfertasAsociadasActivo> getOfertasAsociadasByIdActivo(Long idActivo);
	
	/**
	 * Devuelve las reclamaciones de la comunicación de un activo.
	 * 
	 * @param id del activo al que pertenece la comunicación
	 * @return DtoReclamacionActivo
	 */
	public List<DtoReclamacionActivo> getReclamacionesByIdActivo(Long idActivo);
	
	/**
	 * Obtiene los documentos de una comunicación GENCAT
	 * 
	 * @param id del activo al que pertenece la comunicación
	 * @return DtoAdjunto
	 */
	public List<DtoAdjunto> getListAdjuntosComunicacionByIdActivo(Long id) throws GestorDocumentalException, IllegalAccessException, InvocationTargetException;
	
	/**
	 * Devuelve el historico de comunicaciones de un activo
	 * 
	 * @param id del activo
	 * @return DtoHistoricoComunicacionGencat
	 */
	public List<DtoHistoricoComunicacionGencat> getHistoricoComunicacionesByIdActivo(Long idActivo);
	
	/**
	 * Devuelve la información de GENCAT de una comunicacion del historico.
	 * 
	 * @param id del activo
	 * @return DtoGencat
	 */
	public DtoGencat getDetalleHistoricoByIdComunicacionHistorico(Long idComunicacionHistorico);
	
	/**
	 * Devuelve el historico de ofertas de la comunicación del historico de un activo.
	 * 
	 * @param id de la comunicación del histórico
	 * @return DtoOfertasAsociadasActivo
	 */
	public List<DtoOfertasAsociadasActivo> getHistoricoOfertasAsociadasIdComunicacionHistorico(Long idComunicacionHistorico);
	
	/**
	 * Devuelve las reclamaciones de la comunicación del histórico de un activo.
	 * 
	 * @param id de la comunicación del histórico
	 * @return DtoReclamacionActivo
	 */
	public List<DtoReclamacionActivo> getHistoricoReclamacionesByIdComunicacionHistorico(Long idComunicacionHistorico);
	
	/**
	 * Obtiene los documentos de una comunicación del histórico
	 * 
	 * @param id de la comunicación del histórico
	 * @return DtoAdjunto
	 */
	public List<DtoAdjunto> getListAdjuntosComunicacionHistoricoByIdComunicacionHistorico(Long idComunicacionHistorico) throws GestorDocumentalException, IllegalAccessException, InvocationTargetException;
	
	/**
	 * Sirve para que después de guardar un fichero en el servicio de RestClient
	 * guarde el identificador obtenido en base de datos
	 * 
	 * @param webFileItem
	 * @param idDocRestClient
	 * @return
	 * @throws Exception
	 */
	public String uploadDocumento(WebFileItem webFileItem, Long idDocRestClient, Activo activo, String matricula, Usuario usuarioLogado, ComunicacionGencat comunicacionGencat) throws Exception;
	
	/**
	 * Devuelve las notificaciones de la comunicación de un activo.
	 * 
	 * @param id del activo al que pertenece la comunicación
	 * @return DtoReclamacionActivo
	 */
	public List<DtoNotificacionActivo> getNotificacionesByIdActivo(Long idActivo);
	
	/**
	 * Devuelve las notificaciones de la comunicación del histórico de un activo.
	 * 
	 * @param id del activo al que pertenece la comunicación
	 * @return DtoReclamacionActivo
	 */
	public List<DtoNotificacionActivo> getNotificacionesHistoricoByIdComunicacionHistorico(Long idComunicacionHistorico);
	
	/**
	 * Crea una notificación y la asocia a la comunicación del activo pasado como parámetro
	 * 
	 * @param id del activo al que pertenece la comunicación
	 * @return DtoReclamacionActivo
	 */
	public DtoNotificacionActivo createNotificacionComunicacion(DtoNotificacionActivo notificacionActivo);
	
	/**
	 * Guarda el DtoGencatSave en la BBDD
	 * 
	 * @param gencatDto
	 * @return Boolean
	 */
	public Boolean saveDatosComunicacion(DtoGencatSave gencatDto);
	
	/**
	 * Convierte un DtoGencat en un objeto ComunicacionGencat
	 * 
	 * @param cg
	 * @param gencatDto
	 */
	public void dtoToBeanPreSave(ComunicacionGencat cg , DtoGencatSave gencatDto);
	
	/**
	 * Obtienes un ObjetoComunicacionGencat a partir del IdActivo
	 * 
	 * @param idActivo
	 * @return ComunicacionGencat
	 */
	public ComunicacionGencat getComunicacionGencatByIdActivo(Long idActivo);
	
	/**
	 * Comprueba si el expediente comercial del activo afecto por GENCAT se tiene que bloquear.
	 */
	void bloqueoExpedienteGENCAT(ExpedienteComercial expComercial, ActivoTramite activoTramite);

	/**
	 * Lanza el nuevo tramite de GENCAT.
	 * 
	 * @param Tramite
	 * */
	void lanzarTramiteGENCAT(ActivoTramite tramite, Oferta oferta, ExpedienteComercial expedienteComercial) throws Exception; 
	
	/**
	 * Crea los nuevos registros en las tablas ADG, OFG y CMG.
	 * 
	 * @param ExpedienteComercial
	 * @param Oferta
	 * */
	void crearRegistrosTramiteGENCAT(ExpedienteComercial expedienteComercial, Oferta oferta, ActivoTramite tramite);
	
	/**
	 * Historifica los registros de las tablas ADG, OFG y CMG.
	 * 
	 * @param ExpedienteComercial
	 * @param Oferta
	 * @param ActivoTramite
	 * */
	void historificarTramiteGENCAT(ActivoTramite activoTramite);

	public Boolean deleteAdjunto(DtoAdjunto dtoAdjunto);
	
	/**
	 * Cambiar el estado de comunicacion de GENCAT a comunicado cuando se completa la tarea de Comunicacion GENCAT
	 * @param comunicacionGencat
	 */
	
	void cambiarEstadoComunicacionGENCAT(ComunicacionGencat comunicacionGencat);
	
	/**
	 * Calcular la fecha de sancion a partir de la fecha actual mas 2 meses
	 * @param comunicacionGencat
	 */
	
	void informarFechaSancion(ComunicacionGencat comunicacionGencat);
	
	/**
	 * Cambia la fecha de reclamación en la BBDD
	 * 
	 * @param gencatDto
	 * @return boolean
	 */
	public boolean updateFechaReclamacion(DtoReclamacionActivo gencatDto);
	
}

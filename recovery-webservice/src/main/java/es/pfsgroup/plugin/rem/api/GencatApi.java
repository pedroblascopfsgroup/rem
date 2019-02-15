package es.pfsgroup.plugin.rem.api;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.List;

import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAltaVisita;
import es.pfsgroup.plugin.rem.model.DtoGencat;
import es.pfsgroup.plugin.rem.model.DtoGencatSave;
import es.pfsgroup.plugin.rem.model.DtoHistoricoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoNotificacionActivo;
import es.pfsgroup.plugin.rem.model.DtoOfertasAsociadasActivo;
import es.pfsgroup.plugin.rem.model.DtoReclamacionActivo;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.rest.dto.SalesforceResponseDto;
import es.pfsgroup.plugin.rem.restclient.exception.RestClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;

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
	public void bloqueoExpedienteGENCAT(ExpedienteComercial expComercial, ActivoTramite activoTramite);

	/**
	 * Lanza el nuevo tramite de GENCAT.
	 * 
	 * @param Tramite
	 * */
	public void lanzarTramiteGENCAT(ActivoTramite tramite, Oferta oferta, ExpedienteComercial expedienteComercial) throws Exception; 
	
	/**
	 * Crea los nuevos registros en las tablas ADG, OFG y CMG.
	 * 
	 * @param ExpedienteComercial
	 * @param Oferta
	 * */
	public void crearRegistrosTramiteGENCAT(ExpedienteComercial expedienteComercial, Oferta oferta, ActivoTramite tramite);
	
	/**
	 * Historifica los registros de las tablas ADG, OFG y CMG.
	 * 
	 * @param ExpedienteComercial
	 * @param Oferta
	 * @param ActivoTramite
	 * */
	public void historificarTramiteGENCAT(ActivoTramite activoTramite);

	public Boolean deleteAdjunto(DtoAdjunto dtoAdjunto);
	
	/**
	 * Cambiar el estado de comunicacion de GENCAT a comunicado cuando se completa la tarea de Comunicacion GENCAT
	 * @param comunicacionGencat
	 */
	public void cambiarEstadoComunicacionGENCAT(ComunicacionGencat comunicacionGencat);
	
	/**
	 * Calcular la fecha de sancion a partir de la fecha actual mas 2 meses
	 * @param comunicacionGencat
	 */
	public void informarFechaSancion(ComunicacionGencat comunicacionGencat);
	
	/**
	 * Da de alta una visita en Salesforce y la guarda en la BBDD de REM
	 * 
	 * @param DtoAltaVisita visita que se quiere dar de alta y enviar a Salesforce
	 * @return DtoAltaVisita
	 */
	public DtoAltaVisita altaVisitaComunicacion(DtoAltaVisita dtoAltaVisita) throws Exception;
	
	/**
	 * Valida que los campos obligatorios del formulario esten rellenos, que el activo tenga una comunicacion y que
	 * no haya ya una visita creada.
	 * 
	 * @param DtoAltaVisita dto de la visita que queremos guardar
	 * @return ComunicacionGencat
	 */
	public ComunicacionGencat validateAltaVisita(DtoAltaVisita dtoAltaVisita);
	
	/**
	 * Guarda la visita en la BBDD de REM y la asocia con el idSalesforce que nos devuelva Haya
	 * 
	 * @param ComunicacionGencat comunicacion a la que se asociara la visita
	 * @param DtoAltaVisita dto de la visita que queremos guardar
	 * @param SalesforceResponseDto respuesta de salesforce con el idSalesforce
	 * @return DtoAltaVisita
	 */
	public DtoAltaVisita createVisitaComunicacion(ComunicacionGencat comunicacionGencat, DtoAltaVisita dtoAltaVisita, SalesforceResponseDto salesforceResponseDto);
	
	/**
	 * Metodo que usara el WS de alta de visitas de webcom para asociar las visitas que cree a la
	 * comunicacion del activo pasado como parametro y su idSalesforce
	 * 
	 * @param idActivo La id del activo al que pertenece la comunicación
	 * @param idSalesforce La id que tiene la visita en Salesforce
	 * @param visitaInsertada La visita que queremos asociar con la comunicacion
	 * @return void
	 */
	public void updateVisitaComunicacion(Long idActivo, String idSalesforce, Visita visitaInsertada);
	
}

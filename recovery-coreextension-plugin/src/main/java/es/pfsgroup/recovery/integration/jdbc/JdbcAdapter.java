package es.pfsgroup.recovery.integration.jdbc;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.core.Message;
import org.springframework.integration.core.MessageHeaders;
import org.springframework.integration.message.MessageBuilder;

import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.TypePayload;
import es.pfsgroup.recovery.integration.jdbc.dao.ColaDeMensajeriaDao;
import es.pfsgroup.recovery.integration.jdbc.model.MensajeIntegracion;

public class JdbcAdapter {

	protected final Log logger = LogFactory.getLog(getClass());

	private static final int MAX_RESULTADOS_POR_CONSULTA = 1;
	private static final String GRP_SYS_GUID_NO_APLICA = "N/A";
	private static final String ID_MENSAJE_DB = "db-msg-id";
	
	@Autowired
	private ColaDeMensajeriaDao colaMensajeriaDao;
	
	private final String cola;
	
	public String getCola() {
		return cola;
	}

	public JdbcAdapter(String nombreCola) {
		this.cola = nombreCola;
	}

	/**
	 * Recupera los N resultados de la cola de mensajería de la cola predeterminada.
	 * 
	 * @return
	 */
	public List<Message<String>> readNext() {
		List<MensajeIntegracion> listado = colaMensajeriaDao.getPendientes(this.getCola(), MAX_RESULTADOS_POR_CONSULTA);
		List<Message<String>> output = new ArrayList<Message<String>>();
		logger.info(String.format("[INTEGRACION] Procesando %d mensajes", listado.size()));
		for (MensajeIntegracion msg : listado) {
			Message<String> newMessage = MessageBuilder
					.withPayload(msg.getMensaje())
//					.setCorrelationId(msg.getId())
					.setHeaderIfAbsent(ID_MENSAJE_DB, msg.getId())
					.setHeaderIfAbsent(MessageHeaders.TIMESTAMP, msg.getAuditoria().getFechaCrear())
					.setHeaderIfAbsent(TypePayload.HEADER_MSG_TYPE, msg.getTipo())
					.setHeaderIfAbsent(TypePayload.HEADER_MSG_GROUP, msg.getGuidGrp())
					.build();
			msg.setEstado(MensajeIntegracion.ESTADO_PROCESANDO);
			colaMensajeriaDao.saveOrUpdate(msg);
			output.add(newMessage);
		}
		return output;
	}


	/**
	 * Crea un nuevo mensaje en la tabla de cola de mensajería.
	 * 
	 * @param mensaje
	 */
	public void createNew(Message<String> mensaje) {

		if (!mensaje.getHeaders().containsKey(TypePayload.HEADER_MSG_TYPE)) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El mensaje no tiene asignado tipo de mensaje en la cabecera con la variable %s.", TypePayload.HEADER_MSG_TYPE));
		}
		String tipoMensaje = (String)mensaje.getHeaders().get(TypePayload.HEADER_MSG_TYPE);

		String msgGroup = (mensaje.getHeaders().containsKey(TypePayload.HEADER_MSG_GROUP)) 
				? (String)mensaje.getHeaders().get(TypePayload.HEADER_MSG_GROUP)
				: GRP_SYS_GUID_NO_APLICA;
		
		MensajeIntegracion msg = new MensajeIntegracion();
		msg.setCola(this.getCola());
		msg.setGuidGrp(msgGroup);
		msg.setTipo(tipoMensaje);
		msg.setMensaje(mensaje.getPayload());
		colaMensajeriaDao.save(msg);
	}

	/**
	 * Crea un nuevo mensaje en la tabla de cola de mensajería.
	 * 
	 * @param mensaje
	 */
	public void endPointWihOk(Message<MensajeIntegracion> mensaje) {
		if (!mensaje.getHeaders().containsKey(ID_MENSAJE_DB)) {
			logger.error(String.format("[INTEGRACION] El mensaje no tiene ID de Base de datos para actualizar %s la base de datos.", TypePayload.HEADER_MSG_TYPE));
			return;
		}
		Long idMensaje = (Long)mensaje.getHeaders().get(ID_MENSAJE_DB);
		MensajeIntegracion msg = colaMensajeriaDao.get(idMensaje);
		if (!mensaje.getHeaders().containsKey(ID_MENSAJE_DB)) {
			logger.error(String.format("[INTEGRACION] El mensaje con ID %d no existe en la base de datos.", idMensaje));
			return;
		}
		msg.setEstado(MensajeIntegracion.ESTADO_OK);
		colaMensajeriaDao.save(msg);
	}
	
	/**
	 * Cambia el estado a erróneo.
	 * 
	 * @param mensaje
	 */
	public void endPointWihError(Message<MensajeIntegracion> mensaje) {
		if (!mensaje.getHeaders().containsKey(ID_MENSAJE_DB)) {
			logger.error(String.format("[INTEGRACION] El mensaje no tiene ID de Base de datos para actualizar %s la base de datos.", TypePayload.HEADER_MSG_TYPE));
			return;
		}
		Long idMensaje = (Long)mensaje.getHeaders().get(ID_MENSAJE_DB);
		MensajeIntegracion msg = colaMensajeriaDao.get(idMensaje);
		if (!mensaje.getHeaders().containsKey(ID_MENSAJE_DB)) {
			logger.error(String.format("[INTEGRACION] El mensaje con ID %d no existe en la base de datos.", idMensaje));
			return;
		}
		msg.setEstado(MensajeIntegracion.ESTADO_ERROR);
		//"%s.%s", ex.getMessage(), ex.getStackTrace());
		//if (log.length()>4000) log = String.format(log.substring(0, 3997), "+++");
		//msg.setLog(log);
		colaMensajeriaDao.save(msg);
	}

}

package es.pfsgroup.recovery.integration.jdbc;

import java.util.Date;
import java.util.List;

import org.springframework.integration.core.Message;

import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.TypePayload;
import es.pfsgroup.recovery.integration.jdbc.dao.ColaDeMensajeriaDao;
import es.pfsgroup.recovery.integration.jdbc.model.MensajeIntegracion;

public class JdbcAdapter {

	private static final int MAX_RESULTADOS_POR_CONSULTA = 1;
	private static final String GRP_SYS_GUID_NO_APLICA = "N/A";
	
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
	public List<MensajeIntegracion> next() {
		List<MensajeIntegracion> listado = colaMensajeriaDao.getPendientes(this.getCola(), MAX_RESULTADOS_POR_CONSULTA);
		for (MensajeIntegracion msg : listado) {
			msg.setEstado(MensajeIntegracion.ESTADO_PROCESANDO);
			colaMensajeriaDao.saveOrUpdate(msg);
		}
		return listado;
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

		String msgGroup = (mensaje.getHeaders().containsKey(TypePayload.HEADER_MSG_DESC)) 
				? String.format("%s.msg",(String)mensaje.getHeaders().get(TypePayload.HEADER_MSG_DESC))
				: GRP_SYS_GUID_NO_APLICA;
		
		MensajeIntegracion msg = new MensajeIntegracion();
		msg.setCola(this.getCola());
		msg.setFecha(new Date(mensaje.getHeaders().getTimestamp()));
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
		MensajeIntegracion msg = mensaje.getPayload();
		msg.setEstado(MensajeIntegracion.ESTADO_OK);
		colaMensajeriaDao.save(msg);
	}
	
	/**
	 * Cambia el estado a erróneo.
	 * 
	 * @param mensaje
	 */
	public void endPointWihError(Message<MensajeIntegracion> mensaje, Exception ex) {
		MensajeIntegracion msg = mensaje.getPayload();
		msg.setEstado(MensajeIntegracion.ESTADO_ERROR);
		String log = String.format("%s.%s", ex.getMessage(), ex.getStackTrace());
		if (log.length()>4000) log = String.format(log.substring(0, 3997), "+++");
		msg.setLog(log);
		colaMensajeriaDao.save(msg);
	}
	
}

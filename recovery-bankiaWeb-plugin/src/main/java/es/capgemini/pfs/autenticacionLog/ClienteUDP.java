package es.capgemini.pfs.autenticacionLog;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.PortUnreachableException;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ClienteUDP {

	private static final String KEY_UDP_SERVER_NAME = "log.authentication.servername";
	private static final String KEY_UDP_SERVER_PORT = "log.authentication.port";

	private enum EstadoServidorUDP {NO_INICIADO, INICIADO_ERROR, INICIADO_OK};
	private EstadoServidorUDP estado = EstadoServidorUDP.NO_INICIADO;
	
	@Resource
	private Properties appProperties;
	
	private DatagramSocket serverSocket = null;
	private InetAddress serverIPAddress = null; 
	private int serverPortNumber = 0;

	private final Log logger = LogFactory.getLog(getClass());

	private void init() {
		
		if (estado.equals(EstadoServidorUDP.NO_INICIADO)) {
			boolean serverActivado = false;
			String serverName = "";
			String serverPort = "";
			if (appProperties.containsKey(KEY_UDP_SERVER_NAME) && appProperties.containsKey(KEY_UDP_SERVER_PORT) ) {
				serverName = appProperties.getProperty(KEY_UDP_SERVER_NAME);
				serverPort = appProperties.getProperty(KEY_UDP_SERVER_PORT);
				serverActivado = true;
			}
			
			if (serverActivado) {
				try {
					serverSocket = new DatagramSocket();
					serverIPAddress = InetAddress.getByName(serverName);
					serverPortNumber  = Integer.parseInt(serverPort);
				} catch (SocketException e) {
					logger.error("Error al inicializar socket en ClienteUDP: " + e.getMessage());
					serverActivado = false;
				} catch (UnknownHostException e) {
					logger.error("Error al inicializar ClienteUDP: servidor desconocido " + serverName + ": " + e.getMessage());
					serverActivado = false;
				}	
			}
			if (serverActivado) {
				estado = EstadoServidorUDP.INICIADO_OK;
			} else {
				estado = EstadoServidorUDP.INICIADO_ERROR;
			}
		}
		
	}
	
	public void sendDatagram(String mensaje) {
		
		init();
		
		if (estado.equals(EstadoServidorUDP.INICIADO_OK)) {
			byte[] sendData = new byte[1024];
			sendData = mensaje.getBytes();
			DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length, serverIPAddress, serverPortNumber);
			try {
				serverSocket.send(sendPacket);
			} catch (java.net.PortUnreachableException pue) {
				logger.error("Error al enviar datagrama UDP (puerto inalcanzable): " + pue.getMessage());				
			} catch (IOException ioe) {
				logger.error("Error al enviar datagrama UDP (excepcion IO): " + ioe.getMessage());
			} catch (SecurityException se) {
				logger.error("Error al enviar datagrama UDP (excepcion seguridad): " + se.getMessage());
			} 
		}
	}
	
}

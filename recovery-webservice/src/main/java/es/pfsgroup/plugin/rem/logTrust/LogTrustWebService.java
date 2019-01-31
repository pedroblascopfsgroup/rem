package es.pfsgroup.plugin.rem.logTrust;

import java.util.Date;

import org.apache.commons.logging.LogFactory;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;

@Service
public class LogTrustWebService extends LogTrust {
	
	private final String CODIGO_RESULTADO_POSITIVO_LLAMADA = "OK";
	private final String CODIGO_RESULTADO_NEGATIVO_LLAMADA = "ERROR";
	private final String TEXTO_ESPECIAL_NULO = "null";
	private static final String SEPARADOR = "||";
	
	private enum TIPO_SERVICIO {
		PETICION("peticion"),
		LLAMADA("llamada");

	    private final String text;

	    TIPO_SERVICIO(final String text) {
	        this.text = text;
	    }

	    @Override
	    public String toString() {
	        return text;
	    }
	}


	public LogTrustWebService() {
		super();
		logTrustLogger = LogFactory.getLog(LogTrustWebService.class);
	}

	/**
	 * Este método obtiene los datos de la llamada efectuada hacia un servicio web para montar un registro para LogTrust.
	 * Calcula el resultado de la llamada y establece en el registro la descripción del error.
	 *
	 * @param llamada: entidad con los datos de la llamada para registrar.
	 */
	public void registrarLlamadaServicioWeb(RestLlamada llamada) {
		String resultadoLlamada = CODIGO_RESULTADO_POSITIVO_LLAMADA;
		String temp = llamada.getErrorDesc();
		
		if(!Checks.esNulo(temp) && !temp.contains(TEXTO_ESPECIAL_NULO)) {
			resultadoLlamada = CODIGO_RESULTADO_NEGATIVO_LLAMADA;
		}
		
		this.registrarServicioWeb(TIPO_SERVICIO.LLAMADA, llamada.getToken(), llamada.getIteracion(), llamada.getIp(), llamada.getEndpoint(), llamada.getMetodo(),
				llamada.getAuditoria().getUsuarioCrear(), llamada.getMsInsertarHistorico(), resultadoLlamada, llamada.getErrorDesc());
	}

	/**
	 * Este método obtiene los datos de la petición recibida por un servicio web para montar un registro para LogTrust.
	 *
	 * @param peticion: entidad con los datos de la petición para registrar.
	 */
	public void registrarPeticionServicioWeb(PeticionRest peticion) {
		this.registrarServicioWeb(TIPO_SERVICIO.PETICION, peticion.getToken(), null, peticion.getIp(), peticion.getQuery(), peticion.getMetodo(),
				peticion.getAuditoria().getUsuarioCrear(), peticion.getTiempoEjecucion(), peticion.getResult(), peticion.getErrorDesc());
	}

	private void registrarServicioWeb(TIPO_SERVICIO tipoServicio, String token, Long iteracion, String ip, String endpoint, String metodo, String usuario, Long tiempo,
			String resultado, String descripcionError) {
		StringBuilder builder = new StringBuilder();
		builder.append(sdf.format(new Date()));
		builder.append(SEPARADOR);
		builder.append(tipoServicio.toString());
		builder.append(SEPARADOR);
		builder.append(limpiarCadenaDeTexto(token));
		builder.append(SEPARADOR);
		builder.append(limpiarCadenaDeTexto(iteracion));
		builder.append(SEPARADOR);
		builder.append(limpiarCadenaDeTexto(ip));
		builder.append(SEPARADOR);
		builder.append(limpiarCadenaDeTexto(endpoint));
		builder.append(SEPARADOR);
		builder.append(limpiarCadenaDeTexto(metodo));
		builder.append(SEPARADOR);
		builder.append(limpiarCadenaDeTexto(usuario));
		builder.append(SEPARADOR);
		builder.append(limpiarCadenaDeTexto(tiempo));
		builder.append(SEPARADOR);
		builder.append(limpiarCadenaDeTexto(resultado));
		builder.append(SEPARADOR);
		builder.append(limpiarCadenaDeTexto(descripcionError));
		
		this.registrarMensaje(builder.toString());
	}

	/**
	 * Este método convierte si es necesario un objeto a cadena de texto y luego procesa si esa cadena tiene la palabra
	 * 'null' o si bien está vacía. En alguno de los dos casos devuelve un literal vacío y limpio. Si no, devuelve el
	 * literal sin más.
	 *
	 * @param texto: objeto que contiene un texto para tratar.
	 * @return Devuelve una cadena de texto limpia.
	 */
	private String limpiarCadenaDeTexto(Object texto) {
		String temp = String.valueOf(texto);

		if(!Checks.esNulo(temp) && !temp.contains(TEXTO_ESPECIAL_NULO)) {
			return temp;
		} else {
			return "";
		}
	}
}

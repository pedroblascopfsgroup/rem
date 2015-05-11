package es.capgemini.pfs.asunto.dto;

import java.io.Serializable;
import java.util.Date;

import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;

/**
 * Dto para obtener los textos de las comunicaciones
 * @author 
 *
 */
public class DtoReportComunicacion implements Serializable {

    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	// Campos propios de la comunicacion
	private TareaNotificacion tarea;
    private String textoComunicacion;
    private String respuestaComunicacion;
    private boolean isAnotacion;
 
    // Campos propios de la anotaci�n
    private String usuario;
    
	// Campos comunes Comunicacion y correo
	private String emisor; 
    private String destinatario;
    
    // Campos comunes Anotacion y correo
    private String asunto;
    private String texto;
    private Date fecha;
    
    // TIPOS: 1. Anotaci�n    2. Comunicaci�n    3. Correo
    private String tipoComunicacion;

    /**
     * @return the tarea
     */
    public TareaNotificacion getTarea() {
        return tarea;
    }

    /**
     * @param tarea the tarea to set
     */
    public void setTarea(TareaNotificacion tarea) {
        this.tarea = tarea;
    }

	public String getTextoComunicacion() {
		return textoComunicacion;
	}

	public void setTextoComunicacion(String textoComunicacion) {
		this.textoComunicacion = textoComunicacion;
	}

	public String getRespuestaComunicacion() {
		return respuestaComunicacion;
	}

	public void setRespuestaComunicacion(String respuestaComunicacion) {
		this.respuestaComunicacion = respuestaComunicacion;
	}

	public boolean isAnotacion() {
		return isAnotacion;
	}

	public void setAnotacion(boolean isAnotacion) {
		this.isAnotacion = isAnotacion;
	}

	public String getEmisor() {
		return emisor;
	}

	public void setEmisor(String emisor) {
		this.emisor = emisor;
	}

	public String getDestinatario() {
		return destinatario;
	}

	public void setDestinatario(String destinatario) {
		this.destinatario = destinatario;
	}

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	public String getAsunto() {
		return asunto;
	}

	public void setAsunto(String asunto) {
		this.asunto = asunto;
	}

	public String getTexto() {
		return texto;
	}

	public void setTexto(String texto) {
		this.texto = texto;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	public String getTipoComunicacion() {
		return tipoComunicacion;
	}

	public void setTipoComunicacion(String tipoComunicacion) {
		this.tipoComunicacion = tipoComunicacion;
	}

	/**
	 * Texto sin formato HTML
	 * 
	 * @return
	 */
	public String getTextoSinHTML() {
		if (Checks.esNulo(this.textoComunicacion)) return this.textoComunicacion;
		String cleanText = this.textoComunicacion.replaceAll("(<\\/p.*?>)", "$1\n");
		cleanText = cleanText.replaceAll("<br.*?>", "\n");
		cleanText = cleanText.replaceAll("<[^>]*>", "");
		return cleanText;
	}
	
}

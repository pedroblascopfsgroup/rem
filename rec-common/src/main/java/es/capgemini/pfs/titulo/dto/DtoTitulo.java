package es.capgemini.pfs.titulo.dto;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.titulo.model.Titulo;

/**
 * Clase que transfiere informaci�n desde la vista hacia el modelo.
 */
public class DtoTitulo extends WebDto {

	/**
	 * serial.
	 */
	private static final long serialVersionUID = -6637797816506547314L;

    private Titulo titulo;
    private boolean intervenido;
    private Contrato contrato;
    private String codigoSituacion;
    private String codigoTipo;
    private String comentario;

    /**
     * Este m�todo lo llamar� autom�ticamente webflow cuando usemos el dto e intentemos salir.
     * <br>
     * @param messageContext messageContext
     */
    public void validateUpdate(MessageContext messageContext) {
        messageContext.clearMessages();

        if(codigoSituacion != null && codigoTipo!= null) {
            return;
        }
        messageContext.addMessage(new MessageBuilder().code("titulo.editio.datos").error().source("").defaultText(
                "**Faltan datos.").build());
        throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));

    }

    /**
     * Retorna el atributo contrato.
     * @return idContrato
     */
    public Contrato getContrato() {
        return contrato;
    }

    /**
     * Setea el atributo contrato.
     * @param contrato Contrato
     */
    public void setContrato(Contrato contrato) {
        this.contrato = contrato;
    }

    /**
     * Retorna el atributo intervenido.
     * @return intervenido
     */
    public boolean getIntervenido() {
        return intervenido;
    }

    /**
     * Setea el atributo intervenido.
     * @param intervenido String
     */
    public void setIntervenido(boolean intervenido) {
        this.intervenido = intervenido;
    }

    /**
     * Retorna el atributo titulo.
     * @return titulo
     */
    public Titulo getTitulo() {
        return titulo;
    }

    /**
     * Setea el atributo titulo.
     * @param titulo Titulo
     */
    public void setTitulo(Titulo titulo) {
        this.titulo = titulo;
    }

    /**
     * @return the idSituacion
     */
    public String getCodigoSituacion() {
        return codigoSituacion;
    }

    /**
     * @param codSituacion the idSituacion to set
     */
    public void setCodigoSituacion(String codSituacion) {
        this.codigoSituacion = codSituacion;
    }

    /**
     * @return the idTipo
     */
    public String getCodigoTipo() {
        return codigoTipo;
    }

    /**
     * @param cosTipo the idTipo to set
     */
    public void setCodigoTipo(String cosTipo) {
        this.codigoTipo = cosTipo;
    }

    /**
     * @return the comentario
     */
    public String getComentario() {
        return comentario;
    }

    /**
     * @param comentario the comentario to set
     */
    public void setComentario(String comentario) {
        this.comentario = comentario;
    }

}

package es.capgemini.pfs.ingreso.dto;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.ingreso.model.DDTipoIngreso;
import es.capgemini.pfs.ingreso.model.Ingreso;

/**
 * DTO para la carga y edici�n de bienes de una persona.
 * @author Mariano Ruiz
 *
 */
public class DtoIngreso extends WebDto {

	/**
	 * serial.
	 */
	private static final long serialVersionUID = -6637787816586547314L;

    private Ingreso ingreso;
    private DDTipoIngreso tipoIngreso;



    /**
     * Este m�todo lo llamar� autom�ticamente webflow cuando usemos el dto e intentemos
     * salir del estado con id="formulario".<br>
     * Se valida en dos partes:
     * <ul>
     * <li> los campos de este dto</li>
     * <li> los campos del objeto embebido 'ingreso'</li>
     * </ul>
     * @param messageContext MessageContext
     */
    public void validateFormulario(MessageContext messageContext) {
        messageContext.clearMessages();
        if(ingreso==null || ingreso.getIngNetoBruto()==null || ingreso.getPeriodicidad()==null || ingreso.getTipoIngreso()==null) {
            messageContext.addMessage(new MessageBuilder().code("ingreso.error.campos").error().source("").defaultText(
                "**Todos los campos deben ser llenados.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }
        if(ingreso.getIngNetoBruto()<=0) {
            messageContext.addMessage(new MessageBuilder().code("ingreso.error.netobruto").error().source("").defaultText(
                "**El ingreso debe ser mayor a cero.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }
        if(ingreso.getPeriodicidad()<=0) {
            messageContext.addMessage(new MessageBuilder().code("ingreso.error.periodicidad").error().source("").defaultText(
                "**La periodicidad debe ser mayor a cero.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }
    }

    /**
     * @return the ingreso
     */
    public Ingreso getIngreso() {
        return ingreso;
    }
    /**
     * @param ingreso the ingreso to set
     */
    public void setIngreso(Ingreso ingreso) {
        this.ingreso = ingreso;
    }
    /**
     * @return the tipoIngreso
     */
    public DDTipoIngreso getTipoIngreso() {
        return tipoIngreso;
    }
    /**
     * @param tipoIngreso the tipoIngreso to set
     */
    public void setTipoIngreso(DDTipoIngreso tipoIngreso) {
        this.tipoIngreso = tipoIngreso;
    }
}

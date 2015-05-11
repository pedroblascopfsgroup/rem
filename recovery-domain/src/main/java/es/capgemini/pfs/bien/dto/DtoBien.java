package es.capgemini.pfs.bien.dto;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.bien.model.Bien;

/**
 * @author marruiz
 */
public class DtoBien extends WebDto {

    /**
     * serial.
     */
    private static final long serialVersionUID = -6637787116506547314L;

    private Bien bien;

    /**
     * @return the bien
     */
    public Bien getBien() {
        return bien;
    }

    /**
     * @param bien the bien to set
     */
    public void setBien(Bien bien) {
        this.bien = bien;
    }

    /*private static final String PISO = "1";
    private static final String FINCA = "2";
    */

    /**
     * Este mï¿½todo lo llamarï¿½ automï¿½ticamente webflow cuando usemos el dto e intentemos
     * salir del estado con id="formulario".<br>
     * Se valida en dos partes:
     * <ul>
     * <li> los campos de este dto</li>
     * <li> los campos del objeto embebido 'bien'</li>
     * </ul>
     * @param messageContext MessageContext
     */
    public void validateFormulario(MessageContext messageContext) {
        messageContext.clearMessages();
        if (bien.getParticipacion() == null) {
            messageContext.addMessage(new MessageBuilder().code("bienes.error.participacionnula").error().source("").defaultText(
                    "**Ingrese el porcentaje de 'Participación'.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }
        final int participacion = 100;
        if (bien.getParticipacion() != null && (bien.getParticipacion() < 1 || bien.getParticipacion() > participacion)) {
            messageContext.addMessage(new MessageBuilder().code("bienes.error.participacion").error().source("").defaultText(
                    "**El porcentaje en 'Participación' debe ser entre 1 y 100.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }

        if (bien.getDatosRegistrales() != null && bien.getDatosRegistrales().length() > 50) {
            messageContext.addMessage(new MessageBuilder().code("bien.error.datoRegistral.limite").error().source("").defaultText(
                    "**Los datos registrales no deben exceder de 50 carácteres.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }

        if (bien.getReferenciaCatastral() != null && bien.getReferenciaCatastral().length() > 50) {
            messageContext.addMessage(new MessageBuilder().code("bien.error.referenciaCatastral.limite").error().source("").defaultText(
                    "**La referencia catastral no debe exceder de 50 carácteres.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }

        if (bien.getDescripcionBien() != null && bien.getDescripcionBien().length() > 250) {
            messageContext.addMessage(new MessageBuilder().code("error.limiteCaracteres.250").error().source("").defaultText(
                    "**No se puede guardar más de 250 carácteres para el campo de descripción/observación..").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }

        //El cliente no quiere que se comprueben los campos. Se comprobarán cuando de verdad se diferencien con un tipo los bienes/inmuebles
        /*
        if ((!bien.getTipoBien().getCodigo().equals(PISO) && !bien.getTipoBien().getCodigo().equals(FINCA))
                && ((bien.getDatosRegistrales() != null && !bien.getDatosRegistrales().equals(""))
                        || (bien.getPoblacion() != null && !bien.getPoblacion().equals(""))
                        || (bien.getReferenciaCatastral() != null && !bien.getReferenciaCatastral().equals("")) || (bien.getSuperficie() != null && !bien
                        .getSuperficie().equals("")))) {
            messageContext.addMessage(new MessageBuilder().code("bienes.error.inmueble").error().source("").defaultText(
                    "**No se puede cargar a un bien mueble datos referentes a un inmueble.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }
        if (bien.getSuperficie() != null && bien.getSuperficie().floatValue() <= 0) {
            messageContext.addMessage(new MessageBuilder().code("bienes.error.superficie").error().source("").defaultText(
                    "**La superficie debe ser mayor a cero.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }
        */
        addValidation(bien, messageContext, "bien").addValidation(this, messageContext).validate();
    }

}

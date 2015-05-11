package es.capgemini.pfs.persona.dto;


import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.persona.model.Persona;

/**
 * @author Mariano Ruiz
 */
public class DtoUmbral extends WebDto {

    private static final long serialVersionUID = -5064781869402420149L;

    private Persona persona;


    /**
     * @return the persona
     */
    public Persona getPersona() {
        return persona;
    }

    /**
     * @param persona the persona to set
     */
    public void setPersona(Persona persona) {
        this.persona = persona;
    }


    /**
     * Este método lo llamará automáticamente webflow cuando usemos el dto e intentemos
     * salir del estado con id="formulario".<br>
     * Se valida en dos partes:
     * <ul>
     * <li> los campos de este dto</li>
     * <li> los campos del objeto embebido 'persona'</li>
     * </ul>
     * @param messageContext MessageContext
     */
    public void validateFormulario(MessageContext messageContext) {
       /* messageContext.clearMessages();
        Date d = FormatDateUtils.fechaSinHora(new Date());
        if(persona.getFechaUmbral()!=null && persona.getFechaUmbral().compareTo(d)<=0) {
            messageContext.addMessage(new MessageBuilder().code("persona.umbral.fechainv").error().source("").defaultText(
                "**La fecha del umbral debe ser mayor a la actual.").build());
        }
        if(persona.getImporteUmbral()!=null && persona.getImporteUmbral()<0) {
            messageContext.addMessage(new MessageBuilder().code("persona.umbral.importeinv").error().source("").defaultText(
            "**El importe del umbral no puede ser menor a 0.").build());
        }
        addValidation(persona, messageContext, "persona").addValidation(this, messageContext).validate();
        */
    }
}

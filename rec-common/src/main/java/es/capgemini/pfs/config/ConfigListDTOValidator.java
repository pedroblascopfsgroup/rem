package es.capgemini.pfs.config;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;
import org.springframework.stereotype.Component;

/**
 * @author Nicolás Cornaglia
 */
@Component
public class ConfigListDTOValidator {

    /**
     * Valida que el key no se nulo.
     * @param model Object
     * @param context MessageContext
     */
    public void validateStart(Object model, MessageContext context) {
        ConfigListDTO dto = (ConfigListDTO) model;
        if (dto.getKey() == null) {
            context.addMessage(new MessageBuilder().error().source("key").defaultText("Key must be not null").build());
        }
    }

}

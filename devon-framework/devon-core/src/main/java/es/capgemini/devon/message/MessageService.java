package es.capgemini.devon.message;

import java.util.Locale;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.MessageSource;
import org.springframework.context.NoSuchMessageException;
import org.springframework.stereotype.Service;

/**
 * @author lgiavedo
 * 
 */
@Service
public class MessageService {

    @Resource(name = "messageSource")
    private MessageSource messageSource;
    private static final String MESSAGE_NOT_FOUND_ERROR = "MESSAGE NOT FOUND";

    public String getMessage(String code, Object args[], Locale locale) {
        try {
            return messageSource.getMessage(code, args, locale);
        } catch (NoSuchMessageException e) {
            logger.error("No se ha encontrado el mensaje asociado para: Codigo[" + code + "] Locale:[" + locale + "] ");
            return MESSAGE_NOT_FOUND_ERROR;
        }
    }

    public String getMessage(String code, Object args[]) {
        try {
            return messageSource.getMessage(code, args, Locale.ROOT);
        } catch (NoSuchMessageException e) {
            logger.error("No se ha encontrado el mensaje asociado para: Codigo[" + code + "] ");
            return MESSAGE_NOT_FOUND_ERROR;
        }
    }

    public String getMessage(String code) {
        try {
            return messageSource.getMessage(code, new Object[] {}, Locale.ROOT);
        } catch (NoSuchMessageException e) {
            logger.error("No se ha encontrado el mensaje asociado para: Codigo[" + code + "] ");
            return MESSAGE_NOT_FOUND_ERROR;
        }
    }

    private final Log logger = LogFactory.getLog(getClass());

}

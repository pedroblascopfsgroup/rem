package es.capgemini.pfs.utils.log4j;

import org.apache.log4j.net.SMTPAppender;
import org.apache.log4j.spi.LoggingEvent;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 *
 */
public class CustomSMTPAppender extends SMTPAppender {

    private static final String PROPERTY_SEND_ERROR_MAIL = "log.mail.sendError";
    
    //variable para indicar se deben enviar los mails
    private boolean enable = false;

    /**
     * Constructor.
     */
    public CustomSMTPAppender() {
        super();
        if (getPropertyValue(PROPERTY_SEND_ERROR_MAIL) != null && getPropertyValue(PROPERTY_SEND_ERROR_MAIL).trim().equalsIgnoreCase("TRUE")) {
            enable = true;
            System.out.println("El servicion CustomSMTPAppender ha sido ACTIVADO.");
            //System.out.println("CustomSMTPAppender Params: SMTP: "+getSMTPHost()+", From: "+getFrom()+",  Bcc: "+getBcc());
        }else{
            System.out.println("El servicion CustomSMTPAppender ha sido DESACTIVADO. "+PROPERTY_SEND_ERROR_MAIL+"="+getPropertyValue(PROPERTY_SEND_ERROR_MAIL));
        }
        
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void append(LoggingEvent event) {
        //Si se habilitado el modulo
        if (enable) {
            super.append(event);
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setBcc(String addresses) {
        super.setBcc(checkDynaProperty(addresses));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setCc(String addresses) {
        super.setCc(checkDynaProperty(addresses));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setEvaluatorClass(String value) {
        super.setEvaluatorClass(checkDynaProperty(value));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setFrom(String from) {
        super.setFrom(checkDynaProperty(from));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setSMTPHost(String smtpHost) {
        super.setSMTPHost(checkDynaProperty(smtpHost));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setSMTPPassword(String password) {
        super.setSMTPPassword(checkDynaProperty(password));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setSMTPUsername(String username) {
        super.setSMTPUsername(checkDynaProperty(username));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setSubject(String subject) {
        super.setSubject(checkDynaProperty(subject));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setTo(String to) {
        super.setTo(checkDynaProperty(to));
    }

    /*
     * Metodos propios
     */
    private String checkDynaProperty(String property) {
        //Verificamos si la propiedad es dinamica
        if (property != null && property.trim().startsWith("{") && property.trim().endsWith("}")) {
            return getPropertyValue(property.trim().substring(1, property.trim().length() - 1));
        }
        return property;

    }

    private String getPropertyValue(String property) {
        //Verificamos si esta definida en devon
        /*try {
            Properties properties = new Properties();
            properties.load(new FileInputStream("devon.properties"));
            if (properties.contains(property)) return properties.getProperty(property);
        } catch (IOException e) {
        }*/

        return System.getenv(property);
    }

}

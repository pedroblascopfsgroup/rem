package es.capgemini.devon.mail;

import java.io.InputStream;
import java.util.Map;
import java.util.Properties;

import javax.activation.FileTypeMap;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.internet.MimeMessage;

import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.ConfigurableMimeFileTypeMap;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;

/**
 * Wrapper sobre JavaMailSenderImpl de Spring
 * 
 * @author Nicolás Cornaglia
 * @see JavaMailSenderImpl
 */
public interface MailManager {

    /**
     * Set JavaMail properties for the <code>Session</code>.
     * <p>A new <code>Session</code> will be created with those properties.
     * Use either this method or {@link #setSession}, but not both.
     * <p>Non-default properties in this instance will override given
     * JavaMail properties.
     */
    public abstract void setJavaMailProperties(Properties javaMailProperties);

    /**
     * Allow Map access to the JavaMail properties of this sender,
     * with the option to add or override specific entries.
     * <p>Useful for specifying entries directly, for example via
     * "javaMailProperties[mail.smtp.auth]".
     */
    public abstract Properties getJavaMailProperties();

    /**
     * Set the JavaMail <code>Session</code>, possibly pulled from JNDI.
     * <p>Default is a new <code>Session</code> without defaults, that is
     * completely configured via this instance's properties.
     * <p>If using a pre-configured <code>Session</code>, non-default properties
     * in this instance will override the settings in the <code>Session</code>.
     * @see #setJavaMailProperties
     */
    public abstract void setSession(Session session);

    /**
     * Return the JavaMail <code>Session</code>,
     * lazily initializing it if hasn't been specified explicitly.
     */
    public abstract Session getSession();

    /**
     * Set the mail protocol. Default is "smtp".
     */
    public abstract void setProtocol(String protocol);

    /**
     * Return the mail protocol.
     */
    public abstract String getProtocol();

    /**
     * Set the mail server host, typically an SMTP host.
     * <p>Default is the default host of the underlying JavaMail Session.
     */
    public abstract void setHost(String host);

    /**
     * Return the mail server host.
     */
    public abstract String getHost();

    /**
     * Set the mail server port.
     * <p>Default is {@link #DEFAULT_PORT}, letting JavaMail use the default
     * SMTP port (25).
    */
    public abstract void setPort(int port);

    /**
     * Return the mail server port.
     */
    public abstract int getPort();

    /**
     * Set the username for the account at the mail host, if any.
     * <p>Note that the underlying JavaMail <code>Session</code> has to be
     * configured with the property <code>"mail.smtp.auth"</code> set to
     * <code>true</code>, else the specified username will not be sent to the
     * mail server by the JavaMail runtime. If you are not explicitly passing
     * in a <code>Session</code> to use, simply specify this setting via
     * {@link #setJavaMailProperties}.
     * @see #setSession
     * @see #setPassword
     */
    public abstract void setUsername(String username);

    /**
     * Return the username for the account at the mail host.
     */
    public abstract String getUsername();

    /**
     * Set the password for the account at the mail host, if any.
     * <p>Note that the underlying JavaMail <code>Session</code> has to be
     * configured with the property <code>"mail.smtp.auth"</code> set to
     * <code>true</code>, else the specified password will not be sent to the
     * mail server by the JavaMail runtime. If you are not explicitly passing
     * in a <code>Session</code> to use, simply specify this setting via
     * {@link #setJavaMailProperties}.
     * @see #setSession
     * @see #setUsername
     */
    public abstract void setPassword(String password);

    /**
     * Return the password for the account at the mail host.
     */
    public abstract String getPassword();

    /**
     * Set the default encoding to use for {@link MimeMessage MimeMessages}
     * created by this instance.
     * <p>Such an encoding will be auto-detected by {@link MimeMessageHelper}.
     */
    public abstract void setDefaultEncoding(String defaultEncoding);

    /**
     * Return the default encoding for {@link MimeMessage MimeMessages},
     * or <code>null</code> if none.
     */
    public abstract String getDefaultEncoding();

    /**
     * Set the default Java Activation {@link FileTypeMap} to use for
     * {@link MimeMessage MimeMessages} created by this instance.
     * <p>A <code>FileTypeMap</code> specified here will be autodetected by
     * {@link MimeMessageHelper}, avoiding the need to specify the
     * <code>FileTypeMap</code> for each <code>MimeMessageHelper</code> instance.
     * <p>For example, you can specify a custom instance of Spring's
     * {@link ConfigurableMimeFileTypeMap} here. If not explicitly specified,
     * a default <code>ConfigurableMimeFileTypeMap</code> will be used, containing
     * an extended set of MIME type mappings (as defined by the
     * <code>mime.types</code> file contained in the Spring jar).
     * @see MimeMessageHelper#setFileTypeMap
     */
    public abstract void setDefaultFileTypeMap(FileTypeMap defaultFileTypeMap);

    /**
     * Return the default Java Activation {@link FileTypeMap} for
     * {@link MimeMessage MimeMessages}, or <code>null</code> if none.
     */
    public abstract FileTypeMap getDefaultFileTypeMap();

    public abstract void send(SimpleMailMessage simpleMessage) throws MailException;

    public abstract void send(SimpleMailMessage[] simpleMessages) throws MailException;

    /**
     * This implementation creates a SmartMimeMessage, holding the specified
     * default encoding and default FileTypeMap. This special defaults-carrying
     * message will be autodetected by {@link MimeMessageHelper}, which will use
     * the carried encoding and FileTypeMap unless explicitly overridden.
     * @see #setDefaultEncoding
     * @see #setDefaultFileTypeMap
     */
    public abstract MimeMessage createMimeMessage();

    public abstract MimeMessage createMimeMessage(InputStream contentStream) throws MailException;

    public abstract void send(MimeMessage mimeMessage) throws MailException;

    public abstract void send(MimeMessage[] mimeMessages) throws MailException;

    public abstract void send(MimeMessagePreparator mimeMessagePreparator) throws MailException;

    public abstract void send(MimeMessagePreparator[] mimeMessagePreparators) throws MailException;

    // Agregados a JavaMailSenderImpl

    @SuppressWarnings("unchecked")
    public String mergeTemplateIntoString(String templateLocation, Map model);

    @SuppressWarnings("unchecked")
    public String mergeTemplateIntoString(String templateLocation, String encoding, Map model);

    public void send(MimeMessageHelper messageHelper);

    public MimeMessageHelper createMimeMessageHelper() throws MessagingException;

    public MimeMessageHelper createMimeMessageHelper(boolean isMultipart) throws MessagingException;

    public MimeMessageHelper createMimeMessageHelper(boolean isMultipart, String encoding) throws MessagingException;

    public MimeMessageHelper createMimeMessageHelper(String encoding) throws MessagingException;

    public MimeMessageHelper createMimeMessageHelper(int multipart) throws MessagingException;

    public MimeMessageHelper createMimeMessageHelper(int multipart, String encoding) throws MessagingException;

}
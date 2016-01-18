package es.capgemini.devon.security;

import org.springframework.security.BadCredentialsException;

/**
 * @author Nicolás Cornaglia
 */

public class IpNotAllowedException extends BadCredentialsException {

    /**
     * Constructs a <code>IpNotAllowedException</code> with the specified
     * message.
     *
     * @param msg the detail message.
     */
    public IpNotAllowedException(String msg) {
        super(msg);
    }

    /**
     * Constructs a <code>IpNotAllowedException</code>, making use of the <tt>extraInformation</tt>
     * property of the superclass.
     *
     * @param msg the detail message
     * @param extraInformation additional information such as the username.
     */
    public IpNotAllowedException(String msg, Object extraInformation) {
        super(msg, extraInformation);
    }

    /**
     * Constructs a <code>IpNotAllowedException</code> with the specified
     * message and root cause.
     *
     * @param msg the detail message.
     * @param t root cause
     */
    public IpNotAllowedException(String msg, Throwable t) {
        super(msg, t);
    }
}

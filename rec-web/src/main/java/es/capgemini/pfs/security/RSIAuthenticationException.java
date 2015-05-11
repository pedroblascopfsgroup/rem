package es.capgemini.pfs.security;

import org.springframework.security.BadCredentialsException;

/**
 * @author Nicol�s Cornaglia
 */

public class RSIAuthenticationException extends BadCredentialsException {

    /**
	 * serial.
	 */
	private static final long serialVersionUID = 6707934302023972516L;

	/**
     * Constructs a <code>IpNotAllowedException</code> with the specified
     * message.
     *
     * @param msg the detail message.
     */
    public RSIAuthenticationException(String msg) {
        super(msg);
    }

    /**
     * Constructs a <code>IpNotAllowedException</code>, making use of the <tt>extraInformation</tt>
     * property of the superclass.
     *
     * @param msg the detail message
     * @param extraInformation additional information such as the username.
     */
    public RSIAuthenticationException(String msg, Object extraInformation) {
        super(msg, extraInformation);
    }

    /**
     * Constructs a <code>IpNotAllowedException</code> with the specified
     * message and root cause.
     *
     * @param msg the detail message.
     * @param t root cause
     */
    public RSIAuthenticationException(String msg, Throwable t) {
        super(msg, t);
    }
}

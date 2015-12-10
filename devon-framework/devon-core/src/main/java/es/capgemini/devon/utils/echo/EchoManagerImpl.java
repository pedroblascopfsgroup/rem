package es.capgemini.devon.utils.echo;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;

/**
 * @author Nicolás Cornaglia
 */
@Service("echoManager")
public class EchoManagerImpl implements EchoManager {

    /**
     * @see es.capgemini.devon.utils.echo.EchoManager#echo(java.lang.String)
     */
    public String echo(String echo) {
        return echo;
    }

    /**
     * @see es.capgemini.devon.utils.echo.EchoManager#transactionalEcho(java.lang.String)
     */
    @Transactional
    public String transactionalEcho(String echo) {
        return echo;
    }

}

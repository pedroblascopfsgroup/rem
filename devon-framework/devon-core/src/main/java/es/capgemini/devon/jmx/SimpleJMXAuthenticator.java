package es.capgemini.devon.jmx;

import javax.management.remote.JMXAuthenticator;
import javax.management.remote.JMXPrincipal;
import javax.security.auth.Subject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * @author lgiavedo
 *
 */
public class SimpleJMXAuthenticator implements JMXAuthenticator{
    
    private final Log logger = LogFactory.getLog(getClass());
    
    private String user;
    
    private String password;
    

    @Override
    public Subject authenticate(Object credentials) {
        try{
            if(user == null || password == null){
                Subject subject = new Subject();
                subject.getPrincipals().add(new JMXPrincipal("ANONYMOUS"));
                logger.info("JMX Anonymous Login");
                return subject;
            }
            
            if (!(credentials instanceof String[])) {
                if (credentials == null) {
                    logger.info("Credentials required");
                    throw new SecurityException("Credentials required");
                }
                throw new SecurityException("Credentials should be String[]");
            }
            
            String[] aCredentials = (String[]) credentials;
            if (aCredentials.length != 2) {
                throw new SecurityException("Credentials should have 2 elements (username/password)");
            }
            
            if(user.equals(aCredentials[0]) && password.equals(aCredentials[1])){
                Subject subject = new Subject();
                subject.getPrincipals().add(new JMXPrincipal(aCredentials[0]));
                logger.info("JMX "+aCredentials[0]+" Login");
                return subject;
            }else{
                throw new SecurityException("Bad username/password");
            }
        }catch(SecurityException se){
            logger.info(se);
            throw se;
        }
        
    }


    /**
     * @return the user
     */
    public String getUser() {
        return user;
    }


    /**
     * @param user the user to set
     */
    public void setUser(String user) {
        this.user = user;
    }


    /**
     * @return the password
     */
    public String getPassword() {
        return password;
    }


    /**
     * @param password the password to set
     */
    public void setPassword(String password) {
        this.password = password;
    }
  
}

package es.capgemini.devon.security;

/**
 * Interface que agrega informacion a la entidad SecurityUser
 * 
 * @author lgiavedo
 *
 */
public interface SecurityUserInfo {
    
    public Long getId();

    public void setId(Long id);
    
    public Long getLoginTime();

    public void setLoginTime(Long loginTime);
    
    public String getRemoteAddress();

    public void setRemoteAddress(String remoteAddress);

}

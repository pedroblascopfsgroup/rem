package es.capgemini.pfs.security;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.security.ui.WebAuthenticationDetails;

/**
 * @author NicolÃ¡s Cornaglia
 */
public class RSIWebAuthenticationDetails extends WebAuthenticationDetails {

    public static final String RSI_SECURITY_FORM_WORKING_CODE_KEY = "workingcode";
    public static final String RSI_SECURITY_FORM_CENTRO_KEY = "centro";
    private static final long serialVersionUID = 1L;
    private static final String TOKEN_PARAMETER = "token";

    private String workingCode;
    private String centro;

    /**
     * @param request
     */
    public RSIWebAuthenticationDetails(HttpServletRequest request) {
        super(request);
    }

    /**
     * @see org.springframework.security.ui.WebAuthenticationDetails#doPopulateAdditionalInformation(javax.servlet.http.HttpServletRequest)
     */
    @Override
    protected void doPopulateAdditionalInformation(HttpServletRequest request) {
        this.workingCode = request.getParameter(RSI_SECURITY_FORM_WORKING_CODE_KEY);
        this.centro = request.getParameter(RSI_SECURITY_FORM_CENTRO_KEY);

        //el parÃ¡metro token lo pasamos al thread local para que luego se use en la pantalla inicial
        if (StringUtils.isNotBlank(request.getParameter(TOKEN_PARAMETER))) {
            TokenContextHolder.setToken(request.getParameter(TOKEN_PARAMETER));
        }

    }

    /**
     * @return the entidad
     */
    public String getWorkingCode() {
        return workingCode;
    }

    /**
     * @return the centro
     */
    public String getCentro() {
        return centro;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof RSIWebAuthenticationDetails) {
            RSIWebAuthenticationDetails rhs = (RSIWebAuthenticationDetails) obj;

            if (((getRemoteAddress() == null) && (rhs.getRemoteAddress() != null))
                    || ((getRemoteAddress() != null) && (rhs.getRemoteAddress() == null))
                    || (getRemoteAddress() != null && !getRemoteAddress().equals(rhs.getRemoteAddress()))) { return false; }

            if (((getSessionId() == null) && (rhs.getSessionId() != null)) || ((getSessionId() != null) && (rhs.getSessionId() == null))
                    || (getSessionId() != null && !getSessionId().equals(rhs.getSessionId()))) { return false; }

            if (((getWorkingCode() == null) && (rhs.getWorkingCode() != null)) || ((getWorkingCode() != null) && (rhs.getWorkingCode() == null))
                    || (getWorkingCode() != null && !getWorkingCode().equals(rhs.getWorkingCode()))) { return false; }

            if (((getCentro() == null) && (rhs.getCentro() != null)) || ((getCentro() != null) && (rhs.getCentro() == null))
                    || (getCentro() != null && !getCentro().equals(rhs.getCentro()))) { return false; }

            return true;
        }

        return false;
    }

    @Override
    public String toString() {
        return super.toString() + "; WorkingCode: " + this.getWorkingCode() + "; Centro: " + this.getCentro();
    }

    @Override
    public int hashCode() {
        int hash = super.hashCode();
        if (this.getWorkingCode() != null) {
            hash = hash * (this.getWorkingCode().hashCode() % 7);
        }
        if (this.getCentro() != null) {
            hash = hash * (this.getCentro().hashCode() % 7);
        }
        return hash;
    }
}

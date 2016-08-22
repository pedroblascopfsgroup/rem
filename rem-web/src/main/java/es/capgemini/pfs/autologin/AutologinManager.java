package es.capgemini.pfs.autologin;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.autologin.model.Token;
import es.capgemini.pfs.autologin.model.TokenManager;
import es.capgemini.pfs.security.TokenContextHolder;

@Service
public class AutologinManager {

    @Autowired
    TokenManager tokenManager;

    /** si existe token en el thread local lo procesamos
     * @return
     */
    @BusinessOperation
    public String process(DtoAutologin autologin) {

        StringBuffer loginCode = new StringBuffer("");
        String tokenValue = TokenContextHolder.getToken();
        if (StringUtils.isNotBlank(tokenValue)) {
            Token token = tokenManager.getToken(TokenContextHolder.getToken());
            loginCode.append("app.autologin(");
            if (token != null) {
                loginCode.append(token.getValor());
            } else {
                loginCode.append(tokenValue);
            }
            loginCode.append(");");
            return loginCode.toString();
        }

        if (autologin.getAction() != null) {
            loginCode.append("app.autologin('").append(autologin.getAction()).append("'");
            if (autologin.getArgs().length > 0) {
                loginCode.append(",");
                for (int i = 0; i < autologin.getArgs().length; i++) {
                    String arg = autologin.getArgs()[i];
                    if (arg != null) {
                        loginCode.append("'").append(arg).append("'");
                    }
                }
            }
            loginCode.append(");");
            return loginCode.toString();

        }

        return ";";
    }
}

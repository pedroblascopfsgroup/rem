package es.capgemini.pfs.security;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.security.Authentication;
import org.springframework.security.context.SecurityContext;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.pfsgroup.commons.utils.Checks;

@Component
@Aspect
public class ClientIdentifierConnectionPreparer {
	 
	 @AfterReturning(pointcut= "execution(* *.getConnection(..))", returning = "connection")
		public Connection setClientIdentifier(Connection connection) throws SQLException {
		 	
		 	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		 	
		 	if(!Checks.esNulo(auth)){
			 	
		 		Object principal = auth.getPrincipal();
			 	String username = "";
			 	
			  	if (principal instanceof UsuarioSecurity) {
			  	  username = ((UsuarioSecurity)principal).getUsername();
			  	} else {
			  	  username = principal.toString();
			  	}
			  	
			    CallableStatement cs=connection.prepareCall("{call DBMS_SESSION.SET_IDENTIFIER('"+username+"')}");
			    cs.execute();
			    cs.close();
		 	}
		 	
		    return connection;
		}
}

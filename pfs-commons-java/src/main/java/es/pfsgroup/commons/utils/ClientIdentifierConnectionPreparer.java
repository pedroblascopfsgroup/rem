package es.pfsgroup.commons.utils;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

@Component
@Aspect
public class ClientIdentifierConnectionPreparer {
	 
	 @AfterReturning(pointcut= "execution(* *.getConnection(..))", returning = "connection")
		public Connection setClientIdentifier(Connection connection) throws SQLException {
		    CallableStatement cs=connection.prepareCall("{call DBMS_SESSION.SET_IDENTIFIER('XXXX')}");
		    cs.execute();
		    cs.close();
		    return connection;
		}
}

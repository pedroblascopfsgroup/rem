package es.pfs.bankia.security;

import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Enumeration;
import java.util.Iterator;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.cm.arq.sd.seguridad.SSAException;
import es.cm.krb.filter.SecurityFilter;

public class BankiaSecurityFilter extends SecurityFilter {

	private static final String UNICODE_FORMAT = "UTF8";
	private final Log logger = LogFactory.getLog(getClass());

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) {
		
		Base64 base = new Base64();
		
		try {
			HttpServletRequest req = (HttpServletRequest)request;
			String authHeader = req.getHeader("authorization");
			String encodedValue = authHeader.split(" ")[1];
			System.out.println("Base64-encoded Authorization Value: " + encodedValue);
			System.out.println("----------------------------------------------------");
			byte[] decodedValue = base.decode(encodedValue.getBytes(UNICODE_FORMAT));
			System.out.println("Base64-decoded Authorization Value: " + bytes2String(decodedValue));
			
			super.doFilter(request, response, chain);
			
//			if(session == null && !(uri.endsWith("html") || uri.endsWith("LoginServlet"))){
//	            this.context.log("Unauthorized access request");
//	            res.sendRedirect("login.html");
//	        }else{
//	            // pass the request along the filter chain
//	            chain.doFilter(request, response);
//	        }
			
		} catch (IOException e) {
			registrarLoginErroneo((HttpServletRequest)request);
			logger.error(e.getMessage());
		} catch (ServletException e) {
			registrarLoginErroneo((HttpServletRequest)request);
			logger.error(e.getMessage());
		} catch (Exception e) {
			registrarLoginErroneo((HttpServletRequest)request);
			logger.error(e.getMessage());
		}
		
	}
	
	private void registrarLoginErroneo(HttpServletRequest request) {
		
    	String remoteIP = request.getRemoteAddr();
    	String username = "DUMMY";
    	if (request != null && request.getUserPrincipal() != null && request.getUserPrincipal().getName() != null) {
    		username = request.getUserPrincipal().getName();
    	}
		//obtener IP del servidor
		String ipHost = "127.0.0.1";
		try {
			ipHost = InetAddress.getByName(request.getServerName()).getHostAddress();
		} catch (UnknownHostException e) {
			logger.error("checkAuthentication: error al obtener la IP del servidor.");
		} 
		logger.error("registrarLoginErroneo: " + ipHost + ", " + remoteIP + ", " + username);
		//proxyFactory.proxy(AuthenticationLogApi.class).registrarLoginError(ipHost, remoteIP, username);

	}

	private static String bytes2String(byte[] bytes) {
		StringBuffer stringBuffer = new StringBuffer();
		for (int i = 0; i < bytes.length; i++) {
			if (bytes[i] != 13 && bytes[i] != 10 ) {
				stringBuffer.append((char) bytes[i]);
			}
		}
		return stringBuffer.toString();
	}


}

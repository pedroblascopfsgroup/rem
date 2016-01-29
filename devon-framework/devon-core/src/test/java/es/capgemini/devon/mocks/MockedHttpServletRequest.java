package es.capgemini.devon.mocks;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.security.Principal;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletInputStream;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * <b>Descripcion:</b></p>
 * <p/>
 * <b>Dependencias:</b></p>
 * <p/>
 * <b>Configuracion:</b></p>
 * <p/>
 * Date: Nov 7, 2005
 * Time: 12:54:20 PM
 */
public class MockedHttpServletRequest implements HttpServletRequest, Serializable {

    /**
     *
     */
    private static final long serialVersionUID = -4400295752883462496L;

    private String characterEncoding;
    private int contentLength;
    private String contentType;
    private Hashtable attributes;
    private Hashtable parameters;
    private String protocol;
    private String serverName;
    private String scheme;
    private int port;
    private String remoteAddress;
    private String remoteHost;
    private Locale locale;
    private Hashtable locales;
    private boolean isSecure = false;
    private String authType;
    private List cookieList;
    private long dateHeader;
    private Hashtable headers;
    private String method;
    private String requestURI;
    private String url;
    private String servletPath;
    private MockedHttpSession session = null;
    private String basePath;
    private int remotePort;
    private String localName;
    private String localAddr;
    private int localPort;

    private String contextPath;

    private String pathInfo;

    private String queryString;

    public MockedHttpServletRequest() {
        characterEncoding = "UTF-8";
        attributes = new Hashtable();
        parameters = new Hashtable();
        locale = Locale.getDefault();
        locales = new Hashtable();
        cookieList = new Vector();
        headers = new Hashtable();
        dateHeader = System.currentTimeMillis();
        method = "GET";
        basePath = "/projects/mercadona/framework/application/web";
    }

    public String getCharacterEncoding() {
        return characterEncoding;
    }

    public void setCharacterEncoding(String string) throws UnsupportedEncodingException {
        this.characterEncoding = string;
    }

    public int getContentLength() {
        return contentLength; //To change body of implemented methods use File | Settings | File Templates.
    }

    public void setContentLength(int contentLength) {
        this.contentLength = contentLength;
    }

    public String getContentType() {
        return contentType; //To change body of implemented methods use File | Settings | File Templates.
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public ServletInputStream getInputStream() throws IOException {
        return null; //To change body of implemented methods use File | Settings | File Templates.
    }

    public String getParameter(String key) {
        return (String) parameters.get(key);

    }

    public void setParameter(String key, String value) {
        parameters.put(key, value);
    }

    public void removeParameter(String key) {
        parameters.remove(key);
    }

    public Enumeration getParameterNames() {
        return parameters.keys();
    }

    public String[] getParameterValues(String key) {

        String[] ret;
        String s = (String) parameters.get(key);

        if (s == null)
            ret = new String[0];
        else
            ret = new String[] { s };

        return ret;
    }

    public Map getParameterMap() {
        return parameters;
    }

    public void setParametersMap(Map parameters) {
        this.parameters.putAll(parameters);
    }

    public String getProtocol() {
        return protocol;
    }

    public void setProtocol(String protocol) {
        this.protocol = protocol;
    }

    public String getScheme() {
        return scheme; //To change body of implemented methods use File | Settings | File Templates.
    }

    public void setScheme(String scheme) {
        this.scheme = scheme;
    }

    public String getServerName() {
        return serverName;
    }

    public void setServerName(String serverName) {
        this.serverName = serverName;
    }

    public int getServerPort() {
        return port;
    }

    public void setServerPort(int port) {
        this.port = port;
    }

    public BufferedReader getReader() throws IOException {
        return null; //To change body of implemented methods use File | Settings | File Templates.
    }

    public String getRemoteAddr() {
        return remoteAddress;
    }

    public void setRemoteAddr(String address) {
        this.remoteAddress = address;
    }

    public String getRemoteHost() {
        return remoteHost;
    }

    public void setRemoteHost(String host) {
        this.remoteHost = host;
    }

    public void setAttribute(String key, Object value) {
        attributes.put(key, value);
    }

    public void removeAttribute(String key) {
        attributes.remove(key);
    }

    public Locale getLocale() {
        return locale;
    }

    public void setLocale(Locale locale) {
        this.locale = locale;
    }

    public Enumeration getLocales() {
        return locales.keys();
    }

    public void addLocale(Locale locale) {
        locales.put(locale.toString(), locale);
    }

    public boolean isSecure() {
        return isSecure; //To change body of implemented methods use File | Settings | File Templates.
    }

    public void setSecure(boolean isSecure) {
        this.isSecure = isSecure;
    }

    public RequestDispatcher getRequestDispatcher(String string) {
        return new MockedRequestDispatcher(); //To change body of implemented methods use File | Settings | File Templates.
    }

    public String getRealPath(String string) {
        return basePath + string;
    }

    public void setBasePath(String basePath) {
        this.basePath = basePath;
    }

    public String getAuthType() {
        return authType;
    }

    public void setAuthType(String authType) {
        this.authType = authType;
    }

    public Cookie[] getCookies() {
        Cookie[] list = new Cookie[cookieList.size()];
        cookieList.toArray(list);
        return list;
    }

    public void addCookie(Cookie cookie) {
        cookieList.add(cookie);
    }

    public long getDateHeader(String string) {
        return dateHeader;
    }

    public void setDateHeader(long time) {
        this.dateHeader = time;
    }

    public String getHeader(String header) {
        return (String) headers.get(header); //To change body of implemented methods use File | Settings | File Templates.
    }

    public void addHeader(String header, String value) {
        headers.put(header, value);
    }

    public Enumeration getHeaders(String header) {
        return headers.keys();
    }

    public Enumeration getHeaderNames() {
        return headers.keys();
    }

    public int getIntHeader(String string) {
        return 0; //To change body of implemented methods use File | Settings | File Templates.
    }

    public String getMethod() {
        return method; //To change body of implemented methods use File | Settings | File Templates.
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getPathInfo() {
        return this.pathInfo; //To change body of implemented methods use File | Settings | File Templates.
    }

    public String getPathTranslated() {
        return null; //To change body of implemented methods use File | Settings | File Templates.
    }

    public String getContextPath() {
        return this.contextPath; //To change body of implemented methods use File | Settings | File Templates.
    }

    public String getQueryString() {
        return this.queryString; //To change body of implemented methods use File | Settings | File Templates.
    }

    public String getRemoteUser() {
        return null; //To change body of implemented methods use File | Settings | File Templates
    }

    public boolean isUserInRole(String string) {
        return false;
    }

    public Principal getUserPrincipal() {
        return null; //To change body of implemented methods use File | Settings | File Templates.
    }

    public String getRequestedSessionId() {
        return null; //To change body of implemented methods use File | Settings | File Templates.
    }

    public String getRequestURI() {
        return requestURI; //To change body of implemented methods use File | Settings | File Templates.
    }

    public void setRequestURI(String uri) {
        this.requestURI = uri;
    }

    public StringBuffer getRequestURL() {
        return new StringBuffer(url); //To change body of implemented methods use File | Settings | File Templates.
    }

    public void setRequestURL(String url) {
        this.url = url;
    }

    public String getServletPath() {
        return servletPath; //To change body of implemented methods use File | Settings | File Templates.
    }

    public void setServletPath(String path) {
        this.servletPath = path;
    }

    public HttpSession getSession(boolean b) {

        if (b) {
            session = new MockedHttpSession();
            session.setRequest(this);
        }

        return session;

    }

    public HttpSession getSession() {

        if (session == null) {
            session = new MockedHttpSession();
            session.setRequest(this);
        }

        return session;
    }

    public void invalidateSession() {
        session = null;
    }

    public boolean isRequestedSessionIdValid() {
        return false; //To change body of implemented methods use File | Settings | File Templates.
    }

    public boolean isRequestedSessionIdFromCookie() {
        return false; //To change body of implemented methods use File | Settings | File Templates.
    }

    public boolean isRequestedSessionIdFromURL() {
        return false; //To change body of implemented methods use File | Settings | File Templates.
    }

    public boolean isRequestedSessionIdFromUrl() {
        return false; //To change body of implemented methods use File | Settings | File Templates.
    }

    public Object getAttribute(String attribute) {
        return attributes.get(attribute); //To change body of implemented methods use File | Settings | File Templates.
    }

    public Enumeration getAttributeNames() {
        return attributes.keys();
    }

    public void setRemotePort(int port) {
        this.remotePort = port;
    }

    public int getRemotePort() {
        return this.remotePort;
    }

    public void setLocalName(String localName) {
        this.localName = localName;
    }

    public String getLocalName() {
        return this.localName;
    }

    public void setLocalAddr(String localAddr) {
        this.localAddr = localAddr;
    }

    public String getLocalAddr() {
        return localAddr;
    }

    public void setLocalPort(int port) {
        this.localPort = port;
    }

    public int getLocalPort() {
        return localPort;
    }

    public void setContextPath(String contextPath) {
        this.contextPath = contextPath;
    }

    public void setPathInfo(String pathInfo) {
        this.pathInfo = pathInfo;
    }

    public void setQueryString(String queryString) {
        this.queryString = queryString;
    }

}

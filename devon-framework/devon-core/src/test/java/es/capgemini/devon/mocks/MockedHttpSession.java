package es.capgemini.devon.mocks;

import java.io.Serializable;
import java.lang.reflect.Method;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionContext;

import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.MethodProxy;

/**
 * <b>Descripcion:</b></p>
 * <p/>
 * <b>Dependencias:</b></p>
 * <p/>
 * <b>Configuracion:</b></p>
 * <p/>
 * Date: Nov 3, 2005
 * Time: 4:50:25 PM
 */
public class MockedHttpSession implements MethodInterceptor, HttpSession, Serializable {

    /**
     * 
     */
    private static final long serialVersionUID = -5423621382464040756L;

    private Hashtable sessionData = null;
    private long lastAccessedTime;
    private int inactiveInterval;
    private String id;
    private HttpServletRequest request;

    public MockedHttpSession() {
        sessionData = new Hashtable();
        lastAccessedTime = System.currentTimeMillis();
        inactiveInterval = 300;
        id = "kk";

    }

    public void setRequest(HttpServletRequest request) {
        this.request = request;
    }

    public Object intercept(Object obj, Method method, Object[] args, MethodProxy proxy) throws Throwable {

        Class[] types = new Class[args.length];

        for (int i = 0; i < args.length; i++)
            types[i] = args[i].getClass();

        Method m = null;
        Object ret = null;

        try {
            this.getClass().getMethod(method.getName(), types);
            ret = m.invoke(this, args);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return ret;
    }

    public long getCreationTime() {
        return 0; //To change body of implemented methods use File | Settings | File Templates.
    }

    public String getId() {
        lastAccessedTime = System.currentTimeMillis();
        return id; //To change body of implemented methods use File | Settings | File Templates.
    }

    public void setId(String id) {
        this.id = id;
    }

    public long getLastAccessedTime() {
        return lastAccessedTime; //To change body of implemented methods use File | Settings | File Templates.
    }

    public ServletContext getServletContext() {
        lastAccessedTime = System.currentTimeMillis();
        return null; //To change body of implemented methods use File | Settings | File Templates.
    }

    public void setMaxInactiveInterval(int i) {
        this.inactiveInterval = i;
        //To change body of implemented methods use File | Settings | File Templates.
    }

    public int getMaxInactiveInterval() {
        return inactiveInterval;
    }

    public HttpSessionContext getSessionContext() {
        return null; //To change body of implemented methods use File | Settings | File Templates.
    }

    public Object getAttribute(String key) {
        lastAccessedTime = System.currentTimeMillis();
        return sessionData.get(key);
    }

    public Object getValue(String key) {
        lastAccessedTime = System.currentTimeMillis();
        return getAttribute(key);
    }

    public Enumeration getAttributeNames() {
        lastAccessedTime = System.currentTimeMillis();
        return (sessionData).keys();
    }

    public String[] getValueNames() {

        lastAccessedTime = System.currentTimeMillis();

        String[] array = new String[sessionData.size()];

        int i = 0;

        for (Iterator it = sessionData.keySet().iterator(); it.hasNext();) {
            array[i++] = (String) it.next();
        }

        return array;

    }

    public void setAttribute(String key, Object value) {
        lastAccessedTime = System.currentTimeMillis();
        if (key != null && value != null)
            sessionData.put(key, value);
    }

    public void putValue(String key, Object value) {
        lastAccessedTime = System.currentTimeMillis();
        setAttribute(key, value);
    }

    public void removeAttribute(String key) {
        lastAccessedTime = System.currentTimeMillis();
        sessionData.remove(key);
    }

    public void removeValue(String key) {
        lastAccessedTime = System.currentTimeMillis();
        removeAttribute(key);
    }

    public void invalidate() {
        lastAccessedTime = System.currentTimeMillis();
        if (request != null && request instanceof MockedHttpServletRequest) {
            MockedHttpServletRequest req = (MockedHttpServletRequest) request;
            req.invalidateSession();
        }
        sessionData = new Hashtable();
    }

    public boolean isNew() {
        lastAccessedTime = System.currentTimeMillis();
        return false; //To change body of implemented methods use File | Settings | File Templates.
    }

}

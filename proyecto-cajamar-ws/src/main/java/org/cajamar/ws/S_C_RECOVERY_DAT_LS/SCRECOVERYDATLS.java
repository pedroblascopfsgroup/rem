
package org.cajamar.ws.S_C_RECOVERY_DAT_LS;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.logging.Logger;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import javax.xml.ws.WebEndpoint;
import javax.xml.ws.WebServiceClient;
import javax.xml.ws.WebServiceFeature;


/**
 * This class was generated by the JAX-WS RI.
 * JAX-WS RI 2.1.6 in JDK 6
 * Generated source version: 2.1
 * 
 */
@WebServiceClient(name = "S_C_RECOVERY_DAT_LS", targetNamespace = "http://cajamar.org/webservice", wsdlLocation = "https://multidesa.larural.es:515/RECOVERY/services/S_C_RECOVERY_DAT_LS?wsdl")
public class SCRECOVERYDATLS
    extends Service
{

    private final static URL SCRECOVERYDATLS_WSDL_LOCATION;
    private final static Logger logger = Logger.getLogger(org.cajamar.ws.S_C_RECOVERY_DAT_LS.SCRECOVERYDATLS.class.getName());

    static {
        URL url = null;
        try {
            URL baseUrl;
            baseUrl = org.cajamar.ws.S_C_RECOVERY_DAT_LS.SCRECOVERYDATLS.class.getResource(".");
            url = new URL(baseUrl, "https://multidesa.larural.es:515/RECOVERY/services/S_C_RECOVERY_DAT_LS?wsdl");
        } catch (MalformedURLException e) {
            logger.warning("Failed to create URL for the wsdl Location: 'https://multidesa.larural.es:515/RECOVERY/services/S_C_RECOVERY_DAT_LS?wsdl', retrying as a local file");
            logger.warning(e.getMessage());
        }
        SCRECOVERYDATLS_WSDL_LOCATION = url;
    }

    public SCRECOVERYDATLS(URL wsdlLocation, QName serviceName) {
        super(wsdlLocation, serviceName);
    }

    public SCRECOVERYDATLS() {
        super(SCRECOVERYDATLS_WSDL_LOCATION, new QName("http://cajamar.org/webservice", "S_C_RECOVERY_DAT_LS"));
    }

    /**
     * 
     * @return
     *     returns SCRECOVERYDATLSType
     */
    @WebEndpoint(name = "S_C_RECOVERY_DAT_LSPort")
    public SCRECOVERYDATLSType getSCRECOVERYDATLSPort() {
        return super.getPort(new QName("http://cajamar.org/webservice", "S_C_RECOVERY_DAT_LSPort"), SCRECOVERYDATLSType.class);
    }

    /**
     * 
     * @param features
     *     A list of {@link javax.xml.ws.WebServiceFeature} to configure on the proxy.  Supported features not in the <code>features</code> parameter will have their default values.
     * @return
     *     returns SCRECOVERYDATLSType
     */
    @WebEndpoint(name = "S_C_RECOVERY_DAT_LSPort")
    public SCRECOVERYDATLSType getSCRECOVERYDATLSPort(WebServiceFeature... features) {
        return super.getPort(new QName("http://cajamar.org/webservice", "S_C_RECOVERY_DAT_LSPort"), SCRECOVERYDATLSType.class, features);
    }

}

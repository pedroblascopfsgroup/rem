package es.pfsgroup.gestordocumental.webservice;

import java.net.MalformedURLException;
import java.net.URL;
import javax.xml.namespace.QName;
import javax.xml.ws.WebEndpoint;
import javax.xml.ws.WebServiceClient;
import javax.xml.ws.Service;

@WebServiceClient(name = "S_M_GESTIONDOCUMENTAL", 
                  wsdlLocation = "https://multidesa.larural.es:515/RECOVERY/services/S_M_GESTIONDOCUMENTAL",
                  targetNamespace = "http://cajamar.org/webservice") 
public class SMGESTIONDOCUMENTAL extends Service {

    public final static URL WSDL_LOCATION;

    public final static QName SERVICE = new QName("http://cajamar.org/webservice", "S_M_GESTIONDOCUMENTAL");
    public final static QName SMGESTIONDOCUMENTALPort = new QName("http://cajamar.org/webservice", "S_M_GESTIONDOCUMENTALPort");
    static {
        URL url = null;
        String urlString = "https://multidesa.larural.es:515/RECOVERY/services/S_M_GESTIONDOCUMENTAL";
        try {
            url = new URL(urlString);
        } catch (MalformedURLException e) {
            java.util.logging.Logger.getLogger(SMGESTIONDOCUMENTAL.class.getName())
                .log(java.util.logging.Level.INFO, 
                     "Can not initialize the default wsdl from {0}", urlString);
        }
        WSDL_LOCATION = url;
    }

    public SMGESTIONDOCUMENTAL(URL wsdlLocation) {
        super(wsdlLocation, SERVICE);
    }

    public SMGESTIONDOCUMENTAL() {
        super(WSDL_LOCATION, SERVICE);
    }
    
    /**
     *
     * @return
     *     returns SMGESTIONDOCUMENTALType
     */
    @WebEndpoint(name = "S_M_GESTIONDOCUMENTALPort")
    public SMGESTIONDOCUMENTALType getSMGESTIONDOCUMENTALPort() {
        return super.getPort(SMGESTIONDOCUMENTALPort, SMGESTIONDOCUMENTALType.class);
    }
}

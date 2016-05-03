
package es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_INTEGRACION;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_INTEGRACION package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _ProcessEventResponse_QNAME = new QName("http://alamo.haya.es/IntegracionSOA/schemas", "processEventResponse");
    private final static QName _ProcessEventRequest_QNAME = new QName("http://alamo.haya.es/IntegracionSOA/schemas", "processEventRequest");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: es.pfsgroup.plugin.gestorDocumental.ws.MAESTRO_INTEGRACION
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link ProcessEventResponseType }
     * 
     */
    public ProcessEventResponseType createProcessEventResponseType() {
        return new ProcessEventResponseType();
    }

    /**
     * Create an instance of {@link ProcessEventRequestType }
     * 
     */
    public ProcessEventRequestType createProcessEventRequestType() {
        return new ProcessEventRequestType();
    }

    /**
     * Create an instance of {@link KeyValuePair }
     * 
     */
    public KeyValuePair createKeyValuePair() {
        return new KeyValuePair();
    }

    /**
     * Create an instance of {@link ProcessEventResponseType.Parameters }
     * 
     */
    public ProcessEventResponseType.Parameters createProcessEventResponseTypeParameters() {
        return new ProcessEventResponseType.Parameters();
    }

    /**
     * Create an instance of {@link ProcessEventRequestType.Parameters }
     * 
     */
    public ProcessEventRequestType.Parameters createProcessEventRequestTypeParameters() {
        return new ProcessEventRequestType.Parameters();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link ProcessEventResponseType }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://alamo.haya.es/IntegracionSOA/schemas", name = "processEventResponse")
    public JAXBElement<ProcessEventResponseType> createProcessEventResponse(ProcessEventResponseType value) {
        return new JAXBElement<ProcessEventResponseType>(_ProcessEventResponse_QNAME, ProcessEventResponseType.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link ProcessEventRequestType }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://alamo.haya.es/IntegracionSOA/schemas", name = "processEventRequest")
    public JAXBElement<ProcessEventRequestType> createProcessEventRequest(ProcessEventRequestType value) {
        return new JAXBElement<ProcessEventRequestType>(_ProcessEventRequest_QNAME, ProcessEventRequestType.class, null, value);
    }

}

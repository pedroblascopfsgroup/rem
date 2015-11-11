package es.pfsgroup.gestorDocumental.webservice;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;

@WebService(targetNamespace = "http://cajamar.org/webservice", name = "S_M_GESTIONDOCUMENTALType")
@SOAPBinding(parameterStyle = SOAPBinding.ParameterStyle.BARE)
public interface SMGESTIONDOCUMENTALType {

    @WebResult(name = "OUTPUT", targetNamespace = "http://cajamar.org/webservice", partName = "parameters")
    @WebMethod(operationName = "S_M_GESTIONDOCUMENTAL")
    public OUTPUT sMGESTIONDOCUMENTAL(
        @WebParam(partName = "parameters", name = "INPUT", targetNamespace = "http://cajamar.org/webservice")
        INPUT parameters
    );
}

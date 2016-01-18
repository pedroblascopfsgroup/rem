package es.capgemini.devon.webflow.bo;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.webflow.execution.RequestContext;

import es.capgemini.devon.bo.DefaultExecutor;
import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.devon.webflow.RequestBinder;

public class WebExecutor extends DefaultExecutor {

    private final Log logger = LogFactory.getLog(getClass());

    @Resource
    RequestBinder binder;

    public RequestBinder getBinder() {
        return binder;
    }

    public void setBinder(RequestBinder binder) {
        this.binder = binder;
    }

    /**
     * <p>
     * Este método ejecuta el binding y la validación del dto que se pasa al
     * bean para ejecutarse desde los parámetros de la request.
     * </p>
     * 
     * <p>
     * El método que se ejecutará en la validación será:
     * </p>
     * 
     * <pre>
     * validateSTATE
     * </pre>
     * <p>
     * Donde STATE es el nombre del estado en el que se ejecuta el binding. De
     * esta forma, podemos llamar a distintos métodos de validación en cada flow
     * reutiliando el mismo dto
     * </p>
     * 
     * @param id
     * @param arg
     * @param requestContext
     * @return
     * @throws FrameworkException
     */
    public Object execute(String id, Object[] args) throws FrameworkException {
        // hacemos el bind y luego ejecutamos
        if (args != null && args.length > 0 && args[0] instanceof RequestContext) {
            RequestContext requestContext = (RequestContext) args[0];

            try {
                binder.bindAndValidate(requestContext, args[1]);
            } catch (Throwable e) {
                // TODO Auto-generated catch block
                throw new FrameworkException(e);
            }
            Object[] methodArgs = new Object[args.length - 1];
            System.arraycopy(args, 1, methodArgs, 0, args.length - 1);
            return super.internalExecute(id, methodArgs);
        } else {
            return super.internalExecute(id, args);
        }
    }
}

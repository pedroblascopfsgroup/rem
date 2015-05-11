package es.pfsgroup.commons.utils.web.dto.factory;

import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.commons.utils.web.dto.extensible.ExtensibleDto;

@Component
public final class DTOFactory {

    @Resource
    private Properties appProperties;

    /**
     * Crea un DTO relleno con datos que vienen del REQUEST. Este método es
     * capaz de devolver un objeto de la subclase especificada en
     * devon.properties.
     * <p>
     * Para definir una subclase en el devon.properties hay que configurar la
     * siguiente propiedad <code>request_name.<b>dto</b></code>, dónde
     * <code>request_name</code> es el {@link RequestMapping} (método del
     * controller) en el que se quiere usar el DTO.
     * </p>
     * 
     * 
     * @param requestMappingName
     *            Nombre del {@link RequestMapping} en el que se quiere usar el
     *            DTO.
     * @param request
     *            Request recibido por el {@link Controller}
     * @param defaultClass
     *            Tipo del DTO por defecto.
     * 
     * @return Si se ha definido una subclase en el devon.properties se devuelve
     *         un objeto de ese tipo. En caso contrario se devuelve un DTO del
     *         tipo por defecto. El DTO estará relleno con los datos del
     *         REQUEST.
     * 
     * @throws ClassNotFoundException
     *             Si la subclase no existe.
     */
    @SuppressWarnings("unchecked")
    public <T> T creaYRellenaDTO(final String requestMappingName, final WebRequest request, final Class<? extends T> defaultClass) throws ClassNotFoundException {
        final String subClassName = appProperties.getProperty(requestMappingName + ".dto");

        final T dto =  buildDto(request, defaultClass, subClassName);
        
        final String params = extractDynamicParameters(request);
        
        if (!Checks.esNulo(params) && (dto instanceof ExtensibleDto)){
            putParametersIntoExtensibleDTO(params, dto);
        }
        
        return dto;
    }

    private <T> void  putParametersIntoExtensibleDTO(final String params, final T dto) {
        ExtensibleDto ext = (ExtensibleDto) dto;
        ext.setDynamicParams(params);
    }

    private String extractDynamicParameters(final WebRequest request) {
        if (!Checks.esNulo(request) && !Checks.estaVacio(request.getParameterMap())){
            String[] params = (String[]) request.getParameterMap().get("params");
            if ((params != null) && (params.length > 0)){
                return params[0];
            }
        }
        
        return null; //else
    }

    private <T> T buildDto(final WebRequest request, final Class<? extends T> defaultClass, final String subClassName) throws ClassNotFoundException {
        if (!Checks.esNulo(subClassName)) {
            final Class<? extends T> subclass = (Class<? extends T>) Class.forName(subClassName);
            return DynamicDtoUtils.create(subclass, request);
        } else {
            return DynamicDtoUtils.create(defaultClass, request);
        }
    }

}

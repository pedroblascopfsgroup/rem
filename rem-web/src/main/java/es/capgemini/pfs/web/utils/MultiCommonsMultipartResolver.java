package es.capgemini.pfs.web.utils;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.apache.commons.fileupload.FileItem;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartException;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

public class MultiCommonsMultipartResolver extends CommonsMultipartResolver {

    public MultiCommonsMultipartResolver() {
    }

    public MultiCommonsMultipartResolver(ServletContext servletContext) {
        super(servletContext);
    }

    @Override
    @SuppressWarnings({ "unchecked", "rawtypes" })
    protected MultipartParsingResult parseFileItems(List fileItems, String encoding) {
        Map multipartFiles = new HashMap();
        Map multipartParameters = new HashMap();

        // Extrae los archivos multipart y sus parametros.
        for (Iterator it = fileItems.iterator(); it.hasNext();) {
            FileItem fileItem = (FileItem) it.next();
            if (fileItem.isFormField()) {
                String value = null;
                if (encoding != null) {
                    try {
                        value = fileItem.getString(encoding);
                    } catch (UnsupportedEncodingException ex) {
                        if (logger.isWarnEnabled()) {
                            logger.warn("No se puedo decodificar el elemento multipart '" + fileItem.getFieldName()
                                    + "' con codificacion '" + encoding + "'");
                        }
                        value = fileItem.getString();
                    }
                } else {
                    value = fileItem.getString();
                }
                String[] curParam = (String[]) multipartParameters.get(fileItem.getFieldName());
                if (curParam == null) {
                    // Simple form field
                    multipartParameters.put(fileItem.getFieldName(), new String[] { value });
                } else {
                    // Array of simple form fields
                    String[] newParam = StringUtils.addStringToArray(curParam, value);
                    multipartParameters.put(fileItem.getFieldName(), newParam);
                }
            } else {
                // Multipart file field
                CommonsMultipartFile file = new CommonsMultipartFile(fileItem);
                if (multipartFiles.put(fileItem.getName(), file) != null) {
                    throw new MultipartException("Varios archivos con el nombre [" + file.getName()
                            + "] encontrados - no soportado por MultipartResolver");
                }
                if (logger.isDebugEnabled()) {
                    logger.debug("Encontrado archivo multipart [" + file.getName() + "] de tamaño " + file.getSize()
                            + " bytes con el nombre original del archivo [" + file.getOriginalFilename() + "], almacenado "
                            + file.getStorageDescription());
                }
            }
        }
        return new MultipartParsingResult(multipartFiles, multipartParameters);
    }

}
package es.capgemini.devon.files;

import java.util.HashMap;
import java.util.Map;

/** Esta clase encapsula el formulario de subida de ficheros, tanto el fileItem como el resto de campos enviados
 * @author amarinso
 *
 */
public class WebFileItem {

    private FileItem fileItem;
    private Map<String, String> parameters = new HashMap<String, String>();

    public void setFileItem(FileItem fileItem) {
        this.fileItem = fileItem;
    }

    public FileItem getFileItem() {
        return fileItem;
    }

    public void setParameters(Map<String, String> parameters) {
        this.parameters = parameters;
    }

    public Map<String, String> getParameters() {
        return parameters;
    }

    public String getParameter(String key) {
        return parameters.get(key);
    }

    public void putParameter(String key, String value) {
        parameters.put(key, value);
    }

}

package es.capgemini.pfs.upload.dto;

import java.io.Serializable;


/**
 * DTO para validar uploads de archivos, ver ejemplos donde se usa este objeto en sesión.
 * @author marruiz
 */
public class DtoFileUpload implements Serializable {

    private static final long serialVersionUID = 1L;

    private boolean valido;
    private long size;

    /**
     * Constructor por defecto, con campos: <code>valido=true, size=0</code>.
     */
    public DtoFileUpload() {
        super();
        valido = true;
        size = 0L;
    }

    /**
     * @return boolean: <code>true</code> si el archivo fue validado correctamente.
     */
    public boolean isValido() {
        return valido;
    }
    /**
     * @param valido boolean: <code>true</code> si el archivo fue validado correctamente.
     */
    public void setValido(boolean valido) {
        this.valido = valido;
    }
    /**
     * @return size long: tamaño en bytes.
     */
    public long getSize() {
        return size;
    }
    /**
     * @param size long: tamaño en bytes.
     */
    public void setSize(long size) {
        this.size = size;
    }
}

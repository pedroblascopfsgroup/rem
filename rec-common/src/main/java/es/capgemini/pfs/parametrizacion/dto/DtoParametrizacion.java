package es.capgemini.pfs.parametrizacion.dto;

import java.io.Serializable;

import es.capgemini.pfs.parametrizacion.model.Parametrizacion;

/**
 * DTO para editar el número de intervalos en las métricas.
 * @author marruiz
 */
public class DtoParametrizacion implements Serializable {

    private static final long serialVersionUID = 8788612518757104587L;


    private Parametrizacion parametrizacion;


    /**
     * @return the parametrizacion
     */
    public Parametrizacion getParametrizacion() {
        return parametrizacion;
    }

    /**
     * @param parametrizacion the parametrizacion to set
     */
    public void setParametrizacion(Parametrizacion parametrizacion) {
        this.parametrizacion = parametrizacion;
    }
}

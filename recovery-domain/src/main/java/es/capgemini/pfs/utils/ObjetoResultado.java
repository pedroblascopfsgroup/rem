package es.capgemini.pfs.utils;

import java.io.Serializable;

/**
 * TODO FO.
 */
public class ObjetoResultado implements Serializable {
    private static final long serialVersionUID = 1L;
    public static final Long RESULTADO_OK = 1L;
    public static final Long RESULTADO_ERROR = 0L;

    private Long codigoResultado;
    private String mensajeError;
    private Long resultados;

    /**
     * @return the codigoResultado
     */
    public Long getCodigoResultado() {
        return codigoResultado;
    }

    /**
     * @param codigoResultado the codigoResultado to set
     */
    public void setCodigoResultado(Long codigoResultado) {
        this.codigoResultado = codigoResultado;
    }

    /**
     * @return the mensajeError
     */
    public String getMensajeError() {
        return mensajeError;
    }

    /**
     * @param mensajeError the mensajeError to set
     */
    public void setMensajeError(String mensajeError) {
        this.mensajeError = mensajeError;
    }

    /**
     * @return the resultados
     */
    public Long getResultados() {
        return resultados;
    }

    /**
     * @param resultados the resultados to set
     */
    public void setResultados(Long resultados) {
        this.resultados = resultados;
    }

}

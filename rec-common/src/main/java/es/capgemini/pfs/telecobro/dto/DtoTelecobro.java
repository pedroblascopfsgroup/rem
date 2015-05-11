package es.capgemini.pfs.telecobro.dto;

import org.hibernate.validator.constraints.Length;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para todos lo relacionado con telecobro.
 * @author aesteban
 *
 */
public class DtoTelecobro extends WebDto {

    /**
     * serial.
     */
    private static final long serialVersionUID = -6637784816506547314L;

    private Long idCliente;
    private String idMotivo;

    @Length(message = "telecobro.observaciones.errorLimite", max = 500)
    private String observacion;
    private String respuesta;

    /**
     * @return the idCliente
     */
    public Long getIdCliente() {
        return idCliente;
    }

    /**
     * @param idCliente the idCliente to set
     */
    public void setIdCliente(Long idCliente) {
        this.idCliente = idCliente;
    }

    /**
     * @return the codigoMotivo
     */
    public String getIdMotivo() {
        return idMotivo;
    }

    /**
     * @param codigoMotivo the codigoMotivo to set
     */
    public void setIdMotivo(String codigoMotivo) {
        this.idMotivo = codigoMotivo;
    }

    /**
     * @return the observacion
     */
    public String getObservacion() {
        return observacion;
    }

    /**
     * @param observacion the observacion to set
     */
    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    /**
     * @return the respuesta
     */
    public String getRespuesta() {
        return respuesta;
    }

    /**
     * @param respuesta the respuesta to set
     */
    public void setRespuesta(String respuesta) {
        this.respuesta = respuesta;
    }

}

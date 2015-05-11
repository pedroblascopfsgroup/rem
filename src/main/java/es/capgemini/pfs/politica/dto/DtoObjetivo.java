package es.capgemini.pfs.politica.dto;

import java.util.Date;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.utils.FormatUtils;

/**
 * @author Andrés Esteban
 *
 */
public class DtoObjetivo extends WebDto {

    private static final long serialVersionUID = 3938403785038348026L;

    private Long idObjetivo;
    private Long idPolitica;
    private String tipoObjetivo;
    private String tipoOperador;
    private Long contrato;
    private String observacion;
    private String resumen;
    private String propuesta;
    private String respuesta;
    private String fechaLimite;
    private Float valor;
    private Boolean isJustificacion = false;
    private String justificacion;

    /**
     * Valida los parámetros.
     * @param context el contexto.
     */
    public void validateFormulario(MessageContext context) {
        context.clearMessages();
        if (tipoObjetivo == null || tipoObjetivo.equals("")) {
            context.addMessage(new MessageBuilder().code("editar.objetivo.error.tipoObjetivoNulo").error().defaultText(
                    "**Debe seleccionar el tipo de objetivo.").build());
        }
        if (fechaLimite == null || fechaLimite.equals("")) {
            context.addMessage(new MessageBuilder().code("editar.objetivo.error.fechaLimiteNula").error().defaultText(
                    "**Debe cargar una fecha límite.").build());
        } else {
            Date fecha = FormatUtils.strADate(fechaLimite, FormatUtils.DDMMYYYY);
            if (!(fecha.compareTo(FormatUtils.fechaSinHora(new Date())) == 1)) {
                context.addMessage(new MessageBuilder().code("editar.objetivo.error.fechaLimiteMenor").error().defaultText(
                        "**Debe cargar una fecha superior a la del día de hoy.").build());
            }
        }
        if (context.getAllMessages().length > 0) { throw new ValidationException(ErrorMessageUtils.convertMessages(context.getAllMessages())); }
    }

    /**
     * @return the idObjetivo
     */
    public Long getIdObjetivo() {
        return idObjetivo;
    }

    /**
     * @param idObjetivo the idObjetivo to set
     */
    public void setIdObjetivo(Long idObjetivo) {
        this.idObjetivo = idObjetivo;
    }

    /**
     * @return the tipoObjetivo
     */
    public String getTipoObjetivo() {
        return tipoObjetivo;
    }

    /**
     * @param tipoObjetivo the tipoObjetivo to set
     */
    public void setTipoObjetivo(String tipoObjetivo) {
        this.tipoObjetivo = tipoObjetivo;
    }

    /**
     * @return the tipoOperador
     */
    public String getTipoOperador() {
        return tipoOperador;
    }

    /**
     * @param tipoOperador the tipoOperador to set
     */
    public void setTipoOperador(String tipoOperador) {
        this.tipoOperador = tipoOperador;
    }

    /**
     * @return the contrato
     */
    public Long getContrato() {
        return contrato;
    }

    /**
     * @param contrato the contrato to set
     */
    public void setContrato(Long contrato) {
        this.contrato = contrato;
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
     * @return the resumen
     */
    public String getResumen() {
        return resumen;
    }

    /**
     * @param resumen the resumen to set
     */
    public void setResumen(String resumen) {
        this.resumen = resumen;
    }

    /**
     * @return the fechaLimite
     */
    public String getFechaLimite() {
        return fechaLimite;
    }

    /**
     * @param fechaLimite the fechaLimite to set
     */
    public void setFechaLimite(String fechaLimite) {
        this.fechaLimite = fechaLimite;
    }

    /**
     * @return the valor
     */
    public Float getValor() {
        return valor;
    }

    /**
     * @param valor the valor to set
     */
    public void setValor(Float valor) {
        this.valor = valor;
    }

    /**
     * @param idPolitica the idPolitica to set
     */
    public void setIdPolitica(Long idPolitica) {
        this.idPolitica = idPolitica;
    }

    /**
     * @return the idPolitica
     */
    public Long getIdPolitica() {
        return idPolitica;
    }

    /**
     * @return the propuesta
     */
    public String getPropuesta() {
        return propuesta;
    }

    /**
     * @param propuesta the propuesta to set
     */
    public void setPropuesta(String propuesta) {
        this.propuesta = propuesta;
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

    /**
     * @param isJustificacion the isJustificacion to set
     */
    public void setIsJustificacion(Boolean isJustificacion) {
        this.isJustificacion = isJustificacion;
    }

    /**
     * @return the isJustificacion
     */
    public Boolean getIsJustificacion() {
        return isJustificacion;
    }

    /**
     * @param justificacion the justificacion to set
     */
    public void setJustificacion(String justificacion) {
        this.justificacion = justificacion;
    }

    /**
     * @return the justificacion
     */
    public String getJustificacion() {
        return justificacion;
    }
}

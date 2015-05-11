package es.capgemini.pfs.tareaNotificacion.dto;

import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;

/**
 * dto para generar una tarea.
 * @author jbosnjak
 *
 */
public class DtoGenerarTarea extends WebDto implements Serializable {

    private static final long serialVersionUID = -2221165645685153233L;
    private String codigoTipoEntidad;
    private Long idEntidad;
    private String descripcion;
    private String reqRes;
    private Date fecha;
    private String subtipoTarea;
    private Long idTareaAsociada;
    private String descripcionTareaAsociada;
    private boolean enEspera;
    private boolean esAlerta;
    private Long plazo;

    /**
     * Constructor vacio.
     */
    public DtoGenerarTarea() {
        super();
    }

    /**
     * Constructor.
     * @param idEntidad long
     * @param codigoTipoEntidad string
     * @param codigoSubtipoTarea string
     * @param enEspera boolean
     * @param esAlerta boolean
     * @param plazo long
     * @param descripcion string
     */
    public DtoGenerarTarea(Long idEntidad, String codigoTipoEntidad, String codigoSubtipoTarea, boolean enEspera, boolean esAlerta, Long plazo,
            String descripcion) {
        setIdEntidad(idEntidad);
        setCodigoTipoEntidad(codigoTipoEntidad);
        setSubtipoTarea(codigoSubtipoTarea);
        setEnEspera(enEspera);
        setEsAlerta(esAlerta);
        setPlazo(plazo);
        setDescripcion(descripcion);
    }

    /**
     * @param messageContext MessageContext
     */
    public void validateFormulario(MessageContext messageContext) {
        messageContext.clearMessages();
        if (descripcion == null || descripcion.trim().equals("")) {
            messageContext.addMessage(new MessageBuilder().code("generartarea.descripcion.error").error().source("").defaultText(
                    "**Debe añadir un texto en la comunicación.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }
        SimpleDateFormat sd = new SimpleDateFormat("dd/MM/yyyy");
        Date d = null;
        try {
            d = sd.parse(sd.format(new Date()));
        } catch (ParseException e) {
            throw new BusinessOperationException("**Error al formatear la fecha del sistema.");
        }
        if (reqRes != null && reqRes.equals("on") && (fecha == null || fecha.compareTo(d) < 0)) {
            messageContext.addMessage(new MessageBuilder().code("generartarea.fecha.error").error().source("").defaultText(
                    "**Debe ingresar una fecha mayor o igual a la fecha actual.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }
        addValidation(descripcion, messageContext, "descripcion").addValidation(this, messageContext).validate();
    }

    /**
     * @return the codigoTipoEntidad
     */
    public String getCodigoTipoEntidad() {
        return codigoTipoEntidad;
    }

    /**
     * @param codigoTipoEntidad the codigoTipoEntidad to set
     */
    public void setCodigoTipoEntidad(String codigoTipoEntidad) {
        this.codigoTipoEntidad = codigoTipoEntidad;
    }

    /**
     * @return the idEntidad
     */
    public Long getIdEntidad() {
        return idEntidad;
    }

    /**
     * @param idEntidad the idEntidad to set
     */
    public void setIdEntidad(Long idEntidad) {
        this.idEntidad = idEntidad;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the fecha
     */
    public Date getFecha() {
        return fecha;
    }

    /**
     * @param fecha the fecha to set
     */
    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    /**
     * @return the subtipoTarea
     */
    public String getSubtipoTarea() {
        return subtipoTarea;
    }

    /**
     * @param subtipoTarea the subtipoTarea to set
     */
    public void setSubtipoTarea(String subtipoTarea) {
        this.subtipoTarea = subtipoTarea;
    }

    /**
     * @return the idTareaAsociada
     */
    public Long getIdTareaAsociada() {
        return idTareaAsociada;
    }

    /**
     * @param idTareaAsociada the idTareaAsociada to set
     */
    public void setIdTareaAsociada(Long idTareaAsociada) {
        this.idTareaAsociada = idTareaAsociada;
    }

    /**
     * @return the descripcionTareaAsociada
     */
    public String getDescripcionTareaAsociada() {
        return descripcionTareaAsociada;
    }

    /**
     * @param descripcionTareaAsociada the descripcionTareaAsociada to set
     */
    public void setDescripcionTareaAsociada(String descripcionTareaAsociada) {
        this.descripcionTareaAsociada = descripcionTareaAsociada;
    }

    /**
     * @return the reqRes
     */
    public String getReqRes() {
        return reqRes;
    }

    /**
     * @param reqRes the reqRes to set
     */
    public void setReqRes(String reqRes) {
        this.reqRes = reqRes;
    }

    /**
     * @return the enEspera
     */
    public boolean isEnEspera() {
        return enEspera;
    }

    /**
     * @param enEspera the enEspera to set
     */
    public void setEnEspera(boolean enEspera) {
        this.enEspera = enEspera;
    }

    /**
     * @return the esAlerta
     */
    public boolean isEsAlerta() {
        return esAlerta;
    }

    /**
     * @param esAlerta the esAlerta to set
     */
    public void setEsAlerta(boolean esAlerta) {
        this.esAlerta = esAlerta;
    }

    /**
     * @return the plazo
     */
    public Long getPlazo() {
        return plazo;
    }

    /**
     * @param plazo the plazo to set
     */
    public void setPlazo(Long plazo) {
        this.plazo = plazo;
    }
}

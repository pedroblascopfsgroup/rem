package es.capgemini.pfs.asunto.dto;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.persona.model.Persona;

/**
 * DTO para procedimientos.
 * @author pamuller
 *
 */
public class ProcedimientoDto extends WebDto {

    private static final long serialVersionUID = 4411067538437625731L;

    private static final String ASUNTO_NULO = "dc.proc.asuntoNulo";
    private static final String TIPO_PROCEDIMIENTO_NULO = "dc.proc.tipoProcedimientoNulo";
    private static final String TIPO_RECLAMACION_NULO = "dc.proc.tipoReclamacionNulo";
    private static final String TIPO_ACTUACION_NULO = "dc.proc.tipoActuacionNulo";
    private static final String SALDO_RECUPERAR_NULO = "dc.proc.saldorecuperarNulo";
    private static final String PORCENTAJE_RECUPERACION_NULO = "dc.proc.porcentajeRecuperacionNulo";
    private static final String PLAZO_NULO = "dc.proc.plazoNulo";
    private static final String PERSONAS_SELECCIONADAS_NULO = "dc.proc.personasSeleccionadasNulo";

    //private static final String CONTRATOS_SELECCIONADOS_NULO = "dc.proc.contratosSeleccionadosNulo";
    //private static final String PORCENTAJE_RECUPERACION_INVALIDO = "dc.proc.porcentajeRecuperacionInvalido";
    //private static final double CIEN = 100D;

    private Boolean enConformacion;
    private Long idProcedimiento;
    private String seleccionContratos;
    private Long asunto;
    private String tipoProcedimiento;
    private String tipoReclamacion;
    private String actuacion;
    private BigDecimal saldorecuperar;
    private Integer recuperacion; //%
    private Integer plazo;
    private String seleccionPersonas;
    private BigDecimal saldoOriginalVencido;
    private BigDecimal saldoOriginalNoVencido;

    private List<Persona> personasAfectadas;

    private List<ExpedienteContrato> contratosAfectados;
    
    private String prioridad;
    private String preparacion;
    private String tipoAccionPropuesta;
    private String tipoActuacionPropuesta;
    private Boolean turnadoOrdinario;//hay que ver como recoger el boolean y para guardarlo como 1 o 0
    private Boolean preturnado;
    private String motivo;
    private String observaciones;

    /**
     * Valida la info del formulario.
     * @param context el contexto
     */
    public void validateUpdateProcedimiento(MessageContext context) {
        context.clearMessages();

        //Si el procedimiento se ha elevado desde un asunto y no es un procedimiento original, solo se permite modificar el asunto
        if (!getEnConformacion()) {
            if (asunto == null || "".equals(asunto)) {
                context.addMessage(new MessageBuilder().code(ASUNTO_NULO).error().source("").defaultText("**Debe seleccionar un Asunto.").build());
            }

        } else {

            if (seleccionContratos == null || "".equals(seleccionContratos)) {
                context.addMessage(new MessageBuilder().code("CONTRATOS_SELECCIONADOS_NULO").error().source("").defaultText(
                        "**Debe seleccionar al menos un contrato").build());
            }
            if (asunto == null || "".equals(asunto)) {
                context.addMessage(new MessageBuilder().code(ASUNTO_NULO).error().source("").defaultText("**Debe seleccionar un Asunto.").build());
            }
            if (tipoProcedimiento == null || "".equals(tipoProcedimiento)) {
                context.addMessage(new MessageBuilder().code(TIPO_PROCEDIMIENTO_NULO).error().source("").defaultText(
                        "**Debe seleccionar un tipo de procedimiento.").build());
            }
            if (tipoReclamacion == null || "".equals(tipoReclamacion)) {
                context.addMessage(new MessageBuilder().code(TIPO_RECLAMACION_NULO).error().source("").defaultText(
                        "**Debe seleccionar un tipo de reclamaci�n.").build());
            }
            if (actuacion == null || "".equals(actuacion)) {
                context.addMessage(new MessageBuilder().code(TIPO_ACTUACION_NULO).error().source("").defaultText(
                        "**Debe seleccionar un tipo de Actuaci�n.").build());
            }
            if (saldorecuperar == null) {
                context.addMessage(new MessageBuilder().code(SALDO_RECUPERAR_NULO).error().source("").defaultText(
                        "**Debe introducir un saldo a recuperar.").build());
            }
            if (recuperacion == null) {
                context.addMessage(new MessageBuilder().code(PORCENTAJE_RECUPERACION_NULO).error().source("").defaultText(
                        "**Debe introducir un porcentaje de recuperaci�n.").build());
            }
            if (plazo == null) {
                context.addMessage(new MessageBuilder().code(PLAZO_NULO).error().source("")
                        .defaultText("**Debe introducir un plazo de recuperaci�n.").build());
            }
            if (seleccionPersonas == null || "".equals(seleccionPersonas)) {
                context.addMessage(new MessageBuilder().code(PERSONAS_SELECCIONADAS_NULO).error().source("").defaultText(
                        "**Debe seleccionar por lo menos una persona para el procedimiento.").build());
            }
        }
        if (context.getAllMessages().length > 0) {
            throw new ValidationException(ErrorMessageUtils.convertMessages(context.getAllMessages()));
        }
    }

    /**
     * @return the idProcedimiento
     */
    public Long getIdProcedimiento() {
        return idProcedimiento;
    }

    /**
     * @param idProcedimiento the idProcedimiento to set
     */
    public void setIdProcedimiento(Long idProcedimiento) {
        this.idProcedimiento = idProcedimiento;
    }

    /**
     * @return the asunto
     */
    public Long getAsunto() {
        return asunto;
    }

    /**
     * @param asunto the asunto to set
     */
    public void setAsunto(Long asunto) {
        this.asunto = asunto;
    }

    /**
     * @return the tipoProcedimiento
     */
    public String getTipoProcedimiento() {
        return tipoProcedimiento;
    }

    /**
     * @param tipoProcedimiento the tipoProcedimiento to set
     */
    public void setTipoProcedimiento(String tipoProcedimiento) {
        this.tipoProcedimiento = tipoProcedimiento;
    }

    /**
     * @return the tipoReclamacion
     */
    public String getTipoReclamacion() {
        return tipoReclamacion;
    }

    /**
     * @param tipoReclamacion the tipoReclamacion to set
     */
    public void setTipoReclamacion(String tipoReclamacion) {
        this.tipoReclamacion = tipoReclamacion;
    }

    /**
     * @return the actuacion
     */
    public String getActuacion() {
        return actuacion;
    }

    /**
     * @param actuacion the actuacion to set
     */
    public void setActuacion(String actuacion) {
        this.actuacion = actuacion;
    }

    /**
     * @return the saldorecuperar
     */
    public BigDecimal getSaldorecuperar() {
        return saldorecuperar;
    }

    /**
     * @param saldorecuperar the saldorecuperar to set
     */
    public void setSaldorecuperar(BigDecimal saldorecuperar) {
        this.saldorecuperar = saldorecuperar;
    }

    /**
     * @return the recuperacion
     */
    public Integer getRecuperacion() {
        return recuperacion;
    }

    /**
     * @param recuperacion the recuperacion to set
     */
    public void setRecuperacion(Integer recuperacion) {
        this.recuperacion = recuperacion;
    }

    /**
     * @return the plazo
     */
    public Integer getPlazo() {
        return plazo;
    }

    /**
     * @param plazo the plazo to set
     */
    public void setPlazo(Integer plazo) {
        this.plazo = plazo;
    }

    /**
     * @return the seleccionPersonas
     */
    public String getSeleccionPersonas() {
        return seleccionPersonas;
    }

    /**
     * @param seleccionPersonas the seleccionPersonas to set
     */
    public void setSeleccionPersonas(String seleccionPersonas) {
        this.seleccionPersonas = seleccionPersonas;
    }

    /**
     * @return the saldoOriginalVencido
     */
    public BigDecimal getSaldoOriginalVencido() {
        return saldoOriginalVencido;
    }

    /**
     * @param saldoOriginalVencido the saldoOriginalVencido to set
     */
    public void setSaldoOriginalVencido(BigDecimal saldoOriginalVencido) {
        this.saldoOriginalVencido = saldoOriginalVencido;
    }

    /**
     * @return the saldoOriginalNoVencido
     */
    public BigDecimal getSaldoOriginalNoVencido() {
        return saldoOriginalNoVencido;
    }

    /**
     * @param saldoOriginalNoVencido the saldoOriginalNoVencido to set
     */
    public void setSaldoOriginalNoVencido(BigDecimal saldoOriginalNoVencido) {
        this.saldoOriginalNoVencido = saldoOriginalNoVencido;
    }

    /**
     * @return the personasAfectadas
     */
    public List<Persona> getPersonasAfectadas() {
        return personasAfectadas;
    }

    /**
     * @param personasAfectadas the personasAfectadas to set
     */
    public void setPersonasAfectadas(List<Persona> personasAfectadas) {
        this.personasAfectadas = personasAfectadas;
    }

    /**
     * @return the seleccionContratos
     */
    public String getSeleccionContratos() {
        return seleccionContratos;
    }

    /**
     * @param seleccionContratos the seleccionContratos to set
     */
    public void setSeleccionContratos(String seleccionContratos) {
        this.seleccionContratos = seleccionContratos;
    }

    /**
     * @return the contratosAfectados
     */
    public List<ExpedienteContrato> getContratosAfectados() {
        return contratosAfectados;
    }

    /**
     * @param contratosAfectados the contratosAfectados to set
     */
    public void setContratosAfectados(List<ExpedienteContrato> contratosAfectados) {
        this.contratosAfectados = contratosAfectados;
    }

    /**
     * @return the enConformacion
     */
    public Boolean getEnConformacion() {
        return enConformacion;
    }

    /**
     * @param enConformacion the enConformacion to set
     */
    public void setEnConformacion(Boolean enConformacion) {
        this.enConformacion = enConformacion;
    }
    
    public String getPrioridad() {
		return prioridad;
	}

	public void setPrioridad(String prioridad) {
		this.prioridad = prioridad;
	}

	public String getPreparacion() {
		return preparacion;
	}

	public void setPreparacion(String preparacion) {
		this.preparacion = preparacion;
	}

	public String getTipoAccionPropuesta() {
		return tipoAccionPropuesta;
	}

	public void setTipoAccionPropuesta(String tipoAccionPropuesta) {
		this.tipoAccionPropuesta = tipoAccionPropuesta;
	}

	public String getTipoActuacionPropuesta() {
		return tipoActuacionPropuesta;
	}

	public void setTipoActuacionPropuesta(String tipoActuacionPropuesta) {
		this.tipoActuacionPropuesta = tipoActuacionPropuesta;
	}

	public Boolean getTurnadoOrdinario() {
		return turnadoOrdinario;
	}

	public void setTurnadoOrdinario(Boolean turnadoOrdinario) {
		this.turnadoOrdinario = turnadoOrdinario;
	}

	public Boolean getPreturnado() {
		return preturnado;
	}

	public void setPreturnado(Boolean preturnado) {
		this.preturnado = preturnado;
	}

	public String getMotivo() {
		return motivo;
	}

	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

}

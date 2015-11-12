package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;



import java.util.List;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;
import org.springframework.util.AutoPopulatingList;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.procedimientoDerivado.dto.DtoProcedimientoDerivado;
import es.pfsgroup.commons.utils.Checks;

/**
 * 20/12/2012 Dto para decisiones de procedimiento
 *
 * @author: Dolores Orts
 */
public class MEJDtoDecisionProcedimiento extends WebDto {
    /**
     * serialVersionUID.
     */
    private static final long serialVersionUID = -390516773716052924L;

    private DecisionProcedimiento decisionProcedimiento;
    private Long idProcedimiento;
    //private String causaDecision;
    private String causaDecisionFinalizar;
    private String causaDecisionParalizar;    
    private String strEstadoDecision;
    private List<DtoProcedimientoDerivado> procedimientosDerivados;
    private Boolean finalizar;
    private Boolean paralizar;
    private Date fechaParalizacion;
    private String comentarios="";
    private String entidad;
    private String guid;
    private Long id;

    /**
     * constructor.
     */
    @SuppressWarnings("unchecked")
	public MEJDtoDecisionProcedimiento() {
        procedimientosDerivados = new AutoPopulatingList(DtoProcedimientoDerivado.class);
        paralizar = false;
        finalizar = false;
    }

    /**
     * Valida el form.
     *
     * @param messageContext
     *            messageContext
     */
    public void validateFormulario(MessageContext messageContext) {
        messageContext.clearMessages();

        /*
        if (paralizar || finalizar) {
            if (causaDecision == null || "".equals(causaDecision)) {
                messageContext.addMessage(new MessageBuilder().code("decisionProcedimiento.errores.causaNula").error().source("").defaultText(
                        "**Debe seleccionar una causa para la decisi�n.").build());
                throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
            }
        }
        */
        if (finalizar) {
            if (causaDecisionFinalizar == null || "".equals(causaDecisionFinalizar)) {
                messageContext.addMessage(new MessageBuilder().code("decisionProcedimiento.errores.causaNula").error().source("").defaultText(
                        "**Debe seleccionar una causa de finalizaci�n para la decisi�n.").build());
                throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
            }
        }
        if (paralizar) {
            if (causaDecisionParalizar == null || "".equals(causaDecisionParalizar)) {
                messageContext.addMessage(new MessageBuilder().code("decisionProcedimiento.errores.causaNula").error().source("").defaultText(
                        "**Debe seleccionar una causa de paralizaci�n para la decisi�n.").build());
                throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
            }
        }        

        // Causa = Paralizar y fecha null
        //if (DDCausaDecision.PARALIZAR.equals(causaDecision)) {
        if (paralizar) {
            if (getFechaParalizacion() == null) {
                messageContext.addMessage(new MessageBuilder().code("decisionProcedimiento.errores.fechaNula").error().source("").defaultText(
                        "**Debe seleccionar una fecha de fin de paralizaci�n.").build());
                throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
            }

        }
        // validar que haya al menos un procedimiento derivado
        // int counter = 0;
        for (DtoProcedimientoDerivado dtoP : procedimientosDerivados) {
            if (dtoP.getProcedimientoPadre() == null) {
                continue;
            }
            // counter++;
        }
        /*
         * if (counter == 0) { messageContext.addMessage(new
         * MessageBuilder().code
         * ("decisionProcedimiento.errores.procedimientosDerivados"
         * ).error().source("")
         * .defaultText("**Debe agregar al menos un procedimiento derivado."
         * ).build()); throw new
         * ValidationException(ErrorMessageUtils.convertMessages
         * (messageContext.getAllMessages())); }
         */
    }

    public String getCausaDecisionFinalizar() {
		return causaDecisionFinalizar;
	}

	public void setCausaDecisionFinalizar(String causaDecisionFinalizar) {
		this.causaDecisionFinalizar = causaDecisionFinalizar;
	}

	public String getCausaDecisionParalizar() {
		return causaDecisionParalizar;
	}

	public void setCausaDecisionParalizar(String causaDecisionParalizar) {
		this.causaDecisionParalizar = causaDecisionParalizar;
	}

	/**
     * @return the decisionProcedimiento
     */
    public DecisionProcedimiento getDecisionProcedimiento() {
        return decisionProcedimiento;
    }

    /**
     * @param decisionProcedimiento
     *            the decisionProcedimiento to set
     */
    public void setDecisionProcedimiento(DecisionProcedimiento decisionProcedimiento) {
        this.decisionProcedimiento = decisionProcedimiento;
    }

    /**
     * @return the idProcedimiento
     */
    public Long getIdProcedimiento() {
        return idProcedimiento;
    }

    /**
     * @param idProcedimiento
     *            the idProcedimiento to set
     */
    public void setIdProcedimiento(Long idProcedimiento) {
        this.idProcedimiento = idProcedimiento;
    }

    /**
     * @return the causaDecision
     */
    /*
    public String getCausaDecision() {
        return causaDecision;
    }
    */

    /**
     * @param causaDecision
     *            the causaDecision to set
     */
    /*
    public void setCausaDecision(String causaDecision) {
        this.causaDecision = causaDecision;
    }
    */

    /**
     * @return the procedimientosDerivados
     */
    public List<DtoProcedimientoDerivado> getProcedimientosDerivados() {
        return procedimientosDerivados;
    }

    /**
     * @param procedimientosDerivados
     *            the procedimientosDerivados to set
     */
    public void setProcedimientosDerivados(List<DtoProcedimientoDerivado> procedimientosDerivados) {
        this.procedimientosDerivados = procedimientosDerivados;
    }

    /**
     * @return the strEstadoDecision
     */
    public String getStrEstadoDecision() {
        return strEstadoDecision;
    }

    /**
     * @param strEstadoDecision the strEstadoDecision to set
     */
    public void setStrEstadoDecision(String strEstadoDecision) {
        this.strEstadoDecision = strEstadoDecision;
    }

    /**
     * @param finalizar the finalizar to set
     */
    public void setFinalizar(Boolean finalizar) {
        this.finalizar = finalizar;
    }

    /**
     * @return the finalizar
     */
    public Boolean getFinalizar() {
        return finalizar;
    }

    /**
     * @param paralizar the paralizar to set
     */
    public void setParalizar(Boolean paralizar) {
        this.paralizar = paralizar;
    }

    /**
     * @return the paralizar
     */
    public Boolean getParalizar() {
        return paralizar;
    }

	public Date getFechaParalizacion() {
		return fechaParalizacion;
	}

	public void setFechaParalizacion(Date fechaParalizacion) {
		this.fechaParalizacion = fechaParalizacion;
	}

	public String getComentarios() {
		return comentarios;
	}

	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}

	public void setFechaParalizacionStr(String fecha) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		if (!Checks.esNulo(fecha)) {
			try {
				this.setFechaParalizacion(sdf.parse(fecha));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
	}

	public String getEntidad() {
		return entidad;
	}

	public void setEntidad(String entidad) {
		this.entidad = entidad;
	}

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
}

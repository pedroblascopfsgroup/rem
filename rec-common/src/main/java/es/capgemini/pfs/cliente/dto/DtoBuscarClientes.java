package es.capgemini.pfs.cliente.dto;

import java.util.List;
import java.util.Set;

import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.users.domain.Perfil;

/**
 * Dto para la búsqueda de clientes.
 */
public class DtoBuscarClientes extends WebDto {

    private static final long serialVersionUID = 1L;

    private String nombre;
    private String apellido1;
    private String apellido2;
    private String segmento;
    private String situacion;
    private String situacionFinanciera;
    private String situacionFinancieraContrato;
    private String docId;
    private String codigoEntidad;
    private String tipoPersona;
    private String jerarquia;
    private String codigoZona;
    private String minRiesgoTotal = null;
    private String maxRiesgoTotal = null;
    private String minSaldoVencido = null;
    private String maxSaldoVencido = null;
    private String minDiasVencido = null;
    private String maxDiasVencido = null;
    private Set<String> codigoZonas;
    private Boolean isPrimerTitContratoPase;
    private String tipoIntervercion;
    private String nroContrato;
    private List<Perfil> perfiles;
    private Boolean isBusquedaGV;
    private String tipoRiesgo;
    private String tipoProducto;
    private String tipoProductoEntidad;
    private String codigoGestion;

    /**
     * Recupera el código de tipo de producto filtrado.
     * @return tipoProducto
     */
    public String getTipoProducto() {
        return tipoProducto;
    }

    /**
     * Setea el código de tipo de producto filtrado.
     * @param tipoProducto el tipo dr producto
     */
    public void setTipoProducto(String tipoProducto) {
        this.tipoProducto = tipoProducto;
    }

    public String getTipoProductoEntidad() {
		return tipoProductoEntidad;
	}

	public void setTipoProductoEntidad(String tipoProductoEntidad) {
		this.tipoProductoEntidad = tipoProductoEntidad;
	}

	/**
     * @return the isBusquedaGV
     */
    public Boolean getIsBusquedaGV() {
        return isBusquedaGV;
    }

    /**
     * @param isBusquedaGV the isBusquedaGV to set
     */
    public void setIsBusquedaGV(Boolean isBusquedaGV) {
        this.isBusquedaGV = isBusquedaGV;
    }

    /**
     * @return the perfiles
     */
    public List<Perfil> getPerfiles() {
        return perfiles;
    }

    /**
     * @param perfiles the perfiles to set
     */
    public void setPerfiles(List<Perfil> perfiles) {
        this.perfiles = perfiles;
    }

    /**
     * Validación del lado del servidor de los datos ingresados en el formulario.
     * @param messageContext MessageContext
     */
    public void validateListado(MessageContext messageContext) {
        messageContext.clearMessages();
        /*if (nif != null && !nif.equals("")) {
            try {
                Integer.parseInt(nif);
            } catch (NumberFormatException e) {
                messageContext.addMessage(new MessageBuilder().code("listadoClientes.error.nif").error().source("").defaultText(
                        "**Campo NIF debe ser un número.").build());
                throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
            }
        }*/
        if (codigoEntidad != null && !codigoEntidad.equals("")) {
            try {
                Long.parseLong(codigoEntidad);
            } catch (NumberFormatException e) {
                messageContext.addMessage(new MessageBuilder().code("listadoClientes.error.codigoEntidad").error().source("").defaultText(
                        "**Campo Código Cliente debe ser un número.").build());
                throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
            }
        }

        if (jerarquia != null && jerarquia.trim().length() > 0 && (codigoZona == null || codigoZona.trim().length() == 0)) {
            messageContext.addMessage(new MessageBuilder().code("listadoClientes.error.zonaJerarquia").error().source("").defaultText(
                    "**Debe elegir una zona de la jerarquia.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }
        
        
        /*
         * PRODUCTO-1257 Se deshabilita las llamadas a estas dos validaciones, pero no las borro por si en un futuro se vuelve a requerir
         * 
        //Si no ha seleccionado alguno de los filtros básicos
        if ((codigoEntidad == null || codigoEntidad.trim().length() == 0) && (nombre == null || nombre.trim().length() == 0)
                && (apellido1 == null || apellido1.trim().length() == 0) && (docId == null || docId.trim().length() == 0)
                && (tipoPersona == null || tipoPersona.trim().length() == 0) && (nroContrato == null || nroContrato.trim().length() == 0)
                && (maxRiesgoTotal == null || maxRiesgoTotal.trim().length() == 0) && (minRiesgoTotal == null || minRiesgoTotal.trim().length() == 0)
                && (maxDiasVencido == null || maxDiasVencido.trim().length() == 0) && (minDiasVencido == null || minDiasVencido.trim().length() == 0)
                && (maxSaldoVencido == null || maxSaldoVencido.trim().length() == 0)
                && (minSaldoVencido == null || minSaldoVencido.trim().length() == 0) && (segmento == null || segmento.trim().length() == 0)
                && (situacion == null || situacion.trim().length() == 0) && (tipoProducto == null || tipoProducto.trim().length() == 0)
                && (tipoProductoEntidad == null || tipoProductoEntidad.trim().length() == 0)
                && (codigoGestion == null || codigoGestion.trim().length() == 0)) {

        	
            boolean bTipoIntervencion = (tipoIntervercion == null || tipoIntervercion.trim().length() == 0);
            boolean bJerarquia = (codigoZonas == null || codigoZonas.size() == 0) && (codigoZona == null || codigoZona.trim().length() == 0);
            //boolean bJerarquia = (jerarquia == null || jerarquia.trim().length() == 0);

            if (bTipoIntervencion != bJerarquia) {
                messageContext.addMessage(new MessageBuilder().code("listadoClientes.error.zonaJerarquiaTipoIntervencion").error().source("").defaultText(
                        "**Si elige un tipo de intervención debe seleccionar una zona de la jerarquia o viceversa.").build());
                throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
            }
            
        }*/

    }

    /*
     *
     *  Getters y Setters
     *
     */

    /**
     * @return the nombre
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * @param nombre the nombre to set
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    /**
     * @return the apellido1
     */
    public String getApellido1() {
        return apellido1;
    }

    /**
     * @param apellido1 the apellido1 to set
     */
    public void setApellido1(String apellido1) {
        this.apellido1 = apellido1;
    }

    /**
     * @return the apellido2
     */
    public String getApellido2() {
        return apellido2;
    }

    /**
     * @param apellido2 the apellido2 to set
     */
    public void setApellido2(String apellido2) {
        this.apellido2 = apellido2;
    }

    /**
     * @return código segmento
     */
    public String getSegmento() {
        return segmento;
    }

    /**
     * @param segmento código segmento to set
     */
    public void setSegmento(String segmento) {
        this.segmento = segmento;
    }

    /**
     * @return the situacion
     */
    public String getSituacion() {
        return situacion;
    }

    /**
     * @param situacion the situacion to set
     */
    public void setSituacion(String situacion) {
        this.situacion = situacion;
    }

    /**
     * @return the situacionFinanciera
     */
    public String getSituacionFinanciera() {
        return situacionFinanciera;
    }

    /**
     * @param situacionFinanciera the situacionFinanciera to set
     */
    public void setSituacionFinanciera(String situacionFinanciera) {
        this.situacionFinanciera = situacionFinanciera;
    }

    /**
     * @return the nif
     */
    public String getDocId() {
        return docId;
    }

    /**
     * @param docId the nif to set
     */
    public void setDocId(String docId) {
        this.docId = docId;
    }

    /**
     * @return the codEntidad
     */
    public String getCodigoEntidad() {
        return codigoEntidad;
    }

    /**
     * @param codigoEntidad the codigoEntidad to set
     */
    public void setCodigoEntidad(String codigoEntidad) {
        this.codigoEntidad = codigoEntidad;
    }

    /**
     * @return the serialVersionUID
     */
    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    /**
     * @return the tipoPersona
     */
    public String getTipoPersona() {
        return tipoPersona;
    }

    /**
     * @param tipoPersona the tipoPersona to set
     */
    public void setTipoPersona(String tipoPersona) {
        this.tipoPersona = tipoPersona;
    }

    /**
     * @return the minRiesgoTotal
     */
    public String getMinRiesgoTotal() {
        return minRiesgoTotal;
    }

    /**
     * @param minRiesgoTotal the minRiesgoTotal to set
     */
    public void setMinRiesgoTotal(String minRiesgoTotal) {
        this.minRiesgoTotal = minRiesgoTotal;
    }

    /**
     * @return the maxRiesgoTotal
     */
    public String getMaxRiesgoTotal() {
        return maxRiesgoTotal;
    }

    /**
     * @param maxRiesgoTotal the maxRiesgoTotal to set
     */
    public void setMaxRiesgoTotal(String maxRiesgoTotal) {
        this.maxRiesgoTotal = maxRiesgoTotal;
    }

    /**
     * @return the minSaldoVencido
     */
    public String getMinSaldoVencido() {
        return minSaldoVencido;
    }

    /**
     * @param minSaldoVencido the minSaldoVencido to set
     */
    public void setMinSaldoVencido(String minSaldoVencido) {
        this.minSaldoVencido = minSaldoVencido;
    }

    /**
     * @return the maxSaldoVencido
     */
    public String getMaxSaldoVencido() {
        return maxSaldoVencido;
    }

    /**
     * @param maxSaldoVencido the maxSaldoVencido to set
     */
    public void setMaxSaldoVencido(String maxSaldoVencido) {
        this.maxSaldoVencido = maxSaldoVencido;
    }

    /**
     * @return the minDiasVencido
     */
    public String getMinDiasVencido() {
        return minDiasVencido;
    }

    /**
     * @param minDiasVencido the minDiasVencido to set
     */
    public void setMinDiasVencido(String minDiasVencido) {
        this.minDiasVencido = minDiasVencido;
    }

    /**
     * @return the maxDiasVencido
     */
    public String getMaxDiasVencido() {
        return maxDiasVencido;
    }

    /**
     * @param maxDiasVencido the maxDiasVencido to set
     */
    public void setMaxDiasVencido(String maxDiasVencido) {
        this.maxDiasVencido = maxDiasVencido;
    }

    /**
     * @return the jerarquia
     */
    public String getJerarquia() {
        return jerarquia;
    }

    /**
     * @param jerarquia the jerarquia to set
     */
    public void setJerarquia(String jerarquia) {
        this.jerarquia = jerarquia;
    }

    /**
     * to string.
     * @return strign
     */
    @Override
    public String toString() {
        return ReflectionToStringBuilder.toString(this);
    }

    /**
     * @return the codigoZonas
     */
    public Set<String> getCodigoZonas() {
        return codigoZonas;
    }

    /**
     * @param codigoZonas the codigoZonas to set
     */
    public void setCodigoZonas(Set<String> codigoZonas) {
        this.codigoZonas = codigoZonas;
    }

    /**
     * @return the codigoZona
     */
    public String getCodigoZona() {
        return codigoZona;
    }

    /**
     * @param codigoZona the codigoZona to set
     */
    public void setCodigoZona(String codigoZona) {
        this.codigoZona = codigoZona;
    }

    /**
     * @return the isPrimerTitContratoPase
     */
    public Boolean getIsPrimerTitContratoPase() {
        return isPrimerTitContratoPase;
    }

    /**
     * @param isPrimerTitContratoPase the isPrimerTitContratoPase to set
     */
    public void setIsPrimerTitContratoPase(Boolean isPrimerTitContratoPase) {
        this.isPrimerTitContratoPase = isPrimerTitContratoPase;
    }

    /**
     * @return the nroContrato
     */
    public String getNroContrato() {
        return nroContrato;
    }

    /**
     * @param nroContrato the nroContrato to set
     */
    public void setNroContrato(String nroContrato) {
        this.nroContrato = nroContrato;
    }

    /**
     * @return the tipoIntervercion
     */
    public String getTipoIntervercion() {
        return tipoIntervercion;
    }

    /**
     * @param tipoIntervercion the tipoIntervercion to set
     */
    public void setTipoIntervercion(String tipoIntervercion) {
        this.tipoIntervercion = tipoIntervercion;
    }

    /**
     * Setea el tipo de riesgo.
     * @param tipoRiesgo String
     */
    public void setTipoRiesgo(String tipoRiesgo) {
        this.tipoRiesgo = tipoRiesgo;
    }

    /**
     * Recupera el tipo de riesgo.
     * @return String
     */
    public String getTipoRiesgo() {
        return tipoRiesgo;
    }

    /**
     * @param codigoGestion the codigoGestion to set
     */
    public void setCodigoGestion(String codigoGestion) {
        this.codigoGestion = codigoGestion;
    }

    /**
     * @return the codigoGestion
     */
    public String getCodigoGestion() {
        return codigoGestion;
    }

    /**
     * @param situacionFinancieraContrato the situacionFinancieraContrato to set
     */
    public void setSituacionFinancieraContrato(String situacionFinancieraContrato) {
        this.situacionFinancieraContrato = situacionFinancieraContrato;
    }

    /**
     * @return the situacionFinancieraContrato
     */
    public String getSituacionFinancieraContrato() {
        return situacionFinancieraContrato;
    }
}

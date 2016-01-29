package es.capgemini.pfs.registro.model;

import java.io.Serializable;
import java.util.Date;

/**
 * FALTA JAVADOC FO.
 * @author FO
 *
 */
public class HistoricoProcedimiento implements Serializable {

    public static final Long TIPO_ENTIDAD_TAREA = 1L;
    public static final Long TIPO_ENTIDAD_COMUNICACION = 2L;
    public static final Long TIPO_ENTIDAD_PETICION_RECURSO = 3L;
    public static final Long TIPO_ENTIDAD_RESPUESTA_RECURSO = 4L;
    public static final Long TIPO_ENTIDAD_PETICION_PRORROGA = 5L;
    public static final Long TIPO_ENTIDAD_RESPUESTA_PRORROGA = 6L;
    public static final Long TIPO_ENTIDAD_PETICION_ACUERDO = 7L;
    public static final Long TIPO_ENTIDAD_RESPUESTA_ACUERDO = 8L;
    public static final Long TIPO_ENTIDAD_PETICION_DECISION = 9L;
    public static final Long TIPO_ENTIDAD_RESPUESTA_DECISION = 10L;
    public static final Long TIPO_ENTIDAD_TAREA_CANCELADA = 11L;

    private static final long serialVersionUID = 1L;

    private Long tipoEntidad;
    private Long idEntidad;
    private Boolean respuesta;
    private Long idProcedimiento;
    private String nombreTarea;
    private Date fechaRegistro;
    private Date fechaIni;
    private String fechaInicio;
    private Date fechaVencimiento;
    private Date fechaFin;
    private String nombreUsuario;

    /**
     * @return the tipoEntidad
     */
    public Long getTipoEntidad() {
        return tipoEntidad;
    }

    /**
     * @param tipoEntidad the tipoEntidad to set
     */
    public void setTipoEntidad(Long tipoEntidad) {
        this.tipoEntidad = tipoEntidad;
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
     * @return the respuesta
     */
    public Boolean getRespuesta() {
        return respuesta;
    }

    /**
     * @param respuesta the respuesta to set
     */
    public void setRespuesta(Boolean respuesta) {
        this.respuesta = respuesta;
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
     * @return the nombreTarea
     */
    public String getNombreTarea() {
        return nombreTarea;
    }

    /**
     * @param nombreTarea the nombreTarea to set
     */
    public void setNombreTarea(String nombreTarea) {
        this.nombreTarea = nombreTarea;
    }

    /**
     * @return the fechaRegistro
     */
    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    /**
     * @param fechaRegistro the fechaRegistro to set
     */
    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    /**
     * @return the fechaIni
     */
    public Date getFechaIni() {
        return fechaIni;
    }

    /**
     * @param fechaIni the fechaIni to set
     */
    public void setFechaIni(Date fechaIni) {
        this.fechaIni = fechaIni;
    }

    /**
     * @return the fechaVencimiento
     */
    public Date getFechaVencimiento() {
        return fechaVencimiento;
    }

    /**
     * @param fechaVencimiento the fechaVencimiento to set
     */
    public void setFechaVencimiento(Date fechaVencimiento) {
        this.fechaVencimiento = fechaVencimiento;
    }

    /**
     * @return the fechaFin
     */
    public Date getFechaFin() {
        return fechaFin;
    }

    /**
     * @param fechaFin the fechaFin to set
     */
    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }

    /**
     * @return the nombreUsuario
     */
    public String getNombreUsuario() {
        return nombreUsuario;
    }

    /**
     * @param nombreUsuario the nombreUsuario to set
     */
    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

	public String getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

}

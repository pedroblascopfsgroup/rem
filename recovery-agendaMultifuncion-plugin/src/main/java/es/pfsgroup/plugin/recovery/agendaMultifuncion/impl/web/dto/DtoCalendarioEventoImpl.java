package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.web.dto;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCalendarioEvento;

public class DtoCalendarioEventoImpl extends WebDto implements DtoCalendarioEvento {

    private static final long serialVersionUID = -7913970399437316603L;
    private Long id;
    private String fechaInicio;
    private String fechaFin;
    private String nombre;
    private String descripcion;
    private String diaCompleto;

    /* (non-Javadoc)
     * @see es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCalendarioEvento#getFechaInicio()
     */
    @Override
    public String getFechaInicio() {
        return fechaInicio;
    }

    /* (non-Javadoc)
     * @see es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCalendarioEvento#setFechaInicio(java.lang.String)
     */
    @Override
    public void setFechaInicio(String fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    /* (non-Javadoc)
     * @see es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCalendarioEvento#getFechaFin()
     */
    @Override
    public String getFechaFin() {
        return fechaFin;
    }

    /* (non-Javadoc)
     * @see es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCalendarioEvento#setFechaFin(java.lang.String)
     */
    @Override
    public void setFechaFin(String fechaFin) {
        this.fechaFin = fechaFin;
    }

    /* (non-Javadoc)
     * @see es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCalendarioEvento#getNombre()
     */
    @Override
    public String getNombre() {
        return nombre;
    }

    /* (non-Javadoc)
     * @see es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCalendarioEvento#setNombre(java.lang.String)
     */
    @Override
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    /* (non-Javadoc)
     * @see es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCalendarioEvento#getDescripcion()
     */
    @Override
    public String getDescripcion() {
        return descripcion;
    }

    /* (non-Javadoc)
     * @see es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCalendarioEvento#setDescripcion(java.lang.String)
     */
    @Override
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /* (non-Javadoc)
     * @see es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCalendarioEvento#getId()
     */
    @Override
    public Long getId() {
        return id;
    }

    /* (non-Javadoc)
     * @see es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCalendarioEvento#setId(java.lang.Long)
     */
    @Override
    public void setId(Long id) {
        this.id = id;
    }

    /* (non-Javadoc)
     * @see es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCalendarioEvento#getDiaCompleto()
     */
    @Override
    public String getDiaCompleto() {
        return diaCompleto;
    }

    /* (non-Javadoc)
     * @see es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCalendarioEvento#setDiaCompleto(java.lang.String)
     */
    @Override
    public void setDiaCompleto(String diaCompleto) {
        this.diaCompleto = diaCompleto;
    }

}

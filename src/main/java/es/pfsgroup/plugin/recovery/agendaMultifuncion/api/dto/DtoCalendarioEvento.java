package es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto;

public interface DtoCalendarioEvento {

	public abstract String getFechaInicio();

	public abstract void setFechaInicio(String fechaInicio);

	public abstract String getFechaFin();

	public abstract void setFechaFin(String fechaFin);

	public abstract String getNombre();

	public abstract void setNombre(String nombre);

	public abstract String getDescripcion();

	public abstract void setDescripcion(String descripcion);

	public abstract Long getId();

	public abstract void setId(Long id);

	public abstract String getDiaCompleto();

	public abstract void setDiaCompleto(String diaCompleto);

}
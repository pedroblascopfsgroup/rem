package es.pfsgroup.plugin.recovery.masivo.model.notificacion;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;

public class MSVInfoNotificacionFilter implements Serializable{

	private static final long serialVersionUID = 841646368734743405L;
	public static final String FILTRO_PESONA = "PERSONA";
	public static final String FILTRO_DIRECCION = "DIRECCION";
	public static final String FILTRO_TIPO_FECHA = "FECHA";
	
	private String tipoFiltro;
	
	private String tipoFecha;
	
	private Long idPersona;
	
	private String idDireccion;

	public Long getIdPersona() {
		return idPersona;
	}

	public void setIdPersona(Long idFiltrado) {
		this.idPersona = idFiltrado;
	}

	public String getIdDireccion() {
		return idDireccion;
	}

	public void setIdDireccion(String idDireccion) {
		this.idDireccion = idDireccion;
	}
	
	public String getTipoFiltro() {
		return tipoFiltro;
	}

	public void setTipoFiltro(String tipoFiltro) {
		this.tipoFiltro = tipoFiltro;
	}

	public String getTipoFecha() {
		return tipoFecha;
	}

	public void setTipoFecha(String tipoFecha) {
		this.tipoFecha = tipoFecha;
	}	
	
	
	public void filtra(MSVInfoNotificacion msvInfoNotificacion){
		if (msvInfoNotificacion == null)
			throw new NullPointerException("msvInfoNotificacion es nulo.");
		msvInfoNotificacion.setInfoDemandados(this.filtraPersonas(msvInfoNotificacion.getInfoDemandados()));
		msvInfoNotificacion.setInfoFechasNotificacion(this.filtra(msvInfoNotificacion.getInfoFechasNotificacion()));
/*
		if(FILTRO_PESONA.equals(this.getTipoFiltro()))
			msvInfoNotificacion.setInfoFechasNotificacion(this.filtra(msvInfoNotificacion.getInfoFechasNotificacion()));
		else if (FILTRO_DIRECCION.equals(this.getTipoFiltro()))
			msvInfoNotificacion.setInfoFechasNotificacion(this.filtra(msvInfoNotificacion.getInfoFechasNotificacion()));
		else if (FILTRO_TIPO_FECHA.equals(this.getTipoFiltro()))
			msvInfoNotificacion.setInfoFechasNotificacion(this.filtra(msvInfoNotificacion.getInfoFechasNotificacion()));
*/			
	}
	
	public List<MSVDireccionFechaNotificacion> filtra(List<MSVDireccionFechaNotificacion> listado){
		if(FILTRO_PESONA.equals(this.getTipoFiltro()))
			return this.filtraFechasPorPersonas(listado);
		else if (FILTRO_DIRECCION.equals(this.getTipoFiltro()))
			return this.filtraDireccion(listado);
		else if (FILTRO_TIPO_FECHA.equals(this.getTipoFiltro()))
			return this.filtraTipoFecha(listado);
		else
			return listado;
	}
	
	private List<MSVInfoDemandado> filtraPersonas(List<MSVInfoDemandado> infoDemandados) {

		List<MSVInfoDemandado> infoDemandadosFiltrada = new ArrayList<MSVInfoDemandado>(0);
		
		if (infoDemandados != null){
			for (MSVInfoDemandado msvInfoDemandado : infoDemandados) {
				Persona persona = msvInfoDemandado.getPersona();
				if(persona.getId() != null && persona.getId().equals(this.getIdPersona()))
					infoDemandadosFiltrada.add(msvInfoDemandado);
			}
		}
		return infoDemandadosFiltrada;
	}
	
	private  List<MSVDireccionFechaNotificacion> filtraDireccion( List<MSVDireccionFechaNotificacion> listado) {

		List<MSVDireccionFechaNotificacion> listadoFiltrado = new ArrayList<MSVDireccionFechaNotificacion>(0);

		if(listado != null){
			for (MSVDireccionFechaNotificacion msvDireccionFechaNotificacion : listado) {
				//Persona persona = msvDireccionFechaNotificacion.getPersona();
				Direccion direccion = msvDireccionFechaNotificacion.getDireccion();
				if(direccion != null && direccion.getCodDireccion() != null && direccion.getCodDireccion().equals(this.getIdDireccion()))
					listadoFiltrado.add(msvDireccionFechaNotificacion);
			}
		}
		return listadoFiltrado;
	}
	
	private  List<MSVDireccionFechaNotificacion> filtraTipoFecha( List<MSVDireccionFechaNotificacion> listado) {

		List<MSVDireccionFechaNotificacion> listadoFiltrado = new ArrayList<MSVDireccionFechaNotificacion>(0);
		if(listado != null){
			for (MSVDireccionFechaNotificacion msvDireccionFechaNotificacion : listado) {
				//Persona persona = msvDireccionFechaNotificacion.getPersona();
				//Direccion direccion = msvDireccionFechaNotificacion.getDireccion();
				if(msvDireccionFechaNotificacion.getTipoFecha() != null && msvDireccionFechaNotificacion.getTipoFecha().equals(this.getTipoFecha()))
					listadoFiltrado.add(msvDireccionFechaNotificacion);
			}
		}		
		return listadoFiltrado;
	}	
	
	private  List<MSVDireccionFechaNotificacion> filtraFechasPorPersonas( List<MSVDireccionFechaNotificacion> listado) {

		List<MSVDireccionFechaNotificacion> listadoFiltrado = new ArrayList<MSVDireccionFechaNotificacion>(0);
		if(listado != null){
			for (MSVDireccionFechaNotificacion msvDireccionFechaNotificacion : listado) {
				Persona persona = msvDireccionFechaNotificacion.getPersona();
				if(persona.getId() != null && persona.getId().equals(this.getIdPersona()))
					listadoFiltrado.add(msvDireccionFechaNotificacion);
			}
		}
		return listadoFiltrado;
	}

	
	
}

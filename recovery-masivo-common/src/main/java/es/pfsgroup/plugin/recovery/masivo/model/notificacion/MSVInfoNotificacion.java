package es.pfsgroup.plugin.recovery.masivo.model.notificacion;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.Checks;

/**
 * Objeto que almacena toda la información relativa a las notificaciones masivas, 
 * el listado con el resumen, los demandados y sus direcciones, y las fechas de notificación.
 * 
 * @author manuel
 *
 */
@Component
public class MSVInfoNotificacion implements Serializable{

	private static final long serialVersionUID = -9219173142796564511L;

	private List<MSVInfoResumen> infoResumen = new ArrayList<MSVInfoResumen>(0);
	
	private List<MSVInfoResumenPersona> infoResumenPersona = new ArrayList<MSVInfoResumenPersona>(0);

	private List<MSVInfoDemandado> infoDemandados = new ArrayList<MSVInfoDemandado>(0);

	private List<MSVDireccionFechaNotificacion> infoFechasNotificacion = new ArrayList<MSVDireccionFechaNotificacion>(0);
	
	private List<MSVInfoNotificacionFilter> filtros = new ArrayList<MSVInfoNotificacionFilter>(0);

	Procedimiento procedimiento;
	


	/**
	 * Este método genera el resumen cada vez que se le llama, en tiempo de ejecución.
	 * @return
	 */
	public List<MSVInfoResumen> getInfoResumen() {

		infoResumen.clear();
		if (infoDemandados != null){
			//Creamos una fila por cada demandado.
			for (MSVInfoDemandado msvInfoDemandado : infoDemandados) {
				MSVInfoResumen msvInfoResumen = new MSVInfoResumen();
				Persona persona = msvInfoDemandado.getPersona();
				msvInfoResumen.setIdProcedimiento(procedimiento.getId());
				msvInfoResumen.setNombreDemandado(persona.getApellidoNombre());
				msvInfoResumen.setIdDemandado(persona.getId());
				
				MSVInfoNotificacionFilter filtro = new MSVInfoNotificacionFilter();
				filtro.setIdPersona(persona.getId());
				filtro.setTipoFiltro(MSVInfoNotificacionFilter.FILTRO_PESONA);
				List<MSVDireccionFechaNotificacion> fechasDireccion = filtro.filtra(this.getInfoFechasNotificacion());
	
				filtro.setTipoFecha(MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_REQUERIMIENTO);
				filtro.setTipoFiltro(MSVInfoNotificacionFilter.FILTRO_TIPO_FECHA);
				List<MSVDireccionFechaNotificacion> fechasRequerimiento = filtro.filtra(fechasDireccion);
				
				filtro.setTipoFecha(MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_AVERIGUACION);
				filtro.setTipoFiltro(MSVInfoNotificacionFilter.FILTRO_TIPO_FECHA);
				List<MSVDireccionFechaNotificacion> fechasAveriguacion = filtro.filtra(fechasDireccion);
	
				filtro.setTipoFecha(MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_EDICTOS);
				filtro.setTipoFiltro(MSVInfoNotificacionFilter.FILTRO_TIPO_FECHA);
				List<MSVDireccionFechaNotificacion> fechasEdicto = filtro.filtra(fechasDireccion);
				
				//FIXME De momento dejamos hardcodeado un "NO" 
				//hasta que nos faciliten desde donde se carga este dato
				msvInfoResumen.setExcluido(isExcluido(fechasDireccion));
				
				this.calculaRequerimiento(msvInfoResumen, fechasRequerimiento);
				this.calculaAveriguacion(msvInfoResumen, fechasAveriguacion);
				this.calculaEdicto(msvInfoResumen, fechasEdicto);
				this.infoResumen.add(msvInfoResumen);
			}
		}

		return infoResumen;
	}


	private void calculaRequerimiento(MSVInfoResumen msvInfoResumen, List<MSVDireccionFechaNotificacion> fechasRequerimiento) {
		Collections.sort(fechasRequerimiento, this.getDateComparator());
		if(fechasRequerimiento.size() > 0){
			MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = fechasRequerimiento.get(0);
			for (MSVDireccionFechaNotificacion msvDireccionFechaNotificacionTmp : fechasRequerimiento) {
				if (MSVDireccionFechaNotificacion.RESULTADO_POSITIVO.equals(msvDireccionFechaNotificacionTmp.getResultado())) {
					msvDireccionFechaNotificacion = msvDireccionFechaNotificacionTmp;
					break;
				}
			}
			msvInfoResumen.setFechaReqPago(msvDireccionFechaNotificacion.getFechaResultado());
			msvInfoResumen.setResultadoReqPago(msvDireccionFechaNotificacion.getResultado());
		}
		
	}


	private void calculaEdicto(MSVInfoResumen msvInfoResumen, List<MSVDireccionFechaNotificacion> fechasEdicto) {
		Collections.sort(fechasEdicto, this.getDateComparator());
		if(fechasEdicto.size() > 0){
			MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = fechasEdicto.get(0);
			msvInfoResumen.setFechaSolicitudReqEdicto(msvDireccionFechaNotificacion.getFechaResultado());
			msvInfoResumen.setResultadoReqEdicto(msvDireccionFechaNotificacion.getResultado());
		}
		
	}


	private void calculaAveriguacion(MSVInfoResumen msvInfoResumen, List<MSVDireccionFechaNotificacion> fechasAveriguacion) {
		Collections.sort(fechasAveriguacion, this.getDateComparator());
		if(fechasAveriguacion.size() > 0){
			MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = fechasAveriguacion.get(0);
			msvInfoResumen.setFechaSolicitudAvDomiciliaria(msvDireccionFechaNotificacion.getFechaResultado());
			msvInfoResumen.setResultadoAvDomiciliaria(msvDireccionFechaNotificacion.getResultado());
		}
		
		
	}


	public List<MSVInfoResumenPersona> getInfoResumenPersona() {
		
		infoResumenPersona.clear();
		if(infoDemandados != null){
			for (MSVInfoDemandado msvInfoDemandado : infoDemandados) {
				Persona persona = msvInfoDemandado.getPersona();
				List<Direccion> direcciones = persona.getDirecciones();
				for(Direccion direccion: direcciones){
					MSVInfoResumenPersona msvInfoResumenPersona = new MSVInfoResumenPersona();
					msvInfoResumenPersona.setIdProcedimiento(procedimiento.getId());
					msvInfoResumenPersona.setIdDemandado(persona.getId());
					msvInfoResumenPersona.setIdDireccion(direccion.getCodDireccion());
					msvInfoResumenPersona.setDireccion(direccion.toString());
					
					MSVInfoNotificacionFilter filtro = new MSVInfoNotificacionFilter();
					filtro.setIdDireccion(direccion.getCodDireccion());
					filtro.setTipoFiltro(MSVInfoNotificacionFilter.FILTRO_DIRECCION);
					List<MSVDireccionFechaNotificacion> fechasDireccion = filtro.filtra(this.getInfoFechasNotificacion());
					
					filtro.setTipoFecha(MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_REQUERIMIENTO);
					filtro.setTipoFiltro(MSVInfoNotificacionFilter.FILTRO_TIPO_FECHA);
					List<MSVDireccionFechaNotificacion> fechasRequerimiento = filtro.filtra(fechasDireccion);
	
					filtro.setTipoFecha(MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_HORARIO_NOCTURNO);
					filtro.setTipoFiltro(MSVInfoNotificacionFilter.FILTRO_TIPO_FECHA);
					List<MSVDireccionFechaNotificacion> fechasNocturno = filtro.filtra(fechasDireccion);
					
					this.calculaRequerimiento(msvInfoResumenPersona, fechasRequerimiento);
					this.calculaHorarioNocturno(msvInfoResumenPersona, fechasNocturno);
	
					this.infoResumenPersona.add(msvInfoResumenPersona);
					//infoFechasNotificacion
				}
			}
		}
		return infoResumenPersona;
	}

	private void calculaHorarioNocturno(MSVInfoResumenPersona msvInfoResumenPersona, List<MSVDireccionFechaNotificacion> fechasNocturno) {
		Collections.sort(fechasNocturno, this.getDateComparator());
		if(fechasNocturno.size() > 0){
			MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = fechasNocturno.get(0);
			msvInfoResumenPersona.setFechaHorarioNocturno(msvDireccionFechaNotificacion.getFechaResultado());
			msvInfoResumenPersona.setResultadoHorarioNocturno(msvDireccionFechaNotificacion.getResultado());
		}
		
	}


	private void calculaRequerimiento(MSVInfoResumenPersona msvInfoResumenPersona, List<MSVDireccionFechaNotificacion> fechasRequerimiento) {
		Collections.sort(fechasRequerimiento, this.getDateComparator());
		if(fechasRequerimiento.size() > 0){
			MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = fechasRequerimiento.get(0);			
			msvInfoResumenPersona.setFechaRequerimiento(msvDireccionFechaNotificacion.getFechaResultado());
			msvInfoResumenPersona.setResultadoRequerimiento(msvDireccionFechaNotificacion.getResultado());
		}
		
	}


	public List<MSVInfoDemandado> getInfoDemandados() {
		return infoDemandados;
	}

	public void setInfoDemandados(List<MSVInfoDemandado> infoDemandados) {
		this.infoDemandados = infoDemandados;
	}

	public List<MSVDireccionFechaNotificacion> getInfoFechasNotificacion() {
		return infoFechasNotificacion;
	}

	public void setInfoFechasNotificacion(
			List<MSVDireccionFechaNotificacion> infoFechasNotificacion) {
		this.infoFechasNotificacion = infoFechasNotificacion;
	}
	

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public void filtra() {
		if (filtros.size() > 0){
			for(MSVInfoNotificacionFilter filtro: this.filtros){
				filtro.filtra(this);
			}
		}
	}

	public void addFiltro(MSVInfoNotificacionFilter filtro) {
		this.filtros.add(filtro);
	}

	public void clearAll(){
		infoResumen.clear();
		infoResumenPersona.clear();
		infoDemandados.clear();
		infoFechasNotificacion.clear();
		filtros.clear();		
	}
	
	private Comparator<MSVDireccionFechaNotificacion> getDateComparator(){
		 return new Comparator<MSVDireccionFechaNotificacion>() {
		    public int compare(MSVDireccionFechaNotificacion a, MSVDireccionFechaNotificacion b) {
		    	if(b.getFechaResultado() == null){return -1;}
		    	else if(a.getFechaResultado() == null){return 1;}
		    	else return b.getFechaResultado().compareTo(a.getFechaResultado());
		    }
		};
	}
	
	//Si existe alguna dirección excluida, el demandado está excluido
	private boolean isExcluido(List<MSVDireccionFechaNotificacion> listado) {
		//TODO actualmente se esta utilizando la entity de las direccionesFechas 
		//para almacenar el campo excluido, se deberá cambiar a un objeto propio de demandados
		if (!Checks.esNulo(listado)) {
			for (MSVDireccionFechaNotificacion msvDireccionFechaNotificacion : listado) {				
				if (!Checks.esNulo(msvDireccionFechaNotificacion.getExcluido()) && (msvDireccionFechaNotificacion.getExcluido())) {
					return true;
				}
			}
		}
		return false;
	}

}
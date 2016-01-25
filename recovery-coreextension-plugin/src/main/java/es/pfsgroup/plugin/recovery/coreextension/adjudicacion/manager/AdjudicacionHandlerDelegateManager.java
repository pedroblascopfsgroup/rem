package es.pfsgroup.plugin.recovery.coreextension.adjudicacion.manager;

import java.util.Date;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.api.AdjudicacionHandlerDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.dto.DtoCrearAnotacion;

/**
 *
 */
@Service("adjudicacionHandlerManager")
public class AdjudicacionHandlerDelegateManager implements AdjudicacionHandlerDelegateApi {
	

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_PRESENTACION)
	public void insertarFechaPresentacionCarga(Long prcId, Date fechaPresentacion) {
		
		//Este método se implementa en el nuevoModeloBienes
				
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_INS)
	public void insertarFechaInsCarga(Long prcId, Date fechaIns){
		
		//Este método se implementa en el nuevoModeloBienes
		
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_CAMBIO_CERRADURA)
	public void insertarFechaCambioCerradura(Long prcId, Date fecha) {
		//Este método se implementa en el nuevoModeloBienes
		
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_NOMBRE_ER_DEPO)
	public void insertarNombreErDepo(Long prcId, String nombre) {
		// TODO Auto-generated method stub
		
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_ENVIO)
	public void insertarFechaEnvioLlaves(Long prcId, Date fecha) {
		//Este método se implementa en el nuevoModeloBienes
		
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_RECEPCION_ER_DEPO)
	public void insertarFechaRecepcionErDepo(Long prcId, Date fecha) {
		//Este método se implementa en el nuevoModeloBienes
		
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_NOMBRE_DEPO_FINAL)
	public void insertarNombreDepoFinal(Long prcId, String nombre) {
		//Este método se implementa en el nuevoModeloBienes
		
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_RECEP_FINAL)
	public void insertarFechaRecepcionFinal(Long prcId, Date fecha) {
		// TODO Auto-generated method stub
		
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_RECEPCION_LLAVES)
	public void insertarFechaRecepcionLLaves(Long prcId, Date fecha) {
		//Este método se implementa en el nuevoModeloBienes
		
	}
	

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_SOL_MORAT)
	public void insertarFechaSolMorat(Long prcId, Date fecha) {
		//Este método se implementa en el nuevoModeloBienes
		
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_RES_MORAT)
	public void insertarFechaResMorat(Long prcId, Date fecha) {
		//Este método se implementa en el nuevoModeloBienes
		
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_CARGA_RESULTADO_MORAT)
	public void insertarResultadoMorat(Long prcId, String resultado) {
		//Este método se implementa en el nuevoModeloBienes
		
	}
	

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_POSESION_OCUPADO) 
	public void insertarPosesionComboOcupado(Long prcId, Boolean valor) {
		//Este método se implementa en el nuevoModeloBienes
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_POSESION_POSIBLE_POSESION) 
	public void insertarPosesionComboPosiblePosesion(Long prcId, Boolean valor) {
		//Este método se implementa en el nuevoModeloBienes
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SOLICITUD) 
	public void insertarPosesionFechaSolicitud(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SENYALAMIENTO) 
	public void insertarPosesionFechaSenyalamiento(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_POSESION_REALIZACION) 
	public void insertarPosesionFechaRealizacion(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_POSESION_OCUPANTES_DURANTE) 
	public void insertarPosesionComboOcupantesDurantePosesion(Long prcId, Boolean valor) {
		//Este método se implementa en el nuevoModeloBienes
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_POSESION_LANZAMIENTO_NECESARIO) 
	public void insertarPosesionComboLanzamientoNecesario(Long prcId, Boolean valor) {
		//Este método se implementa en el nuevoModeloBienes
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SOL_LANZAMIENTO) 
	public void insertarPosesionFechaSolicitudLanzamiento(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SENYALAMIENTO_LANZAMIENTO) 
	public void insertarPosesionFechaSenyalamientoLanzamiento(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_POSESION_CREAR_ANOTACION) 
	public void createAnotacion(DtoCrearAnotacion dto) {
		//Este método se implementa en el nuevoModeloBienes
	}
	

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_LANZAMIENTO_EFECTUADO) 
	public void insertarPosesionFechaLanzamientoEfectuado(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_POSESION_LLAVES_NECESARIAS) 
	public void insertarPosesionComboGestionLlaves(Long prcId, Boolean valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_POSESION_FUERZA_PUBLICA) 
	public void insertarPosesionComboFuerzaPublica(Long prcId, Boolean valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_POSESION_ENTREGA_VOLUNTARIA)
	public void insertarPosesionComboEntregaVoluntaria(Long prcId, Boolean valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_SOLICITUD_DECRETO)
	public void insertarFechaSolicitudDecreto(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_CONTABILIDAD)
	public void insertarFechaContabilidad(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_NOTIFICACION_DECRETO)
	public void insertarFechaNotificacionDecreto(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_ENTIDAD_ADJUDICATARIA)
	public void insertarEntidadAdjudicataria(Long prcId, String valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FONDO)
	public void insertarFondo(Long prcId, String valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_FECHA_NOTIF_DECRETO_AL_CONTRARIO)
	public void insertarNotificacionDecretoAlContrario(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_FECHA_SOLICITUD_TESTIMONIO_DECRETO)
	public void insertarFechaSolicitudTestimonioDecreto(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_FECHA_TESTIMONIO_DECRETO)
	public void insertarFechaTestimonioDecreto(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}	
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_FECHA_ENVIO_GESTORIA)	
	public void insertarFechaEnvioGestoria(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_FECHA_RECEPCION)
	public void insertarFechaRecepcion(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_FECHA_PRESENTACION_HACIENDA)
	public void insertarFechaPresentacionHacienda(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_FECHA_PRESENTACION_REGISTRO)
	public void insertarFechaPresentacionRegistro(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_FECHA_INSCRIPCION_TITULO)
	public void insertarFechaInscripcionTitulo(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_FECHA_ENVIO_DECRETO_ADICION)
	public void insertarFechaEnvioDecretoAdicion(Long prcId, Date valor) {
		//Este método se implementa en el nuevoModeloBienes
	}	
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_SITUACION_TITULO)
	public void insertarSituacionTitulo(Long prcId, String valor) {
		//Este método se implementa en el nuevoModeloBienes
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_GESTORIA)
	public void insertarGestoria(Long prcId) {
		//Este método se implementa en el nuevoModeloBienes		
	}
}

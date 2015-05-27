package es.pfsgroup.plugin.recovery.coreextension.adjudicacion.manager;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.api.AdjudicacionProcedimientoDelegateApi;

/**
 *
 */
@Service("adjudicacionProcedimientoManager")
public class AdjudicacionProcedimientoDelegateManager implements AdjudicacionProcedimientoDelegateApi {
	

	@Override
	@BusinessOperation(BO_ADJUDICACION_COMPROBAR_BIEN_ASOCIADO_PRC)
	public Boolean comprobarBienAsociadoPrc(Long prcId) {
		
		//Este método se implementa en el nuevoModeloBienes
				return false;
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_COMPROBAR_BIEN_ENTIDAD_ADJUDICATARIA)
	public Boolean comprobarBienEntidadAdjudicataria(Long bienId){
		
		//Este método se implementa en el nuevoModeloBienes
				return false;
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_COMPROBAR_BIEN_ENTIDAD_ADJ_TERCEROS)
	public Boolean comprobarBienEntidadAdjudicatariaTerceros(Long bienId){
		
		//Este método se implementa en el nuevoModeloBienes
				return false;
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_COMPROBAR_TIPO_CARGA_BIEN_INSCRITO)
	public Boolean comprobarTipoCargaBienInscrito(Long prcId) {
		//Este método se implementa en el nuevoModeloBienes
				return false;
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_COMPROBAR_ESTADO_CARGAS_CANCELACION)
	public Boolean comprobarEstadoCargasCancelacion(Long prcId) {
		//Este método se implementa en el nuevoModeloBienes
				return false;
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_COMPROBAR_ADJUNTO)
	public Boolean comprobarAdjunto(Long prcId, String tipo) {
		
		//Este método se implementa en el nuevoModeloBienes
				return false;
		
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_COMPROBAR_ADJUNTO_ASUNTO)
	public Boolean comprobarAdjuntoAsunto(Long asuId, String tipo) {
		
		//Este método se implementa en el nuevoModeloBienes
				return false;
		
	}
	
	@Override
	@BusinessOperation(BO_ADJUDICACION_COMPROBAR_ADJUNTO_PROPUESTA_CANCELACION_CARGAS)
	public Boolean comprobarAdjuntoPropuestaCancelacionCargas(Long prcId) {
		
		//Este método se implementa en el nuevoModeloBienes
				return false;
		
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_COMPROBAR_ESTADO_CARGAS_PROPUESTA)
	public Boolean comprobarEstadoCargasPropuesta(Long prcId) {
		
		//Este método se implementa en el nuevoModeloBienes
				return false;
	
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_OBTENER_TIPO_CARGA)
	public String obtenerTipoCarga(Long prcId) {
		
		//Este método se implementa en el nuevoModeloBienes
		return "";
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_COMPROBAR_GESTORIA_ASIGNADA_PRC)
	public Boolean comprobarGestoriaAsignadaPrc(Long prcId) {
		//Este método se implementa en el nuevoModeloBienes
		return null;
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_COMPROBAR_GESTORIA_ASIGNADA_SANEAMIENTO_CARGAS_BIENES)
	public Boolean comprobarGestoriaAsignadaAlSaneamientoDeCargasDeBienes(Long prcId) {
		//Este método se implementa en el nuevoModeloBienes
		return null;
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_VIENE_DE_TRAMITE_POSESION)
	public Boolean vieneDeTramitePosesion(Long prcId) {
		//Este método se implementa en el nuevoModeloBienes
		return null;
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_ESTAMOS_A_DOS_MESES)
	public Boolean estamosADosMeses(Long prcId) {
		//Este método se implementa en el nuevoModeloBienes
		return null;
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_COMPROBAR_FECHA_REVISION)
	public Boolean comprobarFechaRevision(Long prcId) {
		//Este método se implementa en el nuevoModeloBienes
		return null;
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_EXISTE_BIEN_CON_ADJU_ENTIDAD)
	public Boolean existeBienConAdjudicacionE(Long prcId) {
		//Este método se implementa en el nuevoModeloBienes
		return null;
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_ES_BIEN_CON_CESION_REMATE)
	public Boolean esBienConCesionRemate(Long bieId) {
		//Este método se implementa en el nuevoModeloBienes
		return null;
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_COMPROBAR_BIEN_SUJETO_IVA)
	public String comprobarBienSujetoIVA(Long prcId) {
		// Este metodo se implementa en el nuevoModeloBienes
		return null;
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_COMPROBAR_BIENES_ASOCIADO_PRC)
	public Boolean comprobarBienesAsociadoPrc(Long prcId) {
		// Este metodo se implementa en el nuevoModeloBienes
		return null;
	}

	@Override
	@BusinessOperation(BO_ADJUDICACION_COMPROBAR_BIEN_ENTIDAD_ADJUDICATARIA_DECRETO)
	public Boolean comprobarBienEntidadAdjudicatariaConDecreto(Long bienId) {
		// Este metodo se implementa en el nuevoModeloBienes
		return null;
	}
}

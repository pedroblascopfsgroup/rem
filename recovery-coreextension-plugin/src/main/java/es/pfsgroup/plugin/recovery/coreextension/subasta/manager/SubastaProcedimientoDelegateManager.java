package es.pfsgroup.plugin.recovery.coreextension.subasta.manager;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda.InformeValidacionCDDDto;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteBien;

/**
 *
 */
@Service("nmbSubastaProcedimientoManager")
public class SubastaProcedimientoDelegateManager implements SubastaProcedimientoDelegateApi {

	
	@BusinessOperation(BO_SUBASTA_IS_BIEN_WITH_TIPO_SUBASTA)
	public Boolean isTipoSubasta(Long bienId){
		
		//Se implementa en el Nuevo modelo de bienes
		return false;
	}
	
	/**
	 * Método que devuelve true si al menos uno de los bienes asociados a la
	 * subasta se encuentra en obras
	 */
	@Override
	@BusinessOperation(BO_SUBASTA_COMPROBAR_OBRA_EN_CURSO)
	public boolean comprobarObraEnCurso(Long prcId) {
		// Este método se implementa en el nuevoModeloBienes
		return false;
	}
	
	@Override
	@BusinessOperation(BO_SUBASTA_COMPROBAR_BIEN_INFORMADO)
	public boolean comprobarBienInformado(Long prcId) {
		// Este método se implementa en el nuevoModeloBienes
		return false;
	}
	
	@Override
	@BusinessOperation(BO_SUBASTA_TIENE_ALGUN_BIEN_CON_FICHA_SUBASTA)
	public boolean tieneAlgunBienConFichaSubasta2(Long prcId) {
		// Este método se implementa en el nuevoModeloBienes
		return false;				
	}
	
	/**
	 * Por cada bien, debe tener informado el importe adjudicación y la entidad
	 */
	@Override
	@BusinessOperation(BO_SUBASTA_IMPORTE_ENTIDAD_ADJUDICACION_BIENES)
	public boolean comprobarImporteEntidadAdjudicacionBienes(Long prcId) {
		// Este método se implementa en el nuevoModeloBienes
		return false;	
	}
	
	/**
	 * Método que devuelve la decisión de Registrar subasta
	 */
	@Override
	@BusinessOperation(BO_SUBASTA_DECIDIR_REGISTRAR_ACTA_SUBASTA)
	public String decidirRegistrarActaSubasta(Long prcId) {
		// Este método se implementa en el nuevoModeloBienes
		return null;
	}
	
	/**
	 * Método que devuelve las instrucciones de cesión de remate
	 */
	@Override
	@BusinessOperation(BO_SUBASTA_OBTENER_INSTRUCCIONES_CESION_REMATE)
	public String obtenerInstruccionesCesionRemate(Long prcId) {
		// Este método se implementa en el nuevoModeloBienes
		return null;
	}

	
	@Override
	@BusinessOperation(BO_SUBASTA_COMPROBAR_TIPO_SUBASTA_INFORMADO)
	public boolean comprobarTipoSubastaInformado(Long prcId) {
		// Este método se implementa en el nuevoModeloBienes
		return false;
	}
	
	//HAYA
	@Override
	@BusinessOperation(BO_SUBASTA_COMPROBAR_DUE_DILLIGENCE)
	public boolean comprobarDueDilligence(Long prcId) {
		//  Este metodo se implementa en el nuevoModeloBienes
		return false;
	}
		
	//HAYA
	@Override
	@BusinessOperation(BO_SUBASTA_COMPROBAR_FECHA_RECEPCION_DUE_DILLIGENCE)
	public boolean comprobarFechaRecepcionDue(Long prcId) {
		//  Este metodo se implementa en el nuevoModeloBienes
		return false;
	}
	
	//BANKIA
	@Override
	@BusinessOperation(BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_PRE)
	public String validacionesCelebracionSubastaPRE(Long prcId) {
		//  Este metodo se implementa en el nuevoModeloBienes
		return null;
	}
	
	//BANKIA
	@Override
	@BusinessOperation(BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_POST)
	public String validacionesCelebracionSubastaPOST(Long prcId) {
		//  Este metodo se implementa en el nuevoModeloBienes
		return null;
	}
	
	//BANKIA
	@Override
	@BusinessOperation(BO_SUBASTA_VALIDACIONES_CONFIRMAR_TESTIMONIO_PRE)
	public String validacionesConfirmarTestimonioPRE(Long prcId) {
		//  Este metodo se implementa en el nuevoModeloBienes
		return null;
	}
	
	//BANKIA
	@Override
	@BusinessOperation(BO_SUBASTA_VALIDACIONES_CONFIRMAR_TESTIMONIO_POST)
	public String validacionesConfirmarTestimonioPOST(Long prcId) {
		//  Este metodo se implementa en el nuevoModeloBienes
		return null;
	}

	//HAYA
	@Override
	@BusinessOperation(BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_ADJUDICACION)
	public boolean comprobarAdjudicacionBienesCelebracionSubasta(Long prcId) {
	//  Este metodo se implementa en el nuevoModeloBienes
		return false;
	}
	
	//HAYA
	@Override
	@BusinessOperation(BO_SUBASTA_VALIDACIONES_CELEBRACION_SUBASTA_ADJUDICACION_DOC)
	public boolean comprobarAdjudicacionDocBienesCelebracionSubasta(Long prcId) {
	//  Este metodo se implementa en el nuevoModeloBienes
		return false;
	}


	//BANKIA
	@Override
	@BusinessOperation(BO_SUBASTA_COMPROBAR_NUMERO_ACTIVO)
	public boolean comprobarNumeroActivo(Long prcId) {
		//  Este metodo se implementa en el nuevoModeloBienes
		return false;		
	}

	//BANKIA
	@Override
	@BusinessOperation(BO_SUBASTA_VALIDACIONES_CONTRATOS_CONFIRMAR_TESTIMONIO_POST)
	public boolean validacionesContratosConfirmarTestimonioPOST(Long prcId) {
		//  Este metodo se implementa en el nuevoModeloBienes
		return false;
	}

	@Override
	@BusinessOperation(BO_SUBASTA_GENERAR_INFORME_VALIDACION_CDD)
	public InformeValidacionCDDDto generarInformeValidacionCDD(Long idSubasta, String idsBien) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	@BusinessOperation(BO_SUBASTA_GET_LOTE_BY_PRC_BIEN)
	public LoteBien getLoteByPrcBien(Long idProcedimiento, Long idBien) {
		// TODO Auto-generated method stub
		return null;
	}

}

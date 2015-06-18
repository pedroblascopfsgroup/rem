package es.pfsgroup.plugin.recovery.nuevoModeloBienes.api;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoLoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDResultadoComite;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;


public class NMBProjectContextImpl implements NMBProjectContext {

	public static final String CONST_TIPO_PROCEDIMIENTO_ADJUDICACION = "ADJUDICACION";
	public static final String CONST_TIPO_PROCEDIMIENTO_SANEAMIENTO = "SANEAMIENTO";
	public static final String CONST_TIPO_PROCEDIMIENTO_POSESION = "POSESION";
	public static final String CONST_TIPO_PROCEDIMIENTO_GESTION_LLAVES = "GESTION-LLAVES";
	
	public static final String CONST_TAREA_CELEBRACION_SUBASTA_SAREB = "CelebracionSubastaSareb";
	public static final String CONST_TAREA_SENYALAMIENTO_SUBASTA_SAREB = "SenyalamientoSubastaSareb";
	public static final String CONST_TAREA_CELEBRACION_SUBASTA_SAREB_CONCURSAL = "CelebracionSubastaConcursal";
	public static final String CONST_TAREA_SENYALAMIENTO_SUBASTA_SAREB_CONCURSAL = "SenyalamientoSubastaConcursal";
	public static final String CONST_TAREA_CELEBRACION_SUBASTA_SAREB_TERCEROS = "CelebracionSubastaTerceros";
	public static final String CONST_TAREA_SENYALAMIENTO_SUBASTA_SAREB_TERCEROS = "SenyalamientoSubastaTerceros";
	
	public static final String CONST_TAREA_CELEBRACION_SUBASTA_BANKIA = "CelebracionSubastaBankia";
	public static final String CONST_TAREA_SENYALAMIENTO_SUBASTA_BANKIA = "SenyalamientoSubastaBankia";
	public static final String CONST_TAREA_CELEBRACION_SUBASTA_SAREB_BNK = "CelebracionSubastaSarebBankia";
	public static final String CONST_TAREA_SENYALAMIENTO_SUBASTA_SAREB_BNK = "SenyalamientoSubastaSarebBankia";
	
	public static final String CONST_TAREA_ADJUDICACION_CONFIRMAR_CONTABILIDAD = "ConfirmarContabilidad";
	public static final String CONST_TAREA_CONTABILIZAR_ACTIVOS_CDD_BNK = "ContabilizarActivosCDDBNK";
	public static final String CONST_TAREA_CONTABILIZAR_ACTIVOS_CDD_SAREB = "ContabilizarActivosCDDSAREB";
	
	public static final String ADJUDICACION_TAREA_CONFIRMAR_TESTIMONIO = "ConfirmarTestimonio";

	
	private Set<String> tareasStopValidarLotesSubasta;
	private Long nivelZonaOficinaGestoraEnInformes;
	private List<String> tiposPrcAdjudicados;
	private Map<String, String> mapaTiposPrc;
	private Map<String, String> tareasCierreDeuda;
	private List<String> codigosSubastaValidacion;
	private List<String> codigosSubastas;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	/**
	 * Devuelve las tareas Stop para validar Lotes de Subasta.
	 * 
	 * @return Listado de tareas
	 */
	@Override
	public Set<String> getTareasStopValidarLotesSubasta() {
		return tareasStopValidarLotesSubasta;
	}

	public void setTareasStopValidarLotesSubasta(Set<String> valor) {
		this.tareasStopValidarLotesSubasta = valor;
	}

	/**
	 * Id del nivel del centro gestor a partir del cual consideramos padres de una oficina para pintar en informe.
	 * 
	 * @return
	 */
	@Override
	public Long getNivelZonaOficinaGestoraEnInformes() {
		return nivelZonaOficinaGestoraEnInformes;
	}

	public void setNivelZonaOficinaGestoraEnInformes(Long valor) {
		this.nivelZonaOficinaGestoraEnInformes = valor;
	}
	
	/**
	 * Devuelve los tipos de procedimientos que son de adjudicados
	 */
	@Override
	public List<String> getTiposProcedimientosAdjudicados() {
		return tiposPrcAdjudicados;
	}

	public void setTiposProcedimientosAdjudicados(List<String> tiposPrcAdjudicados) {
		this.tiposPrcAdjudicados = tiposPrcAdjudicados;
	}
	
	@Override
	public Map<String, String> getMapaTiposPrc() {
		return mapaTiposPrc;
	}

	public void setMapaTiposPrc(Map<String, String> mapaTiposPrc) {
		this.mapaTiposPrc = mapaTiposPrc;
	}
	
	
	/**
	 * Completa la tarea Validar Propuestas según el BPM de subastas como se hubiera realizado desde el formulario.
	 *  
	 * @param subasta
	 * @param dtoForm
	 * @param tareaExterna
	 * @param estado
	 * @param codMotivoSuspSubasta
	 * @param observaciones
	 */
	@Override
	public String[] valoresTareaValidarPropuestaDesdeCambioMasivoLotes(Subasta subasta, String[] nombresItems, TareaExterna tareaExterna, DDEstadoLoteSubasta estado, String codMotivoSuspSubasta, String observaciones) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String[] valores = new String[nombresItems.length];
		for (int current=0; current<valores.length; current++) {
			String nombreItem = nombresItems[current];
			if ("comboTipo".equals(nombreItem)) {
				valores[current] = subasta.getTipoSubasta().getCodigo();
			}
			if ("comboResultado".equals(nombreItem)) {
				if (DDEstadoLoteSubasta.SUSPENDIDA.equals(estado.getCodigo())) {
					valores[current] = DDResultadoComite.SUSPENDER;
				} else if (DDEstadoLoteSubasta.DEVUELTA.equals(estado.getCodigo())) {
					valores[current] = DDResultadoComite.RECTIFICAR;
				} else if (DDEstadoLoteSubasta.APROBADA.equals(estado.getCodigo())) {
					valores[current] = DDResultadoComite.ACEPTADA;	
				}
			}
			if ("comboSuspension".equals(nombreItem)) {
				if (DDEstadoLoteSubasta.SUSPENDIDA.equals(estado.getCodigo())) {
					valores[current] = DDSiNo.SI;
				} else {
					valores[current] = DDSiNo.NO;
				}
			}
			if (DDEstadoLoteSubasta.SUSPENDIDA.equals(estado.getCodigo()) && "motivoSuspension".equals(nombreItem)) {
				valores[current] = codMotivoSuspSubasta;
			}
			if ("fechaDecision".equals(nombreItem)) {
				valores[current] = sdf.format(new Date());
			}
			if ((DDEstadoLoteSubasta.SUSPENDIDA.equals(estado.getCodigo()) || 
					DDEstadoLoteSubasta.DEVUELTA.equals(estado.getCodigo())) && "observaciones".equals(nombreItem)) {
				valores[current] = observaciones;
			}
		}
		return valores;
	}

	/**
	 * Actualiza el lote según la información de la tarea y la decisión que se ha tomado.
	 * 
	 * @param lote
	 * @param tarea
	 * @param decision
	 */
	@Override
	public void actualizaLoteSubastaSegunInformacionTarea(LoteSubasta lote, List<EXTTareaExternaValor> listadoTareaValor, String decision) {
		// Recorre los valores recupera la observacion.
		String observacionesComite = null;
		String fechaDecision = null;
		for (EXTTareaExternaValor tareaExternaValor : listadoTareaValor) {
			if (tareaExternaValor.getNombre().equals("observaciones")) {
				observacionesComite = tareaExternaValor.getValor();
			}
			if (tareaExternaValor.getNombre().equals("fechaDecision")) {
				fechaDecision = tareaExternaValor.getValor();
			}
		}
		
		Date fecha = new Date();
		try {
		if (!Checks.esNulo(fechaDecision)) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			fecha = sdf.parse(fechaDecision);
		}
		} catch (ParseException parseEx) {
			// No hace nada, coge la fecha de hoy
		}
		
		// Actualiza estado del lote
		String codEstado = ("ModificarInstrucciones".equals(decision))
				? DDEstadoLoteSubasta.DEVUELTA
				: ("SuspenderSubasta".equals(decision)) 
					? DDEstadoLoteSubasta.SUSPENDIDA
					: DDEstadoLoteSubasta.APROBADA;
					
		
		DDEstadoLoteSubasta estadoLote = (DDEstadoLoteSubasta)diccionarioApi.dameValorDiccionarioByCod(DDEstadoLoteSubasta.class, codEstado);
		lote.setObservacionesComite(observacionesComite);
		lote.setEstado(estadoLote);;
		lote.setFechaEstado(fecha);
	}
	
	@Override
	public Map<String, String> getTareasCierreDeuda() {
		return tareasCierreDeuda;
	}

	public void setTareasCierreDeuda(Map<String, String> tareasCierreDeuda) {
		this.tareasCierreDeuda = tareasCierreDeuda;
	}

	public List<String> getCodigosSubastaValidacion(){
		
		return codigosSubastaValidacion; 
		
	}
	
	public void setCodigosSubastaValidacion( List<String> codigosSubastaValidacion ){
		
		this.codigosSubastaValidacion = codigosSubastaValidacion; 
	}
	
	public List<String> getCodigosSubastas(){
		
		return codigosSubastas;
		
	}
	
	public void setCodigosSubastas(List<String> codigosSubastas){
		
		this.codigosSubastas = codigosSubastas ;
		
	}
	
}
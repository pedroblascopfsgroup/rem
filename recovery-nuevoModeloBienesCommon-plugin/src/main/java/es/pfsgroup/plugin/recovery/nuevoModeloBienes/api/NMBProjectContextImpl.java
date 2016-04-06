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
	
	public static final String ADJUDICACION_TAREA_CONFIRMAR_TESTIMONIO = "ConfirmarTestimonio";
	public static final String SUBASTA_BANKIA_TAREA_CONTABILIZAR_CDD = "ContabilizarCierreDeuda";
	
	public static final String SUBASTA_BANKIA = "BANKIA";
	public static final String SUBASTA_SAREB = "SAREB";
	
	private Set<String> tareasStopValidarLotesSubasta;
	private Long nivelZonaOficinaGestoraEnInformes;
	private List<String> tiposPrcAdjudicados;
	private Map<String, String> mapaTiposPrc;
	private Map<String, String> tareasCierreDeuda;
	private Map<String, String> mapaSubastas;
	private List<String> codigosSubastaValidacion;
	private List<String> codigosSubastas;
        private String codigoSubastaBankia;
	private String comboPostoresCelebracionSubasta;
	//Valores para generar informe de subasta
	private String valorHonorarios;
	private String valorDerechosSuplidos;
	private String fechaDemandaHipotecario;
	private String fechaDemandaMonitorio;
	private String fechaDemandaOrdinario;
	private List<String> codigosTareasSenyalamiento;
	private String codigoTareaDemandaHipotecario;
	private String codigoTareaDemandaMonitorio;
	private String codigoTareaDemandaOrdinario;
	private String codigoHipotecario;
	
	private String codigoMonitorio;
	private String codigoOrdinario;

	private String codigoRegistrarSolicitudMoratoria;
	private String fechaSolicitudRegistrarSolicitudMoratoria;
	private String codigoRegistrarResolucionMoratoria;
	private String fechaFinMoratoriaRegistrarResolucion;
	private String resultadoMoratoria;
	
	private String plantillaReportPropuestaCancelacionCargas;
	
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
			if ("observaciones".equals(tareaExternaValor.getNombre())) {
				observacionesComite = tareaExternaValor.getValor();
			}
			if ("fechaDecision".equals(tareaExternaValor.getNombre())) {
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
		lote.setEstado(estadoLote);
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
        

        @Override
        public String getCodigoSubastaBankia() {
            return codigoSubastaBankia;
        }

        public void setCodigoSubastaBankia(String codigoSubastaBankia) {
            this.codigoSubastaBankia = codigoSubastaBankia;
        }
	
	@Override
	public String getComboPostoresCelebracionSubasta() {
		return comboPostoresCelebracionSubasta;
	}
	
	public void setComboPostoresCelebracionSubasta(String comboPostoresCelebracionSubasta) {
		this.comboPostoresCelebracionSubasta = comboPostoresCelebracionSubasta;
	}
	
	@Override
	public Map<String, String> getMapaSubastas() {
		return mapaSubastas;
	}
	
	public void setMapaSubastas(Map<String, String> mapaSubastas) {
		this.mapaSubastas = mapaSubastas;
	}
	
	@Override
	public String getValorHonorarios() {
		return valorHonorarios;
	}

	public void setValorHonorarios(String valorHonorarios) {
		this.valorHonorarios = valorHonorarios;
	}
	
	@Override
	public String getValorDerechosSuplidos() {
		return valorDerechosSuplidos;
	}

	public void setValorDerechosSuplidos(String valorDerechosSuplidos) {
		this.valorDerechosSuplidos = valorDerechosSuplidos;
	}
	
	@Override
	public String getFechaDemandaHipotecario() {
		return fechaDemandaHipotecario;
	}

	public void setFechaDemandaHipotecario(String fechaDemandaHipotecario) {
		this.fechaDemandaHipotecario = fechaDemandaHipotecario;
	}
	
	@Override
	public String getFechaDemandaMonitorio() {
		return fechaDemandaMonitorio;
	}

	public void setFechaDemandaMonitorio(String fechaDemandaMonitorio) {
		this.fechaDemandaMonitorio = fechaDemandaMonitorio;
	}

	@Override
	public String getFechaDemandaOrdinario() {
		return fechaDemandaOrdinario;
	}

	public void setFechaDemandaOrdinario(String fechaDemandaOrdinario) {
		this.fechaDemandaOrdinario = fechaDemandaOrdinario;
	}
	
	@Override
	public List<String> getCodigosTareasSenyalamiento() {
		return codigosTareasSenyalamiento;
	}

	public void setCodigosTareasSenyalamiento(
			List<String> codigosTareasSenyalamiento) {
		this.codigosTareasSenyalamiento = codigosTareasSenyalamiento;
	}
	
	@Override
	public String getCodigoTareaDemandaHipotecario() {
		return codigoTareaDemandaHipotecario;
	}

	public void setCodigoTareaDemandaHipotecario(
			String codigoTareaDemandaHipotecario) {
		this.codigoTareaDemandaHipotecario = codigoTareaDemandaHipotecario;
	}
	
	@Override
	public String getCodigoTareaDemandaMonitorio() {
		return codigoTareaDemandaMonitorio;
	}

	public void setCodigoTareaDemandaMonitorio(String codigoTareaDemandaMonitorio) {
		this.codigoTareaDemandaMonitorio = codigoTareaDemandaMonitorio;
	}
	
	@Override
	public String getCodigoTareaDemandaOrdinario() {
		return codigoTareaDemandaOrdinario;
	}

	public void setCodigoTareaDemandaOrdinario(String codigoTareaDemandaOrdinario) {
		this.codigoTareaDemandaOrdinario = codigoTareaDemandaOrdinario;
	}
	
	@Override
	public String getCodigoHipotecario() {
		return codigoHipotecario;
	}

	public void setCodigoHipotecario(String codigoHipotecario) {
		this.codigoHipotecario = codigoHipotecario;
	}
	
	@Override
	public String getCodigoMonitorio() {
		return codigoMonitorio;
	}

	public void setCodigoMonitorio(String codigoMonitorio) {
		this.codigoMonitorio = codigoMonitorio;
	}
	
	@Override
	public String getCodigoOrdinario() {
		return codigoOrdinario;
	}

	public void setCodigoOrdinario(String codigoOrdinario) {
		this.codigoOrdinario = codigoOrdinario;
	}
	
	@Override
	public String getCodigoRegistrarSolicitudMoratoria() {
		return codigoRegistrarSolicitudMoratoria;
	}

	public void setCodigoRegistrarSolicitudMoratoria(String codigoRegistrarSolicitudMoratoria) {
		this.codigoRegistrarSolicitudMoratoria = codigoRegistrarSolicitudMoratoria;
	}

	@Override
	public String getFechaSolicitudRegistrarSolicitudMoratoria() {
		return fechaSolicitudRegistrarSolicitudMoratoria;
	}

	public void setFechaSolicitudRegistrarSolicitudMoratoria(String fechaSolicitudRegistrarSolicitudMoratoria) {
		this.fechaSolicitudRegistrarSolicitudMoratoria = fechaSolicitudRegistrarSolicitudMoratoria;
	}

	@Override
	public String getCodigoRegistrarResolucionMoratoria() {
		return codigoRegistrarResolucionMoratoria;
	}

	public void setCodigoRegistrarResolucionMoratoria(String codigoRegistrarResolucionMoratoria) {
		this.codigoRegistrarResolucionMoratoria = codigoRegistrarResolucionMoratoria;
	}
	
	@Override
	public String getFechaFinMoratoriaRegistrarResolucion() {
		return fechaFinMoratoriaRegistrarResolucion;
	}

	public void setFechaFinMoratoriaRegistrarResolucion(String fechaFinMoratoriaRegistrarResolucion) {
		this.fechaFinMoratoriaRegistrarResolucion = fechaFinMoratoriaRegistrarResolucion;
	}

	@Override
	public String getResultadoMoratoria() {
		return resultadoMoratoria;
	}

	public void setResultadoMoratoria(String resultadoMoratoria) {
		this.resultadoMoratoria = resultadoMoratoria;
	}

	public String getPlantillaReportPropuestaCancelacionCargas() {
		return plantillaReportPropuestaCancelacionCargas;
	}

	public void setPlantillaReportPropuestaCancelacionCargas(String plantillaReportPropuestaCancelacionCargas) {
		this.plantillaReportPropuestaCancelacionCargas = plantillaReportPropuestaCancelacionCargas;
	}
	
	
}
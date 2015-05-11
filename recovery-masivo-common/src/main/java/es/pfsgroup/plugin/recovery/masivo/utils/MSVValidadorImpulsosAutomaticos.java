package es.pfsgroup.plugin.recovery.masivo.utils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVProcesoImpulsoDao;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

public class MSVValidadorImpulsosAutomaticos {

	static private final String PREFIJO_MENSAJE = "No está informado el dato ";
	static private final String SUFIJO_MENSAJE = ". ";
	static private final String PROCURADOR_VACIO = "PR000000";

	static public final String CAMPO_CASO_NOVA = "pre_caso_nova";
	static public final String CAMPO_PLAZA = "pre_plaza";
	static public final String CAMPO_JUZGADO = "pre_juzgado";
	static public final String CAMPO_PROCURADOR = "pre_procurador";
	static public final String CAMPO_PROPIETARIO = "pre_propietario";
	static public final String CAMPO_TIPO_PROCEDIMIENTO = "pre_tipo_procedimiento";
	static public final String CAMPO_NUMERO_AUTOS = "pre_numero_autos";
	static public final String CAMPO_NOMBRE_DEMANDADO = "pre_nombre_demandado";
	static public final String CAMPO_ULTIMA_RESOLUCION = "pre_ultima_resolucion";
	static public final String CAMPO_FECHA_GENERACION_ESCRITO = "pre_fecha_generacion_escrito";
	
	static private Map<String, String> mapaCamposAValidar = new HashMap<String, String>();
	static {
		mapaCamposAValidar.put(CAMPO_CASO_NOVA, "CASO NOVA");
		mapaCamposAValidar.put(CAMPO_PLAZA, "PLAZA");
		mapaCamposAValidar.put(CAMPO_JUZGADO, "JUZGADO");
		mapaCamposAValidar.put(CAMPO_PROCURADOR, "PROCURADOR");
		mapaCamposAValidar.put(CAMPO_PROPIETARIO, "PROPIETARIO");
		mapaCamposAValidar.put(CAMPO_TIPO_PROCEDIMIENTO, "TIPO PROCEDIMIENTO");
		mapaCamposAValidar.put(CAMPO_NUMERO_AUTOS, "NUMERO_AUTOS");
		mapaCamposAValidar.put(CAMPO_NOMBRE_DEMANDADO, "NOMBRE DEMANDADO");
		mapaCamposAValidar.put(CAMPO_ULTIMA_RESOLUCION, "ULTIMA RESOLUCION");
		mapaCamposAValidar.put(CAMPO_FECHA_GENERACION_ESCRITO, "FECHA GENERACIÓN ESCRITO");
	}
	
	private Procedimiento procedimiento;
	private Asunto asunto;
	private Boolean conProcurador;
	private GenericABMDao genericDao;
	private Date fechaProceso;
	private MSVProcesoImpulsoDao procesoImpulsoDao;
	private EXTTareaExterna tareaExterna;

	private EXTContrato contrato;
	private Map<String, String> mapaValores;

	public MSVValidadorImpulsosAutomaticos(Procedimiento procedimiento,
			Boolean conProcurador,
			GenericABMDao genericDao,
			Date fechaProceso,
			MSVProcesoImpulsoDao procesoImpulsoDao, EXTTareaExterna tareaExterna) {
		
		this.procedimiento = procedimiento;
		this.asunto = procedimiento.getAsunto();
		this.conProcurador = conProcurador;
		this.genericDao = genericDao;
		this.fechaProceso = fechaProceso;
		this.procesoImpulsoDao = procesoImpulsoDao;
		this.tareaExterna = tareaExterna;
		
		this.contrato = obtenerContrato();
		
	}


	/**
	 * Comprobar que las variables necesarias para la generación del escrito 
	 * tienen valores válidos
	 * 
	 * @return String con la descripción de los errores detectados
	 */
	public String comprobarErrores() {
		
		StringBuilder resultado = new StringBuilder("");
		
		for (String claveDato : mapaCamposAValidar.keySet()) {
			if (!mapaValores.containsKey(claveDato) ||
						mapaValores.get(claveDato) == null ||
						mapaValores.get(claveDato).equals("")) {
				if (claveDato.equals(CAMPO_PROCURADOR)) {
					if (conProcurador == true) {
						resultado.append(PREFIJO_MENSAJE + mapaCamposAValidar.get(claveDato) + SUFIJO_MENSAJE);
					}
				} else {
					resultado.append(PREFIJO_MENSAJE + mapaCamposAValidar.get(claveDato) + SUFIJO_MENSAJE);
				}
			}
		}
		
		return resultado.toString();
	}


	@SuppressWarnings("unchecked")
	public Map<String, String> obtenerValoresPrecalculados() {
		
		@SuppressWarnings("rawtypes")
		Map mapaValores = new HashMap<String, String>();
		
		for (String claveDato : mapaCamposAValidar.keySet()) {
			String resultado = obtenerValor(claveDato);
			mapaValores.put(claveDato, resultado);
		}
		
		this.mapaValores = mapaValores;
		return mapaValores;
	}

	private EXTContrato obtenerContrato() {
		EXTContrato contrato = null;
		try {
			contrato = (EXTContrato) (asunto.getContratos().toArray()[0]);
		} catch (Exception e) {}
		return contrato;
	}
	
	private String obtenerValor(String clave) {
		
		String resultado = "";
		
		if (CAMPO_CASO_NOVA.equals(clave)) {
			resultado = obtenerCasoNova();
		} else if (CAMPO_PLAZA.equals(clave)) {
			resultado = obtenerPlaza();
		} else if (CAMPO_JUZGADO.equals(clave)) {
			resultado = obtenerJuzgado();
		} else if (CAMPO_PROCURADOR.equals(clave)) {
			resultado = obtenerProcurador();
		} else if (CAMPO_PROPIETARIO.equals(clave)) {
			resultado = obtenerPropietario();
		} else if (CAMPO_TIPO_PROCEDIMIENTO.equals(clave)) {
			resultado = obtenerTipoProcedimiento();
		} else if (CAMPO_NUMERO_AUTOS.equals(clave)) {
			resultado = obtenerNumeroAutos();
		} else if (CAMPO_NOMBRE_DEMANDADO.equals(clave)) {
			resultado = obtenerNombreDemandado();
		} else if (CAMPO_ULTIMA_RESOLUCION.equals(clave)) {
			resultado = obtenerUltimaResolucion();
		} else if (CAMPO_FECHA_GENERACION_ESCRITO.equals(clave)) {
			resultado = obtenerFechaGeneracionEscrito();
		}
		
		return resultado;
		
	}


	private String obtenerCasoNova() {
		String resultado = "";
		try {
			resultado = contrato.getNroContrato().toString();
		} catch (NullPointerException e) {}
		return resultado;
	}


	private String obtenerPlaza() {
		String resultado = "";
		try {
			resultado = procedimiento.getJuzgado().getPlaza().getDescripcion();
		} catch (NullPointerException e) {}
		return resultado;
	}


	private String obtenerJuzgado() {
		String resultado = "";
		try {
			resultado = procedimiento.getJuzgado().getDescripcionLarga();
		} catch (NullPointerException e) {}
		return resultado;
	}


	private String obtenerProcurador() {
		String resultado = "";
		
		Filter filtroAsunto = genericDao.createFilter(FilterType.EQUALS, "asunto.id", asunto.getId());
		Filter filtroTipoProcurador = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", EXTDDTipoGestor.CODIGO_TIPO_GESTOR_PROCURADOR);
		EXTGestorAdicionalAsunto procurador = genericDao.get(EXTGestorAdicionalAsunto.class, filtroAsunto, filtroTipoProcurador);
		
		if (procurador != null) {
			Usuario usuarioProcurador = null;
			try {
				usuarioProcurador = procurador.getGestor().getUsuario();
			} catch (NullPointerException e) {}
			if (usuarioProcurador != null && !PROCURADOR_VACIO.equals(usuarioProcurador.getUsername())) {
				resultado = usuarioProcurador.getNombre() + " " +
						usuarioProcurador.getApellido1() + " " + 
						usuarioProcurador.getApellido2();
				resultado = resultado.trim(); 
			}
		}
		return resultado;
	}


	private String obtenerPropietario() {
		String resultado = "";
		resultado = procesoImpulsoDao.getPropietario(contrato.getId());
		return resultado;
	}


	private String obtenerTipoProcedimiento() {
		String resultado = "";
		try {
			resultado = procedimiento.getTipoProcedimiento().getDescripcionLarga();
		} catch (NullPointerException e) {}
		return resultado;
	}

	private String obtenerNumeroAutos() {
		String resultado = "";
		if (procedimiento.getCodigoProcedimientoEnJuzgado() != null) {
			resultado = procedimiento.getCodigoProcedimientoEnJuzgado();
		}
		return resultado;
	}


	private String obtenerNombreDemandado() {
		String resultado = "";
		Persona demandadoPrincipal = null;
		if (!Checks.esNulo(contrato) && !Checks.esNulo(contrato.getPrimerTitular())) { 
			demandadoPrincipal = contrato.getPrimerTitular();
			List<Persona> personasAfectadas = procedimiento.getPersonasAfectadas();
			if (!personasAfectadas.contains(demandadoPrincipal)) {
				if (personasAfectadas != null && personasAfectadas.get(0) != null) {
					demandadoPrincipal = personasAfectadas.get(0);
				}
			}
		}
		if (demandadoPrincipal != null && demandadoPrincipal.getNom50() != null) {
			resultado = demandadoPrincipal.getNom50() + " (" + demandadoPrincipal.getDocId() + ")";
		}
		return resultado;
	}


	private String obtenerUltimaResolucion() {
		String resultado = "";
		// Consultamos la última resolución (último input) asociadas al procedimiento
		Filter filtroProc = genericDao.createFilter(FilterType.EQUALS,
				"idProcedimiento", procedimiento.getId());
		Order orderFechaDesc = new Order(OrderType.DESC,"auditoria.fechaCrear"); 
		List<RecoveryBPMfwkInput> listaInputs = genericDao.getListOrdered(RecoveryBPMfwkInput.class, 
				orderFechaDesc, filtroProc);
		if (listaInputs != null && listaInputs.size() > 0) {
			// Obtener la última resolución que pertenezca al grupo de inputs impulsables
			for (RecoveryBPMfwkInput input : listaInputs) {
				if (MSVTiposInputImpulsables.listaInputsImpulsables.contains(input.getCodigoTipoInput())) {
					resultado = input.getTipo().getDescripcion();
					break;
				}
			}
		}
		// Si no hay ninguna resolución que pertenezca al grupo de inputs impulsables,
		//  obtener la resolución por defecto en base a la última tarea activa del procedimiento
		if (resultado.equals("")) {
			resultado = obtenerInputPorDefectoParaUltimaTarea();
		}
		return resultado;
	}


	private String obtenerInputPorDefectoParaUltimaTarea() {
		String descTarea = tareaExterna.getTareaPadre().getDescripcionTarea();
		String resultado = procesoImpulsoDao.getInputPorDefecto(descTarea);
		if (resultado == null || resultado.equals("")) {
			resultado = descTarea;
		}
		return resultado;
	}


	private String obtenerFechaGeneracionEscrito() {
		String resultado = "";
		SimpleDateFormat df = new SimpleDateFormat(FormatUtils.DD_DE_MES_DE_YYYY, MessageUtils.DEFAULT_LOCALE);
        try {
			resultado = df.format(fechaProceso);
		} catch (Exception e) {}
		return resultado;
	}

}

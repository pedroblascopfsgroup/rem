package es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastaSareb;

//es.pfsgroup.recovery.geninformes.beans.InformeSubastaBean

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.stereotype.Component;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.asunto.model.ProcedimientoContratoExpediente;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.oficina.model.Oficina;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.NMBProjectContext;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia.BienesBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia.CaracteristicasOperacionesBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia.ContratosBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia.DatosRegistralesBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia.InformeSubastaCommon;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia.IntervinientesBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia.LotesBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia.OperacionesConexionadasBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoFondo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.SubastaApi;
import es.pfsgroup.recovery.ext.api.procedimiento.EXTProcedimientoApi;

@Configurable
public class InformeSubastaSarebBean extends InformeSubastaCommon {

	private static final String INTERVINIENTE_TITULAR = "TITULAR";
	private static final String INTERVINIENTE_FIADOR = "FIADOR";
	
	
	//private static final String TAREA_SENYALAMIENTO_SUBASTA = "P409_SenyalamientoSubasta";
	//private static final String TAREA_INTERPOSICION_DEMANDA_HIPOTECARIO = "P01_DemandaCertificacionCargas";
	//private static final String TAREA_INTERPOSICION_DEMANDA_MONITORIO = "P02_InterposicionDemanda";
	//private static final String TAREA_INTERPOSICION_DEMANDA_ORDINARIO = "P03_InterposicionDemanda";
	//private static final String VALOR_HONORARIOS = "costasLetrado";
	//private static final String VALOR_DERECHOS_SUPLIDOS = "costasProcurador";
	//private static final String VALOR_FECHA_DEMANDA = "fechaSolicitud";
	//private static final String VALOR_FECHA_DEMANDA_ORDINARIO = "fecha";
//	private static final String VALOR_INTERESES_SENYALAMIENTO = "intereses";
//	private static final String VALOR_COSTASPROC_SENYALAMIENTO = "costasProcurador";

	//private static final String PRC_HIPOTECARIO = "P01";
	//private static final String PRC_MONITORIO = "P02";
	//private static final String PRC_ORDINARIO = "P03";

	public ApiProxyFactory getProxyFactory() {
		return proxyFactory;
	}

	public void setProxyFactory(ApiProxyFactory proxyFactory) {
		this.proxyFactory = proxyFactory;
	}

	public SubastaApi getSubastaApi() {
		return subastaApi;
	}

	public void setSubastaApi(SubastaApi subastaApi) {
		this.subastaApi = subastaApi;
	}	
	
	public NMBProjectContext getNmbCommonProjectContext() {
		return nmbCommonProjectContext;
	}
	
	public void setNmbCommonProjectContext(NMBProjectContext nmbCommonProjectContext) {
		this.nmbCommonProjectContext = nmbCommonProjectContext;
	}

	Long idAsunto;
	Long idSubasta;

	String titular;
	String fecha;
	String oficina;
	String zona;
	String territorial;
	String entidad;
	String proponente;
	String observaciones;

	// datos procesales
	String judgado;
	String numeroAutos;
	String tipoProcedimiento;
	String fechaDemanda;
	Float principal;
	String letrado;
	Float honorarios;
	String procurador;
	Float derechosSuplidos;
	Float deudaJudicial;
	String fechaSubasta;

	// Solo Sareb
	String centroNegocios;
	Float capitalSocial;
	String accionariado;
	String consejoAdministracion;
	String grupo;
	String riesgoGrupo;
	String nif;
	String producto;
	String finalidad;
	Float importeConcedido;
	String garantiasHipotecarias;
	String fiadores;
	String datosBasicos;
	String comiteDecisor;
	String fechaFormalizacion;
	String tipoEjecucion;
	String honorariosSuplidos;
	String cargasAnteriores;
	String cargasPosteriores;
	String situacionOcupacional;
	String precioTraspaso;

	List<IntervinientesBean> intervinientes;

	List<CaracteristicasOperacionesBean> caracteristicasOperaciones;

	List<ContratosBean> contratos;

	List<DatosRegistralesBean> datosRegistrales;

	List<LotesBean> lotes;

	List<BienesBean> bienes;

	List<OperacionesConexionadasBean> operacionesConexionadas;

	public List<Object> create() {

		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");

		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
		Subasta subasta = subastaApi.getSubasta(idSubasta);

		List<LoteSubasta> lotesSubasta = null;
		List<Bien> bienesSubasta = subastaApi.getBienesSubasta(idSubasta);
		Procedimiento procedimientoSubasta = null;
		
		Float tmpDeudaJudicial = null;
		if (!Checks.esNulo(subasta)) {
			lotesSubasta = subasta.getLotesSubasta();
			procedimientoSubasta = subasta.getProcedimiento();
			tmpDeudaJudicial = subasta.getDeudaJudicial();
		}		
		
		String fechaDemanda = null;

		if (!Checks.esNulo(procedimientoSubasta)) {

			InformeSubastaSarebBean stub = new InformeSubastaSarebBean();
			Calendar hoy = Calendar.getInstance();
			stub.setFecha(formatter.format(hoy.getTime()));
			if (!Checks.esNulo(asunto.getGestor()) && !Checks.esNulo(asunto.getGestor().getUsuario())) {
				stub.setEntidad(!Checks.esNulo(asunto.getGestor().getUsuario().getEntidad()) ? asunto.getGestor().getUsuario().getEntidad().getDescripcion() : null);
				// No quiere el letrado sino la descripcion del despacho
				if (!Checks.esNulo(asunto.getGestor().getDespachoExterno())) {
					System.out.println("[INFO] - Gestor: " + asunto.getGestor().getDespachoExterno().getDescripcion());
					stub.setLetrado(asunto.getGestor().getDespachoExterno().getDescripcion());
				}
			}
			if (!Checks.esNulo(asunto.getProcurador()) && !Checks.esNulo(asunto.getProcurador().getUsuario())) {
				stub.setProcurador(asunto.getProcurador().getUsuario().getApellidoNombre());
			}
			List<IntervinientesBean> intervinientes = new ArrayList<IntervinientesBean>();
			List<ContratosBean> contratos = new ArrayList<ContratosBean>();
			List<CaracteristicasOperacionesBean> caracteristicasOperaciones = new ArrayList<CaracteristicasOperacionesBean>();
			List<DatosRegistralesBean> datosRegistrales = new ArrayList<DatosRegistralesBean>();
			List<LotesBean> lotes = new ArrayList<LotesBean>();
			List<BienesBean> bienes = new ArrayList<BienesBean>();
			// TODO - buscar por codigo, sino las ñ nos van a matar
			HistoricoProcedimiento tareaSenyalamientoSubasta = this.getNodo(procedimientoSubasta, nmbCommonProjectContext.getCodigosTareasSenyalamiento());
//			List<OperacionesConexionadasBean> operacionesConexionadas = new ArrayList<OperacionesConexionadasBean>();

			List<ProcedimientoContratoExpediente> expedientesContratos = procedimientoSubasta.getProcedimientosContratosExpedientes();

			Date fechaVtoMasAntiguo = null;
			Contrato contratoGeneral = null;
			if (!Checks.esNulo(expedientesContratos)) {
				Float importeMaximo = 0F;
				// El contrato con mayor importe
				for (ProcedimientoContratoExpediente expedienteContrato : expedientesContratos) {
					if (!Checks.esNulo(expedienteContrato.getExpedienteContrato())) {
						Contrato contratoTmp = expedienteContrato.getExpedienteContrato().getContrato();
						if (!Checks.esNulo(contratoTmp)) {
							if (!Checks.esNulo(contratoTmp.getLastMovimiento())) {
								Float pVenc = (Checks.esNulo(contratoTmp.getLastMovimiento().getPosVivaVencida())) ? 0F : contratoTmp.getLastMovimiento().getPosVivaVencida();
								Float pNoVenc = (Checks.esNulo(contratoTmp.getLastMovimiento().getPosVivaNoVencida())) ? 0F : contratoTmp.getLastMovimiento().getPosVivaNoVencida();
								Float posViva = pVenc + pNoVenc;
								if (posViva >= importeMaximo) {
									contratoGeneral = contratoTmp;
									importeMaximo = posViva;
								}
								
								if (!Checks.esNulo(contratoTmp.getLastMovimiento().getFechaPosVencida())) {
									Date fechaVtoTMP = contratoTmp.getLastMovimiento().getFechaPosVencida();
									if (Checks.esNulo(fechaVtoMasAntiguo) || fechaVtoMasAntiguo.after(fechaVtoTMP)) {
										fechaVtoMasAntiguo = fechaVtoTMP;
									}
								}
							}
						}
					}
				}
				
				if (!Checks.esNulo(contratoGeneral)) {

					// Caracteristicas de la operaciones demandadas
					CaracteristicasOperacionesBean co = new CaracteristicasOperacionesBean();
					co.setNumero(contratoGeneral.getDescripcion());
					co.setTipoGarantia(contratoGeneral.getTipoProducto() != null ? contratoGeneral.getTipoProducto().getCodigo() + " - " + contratoGeneral.getTipoProducto().getDescripcion() : "");
					co.setOficina(contratoGeneral.getOficina().getCodDescripOficina(false,false));
					// co.setOficina(contratoTmp.getOficina().getCodigo() !=
					// null ?
					// contratoTmp.getOficina().getCodigo().toString() :
					// "");
					co.setFechaConcesion(Checks.esNulo(contratoGeneral.getFechaCreacion()) ? null : formatter.format(contratoGeneral.getFechaCreacion()));
					co.setFechaFinContrato(Checks.esNulo(contratoGeneral.getFechaVencimiento()) ? null : formatter.format(contratoGeneral.getFechaVencimiento()));
					co.setImporteConcedido(contratoGeneral.getLimiteFinal());
					co.setVtoMasAnt(Checks.esNulo(fechaVtoMasAntiguo) ? null : formatter.format(fechaVtoMasAntiguo));
					co.setDeutaTotal(contratoGeneral.getRiesgo());

					// TODO Se tiene que coger la fecha demanda del
					// procedimiento
					// padre P. Hipotecario / P. Monitorio

					if (!Checks.esNulo(procedimientoSubasta.getProcedimientoPadre()) && !Checks.esNulo(procedimientoSubasta.getProcedimientoPadre().getTipoProcedimiento())) {
						String tipoPrcPadre = procedimientoSubasta.getProcedimientoPadre().getTipoProcedimiento().getCodigo();
						Date fechaNodo = null;
						if (nmbCommonProjectContext.getCodigoHipotecario().equals(tipoPrcPadre)) {
							fechaNodo = this.dameFecha(getValorNodoPrc(procedimientoSubasta.getProcedimientoPadre(), nmbCommonProjectContext.getCodigoTareaDemandaHipotecario(), nmbCommonProjectContext.getFechaDemandaHipotecario()));
							fechaDemanda = Checks.esNulo(fechaNodo) ? null : formatter.format(fechaNodo);
						}
						if (nmbCommonProjectContext.getCodigoMonitorio().equals(tipoPrcPadre)) {
							fechaNodo = this.dameFecha(getValorNodoPrc(procedimientoSubasta.getProcedimientoPadre(), nmbCommonProjectContext.getCodigoTareaDemandaMonitorio(), nmbCommonProjectContext.getFechaDemandaMonitorio()));
							fechaDemanda = Checks.esNulo(fechaNodo) ? null : formatter.format(fechaNodo);
						}
						if (nmbCommonProjectContext.getCodigoMonitorio().equals(tipoPrcPadre)) {
							fechaNodo = this.dameFecha(getValorNodoPrc(procedimientoSubasta.getProcedimientoPadre(), nmbCommonProjectContext.getCodigoTareaDemandaOrdinario(), nmbCommonProjectContext.getFechaDemandaOrdinario()));
							fechaDemanda = Checks.esNulo(fechaNodo) ? null : formatter.format(fechaNodo);
						}
						co.setFechaDemanda(fechaDemanda);
					}

					caracteristicasOperaciones.add(co);

					// TODO Los siguientes datos hay que obtenerlos a partir
					// de los
					// extras del contrato
					// falta que se aprovisione el CHAR_EXTRA7
					if (!Checks.esNulo(contratoGeneral.getFlagextra2()) && "1".equals(contratoGeneral.getFlagextra2())) {
						ContratosBean contrato = new ContratosBean();
						String codigoFondo = contratoGeneral.getCharextra7();
						contrato.setCodigoFondo(codigoFondo);
						if (!Checks.esNulo(codigoFondo)) {
							DDTipoFondo tipoFondo = (DDTipoFondo) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDTipoFondo.class, codigoFondo);
							contrato.setNombreFondo(!Checks.esNulo(tipoFondo) ? tipoFondo.getDescripcion() : null);
						}
						contrato.setOperacion(contratoGeneral.getDescripcion());

						contratos.add(contrato);
						System.out.println("[INFO] - Contrato añadido");
					}
					
				}
			}

			List<ContratoPersona> contratoPersonas = (Checks.esNulo(contratoGeneral) ? null : contratoGeneral.getContratoPersonaOrdenado()); // procedimientoSubasta.getPersonasAfectadas();
			Persona pTitular = null;
			boolean bFiadores = false;

			if (!Checks.esNulo(contratoPersonas)) {

				for (ContratoPersona cp : contratoPersonas) {

					Persona p = cp.getPersona();
					// El titular principal será el primero que encontremos, ya
					// que ordenamos
					// por orden de CPE
					if (Checks.esNulo(pTitular)) {
						pTitular = cp.getPersona();
					}

					if (!cp.isTitular())
						bFiadores = true;

					IntervinientesBean interviniente = new IntervinientesBean();
					interviniente.setIntervencion(cp.isTitular() ? INTERVINIENTE_TITULAR : INTERVINIENTE_FIADOR);
					if (!Checks.esNulo(p)) {
						interviniente.setNombre(p.getApellidoNombre());

						// Demandado (SI / NO) --> Si la persona está en el
						// procedimiento esta demandado
						boolean isDemandado = proxyFactory.proxy(EXTProcedimientoApi.class).isPersonaEnProcedimiento(procedimientoSubasta.getId(), p.getId());
						interviniente.setDemandado(isDemandado ? "SI" : "NO");

						interviniente.setNif(p.getDocId());
						intervinientes.add(interviniente);
					}

				}

				// Datos de la cabecera
				if (!Checks.esNulo(pTitular)) {
					// Es titular en algun contrato de los expedientes del
					// procedimiento
					stub.setTitular(pTitular.getApellidoNombre());
					stub.setNif(pTitular.getDocId());
					stub.setCapitalSocial(pTitular.getDeudaIrregularDirecta());

					Oficina oficinaOficina = pTitular.getOficinaCliente();
					DDZona zonaOficina = (!Checks.esNulo(oficinaOficina)) ? oficinaOficina.getZona() : null;

					DDZona zonaZona = (!Checks.esNulo(zonaOficina)) ? zonaOficina.getZonaPadre() : null;
					Oficina oficinaZona = (!Checks.esNulo(zonaZona)) ? zonaZona.getOficina() : null;

					DDZona zonaTerritorial = (!Checks.esNulo(zonaZona)) ? zonaZona.getZonaPadre() : null;
					Oficina oficinaTerritorial = (!Checks.esNulo(zonaTerritorial)) ? zonaTerritorial.getOficina() : null;

					// Oficina, zona y territorial del titular
					// OFICINA
					stub.setOficina(contratoGeneral.getOficina().getCodDescripOficina(true, false));

					// ZONA
					stub.setZona(contratoGeneral.getOficina().getOficinaZona().getCodDescripOficina(true, false));

					// TERRITORIAL
					stub.setTerritorial(contratoGeneral.getOficina().getOficinaTerritorial().getCodDescripOficina(true, false));
					
				}
			}

			// info de contrato
			if (!Checks.esNulo(contratoGeneral)) {
				stub.setCentroNegocios(!Checks.esNulo(contratoGeneral.getOficina()) ? contratoGeneral.getOficina().getNombre() : null);
				stub.setProducto(!Checks.esNulo(contratoGeneral.getCatalogo1()) ? contratoGeneral.getCatalogo1().getDescripcion() : null);
				stub.setFinalidad(!Checks.esNulo(contratoGeneral.getFinalidadContrato()) ? contratoGeneral.getFinalidadContrato().getDescripcion() : null);
				if (!Checks.esNulo(contratoGeneral.getLastMovimiento())) {
					Float pVenc = (Checks.esNulo(contratoGeneral.getLastMovimiento().getPosVivaVencida())) ? 0F : contratoGeneral.getLastMovimiento().getPosVivaVencida();
					Float pNoVenc = (Checks.esNulo(contratoGeneral.getLastMovimiento().getPosVivaNoVencida())) ? 0F : contratoGeneral.getLastMovimiento().getPosVivaNoVencida();
					stub.setImporteConcedido(pVenc + pNoVenc);
				}

				// Si estamos en un procedimiento hipotecario con la
				// especialidad que pudiera darse, está claro que tenemos
				// garantía hipotecaria, luego necesariamente es SI.
				/*
				 * if (contratoGeneral.getGarantia1() != null) { if
				 * ((contratoGeneral.getGarantia1().getCodigo() == "211") ||
				 * (contratoGeneral.getGarantia1().getCodigo() == "212") ||
				 * (contratoGeneral.getGarantia1().getCodigo() == "213") ||
				 * (contratoGeneral.getGarantia1().getCodigo() == "214") ||
				 * (contratoGeneral.getGarantia1().getCodigo() == "215") ||
				 * (contratoGeneral.getGarantia1().getCodigo() == "411") ||
				 * (contratoGeneral.getGarantia1().getCodigo() == "412")) {
				 * stub.setGarantiasHipotecarias("SI"); } else {
				 * stub.setGarantiasHipotecarias("NO"); } } else {
				 * stub.setGarantiasHipotecarias("NO"); }
				 */
				stub.setGarantiasHipotecarias("SI");

				stub.setFiadores((bFiadores) ? "SI" : "NO");

				String strDatosBasicos = null;
				if (contratoGeneral.getGarantia1() != null)
					strDatosBasicos = "- Garantia: " + contratoGeneral.getGarantia1().getDescripcion() + "\n";
				if (contratoGeneral.getGarantia2() != null)
					strDatosBasicos += "- Garantia2: " + contratoGeneral.getGarantia2().getDescripcion() + "\n";
				if (!Checks.esNulo(fechaVtoMasAntiguo))
					strDatosBasicos += "- Vto. mas antiguo: " + formatter.format(fechaVtoMasAntiguo) + "\n";
				stub.setDatosBasicos(strDatosBasicos);

				stub.setFechaFormalizacion(Checks.esNulo(contratoGeneral.getFechaCreacion()) ? null : formatter.format(contratoGeneral.getFechaCreacion()));

			}

			stub.setIntervinientes(intervinientes);
			stub.setContratos(contratos);
			stub.setCaracteristicasOperaciones(caracteristicasOperaciones);

			stub.setJudgado(procedimientoSubasta.getJuzgado() != null ? procedimientoSubasta.getJuzgado().getDescripcion() : "");
			stub.setNumeroAutos(procedimientoSubasta.getCodigoProcedimientoEnJuzgado());
			stub.setTipoProcedimiento(procedimientoSubasta.getProcedimientoPadre() != null ? procedimientoSubasta.getProcedimientoPadre().getTipoProcedimiento().getDescripcion() : "");

			stub.setFechaDemanda(fechaDemanda);
			String strPrincipal = Checks.esNulo(procedimientoSubasta.getSaldoRecuperacion()) ? null : String.valueOf(procedimientoSubasta.getSaldoRecuperacion());
			try {
				stub.setPrincipal(!Checks.esNulo(strPrincipal) ? Float.valueOf(strPrincipal.replaceAll(",",".")) : 0F);
			} catch (NumberFormatException e) {				
				System.out.println("[WARN] - El valor para principal: " + strPrincipal + " no es un float");
			}

			String valorNodo = getValorNodoPrc(tareaSenyalamientoSubasta, nmbCommonProjectContext.getValorHonorarios());
			
			try {
				stub.setHonorarios(!Checks.esNulo(valorNodo) ? Float.valueOf(valorNodo.replaceAll(",",".")) : 0F);
			} catch (NumberFormatException e) {				
				System.out.println("[WARN] - El valor para honorarios: " + valorNodo + " no es un float");
			}
			
			valorNodo = getValorNodoPrc(tareaSenyalamientoSubasta, nmbCommonProjectContext.getValorDerechosSuplidos());
			try {
				stub.setDerechosSuplidos(!Checks.esNulo(valorNodo) ? Float.valueOf(valorNodo.replaceAll(",",".")) : 0F);
			} catch (NumberFormatException e) {				
				System.out.println("[WARN] - El valor para DerechosSuplicios: " + valorNodo + " no es un float");
			}
			

			// FIXME - Se comenta porque ahora se calcula la deuda judicial del
			// campo LOS_VALOR_SUBASTA
			/*
			 * Float principalSenyalamiento = Checks.esNulo(strPrincipal) ? null
			 * : Float.valueOf(strPrincipal); Float interesesSenyalamiento = 0F;
			 * Float costasProcSenyalamiento = 0F; if
			 * (!Checks.esNulo(tareaSenyalamientoSubasta)) { String valorTmp =
			 * getValorNodoPrc(tareaSenyalamientoSubasta,
			 * VALOR_INTERESES_SENYALAMIENTO); if (!Checks.esNulo(valorTmp)) {
			 * interesesSenyalamiento = Float.valueOf(valorTmp); } valorTmp =
			 * getValorNodoPrc(tareaSenyalamientoSubasta,
			 * VALOR_COSTASPROC_SENYALAMIENTO); if (!Checks.esNulo(valorTmp)) {
			 * costasProcSenyalamiento = Float.valueOf(valorTmp); } } Float
			 * sumPrincipal = Checks.esNulo(principalSenyalamiento) ? null :
			 * principalSenyalamiento + interesesSenyalamiento +
			 * costasProcSenyalamiento;
			 * stub.setDeudaJudicial(!Checks.esNulo(sumPrincipal) ?
			 * Float.valueOf(sumPrincipal) : null);
			 */

			stub.setFechaSubasta(Checks.esNulo(subasta.getFechaSenyalamiento()) ? null : formatter.format(subasta.getFechaSenyalamiento()));

			if (!Checks.esNulo(bienesSubasta)) {
				// Añadimos los bienes
				for (Bien b : bienesSubasta) {
					if (b instanceof NMBBien) {
						NMBBien bien = (NMBBien) b;
						DatosRegistralesBean dr = new DatosRegistralesBean();
						dr.setActivo(bien.getNumeroActivo());
						if (!Checks.esNulo(bien.getDatosRegistralesActivo())) {
							dr.setFinca(bien.getDatosRegistralesActivo().getNumFinca());
							dr.setRegistro(bien.getDatosRegistralesActivo().getNumRegistro());
						}
						dr.setDireccion(Checks.esNulo(bien.getLocalizacionActual()) ? null : bien.getLocalizacionActual().getDireccion());

						dr.setLocalidad(Checks.esNulo(bien.getLocalizacionActual()) ? null : bien.getLocalizacionActual().getPoblacion());
						if (!Checks.esNulo(bien.getAdicional()) && !Checks.esNulo(bien.getAdicional().getTipoInmueble())) {
							dr.setTipoInmueble(bien.getAdicional().getTipoInmueble().getDescripcion());
						} else if (!Checks.esNulo(bien.getTipoBien())) {
							dr.setTipoInmueble(bien.getTipoBien().getDescripcion());
						}
						datosRegistrales.add(dr);
					}
				}
			}
			stub.setDatosRegistrales(datosRegistrales);

//			int nLote = 0;
			String tmpObservaciones = "";
//			Float sumDeudaJudicial = 0F;

			if (!Checks.esNulo(lotesSubasta)) {
				for (LoteSubasta l : lotesSubasta) {
//					nLote++;
					boolean entrado = false;
					if (!Checks.esNulo(l.getBienes())) {
						for (Bien bienLote : l.getBienes()) {
							if (bienLote instanceof NMBBien) {
								NMBBien nmbBienLote = (NMBBien) bienLote;

								// TIPO SUBASTA Y TASACION ACTUALIZADA DE LOS
								// BIENES SUBASTADOS
								LotesBean lb = new LotesBean();

								// Obtengo el contrato del bien con mayor
								// importe
								// EXPLICACION CLIENTE PORQUE SE OBTIENE EL
								// CONTRATO DEL PRC:
								// Ten en cuenta que estamos en trámite subasta
								// tiene que volcarse las operaciones que estén
								// vinculadas en NAL a ese procedimiento
								// hipotecario. De hecho no hay paridad entre
								// las garantías que constan en NOS y las que
								// aparecen en NAL, debe primar este último.
								Contrato contratoBien = getContratoBienImporteMaximo(nmbBienLote);
								if (!Checks.esNulo(contratoBien)) {
									lb.setOperacion(contratoBien.getDescripcion());
									lb.setDeudaEntidad(getSumaDeudaTotal(contratoBien));
								}

//								lb.setOperacion(Checks.esNulo(contratoGeneral) ? null : contratoGeneral.getDescripcion());
								lb.setLote(!Checks.esNulo(l.getNumLote()) ? String.valueOf(l.getNumLote()) : "-");
								lb.setActivo(nmbBienLote.getNumeroActivo());
//								lb.setDeudaEntidad(getSumaDeudaTotal(contratoGeneral));
								lb.setFinca(Checks.esNulo(nmbBienLote.getDatosRegistralesActivo()) ? null : nmbBienLote.getDatosRegistralesActivo().getNumFinca());
								// contrato
								// Mayor
								
								lb.setDeudaJudicial(l.getDeudaJudicial());
								Float tipoSubasta = nmbBienLote.getTipoSubasta();
								if(Checks.esNulo(tipoSubasta)){
									tipoSubasta = l.getInsValorSubasta();
								}
								lb.setTipoSubasta(tipoSubasta);
								lb.setTipoSubasta50(Checks.esNulo(tipoSubasta) ? null : tipoSubasta * 0.50F);
								lb.setTipoSubasta60(Checks.esNulo(tipoSubasta) ? null : tipoSubasta * 0.60F);
								lb.setTipoSubasta70(Checks.esNulo(tipoSubasta) ? null : tipoSubasta * 0.70F);
								Float valorTasacion = null;
								if (!Checks.esNulo(nmbBienLote.getValoraciones()) && nmbBienLote.getValoraciones().size() > 0) {
									valorTasacion = Checks.esNulo(nmbBienLote.getValoraciones().get(0).getImporteValorTasacion()) ? null : nmbBienLote.getValoraciones().get(0).getImporteValorTasacion().floatValue();
								}
								lb.setTasacionActualizada(valorTasacion);
								lb.setTasacionActualizada70(Checks.esNulo(valorTasacion) ? null : valorTasacion * 0.70F);

								lotes.add(lb);

								// PROPUESTA INTERVENCION
								BienesBean bb = new BienesBean();

								// Solo pinto los datos del lote en la primera
								// fila de
								// los bienes
								if (!entrado) {
									bb.setDesdePostores(l.getInsPujaPostoresDesde() != null ? l.getInsPujaPostoresDesde() : 0F);
									bb.setHastaPostores(l.getInsPujaPostoresHasta() != null ? l.getInsPujaPostoresHasta() : 0F);
									bb.setSinPostores(l.getInsPujaSinPostores() != null ? l.getInsPujaSinPostores() : 0F);
									entrado = true;
								}

								bb.setOperacion(Checks.esNulo(contratoBien) ? null : contratoBien.getDescripcion());
								bb.setActivo(nmbBienLote.getNumeroActivo());
								bb.setFinca(Checks.esNulo(nmbBienLote.getDatosRegistralesActivo()) ? null : nmbBienLote.getDatosRegistralesActivo().getNumFinca());

								bienes.add(bb);
							}
						}
					}
					if (!Checks.esNulo(l.getObservaciones())) {
						tmpObservaciones += l.getObservaciones() + "\n";
					}

//					if (!Checks.esNulo(l.getInsValorSubastaSinBienes())) {
//						sumDeudaJudicial += l.getInsValorSubastaSinBienes();
//					}
				}

			}
			stub.setDeudaJudicial(tmpDeudaJudicial);
			stub.setObservaciones(tmpObservaciones);
			stub.setLotes(lotes);
			stub.setBienes(bienes);

			// Añadimos de momento 4 filas en blanco
//			for (int x = 0; x <= 3; x++) {
//				OperacionesConexionadasBean operacionConexionada = new OperacionesConexionadasBean();
//
//				operacionConexionada.setDeuda("");
//				operacionConexionada.setGarantia("");
//				operacionConexionada.setObservaciones("");
//				operacionConexionada.setOperacion("");
//				operacionConexionada.setTotal("");
//
//				operacionesConexionadas.add(operacionConexionada);
//			}
//			stub.setOperacionesConexionadas(operacionesConexionadas);

			return Arrays.asList((Object) stub);

		} else {
			return null;
		}
	}

	public Long getIdAsunto() {
		return idAsunto;
	}

	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}

	public Long getIdSubasta() {
		return idSubasta;
	}

	public void setIdSubasta(Long idSubasta) {
		this.idSubasta = idSubasta;
	}

	public String getTitular() {
		return titular;
	}

	public void setTitular(String titular) {
		this.titular = titular;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public String getOficina() {
		return oficina;
	}

	public void setOficina(String oficina) {
		this.oficina = oficina;
	}

	public String getZona() {
		return zona;
	}

	public void setZona(String zona) {
		this.zona = zona;
	}

	public String getTerritorial() {
		return territorial;
	}

	public void setTerritorial(String territorial) {
		this.territorial = territorial;
	}

	public String getEntidad() {
		return entidad;
	}

	public void setEntidad(String entidad) {
		this.entidad = entidad;
	}

	public String getProponente() {
		return proponente;
	}

	public void setProponente(String proponente) {
		this.proponente = proponente;
	}

	public List<IntervinientesBean> getIntervinientes() {
		return intervinientes;
	}

	public void setIntervinientes(List<IntervinientesBean> intervinientes) {
		this.intervinientes = intervinientes;
	}

	public List<CaracteristicasOperacionesBean> getCaracteristicasOperaciones() {
		return caracteristicasOperaciones;
	}

	public void setCaracteristicasOperaciones(List<CaracteristicasOperacionesBean> caracteristicasOperaciones) {
		this.caracteristicasOperaciones = caracteristicasOperaciones;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public List<ContratosBean> getContratos() {
		return contratos;
	}

	public void setContratos(List<ContratosBean> contratos) {
		this.contratos = contratos;
	}

	public List<DatosRegistralesBean> getDatosRegistrales() {
		return datosRegistrales;
	}

	public void setDatosRegistrales(List<DatosRegistralesBean> datosRegistrales) {
		this.datosRegistrales = datosRegistrales;
	}

	public List<LotesBean> getLotes() {
		return lotes;
	}

	public void setLotes(List<LotesBean> lotes) {
		this.lotes = lotes;
	}

	public List<OperacionesConexionadasBean> getOperacionesConexionadas() {
		return operacionesConexionadas;
	}

	public void setOperacionesConexionadas(List<OperacionesConexionadasBean> operacionesConexionadas) {
		this.operacionesConexionadas = operacionesConexionadas;
	}

	public String getJudgado() {
		return judgado;
	}

	public void setJudgado(String judgado) {
		this.judgado = judgado;
	}

	public String getNumeroAutos() {
		return numeroAutos;
	}

	public void setNumeroAutos(String numeroAutos) {
		this.numeroAutos = numeroAutos;
	}

	public String getTipoProcedimiento() {
		return tipoProcedimiento;
	}

	public void setTipoProcedimiento(String tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}

	public String getFechaDemanda() {
		return fechaDemanda;
	}

	public void setFechaDemanda(String fechaDemanda) {
		this.fechaDemanda = fechaDemanda;
	}

	public Float getPrincipal() {
		return principal;
	}

	public void setPrincipal(Float principal) {
		this.principal = principal;
	}

	public String getLetrado() {
		return letrado;
	}

	public void setLetrado(String letrado) {
		this.letrado = letrado;
	}

	public Float getHonorarios() {
		return honorarios;
	}

	public void setHonorarios(Float honorarios) {
		this.honorarios = honorarios;
	}

	public String getProcurador() {
		return procurador;
	}

	public void setProcurador(String procurador) {
		this.procurador = procurador;
	}

	public Float getDerechosSuplidos() {
		return derechosSuplidos;
	}

	public void setDerechosSuplidos(Float derechosSuplidos) {
		this.derechosSuplidos = derechosSuplidos;
	}

	public Float getDeudaJudicial() {
		return deudaJudicial;
	}

	public void setDeudaJudicial(Float deudaJudicial) {
		this.deudaJudicial = deudaJudicial;
	}

	public String getFechaSubasta() {
		return fechaSubasta;
	}

	public void setFechaSubasta(String fechaSubasta) {
		this.fechaSubasta = fechaSubasta;
	}

	public List<BienesBean> getBienes() {
		return bienes;
	}

	public void setBienes(List<BienesBean> bienes) {
		this.bienes = bienes;
	}

	// Solo Sareb
	public String getCentroNegocios() {
		return centroNegocios;
	}

	public void setCentroNegocios(String centroNegocios) {
		this.centroNegocios = centroNegocios;
	}

	public Float getCapitalSocial() {
		return capitalSocial;
	}

	public void setCapitalSocial(Float capitalSocial) {
		this.capitalSocial = capitalSocial;
	}

	public String getAccionariado() {
		return accionariado;
	}

	public void setAccionariado(String accionariado) {
		this.accionariado = accionariado;
	}

	public String getConsejoAdministracion() {
		return consejoAdministracion;
	}

	public void setConsejoAdministracion(String consejoAdministracion) {
		this.consejoAdministracion = consejoAdministracion;
	}

	public String getGrupo() {
		return grupo;
	}

	public void setGrupo(String grupo) {
		this.grupo = grupo;
	}

	public String getRiesgoGrupo() {
		return riesgoGrupo;
	}

	public void setRiesgoGrupo(String riesgoGrupo) {
		this.riesgoGrupo = riesgoGrupo;
	}

	public String getNif() {
		return nif;
	}

	public void setNif(String nif) {
		this.nif = nif;
	}

	public String getProducto() {
		return producto;
	}

	public void setProducto(String producto) {
		this.producto = producto;
	}

	public String getFinalidad() {
		return finalidad;
	}

	public void setFinalidad(String finalidad) {
		this.finalidad = finalidad;
	}

	public Float getImporteConcedido() {
		return importeConcedido;
	}

	public void setImporteConcedido(Float importeConcedido) {
		this.importeConcedido = importeConcedido;
	}

	public String getGarantiasHipotecarias() {
		return garantiasHipotecarias;
	}

	public void setGarantiasHipotecarias(String garantiasHipotecarias) {
		this.garantiasHipotecarias = garantiasHipotecarias;
	}

	public String getFiadores() {
		return fiadores;
	}

	public void setFiadores(String fiadores) {
		this.fiadores = fiadores;
	}

	public String getDatosBasicos() {
		return datosBasicos;
	}

	public void setDatosBasicos(String datosBasicos) {
		this.datosBasicos = datosBasicos;
	}

	public String getComiteDecisor() {
		return comiteDecisor;
	}

	public void setComiteDecisor(String comiteDecisor) {
		this.comiteDecisor = comiteDecisor;
	}

	public String getFechaFormalizacion() {
		return fechaFormalizacion;
	}

	public void setFechaFormalizacion(String fechaFormalizacion) {
		this.fechaFormalizacion = fechaFormalizacion;
	}

	public String getTipoEjecucion() {
		return tipoEjecucion;
	}

	public void setTipoEjecucion(String tipoEjecucion) {
		this.tipoEjecucion = tipoEjecucion;
	}

	public String getHonorariosSuplidos() {
		return honorariosSuplidos;
	}

	public void setHonorariosSuplidos(String honorariosSuplidos) {
		this.honorariosSuplidos = honorariosSuplidos;
	}

	public String getCargasAnteriores() {
		return cargasAnteriores;
	}

	public void setCargasAnteriores(String cargasAnteriores) {
		this.cargasAnteriores = cargasAnteriores;
	}

	public String getCargasPosteriores() {
		return cargasPosteriores;
	}

	public void setCargasPosteriores(String cargasPosteriores) {
		this.cargasPosteriores = cargasPosteriores;
	}

	public String getSituacionOcupacional() {
		return situacionOcupacional;
	}

	public void setSituacionOcupacional(String situacionOcupacional) {
		this.situacionOcupacional = situacionOcupacional;
	}

	public String getPrecioTraspaso() {
		return precioTraspaso;
	}

	public void setPrecioTraspaso(String precioTraspaso) {
		this.precioTraspaso = precioTraspaso;
	}

}

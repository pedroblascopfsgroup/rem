package es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Configurable;

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
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoFondo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.SubastaApi;
import es.pfsgroup.recovery.ext.api.procedimiento.EXTProcedimientoApi;

@Configurable
public class InformeSubastaBean extends InformeSubastaCommon {

	private static final String INTERVINIENTE_TITULAR = "TITULAR";
	private static final String INTERVINIENTE_FIADOR = "FIADOR";

	//TODO - Modificar por projectContext
	private static final String TAREA_SENYALAMIENTO_SUBASTA = "P401_SenyalamientoSubasta";
	private static final String TAREA_INTERPOSICION_DEMANDA_HIPOTECARIO = "P01_DemandaCertificacionCargas";
	private static final String TAREA_INTERPOSICION_DEMANDA_MONITORIO = "P02_InterposicionDemanda";
	private static final String TAREA_INTERPOSICION_DEMANDA_ORDINARIO = "P03_InterposicionDemanda";
	private static final String VALOR_HONORARIOS = "costasLetrado";
	private static final String VALOR_DERECHOS_SUPLIDOS = "costasProcurador";
	private static final String VALOR_FECHA_DEMANDA = "fechaSolicitud";
	private static final String VALOR_FECHA_DEMANDA_ORDINARIO = "fecha";
	// private static final String VALOR_INTERESES_SENYALAMIENTO = "intereses";
	// private static final String VALOR_COSTASPROC_SENYALAMIENTO =
	// "costasProcurador";

	private static final String PRC_HIPOTECARIO = "P01";
	private static final String PRC_MONITORIO = "P02";
	private static final String PRC_ORDINARIO = "P03";

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

	List<IntervinientesBean> intervinientes;

	List<CaracteristicasOperacionesBean> caracteristicasOperaciones;

	List<ContratosBean> contratos;

	List<DatosRegistralesBean> datosRegistrales;

	List<LotesBean> lotes;

	List<BienesBean> bienes;

	List<OperacionesConexionadasBean> operacionesConexionadas;

	public List<Object> create() {

		System.out.println("[INFO] - START - informeSubasta");
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");

		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
		Subasta subasta = subastaApi.getSubasta(idSubasta);

		Procedimiento procedimientoSubasta = null;

		List<LoteSubasta> lotesSubasta = null;
		List<Bien> bienesSubasta = subastaApi.getBienesSubasta(idSubasta);
		Float tmpDeudaJudicial = null;
		if (!Checks.esNulo(subasta)) {
			lotesSubasta = subasta.getLotesSubasta();
			procedimientoSubasta = subasta.getProcedimiento();
			tmpDeudaJudicial = subasta.getDeudaJudicial();
		}

		String fechaDemanda = null;

		if (!Checks.esNulo(procedimientoSubasta)) {
			System.out.println("[INFO] - Procedimiento subasta: " + procedimientoSubasta.getId().toString());
			InformeSubastaBean stub = new InformeSubastaBean();
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
			HistoricoProcedimiento tareaSenyalamientoSubasta = this.getNodo(procedimientoSubasta, TAREA_SENYALAMIENTO_SUBASTA);
			System.out.println("[INFO] - Tarea Señalamiento: " + (!Checks.esNulo(tareaSenyalamientoSubasta) ? tareaSenyalamientoSubasta.getNombreTarea() : "nulo"));

			List<OperacionesConexionadasBean> operacionesConexionadas = new ArrayList<OperacionesConexionadasBean>();

			List<ProcedimientoContratoExpediente> expedientesContratos = procedimientoSubasta.getProcedimientosContratosExpedientes();
			Contrato contratoGeneral = null;
			if (!Checks.esNulo(expedientesContratos)) {
				Float importeMaximo = 0F;
				System.out.println("[INFO] - ExpedienteContrato OK");
				// El contrato con mayor importe
				for (ProcedimientoContratoExpediente expedienteContrato : expedientesContratos) {
					if (!Checks.esNulo(expedienteContrato)) {
						Contrato contratoTmp = expedienteContrato.getExpedienteContrato().getContrato();
						if (!Checks.esNulo(contratoTmp)) {

							// Caracteristicas de la operaciones demandadas
							CaracteristicasOperacionesBean co = new CaracteristicasOperacionesBean();

							System.out.println("[INFO] - CEX_ID: " + contratoTmp.getId());
							if (!Checks.esNulo(contratoTmp.getLastMovimiento())) {
								System.out.println("[INFO] - Existe ultimo movimiento");
								Float pVenc = (Checks.esNulo(contratoTmp.getLastMovimiento().getPosVivaVencida())) ? 0F : contratoTmp.getLastMovimiento().getPosVivaVencida();
								Float pNoVenc = (Checks.esNulo(contratoTmp.getLastMovimiento().getPosVivaNoVencida())) ? 0F : contratoTmp.getLastMovimiento().getPosVivaNoVencida();
								Float sumaPosicion = pVenc + pNoVenc;
								System.out.println("[INFO] - Suma posViva: " + sumaPosicion.toString());
								if (sumaPosicion >= importeMaximo) {
									contratoGeneral = contratoTmp;
									importeMaximo = sumaPosicion;
									System.out.println("[INFO] - PosViva mayor");
								}

								// suma de los intereses ordinarios + moratorios
								// + posición vencida y no vencida
								Float interesesOrdinarios = (Checks.esNulo(contratoTmp.getLastMovimiento().getMovIntRemuneratoriosAbsoluta())) ? 0F : contratoTmp.getLastMovimiento()
										.getMovIntRemuneratoriosAbsoluta();
								Float interesesMoratorios = (Checks.esNulo(contratoTmp.getLastMovimiento().getMovIntMoratoriosAbsoluta())) ? 0F : contratoTmp.getLastMovimiento()
										.getMovIntMoratoriosAbsoluta();

								Float sumaDeudaTotal = interesesOrdinarios + interesesMoratorios + sumaPosicion;
								co.setDeutaTotal(sumaDeudaTotal);

								co.setVtoMasAnt(Checks.esNulo(contratoTmp.getLastMovimiento().getFechaPosVencida()) ? null : formatter.format(contratoTmp.getLastMovimiento().getFechaPosVencida()));

							}

							co.setNumero(contratoTmp.getDescripcion());
							// co.setTipoGarantia(contratoTmp.getTipoProducto()
							// != null ?
							// contratoTmp.getTipoProducto().getCodigo() + " - "
							// + contratoTmp.getTipoProducto().getDescripcion()
							// : "");
							if (!Checks.esNulo(contratoGeneral)) {
								co.setTipoGarantia(contratoGeneral.getGarantia1() != null ? contratoGeneral.getGarantia1().getDescripcion() : "");
							}
							co.setOficina(contratoTmp.getOficina().getCodDescripOficina(false, false));
							// co.setOficina(contratoTmp.getOficina().getCodigo()
							// != null ?
							// contratoTmp.getOficina().getCodigo().toString() :
							// "");
							co.setFechaConcesion(Checks.esNulo(contratoTmp.getFechaCreacion()) ? null : formatter.format(contratoTmp.getFechaCreacion()));
							co.setFechaFinContrato(Checks.esNulo(contratoTmp.getFechaVencimiento()) ? null : formatter.format(contratoTmp.getFechaVencimiento()));

							co.setImporteConcedido(contratoTmp.getLimiteFinal());
							// co.setVtoMasAnt(Checks.esNulo(contratoTmp.getFechaEstadoFinanciero())
							// ? null :
							// formatter.format(contratoTmp.getFechaEstadoFinanciero()));

							// TODO Se tiene que coger la fecha demanda del
							// procedimiento
							// padre P. Hipotecario / P. Monitorio
							System.out.println("[INFO] - Bloque 2 - comprobacion tarea padre");
							if (!Checks.esNulo(procedimientoSubasta.getProcedimientoPadre()) && !Checks.esNulo(procedimientoSubasta.getProcedimientoPadre().getTipoProcedimiento())) {
								String tipoPrcPadre = procedimientoSubasta.getProcedimientoPadre().getTipoProcedimiento().getCodigo();
								System.out.println("[INFO] - Tipo prc padre: " + tipoPrcPadre);
								Date fechaNodo = null;
								if (PRC_HIPOTECARIO.equals(tipoPrcPadre)) {
									System.out.println("[INFO] - Check hipotecario");
									fechaNodo = this.dameFecha(getValorNodoPrc(procedimientoSubasta.getProcedimientoPadre(), TAREA_INTERPOSICION_DEMANDA_HIPOTECARIO, VALOR_FECHA_DEMANDA));
									System.out.println("[INFO] - Fecha nodo: " + (!Checks.esNulo(fechaNodo) ? fechaNodo.toString() : "nulo"));
									fechaDemanda = Checks.esNulo(fechaNodo) ? null : formatter.format(fechaNodo);
									System.out.println("[INFO] - Fecha demanda: " + (!Checks.esNulo(fechaDemanda) ? fechaDemanda.toString() : "nulo"));
								}
								if (PRC_MONITORIO.equals(tipoPrcPadre)) {
									System.out.println("[INFO] - Check monitorio");
									fechaNodo = this.dameFecha(getValorNodoPrc(procedimientoSubasta.getProcedimientoPadre(), TAREA_INTERPOSICION_DEMANDA_MONITORIO, VALOR_FECHA_DEMANDA));
									System.out.println("[INFO] - Fecha nodo: " + (!Checks.esNulo(fechaNodo) ? fechaNodo.toString() : "nulo"));
									fechaDemanda = Checks.esNulo(fechaNodo) ? null : formatter.format(fechaNodo);
									System.out.println("[INFO] - Fecha demanda: " + (!Checks.esNulo(fechaDemanda) ? fechaDemanda.toString() : "nulo"));
								}
								if (PRC_ORDINARIO.equals(tipoPrcPadre)) {
									System.out.println("[INFO] - Check ordinario");
									fechaNodo = this.dameFecha(getValorNodoPrc(procedimientoSubasta.getProcedimientoPadre(), TAREA_INTERPOSICION_DEMANDA_ORDINARIO, VALOR_FECHA_DEMANDA_ORDINARIO));
									System.out.println("[INFO] - Fecha nodo: " + (!Checks.esNulo(fechaNodo) ? fechaNodo.toString() : "nulo"));
									fechaDemanda = Checks.esNulo(fechaNodo) ? null : formatter.format(fechaNodo);
									System.out.println("[INFO] - Fecha demanda: " + (!Checks.esNulo(fechaDemanda) ? fechaDemanda.toString() : "nulo"));
								}
								co.setFechaDemanda(fechaDemanda);
							}

							caracteristicasOperaciones.add(co);

							// TODO Los siguientes datos hay que obtenerlos a
							// partir de los
							// extras del contrato
							ContratosBean contrato = new ContratosBean();
							String codigoFondo = contratoTmp.getCharextra7();
							if (!Checks.esNulo(codigoFondo)) {
								DDTipoFondo tipoFondo = (DDTipoFondo) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDTipoFondo.class, codigoFondo);
								if ((!Checks.esNulo(tipoFondo)) && (!Checks.esNulo(tipoFondo.getCesionRemate())) && (tipoFondo.getCesionRemate())) {
									contrato.setNombreFondo(tipoFondo.getDescripcion());
									contrato.setCodigoFondo(tipoFondo.getCodigoNAL());
									contrato.setOperacion(contratoTmp.getDescripcion());
								}
							}

							contratos.add(contrato);
							System.out.println("[INFO] - Contrato añadido");
						}
					}
				}
			}
			
			// Datos de la cabecera
                        StringBuffer listaTitulares = new StringBuffer(" ");
                        Persona titularPorPrimero = null;
                        if (!Checks.esNulo(contratoGeneral)) {
				
				System.out.println("[INFO] - Obtengo los datos de oficina/zona/....");

				// Oficina, zona y territorial del titular
				// OFICINA
				stub.setOficina(contratoGeneral.getOficina().getCodDescripOficina(true, false));

				// ZONA
				stub.setZona(contratoGeneral.getOficina().getOficinaZona().getCodDescripOficina(true, false));

				// TERRITORIAL
				stub.setTerritorial(contratoGeneral.getOficina().getOficinaTerritorial().getCodDescripOficina(true, false));

				// DIR PROPENENTE
				stub.setProponente(getDirProponente(contratoGeneral.getOficina().getZona(), new HashSet<Long>()));

				System.out.println("[INFO] - Zonificacion añadida");
			
				List<ContratoPersona> contratoPersonas = (Checks.esNulo(contratoGeneral) ? null : contratoGeneral.getContratoPersonaOrdenado());
	
				if (!Checks.esNulo(contratoPersonas)) {
					System.out.println("[INFO] - Num Personas contrato: " + contratoPersonas.size());
					for (ContratoPersona cp : contratoPersonas) {
						System.out.println("[INFO] - Contrato persona ID: " + cp.getId());
						Persona p = cp.getPersona();
						// El titular principal será el primero que encontremos, ya
						// que ordenamos
						// por orden de CPE
                                                // Se crea la variable titularPorPrimero por si acaso ninguna de las personas asociadas al contrato es titular
                                                // en ese caso se toma el primero de la lista como titular (cuando se settea el titular en el stub)
						if (Checks.esNulo(titularPorPrimero) && Checks.esNulo(listaTitulares.toString())) {
							titularPorPrimero = cp.getPersona();
							System.out.println("[INFO] - Primero de la lista: " + titularPorPrimero.getApellidoNombre());
                                                }
                                                
                                                // listaTitulares es la cadena con los nombres de los titulares de un contrato
                                                // Aprovechando el bucle, construimos en la cabecera, el campo de Titulares separados por ;
                                                if (cp.isTitular()){
                                                    listaTitulares.append(cp.getPersona().getApellidoNombre());
                                                }
                                                
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
							System.out.println("[INFO] - Inteviniente: " + p.getApellidoNombre() + " (añadido)");
						}
					}

				}
				
			}

                        //En caso de que ninguno de la lista est� marcado como titular, se toma el primero como tal
                        if (Checks.esNulo(listaTitulares)){
                            stub.setTitular (titularPorPrimero.getApellidoNombre());
                            System.out.println("[INFO] - Titular por primero de la lista: " + titularPorPrimero.getApellidoNombre());
                        } else {
                            // Lista de titulares del contrato, separados por ;
                            stub.setTitular(listaTitulares.toString());
                            System.out.println("[INFO] - Titulares: " + listaTitulares.toString());
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
				stub.setPrincipal(!Checks.esNulo(strPrincipal) ? Float.valueOf(strPrincipal.replaceAll(",", ".")) : 0F);
			} catch (NumberFormatException e) {
				System.out.println("[WARN] - El valor para principal: " + strPrincipal + " no es un float");
			}
			System.out.println("[INFO] - Principal: " + (!Checks.esNulo(strPrincipal) ? strPrincipal : "nulo"));

			String valorNodo = getValorNodoPrc(tareaSenyalamientoSubasta, VALOR_HONORARIOS);
			try {
				stub.setHonorarios(!Checks.esNulo(valorNodo) ? Float.valueOf(valorNodo.replaceAll(",", ".")) : 0F);
			} catch (NumberFormatException e) {
				System.out.println("[WARN] - El valor para honorarios: " + valorNodo + " no es un float");
			}
			System.out.println("[INFO] - Costas letrado: " + (!Checks.esNulo(valorNodo) ? valorNodo : "nulo"));
			valorNodo = getValorNodoPrc(tareaSenyalamientoSubasta, VALOR_DERECHOS_SUPLIDOS);

			try {
				stub.setDerechosSuplidos(!Checks.esNulo(valorNodo) ? Float.valueOf(valorNodo.replaceAll(",", ".")) : 0F);
			} catch (NumberFormatException e) {
				System.out.println("[WARN] - El valor para DerechosSuplicios: " + valorNodo + " no es un float");
			}
			System.out.println("[INFO] - Costas procurador: " + (!Checks.esNulo(valorNodo) ? valorNodo : "nulo"));

			// FIXME - Se comenta porque ahora se calcula la deuda judicial del
			// campo LOS_VALOR_SUBASTA
			/*
			 * Float principalSenyalamiento = Checks.esNulo(strPrincipal) ? null
			 * : Float.valueOf(strPrincipal); Float interesesSenyalamiento = 0F;
			 * Float costasProcSenyalamiento = 0F; if
			 * (!Checks.esNulo(tareaSenyalamientoSubasta)) {
			 * System.out.println("[INFO] - Bloque 3"); String valorTmp =
			 * getValorNodoPrc(tareaSenyalamientoSubasta,
			 * VALOR_INTERESES_SENYALAMIENTO); if (!Checks.esNulo(valorTmp)) {
			 * interesesSenyalamiento = Float.valueOf(valorTmp);
			 * System.out.println("[INFO] - Intereses: " + valorTmp.toString());
			 * } else { System.out.println("[INFO] - Intereses nulo"); }
			 * valorTmp = getValorNodoPrc(tareaSenyalamientoSubasta,
			 * VALOR_COSTASPROC_SENYALAMIENTO); if (!Checks.esNulo(valorTmp)) {
			 * costasProcSenyalamiento = Float.valueOf(valorTmp);
			 * System.out.println("[INFO] - Costas procurador: " +
			 * valorTmp.toString()); } else {
			 * System.out.println("[INFO] - Costas procurador nulo"); } }
			 * 
			 * 
			 * Float sumPrincipal = Checks.esNulo(principalSenyalamiento) ? null
			 * : principalSenyalamiento + interesesSenyalamiento +
			 * costasProcSenyalamiento;
			 * System.out.println("[INFO] - Suma principal: " +
			 * (!Checks.esNulo(sumPrincipal) ? sumPrincipal.toString() :
			 * "nulo")); stub.setDeudaJudicial(!Checks.esNulo(sumPrincipal) ?
			 * Float.valueOf(sumPrincipal) : null);
			 */
			stub.setFechaSubasta(Checks.esNulo(subasta.getFechaSenyalamiento()) ? null : formatter.format(subasta.getFechaSenyalamiento()));
			System.out.println("[INFO] - Fecha señalamiento: " + (!Checks.esNulo(stub.getFechaSubasta()) ? stub.getFechaSubasta() : "nulo"));

			if (!Checks.esNulo(bienesSubasta)) {
				System.out.println("[INFO] - Hay bienesSubasta");
				// Añadimos los bienes
				for (Bien b : bienesSubasta) {
					if (b instanceof NMBBien) {
						NMBBien bien = (NMBBien) b;
						System.out.println("[INFO] - bien id: " + bien.getId());
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
						System.out.println("[INFO] - bien " + bien.getId() + " añadido");
					}
				}
			}
			stub.setDatosRegistrales(datosRegistrales);

			String tmpObservaciones = "";
			// Float sumDeudaJudicial = 0F;

			if (!Checks.esNulo(lotesSubasta)) {
				System.out.println("[INFO] - Hay lotesSubasta");
				for (LoteSubasta l : lotesSubasta) {
					boolean entrado = false;
					if (!Checks.esNulo(l.getBienes())) {
						System.out.println("[INFO] - Hay bienes en el lote");
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
									System.out.println("[INFO] - el bien tiene id contrato: " + contratoBien.getId().toString());
									lb.setOperacion(contratoBien.getDescripcion());
									System.out.println("[INFO] - check lotebien - Operacion:" + lb.getOperacion());
									lb.setDeudaEntidad(getSumaDeudaTotal(contratoBien));
									System.out.println("[INFO] - check lotebien - Deuda entidad:" + lb.getDeudaEntidad());
								} else {
									System.out.println("[INFO] - El bien no tiene contrato");
								}

								// lb.setOperacion(Checks.esNulo(contratoGeneral)
								// ? null : contratoGeneral.getDescripcion());

								lb.setLote(!Checks.esNulo(l.getNumLote()) ? String.valueOf(l.getNumLote()) : "-");
								System.out.println("[INFO] - check lotebien - Lote:" + lb.getLote());
								lb.setActivo(nmbBienLote.getNumeroActivo());
								System.out.println("[INFO] - check lotebien - Numero activo:" + lb.getActivo());
								lb.setFinca(Checks.esNulo(nmbBienLote.getDatosRegistralesActivo()) ? null : nmbBienLote.getDatosRegistralesActivo().getNumFinca());
								System.out.println("[INFO] - check lotebien - Finca:" + lb.getFinca());
								
								if (!Checks.esNulo(nmbBienLote.getAdicional()) && !Checks.esNulo(nmbBienLote.getAdicional().getDeudaSegunJuzgado())) {
									System.out.println("[INFO] - Deuda judicial del bien: "+nmbBienLote.getAdicional().getDeudaSegunJuzgado());
									lb.setDeudaJudicial(nmbBienLote.getAdicional().getDeudaSegunJuzgado());
									System.out.println("[INFO] - check lotebien - Deuda judicial:" + lb.getDeudaJudicial());
								}
								
								Float tipoSubasta = nmbBienLote.getTipoSubasta();
								lb.setTipoSubasta(tipoSubasta);
								System.out.println("[INFO] - check lotebien - Tipo subasta:" + lb.getTipoSubasta());
								lb.setTipoSubasta50(Checks.esNulo(tipoSubasta) ? null : tipoSubasta * 0.50F);
								System.out.println("[INFO] - check lotebien - TipoSubasta50:" + lb.getTipoSubasta50());
								lb.setTipoSubasta60(Checks.esNulo(tipoSubasta) ? null : tipoSubasta * 0.60F);
								System.out.println("[INFO] - check lotebien - TipoSubasta60:" + lb.getTipoSubasta60());
								lb.setTipoSubasta70(Checks.esNulo(tipoSubasta) ? null : tipoSubasta * 0.70F);
								System.out.println("[INFO] - check lotebien - TipoSubasta70:" + lb.getTipoSubasta70());
								Float valorTasacion = null;
								if (!Checks.esNulo(nmbBienLote.getValoraciones()) && nmbBienLote.getValoraciones().size() > 0) {
									valorTasacion = Checks.esNulo(nmbBienLote.getValoraciones().get(0).getImporteValorTasacion()) ? null : nmbBienLote.getValoraciones().get(0).getImporteValorTasacion();
								}
								lb.setTasacionActualizada(valorTasacion);
								System.out.println("[INFO] - check lotebien - Tasacion Actualizada:" + lb.getTasacionActualizada());
								lb.setTasacionActualizada70(Checks.esNulo(valorTasacion) ? null : valorTasacion * 0.70F);
								System.out.println("[INFO] - check lotebien - Tasacion Actualizada 70:" + lb.getTasacionActualizada70());

								lotes.add(lb);

								System.out.println("[INFO] - Bien añadido al lote");
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
								bb.setFinca(lb.getFinca());

								bienes.add(bb);

								System.out.println("[INFO] - Bien añadido a los bienes");
							}
						}
					}
					if (!Checks.esNulo(l.getObservaciones())) {
						tmpObservaciones += l.getObservaciones() + "<br>";
					}

					// if (!Checks.esNulo(l.getInsValorSubastaSinBienes())) {
					// sumDeudaJudicial += l.getInsValorSubastaSinBienes();
					// }
				}
			}

			stub.setDeudaJudicial(tmpDeudaJudicial);
			stub.setObservaciones(tmpObservaciones);
			stub.setLotes(lotes);
			stub.setBienes(bienes);

			List<Persona> demandados = procedimientoSubasta.getPersonasAfectadas();
			List<ProcedimientoContratoExpediente> prc_cex = procedimientoSubasta.getProcedimientosContratosExpedientes();

			Map<Long, Contrato> mapOperacionesConex = new HashMap<Long, Contrato>();

			if (!Checks.esNulo(demandados)) {
				for (Persona demandado : demandados) { // Recorro todos los
														// demandados
					List<Contrato> contratosDemandados = demandado.getContratos();
					if (!Checks.esNulo(contratosDemandados)) {
						for (Contrato contratoDemandado : contratosDemandados) { // Recorro
																					// todos
																					// los
																					// contratos
																					// de
																					// cada
																					// demandado
							if (!Checks.esNulo(prc_cex)) {
								for (ProcedimientoContratoExpediente pcex : prc_cex) { // Recorro
																						// todos
																						// los
																						// contratos
																						// del
																						// procedimiento
									if (!Checks.esNulo(pcex.getExpedienteContrato()) && !Checks.esNulo(pcex.getExpedienteContrato().getContrato())) {
										if (!pcex.getExpedienteContrato().getContrato().getId().equals(contratoDemandado.getId())) { // Si
																																		// el
																																		// contrato
																																		// no
																																		// está
																																		// en
																																		// el
																																		// procedimiento
																																		// lo
																																		// añado
											mapOperacionesConex.put(contratoDemandado.getId(), contratoDemandado);
										}
									}
								}
							} else { // Si el procedimiento no tiene contrato lo
										// añado
								mapOperacionesConex.put(contratoDemandado.getId(), contratoDemandado);
							}
						}
					}
				}
			}

			// Añadimos el map de operaciones al list
			Iterator it = mapOperacionesConex.entrySet().iterator();

			while (it.hasNext()) {
				Map.Entry<Long, Contrato> op = (Map.Entry<Long, Contrato>) it.next();
				if (!Checks.esNulo(op.getValue())) {
					Contrato opContrato = op.getValue();

					OperacionesConexionadasBean operacionConexionada = new OperacionesConexionadasBean();

					operacionConexionada.setDeuda(getSumaDeudaTotal(opContrato));

					operacionConexionada.setGarantia(op.getValue().getGarantia1() != null ? op.getValue().getGarantia1().getDescripcion() : "");
					operacionConexionada.setObservaciones("");
					operacionConexionada.setOperacion(op.getValue().getDescripcion());
					// operacionConexionada.setTotal("");

					operacionesConexionadas.add(operacionConexionada);
				}
			}
			stub.setOperacionesConexionadas(operacionesConexionadas);

			System.out.println("[INFO] - END - Informe subasta finalizado correctamente");

			return Arrays.asList((Object) stub);

		} else {
			System.out.println("[INFO] - ERROR - No existe procedimiento subasta");
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

}

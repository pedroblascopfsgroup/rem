package es.pfsgroup.procedimientos.adjudicacion;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.multigestor.api.GestorAdicionalAsuntoApi;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.api.AdjudicacionHandlerDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.dto.DtoCrearAnotacion;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBInformacionRegistralBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class AdjudicacionHayaLeaveActionHandler extends
		PROGenericLeaveActionHandler {
	/**
	 * 
	 */
	private static final long serialVersionUID = -5583230911255732281L;

	private SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	
	private final static String CODIGO_TIPO_GESTOR_ADMISION = "GAREO";

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private Executor executor;

	@Override
	protected void process(Object delegateTransitionClass,
			Object delegateSpecificClass, ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass,
				executionContext);
		Boolean tareaTemporal = (executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PARALIZAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_ACTIVAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PRORROGA));
		if (!tareaTemporal) {
			personalizamosTramiteAdjudicacion(executionContext);
		}
	}

	private void personalizamosTramiteAdjudicacion(
			ExecutionContext executionContext) {

		Procedimiento prc = getProcedimiento(executionContext);
		TareaExterna tex = getTareaExterna(executionContext);
		List<EXTTareaExternaValor> listado = ((SubastaProcedimientoApi) proxyFactory
				.proxy(SubastaProcedimientoApi.class))
				.obtenerValoresTareaByTexId(tex.getId());

		if ("H005_SolicitudDecretoAdjudicacion".equals(executionContext
				.getNode().getName())) {
			for (TareaExternaValor tev : listado) {
				try {
					if ("fechaSolicitud".equals(tev.getNombre())) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(
								AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_SOLICITUD_DECRETO,
								prc.getId(), fecha);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		
		else if ("H005_ConfirmarContabilidad".equals(executionContext
				.getNode().getName())) {
			for (TareaExternaValor tev : listado) {
				try {
					if ("fecha".equals(tev.getNombre())) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(
								AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_CONTABILIDAD,
								prc.getId(), fecha);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		else if ("H005_notificacionDecretoAdjudicacionAEntidad"
				.equals(executionContext.getNode().getName())) {
			for (TareaExternaValor tev : listado) {
				try {
					if ("fecha".equals(tev.getNombre())) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(
								AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_NOTIFICACION_DECRETO,
								prc.getId(), fecha);
					} else if ("comboEntidadAdjudicataria".equals(tev
							.getNombre())) {
						String nombre = tev.getValor();
						executor.execute(
								AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_ENTIDAD_ADJUDICATARIA,
								prc.getId(), nombre);
					} else if ("fondo".equals(tev.getNombre())) {
						String nombre = tev.getValor();
						if (Checks.esNulo(nombre)) {
							nombre = "";
						}
						executor.execute(
								AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FONDO,
								prc.getId(), nombre);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		else if ("H005_ConfirmarTestimonio".equals(executionContext.getNode()
				.getName())) {
			for (TareaExternaValor tev : listado) {
				try {
					if ("fechaTestimonio".equals(tev.getNombre())) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(
								AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_FECHA_TESTIMONIO_DECRETO,
								prc.getId(), fecha);
					} else if ("fechaEnvioGestoria".equals(tev.getNombre())) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(
								AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_FECHA_ENVIO_GESTORIA,
								prc.getId(), fecha);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}

		else if ("H005_RegistrarEntregaTitulo".equals(executionContext
				.getNode().getName())) {
			for (TareaExternaValor tev : listado) {
				try {
					if ("fechaRecepcion".equals(tev.getNombre())) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(
								AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_FECHA_RECEPCION,
								prc.getId(), fecha);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}

		else if ("H005_RegistrarPresentacionEnHacienda".equals(executionContext
				.getNode().getName())) {
			for (TareaExternaValor tev : listado) {
				try {
					if ("fechaPresentacion".equals(tev.getNombre())) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(
								AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_FECHA_PRESENTACION_HACIENDA,
								prc.getId(), fecha);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}

		else if ("H005_RegistrarPresentacionEnRegistro".equals(executionContext
				.getNode().getName())) {
			for (TareaExternaValor tev : listado) {
				try {
					if ("fechaPresentacion".equals(tev.getNombre())) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(
								AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_FECHA_PRESENTACION_REGISTRO,
								prc.getId(), fecha);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}

		else if ("H005_RegistrarInscripcionDelTitulo".equals(executionContext
				.getNode().getName())) {
			for (TareaExternaValor tev : listado) {
				try {
					if ("fechaInscripcion".equals(tev.getNombre()) && tev.getValor()!=null) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(
								AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_FECHA_INSCRIPCION_TITULO,
								prc.getId(), fecha);
					} else if ("fechaEnvioDecretoAdicion".equals(tev.getNombre()) && tev.getValor()!=null) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(
								AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_FECHA_ENVIO_DECRETO_ADICION,
								prc.getId(), fecha);
					} else if ("comboSituacionTitulo".equals(tev
							.getNombre())) {						
						executor.execute(
								AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_SITUACION_TITULO,
								prc.getId(), tev.getValor());
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		else if ("H011_RegistrarSolicitudMoratoria".equals(executionContext
				.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("fechaSolicitud".equals(tev.getNombre())) {
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_SOL_MORAT,
									prc.getId(), fecha);

						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}

		else if ("H011_RegistrarResolucion".equals(executionContext.getNode()
				.getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("fechaResolucion".equals(tev.getNombre())) {
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_RES_MORAT,
									prc.getId(), fecha);

						}
						if ("comboFavDesf".equals(tev.getNombre())) {
							String nombre = tev.getValor();
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_CARGA_RESULTADO_MORAT,
									prc.getId(), nombre);

						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}

		else if ("H015_RegistrarSolicitudPosesion".equals(executionContext
				.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("comboOcupado".equals(tev.getNombre())) {
							String valor = tev.getValor();
							Boolean valorBooleano = valor != null
									&& valor.equalsIgnoreCase(DDSiNo.SI);
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_OCUPADO,
									prc.getId(), valorBooleano);

						} else if ("comboPosesion".equals(tev.getNombre())) {
							String valor = tev.getValor();
							Boolean valorBooleano = valor != null
									&& valor.equalsIgnoreCase(DDSiNo.SI);
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_POSIBLE_POSESION,
									prc.getId(), valorBooleano);

						} else if ("fechaSolicitud".equals(tev.getNombre())) {
							Date valor = formatter.parse(tev.getValor());
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SOLICITUD,
									prc.getId(), valor);

						}

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}

		else if ("H015_RegistrarSenyalamientoPosesion".equals(executionContext
				.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {

						if ("fechaSenyalamiento".equals(tev.getNombre())) {
							Date valor = formatter.parse(tev.getValor());
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SENYALAMIENTO,
									prc.getId(), valor);
							
							List<Usuario> lUsuario = proxyFactory.proxy(
									GestorAdicionalAsuntoApi.class).findGestoresByAsunto(
											prc.getAsunto().getId(),
											CODIGO_TIPO_GESTOR_ADMISION);
							if (!Checks.estaVacio(lUsuario)) {
								List<Long> listIdUsuarioGestor = new ArrayList<Long>();
								for (Usuario usu : lUsuario) {
									listIdUsuarioGestor.add(usu.getId());
								}
								
								NMBInformacionRegistralBienInfo infoBien = getDatosRegistralesActivo(prc);
								// Se crea la anotacion y se llamara al EXECUTOR
								String asunto = "Referencia del asunto de posesi&oacute;n";
								StringBuilder cuerpoEmail = new StringBuilder();
								cuerpoEmail.append("Se ha producido el se&ntilde;alamiento del");
								cuerpoEmail.append(" bien con numero de finca:");
								cuerpoEmail.append(!Checks.esNulo(infoBien) && !Checks.esNulo(infoBien.getNumFinca()) ? infoBien.getNumFinca() : "     "); // numeroFinca
								cuerpoEmail.append(" y referencia catastral:");
								cuerpoEmail.append(!Checks.esNulo(infoBien) && !Checks.esNulo(infoBien.getReferenciaCatastralBien()) ? infoBien.getReferenciaCatastralBien() : "          "); // RefCatastral
								cuerpoEmail.append(" con fecha ");
								cuerpoEmail.append(!Checks.esNulo(valor) ? DateFormat.toString(valor) : ""); // Fecha
								cuerpoEmail.append(" para su informaci&oacute;n");

								DtoCrearAnotacion crearAnotacion = DtoCrearAnotacion
										.crearAnotacionDTO(
												listIdUsuarioGestor,
												false, true, null, asunto,
												cuerpoEmail.toString(),
												prc.getAsunto().getId(),
												DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO,
												"A");

								proxyFactory.proxy(
										AdjudicacionHandlerDelegateApi.class)
										.createAnotacion(crearAnotacion);
							}
						}

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}

		else if ("H015_RegistrarPosesionYLanzamiento".equals(executionContext
				.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {

						if ("fecha".equals(tev.getNombre())) {
							Date valor = formatter.parse(tev.getValor());
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_REALIZACION,
									prc.getId(), valor);

						} else if ("fechaSolLanza".equals(tev.getNombre())) {
							Date valor = formatter.parse(tev.getValor());
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SOL_LANZAMIENTO,
									prc.getId(), valor);

						} else if ("comboOcupado".equals(tev.getNombre())) {
							String valor = tev.getValor();
							Boolean valorBooleano = valor != null
									&& valor.equalsIgnoreCase(DDSiNo.SI);
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_OCUPANTES_DURANTE,
									prc.getId(), valorBooleano);

						} else if ("comboLanzamiento".equals(tev.getNombre())) {
							String valor = tev.getValor();
							Boolean valorBooleano = valor != null
									&& valor.equalsIgnoreCase(DDSiNo.SI);
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_LANZAMIENTO_NECESARIO,
									prc.getId(), valorBooleano);
						} else if ("comboFuerzaPublica".equals(tev.getNombre())) {
							String valor = tev.getValor();
							Boolean valorBooleano = valor != null
									&& valor.equalsIgnoreCase(DDSiNo.SI);
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_FUERZA_PUBLICA,
									prc.getId(), valorBooleano);
						}

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}

		else if ("H015_RegistrarSenyalamientoLanzamiento"
				.equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {

						if ("fecha".equals(tev.getNombre())) {
							Date valor = formatter.parse(tev.getValor());
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SENYALAMIENTO_LANZAMIENTO,
									prc.getId(), valor);

							List<Usuario> lUsuario = proxyFactory.proxy(
									GestorAdicionalAsuntoApi.class).findGestoresByAsunto(
											prc.getAsunto().getId(),
											CODIGO_TIPO_GESTOR_ADMISION);
							if (!Checks.estaVacio(lUsuario)) {
								List<Long> listIdUsuarioGestor = new ArrayList<Long>();
								for (Usuario usu : lUsuario) {
									listIdUsuarioGestor.add(usu.getId());
								}
								
								NMBInformacionRegistralBienInfo infoBien = getDatosRegistralesActivo(prc);
								
								// Se crea la anotacion y se llamara al EXECUTOR
								String asunto = "Referencia del asunto de posesi&oacute;n";
								StringBuilder cuerpoEmail = new StringBuilder();
								cuerpoEmail.append("Se ha producido el se&ntilde;alamiento de lanzamiento del bien");
								cuerpoEmail.append(" con numero de finca:");
								cuerpoEmail.append(!Checks.esNulo(infoBien) && !Checks.esNulo(infoBien.getNumFinca()) ? infoBien.getNumFinca() : "     "); // numeroFinca
								cuerpoEmail.append(" y referencia catastral:");
								cuerpoEmail.append(!Checks.esNulo(infoBien) && !Checks.esNulo(infoBien.getReferenciaCatastralBien()) ? infoBien.getReferenciaCatastralBien() : "          "); // RefCatastral
								cuerpoEmail.append(" con fecha");
								cuerpoEmail.append(!Checks.esNulo(valor) ? DateFormat.toString(valor) : ""); // Fecha
								cuerpoEmail.append(" para su informaci&oacute;n");
								
								DtoCrearAnotacion crearAnotacion = DtoCrearAnotacion
										.crearAnotacionDTO(
												listIdUsuarioGestor,
												false, true, null, asunto,
												cuerpoEmail.toString(),
												prc.getAsunto().getId(),
												DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO,
												"A");

								proxyFactory.proxy(
										AdjudicacionHandlerDelegateApi.class)
										.createAnotacion(crearAnotacion);
							}
						}

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}

		else if ("H015_RegistrarLanzamientoEfectuado".equals(executionContext
				.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {

						if ("fecha".equals(tev.getNombre())) {
							Date valor = formatter.parse(tev.getValor());
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_LANZAMIENTO_EFECTUADO,
									prc.getId(), valor);
						}

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}

		else if ("H015_RegistrarDecisionLlaves".equals(executionContext
				.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("comboLlaves".equals(tev.getNombre())) {
							String valor = tev.getValor();
							Boolean valorBooleano = valor != null
									&& valor.equalsIgnoreCase(DDSiNo.SI);
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_LLAVES_NECESARIAS,
									prc.getId(), valorBooleano);

						}

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}

		// Llaves
		else if ("H040_RegistrarCambioCerradura".equals(executionContext
				.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("fecha".equals(tev.getNombre())) {
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_CAMBIO_CERRADURA,
									prc.getId(), fecha);

						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}

		else if ("H040_RegistrarEnvioLlaves".equals(executionContext.getNode()
				.getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("nombre".equals(tev.getNombre())) {
							String nombre = formatter.format(tev.getValor());
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_NOMBRE_ER_DEPO,
									prc.getId(), nombre);

						} else if ("fecha".equals(tev.getNombre())) {
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_ENVIO,
									prc.getId(), fecha);

						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

		}

		else if ("H040_RegistrarRecepcionLlaves".equals(executionContext
				.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("fecha".equals(tev.getNombre())) {
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_RECEPCION_ER_DEPO,
									prc.getId(), fecha);

						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

		}

		else if ("H008_RegistrarPresentacionInscripcion"
				.equals(executionContext.getNode().getName())
				|| "H008_RegistrarPresentacionInscripcionEco"
						.equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("fechaPresentacion".equals(tev.getNombre())) {
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_PRESENTACION,
									prc.getId(), fecha);
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

		}

		else if ("H008_RegInsCancelacionCargasEconomicas"
				.equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("fechaInsEco".equals(tev.getNombre())) {
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(
									AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_INS,
									prc.getId(), fecha);

						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

		}
	}

	private NMBInformacionRegistralBienInfo getDatosRegistralesActivo(
			Procedimiento prc) {
		NMBInformacionRegistralBienInfo infoBien = null;
		if (!Checks.estaVacio(prc.getBienes())) {
			ProcedimientoBien prcBien = prc.getBienes().get(0);
			NMBBien nmbBien = (NMBBien) executor.execute(
					PrimariaBusinessOperation.BO_BIEN_MGR_GET, prcBien.getBien().getId());
			infoBien = nmbBien.getDatosRegistralesActivo();
		}
		return infoBien;
	}
	
}

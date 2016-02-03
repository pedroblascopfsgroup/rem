package es.pfsgroup.procedimientos.adjudicacion;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.api.AdjudicacionHandlerDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class AdjudicacionLeaveActionHandler extends PROGenericLeaveActionHandler {
	/**
	 * 
	 */
	private static final long serialVersionUID = -5583230911255732281L;

	private SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private Executor executor;

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
		
		Boolean tareaTemporal = (executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PARALIZAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_ACTIVAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PRORROGA));  //"activarProrroga"
		
		//Solo si el handle ha sido invocado por el guardado de la tarea, dentro del flujo BPM, realiza las acciones determinadas
		//Si ha sido invocado por una acci�n de paralizar la tarea o por una acci�n autoprorroga, no realiza las acciones determinadas
		if (!tareaTemporal) {
			personalizamosTramiteAdjudicacion(executionContext);
		}
	}

	private void personalizamosTramiteAdjudicacion(ExecutionContext executionContext) {

		// executionContext.getProcessDefinition().getName();
		// executionContext.getEventSource().getName();
		// executionContext.getNode().getName();

		Procedimiento prc = getProcedimiento(executionContext);
		TareaExterna tex = getTareaExterna(executionContext);
		List<EXTTareaExternaValor> listado = ((SubastaProcedimientoApi) proxyFactory.proxy(SubastaProcedimientoApi.class)).obtenerValoresTareaByTexId(tex.getId());

		// COMPROBACIONES GESTION DE LLAVES------------------------------------
		// Items de Tarea1: Registrar Cambio Cerradura
		if ("P417_RegistrarCambioCerradura".equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("fecha".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
							// TODO
							/*
							 * Al completarse la tarea se traslada el
							 * valor a Fecha cambio cerradura en el apartado de
							 * datos de gestión de llaves del bien
							 */
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_CAMBIO_CERRADURA, prc.getId(), fecha);

						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

			
		}else if ("P413_ContabilizarCierreDeuda".equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("fecha".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_CONTABILIDAD, prc.getId(), fecha);

						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
			// Items de Tarea2: Registrar Envio de Llaves
		}else if ("P417_RegistrarEnvioLlaves".equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						/*
						 * Al completarse la tarea deberá trasladar el valor a
						 * Nombre del 1er depositario Fecha envío 1er
						 * depositario en el apartado de datos de gestión de
						 * llaves del bien
						 */
						if ("nombre".equals(tev.getNombre())) {
							/*
							 * Acciones con nombre
							 */
							String nombre = tev.getValor();
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_NOMBRE_ER_DEPO, prc.getId(), nombre);

						} else if ("fecha".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
							/*
							 * Acciones con fecha
							 */
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_ENVIO, prc.getId(), fecha);

						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

			// Items de Tarea3: Registrar Recepcion de Llaves
		} else if ("P417_RegistrarRecepcionLlaves".equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("fecha".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
							/*
							 * Al completarse la tarea deberá trasladar el
							 * valor a Fecha recepción 1er depositario en el
							 * apartado de datos de gestión de llaves del bien
							 */
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_RECEPCION_ER_DEPO, prc.getId(), fecha);

						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

			// Items de Tarea4: Registrar Envio de Llaves Depositario Final
		} else if ("P417_RegistrarEnvioLlavesDepFinal".equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						/*
						 * Al completarse la tarea deberá trasladar el valor a
						 * Nombre del depositario final Fecha envio depositario
						 * final en el apartado de datos de gestión de llaves
						 * del bien
						 */
						if ("nombre".equals(tev.getNombre())) {
							/*
							 * Acciones con nombre
							 */
							String nombre = tev.getValor();
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_NOMBRE_DEPO_FINAL, prc.getId(), nombre);

						} else if ("fecha".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
							/*
							 * Acciones con fecha
							 */
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_RECEP_FINAL, prc.getId(), fecha);
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

			// Items de Tarea5: Registrar Recepcion de Llaves Depositario Final
		} else if ("P417_RegistrarRecepcionLlavesDepFinal".equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("fecha".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
							/*
							 * Al completarse la tarea deberá trasladar el
							 * valor a Fecha recepcion depositario final en el
							 * apartado de datos de gestión de llaves del bien
							 */
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_RECEPCION_LLAVES, prc.getId(), fecha);

						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

			// -------------------------------------------Fin Tramite Gestion
			// llaves

		} else if ("P415_RegistrarPresentacionInscripcion".equals(executionContext.getNode().getName()) || "P415_RegistrarPresentacionInscripcionEco".equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("fechaPresentacion".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
							/*
							 * Al completarse la tarea el sistema guardará en
							 * cada una de las cargas afectas la fecha de
							 * cancelación de la parte económica de la misma
							 */
							// ejemplo:
							// sub.setFechaAnuncio(formatter.parse(tev.getValor()));
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_PRESENTACION, prc.getId(), fecha);
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

		} else if ("P415_RegInsCancelacionCargasEconomicas".equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("fechaInsEco".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
							/*
							 * Al completarse la tarea, la fecha de
							 * presentación consignada por el usuario se
							 * guardará en cada una de las cargas afectas
							 */
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_INS, prc.getId(), fecha);

						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

		} else if ("P418_RegistrarSolicitudMoratoria".equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("fechaSolicitud".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
							/*
							 * Al completarse la tarea, la fecha de
							 * presentación consignada por el usuario se
							 * guardará en cada una de las cargas afectas
							 */
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_SOL_MORAT, prc.getId(), fecha);

						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

		} else if ("P418_RegistrarResolucion".equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("fechaResolucion".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
							/*
							 * Al completarse la tarea, la fecha de
							 * presentación consignada por el usuario se
							 * guardará en cada una de las cargas afectas
							 */
							Date fecha = formatter.parse(tev.getValor());
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_RES_MORAT, prc.getId(), fecha);

						}
						if ("comboFavDesf".equals(tev.getNombre())) {
							/*
							 * Al completarse la tarea, la fecha de
							 * presentación consignada por el usuario se
							 * guardará en cada una de las cargas afectas
							 */
							String nombre = tev.getValor();
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_CARGA_RESULTADO_MORAT, prc.getId(), nombre);

						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

		} 
		else if ("P413_notificacionDecretoAdjudicacionAEntidad".equals(executionContext.getNode().getName())) {
			for (TareaExternaValor tev : listado) {
				try {
					// TODO
					/*
					 * guardar los datos "fecha" (notificación en el juzgado
					 * del Decreto de Adjudicación),
					 * "comboEntidadAdjudicataria" (entidad adjudicataria),
					 * "fondo" (fondos registrados en el sistema)
					 */
					if ("fecha".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_NOTIFICACION_DECRETO, prc.getId(), fecha);						
					} else if ("comboEntidadAdjudicataria".equals(tev.getNombre())) {
						String nombre = tev.getValor();
						executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_ENTIDAD_ADJUDICATARIA, prc.getId(), nombre);
					} else if ("fondo".equals(tev.getNombre())) {
						String nombre = tev.getValor();
						if(Checks.esNulo(nombre)){ 
							nombre = "";
						}
						executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FONDO, prc.getId(), nombre);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		} else if ("P413_notificacionDecretoAdjudicacionAlContrario".equals(executionContext.getNode().getName())) {

		} else if ("P413_SolicitudTestimonioDecretoAdjudicacion".equals(executionContext.getNode().getName())) {

		} else if ("P413_ConfirmarTestimonio".equals(executionContext.getNode().getName())) {
			for (TareaExternaValor tev : listado) {
				try {
					if ("fechaTestimonio".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_FECHA_TESTIMONIO_DECRETO, prc.getId(), fecha);						
					} else if ("fechaEnvioGestoria".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_FECHA_ENVIO_GESTORIA, prc.getId(), fecha);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			//Guardamos además la gestoría asignada en la tabla de adjudicación FASE-932
			executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_GESTORIA, prc.getId());
			

		} else if ("P413_RegistrarEntregaTitulo".equals(executionContext.getNode().getName())) {
			for (TareaExternaValor tev : listado) {
				try {
					/*
					 * guardamos los datos de "fechaRecepcion" (fecha en que
					 * recibe la información de los documentos asignados que
					 * le han enviado)
					 */
					if ("fechaRecepcion".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_FECHA_RECEPCION, prc.getId(), fecha);						
					}
					else if ("comboSituacionTitulo".equals(tev.getNombre())) {
						String nombre = tev.getValor();
						executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_SITUACION_TITULO, prc.getId(), nombre);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		} else if ("P413_RegistrarPresentacionEnHacienda".equals(executionContext.getNode().getName())) {
			for (TareaExternaValor tev : listado) {
				try {
					// TODO
					/*
					 * guardamos los datos de "fechaPresentacion" (fecha de
					 * presentación en Hacienda)
					 */
					if ("fechaPresentacion".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_FECHA_PRESENTACION_HACIENDA, prc.getId(), fecha);						
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		} else if ("P413_RegistrarPresentacionEnRegistro".equals(executionContext.getNode().getName())) {
			for (TareaExternaValor tev : listado) {
				try {
					// TODO
					/*
					 * guardamos los datos de "fechaPresentacion" (fecha de
					 * presentación en el registro)
					 */
					if ("fechaPresentacion".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_FECHA_PRESENTACION_REGISTRO, prc.getId(), fecha);						
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		} else if ("P413_RegistrarInscripcionDelTitulo".equals(executionContext.getNode().getName())) {
			for (TareaExternaValor tev : listado) {
				try {
					// TODO
					/*
					 * guardamos los datos de "fechaInscripcion" (fecha de
					 * inscrito en el registro) y "fechaEnvioDecretoAdicion"
					 * (fecha de envío del decreto para la adición)
					 */
					if ("fechaInscripcion".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_FECHA_INSCRIPCION_TITULO, prc.getId(), fecha);						
					} else if ("comboSituacionTitulo".equals(tev.getNombre())) {
						String nombre = tev.getValor();
						executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_SITUACION_TITULO, prc.getId(), nombre);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		} else if ("P416_RegistrarSolicitudPosesion".equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("comboOcupado".equals(tev.getNombre())) {
							/*
							 * Al completarse la tarea, la fecha de
							 * presentación consignada por el usuario se
							 * guardará en cada una de las cargas afectas
							 */
							String valor = tev.getValor();
							Boolean valorBooleano = valor != null && valor.equalsIgnoreCase(DDSiNo.SI);
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_OCUPADO, prc.getId(), valorBooleano);

						} else if ("comboPosesion".equals(tev.getNombre())) {
							/*
							 * Al completarse la tarea, la fecha de
							 * presentación consignada por el usuario se
							 * guardará en cada una de las cargas afectas
							 */
							String valor = tev.getValor();
							Boolean valorBooleano = valor != null && valor.equalsIgnoreCase(DDSiNo.SI);
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_POSIBLE_POSESION, prc.getId(), valorBooleano);

						} else if ("fechaSolicitud".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
							/*
							 * Al completarse la tarea, la fecha de
							 * presentación consignada por el usuario se
							 * guardará en cada una de las cargas afectas
							 */
							Date valor = formatter.parse(tev.getValor());
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SOLICITUD, prc.getId(), valor);

						}

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

		} else if ("P416_RegistrarSenyalamientoPosesion".equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {

						if ("fechaSenyalamiento".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
							/*
							 * Al completarse la tarea, la fecha de
							 * presentación consignada por el usuario se
							 * guardará en cada una de las cargas afectas
							 */
							Date valor = formatter.parse(tev.getValor());
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SENYALAMIENTO, prc.getId(), valor);
						}

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

		} else if ("P416_RegistrarPosesionYLanzamiento".equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {

						if ("fecha".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
							/*
							 * Al completarse la tarea, la fecha de
							 * presentación consignada por el usuario se
							 * guardará en cada una de las cargas afectas
							 */
							Date valor = formatter.parse(tev.getValor());
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_REALIZACION, prc.getId(), valor);

						} else if ("fechaSolLanza".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
							/*
							 * Al completarse la tarea, la fecha de
							 * presentación consignada por el usuario se
							 * guardará en cada una de las cargas afectas
							 */
							Date valor = formatter.parse(tev.getValor());
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SOL_LANZAMIENTO, prc.getId(), valor);

						} else if ("comboOcupado".equals(tev.getNombre())) {
							/*
							 * Al completarse la tarea, la fecha de
							 * presentación consignada por el usuario se
							 * guardará en cada una de las cargas afectas
							 */
							String valor = tev.getValor();
							Boolean valorBooleano = valor != null && valor.equalsIgnoreCase(DDSiNo.SI);
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_OCUPANTES_DURANTE, prc.getId(), valorBooleano);

						} else if ("comboLanzamiento".equals(tev.getNombre())) {
							/*
							 * Al completarse la tarea, la fecha de
							 * presentación consignada por el usuario se
							 * guardará en cada una de las cargas afectas
							 */
							String valor = tev.getValor();
							Boolean valorBooleano = valor != null && valor.equalsIgnoreCase(DDSiNo.SI);
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_LANZAMIENTO_NECESARIO, prc.getId(), valorBooleano);
						} else if ("comboFuerzaPublica".equals(tev.getNombre())) {
							/*
							 * Al completarse la tarea, el campo fuerza pública
							 * se guardará en el bien
							 */
							String valor = tev.getValor();
							Boolean valorBooleano = valor != null && valor.equalsIgnoreCase(DDSiNo.SI);
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_FUERZA_PUBLICA, prc.getId(), valorBooleano);
						} else if ("comboEntregaVoluntaria".equals(tev.getNombre())) {
							/*
							 * Al completarse la tarea, el campo 'entrega voluntaria posesion' 
							 * insertado por el usuario se
							 * guardará en cada una de las cargas afectas
							 */
							String valor = tev.getValor();
							Boolean valorBooleano = valor != null && valor.equalsIgnoreCase(DDSiNo.SI);
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_ENTREGA_VOLUNTARIA, prc.getId(), valorBooleano);
						}

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

		} else if ("P416_RegistrarSenyalamientoLanzamiento".equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {

						if ("fecha".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
							/*
							 * Al completarse la tarea, la fecha de
							 * presentación consignada por el usuario se
							 * guardará en cada una de las cargas afectas
							 */
							Date valor = formatter.parse(tev.getValor());
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SENYALAMIENTO_LANZAMIENTO, prc.getId(), valor);
						}

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

		} else if ("P416_RegistrarLanzamientoEfectuado".equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {

						if ("fecha".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
							/*
							 * Al completarse la tarea, la fecha de
							 * presentación consignada por el usuario se
							 * guardará en cada una de las cargas afectas
							 */
							Date valor = formatter.parse(tev.getValor());
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_LANZAMIENTO_EFECTUADO, prc.getId(), valor);
						}

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

		} else if ("P416_RegistrarDecisionLlaves".equals(executionContext.getNode().getName())) {

			if (!Checks.esNulo(listado)) {
				for (TareaExternaValor tev : listado) {
					try {
						if ("comboLlaves".equals(tev.getNombre())) {
							/*
							 * Al completarse la tarea, la fecha de
							 * presentación consignada por el usuario se
							 * guardará en cada una de las cargas afectas
							 */
							String valor = tev.getValor();
							Boolean valorBooleano = valor != null && valor.equalsIgnoreCase(DDSiNo.SI);
							executor.execute(AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_POSESION_LLAVES_NECESARIAS, prc.getId(), valorBooleano);

						}

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}

	}
	// FIN JOSEVI
}

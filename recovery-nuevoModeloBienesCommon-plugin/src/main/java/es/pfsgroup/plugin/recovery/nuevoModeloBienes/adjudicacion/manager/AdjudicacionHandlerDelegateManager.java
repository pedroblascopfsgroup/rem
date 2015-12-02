package es.pfsgroup.plugin.recovery.nuevoModeloBienes.adjudicacion.manager;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.HtmlUtils;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.devon.mail.MailManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.procesosJudiciales.model.DDFavorable;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.api.AdjudicacionHandlerDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.dto.DtoCrearAnotacion;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.dto.DtoCrearAnotacionUsuario;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.NMBProjectContext;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDEntidadAdjudicataria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionTitulo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoFondo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.recovery.ext.api.tareas.EXTCrearTareaException;
import es.pfsgroup.recovery.ext.api.tareas.EXTTareasApi;
import es.pfsgroup.recovery.ext.impl.tareas.EXTDtoGenerarTareaIdividualizadaImpl;

/**
 *
 */
@Service("adjudicacionHandlerDelegateManager")
public class AdjudicacionHandlerDelegateManager implements
		AdjudicacionHandlerDelegateApi {

	private static final String SUBTIPO_ANOTACION_AUTOTAREA = "700";
	private static final String SUBTIPO_ANOTACION_TAREA = "700";
	private static final String SUBTIPO_ANOTACION_NOTIFICACION = "701";

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Resource(name = "mailManager")
	private MailManager mailManager;

	@Autowired
	private Executor executor;

	@Autowired
	private GenericABMDao genericDao;

        protected NMBProjectContext nmbProjectContext;
        
	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_PRESENTACION)
	public void insertarFechaPresentacionCarga(Long prcId,
			Date fechaPresentacion) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					// no hay cargas
					if (cargas == null
							|| (cargas != null && cargas.size() == 0)) {
						// No hacemos nada
					} else {
						// hay cargas
						for (NMBBienCargas carga : cargas) {
							carga.setFechaPresentacion(fechaPresentacion);
							carga.setBien(nmbBien);
							proxyFactory.proxy(EditBienApi.class).guardarCarga(
									carga);
						}
					}
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_INS)
	public void insertarFechaInsCarga(Long prcId, Date fechaIns) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					// no hay cargas
					if (cargas == null
							|| (cargas != null && cargas.size() == 0)) {
						// No hacemos nada
					} else {
						// hay cargas
						for (NMBBienCargas carga : cargas) {
							carga.setFechaInscripcion(fechaIns);
							carga.setBien(nmbBien);
							proxyFactory.proxy(EditBienApi.class).guardarCarga(
									carga);
						}
					}
				}
			}
		}

	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_CAMBIO_CERRADURA)
	public void insertarFechaCambioCerradura(Long prcId, Date fecha) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					// no hay cargas
					if (cargas == null
							|| (cargas != null && cargas.size() == 0)) {
						// No hacemos nada
					} else {
						// hay cargas
						NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
								.getAdjudicacion();
						adjudicacion.setFechaCambioCerradura(fecha);
						nmbBien.setAdjudicacion(adjudicacion);
						proxyFactory.proxy(EditBienApi.class)
								.guardarAdjudicacion(adjudicacion);

					}
				}
			}
		}

	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_RECEP_FINAL)
	public void insertarFechaRecepcionFinal(Long prcId, Date fecha) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					// no hay cargas
					if (cargas == null
							|| (cargas != null && cargas.size() == 0)) {
						// No hacemos nada
					} else {
						// hay cargas
						NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
								.getAdjudicacion();
						adjudicacion.setFechaRecepcionDepositario(fecha);
						nmbBien.setAdjudicacion(adjudicacion);
						proxyFactory.proxy(EditBienApi.class)
								.guardarAdjudicacion(adjudicacion);
					}
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_ENVIO)
	public void insertarFechaEnvioLlaves(Long prcId, Date fecha) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					// no hay cargas
					if (cargas == null
							|| (cargas != null && cargas.size() == 0)) {
						// No hacemos nada
					} else {
						// hay cargas
						NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
								.getAdjudicacion();
						adjudicacion.setFechaEnvioLLaves(fecha);
						nmbBien.setAdjudicacion(adjudicacion);
						proxyFactory.proxy(EditBienApi.class)
								.guardarAdjudicacion(adjudicacion);
					}
				}
			}
		}

	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_RECEPCION_ER_DEPO)
	public void insertarFechaRecepcionErDepo(Long prcId, Date fecha) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					// no hay cargas
					if (cargas == null
							|| (cargas != null && cargas.size() == 0)) {
						// No hacemos nada
					} else {
						// hay cargas
						NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
								.getAdjudicacion();
						adjudicacion.setFechaRecepcionDepositario(fecha);
						nmbBien.setAdjudicacion(adjudicacion);
						proxyFactory.proxy(EditBienApi.class)
								.guardarAdjudicacion(adjudicacion);
					}
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_RECEPCION_LLAVES)
	public void insertarFechaRecepcionLLaves(Long prcId, Date fecha) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					// no hay cargas
					if (cargas == null
							|| (cargas != null && cargas.size() == 0)) {
						// No hacemos nada
					} else {
						// hay cargas
						NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
								.getAdjudicacion();
						adjudicacion.setFechaRecepcionDepositarioFinal(fecha);
						nmbBien.setAdjudicacion(adjudicacion);
						proxyFactory.proxy(EditBienApi.class)
								.guardarAdjudicacion(adjudicacion);
					}
				}
			}
		}

	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_NOMBRE_DEPO_FINAL)
	public void insertarNombreDepoFinal(Long prcId, String nombre) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					// no hay cargas
					if (cargas == null
							|| (cargas != null && cargas.size() == 0)) {
						// No hacemos nada
					} else {
						// hay cargas
						NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
								.getAdjudicacion();
						adjudicacion.setNombreDepositarioFinal(nombre);
						nmbBien.setAdjudicacion(adjudicacion);
						proxyFactory.proxy(EditBienApi.class)
								.guardarAdjudicacion(adjudicacion);
					}
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_NOMBRE_ER_DEPO)
	public void insertarNombreErDepo(Long prcId, String nombre) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					// no hay cargas
					if (cargas == null
							|| (cargas != null && cargas.size() == 0)) {
						// No hacemos nada
					} else {
						// hay cargas
						NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
								.getAdjudicacion();
						adjudicacion.setNombreDepositario(nombre);
						nmbBien.setAdjudicacion(adjudicacion);
						proxyFactory.proxy(EditBienApi.class)
								.guardarAdjudicacion(adjudicacion);
					}
				}
			}
		}

	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_POSESION_OCUPADO)
	public void insertarPosesionComboOcupado(Long prcId, Boolean valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = nmbBien
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();

					adjudicacion.setOcupado(valor);
					nmbBien.setAdjudicacion(adjudicacion);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_POSESION_POSIBLE_POSESION)
	public void insertarPosesionComboPosiblePosesion(Long prcId, Boolean valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = nmbBien
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setPosiblePosesion(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SOLICITUD)
	public void insertarPosesionFechaSolicitud(Long prcId, Date valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = nmbBien
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setFechaSolicitudPosesion(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_RES_MORAT)
	public void insertarFechaResMorat(Long prcId, Date fecha) {
            
                //"XXX_RegistrarSolicitudMoratoria.fechaResMorat");                
                setDatoBien(prcId, fecha,
                    nmbProjectContext.getCodigoRegistrarSolicitudMoratoria() + 
                    "." + nmbProjectContext.getFechaFinMoratoriaRegistrarResolucion());
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_CARGA_FECHA_SOL_MORAT)
	public void insertarFechaSolMorat(Long prcId, Date fecha) {

                //XXX_RegistrarResolucion.fechaSolMorat                
                setDatoBien(prcId, fecha, 
                    nmbProjectContext.getCodigoRegistrarResolucionMoratoria() + 
                    "." + nmbProjectContext.getFechaSolicitudRegistrarSolicitudMoratoria());
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_CARGA_RESULTADO_MORAT)
	public void insertarResultadoMorat(Long prcId, String dato) {

		//XXX_RegistrarResolucion.ResultadoMorat
		setDatoBien(prcId, dato, 
                    nmbProjectContext.getCodigoRegistrarResolucionMoratoria() + 
                    "." + nmbProjectContext.getResultadoMoratoria());
	}

	private void setDatoBien(Long prcId, Object dato, String nomCampo) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;

//					if ("XXX_RegistrarSolicitudMoratoria.fechaResMorat"
//              				|| ("XXX_RegistrarResolucion.fechaSolMorat"
//						|| ("XXX_RegistrarResolucion.ResultadoMorat"
					if ((nmbProjectContext.getCodigoRegistrarSolicitudMoratoria() + 
                                                "." + nmbProjectContext.getFechaFinMoratoriaRegistrarResolucion()).equals(nomCampo)
                                            || ((nmbProjectContext.getCodigoRegistrarResolucionMoratoria() + 
                                                "." + nmbProjectContext.getFechaSolicitudRegistrarSolicitudMoratoria()).equals(nomCampo))
                                            || ((nmbProjectContext.getCodigoRegistrarResolucionMoratoria() + 
                                                "." + nmbProjectContext.getResultadoMoratoria()).equals(nomCampo))) {

						NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
								.getAdjudicacion();

						if (Checks.esNulo(adjudicacion)) {
							adjudicacion = new NMBAdjudicacionBien();
							adjudicacion.setBien(nmbBien);
						}

						//if ("XXX_RegistrarSolicitudMoratoria.fechaResMorat"
						if ((nmbProjectContext.getCodigoRegistrarSolicitudMoratoria() + 
                                                    "." + nmbProjectContext.getFechaFinMoratoriaRegistrarResolucion()).equals(nomCampo)) {
							Date fecha = (Date) dato;
							adjudicacion.setFechaResolucionMoratoria(fecha);

						}
						//if ("XXX_RegistrarResolucion.fechaSolMorat"
						if ((nmbProjectContext.getCodigoRegistrarResolucionMoratoria() + 
                                                    "." + nmbProjectContext.getFechaSolicitudRegistrarSolicitudMoratoria()).equals(nomCampo)) {
							Date fecha = (Date) dato;
							adjudicacion.setFechaSolicitudMoratoria(fecha);
						}
						//if ("XXX_RegistrarResolucion.ResultadoMorat"
						if ((nmbProjectContext.getCodigoRegistrarResolucionMoratoria() + 
                                                    "." + nmbProjectContext.getResultadoMoratoria()).equals(nomCampo)) {
							String codResultado = (String) dato;
							DDFavorable resultado = (DDFavorable) proxyFactory
									.proxy(UtilDiccionarioApi.class)
									.dameValorDiccionarioByCod(
											DDFavorable.class, codResultado);
							if (!Checks.esNulo(resultado)) {
								adjudicacion.setResolucionMoratoria(resultado);
							}
						}

						proxyFactory.proxy(EditBienApi.class)
								.guardarAdjudicacion(adjudicacion);
					}
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SENYALAMIENTO)
	public void insertarPosesionFechaSenyalamiento(Long prcId, Date valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = nmbBien
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setFechaSenalamientoPosesion(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_POSESION_REALIZACION)
	public void insertarPosesionFechaRealizacion(Long prcId, Date valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setFechaRealizacionPosesion(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_POSESION_OCUPANTES_DURANTE)
	public void insertarPosesionComboOcupantesDurantePosesion(Long prcId,
			Boolean valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setOcupantesDiligencia(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_POSESION_LANZAMIENTO_NECESARIO)
	public void insertarPosesionComboLanzamientoNecesario(Long prcId,
			Boolean valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setLanzamientoNecesario(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SOL_LANZAMIENTO)
	public void insertarPosesionFechaSolicitudLanzamiento(Long prcId, Date valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setFechaSolicitudLanzamiento(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_SENYALAMIENTO_LANZAMIENTO)
	public void insertarPosesionFechaSenyalamientoLanzamiento(Long prcId,
			Date valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setFechaSenalamientoLanzamiento(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_POSESION_FECHA_LANZAMIENTO_EFECTUADO)
	public void insertarPosesionFechaLanzamientoEfectuado(Long prcId, Date valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setFechaRealizacionLanzamiento(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_POSESION_LLAVES_NECESARIAS)
	public void insertarPosesionComboGestionLlaves(Long prcId, Boolean valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setLlavesNecesarias(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_POSESION_FUERZA_PUBLICA)
	public void insertarPosesionComboFuerzaPublica(Long prcId, Boolean valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setNecesariaFuerzaPublica(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}
	
	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_POSESION_ENTREGA_VOLUNTARIA)
	public void insertarPosesionComboEntregaVoluntaria(Long prcId, Boolean valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = nmbBien
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();

					adjudicacion.setEntregaVoluntaria(valor);
					adjudicacion.setBien(nmbBien);
					
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}
	
	

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_SOLICITUD_DECRETO)
	public void insertarFechaSolicitudDecreto(Long prcId, Date valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					// TODO: confirmar la fecha
					adjudicacion.setFechaDecretoNoFirme(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_NOTIFICACION_DECRETO)
	public void insertarFechaNotificacionDecreto(Long prcId, Date valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setFechaDecretoNoFirme(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_ENTIDAD_ADJUDICATARIA)
	public void insertarEntidadAdjudicataria(Long prcId, String valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					DDEntidadAdjudicataria entidadAdjudicataria = (DDEntidadAdjudicataria) proxyFactory
							.proxy(UtilDiccionarioApi.class)
							.dameValorDiccionarioByCod(
									DDEntidadAdjudicataria.class, valor);
					adjudicacion.setEntidadAdjudicataria(entidadAdjudicataria);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FONDO)
	public void insertarFondo(Long prcId, String valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					DDTipoFondo fondo = (DDTipoFondo) proxyFactory
							.proxy(UtilDiccionarioApi.class)
							.dameValorDiccionarioByCod(DDTipoFondo.class, valor);
					adjudicacion.setFondo(fondo);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_FECHA_NOTIF_DECRETO_AL_CONTRARIO)
	public void insertarNotificacionDecretoAlContrario(Long prcId, Date valor) {
		/*
		 * NO SE PROPAGA POR AHORA
		 * 
		 * @SuppressWarnings("unchecked") List<Bien> listaBienes = (List<Bien>)
		 * executor.execute(ExternaBusinessOperation.
		 * BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, prcId); if (listaBienes !=
		 * null && listaBienes.size() > 0) { for (Bien bien : listaBienes) { if
		 * (bien instanceof NMBBien) { NMBBien nmbBien = (NMBBien) bien;
		 * NMBAdjudicacionBien adjudicacion = ((NMBBien)
		 * bien).getAdjudicacion(); if (adjudicacion==null) adjudicacion = new
		 * NMBAdjudicacionBien(); //adjudicacion.setFecha(valor);
		 * adjudicacion.setBien(nmbBien);
		 * proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion
		 * (adjudicacion); } } }
		 */
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_FECHA_SOLICITUD_TESTIMONIO_DECRETO)
	public void insertarFechaSolicitudTestimonioDecreto(Long prcId, Date valor) {
		/*
		 * NO SE PROPAGA POR AHORA
		 * 
		 * @SuppressWarnings("unchecked") List<Bien> listaBienes = (List<Bien>)
		 * executor.execute(ExternaBusinessOperation.
		 * BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, prcId); if (listaBienes !=
		 * null && listaBienes.size() > 0) { for (Bien bien : listaBienes) { if
		 * (bien instanceof NMBBien) { NMBBien nmbBien = (NMBBien) bien;
		 * NMBAdjudicacionBien adjudicacion = ((NMBBien)
		 * bien).getAdjudicacion(); if (adjudicacion==null) adjudicacion = new
		 * NMBAdjudicacionBien(); //adjudicacion.setFecha(valor);
		 * adjudicacion.setBien(nmbBien);
		 * proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion
		 * (adjudicacion); } } }
		 */
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_FECHA_TESTIMONIO_DECRETO)
	public void insertarFechaTestimonioDecreto(Long prcId, Date valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setFechaDecretoFirme(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_FECHA_ENVIO_GESTORIA)
	public void insertarFechaEnvioGestoria(Long prcId, Date valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class)
				.getProcedimiento(prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setFechaEntregaGestor(valor);
					adjudicacion.setGestoriaAdjudicataria(prc.getAsunto()
							.getGestor().getUsuario());
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_FECHA_RECEPCION)
	public void insertarFechaRecepcion(Long prcId, Date valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setFechaRecepcionTitulo(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_FECHA_PRESENTACION_HACIENDA)
	public void insertarFechaPresentacionHacienda(Long prcId, Date valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setFechaPresentacionHacienda(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_FECHA_PRESENTACION_REGISTRO)
	public void insertarFechaPresentacionRegistro(Long prcId, Date valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setFechaPresentacionRegistro(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_FECHA_INSCRIPCION_TITULO)
	public void insertarFechaInscripcionTitulo(Long prcId, Date valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					if (adjudicacion.getFechaInscripcionTitulo() == null) {
						adjudicacion.setFechaInscripcionTitulo(valor);
					} else {
						// Segunda notificacion
						adjudicacion.setFechaSegundaPresentacion(valor);
					}
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_FECHA_ENVIO_DECRETO_ADICION)
	public void insertarFechaEnvioDecretoAdicion(Long prcId, Date valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					adjudicacion.setFechaEnvioAdicion(valor);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_SITUACION_TITULO)
	public void insertarSituacionTitulo(Long prcId, String valor) {
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor
				.execute(
						ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
						prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					NMBAdjudicacionBien adjudicacion = ((NMBBien) bien)
							.getAdjudicacion();
					if (adjudicacion == null)
						adjudicacion = new NMBAdjudicacionBien();
					DDSituacionTitulo titulo = (DDSituacionTitulo) proxyFactory
							.proxy(UtilDiccionarioApi.class)
							.dameValorDiccionarioByCod(DDSituacionTitulo.class,
									valor);
					adjudicacion.setSituacionTitulo(titulo);
					adjudicacion.setBien(nmbBien);
					proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
							adjudicacion);
				}
			}
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_GESTORIA)
	public void insertarGestoria(Long prcId) {

		Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class)
				.getProcedimiento(prcId);

		Filter filtroAsunto = genericDao.createFilter(FilterType.EQUALS,
				"asunto.id", prc.getAsunto().getId());
		List<EXTGestorAdicionalAsunto> gestoresAdicionales = genericDao
				.getList(EXTGestorAdicionalAsunto.class, filtroAsunto);

		Usuario usu = null;
		if (!Checks.estaVacio(gestoresAdicionales)) {
			for (EXTGestorAdicionalAsunto gaa : gestoresAdicionales) {
				if ("GEST".equals(gaa.getTipoGestor().getCodigo())) {
					usu = gaa.getGestor().getUsuario();
				}
			}
		}

		if (!Checks.esNulo(usu)) {
			List<Bien> listaBienes = (List<Bien>) executor
					.execute(
							ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
							prcId);
			if (listaBienes != null && listaBienes.size() == 1) {
				if (listaBienes.get(0) instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) listaBienes.get(0);
					NMBAdjudicacionBien adjudicacion = nmbBien
							.getAdjudicacion();
					adjudicacion.setGestoriaAdjudicataria(usu);
					genericDao.save(NMBAdjudicacionBien.class, adjudicacion);
				}
			}
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_HANDLER_INSERT_POSESION_CREAR_ANOTACION)
	public void createAnotacion(DtoCrearAnotacion dto) {

		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class)
				.getUsuarioLogado();

		for (DtoCrearAnotacionUsuario user : dto.getUsuarios()) {
			try {
				if (user.isIncorporar()) {
					boolean isUserDistintoUsuarioLogado = false;
					String tipoAnotacion = "";

					if (user.getFecha() != null) {
						if (user.getId().equals(usuarioLogado.getId())) {
							tipoAnotacion = SUBTIPO_ANOTACION_AUTOTAREA;
						} else {
							isUserDistintoUsuarioLogado = true;
							tipoAnotacion = SUBTIPO_ANOTACION_TAREA;
						}
					} else {
						tipoAnotacion = SUBTIPO_ANOTACION_NOTIFICACION;
					}

					// autotarea: crear tarea y rellenar datos del formulario
					Long idTarea = crearTarea(dto, user,
							isUserDistintoUsuarioLogado, tipoAnotacion);

					Map<String, Object> infoEvento = MultifuncionTipoEventoRegistro.createInfoEventoNotificacion(
							idTarea, usuarioLogado.getId(), new Date(), user.getId(), dto.getAsuntoMail(), 
							HtmlUtils.htmlUnescape(dto.getCuerpoEmail()), user.isEmail(), dto.getTipoAnotacion());
									
					executor.execute("plugin.mejoras.registro.guardatTrazaEventoParam", usuarioLogado.getId(), 
							dto.getIdUg(), dto.getCodUg(), MultifuncionTipoEventoRegistro.TIPO_EVENTO_NOTIFICACION, infoEvento);

				}
			} catch (EXTCrearTareaException e) {
				logger.error("Error creando tarea");
				e.printStackTrace();
				throw new FrameworkException("Error creando la tarea");
			}
		}
	}

	/*
	 * Este m�todo se pone como protected para poder hacer un spy sobre el
	 * durante el testeo
	 */
	protected Long crearTarea(DtoCrearAnotacion dto,
			DtoCrearAnotacionUsuario user, boolean enEspera,
			String codigoSubtarea) throws EXTCrearTareaException {

		EXTDtoGenerarTareaIdividualizadaImpl tareaIndDto = new EXTDtoGenerarTareaIdividualizadaImpl();
		DtoGenerarTarea tareaDto = new DtoGenerarTarea();

		tareaDto.setSubtipoTarea(codigoSubtarea);
		tareaDto.setEnEspera(enEspera);
		tareaDto.setFecha(user.getFecha());
		tareaDto.setDescripcion(dto.getAsuntoMail());
		tareaDto.setIdEntidad(dto.getIdUg());
		tareaDto.setCodigoTipoEntidad(dto.getCodUg());
		tareaIndDto.setTarea(tareaDto);
		tareaIndDto.setDestinatario(user.getId());
		return proxyFactory.proxy(EXTTareasApi.class)
				.crearTareaNotificacionIndividualizada(tareaIndDto);

	}

}

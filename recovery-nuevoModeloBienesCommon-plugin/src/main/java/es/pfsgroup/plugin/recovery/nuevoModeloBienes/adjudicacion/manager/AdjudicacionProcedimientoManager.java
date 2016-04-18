package es.pfsgroup.plugin.recovery.nuevoModeloBienes.adjudicacion.manager;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.api.AdjudicacionProcedimientoDelegateApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDDocAdjudicacion;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDEntidadAdjudicataria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdicionalBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

/**
 *
 */
@Service("adjudicacionProcedimientoManagerDelegated")
public class AdjudicacionProcedimientoManager implements AdjudicacionProcedimientoDelegateApi {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private Executor executor;
	
	@Autowired
	private GenericABMDao genericDao;

	private DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_COMPROBAR_BIEN_ASOCIADO_PRC)
	public Boolean comprobarBienAsociadoPrc(Long prcId) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, prcId);
		if (listaBienes != null && listaBienes.size() == 1) {
			return true;
		}
		return false;
	}
	
	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_COMPROBAR_BIEN_ENTIDAD_ADJUDICATARIA)
	public Boolean comprobarBienEntidadAdjudicataria(Long bienId){
		
		Filter filtroBien = genericDao.createFilter(FilterType.EQUALS, "id", bienId);
		NMBBien bien = genericDao.get(NMBBien.class, filtroBien);
		if (bien.getAdjudicacion() != null){
			if(bien.getAdjudicacion().getEntidadAdjudicataria() != null && !DDEntidadAdjudicataria.TERCEROS.equals(bien.getAdjudicacion().getEntidadAdjudicataria().getCodigo())){				
					return true;
			}
		}
		return false;
	}
	
	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_COMPROBAR_BIEN_ENTIDAD_ADJUDICATARIA_DECRETO)
	public Boolean comprobarBienEntidadAdjudicatariaConDecreto(Long bienId){
		
		Filter filtroBien = genericDao.createFilter(FilterType.EQUALS, "id", bienId);
		NMBBien bien = genericDao.get(NMBBien.class, filtroBien);
		if (bien.getAdjudicacion() != null){
			if(bien.getAdjudicacion().getEntidadAdjudicataria() != null){
				if(!DDEntidadAdjudicataria.TERCEROS.equals(bien.getAdjudicacion().getEntidadAdjudicataria().getCodigo())){
					if(bien.getAdjudicacion().getCesionRemate() == null || (bien.getAdjudicacion().getCesionRemate() != null && !bien.getAdjudicacion().getCesionRemate())){
						if(bien.getAdjudicacion().getTipoDocAdjudicacion() != null && DDDocAdjudicacion.DECRETO.equals(bien.getAdjudicacion().getTipoDocAdjudicacion().getCodigo())){
							return true;
						}
					}
				}			
			}
		}
		return false;
	}
	
	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_COMPROBAR_BIEN_ENTIDAD_ADJUDICATARIA_ESCRITURA)
	public Boolean comprobarBienEntidadAdjudicatariaConEscritura(Long bienId){
		
		Filter filtroBien = genericDao.createFilter(FilterType.EQUALS, "id", bienId);
		NMBBien bien = genericDao.get(NMBBien.class, filtroBien);
		if (bien.getAdjudicacion() != null){
			if(bien.getAdjudicacion().getEntidadAdjudicataria() != null){
				if(!DDEntidadAdjudicataria.TERCEROS.equals(bien.getAdjudicacion().getEntidadAdjudicataria().getCodigo())){
					if(bien.getAdjudicacion().getCesionRemate() == null || (bien.getAdjudicacion().getCesionRemate() != null && !bien.getAdjudicacion().getCesionRemate())){
						if(bien.getAdjudicacion().getTipoDocAdjudicacion() != null && DDDocAdjudicacion.ESCRITURA.equals(bien.getAdjudicacion().getTipoDocAdjudicacion().getCodigo())){
							return true;
						}
					}
				}			
			}
		}
		return false;
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_COMPROBAR_BIEN_ENTIDAD_ADJ_TERCEROS)
	public Boolean comprobarBienEntidadAdjudicatariaTerceros(Long bienId){
			Filter filtroBien = genericDao.createFilter(FilterType.EQUALS, "id", bienId);
			NMBBien bien = genericDao.get(NMBBien.class, filtroBien);
			if (bien.getAdjudicacion() != null){
				if(bien.getAdjudicacion().getEntidadAdjudicataria() != null && DDEntidadAdjudicataria.TERCEROS.equals(bien.getAdjudicacion().getEntidadAdjudicataria().getCodigo())){
					return true;
				}
			}
			return false;
		}

	
	
	@BusinessOperation(overrides = BO_ADJUDICACION_COMPROBAR_BIENES_ASOCIADO_PRC)
	public Boolean comprobarBienesAsociadoPrc(Long prcId) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, prcId);
		if (listaBienes != null && listaBienes.size() >= 1) {
			return true;
		}
		return false;
	}
	
	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_COMPROBAR_BIEN_SUJETO_IVA)
	public String comprobarBienSujetoIVA(Long prcId) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, prcId);
		if (listaBienes != null && listaBienes.size() == 1) {
			NMBBien bien = (NMBBien)listaBienes.get(0);
			if(bien.getTributacion() != null){
				return bien.getTributacion().getCodigo();
			}
		}
		return null;
	}
	
	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_COMPROBAR_TIPO_CARGA_BIEN_INSCRITO)
	public Boolean comprobarTipoCargaBienInscrito(Long prcId) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					// no hay cargas
					if (cargas == null || (cargas != null && cargas.size() == 0)) {
						NMBAdicionalBien adicionalBien = ((NMBBien) bien).getAdicional();
						// y se ha revisado
						if (adicionalBien.getSinCargas() != null && adicionalBien.getSinCargas()) {
							return true;
						} else {
							return false;
						}
					} else {
						// hay cargas
						Boolean verificadasCargas = false;
						for (NMBBienCargas carga : cargas) {
							if (carga.getRegistral() && carga.getSituacionCarga() != null) {
								verificadasCargas = true;
							} else if (carga.isEconomica() && carga.getSituacionCargaEconomica() != null) {
								verificadasCargas = true;
							} else {
								return false;
							}
						}
						if (verificadasCargas) {
							return true;
						}
					}
				}
			}
		}
		return false;
	}
	
	public Boolean comprobarCargasBienesProcedimiento(Long prcId) {

		boolean res = true;
		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					// no hay cargas
					if (cargas == null || (cargas != null && cargas.size() == 0)) {
						NMBAdicionalBien adicionalBien = ((NMBBien) bien).getAdicional();
						// y se ha revisado
						if (adicionalBien.getSinCargas() == null || !adicionalBien.getSinCargas()) {
							res = false;
							break;
						}
					} else {
						// hay cargas
						for (NMBBienCargas carga : cargas) {
							if (!(carga.getRegistral() && carga.getSituacionCarga() != null) && !(carga.isEconomica() && carga.getSituacionCargaEconomica() != null)) {
								res = false;
								break;
							}
						}
					}
				}
			}
		}
		return res;
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_COMPROBAR_ESTADO_CARGAS_CANCELACION)
	public Boolean comprobarEstadoCargasCancelacion(Long prcId) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					// no hay cargas
					if ((cargas == null || cargas != null && cargas.size() == 0)) {
						NMBAdicionalBien adicionalBien = ((NMBBien) bien).getAdicional();
						// y se ha revisado
						if (adicionalBien.getSinCargas()) {
							return true;
						} else {
							return false;
						}
					} else {
						// hay cargas
						Boolean verificadasCargas = false;
						Boolean hayRegistrales = false;
						for (NMBBienCargas carga : cargas) {
//							TODOS LOS TIPOS DE CARGA, Antes solo se comprobaban los anteriores
							if (carga.getRegistral()) {
								hayRegistrales=true;
								if (DDSituacionCarga.CANCELADA.compareTo(carga.getSituacionCarga().getCodigo()) == 0 || DDSituacionCarga.RECHAZADA.compareTo(carga.getSituacionCarga().getCodigo()) == 0) {
									verificadasCargas = true;
								} else {
									return false;
								}
							}
						}
						if (verificadasCargas || !hayRegistrales) {
							return true;
						}
					}
				}
			}
		}
		return false;
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_COMPROBAR_ADJUNTO)
	public Boolean comprobarAdjunto(Long prcId, String tipo) {

		Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(prcId);
		Set<AdjuntoAsunto> adjuntos = prc.getAdjuntos();
		for (AdjuntoAsunto adjunto : adjuntos) {
			if (!Checks.esNulo(adjunto.getProcedimiento()) && adjunto.getProcedimiento().getId() == prcId) {
				if (adjunto instanceof EXTAdjuntoAsunto) {
					EXTAdjuntoAsunto extAdjunto = (EXTAdjuntoAsunto) adjunto;
					DDTipoFicheroAdjunto tipoAdjunto = extAdjunto.getTipoFichero();
					if (tipoAdjunto == null) {
						continue;
					}
					if (tipo.equals(((EXTAdjuntoAsunto) adjunto).getTipoFichero().getCodigo())) {
						return true;
					}
				}
			}
		}
		return false;

	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_COMPROBAR_ADJUNTO_PROPUESTA_CANCELACION_CARGAS)
	public Boolean comprobarAdjuntoPropuestaCancelacionCargas(Long prcId) {

		Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(prcId);
		Set<AdjuntoAsunto> adjuntos = prc.getAsunto().getAdjuntos();
		for (AdjuntoAsunto adjunto : adjuntos) {
			if (adjunto.getProcedimiento().getId() == prcId) {
				// if(adjunto.getNombre() == ""){
				return true;
				// }
			}
		}
		return false;

	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_COMPROBAR_ESTADO_CARGAS_PROPUESTA)
	public Boolean comprobarEstadoCargasPropuesta(Long prcId) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					// no hay cargas
					if ((cargas == null || cargas != null && cargas.size() == 0)) {
						NMBAdicionalBien adicionalBien = ((NMBBien) bien).getAdicional();
						// y se ha revisado
						if (adicionalBien.getSinCargas()) {
							return true;
						} else {
							return false;
						}
					} else {
						// hay cargas
						Boolean verificadasCargas = false;
						Boolean hayEconomicas = false;
						for (NMBBienCargas carga : cargas) {
							// PARA TODOS LOS TIPOS DE CARGAS, antes solo los anteriores 
								if (carga.isEconomica()) {
									hayEconomicas = true;
									if (!Checks.esNulo(carga.getSituacionCargaEconomica()) && 
											(DDSituacionCarga.CANCELADA.compareTo(carga.getSituacionCargaEconomica().getCodigo()) == 0 || (DDSituacionCarga.RECHAZADA.compareTo(carga.getSituacionCargaEconomica().getCodigo()) == 0))) {
									verificadasCargas = true;
								} else {
									return false;
								}
							}
						}
						if (verificadasCargas  || !hayEconomicas) {
							return true;
						}
					}
				}
			}
		}
		return false;
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_OBTENER_TIPO_CARGA)
	public String obtenerTipoCarga(Long prcId) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					NMBBien nmbBien = (NMBBien) bien;
					List<NMBBienCargas> cargas = nmbBien.getBienCargas();
					// no hay cargas
					if (cargas == null || (cargas != null && cargas.size() == 0)) {
						return "noCargas";
					} else {
						// hay cargas activas
						boolean registral = false;
						boolean economica = false;
						boolean algunaActiva = false;
						for (NMBBienCargas carga : cargas) {
							if(carga.getRegistral() && "ACT".compareTo(carga.getSituacionCarga().getCodigo()) == 0){
								algunaActiva = true;
							} else if(carga.isEconomica() && "ACT".compareTo(carga.getSituacionCargaEconomica().getCodigo()) == 0){
								algunaActiva = true;
							}
							if (carga.getRegistral() && !carga.isEconomica()) {
								registral = true;
							} else if (!carga.getRegistral() && carga.isEconomica()) {
								economica = true;
							} else if(carga.getRegistral() && carga.isEconomica()) {
								registral = true;
								economica = true;
							}
						}
						//Si todas las cargas son canceladas o rechazadas, entonces se entiende que no hay cargas
						if(!algunaActiva){
							return "noCargas";
						}
						if(registral && economica){
							return "ambos";
						} else if(registral){
							return "registrales";
						} else if(economica){
							return "economicas";
						}
					}
				}
			}
		}
		return null;
	}
	
/**
 * 
 * Nomb: Gestoría para adjudicación - Cod: GPA
 * Nomb: Gestoría para saneamiento - Cod: GPS
 * 
 * 
 */

	@Override
	@BusinessOperation(overrides=BO_ADJUDICACION_COMPROBAR_GESTORIA_ASIGNADA_PRC)
	public Boolean comprobarGestoriaAsignadaPrc(Long prcId) {

		Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(prcId);
		return existeTipoGestorEnAsunto(prc.getAsunto(), "GEST");
	}	

	@Override
	@BusinessOperation(overrides=BO_ADJUDICACION_COMPROBAR_GESTORIA_ASIGNADA_SANEAMIENTO_CARGAS_BIENES)
	public Boolean comprobarGestoriaAsignadaAlSaneamientoDeCargasDeBienes(Long prcId) {
		
		Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(prcId);
		return existeTipoGestorEnAsunto(prc.getAsunto(), "GGSAN");
	}

	private Boolean existeTipoGestorEnAsunto(Asunto asu, String tipoGestor) {
		Filter filtroAsunto = genericDao.createFilter(FilterType.EQUALS, "asunto.id", asu.getId());
		List<EXTGestorAdicionalAsunto> gestoresAdicionales = genericDao.getList(EXTGestorAdicionalAsunto.class, filtroAsunto);

		if (!Checks.estaVacio(gestoresAdicionales)) {
			for (EXTGestorAdicionalAsunto gaa : gestoresAdicionales) {
				if (tipoGestor.equals(gaa.getTipoGestor().getCodigo())) {
					return true;
				}
			}
		}
		return false;
	}

	@Override
	@BusinessOperation(overrides="es.pfsgroup.recovery.adjudicacion.vieneDeTramitePosesion")
	public Boolean vieneDeTramitePosesion(Long prcId) {
		
		Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(prcId);

		if(("P416".compareTo(prc.getProcedimientoPadre().getTipoProcedimiento().getCodigo()) == 0) ||
				("H015".compareTo(prc.getProcedimientoPadre().getTipoProcedimiento().getCodigo()) == 0)) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_ESTAMOS_A_DOS_MESES)
	public Boolean estamosADosMeses(Long prcId) {

		List<TareaNotificacion> tareas = proxyFactory.proxy(TareaNotificacionApi.class).getListByProcedimientoSubtipo(prcId, SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR);

		for (TareaNotificacion tar : tareas) {
			if (!Checks.esNulo(tar.getTarea()) && tar.getTarea().contains("Registrar resoluci")) {
				TareaExterna tex = tar.getTareaExterna();
				List<TareaExternaValor> listaTev = tex.getValores();
				for (TareaExternaValor tev : listaTev) {
					if ("fechaFinMoratoria".equals(tev.getNombre())) {
						try {
							Date fecha = df.parse(tev.getValor());
							int diferencia = restarFechas(Calendar.getInstance(), fecha);
							if (diferencia > 60) {
								return false;
							} else
								return true;

						} catch (ParseException e) {
							e.printStackTrace();
						}
					}
				}
			}
		}

		return null;
	}

	private int restarFechas(Calendar hoy, Date fecha) {
		long milis1 = hoy.getTimeInMillis();
		long milis2 = fecha.getTime();
		// calcular la diferencia en milisengundos
		long diff = milis2 - milis1;
		// calcular la diferencia en dias
		long diffDays = diff / (24 * 60 * 60 * 1000);
		return Long.valueOf(diffDays).intValue();

	}
	
	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_COMPROBAR_FECHA_REVISION)
	public Boolean comprobarFechaRevision(Long prcId) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					if(Checks.esNulo(((NMBBien) bien).getAdicional().getFechaRevision())){
						return false;
					}
				}
			}
		}
		return true;
	}
	

	
	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_EXISTE_BIEN_CON_ADJU_ENTIDAD)
	public Boolean existeBienConAdjudicacionE(Long prcId) {

		@SuppressWarnings("unchecked")
		List<Bien> listaBienes = (List<Bien>) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, prcId);
		if (listaBienes != null && listaBienes.size() > 0) {
			for (Bien bien : listaBienes) {
				if (bien instanceof NMBBien) {
					if(DDEntidadAdjudicataria.ENTIDAD.equals(((NMBBien) bien).getAdjudicacion().getEntidadAdjudicataria().getCodigo())){
						return true;
					}
				}
			}
		}
		return false;
	}
	
	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_ES_BIEN_CON_CESION_REMATE)
	public Boolean esBienConCesionRemate(Long bieId){
		
		Bien bien = genericDao.get(Bien.class, genericDao.createFilter(FilterType.EQUALS, "id", bieId));
		
		if (bien instanceof NMBBien) {
			if(!Checks.esNulo(((NMBBien) bien).getAdjudicacion()) && !Checks.esNulo(((NMBBien) bien).getAdjudicacion().getCesionRemate())){
				if(((NMBBien) bien).getAdjudicacion().getCesionRemate()){
					return true;
				}
			}
		}
		return false;
	}

	
	@Override
	@BusinessOperation(overrides = BO_ADJUDICACION_COMPROBAR_ADJUNTO_ASUNTO)
	public Boolean comprobarAdjuntoAsunto(Long prcId, String tipo) {

		Long asuId = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(prcId).getAsunto().getId();
		Asunto asu = proxyFactory.proxy(AsuntoApi.class).get(asuId);
		Set<AdjuntoAsunto> adjuntos = asu.getAdjuntos();
		
		for (AdjuntoAsunto adjunto : adjuntos) {
			if (!Checks.esNulo(adjunto.getId()) && adjunto.getAsunto().getId() == asuId) {
				if (adjunto instanceof EXTAdjuntoAsunto) {
					EXTAdjuntoAsunto extAdjunto = (EXTAdjuntoAsunto) adjunto;
					DDTipoFicheroAdjunto tipoAdjunto = extAdjunto.getTipoFichero();
					if (tipoAdjunto == null) {
						continue;
					}
					if (tipo.equals(((EXTAdjuntoAsunto) adjunto).getTipoFichero().getCodigo())) {
						return true;
					}
				}
			}
		}
		return false;

	}
	
	public Boolean existeAdjuntoUG(Long idProcedimiento, String codigoDocAdjunto, String uGestion){
		//Balancea la comprobación de existencia de archivos adjuntos, dentro de la unidad de gestión indicada:
		// Asunto.........: ASU
		// Procedimiento..: PRC
		if (uGestion.equals("ASU")){
			return comprobarAdjuntoAsunto(idProcedimiento, codigoDocAdjunto);
		}else if (uGestion.equals("PRC")){
			return comprobarAdjunto(idProcedimiento, codigoDocAdjunto);
		}else{
			return false;
		}
		
	}
	
	public String existeAdjuntoUGMensaje(String codigoDocAdjunto, String uGestion){
		
		//Mensaje de validación
		String mensajeValidacion = "Es necesario aportar ";
		
		DDTipoFicheroAdjunto tipoFicheroAdjunto = genericDao.get(DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoDocAdjunto));
		
		//Dependiendo del entorno de comprobación de existencia, se retorna un mensaje
		if (uGestion.equals("ASU")){
			mensajeValidacion = mensajeValidacion.concat("sobre el asunto, el documento adjunto ");
		}else if(uGestion.equals("PRC")){
			mensajeValidacion = mensajeValidacion.concat("sobre el procedimiento, el documento adjunto ");
		}
		
		//Incluye en el mensaje, la descripción de documento adjunto.
		mensajeValidacion = mensajeValidacion.concat(tipoFicheroAdjunto.getDescripcion());
		
		//Si no encuentra el doc. adjunto por codigo, retorna un mensaje fijo de advertencia
		if (tipoFicheroAdjunto.getCodigo().isEmpty()){
			mensajeValidacion = "ATENCION: No se ha podido verificar la existencia de un adjunto porque no existe el codigo indicado: " + codigoDocAdjunto;
		}

		//Si la unidad de gestión no es ninguna de las definidas, retorna un mensaje fijo de advertencia.
		if (uGestion.isEmpty() && !uGestion.equals("ASU") && !uGestion.equals("PRC")){
			mensajeValidacion = "ATENCION: No es posible verificar la existencia de un adjunto en esta unidad de gestión: " + uGestion;
		}
		
		return mensajeValidacion;
	}
	
	private String formatoMensajeValidacionHTML(String mensajeValidacion){

		//Preformato para mensajes de validación en tareas
		String formatoMensajeIn = "'<div align=\"justify\" style=\"font-size:8pt;font-family:Arial;margin-bottom:10px;\">";
		String formatoMensajeOut = "</div>'";
		
		return formatoMensajeIn + mensajeValidacion + formatoMensajeOut;
		
	}
	
	public String existeAdjuntoUGMensajeHTML(String codigoDocAdjunto, String uGestion){

		return formatoMensajeValidacionHTML(existeAdjuntoUGMensaje(codigoDocAdjunto, uGestion));
		
	}

	
	public Boolean existeAdjuntoUG(Long idProcedimiento,String cadenaDAUG){
		
		String[] arrayDAUG = cadenaDAUG.split(";");
		String tipoDoc = new String();
		String uGestion = new String();
		
		for (String elementoDAUG: arrayDAUG){
			
			tipoDoc = elementoDAUG.split(",")[0].trim();
			uGestion = elementoDAUG.split(",")[1].trim();
			
			if (!existeAdjuntoUG(idProcedimiento, tipoDoc, uGestion)){
				return false;
			}
		}
		
		return true;
	}
	
	public String existeAdjuntoUGMensajeHTML(Long idProcedimiento,String cadenaDAUG){
		
		String[] arrayDAUG = cadenaDAUG.split(";");
		String mensajeMultiValidacion = new String();
		String tipoDoc = new String();
		String uGestion = new String();
		
		for (String elementoDAUG: arrayDAUG){
			
			tipoDoc = elementoDAUG.split(",")[0].trim();
			uGestion = elementoDAUG.split(",")[1].trim();
			
			if (!existeAdjuntoUG(idProcedimiento, tipoDoc, uGestion)){
				mensajeMultiValidacion = mensajeMultiValidacion.concat(existeAdjuntoUGMensaje(tipoDoc,uGestion)).concat("<br>");
			}
		}
		
		return formatoMensajeValidacionHTML(mensajeMultiValidacion);
	}

}
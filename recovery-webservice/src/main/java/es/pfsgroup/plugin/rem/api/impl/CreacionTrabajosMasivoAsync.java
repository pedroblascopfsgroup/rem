package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
//import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.impl.MSVProcesoManager;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.gestor.GestorActivoManager;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.AdjuntoTrabajo;
import es.pfsgroup.plugin.rem.model.DtoFichaTrabajo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;
import es.pfsgroup.plugin.rem.trabajo.TrabajoManager;
import es.pfsgroup.plugin.rem.trabajo.dao.TrabajoDao;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

@Component
public class CreacionTrabajosMasivoAsync {

	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private TrabajoManager trabajoManager;
	
	@Autowired
	private TrabajoDao trabajoDao;
	
	@Autowired
	private GestorActivoManager gestorActivoManager;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private UpdaterStateApi updaterStateApi;
	
	//@Autowired
	//private ProcessAdapter processAdapter;
	
	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	@Autowired
	UsuarioManager usuarioManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private MSVProcesoManager procesoManager;
	
	@Autowired
	private MSVExcelParser excelParser;
	
	@Transactional
	public void doCreacionTrabajosAsync(DtoFichaTrabajo dtoTrabajo, Usuario usuarioLogado) {
		TransactionStatus transaction = null;
		transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
		List<Activo> listaActivos = this.getListaActivosProceso(dtoTrabajo.getIdProceso());
		Trabajo trabajo = new Trabajo();
		
		try {

			Boolean isFirstLoop = true;
			Double total= 0d;
			Boolean algunoSinPrecio= false;
			Map<Long,Double> mapaValores= new HashMap<Long,Double>();
			for(Activo activo:listaActivos){
				Double valor= updaterStateApi.calcularParticipacionValorPorActivo(dtoTrabajo.getTipoTrabajoCodigo(), activo);
				total= total+valor;
				if(valor.equals(0d)){
					algunoSinPrecio= true;
					break;
				}
				mapaValores.put(activo.getId(), valor);
			}
			for (Activo activo : listaActivos) {
				Double participacion = null;
				
				if (algunoSinPrecio) {
					participacion = (100d / listaActivos.size());
				} else {
					participacion = (mapaValores.get(activo.getId()) / total) * 100;
				}

				dtoTrabajo.setParticipacion(Checks.esNulo(participacion) ? "0" : participacion.toString());

				Usuario usuarioGestor = null;

				if(!Checks.esNulo(dtoTrabajo.getIdGestorActivoResponsable())){
					usuarioGestor = usuarioManager.get(dtoTrabajo.getIdGestorActivoResponsable());
					if(!Checks.esNulo(usuarioGestor)){
						trabajo.setUsuarioGestorActivoResponsable(usuarioGestor);
					}
				}

				if (isFirstLoop || !dtoTrabajo.getEsSolicitudConjunta()) {
					trabajo = new Trabajo();
					trabajoManager.dtoToTrabajo(dtoTrabajo, trabajo);
					trabajo.setFechaSolicitud(new Date());
					trabajo.setNumTrabajo(trabajoDao.getNextNumTrabajo());
					trabajo.setSolicitante(usuarioLogado);
					if (!Checks.esNulo(usuarioGestor)) {
						trabajo.setUsuarioResponsableTrabajo(usuarioGestor);
					} else {
						trabajo.setUsuarioResponsableTrabajo(usuarioLogado);
					}

					trabajo.setEstado(trabajoManager.getEstadoNuevoTrabajoUsuario(dtoTrabajo, activo, usuarioLogado));

					// El gestor de activo se salta tareas de estos trámites y
					// por tanto es necesario settear algunos datos
					// al crear el trabajo.
					if (gestorActivoManager.isGestorActivo(activo, usuarioLogado)) {
						if (DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo())
								|| DDTipoTrabajo.CODIGO_TASACION.equals(trabajo.getTipoTrabajo().getCodigo())
								|| DDSubtipoTrabajo.CODIGO_AT_VERIFICACION_AVERIAS.equals(trabajo.getSubtipoTrabajo().getCodigo())) {

							trabajo.setFechaAprobacion(new Date());
						}
					}

					// El trámite de cédula queda aprobado al crearlo, sea o no
					// sea gestor activo quien lo crea
					if (DDSubtipoTrabajo.CODIGO_CEDULA_HABITABILIDAD.equals(trabajo.getSubtipoTrabajo().getCodigo())) {
						trabajo.setFechaAprobacion(new Date());
					}

					if (DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(trabajo.getTipoTrabajo().getCodigo()) 
							|| DDSubtipoTrabajo.CODIGO_AT_VERIFICACION_AVERIAS.equals(trabajo.getSubtipoTrabajo().getCodigo())) {
						trabajo.setEsTarificado(true);
					}
				}
				ActivoTrabajo activoTrabajo = trabajoManager.createActivoTrabajo(activo, trabajo, dtoTrabajo.getParticipacion());
				transactionManager.commit(transaction);
				transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
				
				trabajo.getActivosTrabajo().add(activoTrabajo);
				isFirstLoop = false;

				if (!Checks.esNulo(dtoTrabajo.getIdSupervisorActivo())) {
					Usuario usuarioSupervisor = usuarioManager.get(dtoTrabajo.getIdSupervisorActivo());
					if (!Checks.esNulo(usuarioSupervisor)) {
						trabajo.setSupervisorActivoResponsable(usuarioSupervisor);
					}
				}

				if (!dtoTrabajo.getEsSolicitudConjunta()) {
					if (dtoTrabajo.getRequerimiento() != null) {
						trabajo.setRequerimiento(dtoTrabajo.getRequerimiento());
					}
					trabajoDao.saveOrUpdate(trabajo);
					transactionManager.commit(transaction);
					transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
					
					trabajoManager.createTramiteTrabajo(trabajo);
					transactionManager.commit(transaction);
					transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
					
					//processAdapter.addFilaProcesada(dtoTrabajo.getIdProceso(), true);
					
				}
			}

			if (dtoTrabajo.getEsSolicitudConjunta()) {
				if (dtoTrabajo.getRequerimiento() != null) {
					trabajo.setRequerimiento(dtoTrabajo.getRequerimiento());
				}
				trabajoDao.saveOrUpdate(trabajo);
				transactionManager.commit(transaction);
				transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
				trabajoManager.createTramiteTrabajo(trabajo);
				transactionManager.commit(transaction);
				transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
				ficheroMasivoToTrabajo(dtoTrabajo.getIdProceso(), trabajo);	
				transactionManager.commit(transaction);
			}
			
			//processAdapter.setStateProcessed(dtoTrabajo.getIdProceso());
			
		} catch (Exception e) {
			//processAdapter.addFilaProcesada(dtoTrabajo.getIdProceso(), false);
			//processAdapter.setStateProcessed(dtoTrabajo.getIdProceso());
			logger.error(e.getMessage());
			try {
				transactionManager.rollback(transaction);
			} catch (Exception ex) {
				logger.error("error rollback proceso masivo: " + ex.getMessage());
			}
		}
	}
		
	private List<Activo> getListaActivosProceso(Long idProceso) {

		List<Activo> listaActivos = new ArrayList<Activo>();
		MSVDocumentoMasivo documento = procesoManager.getMSVDocumento(idProceso);
		MSVHojaExcel exc = excelParser.getExcel(documento.getContenidoFichero().getFile());

		try {

			Integer numFilas = exc.getNumeroFilasByHoja(0,documento.getProcesoMasivo().getTipoOperacion());

			for (int i = 1; i < numFilas; i++) {				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numActivo",
						Long.parseLong(exc.dameCelda(i, 0)));
				Activo activo = genericDao.get(Activo.class, filtro);
				if (activo != null) {
					listaActivos.add(activo);
				}
			}
		} catch (NumberFormatException e) {
			logger.error(e.getMessage());
		} catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
		} catch (IOException e) {
			logger.error(e.getMessage());
		} catch (ParseException e) {
			logger.error(e.getMessage());
		}
		return listaActivos;
	}
	
	private void ficheroMasivoToTrabajo(Long idProceso, Trabajo trabajo) {
		MSVDocumentoMasivo documento = procesoManager.getMSVDocumento(idProceso);
		FileItem fileItem = documento.getContenidoFichero();
		fileItem.setFileName(documento.getNombre());
		// fileItem.setLength(); //TODO: Hay que meter el tamaño del fichero
		// fileItem.setContentType(); //TODO: Hay que meter el tipo del fichero
		WebFileItem webFileItem = new WebFileItem();
		webFileItem.setFileItem(fileItem);
		Map<String, String> mapaParametros = new HashMap<String, String>();
		mapaParametros.put("idEntidad", trabajo.getId().toString());
		mapaParametros.put("tipo", "01"); // TODO: He puesto informe comercial
											// pero hay que crear un tipo nuevo
		mapaParametros.put("descripcion", "Listado de activos");
		webFileItem.setParameters(mapaParametros);

		List<AdjuntoTrabajo> adjuntosTrabajo = new ArrayList<AdjuntoTrabajo>();
		trabajo.setAdjuntos(adjuntosTrabajo);
		trabajoDao.saveOrUpdate(trabajo);
		try {
			trabajoManager.upload(webFileItem);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
	}
}

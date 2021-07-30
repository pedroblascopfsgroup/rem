package es.pfsgroup.plugin.rem.adapter;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.bulkAdvisoryNote.dao.BulkOfertaDao;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.AdjuntoExpedienteComercialDao;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.DDSubtipoDocumentoExpedienteDao;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.AdjuntoComprador;
import es.pfsgroup.plugin.rem.model.AdjuntoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.BulkOferta;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.TmpClienteGDPR;
import es.pfsgroup.plugin.rem.model.VListadoOfertasAgrupadasLbk;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.thread.EnvioDocumentoGestorDocBulk;

@Service
public class ExpedienteComercialAdapter {

	private static final String EXCEPTION_DOCUMENTO_SUBTIPO = "Error, solo se puede insertar 1 documento de este subtipo";
	private static final String ERROR_CREACION_CONTENEDOR = "Error creando el contenedor de la persona";
	private static final String CREANDO_CONTENEDOR = "Creando contenedor...";
	private static final String EXCEPTION_UPLOAD_DOCUMENTO_BULK = "Error, existen ofertas sin tramitar en el Bulk";
	private static final String ERROR_SUBIDA_DOCUMENTO_GD = "Error en la subida del documento al Gestor Documental";
	//private static final String GESTOR_GD_EXTERNO = "Gestor externo";

	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private AdjuntoExpedienteComercialDao adjuntoExpedienteComercialDao;
	
	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;
	
	@Autowired
	private DDSubtipoDocumentoExpedienteDao ddSubtipoDocumentoExpedienteDao;
	
	@Autowired
	private BulkOfertaDao bulkOfertaDao;
	
	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	
	protected static final Log logger = LogFactory.getLog(ExpedienteComercialAdapter.class);
	
	@Transactional(readOnly = false)
	public List<DtoAdjunto> getAdjuntosExpedienteComercial(Long id)	throws GestorDocumentalException{
		
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		Usuario usuario = genericAdapter.getUsuarioLogado();
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOne(id);
			try {
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosExpedienteComercial(expedienteComercial);
				for (DtoAdjunto adj : listaAdjuntos) {
					AdjuntoExpedienteComercial adjuntoExpedienteComercial = expedienteComercial.getAdjuntoGD(adj.getId());
					if (!Checks.esNulo(adjuntoExpedienteComercial)) {
						if (!Checks.esNulo(adjuntoExpedienteComercial.getTipoDocumentoExpediente())) {
							adj.setDescripcionTipo(adjuntoExpedienteComercial.getTipoDocumentoExpediente().getDescripcion());
						} 
						if(!Checks.esNulo(adjuntoExpedienteComercial.getSubtipoDocumentoExpediente())){
							adj.setDescripcionSubtipo(adjuntoExpedienteComercial.getSubtipoDocumentoExpediente().getDescripcion());
						}
						adj.setContentType(adjuntoExpedienteComercial.getContentType());
						if (!Checks.esNulo(adjuntoExpedienteComercial.getAuditoria())) {
							adj.setGestor(adjuntoExpedienteComercial.getAuditoria().getUsuarioCrear());
						}
						adj.setTamanyo(adjuntoExpedienteComercial.getTamanyo());
					} else {
						DDSubtipoDocumentoExpediente subtipoExp = ddSubtipoDocumentoExpedienteDao.getSubtipoDocumentoExpedienteComercialPorMatricula(adj.getMatricula());
						
						if(!Checks.esNulo(subtipoExp)) {
							if(!Checks.esNulo(subtipoExp.getTipoDocumentoExpediente())) {
								adj.setDescripcionTipo(subtipoExp.getTipoDocumentoExpediente().getDescripcion());
							}
							adj.setDescripcionSubtipo(subtipoExp.getDescripcion());
						}
					}
				}
			} catch (GestorDocumentalException gex) {
				if (GestorDocumentalException.CODIGO_ERROR_CONTENEDOR_NO_EXISTE.equals(gex.getCodigoError())) {
					
					Integer idExpediente;
					try{
						idExpediente = gestorDocumentalAdapterApi.crearExpedienteComercial(expedienteComercial,usuario.getUsername());
						logger.debug("GESTOR DOCUMENTAL [ crearExpediente para " + expedienteComercial.getNumExpediente() + "]: ID EXPEDIENTE RECIBIDO " + idExpediente);
					} catch (GestorDocumentalException gexc) {
						logger.error(gexc.getMessage(),gexc);
					}
				} else {
					throw gex;
				}
			}			
		} else {
			listaAdjuntos = getAdjuntos(id, listaAdjuntos);
		}
		return listaAdjuntos;
	}
	
	@Transactional(readOnly = false)
	public List<DtoAdjunto> getAdjuntoExpedienteComprador(String idIntervinienteHaya, String docCliente,
			Long idExpediente) throws GestorDocumentalException {
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		if (gestorDocumentalAdapterApi.modoRestClientActivado() && !Checks.esNulo(idIntervinienteHaya)) {
			try {
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosEntidadComprador(idIntervinienteHaya);
				Collections.sort(listaAdjuntos);
			} catch (GestorDocumentalException gex) {
				if (GestorDocumentalException.CODIGO_ERROR_CONTENEDOR_NO_EXISTE.equals(gex.getCodigoError())) {
					crearContenedorComprador(idIntervinienteHaya, docCliente, idExpediente);
				}else{
					throw gex;
				}
				
			} catch (Exception ex) {
				logger.error(ex.getMessage(), ex);
			}
		} else {
			Filter filtroComprador = null;
			Comprador comprador = null;
			if (!Checks.esNulo(idIntervinienteHaya)) {
				filtroComprador = genericDao.createFilter(FilterType.EQUALS, "idPersonaHaya",
						Long.parseLong(idIntervinienteHaya));
			} else {
				filtroComprador = genericDao.createFilter(FilterType.EQUALS, "documento", docCliente);
			}
			comprador = genericDao.get(Comprador.class, filtroComprador);

			DtoAdjunto dtoAdjunto = new DtoAdjunto();
			AdjuntoComprador adjuntoComprador = null;

			if (!Checks.esNulo(comprador) && !Checks.esNulo(comprador.getAdjunto())) {
				adjuntoComprador = comprador.getAdjunto();
			} else {
				if (!Checks.esNulo(idIntervinienteHaya)) {
					filtroComprador = genericDao.createFilter(FilterType.EQUALS, "idPersonaHaya",
							Long.parseLong(idIntervinienteHaya));
				} else {
					filtroComprador = genericDao.createFilter(FilterType.EQUALS, "numDocumento",
							comprador.getDocumento());
				}
				Filter filtroAdjunto = genericDao.createFilter(FilterType.NOTNULL, "idAdjunto");
				List<TmpClienteGDPR> tmpClienteGDPR = genericDao.getList(TmpClienteGDPR.class, filtroComprador, filtroAdjunto);
				if (!Checks.estaVacio(tmpClienteGDPR)) {
					adjuntoComprador = genericDao.get(AdjuntoComprador.class,
							genericDao.createFilter(FilterType.EQUALS, "id", tmpClienteGDPR.get(0).getIdAdjunto()));
				}else {
					tmpClienteGDPR = genericDao.getList(TmpClienteGDPR.class, filtroComprador);
					if (!Checks.estaVacio(tmpClienteGDPR) && !Checks.esNulo(tmpClienteGDPR.get(0).getIdAdjunto())) {
						adjuntoComprador = genericDao.get(AdjuntoComprador.class,
								genericDao.createFilter(FilterType.EQUALS, "id", tmpClienteGDPR.get(0).getIdAdjunto()));
					}
				}
				
			}

			if (adjuntoComprador != null) {
				dtoAdjunto.setId(adjuntoComprador.getId());
				dtoAdjunto.setMatricula(adjuntoComprador.getMatricula());
				dtoAdjunto.setNombre(adjuntoComprador.getNombreAdjunto());
				dtoAdjunto.setDescripcionTipo(adjuntoComprador.getTipoDocumento());
				listaAdjuntos.add(dtoAdjunto);
			}
		}
		return listaAdjuntos;
	}
	
	private void crearContenedorComprador(String idIntervinienteHaya,String docCliente,Long idExpediente){
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		try {
			logger.info(CREANDO_CONTENEDOR+" ID PERSONA: "+idIntervinienteHaya+", DOCUMENTO: "+docCliente);
			Integer idPersonaHaya = gestorDocumentalAdapterApi.crearEntidadComprador(idIntervinienteHaya, usuarioLogado.getUsername(), null, null, idExpediente);
			logger.debug("GESTOR DOCUMENTAL [ crearExpedienteComprador para " + docCliente + "]: ID PERSONA RECIBIDO " + idPersonaHaya);
		} catch (Exception gexc) {
			logger.error(ERROR_CREACION_CONTENEDOR, gexc);
		}
	}
	
	@Transactional(readOnly = false)
	public String uploadDocumentoComprador(WebFileItem webFileItem, String idIntervinienteHaya, String docCliente)
			throws Exception {

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		AdjuntoComprador adjuntoComprador = new AdjuntoComprador();
		Adjunto adj = null;
		Long idDocRestClient = null;

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
				DDTipoDocumentoActivo.CODIGO_CONSENTIMIENTO_PROTECCION_DATOS);
		DDTipoDocumentoActivo tipoDocumento = genericDao.get(DDTipoDocumentoActivo.class, filtro);

		if (gestorDocumentalAdapterApi.modoRestClientActivado() && !Checks.esNulo(idIntervinienteHaya)) {
			idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoEntidadComprador(idIntervinienteHaya,
					webFileItem, usuarioLogado.getUsername(), tipoDocumento.getMatricula());

			if (!Checks.esNulo(idDocRestClient)) {
				adjuntoComprador.setIdDocRestClient(idDocRestClient);
			}
		} else {
			// Subida del adjunto en BBDD si el GD no esta activado.
			adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());

			if (!Checks.esNulo(adj)) {
				adjuntoComprador.setAdjunto(adj.getId());
			}
		}

		adjuntoComprador.setMatricula(tipoDocumento.getMatricula());
		adjuntoComprador.setNombreAdjunto(webFileItem.getFileItem().getFileName());
		adjuntoComprador.setTipoDocumento(tipoDocumento.getDescripcion());
		Auditoria.save(adjuntoComprador);
		genericDao.save(AdjuntoComprador.class, adjuntoComprador);

		Filter filtroComprador = null;
		List<Comprador> compradores= null;

		if (!Checks.esNulo(idIntervinienteHaya)) {
			filtroComprador = genericDao.createFilter(FilterType.EQUALS, "idPersonaHaya",
					Long.parseLong(idIntervinienteHaya));
		} else {
			filtroComprador = genericDao.createFilter(FilterType.EQUALS, "documento", docCliente);
		}
		compradores = genericDao.getList(Comprador.class, filtroComprador);

		// Filtro para conseguir el registro del Adjunto
		Filter filtroDocumento = null;
		if (adj != null && Checks.esNulo(idDocRestClient)) {
			filtroDocumento = genericDao.createFilter(FilterType.EQUALS, "adjunto", adj.getId());
		} else if (Checks.esNulo(adj) && !Checks.esNulo(idDocRestClient)) {
			filtroDocumento = genericDao.createFilter(FilterType.EQUALS, "idDocRestClient", idDocRestClient);
		}

		if (!Checks.esNulo(filtroDocumento))
			adjuntoComprador = genericDao.get(AdjuntoComprador.class, filtroDocumento);

		if (!Checks.estaVacio(compradores)) {
			// Actualizacion de cliente para adjuntar documento
			for(Comprador comprador : compradores){
				comprador.setAdjunto(adjuntoComprador);
				Auditoria.save(comprador);
				genericDao.update(Comprador.class, comprador);
			}
			
		} else {
			if (!Checks.esNulo(idIntervinienteHaya)) {
				filtroComprador = genericDao.createFilter(FilterType.EQUALS, "idPersonaHaya",
						Long.parseLong(idIntervinienteHaya));
			} else {
				filtroComprador = genericDao.createFilter(FilterType.EQUALS, "numDocumento", docCliente);
			}
			List<TmpClienteGDPR> tmpClienteGDPRs = genericDao.getList(TmpClienteGDPR.class, filtroComprador);
			if (!Checks.estaVacio(tmpClienteGDPRs)) {
				for(TmpClienteGDPR tmpClienteGDPR : tmpClienteGDPRs){
					tmpClienteGDPR.setIdAdjunto(adjuntoComprador.getId());
					genericDao.update(TmpClienteGDPR.class, tmpClienteGDPR);
				}
				
			}
		}

		return null;
	}
	
	@Transactional(readOnly = false)
	public boolean deleteAdjuntoComprador(AdjuntoComprador adjuntoComprador, Comprador comprador) {
		boolean borrado = false;
		if(adjuntoComprador != null){
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				borrado = gestorDocumentalAdapterApi.borrarAdjunto(adjuntoComprador.getIdDocRestClient(),
						usuarioLogado.getUsername());
			}
	
			if (borrado) {
				// Borrado lógico del documento
				adjuntoComprador.getAuditoria().setBorrado(true);
				adjuntoComprador.getAuditoria().setUsuarioBorrar(usuarioLogado.getUsername());
				adjuntoComprador.getAuditoria().setFechaBorrar(new Date());
				genericDao.update(AdjuntoComprador.class, adjuntoComprador);
	
				if (!Checks.esNulo(comprador)) {
					// Actualizacion del campo en Comprador
					comprador.setAdjunto(null);
					Auditoria.save(comprador);
					genericDao.update(Comprador.class, comprador);
				} else {
					Filter filtroAdjunto = genericDao.createFilter(FilterType.EQUALS, "idAdjunto",
							adjuntoComprador.getId());
					Filter filtroDocumento = genericDao.createFilter(FilterType.EQUALS, "numDocumento",
							comprador.getDocumento());
					List<TmpClienteGDPR> tmpClienteGDPRs = genericDao.getList(TmpClienteGDPR.class, filtroAdjunto, filtroDocumento);
					if (!Checks.estaVacio(tmpClienteGDPRs)) {
						for(TmpClienteGDPR tmpClienteGDPR : tmpClienteGDPRs){
							tmpClienteGDPR.setIdAdjunto(null);
							genericDao.update(TmpClienteGDPR.class, tmpClienteGDPR);
						}
						
					}else {
						tmpClienteGDPRs = genericDao.getList(TmpClienteGDPR.class, filtroAdjunto);
						if (!Checks.estaVacio(tmpClienteGDPRs)) {
							for(TmpClienteGDPR tmpClienteGDPR : tmpClienteGDPRs){
								tmpClienteGDPR.setIdAdjunto(null);
								genericDao.update(TmpClienteGDPR.class, tmpClienteGDPR);
							}
						}
					}
				}
			}
		}
		return borrado;
	}

	public List<DtoAdjunto> getAdjuntos(Long idExpediente, List<DtoAdjunto> listaAdjuntos) {
		try {
			ExpedienteComercial expediente = expedienteComercialApi.findOne(idExpediente);

			for (AdjuntoExpedienteComercial adjunto : expediente.getAdjuntos()) {
				DtoAdjunto dto = new DtoAdjunto();
				BeanUtils.copyProperties(dto, adjunto);
				dto.setIdEntidad(expediente.getId());
				dto.setDescripcionTipo(adjunto.getTipoDocumentoExpediente().getDescripcion());
				dto.setDescripcionSubtipo(adjunto.getSubtipoDocumentoExpediente().getDescripcion());
				dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());
				listaAdjuntos.add(dto);
			}

		} catch (Exception ex) {
			logger.error("error en expedienteComercialManager", ex);
		}
		return listaAdjuntos;
	}

	@Transactional(readOnly = false)
	public String uploadDocumento(WebFileItem webFileItem) throws Exception {
		
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOne(Long.parseLong(webFileItem.getParameter("idEntidad")));
		if (expedienteComercial == null) {
			expedienteComercial = genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS,"numExpediente",Long.parseLong(webFileItem.getParameter("idEntidad"))));
		}
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		List<Long> listaExpComercial = new ArrayList<Long>();
		
		// Comprobar que el documento sea único para aquellos que así se requiera.
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("subtipo"));
		DDSubtipoDocumentoExpediente subtipoDocumento = (DDSubtipoDocumentoExpediente) genericDao.get(DDSubtipoDocumentoExpediente.class, filtro);
		if(expedienteComercialApi.existeDocSubtipo(webFileItem, expedienteComercial) 
				&& (DDSubtipoDocumentoExpediente.CODIGO_PRE_CONTRATO.equals(subtipoDocumento.getCodigo()) 
				|| DDSubtipoDocumentoExpediente.CODIGO_PRE_LIQUIDACION_ITP.equals(subtipoDocumento.getCodigo()) 
				|| DDSubtipoDocumentoExpediente.CODIGO_CONTRATO.equals(subtipoDocumento.getCodigo())
				|| DDSubtipoDocumentoExpediente.CODIGO_LIQUIDACION_ITP.equals(subtipoDocumento.getCodigo())
				|| DDSubtipoDocumentoExpediente.CODIGO_FIANZA.equals(subtipoDocumento.getCodigo())
				|| DDSubtipoDocumentoExpediente.CODIGO_JUSTIFICANTE_INGRESOS.equals(subtipoDocumento.getCodigo())
				|| DDSubtipoDocumentoExpediente.CODIGO_AVAL_BANCARIO.equals(subtipoDocumento.getCodigo()))) {

			return EXCEPTION_DOCUMENTO_SUBTIPO;
		}
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			if (!Checks.esNulo(subtipoDocumento)) {
				if ((DDSubtipoDocumentoExpediente.CODIGO_ADVISORY_NOTE.equals(subtipoDocumento.getCodigo()) ||
						DDSubtipoDocumentoExpediente.CODIGO_ADVISORY_NOTE_FIRMADO_ADVISORY.equals(subtipoDocumento.getCodigo()) ||
								DDSubtipoDocumentoExpediente.CODIGO_ADVISORY_NOTE_FIRMADO_PROPIEDAD.equals(subtipoDocumento.getCodigo())) &&
						DDCartera.CODIGO_CARTERA_CERBERUS.equals(expedienteComercial.getOferta().getActivoPrincipal().getCartera().getCodigo()) && 
						(DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(expedienteComercial.getOferta().getActivoPrincipal().getSubcartera().getCodigo()) ||
								DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(expedienteComercial.getOferta().getActivoPrincipal().getSubcartera().getCodigo()))) {
					//Comprobamos que tengan lo subtipos de documentos apropiados.
					BulkOferta blkOfr = bulkOfertaDao.findOne(null, expedienteComercial.getOferta().getId(), false);
					//Comprobamos que la oferta pertenezca un Bulk.
					if (!Checks.esNulo(blkOfr)) {
						List<BulkOferta> listaBlkOfr = bulkOfertaDao.getListBulkOfertasByIdBulk(blkOfr.getPrimaryKey().getBulkAdvisoryNote().getId());
						
						for(BulkOferta blkOferta : listaBlkOfr) {
							ExpedienteComercial expComercial = expedienteComercialDao.getExpedienteComercialByIdOferta(blkOferta.getOferta().getId());
							if(!Checks.esNulo(expComercial)) {
								if (!expedienteComercial.getNumExpediente().toString().equals(expComercial.getNumExpediente().toString())) 
									listaExpComercial.add(expComercial.getId()); 
							} else { 
								return EXCEPTION_UPLOAD_DOCUMENTO_BULK;
							}
						}
						
						//Subida del documento al GD del expediente actual / Subida a BBDD / Crear relacion con activo.
						Long idDocRestClient = expedienteComercialApi.uploadDocumentoGestorDocumental(expedienteComercial, webFileItem, subtipoDocumento, usuarioLogado.getUsername());
						
						if (!Checks.esNulo(idDocRestClient)) {							
							//Hilo que se utiliza para subir los documentos al resto de ofertas pertenecientes al Bulk correspondiente.
							Thread envioDocumentoGestorDocBulk = new Thread(new EnvioDocumentoGestorDocBulk(listaExpComercial, webFileItem, subtipoDocumento.getCodigo(), usuarioLogado.getUsername()));
							envioDocumentoGestorDocBulk.start();
						} else {
							return ERROR_SUBIDA_DOCUMENTO_GD;
						}
					} else {
						expedienteComercialApi.uploadDocumentoGestorDocumental(expedienteComercial, webFileItem, subtipoDocumento, usuarioLogado.getUsername());
					}
				} else {
					expedienteComercialApi.uploadDocumentoGestorDocumental(expedienteComercial, webFileItem, subtipoDocumento, usuarioLogado.getUsername());
				}
			}
		} else {
			expedienteComercialApi.uploadDocumento(webFileItem, null, expedienteComercial, null);
		}
		
		return null;
	}

	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		boolean borrado = false;
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				try {
					borrado = gestorDocumentalAdapterApi.borrarAdjunto(dtoAdjunto.getId(), usuarioLogado.getUsername());
					dtoAdjunto = adjuntoExpedienteComercialDao.getAdjuntoByIdDocRest(dtoAdjunto);
					if (borrado && !Checks.esNulo(dtoAdjunto) && !Checks.esNulo(dtoAdjunto.getId())) 
						borrado = expedienteComercialApi.deleteAdjunto(dtoAdjunto);
				} catch (Exception e) {
					logger.error(e.getMessage(),e);
				}
			} else {
				borrado = expedienteComercialApi.deleteAdjunto(dtoAdjunto);
			}
			return borrado;		
	}

	
	public List<VListadoOfertasAgrupadasLbk> getListActivosAgrupacionById(Long idOferta){
		return expedienteComercialApi.getListActivosAgrupacionById(idOferta);
	}
	
}




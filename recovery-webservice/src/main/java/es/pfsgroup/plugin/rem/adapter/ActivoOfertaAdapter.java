package es.pfsgroup.plugin.rem.adapter;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.AdjuntoComprador;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.ClienteGDPR;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.TmpClienteGDPR;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;

@Service
public class ActivoOfertaAdapter {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	protected static final Log logger = LogFactory.getLog(ActivoOfertaAdapter.class);
	protected static final String ERROR_CREACION_CONTENEDOR = "Error creando el contenedor de la persona";
	protected static final String CREANDO_CONTENEDOR = "Creando contenedor...";
	
	@Transactional(readOnly = false)
	public List<DtoAdjunto> getAdjunto(String idIntervinienteHaya, String docCliente, Long idActivo, Long idAgrupacion) throws GestorDocumentalException {
		
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			try {
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosEntidadComprador(idIntervinienteHaya);
			} catch (GestorDocumentalException gex) {
					logger.error(gex.getMessage());
					
					if (GestorDocumentalException.CODIGO_ERROR_CONTENEDOR_NO_EXISTE.equals(gex.getCodigoError())) {
	
					Integer idPersonaHaya;
					try {
						logger.info(CREANDO_CONTENEDOR+" ID PERSONA: "+idIntervinienteHaya+", DOCUMENTO: "+docCliente);
						idPersonaHaya = gestorDocumentalAdapterApi.crearEntidadComprador(idIntervinienteHaya, usuarioLogado.getUsername(), idActivo, idAgrupacion, null);
						logger.debug("GESTOR DOCUMENTAL [ crearEntidadOferta para " + docCliente + "]: ID PERSONA RECIBIDO " + idPersonaHaya);
					} catch (GestorDocumentalException gexc) {
						logger.error(ERROR_CREACION_CONTENEDOR, gexc);
					}
				}
				throw gex;
			} catch (Exception ex) {
				logger.error(ex.getMessage());
				ex.printStackTrace();
			}		
		} else {
			//Filtro para conseguir el Cliente Comercial (donde se almacena el idPersona que devuelve el Maestro de Personas)
			Filter filtroPersona = genericDao.createFilter(FilterType.EQUALS, "idPersonaHaya", idIntervinienteHaya);
			Order order = new Order(OrderType.DESC, "id");
			List<ClienteComercial> listClienteCom = genericDao.getListOrdered(ClienteComercial.class,order, filtroPersona);
			ClienteComercial clienteCom = null;
			if(!Checks.estaVacio(listClienteCom))
				clienteCom=listClienteCom.get(0);
			
			ClienteGDPR clienteGDPR = null;
			Filter filtroCliente = null;
			
			//Filtro para conseguir el ClienteGDPR a traves del Cliente Comercial
			if(!Checks.esNulo(clienteCom)) {
				filtroCliente = genericDao.createFilter(FilterType.EQUALS, "numDocumento", clienteCom.getDocumento());
			} else {
				filtroCliente = genericDao.createFilter(FilterType.EQUALS, "numDocumento", docCliente);
			}
			
			clienteGDPR = genericDao.get(ClienteGDPR.class, filtroCliente);
			DtoAdjunto dtoAdjunto = new DtoAdjunto();
			AdjuntoComprador adjuntoComprador = null;
			
			if(!Checks.esNulo(clienteGDPR)) {
				adjuntoComprador = clienteGDPR.getAdjuntoComprador();
			} else {
				filtroPersona = genericDao.createFilter(FilterType.EQUALS, "idPersonaHaya", Long.parseLong(idIntervinienteHaya));
				TmpClienteGDPR tmpClienteGDPR = genericDao.get(TmpClienteGDPR.class, filtroPersona);
				if(!Checks.esNulo(tmpClienteGDPR) && !Checks.esNulo(tmpClienteGDPR.getIdAdjunto())) {
					adjuntoComprador = genericDao.get(AdjuntoComprador.class, genericDao.createFilter(FilterType.EQUALS, "id", tmpClienteGDPR.getIdAdjunto()));
				}
			}
			
			if(!Checks.esNulo(adjuntoComprador)) {
				dtoAdjunto.setId(adjuntoComprador.getId());
				dtoAdjunto.setMatricula(adjuntoComprador.getMatricula());
				dtoAdjunto.setNombre(adjuntoComprador.getNombreAdjunto());
				dtoAdjunto.setDescripcionTipo(adjuntoComprador.getTipoDocumento());	
				listaAdjuntos.add(dtoAdjunto);
			}
		}
		return listaAdjuntos;
	}
	
	@Transactional(readOnly = false)
	public String uploadDocumento(WebFileItem webFileItem, String idIntervinienteHaya) throws Exception {
		
		try {
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			AdjuntoComprador adjuntoComprador = new AdjuntoComprador();
			Adjunto adj = null;
			Long idDocRestClient = null;
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoDocumentoActivo.CODIGO_CONSENTIMIENTO_PROTECCION_DATOS);
			DDTipoDocumentoActivo tipoDocumento = genericDao.get(DDTipoDocumentoActivo.class, filtro);
						
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoEntidadComprador(idIntervinienteHaya, webFileItem, usuarioLogado.getUsername(), tipoDocumento.getMatricula());

				if (!Checks.esNulo(idDocRestClient)) {
					adjuntoComprador.setIdDocRestClient(idDocRestClient);
				}
			} else {
				//Subida del adjunto en BBDD si el GD no esta activado.
				adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());
								
				if(!Checks.esNulo(adj)) {
					adjuntoComprador.setAdjunto(adj.getId());
				}
			}
			
			adjuntoComprador.setMatricula(tipoDocumento.getMatricula());
			adjuntoComprador.setNombreAdjunto(webFileItem.getFileItem().getFileName());
			adjuntoComprador.setTipoDocumento(tipoDocumento.getDescripcion());
			Auditoria.save(adjuntoComprador);
			genericDao.save(AdjuntoComprador.class, adjuntoComprador);
			
			//Filtro para conseguir el Cliente Comercial (donde se almacena el idPersona que devuelve el Maestro de Personas)
			Filter filtroPersona = genericDao.createFilter(FilterType.EQUALS, "idPersonaHaya", idIntervinienteHaya);
			Order order = new Order(OrderType.DESC, "id");
			List<ClienteComercial> listClienteCom = genericDao.getListOrdered(ClienteComercial.class,order, filtroPersona);
			ClienteComercial clienteCom = null;
			if(!Checks.estaVacio(listClienteCom))
				clienteCom=listClienteCom.get(0);
			
			//Filtro para conseguir el registro del Adjunto
			Filter filtroDocumento = null;
			if (!Checks.esNulo(adj) && Checks.esNulo(idDocRestClient)) {
				filtroDocumento = genericDao.createFilter(FilterType.EQUALS, "adjunto", adj.getId());
			} else if (Checks.esNulo(adj) && !Checks.esNulo(idDocRestClient)){
				filtroDocumento = genericDao.createFilter(FilterType.EQUALS, "idDocRestClient", idDocRestClient);
			}
			
			if (!Checks.esNulo(filtroDocumento))
				adjuntoComprador = genericDao.get(AdjuntoComprador.class, filtroDocumento);
			
			ClienteGDPR clienteGDPR = null;
			
			if(!Checks.esNulo(clienteCom)) {
				//Filtro para conseguir el ClienteGDPR a traves del Cliente Comercial
				Filter filtroCliente = genericDao.createFilter(FilterType.EQUALS, "numDocumento", clienteCom.getDocumento());
				clienteGDPR = genericDao.get(ClienteGDPR.class, filtroCliente);
				
				if(!Checks.esNulo(clienteGDPR)) {
					//Actualizacion de cliente para adjuntar documento
					clienteGDPR.setAdjuntoComprador(adjuntoComprador);
					Auditoria.save(clienteGDPR);
					genericDao.update(ClienteGDPR.class, clienteGDPR);
				}
			} else {
				filtroPersona = genericDao.createFilter(FilterType.EQUALS, "idPersonaHaya", Long.parseLong(idIntervinienteHaya));
				TmpClienteGDPR tmpClienteGDPR = genericDao.get(TmpClienteGDPR.class, filtroPersona);
				if(!Checks.esNulo(tmpClienteGDPR)) {
					tmpClienteGDPR.setIdAdjunto(adjuntoComprador.getId());
					genericDao.update(TmpClienteGDPR.class, tmpClienteGDPR);
				}
			}	
		} catch (GestorDocumentalException gex) {
				logger.error(gex.getMessage());
				gex.printStackTrace();
				return gex.getMessage();
		} catch (Exception ex) {
			logger.error(ex.getMessage());
			ex.printStackTrace();
			return ex.getMessage();
		}
		return null;
	}
	
	@Transactional(readOnly = false)
	public boolean deleteAdjunto(AdjuntoComprador adjuntoComprador, ClienteGDPR clienteGDPR) {
		boolean borrado = true;
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				try {
					borrado = gestorDocumentalAdapterApi.borrarAdjunto(adjuntoComprador.getIdDocRestClient(), usuarioLogado.getUsername());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			if(borrado) {
				//Borrado lógico del documento
				adjuntoComprador.getAuditoria().setBorrado(true);
				adjuntoComprador.getAuditoria().setUsuarioBorrar(usuarioLogado.getUsername());
				adjuntoComprador.getAuditoria().setFechaBorrar(new Date());
				genericDao.update(AdjuntoComprador.class, adjuntoComprador);
				
				if (!Checks.esNulo(clienteGDPR)) {
					//Actualizacion del campo en ClienteGDPR
					clienteGDPR.setAdjuntoComprador(null);
					Auditoria.save(clienteGDPR);
					genericDao.update(ClienteGDPR.class, clienteGDPR);
				} else {
					Filter filtroDocumento = genericDao.createFilter(FilterType.EQUALS, "idAdjunto", adjuntoComprador.getId());
					TmpClienteGDPR tmpClienteGDPR = genericDao.get(TmpClienteGDPR.class, filtroDocumento);
					if(!Checks.esNulo(tmpClienteGDPR)) {
						tmpClienteGDPR.setIdAdjunto(null);
						genericDao.update(TmpClienteGDPR.class, tmpClienteGDPR);
					}
				}
			}
		return borrado;		
	}

}

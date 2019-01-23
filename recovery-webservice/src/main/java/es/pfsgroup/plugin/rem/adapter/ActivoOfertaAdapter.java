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
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
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
	
	protected static final Log logger = LogFactory.getLog(ActivoOfertaAdapter.class);
	protected static final String ERROR_CREACION_CONTENEDOR = "Error creando el contenedor de la persona";
	protected static final String CREANDO_CONTENEDOR = "Creando contenedor...";
	
	@Transactional(readOnly = false)
	public List<DtoAdjunto> getAdjunto(String idIntervinienteHaya, String docCliente, Long idActivo, Long idAgrupacion) throws GestorDocumentalException {
		
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			try {
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosEntidadComprador(Long.parseLong(idIntervinienteHaya));
			} catch (GestorDocumentalException gex) {
					logger.error(gex.getMessage());
					
					if (GestorDocumentalException.CODIGO_ERROR_CONTENEDOR_NO_EXISTE.equals(gex.getCodigoError())) {
	
					Integer idPersonaHaya;
					try {
						logger.info(CREANDO_CONTENEDOR+" ID PERSONA: "+idIntervinienteHaya+", DOCUMENTO: "+docCliente);
						idPersonaHaya = gestorDocumentalAdapterApi.crearEntidadComprador(Long.parseLong(idIntervinienteHaya), usuarioLogado.getUsername(), idActivo, idAgrupacion, null);
						logger.debug("GESTOR DOCUMENTAL [ crearEntidadOferta para " + docCliente + "]: ID PERSONA RECIBIDO " + idPersonaHaya);
					} catch (GestorDocumentalException gexc) {
						logger.error(ERROR_CREACION_CONTENEDOR, gexc);
					}
				}
				throw gex;
			} catch (Exception ex) {
				logger.error(ex.getMessage());
			}		
		}
		return listaAdjuntos;
	}
	
	@Transactional(readOnly = false)
	public String uploadDocumento(WebFileItem webFileItem, String idIntervinienteHaya) throws Exception {
		
		try {
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoDocumentoActivo.CODIGO_CONSENTIMIENTO_PROTECCION_DATOS);
				DDTipoDocumentoActivo tipoDocumento = genericDao.get(DDTipoDocumentoActivo.class, filtro);
				
				Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoEntidadComprador(idIntervinienteHaya, webFileItem, usuarioLogado.getUsername(), tipoDocumento.getMatricula());
				if (!Checks.esNulo(idDocRestClient)) {
					//Subida registro adjunto de la oferta activo.
					AdjuntoComprador adjuntoComprador = new AdjuntoComprador();
					adjuntoComprador.setMatricula(tipoDocumento.getMatricula());
					adjuntoComprador.setNombreAdjunto(webFileItem.getFileItem().getFileName());
					adjuntoComprador.setTipoDocumento(tipoDocumento.getDescripcion());
					adjuntoComprador.setIdDocRestClient(idDocRestClient);
					Auditoria.save(adjuntoComprador);
					genericDao.save(AdjuntoComprador.class, adjuntoComprador);
					
					//Filtro para conseguir el Cliente Comercial (donde se almacena el idPersona que devuelve el Maestro de Personas)
					Filter filtroPersona = genericDao.createFilter(FilterType.EQUALS, "idPersonaHaya", idIntervinienteHaya);
					ClienteComercial clienteCom = genericDao.get(ClienteComercial.class, filtroPersona);
					
					//Filtro para conseguir el registro del Adjunto
					Filter filtroDocumento = genericDao.createFilter(FilterType.EQUALS, "idDocRestClient", idDocRestClient);
					adjuntoComprador = genericDao.get(AdjuntoComprador.class, filtroDocumento);
					
					ClienteGDPR clienteGDPR = null;
					
					if(!Checks.esNulo(clienteCom)) {
						//Filtro para conseguir el ClienteGDPR a traves del Cliente Comercial
						Filter filtroCliente = genericDao.createFilter(FilterType.EQUALS, "cliente", clienteCom);
						clienteGDPR = genericDao.get(ClienteGDPR.class, filtroCliente);
						
						//Actualizacion de cliente para adjuntar documento
						clienteGDPR.setAdjuntoComprador(adjuntoComprador);
						Auditoria.save(clienteGDPR);
						genericDao.update(ClienteGDPR.class, clienteGDPR);
					} else {
						TmpClienteGDPR tmpClienteGDPR = genericDao.get(TmpClienteGDPR.class, filtroPersona);
						if(!Checks.esNulo(tmpClienteGDPR)) {
							tmpClienteGDPR.setIdAdjunto(adjuntoComprador.getId());
							genericDao.update(TmpClienteGDPR.class, tmpClienteGDPR);
						}
					}	
				}
			}
		} catch (GestorDocumentalException gex) {
				logger.error(gex.getMessage());
				return gex.getMessage();
		} catch (Exception ex) {
			logger.error(ex.getMessage());
			return ex.getMessage();
		}
		return null;
	}
	
	@Transactional(readOnly = false)
	public boolean deleteAdjunto(AdjuntoComprador adjuntoComprador, ClienteGDPR clienteGDPR) {
		boolean borrado = false;
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				try {
					borrado = gestorDocumentalAdapterApi.borrarAdjunto(adjuntoComprador.getIdDocRestClient(), usuarioLogado.getUsername());
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
							Filter filtroDocumento = genericDao.createFilter(FilterType.EQUALS, "idDocumento", adjuntoComprador.getId());
							TmpClienteGDPR tmpClienteGDPR = genericDao.get(TmpClienteGDPR.class, filtroDocumento);
							if(!Checks.esNulo(tmpClienteGDPR)) {
								tmpClienteGDPR.setIdAdjunto(null);
								genericDao.update(TmpClienteGDPR.class, tmpClienteGDPR);
							}
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		return borrado;		
	}

}

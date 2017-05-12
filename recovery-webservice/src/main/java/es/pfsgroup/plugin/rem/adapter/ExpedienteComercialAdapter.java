package es.pfsgroup.plugin.rem.adapter;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.AdjuntoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoExpediente;

@Service
public class ExpedienteComercialAdapter {

	private static final String EXCEPTION_EXPEDIENT_NOT_FOUND_COD = "ExceptionExp";	

	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GenericABMDao genericDao;
	
	
	protected static final Log logger = LogFactory.getLog(ActivoAdapter.class);
	
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
					}
				}
			} catch (GestorDocumentalException gex) {
				String[] error = gex.getMessage().split("-");
				if(EXCEPTION_EXPEDIENT_NOT_FOUND_COD.equals(error[0])){
					
					Integer idExpediente;
					try{
						idExpediente = gestorDocumentalAdapterApi.crearExpedienteComercial(expedienteComercial,usuario.getUsername());
						logger.debug("GESTOR DOCUMENTAL [ crearExpediente para " + expedienteComercial.getNumExpediente() + "]: ID EXPEDIENTE RECIBIDO " + idExpediente);
					} catch (GestorDocumentalException gexc) {
						gexc.printStackTrace();
						logger.debug(gexc.getMessage());
					}
					
				}
				throw gex;
			}			
		} else {
			listaAdjuntos = getAdjuntos(id, listaAdjuntos);
		}
		return listaAdjuntos;
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

	public String uploadDocumento(WebFileItem webFileItem, ExpedienteComercial expedienteComercialEntrada, String matricula) throws Exception {
		if (Checks.esNulo(expedienteComercialEntrada)) {
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				ExpedienteComercial expedienteComercial = expedienteComercialApi.findOne(Long.parseLong(webFileItem.getParameter("idEntidad")));
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("subtipo"));
				DDSubtipoDocumentoExpediente subtipoDocumento = (DDSubtipoDocumentoExpediente) genericDao.get(DDSubtipoDocumentoExpediente.class, filtro);
				if (!Checks.esNulo(subtipoDocumento)) {
					Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoExpedienteComercial(expedienteComercial, webFileItem,
						usuarioLogado.getUsername(), subtipoDocumento.getMatricula());
				expedienteComercialApi.uploadDocumento(webFileItem, idDocRestClient,null,null);
				}
			} else {
				expedienteComercialApi.uploadDocumento(webFileItem, null,null,null);
			}
		} else {
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("subtipo"));
				DDSubtipoDocumentoExpediente subtipoDocumento = (DDSubtipoDocumentoExpediente) genericDao.get(DDSubtipoDocumentoExpediente.class, filtro);
				if (!Checks.esNulo(subtipoDocumento)) {
					Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoExpedienteComercial(expedienteComercialEntrada, webFileItem,
							usuarioLogado.getUsername(), subtipoDocumento.getMatricula());
					expedienteComercialApi.uploadDocumento(webFileItem, idDocRestClient, expedienteComercialEntrada, matricula);
				}
			} else {
				expedienteComercialApi.uploadDocumento(webFileItem, null, expedienteComercialEntrada, matricula);
			}
		}
		return null;
	}

	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		boolean borrado = false;
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				try {
					borrado = gestorDocumentalAdapterApi.borrarAdjunto(dtoAdjunto.getId(), usuarioLogado.getUsername());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				borrado = expedienteComercialApi.deleteAdjunto(dtoAdjunto);
			}
			return borrado;		
	}
}
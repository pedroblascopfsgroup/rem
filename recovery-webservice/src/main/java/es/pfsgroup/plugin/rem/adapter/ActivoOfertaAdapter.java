package es.pfsgroup.plugin.rem.adapter;

import java.util.ArrayList;
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
import es.pfsgroup.plugin.rem.model.AdjuntoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.ClienteGDPR;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
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
	
	@Transactional(readOnly = false)
	public List<DtoAdjunto> getAdjunto(String idIntervinienteHaya) throws GestorDocumentalException{
		
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		//Usuario usuario = genericAdapter.getUsuarioLogado();
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			try {
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosActivoOferta(idIntervinienteHaya);
			}  catch (GestorDocumentalException gex) {
				logger.error(gex.getMessage());
			} catch (Exception ex) {
				logger.error(ex.getMessage());
			}		
		}
		
		return listaAdjuntos;
	}
	
	public String uploadDocumento(WebFileItem webFileItem, String idIntervinienteHaya, String matricula) throws Exception {
		
		try {
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
				DDTipoDocumentoActivo tipoDocumento = (DDTipoDocumentoActivo) genericDao.get(DDTipoDocumentoActivo.class, filtro);
				
				//Subida registro adjunto de la oferta activo.
				Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoActivoOferta(idIntervinienteHaya, webFileItem, usuarioLogado.getUsername(), tipoDocumento.getMatricula());
				AdjuntoComprador adjuntoComprador = new AdjuntoComprador();
				adjuntoComprador.setMatricula(tipoDocumento.getMatricula());
				adjuntoComprador.setNombreAdjunto(webFileItem.getFileItem().getFileName());
				adjuntoComprador.setTipoDocumento(tipoDocumento.getDescripcion());
				adjuntoComprador.setIdDocRestClient(idDocRestClient);
			    Auditoria.save(adjuntoComprador);
				genericDao.save(AdjuntoComprador.class, adjuntoComprador);
										
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

}

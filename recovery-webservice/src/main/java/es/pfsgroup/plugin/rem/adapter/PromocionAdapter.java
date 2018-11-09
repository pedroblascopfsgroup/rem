package es.pfsgroup.plugin.rem.adapter;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import es.capgemini.devon.beans.Service;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.DownloaderFactoryApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.AdjuntosPromocion;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoPromocion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoPromocion;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoPromocionApi;


@Service
public class PromocionAdapter {
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoPromocionApi activoPromocionApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Resource
	private Properties appProperties;
	
	@Autowired
	private DownloaderFactoryApi downloaderFactoryApi;
	
	private static final String CONSTANTE_REST_CLIENT = "rest.client.gestor.documental.constante";
	
	public List<DtoAdjuntoPromocion> getAdjuntosPromocion(Long id)
			throws GestorDocumentalException, IllegalAccessException, InvocationTargetException {
		List<DtoAdjuntoPromocion> listaAdjuntos = new ArrayList<DtoAdjuntoPromocion>();

		Activo activo = activoPromocionApi.get(id);
		if (gestorDocumentalAdapterApi.modoRestClientActivado() && activo.getCodigoPromocionPrinex() != null && !activo.getCodigoPromocionPrinex().isEmpty()) {
			
			String codPromo =activo.getCodigoPromocionPrinex()+"_"+activo.getCartera().getCodigo().toString();
			listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosPromociones(codPromo);

			for (DtoAdjuntoPromocion adj : listaAdjuntos) {
				AdjuntosPromocion adjuntosPromocion = activo.getAdjuntoPromocionGD(adj.getId());
				if (!Checks.esNulo(adjuntosPromocion)) {
					if (!Checks.esNulo(adjuntosPromocion.getTipoDocumentoPromocion())) {
						adj.setDescripcionTipo(adjuntosPromocion.getTipoDocumentoPromocion().getDescripcion());
					}
					adj.setContentType(adjuntosPromocion.getContentType());
					if (!Checks.esNulo(adjuntosPromocion.getAuditoria())) {
						adj.setGestor(adjuntosPromocion.getAuditoria().getUsuarioCrear());
					}
					adj.setTamanyo(adjuntosPromocion.getTamanyo());
				}
			}

		} else {
			listaAdjuntos = getAdjuntosPromocion(id, listaAdjuntos);
		}
		return listaAdjuntos;
	}
	
	public List<DtoAdjuntoPromocion> getAdjuntosPromocion(Long id, List<DtoAdjuntoPromocion> listaAdjuntos) {
		try {
			
			Activo activo = activoApi.get(id);
			
			if (activo.getCodigoPromocionPrinex() != null && !activo.getCodigoPromocionPrinex().isEmpty()) {
				String codPromo =activo.getCodigoPromocionPrinex()+"_"+activo.getCartera().getCodigo().toString();
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codPromo", codPromo);
				List<AdjuntosPromocion> adjuntosPromocion = (List<AdjuntosPromocion>) genericDao
						.getList(AdjuntosPromocion.class, filtro);
	
				for (AdjuntosPromocion adjuntoPromocion: adjuntosPromocion) {
					DtoAdjuntoPromocion dto = new DtoAdjuntoPromocion();
					BeanUtils.copyProperties(dto, adjuntoPromocion);
					dto.setIdEntidad(codPromo);
					dto.setDescripcionTipo(adjuntoPromocion.getTipoDocumentoPromocion().getDescripcion());
					dto.setGestor(adjuntoPromocion.getAuditoria().getUsuarioCrear());
					dto.setCodPromo(codPromo);
					
					listaAdjuntos.add(dto);
				}
			}

		} catch (Exception ex) {
			logger.error("error en PromocionAdapter", ex);
		}
		return listaAdjuntos;
	}
	
	
	public String uploadDocumento(WebFileItem webFileItem, Activo activoEntrada, String matricula) throws Exception {
		Activo activo = activoPromocionApi.get(Long.parseLong(webFileItem.getParameter("idEntidad")));
		if (activo.getCodigoPromocionPrinex() != null && !activo.getCodigoPromocionPrinex().isEmpty()) {
			if (Checks.esNulo(activoEntrada)) {
				
				if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
					String codPromo =activo.getIdProp().toString()+"_"+activo.getCartera().getCodigo().toString();
					Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
	
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
					DDTipoDocumentoPromocion tipoDocumento = (DDTipoDocumentoPromocion) genericDao
							.get(DDTipoDocumentoPromocion.class, filtro);
					Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoPromociones(codPromo, webFileItem,
							usuarioLogado.getUsername(), tipoDocumento.getMatricula());
					activoPromocionApi.upload2(webFileItem, idDocRestClient);
				} else {
					activoPromocionApi.upload(webFileItem);
				}
			} else {
				if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
					Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
					String codPromo =activoEntrada.getIdProp().toString()+"_"+activoEntrada.getCartera().getCodigo().toString();
	
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);
					DDTipoDocumentoPromocion tipoDocumento = (DDTipoDocumentoPromocion) genericDao
							.get(DDTipoDocumentoPromocion.class, filtro);
	
					if (!Checks.esNulo(tipoDocumento)) {
						Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoPromociones(codPromo, webFileItem,
								usuarioLogado.getUsername(), tipoDocumento.getMatricula());
						activoPromocionApi.uploadDocumento(webFileItem, idDocRestClient, activoEntrada, matricula);
					}
				} else {
					activoPromocionApi.uploadDocumento(webFileItem, null, activoEntrada, matricula);
				}
			}
		}
		return null;
	}
	
	
	
	
	public String upload(WebFileItem webFileItem) throws Exception {
		return uploadDocumento(webFileItem, null, null);

	}
	
	public FileItem download(Long id,String nombreDocumento) throws Exception {
		String key = appProperties.getProperty(CONSTANTE_REST_CLIENT);
		Downloader dl = downloaderFactoryApi.getDownloader(key);
		return dl.getFileItemPromocion(id,nombreDocumento);
	}

}

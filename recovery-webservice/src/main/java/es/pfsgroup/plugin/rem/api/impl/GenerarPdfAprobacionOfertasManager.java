package es.pfsgroup.plugin.rem.api.impl;

import java.io.File;
import java.text.SimpleDateFormat;
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

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.rem.api.GenerarPdfAprobacionOfertasApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoCaixa;
import es.pfsgroup.plugin.rem.model.ActivoDescuentoColectivos;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.DtoDataSource;
import es.pfsgroup.plugin.rem.model.DtoDatosOfertaPdf;
import es.pfsgroup.plugin.rem.model.DtoOfertaPdfPrincipal;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosAgrupacionIncAnuladas;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.service.GenerateJasperPdfServiceManager;
import es.pfsgroup.plugin.rem.utils.FileUtilsREM;

@Component
public class GenerarPdfAprobacionOfertasManager extends GenerateJasperPdfServiceManager  implements GenerarPdfAprobacionOfertasApi {
	
	private static final String TITULO_PROPUESTA_OFERTA_VENTA = "msg.titulo.propuesta.oferta.venta";
	
	private static final String DOCUMENTO_PROPUESTA_VENTA_ACTIVO = "PropuestaAprobacionOferta";
	private static final String SI = "SI";
	private static final String NO = "NO";
	
	protected static final Log logger = LogFactory.getLog(GenerarPdfAprobacionOfertasManager.class);
	
	@Resource
    MessageService messageServices;
	
	@Autowired
	private GenericABMDao genericDao;
	
	private SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");

	@Override
	public File getDocumentoPropuestaVenta(Oferta oferta) throws Exception {

		List<File> listaPdf = new ArrayList<File>();
		File file = null;
		Map<String, Object> params = paramsHojaDatos(oferta, null);
		try {
			file = this.getPDFFile(params, this.dataSourceListadoOfertasActivo(oferta), DOCUMENTO_PROPUESTA_VENTA_ACTIVO);
			listaPdf.add(file);	
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw new Exception(e);
		}

		File salida = null;
		try {
			salida = File.createTempFile("propuestaAprobacionOferta", ".pdf");
			FileUtilsREM.concatenatePdfs(listaPdf, salida);
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw new Exception(e);
		}
		
		return salida;
	}
	
	@Override
	public Map<String, Object> paramsHojaDatos(Oferta oferta, CompradorExpediente compradorExp) throws Exception {		
		Map<String, Object> mapaValores = new HashMap<String,Object>();
		DtoOfertaPdfPrincipal dto = getDtoPdfPrincipalRelleno (oferta);
		mapaValores.put("msgTitulo", messageServices.getMessage(TITULO_PROPUESTA_OFERTA_VENTA));
		if (dto != null) {
			mapaValores.put("fechaActual", FileUtilsREM.stringify(dto.getFechaActual()));
			mapaValores.put("direccionInmueble", FileUtilsREM.stringify(dto.getDireccionInmueble()));
			mapaValores.put("provinciaInmueble", FileUtilsREM.stringify(dto.getProvinciaInmueble()));
			mapaValores.put("procedenciaInmueble", FileUtilsREM.stringify(dto.getProcedenciaInmueble()));			
			mapaValores.put("poblacionInmueble", FileUtilsREM.stringify(dto.getPoblacionInmueble()));
			mapaValores.put("sociedad", FileUtilsREM.stringify(dto.getSociedad()));
			mapaValores.put("ur", FileUtilsREM.stringify(dto.getUr()));
			mapaValores.put("fincaRegistral", FileUtilsREM.stringify(dto.getFincaRegistral()));
			mapaValores.put("tipoInmueble", FileUtilsREM.stringify(dto.getTipoInmueble()));
			mapaValores.put("situacionComercial", FileUtilsREM.stringify(dto.getSituacionComercial()));
			mapaValores.put("situacionPosesoria", FileUtilsREM.stringify(dto.getSituacionPosesoria()));
			mapaValores.put("situacionJuridica", FileUtilsREM.stringify(dto.getSituacionJuridica()));			
			mapaValores.put("vpo", FileUtilsREM.stringify(!Checks.esNulo(dto.getVpo()) ? "Si" : "No"));
			mapaValores.put("fechaDacionCesionAdj", FileUtilsREM.stringify(dto.getFechaDacionCesionAdj()));
			mapaValores.put("importeDacionCesionAj", FileUtilsREM.stringify(dto.getImporteDacionCesionAj()));
			mapaValores.put("valorContableBruto", FileUtilsREM.stringify(dto.getValorContableBruto()));
			mapaValores.put("valorContableNeto", FileUtilsREM.stringify(dto.getValorContableNeto()));
			mapaValores.put("importePrecioVenta", FileUtilsREM.stringify(dto.getImportePrecioVenta()));
			mapaValores.put("importeValoracMercadoActual", FileUtilsREM.stringify(dto.getImporteValoracMercadoActual()));
			mapaValores.put("importeValoracMercadoActualFecha", FileUtilsREM.stringify(dto.getImporteValoracMercadoActualFecha()));
			mapaValores.put("importeValoracMercado", FileUtilsREM.stringify(dto.getImporteValoracMercado()));
			mapaValores.put("importeValoracMercadoFecha", FileUtilsREM.stringify(dto.getImporteValoracMercadoFecha()));
			mapaValores.put("importeValoracMercadoAntigua", FileUtilsREM.stringify(dto.getImporteValoracMercadoAntigua()));
			mapaValores.put("importeValoracMercadoAntiguaFecha", FileUtilsREM.stringify(dto.getImporteValoracMercadoAntiguaFecha()));
			mapaValores.put("canalesComercializacion", FileUtilsREM.stringify(dto.getCanalesComercializacion()));
			mapaValores.put("interesados", FileUtilsREM.stringify(dto.getInteresados()));
			mapaValores.put("numOferta", FileUtilsREM.stringify(dto.getNumOferta()));
			mapaValores.put("importePropuesta", FileUtilsREM.stringify(dto.getImportePropuesta()));			
			mapaValores.put("campanya", FileUtilsREM.stringify(dto.getCampanya()));
			mapaValores.put("familiarCaixa", FileUtilsREM.stringify(dto.getFamiliarCaixa()));
			mapaValores.put("multiestrella", FileUtilsREM.stringify(dto.getMultiestrella()));
			mapaValores.put("antiguoDeudor", FileUtilsREM.stringify(dto.getAntiguoDeudor()));
			mapaValores.put("compraApiFamiliar", FileUtilsREM.stringify(dto.getCompraApiFamiliar()));			
			mapaValores.put("compradorUnoNif", FileUtilsREM.stringify(dto.getCompradorUnoNif()));
			mapaValores.put("compradorUnoNombre", FileUtilsREM.stringify(dto.getCompradorUnoNombre()));
			mapaValores.put("compradorDosNif", FileUtilsREM.stringify(dto.getCompradorDosNif()));
			mapaValores.put("compradorDosNombre", FileUtilsREM.stringify(dto.getCompradorDosNombre()));
			mapaValores.put("api", FileUtilsREM.stringify(dto.getApi()));
			mapaValores.put("notificarFrob", FileUtilsREM.stringify(dto.getNotificarFrob()));					
			mapaValores.put("notas", FileUtilsREM.stringify(dto.getNotas()));
		}
			
		return mapaValores;
	}

	@Override
		public DtoOfertaPdfPrincipal getDtoPdfPrincipalRelleno(Oferta oferta) {
			DtoOfertaPdfPrincipal dtoAux = new DtoOfertaPdfPrincipal();
		
			Activo activo = oferta.getActivoPrincipal();
			dtoAux.setFechaActual(new Date());
			
			dtoAux = rellenarDatosDtoByActivo(activo,dtoAux);
			dtoAux = rellenarDatosDtoByOferta(oferta,dtoAux);
			
		
			return dtoAux;
		}
	
	private DtoOfertaPdfPrincipal rellenarDatosDtoByOferta(Oferta oferta, DtoOfertaPdfPrincipal dtoAux) {
		if (oferta != null) {
			if (oferta.getNumOferta() != null) {
				dtoAux.setNumOferta(oferta.getNumOferta().toString());
			}
			if (oferta.getImporteOferta() != null) {
				dtoAux.setImportePropuesta(oferta.getImporteOferta());
			}
			ClienteComercial cliente = oferta.getCliente();
			if (cliente != null && cliente.getNombreCompleto() != null) {
				dtoAux.setCompradorUnoNombre(cliente.getNombreCompleto());
			}
			if (cliente != null && cliente.getDocumento() != null) {
				dtoAux.setCompradorUnoNif(cliente.getDocumento());
			}
			if (cliente != null && cliente.getInfoAdicionalPersona() != null
					&& cliente.getInfoAdicionalPersona().getVinculoCaixa() != null) {
				dtoAux.setFamiliarCaixa(true);
			}else {
				dtoAux.setFamiliarCaixa(false);
			}
			if(oferta.getExpedienteComercial() != null 
					&& !oferta.getExpedienteComercial().getCompradores().isEmpty() 
					&& oferta.getExpedienteComercial().getCompradores().get(0).getAntiguoDeudor() != null) {
				dtoAux.setAntiguoDeudor(true);	
			}else {
				dtoAux.setAntiguoDeudor(false);
			}
			if(oferta.getPrescriptor() != null) {
				dtoAux.setApi(oferta.getPrescriptor().getNombreComercial());
			}
		}
		return dtoAux;
	}

	private DtoOfertaPdfPrincipal rellenarDatosDtoByActivo(Activo activo, DtoOfertaPdfPrincipal dtoAux) {
		if (activo != null) {
			if (activo.getDireccionCompleta() != null) {
				dtoAux.setDireccionInmueble(activo.getDireccionCompleta());
			}
			if (activo.getBien() != null && activo.getBien().getLocalizaciones() != null && activo.getBien().getLocalizaciones().get(0).getProvincia() != null
					&& activo.getBien().getLocalizaciones().get(0).getProvincia().getDescripcion() != null) {
				dtoAux.setProvinciaInmueble(activo.getBien().getLocalizaciones().get(0).getProvincia().getDescripcion());
			}
			if (activo.getBien() != null && activo.getBien().getLocalizaciones() != null 
					&& activo.getBien().getLocalizaciones().get(0).getPoblacion() != null) {
				dtoAux.setProcedenciaInmueble(activo.getBien().getLocalizaciones().get(0).getPoblacion());	
			}
			if (activo.getBien() != null && activo.getBien().getLocalizaciones() != null && activo.getBien().getLocalizaciones().get(0).getLocalidad() != null
					&& activo.getBien().getLocalizaciones().get(0).getLocalidad().getDescripcion() != null) {
				dtoAux.setPoblacionInmueble(activo.getBien().getLocalizaciones().get(0).getLocalidad().getDescripcion());
			}
			if (activo.getVpo() != null) {
				dtoAux.setVpo(activo.getVpo().toString());
			}
			if (activo.getNumActivo() != null) {
				dtoAux.setUr(activo.getNumActivo().toString());
			}
			if (activo.getSituacionComercial() != null) {
				dtoAux.setSituacionComercial(activo.getSituacionComercial().getDescripcion());
			}
			if (activo.getSituacionPosesoria() != null && activo.getSituacionPosesoria().getTipoTituloPosesorio() != null) {
				dtoAux.setSituacionPosesoria(activo.getSituacionPosesoria().getTipoTituloPosesorio().getDescripcion());
			}
			if (activo.getTipoActivo() != null) {
				dtoAux.setTipoInmueble(activo.getTipoActivo().getDescripcion());
			}
			if (activo.getTipoComercializacion() != null) {
				dtoAux.setCanalesComercializacion(activo.getTipoComercializacion().getDescripcion());
			}
			ActivoCaixa cb = genericDao.get(ActivoCaixa.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
			if (cb != null) {
				if (cb.getCampanyaPrecioAlquilerNegociable() != null || cb.getCampanyaPrecioVentaNegociable() != null) {
					dtoAux.setCampanya(true);
				}else {
					dtoAux.setCampanya(false);
				}
			}
			ActivoDescuentoColectivos adc = genericDao.get(ActivoDescuentoColectivos.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
			if (adc != null) {
				if (adc.getDescuentosColectivos() != null) {
					dtoAux.setMultiestrella(true);
				}else {
					dtoAux.setMultiestrella(false);
				}
			}	
			if(activo.getFullNamePropietario() != null) {
				dtoAux.setSociedad(activo.getFullNamePropietario());
			}
			if(activo.getInfoRegistral() != null && activo.getInfoRegistral().getInfoRegistralBien() != null) {
				dtoAux.setFincaRegistral(activo.getInfoRegistral().getInfoRegistralBien().getNumFinca());
			}
			if(activo.getTitulo() != null && activo.getTitulo().getEstado() != null) {
				dtoAux.setSituacionJuridica(activo.getTitulo().getEstado().getDescripcion());
			}
			if(activo.getAdjNoJudicial() != null) {
				dtoAux.setFechaDacionCesionAdj(activo.getAdjNoJudicial().getFechaTitulo());
				dtoAux.setImporteDacionCesionAj(activo.getAdjNoJudicial().getValorAdquisicion());
			}
			if(!Checks.estaVacio(activo.getOfertas())) {
				dtoAux.setInteresados(new Long(activo.getOfertas().size()));
			}
			if(!activo.getTasacion().isEmpty()) {
				List<ActivoTasacion> listActTas = activo.getTasacion();
				dtoAux.setImporteValoracMercadoActual(listActTas.get(0).getImporteTasacionFin());
				dtoAux.setImporteValoracMercadoActualFecha(listActTas.get(0).getFechaInicioTasacion());
				dtoAux.setImporteValoracMercado(listActTas.get(1).getImporteTasacionFin());
				dtoAux.setImporteValoracMercadoFecha(listActTas.get(1).getFechaInicioTasacion());
				dtoAux.setImporteValoracMercadoAntigua(listActTas.get(listActTas.size()-1).getImporteTasacionFin());
				dtoAux.setImporteValoracMercadoAntiguaFecha(listActTas.get(listActTas.size()-1).getFechaInicioTasacion());
			}
			if(!activo.getValoracion().isEmpty()) {
				for (ActivoValoraciones actVal : activo.getValoracion()) {
					if(actVal.getTipoPrecio() != null && DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA.equals(actVal.getTipoPrecio().getCodigo())) {
						dtoAux.setImportePrecioVenta(actVal.getImporte());
						break;
					}
				}
			}
			if(activo.getTipoComercializacion() != null) {
				dtoAux.setCanalesComercializacion(activo.getTipoComercializacion().getDescripcion());
			}
			ActivoCaixa activoCaixa = genericDao.get(ActivoCaixa.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
			if(activoCaixa != null && activoCaixa.getCategoriaComercializacion() != null) {
				dtoAux.setMultiestrella(true);
			}else {
				dtoAux.setMultiestrella(false);
			}
		}
		return dtoAux;
	}

	private List<Object> dataSourceListadoOfertasActivo(Oferta oferta) throws Exception {
		
		DtoDataSource dtoDataSource = new DtoDataSource();
		Activo activo = oferta.getActivoPrincipal();
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "idActivo", activo.getId());
		Order order = new Order(OrderType.DESC, "fechaCreacion");
		
		List<VGridOfertasActivosAgrupacionIncAnuladas> listaAof = genericDao.getListOrdered(VGridOfertasActivosAgrupacionIncAnuladas.class,order, filter);
		List<Object> array = new ArrayList<Object>();
		for (VGridOfertasActivosAgrupacionIncAnuladas iterator : listaAof) {
			DtoDatosOfertaPdf dto = new DtoDatosOfertaPdf();
			iterator.getIdOferta();
			Oferta ofertaAux = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id", iterator.getIdOferta()));
			dto.setNumOferta(ofertaAux.getNumOferta());
			dto.setNombre(ofertaAux.getCliente().getNombreCompleto());
			dto.setImporteOferta(ofertaAux.getImporteOferta());
			dto.setFechaOferta(FileUtilsREM.stringify(ofertaAux.getFechaAlta()));
			if(ofertaAux.getOfertaCaixa() != null
					&& ofertaAux.getOfertaCaixa().getEstadoComunicacionC4C() != null) {
				dto.setEstadoOferta(ofertaAux.getOfertaCaixa().getEstadoComunicacionC4C().getDescripcion());	
			}
			ClienteComercial cliente = ofertaAux.getCliente();
			if (cliente != null) {
				if (cliente.getInfoAdicionalPersona() != null && cliente.getInfoAdicionalPersona().getVinculoCaixa() != null) {
					dto.setFamiliarCaixa(SI);
				}else {
					dto.setFamiliarCaixa(NO);
				}
			}else {
				dto.setFamiliarCaixa(NO);
			}		
			
			array.add(dto);
		}
		
		dtoDataSource.setListaOferta(array);
		List<Object> dataSource =  new ArrayList<Object>();
		dataSource.add(dtoDataSource);
		
		return dataSource;
	}
	@Override
	public WebFileItem getWebFileItemByFile (File file, Long numExpediente) {
		Boolean crear = true;
        WebFileItem webFileItem = new WebFileItem();
        FileItem fileItem = null;
				
		try {
			if (file != null) {
				fileItem = new FileItem(file);				

				String fileName = file.getPath();
				String fileNameFilter = fileName.substring(fileName.lastIndexOf('/')+1, fileName.length());
				fileItem.setFileName(fileNameFilter);
				fileItem.setLength(file.length());
				fileItem.setContentType("application/pdf");
				
				//Con esto meto los parámetros
				webFileItem.putParameter("tipo", DDTipoDocumentoExpediente.CODIGO_DOCUMENTOS_COMPRADORES); 
				webFileItem.putParameter("subtipo", DDSubtipoDocumentoExpediente.CODIGO_PROPUESTA_APROBACION_OFERTA); 
				webFileItem.putParameter("idEntidad", numExpediente.toString());
				webFileItem.putParameter("descripcion", ""); //TODO
				webFileItem.putParameter("activos", "");

			}else {
				crear = false;
			}
		} catch (Exception e) {
			throw new BusinessOperationException(e);
		}
		if(crear) {
			webFileItem.setFileItem(fileItem);
		}
		return webFileItem;
	}

}

package es.pfsgroup.plugin.rem.api.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.output.ByteArrayOutputStream;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.PropuestaOfertaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoCliente;
import es.pfsgroup.plugin.rem.model.DtoOferta;
import es.pfsgroup.plugin.rem.model.DtoPropuestaOferta;
import es.pfsgroup.plugin.rem.model.DtoTasacionInforme;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPorCuenta;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.recovery.api.ExpedienteApi;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

@Service("propuestaOfertaManager")
public class PropuestaOfertaManager implements PropuestaOfertaApi{

	private final String CODES = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
	@Autowired 
	private OfertaApi ofertaApi;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ExpedienteApi expedienteApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	private String formatDate (Date date) {
		if (date==null) return "-";
		DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		return dateFormat.format(date).toString();
	}
	
	private String notNull (Object obj) {
		if (obj==null) return "-";
		return obj.toString();
	}
	
	@Override
	public Map<String, Object> paramsPropuestaSimple(Long numOfertaHRE, ModelMap model) {
		
		Map<String, Object> mapaValores = new HashMap<String,Object>();
		Oferta oferta = ofertaApi.getOfertaByNumOfertaRem(numOfertaHRE);
		
		try {
			if (oferta==null) {
				model.put("error", RestApi.REST_NO_RELATED_OFFER);
				throw new Exception(RestApi.REST_NO_RELATED_OFFER);					
			}
			mapaValores.put("NumOfProp", oferta.getNumOferta()+"/1");
			
			//Obteniedo el activo relacionado con la OFERTA
			Activo activo = oferta.getActivoPrincipal();
			if (activo == null) {
				model.put("error", RestApi.REST_NO_RELATED_ASSET);
				throw new Exception(RestApi.REST_NO_RELATED_ASSET);
			}
			mapaValores.put("Activo", activo.getNumActivoUvem().toString());
			
			mapaValores.put("FRecepOf", formatDate(oferta.getFechaAlta()) );
			mapaValores.put("FProp", formatDate(new Date()));

			Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", "GCOM");
			Long tipo = genericDao.get(EXTDDTipoGestor.class, filter).getId();		
			if (gestorActivoApi.getGestorByActivoYTipo(activo, tipo)!=null) {
				mapaValores.put("Gestor", gestorActivoApi.getGestorByActivoYTipo(activo, tipo).getApellidoNombre());
			} else {
				mapaValores.put("Gestor", notNull(null));
			}
			
			mapaValores.put("FPublWeb", formatDate(activo.getFechaPublicable()));
			mapaValores.put("NumVisitasWeb", notNull(activo.getVisitas().size()));
			
			mapaValores.put("Direccion",notNull(activo.getDireccion()));
			if (activo.getTipoActivo()!=null) {
				mapaValores.put("Tipo",notNull(activo.getTipoActivo().getDescripcionLarga()));
			}
			if (activo.getSubtipoActivo()!=null) {
				mapaValores.put("Subtipo",notNull(activo.getSubtipoActivo().getDescripcionLarga()));
			}
			mapaValores.put("Residencia","-");
			mapaValores.put("CertificadoEnergetico","-");
			mapaValores.put("SuperficieConstruida",notNull(activo.getTotalSuperficieConstruida()));
			mapaValores.put("Parcela",notNull(activo.getTotalSuperficieParcela()));
			mapaValores.put("Sociedadpatrimonial","-");
			mapaValores.put("FEntradaCartera","-");
			mapaValores.put("FincaRegistral","-");
			mapaValores.put("FRecepcionLlaves","-");
			mapaValores.put("Disponibilidadjuridica","-");
			mapaValores.put("SituacionProcesal","-");
			mapaValores.put("SituacionLiquidacionInscripcion","-");
			mapaValores.put("Situaciondecargas","-"); //?? -> activo.getCargas().getCargaBien());
			mapaValores.put("Comercializacion","-");
			mapaValores.put("Entrada","-");
			mapaValores.put("CantidadOfertas", notNull(activoApi.cantidadOfertas(activo)));
			mapaValores.put("MayorOfertaRecibida", String.valueOf(activoApi.mayorOfertaRecibida(activo)));
			
			mapaValores.put("ImportePropuesta", notNull(oferta.getImporteOfertaAprobado()));
			mapaValores.put("ImporteInicial", notNull(oferta.getImporteOferta()));
			mapaValores.put("FechaContraoferta", formatDate(oferta.getFechaContraoferta()));
			mapaValores.put("GastosCompraventa", "-");
			
			Oferta ofertaAceptada = ofertaApi.getOfertaAceptadaByActivo(activo);
			if (ofertaAceptada==null) {
				model.put("error", RestApi.REST_NO_RELATED_OFFER_ACCEPTED);
				throw new Exception(RestApi.REST_NO_RELATED_OFFER_ACCEPTED);					
			}
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id", ofertaAceptada.getId());
			ExpedienteComercial expediente = (ExpedienteComercial) genericDao.get(ExpedienteComercial.class, filtro);
			if (expediente==null) {
				model.put("error", RestApi.REST_NO_RELATED_EXPEDIENT);
				throw new Exception(RestApi.REST_NO_RELATED_EXPEDIENT);					
			}
			CondicionanteExpediente condExp = expediente.getCondicionante();
			if (condExp==null) {
				model.put("error", RestApi.REST_NO_RELATED_COND_EXPEDIENT);
				throw new Exception(RestApi.REST_NO_RELATED_COND_EXPEDIENT);					
			}

			mapaValores.put("Contraoferta", notNull(oferta.getImporteContraOferta()));	
			
//			Si con posesión inicial "sí": El ofertante requiere que haya posesión inicial.
//			Si con posesión inicial "no": El ofertante acepta que no haya posesión inicial.
//			Si con situación posesoria "vacío": El ofertante acepta cualquier situación posesoria.
//			Si con situación posesoria "libre": El ofertante requiere que el activo esté libre de ocupantes.
//			Si con situación posesoria "ocupado con título": El ofertante acepta que el activo esté arrendado.
			DDSituacionesPosesoria sitaPosesion = condExp.getSituacionPosesoria();
			Integer poseInicial = condExp.getPosesionInicial();
			if (sitaPosesion!=null && poseInicial!=null) {
				if (poseInicial.equals(new Integer(1))) {
					mapaValores.put("Posesion", "El ofertante requiere que haya posesión inicial.");
				} else {
					if (sitaPosesion==null) {
						mapaValores.put("Posesion", "El ofertante acepta cualquier situación posesoria.");
					} else if (sitaPosesion.getCodigo().equals(DDSituacionesPosesoria.SITUACION_POSESORIA_LIBRE)) {
						mapaValores.put("Posesion", "El ofertante requiere que el activo esté libre de ocupantes.");
					} else if (sitaPosesion.getCodigo().equals(DDSituacionesPosesoria.SITUACION_POSESORIA_OCUPADO_CON_TITULO)) {
						mapaValores.put("Posesion", "El ofertante acepta que el activo esté arrendado.");
					}
				}
			} else {
				mapaValores.put("Posesion", notNull(null));
			}
			
			mapaValores.put("Impuestos", notNull(condExp.getCargasImpuestos()));
			mapaValores.put("Comunidades", notNull(condExp.getCargasComunidad()));
			mapaValores.put("Otros", notNull(condExp.getCargasOtros()));
			mapaValores.put("Importe", notNull(condExp.getGastosNotaria()));
			mapaValores.put("OpCondicionadaa", "-");
			
//			Si hay contenido en impuestos y en el combo "por cuenta de" pone "comprador": El comprador asume el pago de los impuestos pendientes.
//			Si hay contenido en comunidades y en el combo "por cuenta de" pone "vendedor": El comprador no asume el pago de los impuestos pendientes.
//			Si hay contenido en otros y en el combo "por cuenta de" pone "según ley": El comprador requiere que los gastos sean asumidos por quien corresponda según ley.
			mapaValores.put("Tratamientodecargas", "-");
			
			DDTiposPorCuenta tipoPlusValia = condExp.getTipoPorCuentaPlusvalia();
			if (tipoPlusValia!=null) {
				mapaValores.put("Plusvalia", notNull(tipoPlusValia.getDescripcionLarga()));
			} else {
				mapaValores.put("Plusvalia", notNull(null));
			}
			DDTiposPorCuenta tipoNotaria = condExp.getTipoPorCuentaNotaria();
			if (tipoNotaria!=null) {
				mapaValores.put("Notaria", notNull(tipoNotaria.getDescripcionLarga()));
			} else {
				mapaValores.put("Notaria", notNull(null));
			}
			DDTiposPorCuenta tipoOtros = condExp.getTipoPorCuentaGastosOtros();
			if (tipoOtros!=null) {
				mapaValores.put("OtrosImporteOferta",  notNull(tipoOtros.getDescripcionLarga()));
			} else {
				mapaValores.put("OtrosImporteOferta", notNull(null));
			}
			mapaValores.put("Reserva", "-");
			if (activo.getInfoRegistral()!=null && activo.getInfoRegistral().getInfoRegistralBien()!=null) {
				if (activo.getInfoRegistral().getInfoRegistralBien().getFechaInscripcion()==null) {
					mapaValores.put("Inscripcion", "SI");
				} else {
					mapaValores.put("Inscripcion", "NO");
				}
			}			
			
			mapaValores.put("ValorTasacion", "-");
			mapaValores.put("ValorEstColabor", "-");
			mapaValores.put("ValorAprobVenta", "-");
			
		} catch (JsonParseException e1) {
			e1.printStackTrace();
		} catch (JsonMappingException e1) {
			e1.printStackTrace();
		} catch (IOException e1) {
			e1.printStackTrace();
		} catch (Exception e1){
			e1.printStackTrace();
		} 
		
		return mapaValores;
	}

	@Override
	public List<Object> dataSourcePropuestaSimple(Long numOfertaHRE, ModelMap model) {
		
		List<Object> array = new ArrayList();
		
		DtoPropuestaOferta propuestaOferta = new DtoPropuestaOferta();
		
		DtoCliente cliente = new DtoCliente();
		cliente.setNombreCliente("-");
		cliente.setDireccionCliente("-");
		cliente.setDniCliente("-");
		cliente.setTlfCliente("-");
		
		DtoCliente cliente2 = new DtoCliente();
		cliente2.setNombreCliente("-");
		cliente2.setDireccionCliente("-");
		cliente2.setDniCliente("-");
		cliente2.setTlfCliente("-");

		List<Object> listaCliente = new ArrayList<Object>();
		listaCliente.add(cliente);
		listaCliente.add(cliente2);
		propuestaOferta.setListaCliente(listaCliente);
		
		DtoOferta ofertaActivo = new DtoOferta();
		ofertaActivo.setNumOferta("-");
		ofertaActivo.setTitularOferta("-");
		ofertaActivo.setImporteOferta("-");
		ofertaActivo.setFechaOferta("-");
		ofertaActivo.setSituacionOferta("-");
		
		DtoOferta ofertaActivo2 = new DtoOferta();
		ofertaActivo2.setNumOferta("-");
		ofertaActivo2.setTitularOferta("-");
		ofertaActivo2.setImporteOferta("-");
		ofertaActivo2.setFechaOferta("-");
		ofertaActivo2.setSituacionOferta("-");
		
		List<Object> listaOferta = new ArrayList<Object>();
		listaOferta.add(ofertaActivo);
		listaOferta.add(ofertaActivo2);
		propuestaOferta.setListaOferta(listaOferta);
		
		DtoTasacionInforme tasacion = new DtoTasacionInforme();
		tasacion.setNumTasacion("-");
		tasacion.setTipoTasacion("-");
		tasacion.setImporteTasacion("-");
		tasacion.setFechaTasacion("-");
		tasacion.setFirmaTasacion("-");
		
		List<Object> listaTasacion = new ArrayList<Object>();
		listaTasacion.add(tasacion);
		propuestaOferta.setListaTasacion(listaTasacion);
		
		array.add(propuestaOferta);
		
		return array;
	}

	@Override
	public File getPDFFilePropuestaSimple(Map<String, Object> params, List<Object> dataSource, ModelMap model) {
		
		String namePropuestaSimple = "PropuestaResolucion001";
		String ficheroPlantilla = "jasper/"+namePropuestaSimple+".jrxml";
		
		InputStream is = this.getClass().getClassLoader().getResourceAsStream(ficheroPlantilla);
		File fileSalidaTemporal = null;
		
		//Comprobar si existe el fichero de la plantilla
		if (is == null) {
			model.put("error","No existe el fichero de plantilla " + ficheroPlantilla);
		} else  {
			try {
				//Compilar la plantilla
				JasperReport report = JasperCompileManager.compileReport(is);	
				
				//JasperReport report = (JasperReport)JRLoader.loadObject(is);

				//Rellenar los datos del informe
				JasperPrint print = JasperFillManager.fillReport(report, params,  new JRBeanCollectionDataSource(dataSource));
				
				//Exportar el informe a PDF
				fileSalidaTemporal = File.createTempFile("jasper", ".pdf");
				fileSalidaTemporal.deleteOnExit();
				if (fileSalidaTemporal.exists()) {
					JasperExportManager.exportReportToPdfStream(print, new FileOutputStream(fileSalidaTemporal));
					FileItem fi = new FileItem();
					fi.setFileName(ficheroPlantilla + (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + ".pdf");
					fi.setFile(fileSalidaTemporal);
				} else {
					throw new IllegalStateException("Error al generar el fichero de salida " + fileSalidaTemporal);
				}
				
			} catch (JRException e) {
				model.put("error","Error al compilar el informe en JasperReports " + e.getLocalizedMessage());
			} catch (IOException e) {
				model.put("error","No se puede escribir el fichero de salida");
			} catch (Exception e) {
				model.put("error","Error al generar el informe en JasperReports " + e.getLocalizedMessage());
			};
		}
		
		return fileSalidaTemporal;

	}

	@Override
	public void sendFileBase64(HttpServletResponse response, File file, ModelMap model) {
		
		Map<String, Object> dataResponse = new HashMap<String, Object>();
		
		try {
			byte[] bytes = read(file);
			dataResponse.put("contentType", "application/pdf");
			dataResponse.put("fileName", "HojaPresentacionPropuesta.pdf");
			dataResponse.put("hojaPropuesta",base64Encode(bytes));
			model.put("data", dataResponse);
			
//       		ServletOutputStream salida = response.getOutputStream(); 
//       		FileInputStream fileInputStream = new FileInputStream(file.getAbsolutePath());
// 
//       		if(fileInputStream!= null) {       		
//	       		response.setHeader("Content-disposition", "attachment; filename=PropuestaOferta.pdf");
//	       		response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
//	       		response.setHeader("Cache-Control", "max-age=0");
//	       		response.setHeader("Expires", "0");
//	       		response.setHeader("Pragma", "public");
//	       		response.setDateHeader("Expires", 0); //prevents caching at the proxy
//	       		response.setContentType("application/pdf");		
//	       		FileUtils.copy(fileInputStream, salida);// Write
//	       		salida.flush();
//	       		salida.close();
//       		}
       		
       	} catch (Exception e) { 
       		e.printStackTrace();
       	}
	}

    private String base64Encode(byte[] in)       {
        StringBuilder out = new StringBuilder((in.length * 4) / 3);
        int b;
        for (int i = 0; i < in.length; i += 3)  {
            b = (in[i] & 0xFC) >> 2;
            out.append(CODES.charAt(b));
            b = (in[i] & 0x03) << 4;
            if (i + 1 < in.length)      {
                b |= (in[i + 1] & 0xF0) >> 4;
                out.append(CODES.charAt(b));
                b = (in[i + 1] & 0x0F) << 2;
                if (i + 2 < in.length)  {
                    b |= (in[i + 2] & 0xC0) >> 6;
                    out.append(CODES.charAt(b));
                    b = in[i + 2] & 0x3F;
                    out.append(CODES.charAt(b));
                } else  {
                    out.append(CODES.charAt(b));
                    out.append('=');
                }
            } else      {
                out.append(CODES.charAt(b));
                out.append("==");
            }
        }

        return out.toString();
    }

    
    private byte[] read(File file) throws IOException {
	    ByteArrayOutputStream ous = null;
	    InputStream ios = null;
	    try {
	        byte[] buffer = new byte[4096];
	        ous = new ByteArrayOutputStream();
	        ios = new FileInputStream(file);
	        int read = 0;
	        while ((read = ios.read(buffer)) != -1) {
	            ous.write(buffer, 0, read);
	        }
	    }finally {
			try {
				if (ous != null)
					ous.close();
			} catch (IOException e) {
			}
			try {
				if (ios != null)
					ios.close();
			} catch (IOException e) {
			}
	    }
	    return ous.toByteArray();
	}
    
}

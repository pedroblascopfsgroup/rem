package es.pfsgroup.plugin.gestorDocumental.controller;

import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalApi;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalExpedientesApi;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.BajaDocumentoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CabeceraPeticionRestClientDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.DocumentosExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.RecoveryToGestorDocAssembler;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearGastoDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDescargarDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDocumentosExpedientes;
import es.pfsgroup.plugin.gestorDocumental.model.servicios.RespuestaCrearExpediente;

@Controller
@RequestMapping("/gdtest")
public class GestorDocumentalTestController {
	
	@Resource
	private Properties appProperties;	
	
	@Autowired
	private GestorDocumentalExpedientesApi gestorDocumentalExpedientesApi;
	
	@Autowired
	private GestorDocumentalApi gestorDocumentalApi;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView crearGasto(CrearGastoDto crearGastoDto, ModelMap model) {
		
		try {
			
			RespuestaCrearExpediente respuesta = gestorDocumentalExpedientesApi.crearGasto(crearGastoDto);
			
			model.put("Respuesta", respuesta);
			
		} catch (GestorDocumentalException e) {
			model.put("Exception", e);
		}
		
		return new ModelAndView("jsonView", model);

	}		
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView documentosExpediente(CabeceraPeticionRestClientDto cabecera, ModelMap model) {
		
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto();
		
		try {
		
			RespuestaDocumentosExpedientes respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);
			
			model.put("Respuesta", respuesta);
		
		} catch (GestorDocumentalException e) {
			model.put("Exception", e);
		}
	
		return new ModelAndView("jsonView", model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView descargarDocumento(Long idDocumento, ModelMap model) {
		
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		BajaDocumentoDto descargaDocumentoDto = recoveryToGestorDocAssembler.getDescargaDocumentoDto();
		
		try {
			RespuestaDescargarDocumento respuesta = null;
			
			respuesta = gestorDocumentalApi.descargarDocumento(idDocumento, descargaDocumentoDto);		
			
			model.put("Respuesta", respuesta);
		
		} catch (GestorDocumentalException e) {
			model.put("Exception", e);
		}
	
		return new ModelAndView("jsonView", model);
		
	}


}

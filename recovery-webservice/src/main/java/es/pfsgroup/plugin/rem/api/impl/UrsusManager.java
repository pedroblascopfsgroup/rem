package es.pfsgroup.plugin.rem.api.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.UrsusApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.model.ClienteUrsus;
import es.pfsgroup.plugin.rem.model.DtoClienteUrsus;
import es.pfsgroup.plugin.rem.model.dd.DDTiposDocumentos;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteDto;
import es.pfsgroup.plugin.rem.rest.dto.UrsusDto;
import net.sf.json.JSONObject;

@Service("ursusManager")
public class UrsusManager implements UrsusApi{
	
	private final Log logger = LogFactory.getLog(getClass());
	
	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	@Autowired
	private UvemManagerApi uvemManagerApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	private DtoClienteUrsus getDtoClienteUrsus(String tipoDocumento, String numDocumento) throws Exception {
		DtoClienteUrsus compradorUrsus = new DtoClienteUrsus();
		String tipoDoc = null;
		if (!Checks.esNulo(tipoDocumento)) {
			if (DDTiposDocumentos.DNI.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.DNI;
			if (DDTiposDocumentos.CIF.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.CIF;
			if (DDTiposDocumentos.NIF.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.DNI;
			if (DDTiposDocumentos.TARJETA_RESIDENTE.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.TARJETA_RESIDENTE;
			if (DDTiposDocumentos.PASAPORTE.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.PASAPORTE;
			if (DDTiposDocumentos.CIF_EXTRANJERO.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.CIF_EXTRANJERO;
			if (DDTiposDocumentos.DNI_EXTRANJERO.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.DNI_EXTRANJERO;
			if (DDTiposDocumentos.TARJETA_DIPLOMATICA.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.TARJETA_DIPLOMATICA;
			if (DDTiposDocumentos.MENOR.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.MENOR;
			if (DDTiposDocumentos.OTROS_PERSONA_FISICA.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.OTROS_PERSONA_FISICA;
			if (DDTiposDocumentos.OTROS_PESONA_JURIDICA.equals(tipoDocumento))
				tipoDoc = DtoClienteUrsus.OTROS_PESONA_JURIDICA;
		}
		if (numDocumento != null) {
			compradorUrsus.setNumDocumento(numDocumento);
		}

		compradorUrsus.setTipoDocumento(tipoDoc);
		
		return compradorUrsus;
	}

	@Override
	@Transactional(readOnly = false)
	public ArrayList<Map<String, Object>> saveOrUpdateNumerosUrsus(List<UrsusDto> clientes, JSONObject jsonFields)
			throws Exception {
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		Map<String, Object> map = null;

		for (UrsusDto cliente : clientes) {
			map = new HashMap<String, Object>();
			DtoClienteUrsus compradorUrsus = getDtoClienteUrsus(cliente.getTipoDocumentoCodigo(), cliente.getNumeroDocumento());
			
			List<DatosClienteDto> dtoDatosCliente = new ArrayList<DatosClienteDto>();
			List<DatosClienteDto> clientesBankia;
			List<String> idsUrsus = null;
			try {
				
				map.put("tipoDocumento", compradorUrsus.getTipoDocumento());
				map.put("numDocumento", compradorUrsus.getNumDocumento());
				
				//Bankia
				compradorUrsus.setQcenre(DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA);
				dtoDatosCliente = new ArrayList<DatosClienteDto>();
				idsUrsus = new ArrayList<String>();
				clientesBankia = uvemManagerApi.ejecutarNumCliente(compradorUrsus.getNumDocumento(), 
						compradorUrsus.getTipoDocumento(), compradorUrsus.getQcenre());
				if(clientesBankia != null && !clientesBankia.isEmpty()) {
					for(DatosClienteDto dto : clientesBankia) {	
						if (dto.getNumeroClienteUrsus() != null	&& !dto.getNumeroClienteUrsus().isEmpty()) {
							DatosClienteDto datos = new DatosClienteDto();
							datos = uvemManagerApi.ejecutarDatosCliente(Integer.valueOf(dto.getNumeroClienteUrsus()), compradorUrsus.getQcenre());
							dtoDatosCliente.add(datos);
						}
					}
					
					for(DatosClienteDto dto : dtoDatosCliente) {
						ClienteUrsus ursus = genericDao.get(ClienteUrsus.class, 
								genericDao.createFilter(FilterType.EQUALS, "ClaseDeDocumentoIdentificador", dto.getClaseDeDocumentoIdentificador()),
								genericDao.createFilter(FilterType.EQUALS, "DniNifDelTitularDeLaOferta", dto.getDniNifDelTitularDeLaOferta()),
								genericDao.createFilter(FilterType.EQUALS, "numeroClienteUrsus", dto.getNumeroClienteUrsus()));
						if(ursus != null) {
							beanUtilNotNull.copyProperties(ursus, dto);
							genericDao.update(ClienteUrsus.class, ursus);
						}else {
							ursus = new ClienteUrsus();							
							beanUtilNotNull.copyProperties(ursus, dto);
							genericDao.save(ClienteUrsus.class, ursus);
						}
						idsUrsus.add(dto.getNumeroClienteUrsus());
					}					
					map.put("idsUrsus", idsUrsus);
				}
				
				//Bankia Habitat
				compradorUrsus.setQcenre(DtoClienteUrsus.ENTIDAD_REPRESENTADA_BANKIA_HABITAT);
				dtoDatosCliente = new ArrayList<DatosClienteDto>();
				idsUrsus = new ArrayList<String>();
				clientesBankia = uvemManagerApi.ejecutarNumCliente(compradorUrsus.getNumDocumento(), 
						compradorUrsus.getTipoDocumento(), compradorUrsus.getQcenre());
				if(clientesBankia != null && !clientesBankia.isEmpty()) {
					for(DatosClienteDto dto : clientesBankia) {	
						if (dto.getNumeroClienteUrsus() != null	&& !dto.getNumeroClienteUrsus().isEmpty()) {
							DatosClienteDto datos = new DatosClienteDto();
							datos = uvemManagerApi.ejecutarDatosCliente(Integer.valueOf(dto.getNumeroClienteUrsus()), compradorUrsus.getQcenre());
							dtoDatosCliente.add(datos);
						}
					}
					
					for(DatosClienteDto dto : dtoDatosCliente) {
						ClienteUrsus ursus = genericDao.get(ClienteUrsus.class, 
								genericDao.createFilter(FilterType.EQUALS, "ClaseDeDocumentoIdentificador", dto.getClaseDeDocumentoIdentificador()),
								genericDao.createFilter(FilterType.EQUALS, "DniNifDelTitularDeLaOferta", dto.getDniNifDelTitularDeLaOferta()),
								genericDao.createFilter(FilterType.EQUALS, "numeroClienteUrsusBh", dto.getNumeroClienteUrsus()));
						if(ursus != null) {
							beanUtilNotNull.copyProperties(ursus, dto);
							genericDao.update(ClienteUrsus.class, ursus);
						}else {
							ursus = new ClienteUrsus();			
							beanUtilNotNull.copyProperties(ursus, dto);
							ursus.setNumeroClienteUrsusBh(dto.getNumeroClienteUrsus());
							genericDao.save(ClienteUrsus.class, ursus);
						}
						idsUrsus.add(dto.getNumeroClienteUrsus());
					}
					map.put("idsUrsusBh", idsUrsus);
				}
				
			} catch (JsonViewerException e) {
				map.put("success", false);
				logger.error("error en expedienteComercialManager", e);
				throw e;

			} catch (Exception e) {
				map.put("success", false);
				logger.error("error en expedienteComercialManager", e);
				throw e;
			}
			
			map.put("success", true);
			listaRespuesta.add(map);
		}
		return listaRespuesta;
	}

}

package es.capgemini.pfs.direccion;

import java.util.Collection;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.capgemini.pfs.direccion.api.DireccionApi;
import es.capgemini.pfs.direccion.dao.DireccionDao;
import es.capgemini.pfs.direccion.dao.DireccionPersonaDao;
import es.capgemini.pfs.direccion.dto.DireccionAltaDto;
import es.capgemini.pfs.direccion.model.DireccionPersona;
import es.capgemini.pfs.direccion.model.DireccionPersonaId;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;


@Component
public class DireccionManager implements DireccionApi {

	private static final String RESULTADO_OK = "OK";

	private static final String RESULTADO_KO = "KO";
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private DireccionDao direccionDao;
	
	@Autowired
	private DireccionPersonaDao direccionPersonaDao;

	@BusinessOperation(DireccionApi.GET_LIST_LOCALIDADES)
	public List<Localidad> getListLocalidades(Long idProvincia) {
		Order orderDescripcion = new Order(OrderType.ASC, "descripcion");
		return genericDao.getListOrdered(Localidad.class, orderDescripcion,
				genericDao.createFilter(FilterType.EQUALS, "provincia.id",
						idProvincia));
	}

	@BusinessOperation(DireccionApi.GET_LIST_TIPOS_VIA)
	public List<DDTipoVia> getListTiposVia() {
		Order orderDescripcion = new Order(OrderType.ASC, "descripcion");
		return genericDao.getListOrdered(DDTipoVia.class, orderDescripcion);
	}

	@Override
	@BusinessOperation(GET_LIST_PERSONAS)
	public Collection<? extends Persona> getPersonas(String query, Long idAsunto) {
		return direccionDao.getPersonas(query, idAsunto);
	}

	@Override
	@BusinessOperation(GUARDAR_DIRECCION)
	@Transactional(readOnly = false)
	public String guardarDireccion(DireccionAltaDto dto) {
		boolean hayError=false;
		
		try{
			guardarDireccionRetornaId(dto);
		}catch(Exception e){
			hayError=true;
			e.printStackTrace();
		}
		
		if (hayError) {
			return RESULTADO_KO;
		} else {
			return RESULTADO_OK;
		}
	}

	@Override
	@BusinessOperation(GUARDAR_DIRECCION_RETORNA_ID)
	@Transactional(readOnly = false)
	public Long guardarDireccionRetornaId(DireccionAltaDto dto) throws Exception {
		Direccion dir = new Direccion();
		if (!Checks.esNulo(dto.getProvincia())) {
			DDProvincia provincia = genericDao.get(
					DDProvincia.class,
					genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dto.getProvincia())));
			if (provincia != null) {
				dir.setProvincia(provincia);
				dir.setNomProvincia(provincia.getDescripcion());
			}
		}
		
		dir.setCodigoPostalInternacional(dto.getCodigoPostal());
		try {
			Integer codigoPostal = Integer.parseInt(dto.getCodigoPostal());
			dir.setCodigoPostal(codigoPostal);
		} catch (NumberFormatException e) {}
		
		Localidad localidad = genericDao.get(Localidad.class,
				genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dto.getLocalidad())));
		if (localidad != null) {
			dir.setLocalidad(localidad);
			dir.setNomPoblacion(localidad.getDescripcion());
		}
		dir.setMunicipio(dto.getMunicipio());
		
		Long idTipoVia = -1L;
		try {
			idTipoVia = Long.parseLong(dto.getTipoVia());
		} catch (NumberFormatException e1) {}
		DDTipoVia tipoVia = genericDao.get(DDTipoVia.class,
				genericDao.createFilter(FilterType.EQUALS, "id", idTipoVia));
		if (tipoVia != null) {
			dir.setTipoVia(tipoVia);
		}
		
		dir.setDomicilio(dto.getDomicilio());
		
		dir.setDomicilio_n(dto.getNumero());
		dir.setPortal(dto.getPortal());
		dir.setPiso(dto.getPiso());
		dir.setEscalera(dto.getEscalera());
		dir.setPuerta(dto.getPuerta());
		
		dir.setOrigen(dto.getOrigen());
		
		Long idDireccion = direccionDao.getNextIdDireccion();
		dir.setId(idDireccion);
				
		String codDireccion = direccionDao.getNextCodDireccionManual().toString();
		dir.setCodDireccion(codDireccion);
		
		direccionDao.saveOrUpdate(dir);
		
		
		for (Long idPersona : dto.getSetIdPersonas()) {
			DireccionPersona dirPers = new DireccionPersona();
			DireccionPersonaId dirPersId = new DireccionPersonaId(idDireccion, idPersona);
			dirPers.setId(dirPersId);
		
			direccionPersonaDao.saveOrUpdate(dirPers);
		}
		return idDireccion;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void actualizarDireccion(DireccionAltaDto dto, Long idDireccion) {
		Direccion dir = new Direccion();
		Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "id", idDireccion);
		List<Direccion> listaDirecciones=(List<Direccion>) genericDao.getList(Direccion.class,filtro1);
		dir=listaDirecciones.get(0);
		if (!Checks.esNulo(dto.getProvincia())) {
			DDProvincia provincia = genericDao.get(
					DDProvincia.class,
					genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dto.getProvincia())));
			if (provincia != null) {
				dir.setProvincia(provincia);
				dir.setNomProvincia(provincia.getDescripcion());
			}
		}
			
		dir.setCodigoPostalInternacional(dto.getCodigoPostal());
		try {
			Integer codigoPostal = Integer.parseInt(dto.getCodigoPostal());
			dir.setCodigoPostal(codigoPostal);
		} catch (NumberFormatException e) {}
			
		Localidad localidad = genericDao.get(Localidad.class,
				genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dto.getLocalidad())));
		if (localidad != null) {
			dir.setLocalidad(localidad);
			dir.setNomPoblacion(localidad.getDescripcion());
		}
		dir.setMunicipio(dto.getMunicipio());
			
		Long idTipoVia = -1L;
		try {
			idTipoVia = Long.parseLong(dto.getTipoVia());
		} catch (NumberFormatException e1) {}
		DDTipoVia tipoVia = genericDao.get(DDTipoVia.class,
				genericDao.createFilter(FilterType.EQUALS, "id", idTipoVia));
		if (tipoVia != null) {
			dir.setTipoVia(tipoVia);
		}	
			
		dir.setDomicilio(dto.getDomicilio());
			
		dir.setDomicilio_n(dto.getNumero());
		dir.setPortal(dto.getPortal());
		dir.setPiso(dto.getPiso());
		dir.setEscalera(dto.getEscalera());
		dir.setPuerta(dto.getPuerta());
			
		direccionDao.saveOrUpdate(dir);
	}


}

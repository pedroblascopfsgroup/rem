package es.capgemini.pfs.telefonos;

import java.util.ArrayList;
import java.util.List;





//import org.apache.commons.logging.Log;
//import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.core.api.persona.PersonaApi;
import es.capgemini.pfs.core.api.telefono.api.TelefonosApi;
import es.capgemini.pfs.persona.model.DDOrigenTelefono;
import es.capgemini.pfs.persona.model.DDTipoTelefono;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.telefonos.dao.TelefonosDao;
import es.capgemini.pfs.telefonos.dto.AltaTelefonoDto;
import es.capgemini.pfs.telefonos.model.DDEstadoTelefono;
import es.capgemini.pfs.telefonos.model.DDMotivoTelefono;
import es.capgemini.pfs.persona.model.PersonasTelefono;
import es.capgemini.pfs.telefonos.model.Telefono;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;

@Component
public class TelefonosManager implements TelefonosApi {
//	private final Log logger = LogFactory.getLog(getClass());
	 
	@Autowired
	protected GenericABMDao genericDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private TelefonosDao telefonosDao;
	
	@Override
	@BusinessOperation(BO_COREEXTENSION_TELEFONOS_GET_TELEFONOSCLIENTE)
	public List<Telefono> getTelefonosCliente(Long idCliente) {
		List<Telefono> telefonos = new ArrayList<Telefono>();
		Filter f = genericDao.createFilter(FilterType.EQUALS, "persona.codClienteEntidad", idCliente);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "persona.auditoria.borrado", false);
		Filter f3 = genericDao.createFilter(FilterType.EQUALS, "telefono.auditoria.borrado", false);
		Order order = new Order(OrderType.ASC, "telefono.prioridad");
		List<PersonasTelefono> personasTelefono = genericDao.getListOrdered(PersonasTelefono.class, order, f,f2,f3);
		
		for (PersonasTelefono pt : personasTelefono){
			telefonos.add(pt.getTelefono());
		}
		
		return telefonos;
	}
	
	@Override
	@BusinessOperation(BO_COREEXTENSION_TELEFONOS_GET_ORIGENESTELEFONO)
	public List<DDOrigenTelefono> getOrigenesTelefono() {
		return genericDao.getList(DDOrigenTelefono.class);
	}
	
	@Override
	@BusinessOperation(BO_COREEXTENSION_TELEFONOS_GET_TIPOSTELEFONO)
	public List<DDTipoTelefono> getTiposTelefono() {
		return genericDao.getList(DDTipoTelefono.class);
	}
	
	@Override
	@BusinessOperation(BO_COREEXTENSION_TELEFONOS_GET_MOTIVOSTELEFONO)
	public List<DDMotivoTelefono> getMotivosTelefono() {
		return genericDao.getList(DDMotivoTelefono.class);
	}
	
	@Override
	@BusinessOperation(BO_COREEXTENSION_TELEFONOS_GET_ESTADOSTELEFONO)
	public List<DDEstadoTelefono> getEstadosTelefono() {
		return genericDao.getList(DDEstadoTelefono.class);
	}

	@Override
	@BusinessOperation(BO_COREEXTENSION_TELEFONOS_GUARDATELEFONO)
	@Transactional(readOnly=false)
	public void guardaTelefonoCliente(AltaTelefonoDto dto) {
		int prioridadAnt = -1;
		Telefono telefono = null;
		PersonasTelefono personaTelefono = null ;
		Persona persona = proxyFactory.proxy(PersonaApi.class).getPersonaByCodClienteEntidad(dto.getIdCliente()); 
		if (!Checks.esNulo(dto.getIdTelefono())){
			telefono = this.get(dto.getIdTelefono());
			personaTelefono = this.buscaPersonaTelefono (dto.getIdTelefono(), dto.getIdCliente());
			prioridadAnt = telefono.getPrioridad();
		} else {
			telefono = new Telefono();
		}
		
		telefono.setTelefono(dto.getNumero());
		telefono.setConsentimiento(dto.getConsentimiento());
		telefono.setTipoTelefono(this.getTipoTelefonoByCodigo(dto.getTipo()));
		telefono.setMotivoTelefono(this.getMotivoTelefonoByCodigo(dto.getMotivo()));
		telefono.setEstadoTelefono(this.getEstadoTelefonoByCodigo (dto.getEstado()));
		telefono.setOrigenTelefono(this.getOrigenTelefonoByCodigo(dto.getOrigen()));
		telefono.setObservaciones(dto.getObservaciones());
		telefono.setPrioridad(dto.getPrioridad());
		
		telefono = genericDao.save(Telefono.class, telefono);
		
		if (Checks.esNulo(personaTelefono)){
			personaTelefono = new PersonasTelefono();
			personaTelefono.setTelefono(telefono);
			personaTelefono.setPersona(persona);
			genericDao.save(PersonasTelefono.class, personaTelefono);
		}
		
		telefonosDao.reorganizaPrioridades(dto.getIdCliente(), telefono.getId(), dto.getPrioridad(), prioridadAnt);
		
	}

	
	private DDOrigenTelefono getOrigenTelefonoByCodigo(String origen) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", origen);
		return genericDao.get(DDOrigenTelefono.class, filtro);
	}

	private DDEstadoTelefono getEstadoTelefonoByCodigo(String estado) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", estado);
		return genericDao.get(DDEstadoTelefono.class, filtro);
	}

	private DDMotivoTelefono getMotivoTelefonoByCodigo(String motivo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", motivo);
		return genericDao.get(DDMotivoTelefono.class, filtro);
	}

	private DDTipoTelefono getTipoTelefonoByCodigo(String tipo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", tipo);
		return genericDao.get(DDTipoTelefono.class, filtro);
	}

	@Override
	@BusinessOperation(BO_COREEXTENSION_TELEFONOS_GETBYID)
	public Telefono get(Long idTelefono) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idTelefono);
		
		Telefono telefono = genericDao.get(Telefono.class, filtro);
		
		return telefono;
	}

	@Override
	@BusinessOperation(BO_COREEXTENSION_BUSCA_PERSONA_TELEFONO)
	public PersonasTelefono buscaPersonaTelefono(Long idTelefono ,Long codClienteEntidad) {
		PersonasTelefono personaTelefono= null;
		Filter filtroTelefono = genericDao.createFilter(FilterType.EQUALS, "telefono.id", idTelefono);
		Filter filtroPersona = genericDao.createFilter(FilterType.EQUALS, "persona.codClienteEntidad", codClienteEntidad);
		personaTelefono = genericDao.get(PersonasTelefono.class, filtroTelefono,filtroPersona);
		
		return personaTelefono;
	}

	@Override
	@BusinessOperation(BO_COREEXTENSION_BORRA_TELEFONO)
	@Transactional(readOnly=false)
	public void borraTelefono(Long idCliente, Long idTelefono) {
		Telefono telefono = telefonosDao.get(idTelefono);
		int prioridadAnt = telefono.getPrioridad();
		telefono.setPrioridad(-1); /*Le ponermos prioridad negativa para que no mareen*/
		telefonosDao.saveOrUpdate(telefono);
		telefonosDao.deleteById(idTelefono);
		
		PersonasTelefono personaTelefono = buscaPersonaTelefono(idTelefono, idCliente);
		if (!Checks.esNulo(personaTelefono)) {
			genericDao.deleteById(PersonasTelefono.class, personaTelefono.getId());
		}
		/*Al eliminar el tel�fono se tienen que reorganizar las prioridades para ocupar el hueco que ha dejado lilbre
		 *para eso, utilizamos el m�todo de reorganizar y le indicamos como si movieramos ese telefono al final del todo*/
		int prioridad = telefonosDao.getMaxPrioridad(idCliente)+1;
		telefonosDao.reorganizaPrioridades(idCliente, idTelefono, prioridad, prioridadAnt);
		
	}
}

package es.pfsgroup.plugin.rem.rest.api.impl;

import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;
import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;
import javax.validation.ValidatorFactory;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dao.BrokerDao;
import es.pfsgroup.plugin.rem.rest.dao.PeticionDao;
import es.pfsgroup.plugin.rem.rest.model.Broker;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;
import es.pfsgroup.plugin.rem.utils.WebcomSignatureUtils;

@Service("restManager")
public class RestManagerImpl implements RestApi {

	@Autowired
	BrokerDao brokerDao;

	@Autowired
	PeticionDao peticionDao;

	@Resource
	private Properties appProperties;

	@Override
	public boolean validateSignature(Broker broker, String signature, String peticion)
			throws NoSuchAlgorithmException, UnsupportedEncodingException {
		boolean resultado = false;
		if (broker == null || signature == null || signature.isEmpty() || peticion == null) {
			resultado = false;
		} else {
			String firma = WebcomSignatureUtils.computeSignatue(broker.getKey(), broker.getIp(), peticion);

			if (firma.equals(signature) || broker.getValidarFirma().equals(new Long(0))) {
				resultado = true;
			}
		}
		return resultado;
	}

	@Override
	public boolean validateId(Broker broker, String id) {
		boolean resultado = false;
		if (id == null || id.isEmpty() || broker == null) {
			resultado = false;
		} else {
			if (broker.getValidarToken().equals(new Long(1))) {
				if (peticionDao.existePeticionToken(id, broker.getBrokerId())) {
					resultado = false;
				} else {
					resultado = true;
				}
			} else {
				resultado = true;
			}
		}
		return resultado;
	}

	@Override
	public Broker getBrokerByIp(String ip) {
		Broker broker = brokerDao.getBrokerByIp(ip);
		return broker;
	}

	@Override
	public Broker getBrokerDefault(String queryString) {
		String DEFAULT_KEY = !Checks.esNulo(appProperties.getProperty("rest.server.rem.api.key"))
				? appProperties.getProperty("rest.server.rem.api.key") : "";
		Broker broker = new Broker();
		broker.setBrokerId(new Long(-1));
		broker.setValidarFirma(new Long(1));
		broker.setValidarToken(new Long(1));
		broker.setKey(DEFAULT_KEY);
		return broker;
	}

	@Override
	public void guardarPeticionRest(PeticionRest peticion) {
		peticionDao.saveOrUpdate(peticion);
	}

	@Override
	public List<String> validateRequestObject(Serializable obj) {
		return validateRequestObject(obj, null);
	}
	
	@SuppressWarnings("rawtypes")
	@Override
	public List<String> validateRequestObject(Serializable obj, Class dto) {
		ArrayList<String> error = new ArrayList<String>();
		ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
		Validator validator = factory.getValidator();
		Set<ConstraintViolation<Serializable>> constraintViolations = null;
		if(dto != null){
			constraintViolations = validator.validate(obj,dto);
		}else{
			constraintViolations = validator.validate(obj);
		}
		if (!constraintViolations.isEmpty()) {
			for (ConstraintViolation<Serializable> visitaFailure : constraintViolations) {
				error.add((visitaFailure.getPropertyPath() + " " + visitaFailure.getMessage()));

			}
		}
		return error;
	}

	@Override
	public PeticionRest getPeticionById(Long id) {
		return peticionDao.get(id);
	}

	@Override
	public PeticionRest getLastPeticionByToken(String token) {
		return peticionDao.getLastPeticionByToken(token);
	}

}

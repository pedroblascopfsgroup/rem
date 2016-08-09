package es.pfsgroup.plugin.rem.rest.impl;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.rem.rest.api.RestManager;
import es.pfsgroup.plugin.rem.rest.dao.BrokerDao;
import es.pfsgroup.plugin.rem.rest.dao.PeticionDao;
import es.pfsgroup.plugin.rem.rest.model.Broker;
import es.pfsgroup.plugin.rem.rest.model.PeticionRest;

@Service("restManager")
public class RestManagerImpl implements RestManager {

	@Autowired
	BrokerDao brokerDao;

	@Autowired
	PeticionDao peticionDao;

	@Override
	public boolean validateSignature(Broker broker, String signature, String peticion)
			throws NoSuchAlgorithmException, UnsupportedEncodingException {
		boolean resultado = false;
		if (broker == null || signature == null || signature.isEmpty() || peticion == null) {
			resultado = false;
		} else {
			String firma = (broker.getKey().concat(broker.getIp()).concat(peticion)).toLowerCase();
			byte[] bytesOfMessage = firma.getBytes("UTF-8");

			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(bytesOfMessage);
			byte[] thedigest = md.digest();
			StringBuffer hexString = new StringBuffer();
			for (int i = 0; i < thedigest.length; i++) {
				if ((0xff & thedigest[i]) < 0x10) {
					hexString.append("0" + Integer.toHexString((0xFF & thedigest[i])));
				} else {
					hexString.append(Integer.toHexString(0xFF & thedigest[i]));
				}
			}
			firma = hexString.toString();

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
	public void guardarPeticionRest(PeticionRest peticion) {
		peticionDao.saveOrUpdate(peticion);
	}

}

package es.pfsgroup.plugin.rem.restclient.schedule;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;

import es.capgemini.devon.utils.ApplicationContextUtil;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.CambioBD;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.RegistroCambiosBD;
import es.pfsgroup.plugin.rem.restclient.utils.Converter;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

public class DeteccionCambiosBDTask implements ApplicationListener {
	
	private static final Long ID_USUARIO_LOGADO = -1L;

	private final Log logger = LogFactory.getLog(getClass());

	private RegistroCambiosBD registroCambios;

	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	public void detectaCambios() {

		if (registroCambios != null) {
			List<CambioBD> cambios = registroCambios.listPendientes();

			List<StockDto> stock = new ArrayList<StockDto>();

			if (cambios != null) {
				for (CambioBD cambio : cambios) {
					StockDto dto = new StockDto();
					Converter.updateObjectFromHashMap(cambio.getCambios(), dto, null);
					stock.add(dto);
				}
			}

			serviciosWebcom.enviarStock(ID_USUARIO_LOGADO, stock);
		} else {
			logger.warn("El registro de cambios en BD aún no está disponible");
		}

	}

	@Override
	public void onApplicationEvent(ApplicationEvent event) {
		if (registroCambios == null) {
			if (event instanceof ContextRefreshedEvent) {
				ApplicationContext applicationContext = ((ContextRefreshedEvent) event).getApplicationContext();
				String[] beanNames = applicationContext.getBeanNamesForType(RegistroCambiosBD.class);
				if ((beanNames != null) && (beanNames.length >= 1)) {
					registroCambios = (RegistroCambiosBD) applicationContext.getBean(beanNames[0]);
				}

			}
		}

	}

}

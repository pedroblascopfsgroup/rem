package es.pfsgroup.plugin.rem.factory.observaciones;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class GridObservacionesFactory {
	
	@Autowired
	private List<GridObservacionesApi> observacionesList;

	public GridObservacionesApi getGridObservacionByCode(String code) {
		
		for (GridObservacionesApi grid : observacionesList) {
			if ( grid.getCode().equals(code)) {
				return grid;
			}
		}
		return null;
	}
}

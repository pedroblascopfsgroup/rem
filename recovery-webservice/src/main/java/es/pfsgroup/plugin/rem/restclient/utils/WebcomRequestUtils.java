package es.pfsgroup.plugin.rem.restclient.utils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Random;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.NullDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.WebcomDataType;
import es.pfsgroup.plugin.rem.restclient.webcom.ParamsList;
import net.sf.json.JSONArray;
import net.sf.json.JSONNull;
import net.sf.json.JSONObject;

public class WebcomRequestUtils {

	public static JSONObject createRequestJson(ParamsList paramsList) {
		JSONArray dataArray = new JSONArray();

		for (Map<String, Object> params : paramsList) {
			JSONObject data = createJSONData(toStringParameters(params));
			dataArray.add(data);
		}

		JSONObject json = new JSONObject();
		json.put("id", computeRequestId());
		json.put("data", dataArray);
		return json;
	}

	private static JSONObject createJSONData(Map<String, String> stringParameters) {
		JSONObject data = new JSONObject();
		if (stringParameters != null){
			for (Entry<String, String> e : stringParameters.entrySet()){
				if (e.getValue() != null){
					data.put(e.getKey(), e.getValue());
				}else{
					data.put(e.getKey(), JSONNull.getInstance());
				}
			}
		}
		return data;
	}

	private static Map<String, String> toStringParameters(Map<String, Object> params) {
		HashMap<String, String> strParams = new HashMap<String, String>();
		if ((params != null) && (!params.isEmpty())) {
			for (Entry<String, Object> p : params.entrySet()) {
				Object value = p.getValue();
				if (value != null) {
					if (value instanceof NullDataType) {
						strParams.put(p.getKey(), null);
					} else {
						strParams.put(p.getKey(), WebcomDataType.valueOf(value).toString());
					}
				}
			}
		}
		return strParams;
	}

	private static String computeRequestId() {
		long timestamp = ((Date) new Date()).getTime();
		int threadId = Math.abs(Thread.currentThread().getName().hashCode());
		int rnd = ((Random) new Random()).nextInt(100);
		return timestamp + "" + threadId + "" + rnd;
	}

	public static String formatDate(Date date) {
		SimpleDateFormat formaterDate = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat formaterTime = new SimpleDateFormat("hh:mm:ss");
		return formaterDate.format(date) + "T" + formaterTime.format(date);
	}

}

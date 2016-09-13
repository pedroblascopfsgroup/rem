package es.pfsgroup.plugin.rem.restclient.utils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Random;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class WebcomRequestUtils {

	public static JSONObject createRequestJson(Map<String, Object> params) {
		JSONObject data = new JSONObject();
		data.putAll(toStringParameters(params));
		JSONArray dataArray = new JSONArray();
		dataArray.add(data);

		JSONObject json = new JSONObject();
		json.put("id", computeRequestId());
		json.put("data", dataArray);
		return json;
	}

	private static Map<String, String> toStringParameters(Map<String, Object> params) {
		HashMap<String, String> strParams = new HashMap<String, String>();
		if ((params != null) && (!params.isEmpty())) {
			for (Entry<String, Object> p : params.entrySet()) {
				if (p.getValue() != null) {
					strParams.put(p.getKey(), p.getValue().toString());
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
		// return DateFormat.toString(date);
	}

}

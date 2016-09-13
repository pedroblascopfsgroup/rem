package es.pfsgroup.plugin.rem.restclient.utils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.Random;

import es.pfsgroup.commons.utils.DateFormat;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class WebcomRequestUtils {
	
	public static JSONObject createRequestJson(Map<String, String> params){
		JSONObject data = new JSONObject();
		data.putAll(params);
		JSONArray dataArray = new JSONArray();
		dataArray.add(data);

		JSONObject json = new JSONObject();
		json.put("id", computeRequestId());
		json.put("data", dataArray);
		return json;
	}

	private static String computeRequestId() {
		long timestamp = ((Date) new Date()).getTime();
		int threadId = Math.abs(Thread.currentThread().getName().hashCode());
		int rnd = ((Random) new Random()).nextInt(100);
		return timestamp + "" + threadId + "" + rnd;
	}

	public static String formatDate(Date date) {
		return DateFormat.toString(date);
	}

}

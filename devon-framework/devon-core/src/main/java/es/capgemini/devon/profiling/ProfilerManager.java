package es.capgemini.devon.profiling;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ArrayBlockingQueue;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.springframework.jmx.export.annotation.ManagedAttribute;
import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedResource;
import org.springframework.stereotype.Service;

import com.jamonapi.MonitorComposite;
import com.jamonapi.MonitorFactory;

import es.capgemini.devon.bo.FwkBusinessOperations;
import es.capgemini.devon.bo.annotations.BusinessOperation;

/**
 * TODO Documentar
 * 
 * @author Nicolás Cornaglia
 */
@Service
@ManagedResource("type=ProfileManager")
public class ProfilerManager {

    private static final String LOG_CAPACITY_KEY = "profiling.logCapacity";
    private static final String ENABLE_STATISTICS_KEY = "profiling.enableStatistics";
    private static final String ENABLE_LOG_KEY = "profiling.enableLog";

    public static String HEADER_KEY = "header";
    public static String DATA_KEY = "data";
    public static String LOG_DATA_KEY = "logData";

    protected boolean statisticsEnabled = false;
    protected boolean logEnabled = false;
    private int logHolderCapacity = 100;

    private ArrayBlockingQueue<ProfileData> logHolder;

    @Resource
    private Properties appProperties;

    @PostConstruct
    public void init() {
        statisticsEnabled = new Boolean(appProperties.getProperty(ENABLE_STATISTICS_KEY, "false")).booleanValue();
        logEnabled = new Boolean(appProperties.getProperty(ENABLE_LOG_KEY, "false")).booleanValue();
        logHolderCapacity = new Integer(appProperties.getProperty(LOG_CAPACITY_KEY, "100")).intValue();
        reset();
    }

    /**
     * @param rangeName
     */
    @ManagedOperation
    @BusinessOperation(FwkBusinessOperations.PROFILER_GET_STATISTICS)
    public Map<String, List<Object>> getStatistics(String rangeName) {
        MonitorComposite monitorComposite = MonitorFactory.getComposite(rangeName);
        Object[] headerArray = monitorComposite.getBasicHeader();
        Object[][] dataArray = monitorComposite.getBasicData();

        Map<String, List<Object>> result = new Hashtable<String, List<Object>>();
        result.put(HEADER_KEY, Arrays.asList(headerArray));

        List<Object> dataList = new ArrayList<Object>();
        for (Object[] rowArray : dataArray) {
            int col = 0;
            Map<String, Object> row = new Hashtable<String, Object>();
            for (Object data : rowArray) {
                row.put((String) headerArray[col++], data);
            }
            row.put("Label", ((String) row.get("Label")).replace(", ms.", ""));
            dataList.add(row);
        }
        result.put(DATA_KEY, dataList);

        //result.put(LOG_DATA_KEY, new ArrayList<Object>(logHolder));

        //        for (ProfileData profileData : logHolder) {
        //            System.out.println("[" + new Date(profileData.getStartTime()) + "] " + profileData.toString());
        //        }

        return result;
    }

    /**
     * @param profileData
     */
    public void addData(ProfileData profileData) {
        if (!logHolder.offer(profileData)) {
            synchronized (logHolder) {
                if (!logHolder.offer(profileData)) {
                    logHolder.poll();
                    logHolder.offer(profileData);
                }
            }
        }

    }

    public Map<String, List<Object>> getStatistics() {
        return getStatistics("AllMonitors");
    }

    @ManagedOperation
    @BusinessOperation(FwkBusinessOperations.PROFILER_RESET)
    public void reset() {
        MonitorFactory.reset();
        logHolder = new ArrayBlockingQueue<ProfileData>(logHolderCapacity);
    }

    @ManagedAttribute
    public void setStatisticsEnabled(boolean statisticsEnabled) {
        this.statisticsEnabled = statisticsEnabled;
    }

    @ManagedAttribute
    public boolean isStatisticsEnabled() {
        return statisticsEnabled;
    }

    @ManagedAttribute
    public void setLogEnabled(boolean logEnabled) {
        this.logEnabled = logEnabled;
    }

    @ManagedAttribute
    public boolean isLogEnabled() {
        return logEnabled;
    }

    @BusinessOperation(FwkBusinessOperations.PROFILER_CHANGE_STATISTICS_MODE)
    public void changeStatisticsMode() {
        setStatisticsEnabled(!isStatisticsEnabled());
    }

    public int getLogHolderCapacity() {
        return logHolderCapacity;
    }

    public void setLogHolderCapacity(int logHolderCapacity) {
        this.logHolderCapacity = logHolderCapacity;
    }
}

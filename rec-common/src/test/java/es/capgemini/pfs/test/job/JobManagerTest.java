package es.capgemini.pfs.test.job;

import junit.framework.Assert;

import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;

import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.pfs.job.JobInfo;
import es.capgemini.pfs.job.JobController;
import es.capgemini.pfs.job.policy.imp.JEPRunAlone;
import es.capgemini.pfs.job.policy.imp.JEPRunAloneEntity;
import es.capgemini.pfs.test.CommonTestAbstract;
import es.capgemini.pfs.test.job.bean.JobTWait;


public class JobManagerTest extends CommonTestAbstract{
    
    @Autowired
    private JobController jobManager;
    @Autowired
    private ApplicationContext appContext;
    
    @Before
    public void reset(){
        jobManager.setMaxProcessRunning(10);
        jobManager.setSleepTime(500);
        jobManager.setWaitAfterExecution(10);
        new ApplicationContextUtil().setApplicationContext(appContext);
    }
    
    @Test
    public void testBase(){
        jobManager.setMaxProcessRunning(0);
        
        jobManager.addJob("A", "A", new JobTWait());
        jobManager.addJob("B", "A", new JobTWait());
        jobManager.addJob("C", "A", new JobTWait());
        
        Assert.assertTrue(jobManager.getNumberOfProcessRunning()==0);
        Assert.assertTrue(jobManager.getNumberOfProcessWaiting()==3);
        
        jobManager.setMaxProcessRunning(3);
        sleep(jobManager.getSleepTime()+3000);
        Assert.assertTrue(jobManager.getNumberOfProcessRunning()==3);
        Assert.assertTrue(jobManager.getNumberOfProcessWaiting()==0);
        
        sleep(jobManager.getWaitAfterExecution()+12000);
        Assert.assertTrue(jobManager.getNumberOfProcessRunning()==0);
        Assert.assertTrue(jobManager.getNumberOfProcessWaiting()==0);
        
    }
    
    
    @Test
    public void testJEPRunAlone(){
        jobManager.setMaxProcessRunning(0);
       
        JobInfo jobA=new JobInfo("A", "A", new JobTWait());
        jobA.addExecutionPolicies(new JEPRunAlone());
                
        jobManager.addJob(jobA);
        jobManager.addJob("B", "A", new JobTWait());
        jobManager.addJob("C", "A", new JobTWait());
        
        Assert.assertTrue(jobManager.getNumberOfProcessRunning()==0);
        Assert.assertTrue(jobManager.getNumberOfProcessWaiting()==3);
        
        jobManager.setMaxProcessRunning(3);
        sleep(jobManager.getSleepTime()+3000);
        
        Assert.assertTrue(jobManager.getNumberOfProcessRunning()==1);
        Assert.assertTrue(jobManager.getNumberOfProcessWaiting()==2);
        
        sleep(jobManager.getWaitAfterExecution()+12000);
        Assert.assertTrue(jobManager.getNumberOfProcessRunning()==2);
        Assert.assertTrue(jobManager.getNumberOfProcessWaiting()==0);
        
        sleep(10000);
        
    }
    
    @Test
    public void testJEPRunAloneEntity(){
        jobManager.setMaxProcessRunning(0);
       
        JobInfo jobA=new JobInfo("A", "ENT_A", new JobTWait());
        jobA.addExecutionPolicies(new JEPRunAloneEntity());
                
        jobManager.addJob(jobA);
        try {Thread.sleep(10);} catch (InterruptedException e) {}
        jobManager.addJob("B", "ENT_A", new JobTWait());
        try {Thread.sleep(10);} catch (InterruptedException e) {}
        jobManager.addJob("C", "ENT_Z", new JobTWait());
        
        Assert.assertTrue(jobManager.getNumberOfProcessRunning()==0);
        Assert.assertTrue(jobManager.getNumberOfProcessWaiting()==3);
        
        jobManager.setMaxProcessRunning(3);
        sleep(jobManager.getSleepTime()+3000);
        
        Assert.assertTrue(jobManager.getNumberOfProcessRunning()==2);
        Assert.assertTrue(jobManager.getNumberOfProcessWaiting()==1);
        
        sleep(jobManager.getWaitAfterExecution()+12000);
        Assert.assertTrue(jobManager.getNumberOfProcessRunning()==1);
        Assert.assertTrue(jobManager.getNumberOfProcessWaiting()==0);
        
    }

}
